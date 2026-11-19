import AppKit
import Testing
import UmuoCore
@testable import Umuo

@Suite("umuo:// 外部链接")
@MainActor
struct ExternalURLTests {
    /// 没有任何 Key：流水线在读 Key 这一步就报缺 Key，不会向供应商发请求。
    final class NoKeyHost: HostBridge {
        func apiKey(providerId _: String) throws -> String? { nil }
        func frontmostAppName() -> String? { "Test" }
        func writeTargetToken() -> String? { nil }
        func writeBack(source _: FocusSource, original _: String, text _: String, target _: String?) throws {
            throw HostFailure.Failed(detail: "测试不写回")
        }
    }

    private func command(_ string: String) -> ExternalCommand? {
        URL(string: string).flatMap(ExternalCommand.init(url:))
    }

    private func urlEvent(_ string: String) -> NSAppleEventDescriptor {
        let event = NSAppleEventDescriptor(
            eventClass: AEEventClass(kInternetEventClass), eventID: AEEventID(kAEGetURL), targetDescriptor: nil,
            returnID: AEReturnID(kAutoGenerateReturnID), transactionID: AETransactionID(kAnyTransactionID)
        )
        event.setParam(NSAppleEventDescriptor(string: string), forKeyword: keyDirectObject)
        return event
    }

    @Test func 解码文本并去掉首尾空白() {
        #expect(command("umuo://translate?text=%20Hello%20world%0A") == .translate("Hello world"))
        #expect(command("umuo://translate?text=%E4%BD%A0%E5%A5%BD%26%3D") == .translate("你好&="))
        #expect(command("UMUO://Translate?text=hi") == .translate("hi"))
    }

    @Test func 不认识的动作与空文本一律忽略() {
        #expect(command("umuo://translate") == nil)
        #expect(command("umuo://translate?text=%20%0A") == nil)
        #expect(command("umuo://replace?text=hi") == nil)
        #expect(command("other://translate?text=hi") == nil)
    }

    @Test func 核验不出是PopClip的调用方_不进翻译流水线() {
        var received: [ExternalCommand] = []
        // 默认核验：没有发送方审计令牌（伪造或来源不明）即拒绝
        ExternalURLReceiver { received.append($0) }.receive(urlEvent("umuo://translate?text=hi"))
        #expect(received.isEmpty)
        #expect(!ExternalCaller.isPopClip(urlEvent("umuo://translate?text=hi")))

        ExternalURLReceiver(isTrusted: { _ in true }) { received.append($0) }.receive(urlEvent("umuo://translate?text=hi"))
        #expect(received == [.translate("hi")])
    }

    @Test func 内核还在启动时先暂存_打开后清空暂存() {
        let model = AppModel(arguments: [], bundleIdentifier: nil)
        model.handle(.translate("hello"))
        #expect(model.pendingExternalText == "hello")
        model.opened(nil, settingsJson: nil)
        #expect(model.pendingExternalText == nil)
    }

    @Test func 外部入口在Start前就记为等待_Esc与关闭取消的是这次请求() throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent("umuo-test-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: dir) }
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        try #"{"proxyMode":"none","providerId":"openai"}"#
            .write(to: dir.appendingPathComponent("settings.json"), atomically: true, encoding: .utf8)
        let engine = try Engine.open(configDir: dir.path, host: NoKeyHost())
        // `opened` 会设置应用外观，要先有 NSApp
        _ = NSApplication.shared
        let app = AppModel(arguments: [], bundleIdentifier: nil)
        app.opened(.success(engine), settingsJson: nil)
        let panel = PanelController(app: app)

        panel.startAwaitingStart(TranslateRequest(text: "This is a whole sentence here.", mode: .selection,
                                                  targetOverride: nil, sourceOverride: nil, focusSource: nil),
                                 engine: engine)
        // 等待 Start 期间 `PanelSession.escape` / `close` 按「还有请求在途」处理：取消请求，而不只是收起
        //（`PanelSessionTests` 的「Start之前按Esc也取消请求」）
        #expect(panel.session.pendingStart != nil)
        // 断开宿主：随后到达的缺 Key 错误只改 session，不建窗口，也不碰测试结束后释放的 AppModel
        panel.session.backend = nil
    }
}
