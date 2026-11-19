import type { SiteContent } from './types'

/**
 * 繁體中文（台灣）文案。用詞依台灣習慣重寫（軟體、設定、網路、使用者、金鑰、權限），
 * 不是簡體版的逐字轉換。事實依據：docs/PRD.md（v0.5：文字／截圖／語音三項核心，免費、純 BYOK）。
 */
export const zhTw: SiteContent = {
  seo: {
    title: 'umuo — 寫完就地翻譯 | Mac AI 翻譯',
    description:
      'umuo 是免費開源的 Mac 翻譯軟體。連按兩下 ⌥，譯文直接回到原本的輸入框。也能翻譯選取文字、手動輸入、截圖和語音。使用自己的 API 金鑰或本機模型，不需帳號或訂閱。',
    ogLocale: 'zh_TW',
  },
  nav: {
    skipToContent: '跳到主要內容',
    themeLabel: '主題',
    themeToLight: '切換為淺色主題',
    themeToDark: '切換為深色主題',
  },
  hero: {
    title: '寫完按兩下，\n原地換個語言',
    subtitle: '連按兩下 ⌥，譯文直接回到輸入框，省下複製貼上。想看懂外文？選取文字，或截個圖。',
    demo: {
      label: '翻譯預覽',
      modes: [
        {
          id: 'read',
          hint: '在這個頁面連按兩下 ⌃ 試試',
          name: '劃詞翻譯',
          keys: ['⌃', '⌃'],
          before: 'That meeting could have been an email.',
          beforeLang: 'en',
          after: '這場會議其實寄封信就好。',
          afterLang: 'zh-Hant',
        },
        {
          id: 'write',
          hint: '在這個頁面連按兩下 ⌥ 試試',
          name: '閃電替換',
          keys: ['⌥', '⌥'],
          before: '明天下午三點開個短會，真的。',
          beforeLang: 'zh-Hant',
          after: 'Quick meeting at 3 tomorrow. Really.',
          afterLang: 'en',
          note: '確認仍是同一個輸入框才替換；失敗或取消時原文不動。',
        },
        {
          id: 'ocr',
          hint: '截圖翻譯要在 Mac 上按 ⌥⌘O 框選',
          name: '截圖翻譯',
          keys: ['⌥', '⌘', 'O'],
          before: 'Last train leaves Platform 2 at 11:40 p.m.',
          beforeLang: 'en',
          after: '末班車晚上 11:40 從 2 號月台發車。',
          afterLang: 'zh-Hant',
        },
        {
          id: 'speak',
          hint: '按住 ⌃⌘V 說話，放開後翻譯成目標語言；按住 ⌥⌘V 則整理成通順的同語言文字',
          name: '語音輸入',
          keys: ['⌃', '⌘', 'V'],
          before: '嗯，禮拜五……啊不對，禮拜四喝杯咖啡？',
          beforeLang: 'zh-Hant',
          after: 'Coffee on Thursday?',
          afterLang: 'en',
          note: '語音在本機轉寫，第一次使用會下載約 560 MB 的語音模型。',
        },
      ],
    },
    platform: {
      requirement: 'macOS 14+，僅支援 Apple Silicon（M 系列晶片）',
      actionLabel: '下載 macOS 版',
      statusLabel: '預覽版',
      note: '預覽版未經 Apple 公證，首次打開若被攔下，到「隱私權與安全性」點「仍要打開」。',
      afterDownload: {
        title: '下載開始了，接下來安裝 umuo',
        steps: [
          '打開下載的安裝檔，把 umuo 拖進「應用程式」資料夾。',
          '首次打開若被攔下，到「系統設定 › 隱私權與安全性」點「仍要打開」。',
          '依引導選擇模型供應商、填入你的 API 金鑰；劃詞翻譯需要授予輔助使用權限。',
        ],
      },
    },
  },
  footer: {
    copyright: '© 2026 umuo',
    languageLabel: '語言',
  },
}
