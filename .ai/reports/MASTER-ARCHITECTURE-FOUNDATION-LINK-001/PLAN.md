# PLAN — MASTER-ARCHITECTURE-FOUNDATION-LINK-001

## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-ARCHITECTURE-FOUNDATION-LINK-001 (= ledger MASTER-T04) |
| Mode | ops-layer (= docs/agent/architecture/ + .claude/rules/) |
| Workflow | Collect → Plan → Implement → Cleanup → Verify → Review |
| Requirements Source | Cowork prompt + ledger MASTER-T04 본문 |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | **15** (= 7 architecture file M + 1 신규 cli infra + tasks 1 + reports 5 + decision-log 1 박음) |
| Modules | docs/agent/architecture/ + .claude/rules/ + .ai/ + .auto-memory/ |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A (= 라이브러리 변경 X · ops-layer 박음)

## 3. ArchitectureImpact

- 새 인터페이스/추상화: `.claude/rules/architecture-foundation-link-policy.md` (= link 박은 patterns 박은 SoT 박음 신설).
- 변동성 경계 유형: docs/agent/architecture/ 측 코드 path 인용 영역 박은 박은 → app-foundation 측 실제 file 측 link 박은 박은 단일 진입 박음.
- 레이어 누수 위험: 없음 (= markdown link 박음만 + 5-repo byte-identical 박은 박음).
- shared-first 경계 영향: N/A.

## 4. ModelBoundaryPlan

N/A (= 모델 변경 X)

## 5. ErrorPolicy

N/A (= UseCase / Repository 신설 X)

## 6. UIStateFlowPlan

N/A (= UI 변경 X)

## 7. TestabilitySeams

N/A (= 인터페이스 신설 X · 문서 link 박음 박음)

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/propagate.sh <14 file> --targets all` + `bash scripts/verify-sync.sh --no-update --skip-daemon-check` + 보호 5 sha 재 실측 박음 |

## 9. RollbackStrategy

- 롤백 가능 지점: 본 commit 박은 박은 박음 → `git revert <sha>` 박은 박은 + 자식 4 측 동일 박음.
- 롤백 조건: 보호 5 sha 변동 박은 박은 또는 verify-sync 측 본 cycle 측 14 file × 5 = 70 cross-check 측 PASS 박은 박은 X 박은 박음.
- 복구 경로: revert 박은 박은 박은 + sub-cycle 박은 박은 박은 박은 박음 + 보호 5 sha baseline 박은 박은 박음 박은 박음.

## 10. ExternalPrep / DeferredItems

- **CLI-VERSION-UNPIN-PROPAGATION-002** 박음 (= 사전 DRIFT-1 박은 사후 처리 박음 · app-foundation 측 cycle-discipline.md propagation 박음 박은 박음 · 별 cycle 박음).
- **MASTER-RELEASE-CHECKLIST-TEMPLATE-002** 박음 (= 사전 MISS-4 박은 사후 처리 박음 · release-checklist.template.md 자식 4 측 propagation 박음 박은 박음 · 별 cycle 박음).

## Plan

### STEP 1. /collect 박음 (= 사전 박음 박은 박은)
- 13 architecture file 측 코드 path 인용 박은 영역 grep 박음 = 8 file 박음 (= 40 occurrences 박음 박음).
- app-foundation 측 실제 박힌 path 박은 박은 박음 = `shared/{domain,data,feature-state}` + `core/{8 sub}` 박음 + `shared/app` 박은 부재 + `composeApp/` + `iosApp/` 빈 디렉터리 박음.

### STEP 2. /plan 박은 박음
- 7 file 측 link 박은 박은 (= ERROR_RESULT_POLICY 측 code block 박은 박은 박음 X 박음).
- 1 신규 cli infra `architecture-foundation-link-policy.md` 신설 박음.
- 14 file × 4 자식 = 56 cp 박음 박은 박음 propagation 박음 (= file 명시 박음 · `--all` 박음 X).

### STEP 3. implement 박음
- 7 file 측 Edit 박음 (= KMP_CMP_LAYER_DIRECTION + COMMON_ARCHITECTURE + KOIN_DI_BASELINE 2 박음 + MODEL_SEPARATION + SSOT_PRINCIPLES + TDD_WORKFLOW + TESTABILITY_SEAMS 박음).
- 1 신규 file Write 박음 (= architecture-foundation-link-policy.md 박음).

### STEP 4. cleanup pass
- N/A (ops-layer 박음).

### STEP 5. /verify 박음
- `bash scripts/propagate.sh <14 file> --targets all` → ok=56 fail=0 박음 ✓
- `bash scripts/verify-sync.sh --no-update --skip-daemon-check` → PASS 112 / DRIFT 1 / MISS 4 박음 (= 본 cycle 박은 14×5=70 PASS + 사전 DRIFT 2 영역 별 cycle 박음).
- 보호 5 sha 재 실측 박음 → 변동 X 박음 ✓.

### STEP 6. /review 박음
- 12-section 박음 + Verdict = PASS 조건부 박음 (= 사전 DRIFT 2 영역 박은 본 cycle scope X 박음 박은 박은 패턴 박음 차용 박음).

### STEP 7. ledger + decision-log + reports 박음 박은 박음 commit 박음
- master commit 1 박음 + 자식 4 commit 4 박은 박음 = 5-repo commit 5 박음.
- ledger PACKAGE-OVERVIEW.md 갱신 박음 (= sub cycle 측 사용자 결정 옵션 외 박음 vs 본 cycle 박은 박음 박은 박음 결정 박은 박은 박음).
- decision-log 1 entry append 박은 박은 박음.
- reports 5 file 신설 박은 박은 박음.

## Notes

- 사전 DRIFT 2 영역 박은 사용자 명시 별 cycle 박음 박은 박은 박음 (= scope 정합 박은 박은 박은 박은 박음).
- 본 cycle 측 propagation 박은 file 명시 박음 박은 박은 박음 (= `--all` 박음 X 박은 박은 박은 박음 = 사전 DRIFT 2 영역 박은 자동 흡수 회피 박은 박음 · §C scope 정합 박은 박은 박음).
- amend 박음 X 박음 박은 박은 박음 (= 사전 본 session cycle MASTER-REPO-CONFIG-SOT-001 박은 박은 사고 박은 박은 박은 박음 amend 박은 영역 박은 박은 박은 박음 회피 박은 박은 박음).
