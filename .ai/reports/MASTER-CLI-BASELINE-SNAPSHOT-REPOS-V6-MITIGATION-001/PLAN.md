# PLAN — MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001

## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001 |
| Mode | ops-layer (cli infra hook 본문 정정) |
| Workflow | Collect → Plan → Implement → Verify → Review (lightweight 4-file 정합 · `cycle-discipline.md` §11) |
| Requirements Source | `cc-paste-MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001.md` (= paste source default · paradigm 진입점) |
| paradigm | 영역 1 (= 부모 mount root cwd · 단일 cli session · scripts/propagate.sh + verify-sync.sh 자동) |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 4 (= master baseline-snapshot.sh + CLAUDE.md §15 + propagation-status.md + audit) · 자식 4 propagation cp 1 file each |
| Modules | `.claude/hooks/` (= cli infra · 1 file) · `CLAUDE.md` §15 row +1 · `.auto-memory/propagation-status.md` +1 entry |
| Risk | Low (= ops-layer · 5-repo byte-identical paradigm · 제품 코드 0 touch) |
| DBMig | No |
| MoneyAuth | No |
| LOC | ~5~15 line 정정 (= 매우 적은 영역 · §FREEDOM wording 자율) |

## 2. DependencyDecision

N/A (= ops-layer · libs.versions.toml 무접촉 default)

## 3. ArchitectureImpact

N/A (= 새 인터페이스/추상화 X · hook 본문 정정 단일)

## 4. ModelBoundaryPlan

N/A (= 모델 레이어 무접촉)

## 5. ErrorPolicy

N/A (= 새 UseCase/Repository X)

## 6. UIStateFlowPlan

N/A (= UI 무접촉)

## 7. TestabilitySeams

N/A (= hook self-test 측 fixture-based 검증 default · 단 self-test = exit 0 + latest.json 안 5-repo entry 정합 + Proto* entry 부재 확인 의무)

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | `bash .claude/hooks/baseline-snapshot.sh` (hook self-test) + `bash scripts/verify-sync.sh` (5-repo cross-verify) |

## 9. RollbackStrategy

- 본 cycle = master 측 4 commit (= feat + audit) + 자식별 4 commit (= chore propagation). 롤백 = `git revert <hash>` × 5 (master 측 audit + feat + 자식 4) default. 비가역 영역 X.
- 보호 5 file 무접촉 default · 보호 file 측 mitigation cycle 측 진입 X default.
- 7-repo paradigm 회귀 = `git revert` 후 직전 baseline `839ac890...` 5-repo (= 또는 master baseline_snapshot.sh 측 직전 commit state · ProtoGently 측 미적용 default).

## 10. ExternalPrep / DeferredItems

- 잔존 영역 (= 별 cycle 후보 · 본 cycle scope 외 default):
  - **`scripts/propagate.sh` + `scripts/verify-sync.sh` 측 `TARGET_REPOS` default 5-repo paradigm drift** — 본 cycle 측 `--targets FND,GB,GD,GT` 명시 사용 default. 별 cycle 후보 = `MASTER-CLI-PROPAGATE-VERIFY-SYNC-V6-MITIGATION-001` 패턴.
  - **pre-existing scope 외 dirty 영역** = §7.1 paste-back dirty baseline paradigm 정합 default · 본 cycle 측 0 NEW dirty 의무 default (= baseline-snapshot.sh self-test 출력 latest.json + 신 timestamped snapshot 영역만 = cycle proof-of-PASS evidence default).

## Plan (= 핵심 영역 한정 · §FREEDOM 위임 본문)

1. baseline-snapshot.sh 본문 정정 (line 3 목적 본문 + REPOS 배열 + line 116 자식 list + 신설 paradigm row append) [완료]
2. hook self-test 마감 (= `bash .claude/hooks/baseline-snapshot.sh` 실호출 default · baseline JSON 본문 측 5-repo entry 정합 ✓ + Proto* entry 부재 ✓) [완료]
3. master commit (= feat · §7 6-항 정합) + propagation (= `bash scripts/propagate.sh .claude/hooks/baseline-snapshot.sh --targets FND,GB,GD,GT`) + verify-sync.sh + 4 자식별 staged commit [완료]
4. propagation report 3 file 자동 생성 (= `bash scripts/report-gen.sh MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001`) [완료]
5. master CLAUDE.md §15 entry append + `.auto-memory/propagation-status.md` 갱신 + master audit commit [진행 중]
6. 산출물 5 file (PLAN/EVIDENCE/VERIFY/REVIEW/HANDOFF) 작성 + paste-back 본문 운반 [진행 중]

## Notes

- §FREEDOM 영역: wording / format / commit body 영역 자율 default · 5-repo paradigm 본문 의무 정합.
- 영역 1 paradigm 정합 default (= 단일 cli session 측 sub-agent fan-out 가능 단 본 cycle = file 단일 + master cwd 진입 default · scripts 자동 호출 paradigm 정합 default · sub-agent fan-out 영역 X default).
- subscription-aware paradigm 정합 (= `cross-repo-parallel-exec.md` §2.4 정합 · interactive pool 정합 default · `claude -p` 영역 X default).
