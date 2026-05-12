# SSOT Principles — Single Source of Truth

> **목적**: 동일한 사실(fact)·정책·표현이 두 곳 이상에 살지 않도록 한다.
> **적용 범위**: 운영 레이어 문서, 제품 코드, UI 표시 텍스트, 정책 정의, 데이터 모델.

---

## 1. SSOT 위반의 비용

- 한쪽만 고치면 drift 가 발생한다 (운영 레이어 ↔ 제품 코드, ↔ 사용자에게 노출되는 텍스트)
- "어디가 진실인가" 를 매번 검색해야 한다
- review · audit 가 의미 없어진다 (어느 한쪽을 보고도 안전을 보장 못함)

---

## 2. 운영 레이어 SSOT 계층

| Source of Truth | 권한 |
|---|---|
| `CLAUDE.md` | 최상위 운영 헌법 — 모든 운영 규칙의 진입점 |
| `.claude/rules/**` | 세부 규칙 — `CLAUDE.md` 가 위임한 영역만 |
| `.claude/agents/**` | 역할 정의 — read-only / write 권한, 출력 형식 |
| `.claude/skills/**` | 유저 입력 → 워크플로 매핑 |
| `.claude/commands/**` | 슬래시 커맨드 — skill 없이 직접 호출하는 경로 |
| `docs/agent/architecture/**` | 아키텍처 공통 SoT (이 문서 포함) |
| `docs/agent/process/**` | 프로세스 워크플로 (intake / doc governance) |
| `docs/agent/solutions/**` | 운영 솔루션 (PromptFit rubric 등) |
| `.ai/tasks/<taskId>.md` | task 자체 (불변) |
| `.ai/reports/<taskId>/**` | 단계별 산출물 — 사후 분석 가능 |

각 레이어는 자신보다 상위 SoT 를 참조만 하며, 동일 사실을 복제하지 않는다.

---

## 3. 제품 코드 SSOT 원칙

### 3.1 단일 출처 표시 규칙

동일한 UI 개념(예: 사용자 표시명, 상태 라벨, 카운트)이 두 화면에 등장한다면:
- **단일 출처 모델** 또는 **단일 포매터 경로** 를 통과해야 한다
- 두 화면이 각자 포매팅하는 패턴 금지
- review 단계에서 "Architecture Integrity — Layer Boundaries" 블로커로 검사

### 3.2 정책 계산의 위치

- 비즈니스 정책 계산은 `shared/domain` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/)) 또는 동등한 domain layer 에서만
- `app/`, `feature/`, `platform/` 레이어가 정책 계산을 새로 소유하면 review FAIL

### 3.3 라우트·문구·리소스

- 라우트 정의: `AppRoutes.kt` 또는 동등한 단일 파일
- 사용자 노출 텍스트: `strings.xml` (Android), `Localizable.strings` (iOS)
- 색상·치수 토큰: design system 단일 출처

---

## 4. 운영 레이어 ↔ 제품 코드 경계

운영 레이어는 제품 코드의 **기준선** 역할만 한다. 제품 컨텍스트(앱 이름, 도메인 정책, 결제 모델, AI 정책 등)는 운영 레이어에 침투 금지.

| 사실 | SoT |
|---|---|
| "이 앱이 어떤 정책을 따르는가" | `docs/<product-overview>.md` (제품 레이어) |
| "어떻게 검증하고 리뷰하는가" | `.claude/rules/`, `.claude/agents/` (운영 레이어) |
| "오류를 어떻게 모델링하는가" | `docs/agent/architecture/ERROR_RESULT_POLICY.md` (운영 레이어 — 모든 레포 공통) |

---

## 5. Drift 감지

| 종류 | 감지 도구 |
|---|---|
| 운영 레이어 drift (SteadyWell ↔ targets) | 정기 audit + `/fulfill-doc-governance` |
| 문서 ↔ 코드 drift | `docs-drift-auditor` (read-only) |
| 동일 UI 개념 중복 표시 | reviewer Architecture Integrity — Layer Boundaries 체크 |
| 정책 계산 위치 위반 | reviewer Architecture Integrity — Layer Boundaries 체크 |

---

## 6. 관련 문서

- `COMMON_ARCHITECTURE.md` — 운영 레이어 vs 제품 레이어 경계
- `MODEL_SEPARATION.md` — 모델 SoT 분리
- `.claude/rules/verification-and-review.md` — 12-section 체크리스트
