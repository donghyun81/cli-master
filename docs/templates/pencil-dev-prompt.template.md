# Pencil Dev Prompt — `<RepoName>`

> **template 출처**: master `docs/templates/pencil-dev-prompt.template.md`.
> **단일 목적**: Pencil 캔버스 작성 시 디자이너 / agent 가 참조하는 free-text 계약 (스펙 / 톤 / 근거).
> **연관**: `pencil-uiux-workflow.md` (Pencil 도구 바인딩) + `design-to-code-sync.md` (도구 무관 5-type IMPL).

## 1. 도메인 톤

- target audience: `<예: 30~40대 직장인>`
- 감성 키워드: `<예: 부드러움 / 따뜻함 / 회복>`
- 색감: light / dark 모두 지원

## 2. 디자인 토큰 (A-0)

`docs/design/pencil-exports/A-0_design_tokens/` 의 `pencil-vars-after.json` 참조.
색상 / typography / spacing 모두 토큰 inherit 의무.

## 3. 화면 별 [TARGET] 스펙

### A-1 `<screen 이름>`
- 목적: `<예: 첫 진입 인상>`
- 핵심 컴포넌트: `<list>`
- state: `<loading / loaded / error>`
- interaction: `<탭 / 스와이프 / ...>`
- 수용 기준: `<측정 가능한 조건>`

### A-2 `<screen 이름>`
(반복)

## 4. 변경 정책

[TARGET] → [LOCKED] 승격 = `design-sot-policy.md` §6 7 항목 모두 PASS 의무.
