# PLAN — MASTER-CLI-PROPAGATE-BASELINE-DYNAMIC-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-PROPAGATE-BASELINE-DYNAMIC-001 |
| Mode | M5 cli-infra-ops |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cc-paste-MASTER-CLI-PROPAGATE-BASELINE-DYNAMIC-001.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 1 (propagation 대상 scripts/propagate.sh) + CLAUDE.md §15 (master only) |
| Modules | cli infra (scripts/) |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2~7. (N/A — ops-layer · production code 무접촉)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash -n propagate.sh` · stale 4 sha grep=0 · `bash scripts/propagate.sh <file>` WARN noise=0 · `bash scripts/verify-sync.sh` |

## 9. RollbackStrategy
- git revert a65189a (master) + 자식 4 revert. 비가역 영역 0 (script 거동 무변동 · noise 만 제거).

## 10. ExternalPrep / DeferredItems
- N/A

## Plan
1. propagate.sh L221-236 EXPECTED_BASELINE stale-hardcode heredoc 제거 → manifest 동적 parse.
2. ACTUAL loop 4→5 file (design-sot-policy.md 추가) · 명시적 5-file list (verify-sync.sh PROTECTED 정합).
3. comment 4종→5종 · WARN-only non-blocking 보존.
4. master commit → propagate (= WARN noise 0 self-test) → 4 child commit → verify-sync → §15 audit.

## Notes
- HOW 결정 (§5 §FREEDOM): 명시적 5-file list 채택 (= verify-sync.sh sibling 의 `PROTECTED=(...)` house style 정합 + §7.3 literal grep design-sot-policy 만족 + umbrella §4.2 정합). repo-config.sh PROTECTED_FILES array 대안 검토했으나 sibling house style = script별 explicit local list 이므로 일관성 우선.
- sha 만 manifest 동적 (= 실 stale bug) · file list 는 explicit (= 안정 식별자 · sibling 정합).
- `|| true` defensive: set -euo pipefail 하 grep no-match 시 set-e trip 방지 → WARN-only 보존.
