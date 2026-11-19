# umuo

<div align="center">

**macOS 翻译与语音表达工具 · 免费开源 · 自带模型 Key**

macOS 14+ · Apple Silicon · Swift + SwiftUI + AppKit · Rust 共享核心 · 纯 BYOK · MIT 开源

**简体中文** · [English](docs/readme/README.en.md) · [繁體中文](docs/readme/README.zh-TW.md) · [日本語](docs/readme/README.ja.md) · [한국어](docs/readme/README.ko.md)

[官网](https://umuo.app) · [下载（Apple Silicon）](https://umuo.app/download/macos) · [所有版本](https://github.com/youming-ai/umuo/releases) · [贡献指南](CONTRIBUTING.md)

[![Release](https://img.shields.io/github/v/release/youming-ai/umuo?label=release)](https://github.com/youming-ai/umuo/releases/latest)
[![CI](https://github.com/youming-ai/umuo/actions/workflows/ci.yml/badge.svg)](https://github.com/youming-ai/umuo/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Platform](https://img.shields.io/badge/platform-macOS%2014%2B%20%C2%B7%20Apple%20Silicon-lightgrey)

</div>

---

## 主要功能

| 核心 | 范围 |
| --- | --- |
| 文字翻译 | 划词（⌃⌃）、输入翻译（⌥⌘A）、输入框原地替换（⌥⌥）；复制、朗读与轻量结果窗 |
| OCR 截图翻译 | 系统框选（⌥⌘O）、Apple Vision 本地识别、修正原文后翻译 |
| 语音表达 | 按住 ⌥⌘V 说话整理成通顺文字、按住 ⌃⌘V 说话翻译成目标语言；本机转写，结果写回原输入框 |

umuo 按 MIT 许可证开源，可免费使用。请配置自己的模型。使用付费服务时，模型用量由供应商直接计费。

模型 Key 存系统 Keychain，供应商请求从本机直连用户配置的端点。语音在本机用 transcribe.cpp + Qwen3-ASR-0.6B 转写，
不需要额外的语音 Key；整理与翻译复用文字模型，使用云端文字模型时，转写文本会发送给该供应商。

## 下载与安装

在 Apple Silicon Mac（macOS 14 或更新版本）上，[下载安装包](https://umuo.app/download/macos)。打开 `umuo-v<版本>.dmg`，将 umuo 拖到「应用程序」。

安装包尚未经 Apple 公证。如果 macOS 拦截首次启动，请到「系统设置 › 隐私与安全性」选择「仍要打开」。已安装的版本可在「设置 › 关于」检查更新。所有安装包见 [GitHub Releases](https://github.com/youming-ai/umuo/releases)。

## 开始使用

### 配置模型与划词翻译

1. 打开 umuo，在「设置 › 引擎」选择模型供应商并保存 API Key。使用本地模型时，配置端点与模型名。
2. 在「系统设置 › 隐私与安全性 › 辅助功能」中允许 umuo。使用开发构建时，授权启动它的终端或 IDE。
3. 在其他 App 中选中文字，连按两下 Control（`⌃⌃`），译文会在鼠标附近的浮窗中逐步显示。

### 语音输入

在任意输入框里按住 **⌥⌘V** 说话，松开后整理成通顺的文字写回输入框；按住 **⌃⌘V** 则翻译成目标语言再写回。
首次使用会请求麦克风权限，并从 Hugging Face 下载约 560 MB 的转写模型；写回输入框同样需要辅助功能权限。
两个键都可以在**设置 → 翻译 → 语音输入**里修改。

### PopClip

装有 [PopClip](https://www.popclip.app/)（2024.12 及以上）时，执行 `open scripts/popclip/umuo.popclipext` 安装扩展。
之后选中文字、点 PopClip 栏里的 umuo 图标，译文同样出现在鼠标附近的浮窗里。扩展经 `umuo://translate?text=…` 唤起 umuo；umuo 只接受 PopClip 发来的这个链接。

## 隐私

- BYOK 模式下，请求只发往你自己配置的端点；umuo 的服务器收不到你的内容，也收不到你的 Key。
- 翻译历史存在本机 SQLite，可搜索、删除，可设置保留天数，也可完全关闭。
- 语音在本机转写：录音只写入临时文件，转写结束或取消后立即删除，不发给 umuo，也不发给模型供应商。
- 默认不开启内容遥测。

## 从源码构建

需要：Apple Silicon Mac、macOS 14+；Xcode 26（或带 macOS 26 SDK 的 Command Line Tools，浮窗用到 Liquid Glass）、
[rustup](https://rustup.rs)（Rust 版本由 `rust-toolchain.toml` 固定，首次构建自动安装）、[Bun](https://bun.sh) 1.4+（以 `package.json` 的 `packageManager` 为准）。

```bash
bun install          # 仓库工具脚本依赖
cargo fetch          # Rust 依赖

bun run dev:macos    # 编 Rust 绑定与 SwiftUI 客户端后启动（macOS 14+，Swift 6）
# 开发二进制默认不注册全局快捷键；先退出其他实例，再用 bun run dev:macos --hotkeys
```

## 开发命令

| 命令 | 作用 |
| --- | --- |
| `bun run dev:macos` | 编译并启动 SwiftUI 客户端 |
| `bun run build` | 编译 Rust 绑定与原生客户端 |
| `bun run bundle:macos -- --version X.Y.Z` | 生成 Apple Silicon（arm64）的 `.app` / `.dmg` / `.app.tar.gz`，须配置 Sparkle 公钥，不上传 |
| `bun run icons` | 直接生成原生应用 ICNS 与菜单栏 PNG |
| `bun run lint` / `bun run format` | Biome 检查 / 格式化工具脚本 |
| `bun run type-check` | 工具脚本的 TypeScript 类型检查 |
| `bun run test:rust` | Rust workspace 单测与流水线回归测试 |
| `bun run verify:macos` | Swift 构建、Swift Testing、FFI 自检与打包冒烟 |
| `bun run verify` | 提交前完整门禁，与 GitHub Actions 的 CI 对齐 |

## 仓库结构

- [`apps/macos/`](apps/macos/) — 原生 macOS 客户端、Swift 测试和打包脚本
- [`crates/`](crates/) — Rust 应用逻辑、翻译内核、SQLite 存储和 Swift 绑定
- [`site/`](site/README.md) — 官网与 Cloudflare Worker，使用独立的 Bun 项目
- [`scripts/`](scripts/) — 开发工具、语音评测和 PopClip 扩展
- [`docs/`](docs/README.md) — 项目文档、发布手册和 README 译本

## 开发文档

产品需求、架构、验收状态和发布手册见 [项目文档](docs/README.md)。

官网 [umuo.app](https://umuo.app)（单页首页）与 Worker 在 [site/](site/)，合入 `main` 后由 Cloudflare Workers Builds 自动部署。

## 参与贡献

欢迎提交 Issue 或 Pull Request。开发流程、测试和提交流程见 [贡献指南](CONTRIBUTING.md)。安全漏洞请通过 [私密报告渠道](SECURITY.md) 提交。

## 许可

[MIT](LICENSE)，整个仓库（含官网 `site/`）。「umuo」名称与水獭图标不随 MIT 授权：分发修改版请换用其他名称与图标，说明作品基于 umuo 不受限制。贡献方式见 [CONTRIBUTING.md](CONTRIBUTING.md)。参考与复用的第三方实现记在 [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES)。
