# PLAN — MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001

## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001 |
| Mode | cli infra (= ops-layer · 정정 강화 · 0 production touch) |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | `/Users/yundonghyeon/AndroidStudioProjects/cc-paste-MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001.md` |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | ≈ 14 (= append 2 + propagation 4 + 산출물 5 + memory 2 + master CLAUDE.md §15 1) |
| Modules | cli infra (`.claude/rules/cross-repo-parallel-exec.md`) + 부모 mount root `CLAUDE.md` + master `CLAUDE.md` §15 + master `.ai/reports/` |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A (= `libs.versions.toml` 변경 X · cli infra paradigm 정정 강화 영역 default)

## 3. ArchitectureImpact

- 새 인터페이스/추상화: N/A (= 본 cycle = 정정 강화 영역 default · 신 sub-section 영역 신설 default · 새 추상화 X)
- 변동성 경계 유형: N/A
- 레이어 누수 위험: N/A
- shared-first 경계 영향: N/A

## 4. ModelBoundaryPlan

N/A (= 모델 레이어 무관 · cli infra 영역)

## 5. ErrorPolicy

N/A (= UseCase / Repository 무관 · cli infra 영역)

## 6. UIStateFlowPlan

N/A (= UI 무관 · cli infra 영역)

## 7. TestabilitySeams

N/A (= 신규 테스트 file 영역 X · cli infra paradigm 정정 강화 영역 default)

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/verify-sync.sh` + `git hash-object` 측 보호 5 file sha drift 0 verify + `shasum -a 256` 측 부모 mount root CLAUDE.md 신 sha 산출 + `git hash-object` 측 본 cycle 신 1 file × 5-repo byte-identical verify + `git diff HEAD~1 HEAD --stat -- 'app/' 'composeApp/' 'core/' 'domain/' 'shared/'` 측 production code touch 0 LOC verify |

## 9. RollbackStrategy

- 롤백 가능 지점: 본 cycle commit 직전 5-repo HEAD (= baseline §0 정합 · master `e1cef8c1` / FND `15a58f1e` / GB `efa4b211` / GD `d70f2c5e` / GT `a29c09bb`)
- 롤백 조건: 보호 5 file sha drift 발견 / production code touch 발견 / 사용자 본심 분기 의제 발견
- 복구 경로: `git revert <commit>` × 5-repo (= cli infra paradigm 정정 강화 영역 default · 비가역 변경 X)

## 10. ExternalPrep / DeferredItems

- 본 cycle 측 외부 의존 영역 X (= cli infra paradigm 정정 강화 영역 default)
- 직전 cycle TODO 영역 trail 정합:
  - `MASTER-CLI-CROSS-REPO-ORCHESTRATOR-FIRST-USE-NNN` (= cross-repo-orchestrator sub-agent 실 활용 cycle 별 trail · 본 cycle 측 정합 X · 본 cycle = SoT 정정 강화 영역 default)

## Plan

1. baseline anchor verify (= 5-repo HEAD + cross-repo-parallel-exec.md sha + 부모 mount root CLAUDE.md sha-256 + 보호 5 file drift 0 + dirty 영역 측정)
2. cross-repo-parallel-exec.md 정정 강화 (master):
   2.1 §2.2 영역 2 paradigm 본문 강화 (= 사용자 본인 측 의무 표 + 자식 cli infra 자동 정합 + subscription pool 정합 + trade-off 영역)
   2.2 §2.4 Subscription-aware paradigm sub-section 신설 (= 2026-06-15 billing split + claude -p 회피 paradigm)
   2.3 §3.4 Sub-agent token cost warning sub-section 신설 (= 7× standard + 실 사례)
   2.4 §8 명시 cycle 이력 본 cycle entry append
3. 부모 mount root CLAUDE.md §4 정정 강화 (= 영역 1/2/3 분기 표 + subscription-aware paradigm 본문 + 사용자 본심 영역 + 영역 2 진입 paradigm)
4. master CLAUDE.md §15 본 cycle entry append
5. propagation 단방향 (master → 4 자식 byte-identical):
   5.1 `bash scripts/propagate.sh .claude/rules/cross-repo-parallel-exec.md`
   5.2 verify-sync.sh + 보호 5 file sha cross-verify + 본 cycle 신 1 file × 5-repo byte-identical verify
6. 산출물 5 file 신설 (= `.ai/reports/MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001/{PLAN,EVIDENCE,VERIFY,REVIEW,TODO}.md`)
7. memory 갱신:
   7.1 `.auto-memory/incident-log.md` entry append
   7.2 `.auto-memory/propagation-status.md` (= verify-sync.sh 자동 갱신)
8. commit 5-repo:
   8.1 master = `feat(cli-infra): MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001 ...`
   8.2 4 자식 = `chore(cli-infra): propagation MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001`
9. paste-back 본문 cowork chat 측 회수

## Notes

- 본 cycle = ops-layer 영역 default (= cli infra paradigm 정정 강화 영역 · 0 production code touch)
- `cycle-discipline.md` §5 v2 자동 허용 카테고리 정합 default (= chore + audit + discipline)
- §FREEDOM 영역 결정 = cli session 자체 결정 default (= paste source §4 정합)
- §FREEDOM 결정: §2.4 + §3.4 위치 결정 default · (B) §2.2 expansion + (D) §4 expansion default
- 본 cycle 측 scope 외 영역 (= intake-router.md drift @ foundation / gradlew/gradlew.bat foundation drift / docs/baseline cowork-project-instructions §20-redline master 단일 file) = 직전 cycle 동일 영역 default · 본 cycle 진입 baseline 측 pre-existing 영역 default · EVIDENCE 측 명시 default
