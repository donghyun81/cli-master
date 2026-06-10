# PLAN — MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-001 |
| Mode | M5 cli-infra-ops |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | cc-paste-MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-001.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 3 (master edit) + 5 자식 propagate (cycle-discipline.md byte-identical) |
| Modules | cli infra (`.claude/rules` + `.auto-memory` + `CLAUDE.md`) |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2~7. DependencyDecision / ArchitectureImpact / ModelBoundaryPlan / ErrorPolicy / UIStateFlowPlan / TestabilitySeams
- N/A (cli infra 문구 재보정 · 제품 코드/모델/테스트 무변경)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `ToolSearch query="pencil"`(self-validating 9/9) · `bash scripts/verify-sync.sh` · `git diff --stat` 보호 5 무변동 |

## 9. RollbackStrategy
- 문서/cli infra 전용: `git revert <commit>` 으로 즉시 복구 가능 (제품 코드 무접촉)

## 10. ExternalPrep / DeferredItems
- 광역 pencil stale sweep(보호 2 file + ux-auditor + reference docs + Path 2-A open_document) = 별 cycle `PENCIL-TOOLSET-REMOVAL-STALE-SWEEP`(가칭)
- `scripts/propagate.sh` 기존 dirty(run-* prune exclude) = 별 영역 · 본 cycle 무접촉

## Plan
1. Step 0 self-test (게이트 self-exception) — 9 종 verbatim + Pencil v1.1.62 캡처. [DONE]
2. Step 1 `cycle-discipline.md §13` item 3 재보정 (≥13 → 9 종 named-set 전수). [DONE]
3. Step 2 incident-log entry (PENCIL-MCP-TOOLSET-RECALIBRATE · master-only). [DONE]
4. Step 3 CLAUDE.md §15 1행. [DONE]
5. Step 4 self-test 재검증 (9 종 전수 → PASS · self-validating). [DONE]
6. Step 5 commit (3 file scoped) + propagate.sh cycle-discipline.md --targets all + verify-sync.sh.
7. Step 6 보호 5 sha drift 0 + 자식 5 byte-identical 확인.

## Notes
- 범위 가드: 보호 2 file(pencil-uiux-workflow.md / pencil-sot-policy.md) · ux-auditor · pencil-mcp-tools-reference · Path 2-A open_document 무접촉.
- propagate 는 `--prune` 미사용 (dirty propagate.sh 의 prune 코드 경로 inert).
