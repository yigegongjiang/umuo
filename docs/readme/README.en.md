# umuo

<div align="center">

**A free, open-source macOS translator: translate in place, select-to-translate, screenshot OCR and voice input — with your own API key.**

macOS 14+ · Apple Silicon · Swift + SwiftUI + AppKit · Shared Rust core · BYOK only · MIT licensed

[简体中文](../../README.md) · **English** · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md)

[Website](https://umuo.app) · [Download (Apple Silicon)](https://umuo.app/download/macos) · [All releases](https://github.com/youming-ai/umuo/releases) · [Contributing](../../CONTRIBUTING.md)

[![Release](https://img.shields.io/github/v/release/youming-ai/umuo?label=release)](https://github.com/youming-ai/umuo/releases/latest)
[![CI](https://github.com/youming-ai/umuo/actions/workflows/ci.yml/badge.svg)](https://github.com/youming-ai/umuo/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](../../LICENSE)
![Platform](https://img.shields.io/badge/platform-macOS%2014%2B%20%C2%B7%20Apple%20Silicon-lightgrey)

</div>

---

## Features

| Feature | Scope |
| --- | --- |
| Text translation | Selection (⌃⌃), Text Translation for typed input (⌥⌘A), Replace in Text Field (⌥⌥); copy, read aloud and a lightweight result window |
| Screenshot OCR translation | System region capture (⌥⌘O), on-device recognition with Apple Vision, edit the recognized text before translating |
| Voice input | Hold ⌥⌘V and speak to get clean, well-formed text; hold ⌃⌘V and speak to get it in your target language. Transcription runs on your Mac and the result is written back into the text field you were typing in |

umuo is free to use and open source under the MIT license. Bring your own model. If you use a paid service, the provider bills you directly for usage.

API keys are stored in the macOS Keychain, and provider requests go straight from your Mac to the endpoint you configured. Speech is transcribed on your Mac with transcribe.cpp + Qwen3-ASR-0.6B,
so no separate speech API key is needed. Cleanup and translation reuse your text model; if that is a cloud model, the transcribed text is sent to that provider.

## Download and install

[Download the installer](https://umuo.app/download/macos) on an Apple Silicon Mac running macOS 14 or later. Open `umuo-v<version>.dmg` and drag umuo to Applications.

The installer has not been notarized by Apple. If macOS blocks the first launch, choose **Open Anyway** in **System Settings › Privacy & Security**. To update an installed copy, go to **Settings › About**. All installers are available on [GitHub Releases](https://github.com/youming-ai/umuo/releases).

## Getting started

### Set up a model and translate selected text

1. Open umuo and choose a provider under **Settings › Engine**, then save your API key. For a local model, configure its endpoint and name.
2. Allow umuo under **System Settings › Privacy & Security › Accessibility**. For a development build, allow the terminal or IDE that launched it.
3. Select text in another app and press Control twice (`⌃⌃`). The translation streams into a window near the pointer.

### Voice input

In any text field, hold **⌥⌘V** and speak; when you release, your words are cleaned up into well-formed text and written back into the field. Hold **⌃⌘V** instead to have them translated into your target language before they are written back.
The first use asks for microphone permission and downloads a transcription model of about 560 MB from Hugging Face; writing back into the text field also needs Accessibility permission.
Both shortcuts can be changed under **Settings → Translation → Voice Input**.

### PopClip

With [PopClip](https://www.popclip.app/) 2024.12 or later installed, run `open scripts/popclip/umuo.popclipext` to install the extension.
Then select text and click the umuo icon in the PopClip bar: the translation appears in the same floating panel next to your pointer. The extension opens `umuo://translate?text=…`; umuo accepts this link only from PopClip.

## Privacy

- With BYOK, requests go only to the endpoints you configure; umuo's servers never see your content or your keys.
- Translation history is stored locally in SQLite. You can search and delete it, set how many days to keep it, or turn it off entirely.
- Speech is transcribed on your Mac: audio is written only to a temporary file that is deleted as soon as transcription finishes or is cancelled, and it is never sent to umuo or to the model provider.
- Content telemetry is off by default.

## Build from source

Requirements: an Apple Silicon Mac running macOS 14+; Xcode 26 (or Command Line Tools with the macOS 26 SDK — the floating panel uses Liquid Glass);
[rustup](https://rustup.rs) (the Rust version is pinned by `rust-toolchain.toml` and installed automatically on the first build); and [Bun](https://bun.sh) 1.4+ (the `packageManager` field in `package.json` is authoritative).

```bash
bun install          # dependencies for the repo's tooling scripts
cargo fetch          # Rust dependencies

bun run dev:macos    # build the Rust bindings and the SwiftUI client, then launch (macOS 14+, Swift 6)
# Dev builds don't register global shortcuts by default; quit other instances first, then run bun run dev:macos --hotkeys
```

## Development commands

| Command | What it does |
| --- | --- |
| `bun run dev:macos` | Build and launch the SwiftUI client |
| `bun run build` | Build the Rust bindings and the native client |
| `bun run bundle:macos -- --version X.Y.Z` | Produce the Apple Silicon (arm64) `.app` / `.dmg` / `.app.tar.gz`; requires the Sparkle public key; does not upload |
| `bun run icons` | Generate the native app ICNS and menu bar PNGs |
| `bun run lint` / `bun run format` | Biome lint / format for the tooling scripts |
| `bun run type-check` | TypeScript type check for the tooling scripts |
| `bun run test:rust` | Rust workspace unit tests and pipeline regression tests |
| `bun run verify:macos` | Swift build, Swift Testing, FFI self-check and packaging smoke test |
| `bun run verify` | Full pre-commit gate, matching CI on GitHub Actions |

## Repository layout

- [`apps/macos/`](../../apps/macos/) — Native macOS client, Swift tests and packaging scripts
- [`crates/`](../../crates/) — Rust application logic, translation core, SQLite storage and Swift bindings
- [`site/`](../../site/README.md) — Website and Cloudflare Worker in a standalone Bun project
- [`scripts/`](../../scripts/) — Developer tooling, speech recognition benchmarks and the PopClip extension
- [`docs/`](../../docs/README.md) — Project documentation, release guides and README translations

## Project documentation

See the [project documentation](../README.md) for product requirements, architecture, acceptance status and release instructions in Simplified Chinese.

The website [umuo.app](https://umuo.app) (a single landing page) and its Worker live in [site/](../../site/), and are deployed automatically by Cloudflare Workers Builds once merged into `main`.

## Contributing

Issues and pull requests are welcome. For setup, testing and submission, see the [contributing guide](../../CONTRIBUTING.md). Report vulnerabilities through the [private reporting channel](../../SECURITY.md).

## License

[MIT](../../LICENSE), covering the whole repository (including the website in `site/`). The "umuo" name and the otter icon are not licensed under MIT: if you distribute a modified version, please use a different name and icon; you are free to say your work is based on umuo. See [CONTRIBUTING.md](../../CONTRIBUTING.md) for how to contribute. Third-party implementations we referenced or reused are listed in [THIRD_PARTY_NOTICES](../../THIRD_PARTY_NOTICES).
