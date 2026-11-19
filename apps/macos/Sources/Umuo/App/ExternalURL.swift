import AppKit

/// `umuo://` 链接能做的事。目前只有 `umuo://translate?text=<文本>`（PopClip 扩展 `scripts/popclip/umuo.popclipext`）。
///
/// 任何应用、网页都能打开这个链接，所以只开放「把给定文本弹浮窗翻译」：不取词、不写回、不读剪贴板、不改设置。
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

/// 接收 `umuo://` 的 Apple 事件（`kAEGetURL`），解析后交给 `onCommand`。
///
/// 必须在 `willFinishLaunching` 时注册：更早注册会被 AppKit 启动时装的默认处理器覆盖，
/// 晚于启动完成则会漏掉冷启动带来的那个链接。`start()` 在 `UmuoApp.init` 里调用，早于这个通知。
@MainActor
final class ExternalURLReceiver: NSObject {
    private let onCommand: @MainActor (ExternalCommand) -> Void
    private var launchObserver: NSObjectProtocol?

    init(onCommand: @escaping @MainActor (ExternalCommand) -> Void) {
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
        guard let string = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
              let url = URL(string: string)
        else { return }
        guard let command = ExternalCommand(url: url) else {
            return print("umuo: 忽略不支持的链接 \(url.scheme ?? "")://\(url.host ?? "")")
        }
        onCommand(command)
    }
}
