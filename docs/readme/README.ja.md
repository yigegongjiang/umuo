# umuo

<div align="center">

**macOS 向け翻訳・音声入力ツール · 無料のオープンソース · 自分のモデル API キーで使う**

macOS 14+ · Apple Silicon · Swift + SwiftUI + AppKit · Rust 共有コア · BYOK のみ · MIT ライセンス

[简体中文](../../README.md) · [English](README.en.md) · [繁體中文](README.zh-TW.md) · **日本語** · [한국어](README.ko.md)

[公式サイト](https://umuo.app) · [ダウンロード（Apple Silicon）](https://umuo.app/download/macos) · [すべてのバージョン](https://github.com/youming-ai/umuo/releases) · [コントリビューションガイド](../../CONTRIBUTING.md)

[![Release](https://img.shields.io/github/v/release/youming-ai/umuo?label=release)](https://github.com/youming-ai/umuo/releases/latest)
[![CI](https://github.com/youming-ai/umuo/actions/workflows/ci.yml/badge.svg)](https://github.com/youming-ai/umuo/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](../../LICENSE)
![Platform](https://img.shields.io/badge/platform-macOS%2014%2B%20%C2%B7%20Apple%20Silicon-lightgrey)

</div>

---

## 主な機能

| 柱 | 範囲 |
| --- | --- |
| テキスト翻訳 | 選択翻訳（⌃⌃）、テキスト翻訳（⌥⌘A）、入力欄をその場で置換（⌥⌥）。コピー・読み上げ・軽量な結果ウィンドウ |
| OCR スクリーンショット翻訳 | システムの範囲選択（⌥⌘O）、Apple Vision によるローカル認識、原文を修正してから翻訳 |
| 音声入力 | ⌥⌘V を押したまま話すと読みやすい文章に整え、⌃⌘V を押したまま話すと翻訳先の言語に翻訳。文字起こしは Mac 上で行い、結果は元の入力欄に書き戻す |

umuo は MIT ライセンスのオープンソースで、無料で使えます。ご自身のモデルを設定してください。有料サービスを使う場合は、利用料をプロバイダーに直接支払います。

モデルの API キーはシステムのキーチェーンに保存され、プロバイダーへのリクエストはこの Mac から、ご自身で設定したエンドポイントへ直接送られます。音声は Mac 上で transcribe.cpp + Qwen3-ASR-0.6B により文字起こしされるため、
音声用の API キーは別途不要です。整形と翻訳にはテキスト用のモデルを使います。クラウドのテキストモデルを使う場合、書き起こしたテキストはそのプロバイダーへ送信されます。

## ダウンロードとインストール

Apple Silicon 搭載の Mac（macOS 14 以降）で[インストーラをダウンロード](https://umuo.app/download/macos)します。`umuo-v<バージョン>.dmg` を開き、umuo を「アプリケーション」にドラッグしてください。

インストーラは Apple の公証を受けていません。初回起動がブロックされた場合は「システム設定 › プライバシーとセキュリティ」で「このまま開く」を選びます。インストール済みのアプリは「設定 › このアプリについて」でアップデートを確認できます。各バージョンのインストーラは [GitHub Releases](https://github.com/youming-ai/umuo/releases) にあります。

## 使い方

### モデルを設定して選択したテキストを翻訳する

1. umuo を開き、「設定 › エンジン」でプロバイダーを選び、API キーを保存します。ローカルモデルを使う場合は、エンドポイントとモデル名を設定します。
2. 「システム設定 › プライバシーとセキュリティ › アクセシビリティ」で umuo を許可します。開発ビルドの場合は、起動に使ったターミナルまたは IDE を許可します。
3. 別のアプリでテキストを選び、Control を 2 回押します（`⌃⌃`）。ポインター付近のウインドウに訳文が順次表示されます。

### 音声入力

任意の入力欄で **⌥⌘V** を押したまま話すと、離したときに読みやすい文章に整えて入力欄へ書き戻します。**⌃⌘V** を押したまま話すと、翻訳先の言語に翻訳してから書き戻します。
初回利用時にはマイクへのアクセス許可を求められ、Hugging Face から約 560 MB の文字起こしモデルをダウンロードします。入力欄への書き戻しにもアクセシビリティの許可が必要です。
どちらのキーも **設定 → 翻訳 → 音声入力** で変更できます。

### PopClip

[PopClip](https://www.popclip.app/)（2024.12 以降）を使っている場合は、`open scripts/popclip/umuo.popclipext` で拡張機能をインストールできます。
あとはテキストを選択して PopClip バーの umuo アイコンをクリックすると、同じくマウスカーソルの近くのパネルに訳文が表示されます。拡張機能は `umuo://translate?text=…` で umuo を呼び出します。umuo はこのリンクを PopClip からのみ受け付けます。

## プライバシー

- BYOK モードでは、リクエストはご自身で設定したエンドポイントにのみ送られます。umuo のサーバーがあなたの内容や API キーを受け取ることはありません。
- 翻訳履歴は Mac 上の SQLite に保存されます。検索・削除ができ、保存日数を設定したり、記録を完全にオフにしたりできます。
- 音声は Mac 上で文字起こしします。録音は一時ファイルにのみ書き込まれ、文字起こしの完了またはキャンセル後すぐに削除されます。umuo にもモデルのプロバイダーにも送信されません。
- コンテンツのテレメトリは既定でオフです。

## ソースからビルド

必要なもの：Apple Silicon 搭載の Mac、macOS 14 以降。Xcode 26（または macOS 26 SDK を含む Command Line Tools。パネルで Liquid Glass を使うため）、
[rustup](https://rustup.rs)（Rust のバージョンは `rust-toolchain.toml` で固定され、初回ビルド時に自動でインストールされます）、[Bun](https://bun.sh) 1.4 以降（`package.json` の `packageManager` に従います）。

```bash
bun install          # リポジトリのツールスクリプトの依存関係
cargo fetch          # Rust の依存関係

bun run dev:macos    # Rust バインディングと SwiftUI クライアントをビルドして起動（macOS 14+、Swift 6）
# 開発ビルドは既定でグローバルショートカットを登録しません。ほかのインスタンスを終了してから bun run dev:macos --hotkeys を使ってください
```

## 開発コマンド

| コマンド | 内容 |
| --- | --- |
| `bun run dev:macos` | SwiftUI クライアントをビルドして起動 |
| `bun run build` | Rust バインディングとネイティブクライアントをビルド |
| `bun run bundle:macos -- --version X.Y.Z` | Apple Silicon（arm64）向けの `.app` / `.dmg` / `.app.tar.gz` を生成。Sparkle の公開鍵の設定が必要。アップロードはしない |
| `bun run icons` | ネイティブアプリの ICNS とメニューバー用 PNG を直接生成 |
| `bun run lint` / `bun run format` | ツールスクリプトの Biome チェック／フォーマット |
| `bun run type-check` | ツールスクリプトの TypeScript 型チェック |
| `bun run test:rust` | Rust workspace の単体テストとパイプラインの回帰テスト |
| `bun run verify:macos` | Swift のビルド、Swift Testing、FFI のセルフチェック、パッケージのスモークテスト |
| `bun run verify` | コミット前の総合チェック。GitHub Actions の CI と同じ内容 |

## リポジトリ構成

- [`apps/macos/`](../../apps/macos/) — macOS ネイティブクライアント、Swift テスト、パッケージ作成スクリプト
- [`crates/`](../../crates/) — Rust のアプリケーションロジック、翻訳コア、SQLite ストレージ、Swift バインディング
- [`site/`](../../site/README.md) — 公式サイトと Cloudflare Worker を含む独立した Bun プロジェクト
- [`scripts/`](../../scripts/) — 開発ツール、音声認識の評価、PopClip 拡張
- [`docs/`](../../docs/README.md) — プロジェクトドキュメント、リリース手順、README の翻訳

## 開発ドキュメント

製品要件、アーキテクチャ、受け入れ確認の状況、リリース手順は[プロジェクトドキュメント](../README.md)（簡体字中国語）を参照してください。

公式サイト [umuo.app](https://umuo.app)（1 ページ構成のトップページ）と Worker は [site/](../../site/) にあり、`main` にマージされると Cloudflare Workers Builds で自動デプロイされます。

## コントリビューション

Issue や Pull Request を歓迎します。開発、テスト、提出の手順は[コントリビューションガイド](../../CONTRIBUTING.md)を参照してください。脆弱性は[非公開の窓口](../../SECURITY.md)に報告してください。

## ライセンス

[MIT](../../LICENSE)。リポジトリ全体（公式サイト `site/` を含む）が対象です。「umuo」の名称とカワウソのアイコンは MIT ライセンスの対象外です。改変版を配布する場合は別の名称とアイコンを使ってください。umuo をもとにした作品であると明記することは制限されません。コントリビューションの方法は [CONTRIBUTING.md](../../CONTRIBUTING.md) を参照してください。参考・再利用したサードパーティの実装は [THIRD_PARTY_NOTICES](../../THIRD_PARTY_NOTICES) に記載しています。
