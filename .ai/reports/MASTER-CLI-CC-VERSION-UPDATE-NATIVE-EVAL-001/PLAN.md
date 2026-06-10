# PLAN — MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001 |
| Mode | M5 cli-infra-ops |
| Workflow | (cli-infra) measure → edit → commit → propagate → verify → audit |
| Requirements Source | cc-paste-MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 3 master (cycle-discipline.md §13 · incident-log.md · CLAUDE.md §15) + propagate ×5 자식 |
| Modules | cli infra (`.claude/rules/` + `.auto-memory/` + master CLAUDE.md) |
| Risk | Low (cli-infra ops · production 무접촉) |
| DBMig | No |
| MoneyAuth | No |

## 2~7. (N/A — cli-infra ops · production code 무접촉)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `claude --version` + `claude mcp list` + ToolSearch pencil (self-test 3) · `bash scripts/propagate.sh .claude/rules/cycle-discipline.md --targets all` · `bash scripts/verify-sync.sh` · `shasum -a 256` 보호 5 |

## 9. RollbackStrategy
- 문서 전용 cli-infra 변경. `git revert <commit>` 으로 즉시 복구 가능 (master + 자식별).

## 10. ExternalPrep / DeferredItems
- npm `@latest` 능동 갱신 = 진입 시점 이미 2.1.170 (= npm latest) = no-op 확인. 별 install action 불요.

## Plan
1. §0 baseline 재측정 + 보호 sha 재baseline (drift 시 STOP).
2. D-1 진단 (version / npm 경로 / `claude update` 이중 차단 = 정상).
3. 교정 = no-op (이미 latest) → D-2 self-test 3/3.
4. #60956 live GitHub verify (§3 calibration · Coin 인가).
5. §13 native installer 재검토 trigger 블록 신설 (live 줄번호 재유도).
6. incident-log 2 trail entry (LATEST-CHASE PASS + NATIVE-MIGRATION-EVAL) + §15 1행.
7. commit (path-limited) → propagate → child commit (path-limited) → verify-sync → audit.

## Notes
- self-re-anchor: paste baseline `424644…` → 진입 `157a2c5` → 실행 중 `fc51d04` (2회 re-drift · PENCIL-PHASE-B 완결 cycle · orthogonal).
- self-test 게이트 = 9종 named-set (PENCIL-SELFTEST-GATE-RECALIBRATE baseline · paste 의 ≥13 = stale 정정).
