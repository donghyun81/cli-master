# PLAN — MASTER-REPO-CONFIG-SOT-001

## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-REPO-CONFIG-SOT-001 (= ledger MASTER-T05) |
| Mode | ops-layer (scripts/ 측 SoT 통합) |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | Cowork prompt + ledger MASTER-T05 본문 |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 7 (scripts/repo-config.sh 신설 1 + propagate.sh / verify-sync.sh / ensure-child-gitignore-patches.sh 갱신 3 + PACKAGE-OVERVIEW.md 갱신 1 + decision-log.md append 1 + reports 4 file × 1 디렉터리) |
| Modules | scripts/ + docs/release-readiness/ + .auto-memory/ + .ai/reports/ |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A (라이브러리 변경 X · ops-layer)

## 3. ArchitectureImpact

- 새 인터페이스/추상화: `scripts/repo-config.sh` (POSIX-bash sourceable 변수 SoT) — 변동성 경계 = scripts/ 측 propagation 도구 측 단일 진입점
- 변동성 경계 유형: 본 file = "repo-list" + "protected-file-list" 두 영역 측 SoT 단일화
- 레이어 누수 위험: 없음 (3 script 측 source 의존 단순 추가)
- shared-first 경계 영향: N/A

## 4. ModelBoundaryPlan

N/A (모델 변경 X)

## 5. ErrorPolicy

N/A (UseCase / Repository 신설 X)

## 6. UIStateFlowPlan

N/A (UI 변경 X)

## 7. TestabilitySeams

N/A (인터페이스 주입 X · sourceable 변수 file)

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | `bash -n scripts/repo-config.sh` + `bash -c '. scripts/repo-config.sh && echo "$TARGET_REPOS" && echo "${#PROTECTED_FILES[@]}"'` + `bash scripts/ensure-child-gitignore-patches.sh --verify` + `bash scripts/verify-sync.sh --no-update --skip-daemon-check` |

## 9. RollbackStrategy

- 롤백 가능 지점: 본 commit `git revert <sha>`
- 롤백 조건: verify-sync.sh exit ≠ 0 또는 보호 5 sha 변동 발견
- 복구 경로: revert 후 사전 dirty 영역 (PACKAGE-OVERVIEW.md §1 baseline 정정) 측 별도 commit 분리

## 10. ExternalPrep / DeferredItems

N/A

## Plan

### STEP 1. scripts/repo-config.sh 신설

- bash shebang + 본문 export 변수 + PROTECTED_FILES array (5 종 path)
- 환경 변수 override 가능 patterns (`: "${PARENT_DIR:=...}"` 측 default)
- chmod +x

### STEP 2. 3 script 측 source 통합

- `propagate.sh`: 기존 `: "${PARENT_DIR:=...}"` 측 3 줄 → `. "$SCRIPT_DIR/repo-config.sh"` 측 1 묶음
- `verify-sync.sh`: 동일 patterns
- `ensure-child-gitignore-patches.sh`: 동일 patterns + drift 정정 흡수 (3→4 repo 자동)

### STEP 3. PACKAGE-OVERVIEW.md 갱신

- §3 MASTER-T05 row: ☐ → ✓ + sha placeholder (`<TBD-AMEND>` · commit 후 amend) + 본심
- §1 progress: master `2/8` → `3/8` + T01/T02/T05 ✓ 박음

### STEP 4. decision-log.md append

- 1 entry 단일 라인 patterns (최근 patterns 차용)

### STEP 5. .ai/reports/MASTER-REPO-CONFIG-SOT-001/ 4 file 신설

- EVIDENCE.md / PLAN.md / VERIFY.md / REVIEW.md (PASS)

### STEP 6. stage + commit (1 commit)

- stage 영역 = 본 cycle 변경 영역만 (사전 dirty .ai/reports/ 측 2 디렉터리 stage X)
- commit subject = `chore(ops): MASTER-REPO-CONFIG-SOT-001 add repo-config.sh single SoT + drift mitigation (ensure-child-gitignore +app-foundation)`
- commit body = 6 섹션 ([Goal] [Diff] [Sha] [EC] [Next] [Refs])

### STEP 7. commit 후 amend (sha 갱신)

- commit sha 12자 추출
- PACKAGE-OVERVIEW.md ledger sha column + decision-log.md sha column 갱신 (`<TBD-AMEND>` → 12자)
- `git commit --amend --no-edit` 박음 (1 commit 유지)

### STEP 8. verify-sync.sh 재실행 (commit 후)

- exit 0 의무 + 보호 5 sha 변동 X 박음

## Notes

- 사전 dirty `PACKAGE-OVERVIEW.md` §1 baseline 정정 = 본 cycle 흡수 (§1 progress 갱신 정합 영역).
- 사전 dirty `.ai/reports/MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001/` + `MULTI-REPO-RELEASE-LEDGER-INIT-001/` = 본 cycle stage X (별 cycle 측 영역).
- amend 채택 사유 = ledger sha column self-reference 영역 + 1 commit 의무 (cycle-discipline §6).
