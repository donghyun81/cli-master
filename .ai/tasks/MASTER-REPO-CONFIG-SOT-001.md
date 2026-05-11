# MASTER-REPO-CONFIG-SOT-001 (= ledger MASTER-T05)

## Meta

| 항목 | 값 |
|---|---|
| TaskId | MASTER-REPO-CONFIG-SOT-001 |
| Ledger ID | MASTER-T05 |
| Created (KST) | 2026-05-11 |
| Status | DONE |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |
| Mode | ops-layer (scripts/ 측 SoT 통합) |

## 원문 요구사항

Cowork prompt — ledger MASTER-T05 본문 = "`repo-config.sh` 의 `PROTECTED_FILES` / `CHILD_REPOS` 갱신 · 의도 = propagation 의 export 변수 SoT".

## 분해된 문제 진술

1. `scripts/repo-config.sh` 자체 부재 (= 본 cycle 신설 의제).
2. 3 script (`propagate.sh` / `verify-sync.sh` / `ensure-child-gitignore-patches.sh`) 측 TARGET_REPOS literal default 박음 = export 변수 SoT 분산.
3. `ensure-child-gitignore-patches.sh` 측 app-foundation 미포함 (drift 영역).

## 성공 조건

- `scripts/repo-config.sh` 신설 (TARGET_REPOS 4-repo + PROTECTED_FILES 5종 + PARENT_DIR/MASTER_DIR export).
- 3 script 측 `source` 단일 SoT 통합 (literal default 박음 폐기).
- `ensure-child-gitignore-patches.sh` 측 drift 정정 (3→4 repo 자동 흡수).
- `decision-log.md` 1 entry append + `.ai/reports/MASTER-REPO-CONFIG-SOT-001/` 4 file (PLAN/EVIDENCE/VERIFY/REVIEW PASS).
- `verify-sync.sh` exit 0 + 보호 5 sha 변동 X 박음.

## Measurable Exit Criteria

- [x] `bash -n scripts/repo-config.sh && bash -n scripts/propagate.sh && bash -n scripts/verify-sync.sh && bash -n scripts/ensure-child-gitignore-patches.sh` — exit 0 (syntax OK × 4)
- [x] `bash -c '. scripts/repo-config.sh && echo $TARGET_REPOS'` = `GentlyBreath GentlyDay GentlyTable app-foundation`
- [x] `bash -c '. scripts/repo-config.sh && echo ${#PROTECTED_FILES[@]}'` = `5`
- [x] `bash scripts/ensure-child-gitignore-patches.sh --verify` — 적용 4 / 미적용 0 (exit 0)
- [x] `bash scripts/verify-sync.sh --no-update --skip-daemon-check` — PASS 112/0/0 (exit 0)
- [x] 보호 5 sha (`f1edd397` / `ee377dc2` / `e5e3fe16` / `7621013e` / `96de2f5d`) 변동 0

## 비기능 요구사항

- bash 3.x 호환 (macOS default · `safety-and-secrets.md` §macOS bash3 정합).
- POSIX-bash sourceable file (3 script 측 source 측 단일 진입점).
- 사용자 환경 측 PARENT_DIR / MASTER_DIR / TARGET_REPOS env override 가능.

## 불확실성 (UNKNOWN)

없음 — baseline 모두 일치 + 본 cycle scope 명확.

## 산출물

- `scripts/repo-config.sh` (40 line · sha `7b235ab3ea18`)
- `scripts/propagate.sh` (M · source 통합)
- `scripts/verify-sync.sh` (M · source 통합)
- `scripts/ensure-child-gitignore-patches.sh` (M · source 통합 + drift 정정)
- `.auto-memory/decision-log.md` (append 1 entry)
- `.ai/reports/MASTER-REPO-CONFIG-SOT-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md`

## skip 영역 (본 cycle scope X · 사용자 결정)

- `docs/release-readiness/PACKAGE-OVERVIEW.md` — 병렬 cycle (MASTER-RELEASE-CHECKLIST-TEMPLATE-001) 측 mixed 영역 + 본 cycle T05 ✓ 갱신 = Cowork Edit 측 별 처리 (옵션 C revert X · 별 cycle 측 갱신).
- 병렬 cycle 측 산출 (`docs/templates/release-checklist.template.md` + `.ai/reports/MASTER-RELEASE-CHECKLIST-TEMPLATE-001/` + `.ai/tasks/MASTER-RELEASE-CHECKLIST-TEMPLATE-001.md`) — 별 cycle 측 commit.
- 사전 dirty (`.ai/reports/MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001/` + `.ai/reports/MULTI-REPO-RELEASE-LEDGER-INIT-001/`) — 별 cycle 측 commit.
