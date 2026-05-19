# PLAN — MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001

## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001 |
| Mode | cli infra (ops-layer · 0 production touch) |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | `/Users/yundonghyeon/AndroidStudioProjects/cc-paste-MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001.md` |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | ≈ 27 (= 신설 11 + append 15 - 산출물 5) |
| Modules | cli infra (`.claude/rules/` + `.claude/agents/active/`) + 부모 mount root + master `CLAUDE.md` §15 + master `.ai/reports/` |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A (= `libs.versions.toml` 변경 X · cli infra paradigm 신설 영역 default)

## 3. ArchitectureImpact

- 새 인터페이스/추상화: cross-repo orchestrator sub-agent (= Planner 경계 default · `routing-and-delegation.md` Planner/Generator/Evaluator 정합)
- 변동성 경계 유형: N/A (= cli infra 영역 · production code 무영향)
- 레이어 누수 위험: N/A
- shared-first 경계 영향: N/A

## 4. ModelBoundaryPlan

N/A (= 모델 레이어 무관 · cli infra 영역)

## 5. ErrorPolicy

N/A (= UseCase / Repository 무관 · cli infra 영역)

## 6. UIStateFlowPlan

N/A (= UI 무관 · cli infra 영역)

## 7. TestabilitySeams

N/A (= 신규 테스트 file 영역 X · cli infra paradigm 신설 영역 default)

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/verify-sync.sh` + `git hash-object` 측 보호 5 file sha drift 0 verify + `shasum -a 256` 측 부모 mount root CLAUDE.md sha 산출 + `git diff --stat` 측 production code touch 0 LOC verify |

## 9. RollbackStrategy

- 롤백 가능 지점: 본 cycle commit 직전 5-repo HEAD (= baseline §0 정합)
- 롤백 조건: 보호 5 file sha drift 발견 / production code touch 발견 / 사용자 본심 분기 의제 발견
- 복구 경로: `git revert <commit>` × 5-repo (= cli infra paradigm 영역 default · 비가역 변경 X)

## 10. ExternalPrep / DeferredItems

- 본 cycle 측 외부 의존 영역 X (= cli infra paradigm 신설 영역 default)
- §FREEDOM 영역 deferred:
  - `baseline-snapshot.sh` REPOS 배열 app-foundation 추가 = **skip default** (= file 자체 5-repo 모두 MISSING · Finding 4 mitigation = 별 cycle 분리 default)

## Plan

1. baseline anchor verify (= 5-repo HEAD sha + 보호 5 file sha + dirty 영역 측정)
2. cli infra SoT 본문 정독 (= master CLAUDE.md + routing-and-delegation.md + cycle-discipline.md + workflow-core.md + intake-router.md + report-formats.md)
3. file 신설 (master):
   3.1 `/Users/yundonghyeon/AndroidStudioProjects/CLAUDE.md` (= 부모 mount root SoT)
   3.2 `.claude/rules/cross-repo-parallel-exec.md`
   3.3 `.claude/agents/active/cross-repo-orchestrator.md` (= §FREEDOM 결정 = 신설)
4. file append (master):
   4.1 `.claude/rules/routing-and-delegation.md` Cross-repo sub-section
   4.2 `.claude/rules/cycle-discipline.md` §21 Cross-repo cycle 영역
   4.3 `CLAUDE.md` §15 본 cycle entry
5. propagation 단방향 (master → 4 자식 byte-identical):
   5.1 `bash scripts/propagate.sh cross-repo-parallel-exec.md cross-repo-orchestrator.md routing-and-delegation.md cycle-discipline.md`
   5.2 verify-sync.sh + 보호 5 file sha cross-verify
6. 산출물 5 file 신설 (= `.ai/reports/MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001/`)
7. memory 갱신:
   7.1 `.auto-memory/incident-log.md` entry append
   7.2 `.auto-memory/propagation-status.md` sha 갱신
8. commit 5-repo:
   8.1 master = `feat(cli-infra): MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001 ...`
   8.2 4 자식 = `chore(cli-infra): propagation MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001`
9. paste-back 본문 cowork chat 측 회수

## Notes

- 본 cycle = ops-layer 영역 default (= cli infra paradigm 신설 · 0 production code touch)
- `cycle-discipline.md` §5 v2 자동 허용 카테고리 정합 default (= chore + audit + discipline)
- §FREEDOM 영역 결정 = cli session 자체 결정 default (= paste source §4 정합)
- 본 cycle 측 scope 외 영역 (= intake-router.md drift @ foundation / gradlew/gradlew.bat foundation drift / docs/baseline cowork-project-instructions §20-redline master 단일 file) = 본 cycle 진입 baseline 측 pre-existing 영역 default · EVIDENCE 측 명시 default
