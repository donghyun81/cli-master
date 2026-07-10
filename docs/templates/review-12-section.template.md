# REVIEW.md 12-section 스키마 template

> **출처**: `reporting.md` §7 verbatim 이전 (= MASTER-CLI-CONTEXT-DIET-2-001 T3 · 2026-07-10). 형식 SoT = 본 file · `reporting.md` §7 = pointer. 판정 기준/블로커 SoT = `verification-and-review.md` (형식 vs 기준 분리 불변).
> **Read 시점**: Risk ≥ Medium cycle 만 (Low Risk = §1+§2+§11 3-section · UI 레이어 변경 시 §5+§14 추가).
> **N/A 처리 (T3 개정)**: N/A 섹션 = 말미 1줄 집계 허용 — 판단 의무 불변. PromptFit = 불변 의무.

---

## §7 REVIEW.md 형식 (12-section 정규 스키마)

> 각 섹션은 이름이 있는 독립 판정 영역이다. 해당 없으면 "N/A" 명시.

```markdown
## Technical Review

> **Risk 기반 경량화**: Low Risk task는 §1 Requirements Coverage, §2 Regression Risk, §11 Secrets Safety만 필수. **UI 레이어 변경(Screen/ViewModel/UiState 신규·수정) 포함 시 §5 Model Separation + §14 Design SoT Sync 추가 필수.** 나머지 N/A. Medium 이상은 전체 12-section 필수.

### 1. Requirements Coverage
- [ ] 요구사항 성공조건 충족: <근거 (CONFIRMED/INFERRED/UNKNOWN)>
- [ ] 성공 조건 항목별 대조: <확인>
- [ ] Intake normalization / pre-EVIDENCE 계약 존재: <확인 / N/A>

### 2. Regression Risk
- 변경 영향 범위: <확인>
- 회귀 위험 없음: <근거>

### 3. Architecture Integrity — SOLID
- SOLID 영향: <없음 / 단일 책임 위반 여부 / 과도한 추상화 여부>
- DTO·Entity·DomainModel·UiState 분리 유지: <확인>
- 오류 모델 선택 근거 명시: <N/A / 확인>

### 4. Architecture Integrity — Layer Boundaries
- 아키텍처 경계 준수: <확인>
- I2 불변 원칙 (domain→data import 금지): <N/A / 확인>
- 경계 매핑 위치 (Repository·UseCase·ViewModel 에서만): <N/A / 확인>

### 5. Model Separation
- UiState 가 DomainModel 과 분리됨: <N/A / 확인>
- UI 단방향 흐름 유지: <N/A / 확인>
- 경계 매핑 변환 위치: <N/A / 확인>

### 6. Dependency Governance
- libs.versions.toml 변경: <Yes/No>
- DependencyDecision 8개 항목 기술 여부: <N/A / PASS>
- 신규 의존성 승인: <N/A / PASS / FAIL>

### 7. TDD Evidence & Testability Seams
- FakeXxx 테스트 존재 또는 N/A 사유: <확인>
- StateFlow 테스트: <N/A / 존재>
- 심 기반 테스트 (clock·dispatcher·identity·logger·uuid): <N/A / 존재 / 연기 사유>

### 8. Error / Result Policy
- typed Result 사용 여부: <N/A / Yes>
- sealed 오류 모델: <N/A / 확인>
- 기존 코드 전면 교체 없음: <확인>

### 9. External Prep / Deferred Items
- user-prep TODO 또는 stub 처리: <N/A / 확인>
- 외부 의존으로 인한 UI 불변 상태 침해 없음: <확인>

### 10. DocSync
- 문서-구현 드리프트 없음: <확인>

### 11. Secrets Safety
- 시크릿 노출 없음: <시크릿 grep 결과> (스캔 범위: `.ai/reports/<taskId>/` 아래만 — product code 전체 스캔 아님 · 패턴 SoT = `safety-and-secrets.md` §시크릿 스캔 패턴)

### 12. Rollback Viability
- 롤백 지점 실행 가능성: <확인>
- 비가역 변경 없음: <확인>

### 13. Cleanup Governance
_code-level task에만 적용. ops-layer·조사형·문서형 task는 N/A 명시._
- Cleanup assessment 흔적 (EVIDENCE.md `## Cleanup Assessment` 섹션): <N/A / 확인 / 누락>
- 제거 판단 근거 충분성: <N/A / CONFIRMED / INFERRED / UNKNOWN>
- 핵심 경로 후보 task-level STOP 처리: <N/A / 없음 / 확인>
- code removal vs file deletion 구분 준수: <N/A / 확인>

### 14. Design SoT Sync
_UI visible-state(FULL) 변경 포함 task에만 적용. UI 무변경·ops-layer·문서형 task는 N/A 명시._
- 변경 화면 `.pen` + `.ui-spec.json` 선행/동반 refresh: <N/A / 확인 / 누락>
- 누락 시 `DESIGN-DEBT.md` 등재 (deferred lane): <N/A / 등재 / 미등재(WARN)>
- 출시 후 net-new visual 선행 의무 충족: <N/A / 확인 / 위반(release FAIL)>

## Findings
[근거 기반 판정. 근거 없으면 UNKNOWN.]

## Verdict
PASS / FAIL / PARTIAL

## Remaining Risks
[향후 주의사항 — 이유와 함께 명시]

---

## PromptFit

PromptFitScore:
PromptFitVerdict:
PromptFitBreakdown:
- Requirement Alignment: /25
- Scope Control: /20
- Evidence/Verify Quality: /20
- Risk/STOP Handling: /10
- Output Contract Compliance: /10
- Prompt Efficiency/Clarity: /15
PromptFitIssues:
-
PromptFitNextActions:
-
PromptFitConfidence:
```

