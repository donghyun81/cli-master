# PLAN — MASTER-CLI-PENCIL-FLOW-ENFORCE-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-PENCIL-FLOW-ENFORCE-001 |
| Mode | master cli infra cycle (= 5 영역 통합 흡수) |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | `/Users/yundonghyeon/AndroidStudioProjects/cc-paste-MASTER-CLI-PENCIL-FLOW-ENFORCE-001.md` |
| Cycle Class | cli infra cycle (= production code 무접촉 default) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 5 (= 신설 3 + 정정 2) |
| Modules | `.claude/hooks/` + `.claude/agents/active/` + `scripts/` + `.auto-memory/` |
| Risk | Low (= cli infra · warn mode default · production code 무접촉) |
| DBMig | No |
| MoneyAuth | No |
| ChangeBudget LOC | A 영역 ≤ 200 / C 영역 ≤ 300 / D 영역 ≤ 30 / E 영역 ≤ 50 |

## 2. DependencyDecision
N/A (= `libs.versions.toml` 변경 없음 · cli infra cycle 영역 default)

## 3. ArchitectureImpact
N/A (= 새 인터페이스 / 추상화 없음 · 기존 hook + agent paradigm precedent 정합 default)

## 4. ModelBoundaryPlan
N/A (= 도메인 모델 변경 없음)

## 5. ErrorPolicy
N/A (= 새 UseCase / Repository 없음)

## 6. UIStateFlowPlan
N/A (= UI 변경 없음)

## 7. TestabilitySeams
N/A (= hook self-test 7 fixture + sweep script self-test 본문 본문 정합 default)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | 1. `bash .claude/hooks/pre-screen-edit-pen-check.sh` (= 7 fixture self-test)<br>2. `bash scripts/pencil-pending-sweep.sh` (= sweep self-test)<br>3. `bash scripts/propagate.sh ... --targets FND,GB,GD,GT` (= 20/0)<br>4. `bash scripts/verify-sync.sh` (= 5-repo sha cross-verify)<br>5. 본 cycle 5 file × 5-repo byte-identical 측정<br>6. 보호 5 file × 5-repo drift 0 검증<br>7. production code touch 0 LOC 검증 |

## 9. RollbackStrategy
- 롤백 가능 지점: `git revert <master-commit>` (= 본 cycle 변경 전 baseline `36f1632`)
- 롤백 조건: 사용자 본심 회수 또는 §6 STOP 조건 #1 (보호 file sha drift) 발견 시
- 복구 경로: master 측 revert + 5-repo propagation 재 실행 + audit commit

## 10. ExternalPrep / DeferredItems
- C 영역 sweep paradigm 측 cron / launchd 자동화 정착 = 별 cycle 영역 default (= `MASTER-CLI-PENCIL-PENDING-SWEEP-AUTOMATION-NNN` 후속 영역)
- A 영역 warn → enforce 승격 = 별 cycle 영역 default (= `no-abbreviation-policy.md` §5.1 precedent 정합 · 본 cycle = warn baseline default)
- 보호 file baseline sha 정정 (= `propagate.sh` 본문 측 outdated expected baseline 영역) = 별 cycle 영역 default (= 본 cycle scope 외 · WARN-only 영역 default)

## Plan

1. **A 영역**: `.claude/hooks/pre-screen-edit-pen-check.sh` 신설 + `.claude/settings.json` PreToolUse Edit|Write matcher 측 추가
2. **D 영역**: `.claude/agents/active/ui-implementer.md` Key questions 0 항 (Pencil SoT entry gate) + Must escalate `.pen` 부재 본문 추가
3. **E 영역**: `.claude/agents/active/intake-router.md` Auth keyword routing sub-section 신설 (= Supabase routing 후 default)
4. **C 영역**: `scripts/pencil-pending-sweep.sh` 신설 + `.auto-memory/pencil-pending-status.md` trail 신설
5. **F 영역**: 5-repo byte-identical propagation (= FND + GB + GD + GT 측 5 file cp + verify-sync cross-verify + production code touch 0 검증)
6. cycle 산출물 (PLAN + EVIDENCE + VERIFY + REVIEW + HANDOFF) + propagation-reports + `CLAUDE.md` §15 entry append
7. master commit + 자식별 commit × 4 + audit (= `.auto-memory/propagation-status.md` 갱신)

## Notes
- §FREEDOM 영역 결정 (= cli session 자율 default):
  - A 영역 매핑 paradigm = basename strip Screen[s] + camelCase → kebab-case (= 단순 default · sot-code-name-map.md 명명 차이 영역 false positive 회피 paradigm = warn mode default)
  - C 영역 sweep paradigm = 매뉴얼 호출 default (= cron 자동화 별 cycle 분리)
  - commit paradigm = master 1 commit + 자식별 4 commit + audit 1 commit (= 통합 흐름 default)
  - Plan Mode 진입 skip (= scope 명확 + ChangeBudget 명시 + §FREEDOM 광범위 위임 default · 즉시 IMPL 진입 default)
