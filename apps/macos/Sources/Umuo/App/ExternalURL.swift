import AppKit
import Security

/// `umuo://` 链接能做的事。目前只有 `umuo://translate?text=<文本>`（PopClip 扩展 `scripts/popclip/umuo.popclipext`）。
///
/// 只开放「把给定文本弹浮窗翻译」：不取词、不写回、不读剪贴板、不改设置。
enum ExternalCommand: Equatable {
    case translate(String)

    /// 不认识的动作、缺文本或文本只有空白时为 nil。
    init?(url: URL) {
        guard url.scheme?.lowercased() == "umuo",
              url.host?.lowercased() == "translate",
              let text = URLComponents(url: url, resolvingAgainstBaseURL: false)?
              .queryItems?.first(where: { $0.name == "text" })?.value?
              .trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty
        else { return nil }
        self = .translate(text)
    }
}

/// 谁发来的链接可以触发翻译。任何应用或网页都能打开 `umuo://`，而每次翻译都花用户自己的 Key，
/// 所以只认 PopClip（含它的 XPC 脚本进程）：按发送方的审计令牌核验代码签名的开发者团队。Bundle ID 谁都能写，不作数。
enum ExternalCaller {
    /// Pilotmoon Software 的 Team ID（`codesign -dv /Applications/PopClip.app`）。
    static let popClipRequirement = #"anchor apple generic and certificate leaf[subject.OU] = "6W6K75YWQ9""#

    static func isPopClip(_ event: NSAppleEventDescriptor) -> Bool {
        guard let token = event.attributeDescriptor(forKeyword: AEKeyword(keySenderAuditTokenAttr))?.data else {
            return false
        }
        var code: SecCode?
        var requirement: SecRequirement?
        guard SecCodeCopyGuestWithAttributes(nil, [kSecGuestAttributeAudit: token] as CFDictionary, [], &code)
            == errSecSuccess,
            let code,
            SecRequirementCreateWithString(popClipRequirement as CFString, [], &requirement) == errSecSuccess,
            let requirement
        else { return false }
        return SecCodeCheckValidity(code, [], requirement) == errSecSuccess
    }
}

/// 接收 `umuo://` 的 Apple 事件（`kAEGetURL`），解析并核验调用方后交给 `onCommand`。
///
/// 必须在 `willFinishLaunching` 时注册：更早注册会被 AppKit 启动时装的默认处理器覆盖，
/// 晚于启动完成则会漏掉冷启动带来的那个链接。`start()` 在 `UmuoApp.init` 里调用，早于这个通知。
@MainActor
final class ExternalURLReceiver: NSObject {
    private let isTrusted: (NSAppleEventDescriptor) -> Bool
    private let onCommand: @MainActor (ExternalCommand) -> Void
    private var launchObserver: NSObjectProtocol?

    init(isTrusted: @escaping (NSAppleEventDescriptor) -> Bool = ExternalCaller.isPopClip,
         onCommand: @escaping @MainActor (ExternalCommand) -> Void) {
        self.isTrusted = isTrusted
        self.onCommand = onCommand
    }

    func start() {
        launchObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.willFinishLaunchingNotification, object: nil, queue: nil
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.register() }
        }
    }

    private func register() {
        if let launchObserver { NotificationCenter.default.removeObserver(launchObserver) }
        launchObserver = nil
        NSAppleEventManager.shared().setEventHandler(
            self, andSelector: #selector(handle(_:withReplyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL)
        )
    }

    @objc private func handle(_ event: NSAppleEventDescriptor, withReplyEvent _: NSAppleEventDescriptor) {
        receive(event)
    }

    /// 不认识的链接与未通过核验的调用方都在这里止步：不进翻译流水线，不读 Key，不发请求。
    func receive(_ event: NSAppleEventDescriptor) {
        guard let string = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
              let url = URL(string: string)
        else { return }
        guard let command = ExternalCommand(url: url) else {
            return print("umuo: 忽略不支持的链接 \(url.scheme ?? "")://\(url.host ?? "")")
        }
        guard isTrusted(event) else { return print("umuo: 忽略不是 PopClip 发来的 umuo:// 链接") }
        onCommand(command)
    }
}
