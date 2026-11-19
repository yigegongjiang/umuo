import Foundation
import Testing
@testable import Umuo

@Suite("umuo:// 外部链接")
@MainActor
struct ExternalURLTests {
    private func command(_ string: String) -> ExternalCommand? {
        URL(string: string).flatMap(ExternalCommand.init(url:))
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

    @Test func 内核还在启动时先存下_打开后交出() {
        let model = AppModel(arguments: [], bundleIdentifier: nil)
        model.handle(.translate("hello"))
        #expect(model.pendingExternalText == "hello")
        model.opened(nil, settingsJson: nil)
        #expect(model.pendingExternalText == nil)
    }
}
