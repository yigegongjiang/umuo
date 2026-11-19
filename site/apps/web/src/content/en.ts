import type { SiteContent } from './types'

/**
 * English copy. Structure follows zh-cn.ts; facts come from docs/PRD.md (v0.5: text,
 * screenshot and voice; free, BYOK only). Wording is written for English readers, not translated.
 */
export const en: SiteContent = {
  seo: {
    title: 'umuo — Translate as you write on Mac',
    description:
      'Free, open-source translation for Mac. Double-tap ⌥ to translate in place, or translate selected text, typed text, screenshots, and speech. Use your own API key or a local model. No account or subscription.',
    ogLocale: 'en_US',
  },
  nav: {
    skipToContent: 'Skip to main content',
    themeLabel: 'Theme',
    themeToLight: 'Switch to light theme',
    themeToDark: 'Switch to dark theme',
  },
  hero: {
    title: 'Write here.\nTranslate here.',
    subtitle:
      'Tap ⌥ twice to translate in the same text box. Copy and paste can take a break. You can translate selections and screenshots, too.',
    demo: {
      label: 'Translation preview',
      modes: [
        {
          id: 'read',
          hint: 'Tap ⌃ twice on this page to try it',
          name: 'Selection',
          keys: ['⌃', '⌃'],
          before: '这会其实发封邮件就行。',
          beforeLang: 'zh-Hans',
          after: 'That meeting could have been an email.',
          afterLang: 'en',
        },
        {
          id: 'write',
          hint: 'Tap ⌥ twice on this page to try it',
          name: 'Lightning Replace',
          keys: ['⌥', '⌥'],
          before: 'Quick meeting at 3 tomorrow. Really.',
          beforeLang: 'en',
          after: '明天下午三点开个短会，真的。',
          afterLang: 'zh-Hans',
          note: 'Replaced only if it is still the same input box. If anything fails, your original text stays.',
        },
        {
          id: 'ocr',
          hint: 'Screenshot translation runs on your Mac: press ⌥⌘O and drag',
          name: 'Screenshot',
          keys: ['⌥', '⌘', 'O'],
          before: '終電は 23:40、2 番線から発車します。',
          beforeLang: 'ja',
          after: 'The last train leaves Platform 2 at 11:40 p.m.',
          afterLang: 'en',
        },
        {
          id: 'speak',
          hint: 'Hold ⌃⌘V and speak, release to get it in your target language; hold ⌥⌘V to tidy it up in the same language',
          name: 'Voice',
          keys: ['⌃', '⌘', 'V'],
          before: 'Um, coffee Friday… wait, Thursday?',
          beforeLang: 'en',
          after: '周四喝杯咖啡？',
          afterLang: 'zh-Hans',
          note: 'Speech is transcribed on your Mac; first use downloads a voice model of about 560 MB.',
        },
      ],
    },
    platform: {
      requirement: 'macOS 14+, Apple Silicon (M-series) only',
      actionLabel: 'Download for macOS',
      statusLabel: 'Preview',
      note: 'Not notarized yet. If macOS blocks it, open Privacy & Security and click “Open Anyway”.',
      afterDownload: {
        title: 'Download started. Let’s get umuo set up.',
        steps: [
          'Open the downloaded installer and drag umuo into your Applications folder.',
          'If macOS blocks it on first launch, open System Settings › Privacy & Security and click “Open Anyway”.',
          'Follow the setup to pick a model provider and enter your API key. Selection translation needs Accessibility permission.',
        ],
      },
    },
  },
  footer: {
    copyright: '© 2026 umuo',
    languageLabel: 'Language',
  },
}
