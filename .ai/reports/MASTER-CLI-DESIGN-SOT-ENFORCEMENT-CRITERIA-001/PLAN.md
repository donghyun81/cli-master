# PLAN — MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001 (Mode M5)

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001 |
| Mode | M5 (cli-infra-ops) |
| Workflow | (cli-infra) edit 6 → manifest/§14a resync → propagate → verify-sync → §15 audit |
| Requirements Source | cc-paste-MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001.md §3 contract |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 6 rule/design (2 보호 + 4 cli-infra) + 2 master-only (manifest, CLAUDE.md) |
| Risk | Low (cli-infra · production 0 LOC · clarify+enforce) |
| DBMig | No |
| MoneyAuth | No |

## 2~7. (N/A — production code / 의존성 / 모델 / UI state / 테스트 변경 0)

## 8. VerificationPlan
- `propagate.sh --targets all` ok=N/0 · `verify-sync.sh` DRIFT 0 · 보호 5 6-repo byte-identical · 보호 2 manifest+§14a resync 일관.

## 9. RollbackStrategy
- git revert content `9e286138` + audit `5f415b0d` + 자식 5 commit. manifest/§14a 양층 동반 revert. 비가역 0.

## 10. ExternalPrep / DeferredItems
- per-repo `DESIGN-DEBT.md` 실 entry seeding = 후속 `3APP-AI-TIER-AD-GATE-DESIGN-RETROFIT-001` (본 cycle = rule/template/format SoT 만).

## Plan
1. 보호 2 (uiux split 표+게이트 재배선 · dsp §3 deferred 예외)
2. cli-infra 4 (design-to-code §10 lane+P11 · v&r §14 row+backstop · reporting §14 스키마 · rule-routing §C row2/row4+§F)
3. manifest sha-256 resync + §14a git-sha1 + §15 entry
4. content commit → propagate 6-repo → 자식 commit → verify-sync → audit commit
