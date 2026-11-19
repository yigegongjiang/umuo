import AVFoundation
import os

/// 麦克风权限（TCC）。首次使用语音时才申请（PRD §7.4），不在启动或引导里弹。
enum MicrophoneAccess {
    enum Status: Equatable { case authorized, notDetermined, denied }

    static var status: Status {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized: .authorized
        case .notDetermined: .notDetermined
        default: .denied // denied、restricted（家长控制 / MDM）都当拒绝
        }
    }

    /// 已授权直接通过；没问过就弹系统授权框等用户选；拒绝过返回 false（系统不会再弹，要去系统设置里开）。
    static func ensure() async -> Bool {
        switch status {
        case .authorized: true
        case .denied: false
        case .notDetermined: await AVCaptureDevice.requestAccess(for: .audio)
        }
    }

    /// 系统设置「隐私与安全性 → 麦克风」。
    static let settingsURL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone")!
}

/// 正式的录音器：`AVAudioEngine` 的输入节点（系统当前的默认输入设备）→ 转成 16 kHz 单声道 Float32 → 追加写进临时文件。
///
/// - 设备：设置里选了麦克风（`inputDevice` 返回 UID）就用它，没选或它不在就跟随系统默认输入；
///   没有输入设备（格式采样率为 0）报 `noInputDevice`。
/// - 配置变更：蓝牙耳机一开麦就会从听歌切到通话模式，输入格式随之改变，引擎发通知并停下。
///   这时按新格式重新接上、继续写同一个文件；重新接不上（设备拔了、格式为 0）才按 `noInputDevice` 回报。
/// - 只在主线程上开关；采样在音频线程上转换并写盘（`Writer` 自己加锁）。
@MainActor
final class SystemVoiceRecorder: VoiceRecording {
    var onFailure: ((UInt64, VoiceFault) -> Void)?

    private struct Active {
        let session: UInt64
        let engine: AVAudioEngine
        let writer: Writer
        let observer: NSObjectProtocol
    }

    private var active: Active?
    /// 最近一次要求开麦的会话。`start` 要等授权框，期间可能已被丢弃或被新会话顶掉，回来后据此认出过期。
    private var latest: UInt64?
    /// 申请麦克风权限（测试换成自己控制何时放行的假授权，不弹系统对话框）。
    private let authorize: @MainActor () async -> Bool
    /// 设置里选的麦克风 UID，空串 = 系统默认。每次开麦现读，改了设置下一句就生效。
    private let inputDevice: @MainActor () -> String

    init(authorize: @escaping @MainActor () async -> Bool = { await MicrophoneAccess.ensure() },
         inputDevice: @escaping @MainActor () -> String = { "" }) {
        self.authorize = authorize
        self.inputDevice = inputDevice
    }

    func start(session: UInt64, output: FileHandle) async throws {
        latest = session
        let granted = await authorize()
        // 等授权的这段时间里这一会话被丢弃、或新会话已经开始：过期了直接返回，
        // 不报错也不往下走——往下走会 teardown 掉新会话正在录的音。状态机按迟到忽略这一次。
        guard latest == session else {
            try? output.close()
            return
        }
        // 详情只进日志（界面按错误类别显示文案）
        guard granted else { throw VoiceFault(kind: .micPermissionDenied, detail: "麦克风权限未授予") }
        if let active { teardown(active) }

        let engine = AVAudioEngine()
        let writer = Writer(output: output)
        let device = inputDevice()
        do {
            try Self.attach(engine, writer, device: device)
        } catch {
            writer.finish()
            throw error
        }
        let observer = NotificationCenter.default.addObserver(
            forName: .AVAudioEngineConfigurationChange, object: engine, queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self, let active = self.active, active.session == session else { return }
                engine.inputNode.removeTap(onBus: 0)
                engine.stop()
                do {
                    try Self.attach(engine, writer, device: device)
                } catch {
                    self.teardown(active)
                    self.onFailure?(session, error as? VoiceFault
                        ?? VoiceFault(kind: .noInputDevice, detail: "输入设备在录音中途发生变化：\(error)"))
                }
            }
        }
        active = Active(session: session, engine: engine, writer: writer, observer: observer)
    }

    /// 按输入节点当前的格式装 tap、换转换器、启动引擎。首次开麦与配置变更后重接共用。
    private static func attach(_ engine: AVAudioEngine, _ writer: Writer, device: String) throws {
        Microphones.select(device, on: engine)
        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)
        guard format.sampleRate > 0, format.channelCount > 0 else {
            throw VoiceFault(kind: .noInputDevice, detail: "没有可用的输入设备")
        }
        guard let converter = AVAudioConverter(from: format, to: Writer.target) else {
            throw VoiceFault(kind: .recording, detail: "无法把 \(format) 转成 16 kHz 单声道")
        }
        writer.use(converter)
        input.installTap(onBus: 0, bufferSize: 4096, format: format) { buffer, _ in writer.consume(buffer) }
        engine.prepare()
        do {
            try engine.start()
        } catch {
            input.removeTap(onBus: 0)
            throw VoiceFault(kind: .recording, detail: "音频引擎启动失败：\(error)")
        }
    }

    func stop(session: UInt64) async throws -> UInt64 {
        guard let active, active.session == session else {
            throw VoiceFault(kind: .recording, detail: "没有进行中的录音")
        }
        teardown(active)
        if let error = active.writer.error {
            throw VoiceFault(kind: .recording, detail: "写临时音频失败：\(error)")
        }
        return VoiceAudioFiles.durationMs(samples: active.writer.samples)
    }

    func discard(session: UInt64) {
        if latest == session { latest = nil }
        guard let active, active.session == session else { return }
        teardown(active)
    }

    /// 停麦、拆 tap、关文件。之后不会再有采样写进来。
    private func teardown(_ recording: Active) {
        NotificationCenter.default.removeObserver(recording.observer)
        recording.engine.inputNode.removeTap(onBus: 0)
        recording.engine.stop()
        recording.writer.finish()
        if active?.session == recording.session { active = nil }
    }

    /// 音频线程上的转换与写盘。
    private final class Writer: @unchecked Sendable {
        private let lock = NSLock()
        static let target = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: VoiceAudioFiles.sampleRate,
                                          channels: 1, interleaved: false)!
        private let output: FileHandle
        private var converter: AVAudioConverter?
        private let target = Writer.target
        private var closed = false
        private var written = 0
        private var failure: Error?

        var samples: Int { lock.withLock { written } }
        var error: Error? { lock.withLock { failure } }

        init(output: FileHandle) {
            self.output = output
        }

        /// 换上新格式的转换器（配置变更后输入格式可能不同）。
        func use(_ converter: AVAudioConverter) {
            lock.withLock { self.converter = converter }
        }

        func consume(_ buffer: AVAudioPCMBuffer) {
            lock.lock()
            defer { lock.unlock() }
            guard !closed, failure == nil, let converter, buffer.format == converter.inputFormat else { return }
            let ratio = target.sampleRate / buffer.format.sampleRate
            let capacity = AVAudioFrameCount((Double(buffer.frameLength) * ratio).rounded(.up)) + 32
            guard let converted = AVAudioPCMBuffer(pcmFormat: target, frameCapacity: capacity) else { return }
            var fed = false
            var conversionError: NSError?
            converter.convert(to: converted, error: &conversionError) { _, status in
                if fed {
                    status.pointee = .noDataNow
                    return nil
                }
                fed = true
                status.pointee = .haveData
                return buffer
            }
            if let conversionError { return failure = conversionError }
            guard let channel = converted.floatChannelData?[0], converted.frameLength > 0 else { return }
            do {
                try VoiceAudioFiles.append(UnsafeBufferPointer(start: channel, count: Int(converted.frameLength)),
                                           to: output)
                written += Int(converted.frameLength)
            } catch {
                failure = error
            }
        }

        func finish() {
            lock.lock()
            defer { lock.unlock() }
            guard !closed else { return }
            closed = true
            try? output.close()
        }
    }
}
