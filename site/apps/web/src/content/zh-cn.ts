import type { SiteContent } from './types'

/**
 * 简体中文文案（首发语言，也是其他语言的参考文本）。
 * 事实性内容来自根目录 docs/PRD.md（v0.5：文字 / 截图 / 语音三项核心，免费、纯 BYOK）。
 */
export const zhCn: SiteContent = {
  seo: {
    title: 'umuo — 写完就地译 | Mac AI 翻译',
    description:
      'umuo 是免费的开源 Mac 翻译工具。连按两下 ⌥，译文回到原输入框。划词、输入、截图和语音也能译。使用自己的 API Key 或本地模型，无需账号或订阅。',
    ogLocale: 'zh_CN',
  },
  nav: {
    skipToContent: '跳到主要内容',
    themeLabel: '主题',
    themeToLight: '切换到浅色主题',
    themeToDark: '切换到深色主题',
  },
  hero: {
    title: '写完按两下，\n原地换个语言',
    subtitle: '连按两下 ⌥，译文直接回到输入框，省去复制粘贴。想读外文？划个词，或截个图。',
    demo: {
      label: '翻译预览',
      modes: [
        {
          id: 'read',
          hint: '在这个页面连按两下 ⌃ 试试',
          name: '划词翻译',
          keys: ['⌃', '⌃'],
          before: 'That meeting could have been an email.',
          beforeLang: 'en',
          after: '这会其实发封邮件就行。',
          afterLang: 'zh-Hans',
        },
        {
          id: 'write',
          hint: '在这个页面连按两下 ⌥ 试试',
          name: '闪电替换',
          keys: ['⌥', '⌥'],
          before: '明天下午三点开个短会，真的。',
          beforeLang: 'zh-Hans',
          after: 'Quick meeting at 3 tomorrow. Really.',
          afterLang: 'en',
          note: '确认还是同一个输入框才替换；失败或取消时原文不动。',
        },
        {
          id: 'ocr',
          hint: '截图翻译要在 Mac 上按 ⌥⌘O 框选',
          name: '截图翻译',
          keys: ['⌥', '⌘', 'O'],
          before: 'Last train leaves Platform 2 at 11:40 p.m.',
          beforeLang: 'en',
          after: '末班车晚上 11:40 从 2 号站台发车。',
          afterLang: 'zh-Hans',
        },
        {
          id: 'speak',
          hint: '按住 ⌃⌘V 说话，松开后翻译成目标语言；按住 ⌥⌘V 则整理成通顺的同语言文字',
          name: '语音输入',
          keys: ['⌃', '⌘', 'V'],
          before: '嗯，周五……不对，周四喝杯咖啡？',
          beforeLang: 'zh-Hans',
          after: 'Coffee on Thursday?',
          afterLang: 'en',
          note: '语音在本机转写，首次使用会下载约 560 MB 的语音模型。',
        },
      ],
    },
    platform: {
      requirement: 'macOS 14+，仅支持 Apple Silicon（M 系列芯片）',
      actionLabel: '下载 macOS 版',
      statusLabel: '预览版',
      note: '预览版未经 Apple 公证，首次打开如被拦截，到「隐私与安全性」点「仍要打开」。',
      afterDownload: {
        title: '下载开始了，接下来装上 umuo',
        steps: [
          '打开下载的安装包，把 umuo 拖进「应用程序」文件夹。',
          '首次打开如被拦截，到「系统设置 › 隐私与安全性」点「仍要打开」。',
          '按引导选模型供应商、填入你的 API Key；划词翻译需要授予辅助功能权限。',
        ],
      },
    },
  },
  footer: {
    copyright: '© 2026 umuo',
    languageLabel: '语言',
  },
}
