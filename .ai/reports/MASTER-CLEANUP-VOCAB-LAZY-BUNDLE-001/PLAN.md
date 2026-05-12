# PLAN — MASTER-CLEANUP-VOCAB-LAZY-BUNDLE-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLEANUP-VOCAB-LAZY-BUNDLE-001 |
| Mode | cleanup / docs (lightweight 4 file) |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | cycle prompt MASTER-CLEANUP-VOCAB-LAZY-BUNDLE-001 (TRAIL-4/5/8 묶음) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 3 modified + 2 dirs add + 4 자식 cp (TRAIL-4) |
| Modules | cli infra (.claude/rules/) + auto-memory + .ai/reports |
| Risk | Low (ops-layer · 도메인 코드 미변경) |
| DBMig | No |
| MoneyAuth | No |

## 2~9. N/A (cleanup 영역 · ops-layer · 의존성 변경 X)

## VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash .claude/hooks/post-edit-degeneration-check.sh <file>` × 3 file + `bash scripts/verify-sync.sh` |

## Plan

1. **TRAIL-4** = architecture-foundation-link-policy.md 본문 paraphrase (박-cluster 176→0) + 5-repo propagation (cp · master sha = 33c3b891e0fd2f29).
2. **TRAIL-5** = decision-log (박-cluster 50→0) + incident-log (박-cluster 20→0) paraphrase (master only · 자식 cp X).
3. **TRAIL-8** = 잔여 untracked 2 report 디렉터리 git add (MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001 + MULTI-REPO-RELEASE-LEDGER-INIT-001).
4. **검증** = hook self-test 3 file × exit 0 + verify-sync.sh 측 본 cycle 산출물 (architecture-foundation-link-policy.md) 5-repo PASS.
5. **commit** = master 1 commit (TRAIL-4 + TRAIL-5 + TRAIL-8 묶음) + 4 자식 commit (TRAIL-4 cp).
6. **사후** = incident-log entry append (본 cycle 마감 entry).

## 10. ExternalPrep / DeferredItems
- 외부 활성 trail 2 (CLI-VERSION-UNPIN-PROPAGATION-002 + MASTER-RELEASE-CHECKLIST-TEMPLATE-002) = 본 cycle scope 외 (별 cycle).
- verify-sync.sh exit 0 회복 = 외부 trail 2 마감 후 자연 달성 (사후 별 cycle).

## Notes
- text-degeneration-prevention.md §11 mitigation cycle 패턴 정합 (감지 → 분류 → 정정 → 재검증 → 기록).
- 표기 의미 정합 보존 의무 (= 13 architecture markdown 참조 의무 변경 X · auto-memory entry RCA 의미 변경 X).
- 보호 5 sha 변동 0 강제 (5b84cd9e4bc36165 / d3a0b57390bd0414 / e580b6d7ca9a88ae / 3a703b30553e0d09 / b27fbe16edb68821 그대로).
