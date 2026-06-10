# PLAN — MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001 |
| Mode | M5 cli-infra-ops (보호 2 접촉 = STOP #5 절차 동반) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cc-paste-MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001.md (재baseline 판) + 원 계약 cc-paste-MASTER-CLI-PENCIL-TOOLSET-REMOVAL-STALE-SWEEP-001.md §Phase B + §6 |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 6 (보호 2 + cycle-discipline 1 + CLAUDE.md + manifest + incident-log) + 자식 5×3 propagation |
| Modules | cli infra 단일 (rules + docs/design + .auto-memory) |
| Risk | Medium (보호 file 접촉 · sha 3-layer 절차 의무) |
| DBMig | No |
| MoneyAuth | No |

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/verify-sync.sh` (exit 0 의무) + shasum -a 256 / git hash-object 양층 + 제거 4종 grep 분류 |

## 9. RollbackStrategy
- 문서 전용: `git revert 57af6de` (master) + 자식 5 동족 revert + manifest/§14a 역방향 resync로 즉시 복구 가능.

## Plan
1. baseline 실측 (6-repo HEAD + 보호 2 sha 양층 + 자식 dirty) — §0 표 대조
2. 원 계약 §Phase B + §6 정독 + §13 self-test 3항
3. dual grep 재탐색 (원 좌표 이동 가능성 → 내용 기준)
4. 보호 2 정정 (workflow 7곳 + sot-policy 2곳) + 동반 cycle-discipline :227
5. sha 3-layer resync (manifest + §14a + baseline-snapshot 재생성)
6. master commit → propagate 3 file × 5 → 자식 path-limited commit × 5 → verify-sync → REPORT
7. §15 entry + incident-log + 산출물 + audit commit

## Notes
- 무접촉: 나머지 보호 3 · 제품 SoT · production · 기존 dirty (GB 2 · GD/GT 각 1) · cycle-discipline :164 (§13 게이트 정합 서술).
