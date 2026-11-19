# umuo 项目指引

umuo 面向 Apple Silicon、macOS 14+，提供文字翻译、OCR 截图翻译和语音输入。客户端免费、MIT 开源，模型调用采用纯 BYOK。账号、收费、试用、官方额度和 AI 网关已退出产品范围。

## 按改动查阅

- **官网或 Worker**：先读 [官网指引](site/AGENTS.md)，在 `site/` 使用独立的 Bun 项目。
- **功能或入口**：先读 [PRD](docs/PRD.md)、[实现与验收清单](docs/PRD-CONFORMANCE.md) 和 [开发计划](docs/IMPLEMENTATION-PLAN.md)。完成后在验收清单记录实现证据、验证结果和剩余真机项目。
- **线程、事件或 Host 接口**：读 [架构 §2.1–2.3](docs/ARCHITECTURE.md#21-应用层与宿主)。
- **发布、签名、Sparkle 或升级兼容**：读 [发布手册](docs/release/RELEASE.md)。保留正式版 Latest 标记，以及安装包、更新包和 appcast 的命名规则。
- **真机或性能验收**：按 [真机走查](docs/release/NATIVE-WALKTHROUGH.md) 操作。性能使用 release 包，内存记录 `footprint` 的 `phys_footprint`。
- **README**：以 [简体中文版](README.md) 为准，同步 [英文、繁体中文、日文和韩文译本](docs/readme/)。

## 实现约束

- `apps/macos/` 使用 Swift 6、SwiftUI 和 AppKit，负责系统交互。平台无关业务逻辑放入 `umuo-app`，翻译协议、Prompt 和传输放入 `umuo-core`，两者须在 Linux 上可构建和测试。`umuo-ffi` 只做类型转换和导出，`umuo-bindgen` 只在构建时生成 Swift 绑定。
- 流水线需要的 Key、前台应用和写回通过 `umuo_app::Host` 调用 Swift 宿主。同步 Host 回调不得等待主线程。模型请求由 Rust 发出，API Key 只存系统 Keychain，界面只读取配置状态，配置、日志和历史不记录 Key。
- 发布与升级须保留 Bundle ID `app.umuo.desktop`、`umuo.app` 和可执行文件名 `umuo-desktop`，兼容现有 Keychain、系统授权与 LaunchAgent。Rust 读写 `settings.json` 并保留未知字段，Swift 只提交 patch。历史沿用 `history.db` 和已发布的 SQLite 迁移，旧收藏和用量表仅作数据保留。
- UI 遵循 Apple HIG，采用系统控件、语义色、文字样式和 SF Symbols。使用 `Form(.grouped)` 或 `GroupBox` 分组，非激活浮窗用 AppKit `NSPanel` 和 `floatingSurface`（macOS 26 Liquid Glass，旧系统回落至系统材质）。外观只有跟随系统、浅色和深色，由 `ThemeChoice.apply` 统一处理，保留 VoiceOver、增强对比度与减少动态效果支持。

## 开发与验证

1. 使用根 `package.json` 指定的 Bun 版本、`rust-toolchain.toml` 锁定的 Rust 工具链，以及 Swift 6 和 macOS 26 SDK。命令以根 `package.json` 为准。
2. 用 `bun run dev:macos` 从当前源码构建并启动。开发构建默认关闭全局快捷键。需要测试时先退出其他 umuo 实例，再运行 `bun run dev:macos --hotkeys`。
3. 翻译逻辑改动跑 `bun run test:rust`，原生 UI 改动跑 `bun run verify:macos`，提交前跑 `bun run verify`。非 macOS 环境由 CI 的 `macos-app` 验证原生部分。官网在 `site/` 单独跑 `bun run verify`。
4. 新增 CI 门禁时同步接入本机 `verify`。功能分支可用 `gh workflow run ci.yml --ref <分支>` 触发 CI，在 PR 说明记录验证结果。客户端改动合入 `main` 后由 Release 工作流跑 CI 并发布正式版。合并在本地完成再推送，以使用本地 Git 邮箱。

## 风格与测试

注释与提交信息用中文，代码标识符用英文。Rust 公共 API 写文档注释，用 cargo fmt 和 clippy 检查。TS/JS 格式以 Biome 配置为准，JS 包管理使用 Bun。

Rust 单测与模块同文件。跨模块流水线回归和事件兼容快照位于 `crates/umuo-app/tests/`。FFI 行为由 `crates/umuo-ffi/src/engine.rs` 和 `Umuo --selftest` 验证。Swift 视图模型和纯规则使用 Swift Testing，官网测试使用 Vitest。测试使用替身和本地桩隔离用户 Keychain、剪贴板、系统按键与真实供应商端点。
