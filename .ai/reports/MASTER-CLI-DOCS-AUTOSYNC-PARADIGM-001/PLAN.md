# PLAN — MASTER-CLI-DOCS-AUTOSYNC-PARADIGM-001

> master cli infra cycle · DocSync paradigm SoT 강화 + 자식 출시 docs 영역 명시 영구 정착 + 5-repo byte-identical propagation 동반.

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-DOCS-AUTOSYNC-PARADIGM-001 |
| Mode | master-cli-infra (ops-layer) |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | `/Users/yundonghyeon/AndroidStudioProjects/cc-paste-MASTER-CLI-DOCS-AUTOSYNC-PARADIGM-001.md` (SHA `067c3b9a0276c87f7a0822d48f794fc45ff62b5b` · 254 line) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | master 4 (workflow-core.md + cycle-discipline.md + docs-change-communicator.md + CLAUDE.md) + 자식 12 (3 file × 4-repo) = 총 16 |
| Modules | `.claude/rules/` + `.claude/agents/active/` + master root CLAUDE.md |
| Risk | Low (= ops-layer paradigm SoT 강화 · 0 production code touch) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision
N/A (= libs.versions.toml 무접촉)

## 3. ArchitectureImpact
N/A (= 기존 paradigm SoT 강화 default · 신 추상화 X · 신 file 신설 0)

## 4. ModelBoundaryPlan
N/A (= ops-layer · 도메인 모델 무관)

## 5. ErrorPolicy
N/A (= ops-layer)

## 6. UIStateFlowPlan
N/A (= ops-layer)

## 7. TestabilitySeams
N/A (= ops-layer)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `git hash-object` 5-repo cross-verify (= 3 file byte-identical) + 보호 5 sha drift 0 verify + dirty baseline 0 NEW verify |

## 9. RollbackStrategy
- 비가역 변경 영역 0 (= paradigm SoT 강화 default · production code touch 0)
- 롤백 절차: `git revert <commit>` 5-repo 모두 (= byte-identical commit 정합)

## 10. ExternalPrep / DeferredItems
N/A

## Plan

1. (A) `claude-cli-master/.claude/rules/workflow-core.md` §단계 흐름 안 DocSync bullet 본문 추가 (= 자식 repo 출시 docs 영역 명시 = `docs/release-readiness/LAUNCH-STATUS.md` + `docs/CLAUDE.md` + `docs/setup/*`)
2. (B) `claude-cli-master/.claude/rules/cycle-discipline.md` §20 신설 (= DocSync 단계 본문 SoT · 4 sub-section: 갱신 대상 / 의무 / 정합 / 이력)
3. (C) `claude-cli-master/.claude/agents/active/docs-change-communicator.md` Key questions 6~8 append (= 자식 출시 docs 영역 questions)
4. 산출물 4 file (`PLAN.md` + `EVIDENCE.md` + `VERIFY.md` + `REVIEW.md`) `.ai/reports/MASTER-CLI-DOCS-AUTOSYNC-PARADIGM-001/` 안 작성
5. (D) master `CLAUDE.md` §15 cycle 이력 entry append
6. master commit (= scope 4 file 한정 · pre-existing scope-외 dirty 보존)
7. `scripts/propagate.sh` 호출 (= 4-repo 측 3 file byte-identical cp)
8. `scripts/verify-sync.sh` 호출 (= 5-repo byte-identical verify · drift 0)
9. paste-back 본문 작성 + cowork 회수

## Notes
- §FREEDOM 영역 (= paste source §5 정합): paradigm 본문 어휘 / 위치 / structure 결정 cli session 자율 적용. 본 cycle 안 (A) bullet 위치 = cleanup pass bullet 다음 / (B) §20 위치 = §19 다음 / (C) questions 6~8 위치 = 기존 5 questions 다음.
- pre-existing scope-외 dirty (= 002 cycle 진행 영역 측 pencil-* rules + nightly-baseline 등) 보존 default (= memory `project_paste_back_dirty_baseline.md` §7.1 정합).
- 보호 5 file sha drift 0 의무 default.
