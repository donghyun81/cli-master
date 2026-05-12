## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001 |
| Mode | cli infra ops |
| Workflow | collect → plan → implement → verify → review |
| Requirements Source | task prompt (MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 2 (master) + 3 (propagation) = 5 총 |
| Modules | cli infra (.claude/rules/) + CLAUDE.md L3 |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision
N/A

## 3. ArchitectureImpact
N/A — 신규 rule file 신설 + cross-reference 1줄 추가. 기존 구조 변경 없음.

## 4. ModelBoundaryPlan
N/A

## 5. ErrorPolicy
N/A

## 6. UIStateFlowPlan
N/A

## 7. TestabilitySeams
N/A

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/verify-sync.sh` + `shasum -a 256` 보호 파일 5종 |

## 9. RollbackStrategy
git revert cc64d75 으로 즉시 복구 가능. propagation은 자식 3 revert 필요.

## 10. ExternalPrep / DeferredItems
N/A

## Plan

1. 보호 파일 5종 SHA 사전 검증 (STOP gate)
2. `.claude/rules/terminology.md` 신설 (master)
3. `CLAUDE.md` L3 cross-reference 1줄 추가 (master만)
4. master commit
5. `bash scripts/propagate.sh .claude/rules/terminology.md --targets all`
6. 자식 3 (GB/GD/GT) git add + commit
7. `bash scripts/verify-sync.sh` PASS 확인
8. 보호 파일 5종 SHA 사후 재검증
9. 보고서 산출

## Notes
- CLAUDE.md cross-reference = master 만 (자식 CLAUDE.md 는 도메인 영역 · 수정 금지)
- legacy 268건 정정 = 절대 X (scope 외 · D 옵션 합리화)
