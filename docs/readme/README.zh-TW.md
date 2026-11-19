# umuo

<div align="center">

**macOS 翻譯與語音表達工具 · 免費開源 · 自備模型金鑰**

macOS 14+ · Apple Silicon · Swift + SwiftUI + AppKit · Rust 共用核心 · 純 BYOK · MIT 開源

[简体中文](../../README.md) · [English](README.en.md) · **繁體中文** · [日本語](README.ja.md) · [한국어](README.ko.md)

[官網](https://umuo.app) · [下載（Apple Silicon）](https://umuo.app/download/macos) · [所有版本](https://github.com/youming-ai/umuo/releases) · [貢獻指南](../../CONTRIBUTING.md)

[![Release](https://img.shields.io/github/v/release/youming-ai/umuo?label=release)](https://github.com/youming-ai/umuo/releases/latest)
[![CI](https://github.com/youming-ai/umuo/actions/workflows/ci.yml/badge.svg)](https://github.com/youming-ai/umuo/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](../../LICENSE)
![Platform](https://img.shields.io/badge/platform-macOS%2014%2B%20%C2%B7%20Apple%20Silicon-lightgrey)

</div>

---

## 主要功能

| 核心 | 範圍 |
| --- | --- |
| 文字翻譯 | 劃詞（⌃⌃）、輸入翻譯（⌥⌘A）、輸入框原地替換（⌥⌥）；複製、朗讀與輕量結果視窗 |
| OCR 截圖翻譯 | 系統框選（⌥⌘O）、Apple Vision 本機辨識、修正原文後再翻譯 |
| 語音表達 | 按住 ⌥⌘V 說話，整理成通順的文字；按住 ⌃⌘V 說話，翻譯成目標語言；本機轉寫，結果寫回原本的輸入框 |

umuo 採 MIT 授權條款開源，可免費使用。請設定自己的模型。使用付費服務時，模型用量由供應商直接計費。

模型金鑰存放在系統鑰匙圈，對供應商的請求從本機直接連到使用者設定的端點。語音在本機以 transcribe.cpp + Qwen3-ASR-0.6B 轉寫，
不需要額外的語音金鑰；整理與翻譯沿用文字模型，若使用雲端文字模型，轉寫出的文字會傳送給該供應商。

## 下載與安裝

在 Apple Silicon Mac（macOS 14 或更新版本）上[下載安裝檔](https://umuo.app/download/macos)。開啟 `umuo-v<版本>.dmg`，將 umuo 拖到「應用程式」。

安裝檔尚未經 Apple 公證。如果 macOS 阻擋首次啟動，請到「系統設定 › 隱私權與安全性」選擇「仍要打開」。已安裝的版本可在「設定 › 關於」檢查更新。所有安裝檔可在 [GitHub Releases](https://github.com/youming-ai/umuo/releases) 取得。

## 開始使用

### 設定模型與劃詞翻譯

1. 開啟 umuo，在「設定 › 引擎」選擇模型供應商並儲存 API 金鑰。使用本機模型時，請設定端點與模型名稱。
2. 在「系統設定 › 隱私權與安全性 › 輔助使用」允許 umuo。若使用開發版本，請允許啟動它的終端機或 IDE。
3. 在其他 App 中選取文字，連按兩下 Control（`⌃⌃`），譯文會在滑鼠游標附近的視窗內逐步顯示。

### 語音輸入

在任何輸入框裡按住 **⌥⌘V** 說話，放開後會整理成通順的文字並寫回輸入框；按住 **⌃⌘V** 則會翻譯成目標語言後再寫回。
第一次使用時會請求麥克風權限，並從 Hugging Face 下載約 560 MB 的轉寫模型；寫回輸入框同樣需要輔助使用權限。
這兩組快速鍵都可以在**設定 → 翻譯 → 語音輸入**裡修改。

### PopClip

裝有 [PopClip](https://www.popclip.app/)（2024.12 以上）時，執行 `open scripts/popclip/umuo.popclipext` 安裝擴充功能。
之後選取文字、點 PopClip 列上的 umuo 圖示，譯文同樣會出現在滑鼠游標附近的浮動視窗裡。擴充功能透過 `umuo://translate?text=…` 喚起 umuo；umuo 只接受 PopClip 發來的這個連結。

## 隱私

- 在 BYOK 模式下，請求只會送往你自己設定的端點；umuo 的伺服器收不到你的內容，也收不到你的金鑰。
- 翻譯歷史存放在本機 SQLite，可以搜尋、刪除、設定保留天數，也可以完全關閉。
- 語音在本機轉寫：錄音只寫入暫存檔，轉寫結束或取消後立即刪除，不會傳給 umuo，也不會傳給模型供應商。
- 預設不開啟內容遙測。

## 從原始碼建置

需求：Apple Silicon Mac、macOS 14+；Xcode 26（或附 macOS 26 SDK 的 Command Line Tools，浮動視窗用到了 Liquid Glass）、
[rustup](https://rustup.rs)（Rust 版本由 `rust-toolchain.toml` 固定，首次建置時會自動安裝）、[Bun](https://bun.sh) 1.4+（以 `package.json` 的 `packageManager` 為準）。

```bash
bun install          # 儲存庫工具指令碼的相依套件
cargo fetch          # Rust 相依套件

bun run dev:macos    # 編譯 Rust 綁定與 SwiftUI 用戶端後啟動（macOS 14+，Swift 6）
# 開發版本預設停用全域快速鍵。請先結束其他執行個體，再執行 bun run dev:macos --hotkeys
```

## 開發指令

| 指令 | 作用 |
| --- | --- |
| `bun run dev:macos` | 編譯並啟動 SwiftUI 用戶端 |
| `bun run build` | 編譯 Rust 綁定與原生用戶端 |
| `bun run bundle:macos -- --version X.Y.Z` | 產生 Apple Silicon（arm64）的 `.app` / `.dmg` / `.app.tar.gz`，須設定 Sparkle 公鑰，不會上傳 |
| `bun run icons` | 直接產生原生 App 的 ICNS 與選單列 PNG |
| `bun run lint` / `bun run format` | Biome 檢查／格式化工具腳本 |
| `bun run type-check` | 工具腳本的 TypeScript 型別檢查 |
| `bun run test:rust` | Rust workspace 單元測試與流水線回歸測試 |
| `bun run verify:macos` | Swift 建置、Swift Testing、FFI 自我檢查與打包冒煙測試 |
| `bun run verify` | 提交前的完整關卡，與 GitHub Actions 的 CI 一致 |

## 儲存庫結構

- [`apps/macos/`](../../apps/macos/) — 原生 macOS 用戶端、Swift 測試與打包指令碼
- [`crates/`](../../crates/) — Rust 應用程式邏輯、翻譯核心、SQLite 儲存與 Swift 綁定
- [`site/`](../../site/README.md) — 官網與 Cloudflare Worker，使用獨立的 Bun 專案
- [`scripts/`](../../scripts/) — 開發工具、語音辨識評測與 PopClip 擴充功能
- [`docs/`](../../docs/README.md) — 專案文件、發布手冊與 README 譯本

## 開發文件

產品需求、架構、驗收進度與發布手冊請見[專案文件](../README.md)（簡體中文）。

官網 [umuo.app](https://umuo.app)（單頁首頁）與 Worker 位於 [site/](../../site/)，合併進 `main` 後由 Cloudflare Workers Builds 自動部署。

## 參與貢獻

歡迎提交 Issue 或 Pull Request。開發、測試與提交方式請見[貢獻指南](../../CONTRIBUTING.md)。安全漏洞請透過[私密通報管道](../../SECURITY.md)提交。

## 授權

[MIT](../../LICENSE)，涵蓋整個儲存庫（含官網 `site/`）。「umuo」名稱與水獺圖示不在 MIT 授權範圍內：散布修改版時請改用其他名稱與圖示；說明作品是以 umuo 為基礎則不受限制。貢獻方式見 [CONTRIBUTING.md](../../CONTRIBUTING.md)。參考與重用的第三方實作記錄在 [THIRD_PARTY_NOTICES](../../THIRD_PARTY_NOTICES)。
