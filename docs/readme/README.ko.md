# umuo

<div align="center">

**macOS 번역·음성 입력 도구 · 무료 오픈소스 · 내 모델 API 키 사용**

macOS 14+ · Apple Silicon · Swift + SwiftUI + AppKit · Rust 공유 코어 · 순수 BYOK · MIT 오픈소스

[简体中文](../../README.md) · [English](README.en.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · **한국어**

[공식 웹사이트](https://umuo.app) · [다운로드(Apple Silicon)](https://umuo.app/download/macos) · [모든 버전](https://github.com/youming-ai/umuo/releases) · [기여 가이드](../../CONTRIBUTING.md)

[![Release](https://img.shields.io/github/v/release/youming-ai/umuo?label=release)](https://github.com/youming-ai/umuo/releases/latest)
[![CI](https://github.com/youming-ai/umuo/actions/workflows/ci.yml/badge.svg)](https://github.com/youming-ai/umuo/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](../../LICENSE)
![Platform](https://img.shields.io/badge/platform-macOS%2014%2B%20%C2%B7%20Apple%20Silicon-lightgrey)

</div>

---

## 주요 기능

| 핵심 기능 | 범위 |
| --- | --- |
| 텍스트 번역 | 선택 번역(⌃⌃), 입력 번역(⌥⌘A), 입력란 제자리 교체(⌥⌥). 복사, 읽어 주기, 가벼운 결과 창 |
| 스크린샷(OCR) 번역 | 시스템 영역 선택(⌥⌘O), Apple Vision 로컬 인식, 원문 수정 후 번역 |
| 음성 입력 | ⌥⌘V를 누른 채 말하면 매끄러운 문장으로 다듬고, ⌃⌘V를 누른 채 말하면 목표 언어로 번역. Mac에서 음성 인식 후 결과를 원래 입력란에 다시 써넣음 |

umuo는 MIT 라이선스의 오픈소스로 무료로 사용할 수 있습니다. 사용할 모델을 직접 설정하세요. 유료 서비스를 이용하는 경우 사용료는 공급자에게 직접 지불합니다.

모델 API 키는 시스템 키체인에 저장되며, 제공업체 요청은 Mac에서 사용자가 설정한 엔드포인트로 직접 전송됩니다. 음성은 Mac에서 transcribe.cpp + Qwen3-ASR-0.6B로 인식하므로
별도의 음성 API 키가 필요 없습니다. 다듬기와 번역은 텍스트 모델을 그대로 사용하며, 클라우드 텍스트 모델을 쓰는 경우 인식된 텍스트가 해당 제공업체로 전송됩니다.

## 다운로드와 설치

Apple Silicon Mac(macOS 14 이상)에서 [설치 파일을 다운로드](https://umuo.app/download/macos)하세요. `umuo-v<버전>.dmg`를 열고 umuo를 ‘응용 프로그램’ 폴더로 드래그합니다.

설치 파일은 아직 Apple 공증을 받지 않았습니다. 첫 실행이 차단되면 ‘시스템 설정 › 개인정보 보호 및 보안’에서 ‘그래도 열기’를 선택하세요. 설치 후에는 ‘설정 › 정보’에서 업데이트를 확인할 수 있습니다. 모든 설치 파일은 [GitHub Releases](https://github.com/youming-ai/umuo/releases)에서 받을 수 있습니다.

## 시작하기

### 모델 설정과 선택 번역

1. umuo를 열고 ‘설정 › 엔진’에서 공급자를 선택한 다음 API 키를 저장하세요. 로컬 모델을 사용한다면 엔드포인트와 모델 이름을 설정하세요.
2. ‘시스템 설정 › 개인정보 보호 및 보안 › 손쉬운 사용’에서 umuo를 허용하세요. 개발 빌드에서는 실행에 사용한 터미널이나 IDE를 허용하세요.
3. 다른 앱에서 텍스트를 선택하고 Control을 두 번 누르세요(`⌃⌃`). 포인터 근처 창에 번역이 차례로 표시됩니다.

### 음성 입력

아무 입력란에서나 **⌥⌘V**를 누른 채 말하고 손을 떼면, 매끄러운 문장으로 다듬어 입력란에 다시 써넣습니다. **⌃⌘V**를 누른 채 말하면 목표 언어로 번역해서 써넣습니다.
처음 사용할 때 마이크 권한을 요청하고 Hugging Face에서 약 560MB의 음성 인식 모델을 내려받습니다. 입력란에 다시 써넣는 데에도 손쉬운 사용 권한이 필요합니다.
두 단축키 모두 **Settings → Translation → Voice Input**(설정 → 번역 → 음성 입력)에서 바꿀 수 있습니다.

### PopClip

[PopClip](https://www.popclip.app/)(2024.12 이상)을 쓰고 있다면 `open scripts/popclip/umuo.popclipext`로 확장을 설치합니다.
이후 텍스트를 선택하고 PopClip 막대의 umuo 아이콘을 누르면 마우스 근처의 플로팅 창에 번역이 표시됩니다. 확장은 `umuo://translate?text=…`로 umuo를 호출하며, umuo는 PopClip에서 온 이 링크만 받습니다.

## 개인정보

- BYOK 모드에서 요청은 사용자가 직접 설정한 엔드포인트로만 전송됩니다. umuo 서버는 사용자의 콘텐츠도, API 키도 받지 않습니다.
- 번역 기록은 Mac의 SQLite에 저장되며, 검색·삭제할 수 있고 보존 기간을 설정하거나 완전히 끌 수도 있습니다.
- 음성은 Mac에서 인식합니다. 녹음은 임시 파일에만 기록되고 인식이 끝나거나 취소되면 즉시 삭제되며, umuo에도 모델 제공업체에도 전송되지 않습니다.
- 콘텐츠 원격 측정은 기본적으로 꺼져 있습니다.

## 소스에서 빌드

필요 사항: Apple Silicon Mac, macOS 14+, Xcode 26(또는 macOS 26 SDK가 포함된 Command Line Tools — 플로팅 창에 Liquid Glass를 사용합니다),
[rustup](https://rustup.rs)(Rust 버전은 `rust-toolchain.toml`로 고정되며 첫 빌드 때 자동 설치), [Bun](https://bun.sh) 1.4+(`package.json`의 `packageManager` 기준).

```bash
bun install          # 저장소 도구 스크립트 의존성
cargo fetch          # Rust 의존성

bun run dev:macos    # Rust 바인딩과 SwiftUI 클라이언트를 빌드한 뒤 실행(macOS 14+, Swift 6)
# 개발용 바이너리는 기본적으로 전역 단축키를 등록하지 않음. 다른 인스턴스를 먼저 종료한 뒤 bun run dev:macos --hotkeys 사용
```

## 개발 명령

| 명령 | 역할 |
| --- | --- |
| `bun run dev:macos` | SwiftUI 클라이언트를 컴파일하고 실행 |
| `bun run build` | Rust 바인딩과 네이티브 클라이언트 컴파일 |
| `bun run bundle:macos -- --version X.Y.Z` | Apple Silicon(arm64)용 `.app` / `.dmg` / `.app.tar.gz` 생성. Sparkle 공개 키 설정 필요, 업로드하지 않음 |
| `bun run icons` | 네이티브 앱 ICNS와 메뉴 막대 PNG 직접 생성 |
| `bun run lint` / `bun run format` | 도구 스크립트 Biome 검사 / 포맷 |
| `bun run type-check` | 도구 스크립트 TypeScript 타입 검사 |
| `bun run test:rust` | Rust workspace 단위 테스트와 파이프라인 회귀 테스트 |
| `bun run verify:macos` | Swift 빌드, Swift Testing, FFI 자체 점검, 패키징 스모크 테스트 |
| `bun run verify` | 커밋 전 전체 검사. GitHub Actions의 CI와 동일 |

## 저장소 구조

- [`apps/macos/`](../../apps/macos/) — macOS 네이티브 클라이언트, Swift 테스트 및 패키징 스크립트
- [`crates/`](../../crates/) — Rust 앱 로직, 번역 코어, SQLite 저장소 및 Swift 바인딩
- [`site/`](../../site/README.md) — 독립 Bun 프로젝트로 구성된 공식 웹사이트와 Cloudflare Worker
- [`scripts/`](../../scripts/) — 개발 도구, 음성 인식 평가 및 PopClip 확장
- [`docs/`](../../docs/README.md) — 프로젝트 문서, 릴리스 가이드 및 README 번역본

## 개발 문서

제품 요구사항, 아키텍처, 검수 현황 및 릴리스 절차는 [프로젝트 문서](../README.md)(중국어 간체)를 참고하세요.

공식 웹사이트 [umuo.app](https://umuo.app)(단일 페이지 홈)과 Worker는 [site/](../../site/)에 있으며, `main`에 병합되면 Cloudflare Workers Builds가 자동으로 배포합니다.

## 기여하기

Issue와 Pull Request를 환영합니다. 개발, 테스트 및 제출 절차는 [기여 가이드](../../CONTRIBUTING.md)를 참고하세요. 보안 취약점은 [비공개 신고 채널](../../SECURITY.md)로 제보해 주세요.

## 라이선스

[MIT](../../LICENSE). 저장소 전체(공식 웹사이트 `site/` 포함)에 적용됩니다. 「umuo」라는 이름과 수달 아이콘은 MIT 라이선스에 포함되지 않습니다. 수정판을 배포할 때는 다른 이름과 아이콘을 사용해 주세요. 작품이 umuo를 기반으로 한다고 밝히는 것은 제한하지 않습니다. 기여 방법은 [CONTRIBUTING.md](../../CONTRIBUTING.md)를 참고하세요. 참고하거나 재사용한 서드파티 구현은 [THIRD_PARTY_NOTICES](../../THIRD_PARTY_NOTICES)에 기록되어 있습니다.
