# Verification and Review Rules

> /verify 와 /review 단계의 상세 규칙.
> SOT: `CLAUDE.md` | 관련: `workflow-core.md`, `cycle-discipline.md`

---

## /verify 규칙

### 기본 원칙
- **0 command 금지**: 검증 명령 없이 VERIFY.md만 만드는 것은 허용되지 않는다
- 최소 1개 검증 명령을 실행하고 exit code를 기록한다
- 검증 명령은 PLAN.md의 VerifyCmds에 명시된 것을 우선 사용
- **명령 흔적 필수**: VERIFY.md 에 백틱 래핑 명령(테이블) 또는 `CMD:` 패턴(LOG) 이 1개 이상 있어야 한다 — 부재 시 VERIFY 미통과 (reviewer 판정 블로커 · 구 compound-lint 3b 검사 = deprecated · 도구 부재)
- **production 바인딩 실체 검증 의무** (DI / seam / 조합 루트 변경 시): "production 조합의 X 가 **실제로 무엇인지**" 를 검증 항목으로 둔다. 형태 2 가지 **모두** 요구:
  - **① identity assertion** — `assertSame(기대 인스턴스, 해석 결과)`. **타입 assertion 은 부족하다**: `assertTrue(x is EntitlementRepository)` 는 NoOp 기본값 부활을 **못 잡는다**(NoOp 도 같은 타입 · `FND-BILLING-SEAMS-S1-001` 실증). "무엇이 아닌지"(`assertNotSame` / `assertFalse(x is NoOpX)`)까지 명시.
  - **② 음성 대조(negative control)** — 가드를 **일부러 깨보고 FAIL 하는지** 확인한 흔적. 통과만 기록된 테스트는 **공허한 테스트와 구분되지 않는다** (`SELFWARD-ENTITLEMENT-WIRE-S0-001` / `SELFWARD-COMPOSITION-ROOT-S2-001` 실증 = 음성 대조 3/3 FAIL 확인).
  - 근거 정합: `code-principles.md` §2 암묵 기본값 금지 · `billing-rules.md` §1 명시 조합 paradigm (도구는 *structural presence* 만 본다).
- **실 데이터 검증 의무 (빈 계정 금지)** — 사용자 데이터를 **입력으로 쓰는 경로**(특히 유료·생성·AI)는 **실 데이터가 있는 계정**으로 검증한다. 빈 데이터로 도는 검증은 **데이터 의존 결함을 구조적으로 못 잡는다**(입력이 없으면 그 코드가 실행되지 않는다). 검증용 **seed 계정을 자산으로 유지**한다(1회성 계정 금지 · 재현 가능해야 한다).
  - 실측 근거: **F2** — 기록 **0건** 계정은 `200`, **실 기록** 계정은 `502`. 빈 계정만 쓴 탓에 "AI 기능이 **한 번도 작동한 적 없다**"는 사실이 **몇 달간** 검출되지 않았다.
- **성공 경로 관측 가능성 선행 의무** — **성공을 관측할 수 없으면 그에 의존하는 변경은 검증 불가**다. 성공/실패를 **원장(로그·계측)으로 가를 수 있게 만든 뒤에** 그 경로를 바꾼다(관측 → 변경 순서 · 역순 금지).
  - 실측 근거: 관측 확보(①)를 변경(②)보다 **먼저** 한 순서의 근거. ②가 같은 3 시도를 **성공 1 · 실패 2** 로 실제로 갈랐다 — 관측이 없었다면 어느 쪽도 증명 못 한다.
- **외부 응답 검증 실패 경로 = 진단 가능 로그 의무** — 외부(모델·서드파티) 응답의 검증/파싱이 실패하는 경로는 **① 분기 식별자**(어느 검증에서 떨어졌나) + **② 원문 발췌(상한 명시)** + **③ 에러 메시지** 를 남긴다. "실패했다"만 남는 로그는 **다음 cycle 에도 같은 미지**를 남긴다.
  - **마스킹 의무**: 발췌 대상 = **모델 출력 한정**. **사용자 원문 · 키 · 토큰 = 제외**(= `safety-and-secrets.md` §시크릿 기록 금지 정합 · 로그도 파일이다).
  - 실측 근거: **A1 로그 1개**가 F2 의 미지를 **한 cycle 안에** 닫았다 (그 전까지는 재현 자체가 불가능했다). EF 측 정착 = `supabase-handling.md` §11.
- **native `/verify` bundled skill (2026-05-27 · MASTER-CLI-NATIVE-RUN-VERIFY-SANDBOX-INTEGRATION-001)**: Anthropic v2.1.145+ 의 `/verify` 는 build + 실 앱 실행으로 코드 변경을 확인한다(test/type-check fallback 회피). manual 검증 명령(`./gradlew ...` + `adb ...`) 또는 `/verify` bundled skill 양쪽 사용 가능 — cli session 자율 · 단 "0 command 금지" 정합. 자식별 launch recipe = `.claude/skills/run-<name>/SKILL.md`(`/run-skill-generator` capture) · staging flavor 한정

### 검증 명령 실행 불가 시
불가피한 이유가 있으면:
1. UNKNOWN(사유) 명시
2. 제품 파일 변경 없이 STOP
3. 사용자에게 직접 실행 방법 안내

### VERIFY.md 필수 항목
- 실행된 명령과 인수
- 각 명령의 exit code
- 명령 stdout/stderr 핵심 내용
- UNKNOWN 항목 (검증 불가 사유)

### 허용 검증 명령 유형

| 유형 | 예시 |
|---|---|
| 정적 파일 확인 | `git diff -- <file>`, `grep -n <pattern> <file>` |
| Lint | `./gradlew ktlintCheck` (자식 product-layer warn-gate) |
| Git ignore 확인 | `git check-ignore -v <path>` |
| 빌드 (제품 변경 없는) | `./gradlew assembleDebug` (설정 변경 없을 때만) |
| 단위 테스트 | `./gradlew test` |

### 산출물·시크릿 검증 (권장 · 구 Compound Lint = deprecated)

> 구 compound-lint 도구 = 6-repo 부재 (deprecated · MASTER-CLI-COMPOUND-LINT-DEPRECATE-001). 검증 의무는 아래 실존 명령으로 수행한다.

```bash
ls .ai/reports/<taskId>/        # 산출물 존재 확인 (형식 SoT = reporting.md §1 표 대조)
grep -rEn 'AKIA[0-9A-Z]{16}|sk-[a-zA-Z0-9]{32,}|ghp_[a-zA-Z0-9]{36}|xox[baprs]-[0-9a-zA-Z-]+|ya29\.[a-zA-Z0-9._-]+|AIza[0-9A-Za-z_-]{35}' .ai/reports/<taskId>/
```
시크릿 grep (패턴 SoT = `safety-and-secrets.md` §시크릿 스캔 패턴): 무매치(exit 1) = PASS · 매치(exit 0) = FAIL (시크릿 감지 — 즉시 STOP)

---

## /review 규칙

### Risk 기반 리뷰 경량화
- **Low Risk**: VERIFY.md (빌드/테스트 통과 확인) + 3-section REVIEW (Requirements, Regression, Secrets). **UI 레이어 변경(Screen/ViewModel/UiState 신규·수정) 포함 시 §5 Model Separation 추가 필수** (= [`docs/agent/architecture/MODEL_SEPARATION.md`](../../docs/agent/architecture/MODEL_SEPARATION.md) 정합); **UI visible-state(FULL) 변경 포함 시 §14 Design SoT Sync 추가** (= `uiux-sot-refresh.md` "즉시 의무 vs Deferred" 분기 정합). PromptFit 선택.
- **Medium Risk**: 현행 12-section REVIEW + PromptFit 필수.
- **High Risk**: 12-section REVIEW + PromptFit + 독립 reviewer 실행 필수.

### 기본 원칙
- 근거 없는 단정 금지 (CONFIRMED / INFERRED / UNKNOWN으로 분류)
- VERIFY PASS 없이는 review를 PASS로 판정하지 않는다
- REVIEW.md 는 12-section 정규 스키마로 작성 (형식: `docs/rules/reporting.md` §7)

### REVIEW.md 12-section 체크리스트

| 섹션 | 판정 기준 | 블로커 |
|---|---|---|
| 1. Requirements Coverage | `.ai/tasks/<taskId>.md` 성공조건과 대조 | 블로커 |
| 2. Regression Risk | 변경 파일 영향 범위 검토 | 블로커 |
| 3. Architecture Integrity — SOLID | 단일 책임 위반·과도한 추상화 없음; DTO·Entity·DomainModel·UiState 분리 유지; 오류 모델 선택 근거 명시 | 블로커 |
| 4. Architecture Integrity — Layer Boundaries | domain→data import 없음(I2 불변 원칙); 경계 매핑이 Repository·UseCase·ViewModel 에서만; UiState 가 DomainModel 과 분리됨; **app/feature/platform 레이어가 정책 계산을 새로 소유하지 않음**; **동일 UI 개념이 단일 출처 모델 또는 단일 포매터 경로를 사용함(단일 출처 표시 규칙)**; **서버 부재 경로가 live implementation으로 기술되지 않음(UNKNOWN/DEFERRED/contract-only만 허용)** | 블로커 |
| 5. Model Separation | UiState 분리; UI 단방향 흐름; 경계 매핑 변환 위치 (해당 task 에 적용될 때) | 블로커 |
| 6. Dependency Governance | libs.versions.toml 변경 시 PLAN DependencyDecision 8개 항목 존재 (없으면 FAIL) | 블로커 |
| 7. TDD Evidence & Testability Seams | 기존: FakeXxx 존재 또는 N/A 사유; StateFlow 테스트; 심(clock·dispatcher·identity·logger·uuid) 테스트 또는 연기 사유. **DI/seam/조합 루트 변경 시: production 바인딩이 identity assertion(`assertSame`)으로 고정되고 음성 대조(가드를 깨보고 FAIL 확인) 흔적이 있음 — 타입 assertion 단독 = 미충족**(`/verify` §기본 원칙 "production 바인딩 실체 검증 의무" 정합). 테스트 전략 확장: 변경분 ROI-coverage(고위험 Auth/Billing/Data/Backend 우선) · 여러 경우 완전성(happy+경계+에러+해당 시 empty/null/동시성) · 피라미드/test size 적정성 (SoT = `docs/agent/architecture/TESTING_STRATEGY.md` §5·§6·§3 · enforce=warn · follow-up TODO 권장 · blocking gate 신설 X) | 비블로커 |
| 8. Error / Result Policy | typed Result/sealed 오류 모델 사용 여부; 기존 전면 교체 없음 (해당 task에 적용될 때) | 비블로커 |
| 9. External Prep / Deferred Items | user-prep TODO 또는 stub 처리; 외부 의존으로 UI 불변 상태 침해 없음 | 비블로커 |
| 10. DocSync | 문서-구현 드리프트 없음 | 비블로커 |
| 11. Secrets Safety | 시크릿 패턴 grep 결과 (패턴 SoT = `safety-and-secrets.md` §시크릿 스캔 패턴 · 구 compound-lint = deprecated) | 블로커 |
| 12. Rollback Viability | 롤백 지점 실행 가능성; 비가역 변경 없음 | 비블로커 |
| 13. Cleanup Governance | code-level task: EVIDENCE.md에 `## Cleanup Assessment` 존재; 제거 근거 충분성; 핵심 경로 STOP 처리; code removal vs file deletion 구분 준수. ops-layer·조사형·문서형 task: N/A | 비블로커 |
| 14. Design SoT Sync | UI visible-state(FULL) 변경 시 해당 화면 `.pen`+`.ui-spec.json` 선행/동반 refresh OR `DESIGN-DEBT.md` 등재(`uiux-sot-refresh.md` "즉시 의무 vs Deferred" 분기 정합); 출시 후 net-new visual 선행 누락 = 위반. UI visible-state 변경 무 = N/A | 비블로커 (release cycle = 아래 backstop 으로 hard FAIL 승격) |

추가 항목 (reviewer 수동 검사 · 구 compound-lint 별도 검사 = deprecated):
- PromptFit 섹션 존재: `REVIEW.md` 내 PromptFitScore, PromptFitBreakdown, PromptFitNextActions
- `.ai/promptfit/INDEX.md` 갱신: 해당 task 한 줄 append 여부

> **Release backstop (§14 enforce)**: release / production-push REVIEW cycle 한정 — 출시 대상 화면의 `DESIGN-DEBT.md` OPEN row = 0 이어야 PASS, else **FAIL (release cycle 한정 blocker)**. 매 cycle §14 = 비블로커(warn) 이나 release 게이트에서만 hard FAIL 로 승격 (= `design-to-code-sync.md` §10.2 backstop 정합 · `uiux-sot-refresh.md` 출시 backstop 정합 · blocking gate 신설 X · enforce=warn default + release 한정 backstop).

### Verdict 판정

| Verdict | 조건 |
|---|---|
| PASS | 모든 체크리스트 통과, 블로커 없음 |
| PARTIAL | 미완 항목이 있으나 핵심 기능은 충족, TODO로 추적 가능 |
| FAIL | 성공조건 미충족, 아키텍처 위배, 시크릿 노출 등 블로커 존재 |

FAIL / PARTIAL(블로커 있음) 시 → change-planner / system-architect 루프 재진입

---

## 루프 재진입 규칙

verifier 또는 reviewer가 reject 시:

1. reject 사유와 근거를 VERIFY.md 또는 REVIEW.md에 기록

### 에러 유형별 복구 경로

| 에러 유형 | 1차 복구 대상 | 최대 시도 | 초과 시 |
|---|---|---|---|
| 컴파일 실패 (빌드 에러) | implementer 즉시 수정 | 2 | STOP |
| 테스트 실패 (기존 테스트 깨짐) | change-planner 재계획 | 2 | STOP |
| 산출물 검증 FAIL (아티팩트 누락) | 누락 아티팩트 보충 후 재검증 | 1 | STOP |
| 시크릿 grep 매치 (시크릿 감지) | 즉시 STOP (재시도 없음) | 0 | STOP |
| REVIEW FAIL (블로커 항목) | change-planner / system-architect 루프 | 2 | STOP |
| REVIEW PARTIAL (비블로커 TODO) | TODO.md 기록 후 DONE 가능 | — | — |
| Context 고갈 (compaction 1회+) | HANDOFF.md 작성 → 새 세션 재진입 | 1 | STOP |
| 예상 외 파일 변경 발견 | 즉시 STOP (재시도 없음) | 0 | STOP |

- **컴파일 실패**: implementer가 에러 메시지 기반으로 직접 수정. change-planner 재호출 없이 빠른 수정.
- **테스트 실패**: 기존 테스트가 깨진 경우 회귀 위험이므로 change-planner가 영향 범위를 재평가.
- **아티팩트 누락**: 형식적 보충이므로 1회만 허용. 2회 누락이면 프로세스 문제로 STOP.
- **시크릿 감지 / 예상 외 변경**: 안전 위험이므로 자동 재시도 금지.

2. change-planner 또는 system-architect에게 위임 (intake-router 경유)
3. PLAN.md를 갱신하고 재구현
4. 재verify → 재review
5. 최대 2회 루프 후에도 FAIL이면 STOP → 사용자 판단 요청

---

## 검증 명령 LOG 형식

VERIFY.md 내 또는 `.ai/reports/<taskId>/LOG` 파일:

```
[LOG] 2026-MM-DD HH:MM KST
CMD: ls .ai/reports/SW-UI-001/
EXIT: 0
STDOUT: EVIDENCE.md PLAN.md VERIFY.md REVIEW.md TODO.md
```
