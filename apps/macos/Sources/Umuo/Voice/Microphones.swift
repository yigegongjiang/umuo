import AVFoundation
import CoreAudio

/// 可选的麦克风，以及把录音引擎切到其中一个。设置里存的是 CoreAudio 设备 UID（`AVCaptureDevice.uniqueID` 同值）。
enum Microphones {
    struct Device: Equatable {
        let uid: String
        let name: String
    }

    /// 当前连着的音频输入设备。
    static func list() -> [Device] {
        AVCaptureDevice.DiscoverySession(deviceTypes: [.microphone, .external], mediaType: .audio, position: .unspecified)
            .devices.map { Device(uid: $0.uniqueID, name: $0.localizedName) }
    }

    /// 把引擎的输入切到 `uid` 对应的设备。空串或设备不在（耳机没连）时什么都不做，沿用系统默认输入。
    /// 要在读输入格式、装 tap 之前调。
    static func select(_ uid: String, on engine: AVAudioEngine) {
        guard !uid.isEmpty, var device = deviceID(uid: uid), let unit = engine.inputNode.audioUnit else { return }
        let status = AudioUnitSetProperty(unit, kAudioOutputUnitProperty_CurrentDevice, kAudioUnitScope_Global, 0,
                                          &device, UInt32(MemoryLayout<AudioDeviceID>.size))
        if status != noErr { print("umuo: 切换麦克风失败（\(status)），改用系统默认输入") }
    }

    private static func deviceID(uid: String) -> AudioDeviceID? {
        var address = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyTranslateUIDToDevice,
                                                 mScope: kAudioObjectPropertyScopeGlobal,
                                                 mElement: kAudioObjectPropertyElementMain)
        var cfUID = uid as CFString
        var device = AudioDeviceID(kAudioObjectUnknown)
        var size = UInt32(MemoryLayout<AudioDeviceID>.size)
        let status = withUnsafeMutablePointer(to: &cfUID) { qualifier in
            AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address,
                                       UInt32(MemoryLayout<CFString>.size), qualifier, &size, &device)
        }
        return status == noErr && device != kAudioObjectUnknown ? device : nil
    }
}
