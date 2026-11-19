import type { SiteContent } from './types'

/** 한국어 문안. 구조와 제품 정보는 zh-cn.ts를 기준으로 합니다. */
export const ko: SiteContent = {
  seo: {
    title: 'umuo — 쓰는 자리에서 번역하는 Mac 앱',
    description:
      'umuo는 무료 오픈소스 Mac 번역 앱입니다. ⌥를 두 번 눌러 입력창에서 바로 번역하세요. 선택한 텍스트, 직접 입력한 글, 스크린샷, 음성도 번역합니다. 내 API 키나 로컬 모델을 쓰며 계정과 구독은 필요 없습니다.',
    ogLocale: 'ko_KR',
  },
  nav: {
    skipToContent: '본문으로 바로가기',
    themeLabel: '테마',
    themeToLight: '라이트 테마로 전환',
    themeToDark: '다크 테마로 전환',
  },
  hero: {
    title: '쓰던 그 자리에서\n언어만 바꿔요',
    subtitle:
      '⌥를 두 번 누르면 번역문이 같은 입력창에 들어갑니다. 복사와 붙여넣기는 잠깐 쉬어도 돼요. 선택한 글과 스크린샷도 번역할 수 있어요.',
    demo: {
      label: '번역 미리보기',
      modes: [
        {
          id: 'read',
          hint: '이 페이지에서 ⌃를 두 번 눌러 보세요',
          name: '선택 번역',
          keys: ['⌃', '⌃'],
          before: 'That meeting could have been an email.',
          beforeLang: 'en',
          after: '그 회의, 이메일 한 통이면 됐는데.',
          afterLang: 'ko',
        },
        {
          id: 'write',
          hint: '이 페이지에서 ⌥를 두 번 눌러 보세요',
          name: '번개 교체',
          keys: ['⌥', '⌥'],
          before: '내일 오후 3시에 짧게 회의해요. 진짜 짧게요.',
          beforeLang: 'ko',
          after: 'Quick meeting at 3 tomorrow. Really.',
          afterLang: 'en',
          note: '같은 입력창일 때만 바꿉니다. 실패하거나 취소하면 원문은 그대로 둡니다.',
        },
        {
          id: 'ocr',
          hint: '스크린샷 번역은 Mac에서 ⌥⌘O로 영역을 선택합니다',
          name: '스크린샷 번역',
          keys: ['⌥', '⌘', 'O'],
          before: 'Last train leaves Platform 2 at 11:40 p.m.',
          beforeLang: 'en',
          after: '막차는 오후 11시 40분에 2번 승강장에서 출발합니다.',
          afterLang: 'ko',
        },
        {
          id: 'speak',
          hint: '⌃⌘V를 누른 채 말하고 떼면 목표 언어로 번역합니다. ⌥⌘V를 쓰면 같은 언어로 매끄럽게 다듬습니다',
          name: '음성 입력',
          keys: ['⌃', '⌘', 'V'],
          before: '음, 금요일에… 아니, 목요일에 커피 한 잔 할래?',
          beforeLang: 'ko',
          after: 'Coffee on Thursday?',
          afterLang: 'en',
          note: '음성 인식은 Mac에서 처리하며, 처음 사용할 때 약 560MB의 음성 모델을 내려받습니다.',
        },
      ],
    },
    platform: {
      requirement: 'macOS 14 이상, Apple Silicon(M 시리즈) 전용',
      actionLabel: 'macOS용 다운로드',
      statusLabel: '프리뷰',
      note: '아직 Apple 공증 전인 프리뷰입니다. 차단되면 「개인정보 보호 및 보안」에서 「그래도 열기」를 누르세요.',
      afterDownload: {
        title: '다운로드를 시작했어요. 이제 umuo를 설치해 볼까요?',
        steps: [
          '받은 설치 파일을 열고 umuo를 「응용 프로그램」 폴더로 끌어 놓습니다.',
          '처음 열 때 차단되면 「시스템 설정 › 개인정보 보호 및 보안」에서 「그래도 열기」를 누릅니다.',
          '안내에 따라 모델 제공업체를 고르고 API 키를 입력합니다. 선택 번역에는 손쉬운 사용 권한이 필요합니다.',
        ],
      },
    },
  },
  footer: {
    copyright: '© 2026 umuo',
    languageLabel: '언어',
  },
}
