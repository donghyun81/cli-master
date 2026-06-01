## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-POSTCYCLE-AUTOMATION-001 |
| Mode | M5 cli-infra-ops |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | 부모-root `cc-paste-MASTER-CLI-POSTCYCLE-AUTOMATION-001.md` (cowork authored · disk-grounded) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | master 6 (archiver · rotate.sh 신설 · verify-sync · propagation-status · protected-file-hashes · settings.json) + CLAUDE.md §15 + 자식 propagation |
| Modules | cli infra (`.claude/` hooks/settings + `scripts/`) + `.auto-memory/` 상태문서 |
| Risk | Medium (= 보호 file 정책 영역 protected-file-hashes.md + settings.json resync · STOP #5 민감) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision
N/A (의존성 변경 없음 · libs.versions.toml 무접촉)

## 3~7
N/A (= ops-layer · production code / 모델 / UI / 테스트 심 무접촉)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/verify-sync.sh` (cross-verify PASS/drift0) · `bash -n` (script syntax) · 부모-root archiver/rotate 1회 run + count delta · stop-housekeeping self-test exit0 · shasum -a 256 5-repo byte-identical |

## 9. RollbackStrategy
- 롤백 지점: master 6033652~6ec20f6 + 자식 4 commit = `git revert` (cli infra · 가역)
- archiver/rotate 부모-root run = mv only → `scripts/restore.sh` 복원 가능 (삭제 0)
- 보호 5 file 무접촉 → 보호 baseline 롤백 불요

## 10. ExternalPrep / DeferredItems
N/A

## Plan
1. **Phase A** working-file-archiver.sh = sweep +4 패턴 + is_excluded + sibling-repo REVIEW lookup → propagate(sweep 위치 master+GB+GD+GT + 부모-root cp · FND 제외) → 1회 run.
2. **Phase B** handoff-active-rotate.sh 신설(threshold 256KB · 본문 보존 mv + 신 active 재생성) → master scripts/ + 부모-root cp → 1회 rotation.
3. **Phase C** verify-sync.sh = live 매트릭스 재생성 + 부재참조 WARN → propagate 5-repo · propagation-status.md/protected-file-hashes.md stale 정정(master-only) → manifest resync.
4. **Phase D** stop-housekeeping.sh 신설(non-blocking · Stop hook) + settings.json Stop 배선 + settings sha resync → propagate 5-repo(FND 포함 · archiver guard 로 FND no-op).
5. cross-verify + §15 + audit + reports + paste-back.

## Notes
- 사용자 reconcile (AskUserQuestion): Phase A archiver propagate target = "sweep 위치" (= master+GB+GD+GT+부모-root cp · FND 제외). 근거 = lifecycle §3 + launchd plist sweep 위치 정합.
- §FREEDOM 결정: threshold 256KB · phase 별 master commit 4 + audit 1 · launchd rotation 추가 X(stop-housekeeping WARN + 1회 run 충분) · handoff rotate = stop-housekeeping WARN-only(자동 mv X).
