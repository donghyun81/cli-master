# PLAN — MASTER-CLI-CLEANUP-7CYCLE-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-CLEANUP-7CYCLE-001 |
| Mode | cleanup (= cli infra 통합 cycle default · 7 sub-cycle SEVERE 4 + MEDIUM 3) |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | `cc-paste-MASTER-CLI-CLEANUP-7CYCLE-001.md` + `cowork-cli-cleanup-audit-20260521.md` |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 30+ (= 본 cycle 마감 default · SEVERE 16 + MEDIUM 8 + propagation overhead) |
| Modules | `.claude/rules/` + `.claude/hooks/` + `.claude/agents/active/` + `scripts/` + `docs/agent/architecture/` + `docs/guides/` + `CLAUDE.md` |
| Risk | Low (= cli infra 본문 정정 default · 의미 변경 X · 본문 통합 default · 본질 정합 default) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision
N/A (= 신규 의존성 X default)

## 3. ArchitectureImpact
N/A (= cli infra 본문 정정 default · 새 추상화 X)

## 4. ModelBoundaryPlan
N/A (= 도메인 코드 무접촉 default)

## 5. ErrorPolicy
N/A (= 새 UseCase X default)

## 6. UIStateFlowPlan
N/A (= UI 영역 무접촉 default)

## 7. TestabilitySeams
N/A · 단 hook self-test 의무 default (= check-abbreviation.sh 7 fixture + post-edit-degeneration-check.sh self-test paradigm 정합 default)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/verify-sync.sh --skip-daemon-check` (= 5-repo byte-identical 정합 검증) + hook self-test |

## 9. RollbackStrategy
- 롤백 가능 지점: 본 cycle 측 7 commit + 1 propagate.sh compat fix = 8 commit default · 각 commit 단위 `git revert <commit>` default 가능 default
- 롤백 조건: 본 cycle 마감 후 mismatch 발견 또는 사용자 회수 default
- 복구 경로: 직전 master HEAD = `26121e5df63b` (= paste source §0 baseline default)

## 10. ExternalPrep / DeferredItems
| 후속 영역 | 본질 |
|---|---|
| `MASTER-CLI-PROTECTED-FILE-CITATION-FIX-001` 가칭 | `pencil-uiux-workflow.md` line 12 측 save-as-result-check.sh 인용 path mismatch mitigation default |
| `MASTER-CLI-SOT-CODE-NAME-MAP-TODO-CLOSE-NNN` 가칭 | sot-code-name-map.md TODO row 2 (= GB paywall + GD TicketScreen) chat A baseline 마감 후 갱신 default |

## Plan

1. ✓ S1 abbreviation triad merge (3 file → abbreviation-policy.md · check-abbreviation.sh + post-edit-degeneration-check.sh + text-degeneration-prevention.md + terminology.md 인용 갱신)
2. ✓ S2 propagation scope stale 일괄 정정 (9 file 본문 측 "3/4-repo" → "5-repo")
3. ✓ S3 routing path fix + domain-roles.md `.claude/agents/active/` → `.claude/rules/` rename (= intake-router.md + PROPAGATION_PARAMETERS.md 인용 갱신)
4. ✓ S4 save-as-result-check.sh `.claude/hooks/` → `scripts/` rename (= pencil-automation.md + design-to-code-sync.md 인용 갱신)
5. ✓ M1 report-paths + report-formats merge → reporting.md (= 9 file 인용 갱신)
6. ✓ M2 = no-op finding (= 분석 baseline 측 가정 X default · paradigm B 정합 default)
7. ✓ M3 stale + orphan cleanup (= ui-ux-analysis.md + reporting.md §1 pointer · sot-code-name-map.md 무접촉 default)
8. ✓ propagation (= `propagate.sh --all` + `--prune --apply` + `verify-sync.sh PASS`) + master CLAUDE.md §15 entry append + REPORT.md 신설 + 4-file 산출물 + paste-back 본문 출력

## Notes
- `[agent-commit: yes]` 묵시 동의 default (= cycle-discipline.md §5 v2 + paste source §7.10 정합 default)
- §FREEDOM 광범위 위임 default (= paste source §5 정합 default)
- 보호 5 file sha drift X default (= 사용자 본심 paradigm B 정합 default · paste source §5 정합 default)
- M2 paradigm 결정 = AskUserQuestion 1 회 default (= paste source §6 STOP #4 정합 default · 사용자 본심 paradigm B 정합 default)
