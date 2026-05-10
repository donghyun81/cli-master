# REVIEW — GLOBAL-NO-ABBREV-POLICY-001 (Cycle 1/4)

> cycle ID: GLOBAL-NO-ABBREV-POLICY-001  
> date: 2026-05-10  
> scope: CLI infra SoT 신설 (no-abbreviation 정책 + PreToolUse hook) + 4-repo propagation

---

## Technical Review

> Risk: Low (ops-layer task · 제품 코드 미변경 · `NO_ABBREV_ENFORCE=warn` 기본)

### 1. Requirements Coverage
- [x] 3 rule 파일 신설 (no-abbreviation-policy.md · allowed-acronyms.md · forbidden-abbreviations.md): **CONFIRMED** (master 77ca613)
- [x] PreToolUse hook 신설 (check-abbreviation.sh): **CONFIRMED** (master 77ca613)
- [x] settings.json PreToolUse Edit|Write matcher 등록: **CONFIRMED** (`c777a494d5e7`)
- [x] 4-repo propagation: **CONFIRMED** (GB 628245f · GD 3a5b4ca · GT f4501d5)
- [x] verify-sync PASS 24/0/0: **CONFIRMED**
- [x] hook self-test 3 fixture PASS (warn mode): **CONFIRMED**
- [x] Intake normalization / pre-EVIDENCE 계약: N/A (ops-layer task, Plan Mode 진행)

### 2. Regression Risk
- 변경 영향 범위: cli infra 신설 5 파일. 보호 파일 4종 sha 변동 0. 제품 코드 미변경.
- 회귀 위험: `NO_ABBREV_ENFORCE=warn` 기본값 → exit 0 보장. 기존 hook (pre-tool-use.sh / post-policy-watch.sh / stop-gate.sh 등) 미변경. 기존 workflow 차단 위험 없음.

### 3. Architecture Integrity — SOLID
- SRP: check-abbreviation.sh = 단일 책임 (금지 약어 감지 + warn/enforce 출력). PASS.
- SOLID 위반: N/A (ops-layer · Kotlin 구조 없음)
- DTO/Entity/UiState 분리: N/A (ops-layer)
- 오류 모델: N/A

### 4. Architecture Integrity — Layer Boundaries
- cli infra 단방향 (master → 자식): CONFIRMED. 자식 repo 가 cli 직접 수정한 사항 없음.
- 보호 파일 변동 0: CONFIRMED.

### 5. Model Separation
- N/A (ops-layer task)

### 6. Dependency Governance
- libs.versions.toml 변경: No
- 외부 의존 신설: No (Python stdlib 만 사용 — os, json, re, sys)

### 7. TDD Evidence & Testability Seams
- hook self-test 3 fixture 실행 결과:
  - Fixture 1: `val btnClick` (src/TestScreen.kt) → `[NO-ABBREV:WARN] 1 hit(s)` (exit 0) ✓
  - Fixture 2: `val apiUrl` (src/ApiScreen.kt) → no output (exit 0) ✓
  - Fixture 3: `val buttonClickHandler` (src/ButtonScreen.kt) → no output (exit 0) ✓

### 8. Error / Result Policy
- N/A (ops-layer)

### 9. External Prep / Deferred Items
- Cycle 2 (GB): src/ 도메인 코드 forbidden 정정 (규모: 0 hits → 즉시 진입 가능)
- Cycle 3 (GD): src/ 도메인 코드 forbidden 정정 (규모: 0 hits → 즉시 진입 가능)
- Cycle 4 (GT): src/ 도메인 코드 forbidden 정정 (규모: ~4 real hits = ctx loop var) + enforce 모드 승격
- `NO_ABBREV_ENFORCE=enforce` 승격: Cycle 4 마감 시점 (GT 정정 완료 후)

### 10. DocSync
- CLAUDE.md §15 table: 갱신 예정 (본 REVIEW 직후)
- `.auto-memory/protected-file-hashes.md`: cli infra sha 추가 예정

### 11. Secrets Safety
- 시크릿 노출: 없음 (hook 은 JSON 입력 파싱만 수행 · 키/토큰 미접촉)

### 12. Rollback Viability
- `git revert 77ca613` (master) + 자식 3 repo 동일 — 즉시 복구 가능.
- 비가역 변경: 없음.

### 13. Cleanup Governance
- N/A (ops-layer task — 제품 코드 미변경)

---

## sha 정합 표 (5 파일 × 4 repo)

| 파일 | sha-256 prefix | master | GB | GD | GT |
|---|---|---|---|---|---|
| `no-abbreviation-policy.md` | `dc5432f6` | ✓ | ✓ | ✓ | ✓ |
| `allowed-acronyms.md` | `83b092e2` | ✓ | ✓ | ✓ | ✓ |
| `forbidden-abbreviations.md` | `82519940` | ✓ | ✓ | ✓ | ✓ |
| `check-abbreviation.sh` | `98d0a023` | ✓ | ✓ | ✓ | ✓ |
| `settings.json` | `c777a494` | ✓ | ✓ | ✓ | ✓ |

verify-sync: PASS — 24 파일, DRIFT 0, MISS 0

---

## forbidden hit count survey (Cycle 2~4 규모 추정)

| repo | src 경로 | 전체 hit 수 | real violations | false positive |
|---|---|---|---|---|
| GB | `app/src/main/` | 0 | 0 | 0 |
| GD | `app/src/main/` | 0 | 0 | 0 |
| GT | `app/src/main/` | 6 | 4 (`ctx` loop var × 4) | 2 (framework import `res`) |

**Cycle 2~4 scope 예측**:
- Cycle 2 (GB): skip 가능 또는 형식적 1 commit (0 violations)
- Cycle 3 (GD): skip 가능 또는 형식적 1 commit (0 violations)
- Cycle 4 (GT): `ctx` → `mealContext` 또는 의미있는 이름으로 4 line 정정 + enforce 모드 승격

---

## Findings

1. **CONFIRMED**: 5 파일 × 4 repo = 20 파일 sha 전수 일치. verify-sync PASS.
2. **CONFIRMED**: hook self-test 3 fixture 모두 warn 모드 exit 0 통과.
3. **CONFIRMED**: 보호 파일 4종 sha 변동 0 (cli infra 권장 파일 5종만 신설).
4. **CONFIRMED**: `NO_ABBREV_ENFORCE=warn` 기본값 → 기존 workflow 차단 없음.
5. **INFERRED**: GB/GD 의 forbidden 0 hits → Cycle 2/3 는 경량 (enforce 승격 준비 용 형식 cycle 가능).
6. **CONFIRMED**: GT 의 real 4 hits = `ctx` loop variable (DailyPrescriptionScreen.kt:194-198) → Cycle 4 에서 정정.

---

## Verdict

**PASS**

---

## Remaining Risks

- GT `ctx` loop var 4 개: Cycle 4 에서 정정 필요. warn 모드에서는 차단 없음.
- `NO_ABBREV_ENFORCE=enforce` 승격 시 기존 코드 잔존 forbidden token 이 있으면 Edit/Write 차단됨 — Cycle 4 정정 완료 확인 후 승격 의무.
- false positive 가능성: framework import (`ui.res.stringResource`) 의 `res` 매칭. 실제 hook 은 comment 인지 / 코드 식별자 인지를 line-level 로만 판단하므로 import 문 내 `res` 는 warn 출력될 수 있음 (차단 없음 · warn 모드). Cycle 4 이전에 `res` 를 FORBIDDEN_CHECK 에서 제외하거나 import 스킵 로직 추가 권장.

---

## PromptFit

PromptFitScore: N/A
PromptFitVerdict: N/A (ops-layer cycle — PromptFit 선택)
PromptFitBreakdown: N/A
PromptFitIssues: N/A
PromptFitNextActions: N/A
PromptFitConfidence: N/A
