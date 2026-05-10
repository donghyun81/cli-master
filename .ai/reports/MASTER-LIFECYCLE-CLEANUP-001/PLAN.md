# PLAN — MASTER-LIFECYCLE-CLEANUP-001

## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-LIFECYCLE-CLEANUP-001 |
| Mode | ops-layer (lifecycle cleanup) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | Coin prompt 2026-05-10 (4 mitigation 영역) |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | master 8 + GB 1 (mv) |
| Modules | .auto-memory/ + .ai/reports/ + archive/ + GB cc-paste |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/verify-sync.sh` (exit 0 · 106/0/0) + `git log -1 --format=%s` 자기 검증 + `ls archive/2026-05/` GB 존재 검증 |

## Plan

1. **STEP 1**: master `.auto-memory/decision-log.md` MULTI-REPO-EDGEFN-VAULT-KEY-RENAME-001 entry append (single-line format · 2026-05-10).
2. **STEP 2**: `bash scripts/verify-sync.sh` — propagation-status.md Last verify-sync 자동 갱신.
3. **STEP 3**: master commit lifecycle cleanup (selective add: .auto-memory/ + .ai/reports/ 4 신설 + 2 audit modify + archive/. gradlew.bat 의도 제외).
4. **STEP 4**: GB `cc-paste-PHASE-2-ENTRY-GB-001.md` → `archive/2026-05/` mv + GB-CC-PASTE-ARCHIVE-001 commit (cc-paste-3REPO-AUDIT-ENTRY-001.md 영역 외).
5. **STEP 5**: self-verify per `cycle-discipline.md` §9 — protected 6 sha 변동 0 / decision-log entry 1+ hit / propagation-status 2026-05-10 hit / GB archive/2026-05/ 안 file 존재 + GB working tree 안 file 부재.

## Notes

- ops-layer 마감 cycle (보호 0 / 도메인 0 / 빌드 0).
- agent commit 자동 허용 영역 (cycle-discipline §5 v2 — chore/audit lifecycle).
