import type { SiteContent } from './types'

/**
 * 日本語コピー。事実はルートの docs/PRD.md（v0.5：文字 / スクリーンショット / 音声の 3 本柱、無料・BYOK のみ）に基づく。
 * 中国語版の直訳ではなく、日本語のプロダクトサイトとして書いた文章。
 */
export const ja: SiteContent = {
  seo: {
    title: 'umuo — 書いたその場で翻訳 | Mac AI 翻訳',
    description:
      'umuo は無料・オープンソースの Mac 向け翻訳アプリです。⌥ を 2 回押すと入力欄の文章をその場で翻訳。選択範囲、入力テキスト、スクリーンショット、音声にも対応。自分の API キーやローカルモデルを使えます。アカウントやサブスクリプションは不要です。',
    ogLocale: 'ja_JP',
  },
  nav: {
    skipToContent: 'メインコンテンツへ移動',
    themeLabel: 'テーマ',
    themeToLight: 'ライトテーマに切り替え',
    themeToDark: 'ダークテーマに切り替え',
  },
  hero: {
    title: '書いたその場で、\n言語をチェンジ',
    subtitle:
      '⌥ を 2 回押せば、訳文は同じ入力欄に。コピペはひと休み。選んだ文字やスクショも訳せます。',
    demo: {
      label: '翻訳プレビュー',
      modes: [
        {
          id: 'read',
          hint: 'このページで ⌃ を 2 回押して試せます',
          name: '選択翻訳',
          keys: ['⌃', '⌃'],
          before: 'That meeting could have been an email.',
          beforeLang: 'en',
          after: 'あの会議、メールで済んだよね。',
          afterLang: 'ja',
        },
        {
          id: 'write',
          hint: 'このページで ⌥ を 2 回押して試せます',
          name: '瞬間置換',
          keys: ['⌥', '⌥'],
          before: '明日の午後 3 時に短い打ち合わせを。本当に短めで。',
          beforeLang: 'ja',
          after: 'Quick meeting at 3 tomorrow. Really.',
          afterLang: 'en',
          note: '同じ入力欄のままのときだけ置き換えます。失敗・キャンセル時は原文を残します。',
        },
        {
          id: 'ocr',
          hint: 'スクショ翻訳は Mac で ⌥⌘O を押して範囲を選びます',
          name: 'スクショ翻訳',
          keys: ['⌥', '⌘', 'O'],
          before: 'Last train leaves Platform 2 at 11:40 p.m.',
          beforeLang: 'en',
          after: '終電は午後 11 時 40 分に 2 番線から発車します。',
          afterLang: 'ja',
        },
        {
          id: 'speak',
          hint: '⌃⌘V を押したまま話すと、離したときに目標言語へ翻訳します。⌥⌘V なら同じ言語のまま整えます',
          name: '音声入力',
          keys: ['⌃', '⌘', 'V'],
          before: 'えっと、金曜……じゃなくて木曜にコーヒーでもどう？',
          beforeLang: 'ja',
          after: 'Coffee on Thursday?',
          afterLang: 'en',
          note: '文字起こしは Mac 上で行い、初回利用時に約 560 MB の音声モデルをダウンロードします。',
        },
      ],
    },
    platform: {
      requirement: 'macOS 14 以降、Apple Silicon（M シリーズ）専用',
      actionLabel: 'macOS 版をダウンロード',
      statusLabel: 'プレビュー版',
      note: '未公証のプレビュー版です。開けない場合は「プライバシーとセキュリティ」で「このまま開く」を押してください。',
      afterDownload: {
        title: 'ダウンロードを開始しました。次は umuo のインストールです。',
        steps: [
          'ダウンロードしたインストーラを開き、umuo を「アプリケーション」フォルダへドラッグします。',
          '初回起動がブロックされたら「システム設定 › プライバシーとセキュリティ」で「このまま開く」を押します。',
          '案内に沿ってモデルプロバイダーを選び、API キーを入力します。選択翻訳にはアクセシビリティの許可が必要です。',
        ],
      },
    },
  },
  footer: {
    copyright: '© 2026 umuo',
    languageLabel: '言語',
  },
}
