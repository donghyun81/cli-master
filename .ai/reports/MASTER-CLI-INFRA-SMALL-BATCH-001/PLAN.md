# PLAN — MASTER-CLI-INFRA-SMALL-BATCH-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-INFRA-SMALL-BATCH-001 |
| Mode | M5 cli-infra-ops (도메인 키워드 0) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cc-paste-MASTER-CLI-INFRA-SMALL-BATCH-001.md (audit backlog ②③⑪) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | master 3 (2 hook + propagate.sh) + 자식 propagation(instructions ×5 + pending ×4) + GT git config(비커밋) |
| Modules | cli infra (.claude/hooks + scripts) |
| Risk | Low (기계적 · 도구 무관 · 보호 무접촉) |
| DBMig | No |
| MoneyAuth | No |

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash -n` 3 file + instructions-loaded live run + propagate 가드 self-test + `bash scripts/verify-sync.sh` (exit 0) + pencil-pending-sweep 4-child hash 대조 + GT hooksPath 대조 |

## 9. RollbackStrategy
- 문서/도구 전용: `git revert 513f964`(master) + 자식 5 동족 revert. GT config = `git -C GentlyTable config --unset core.hooksPath` 즉시 복구.

## Plan
1. live 재측정 (§0 = Phase B 이전 stale · authoritative = live)
2. ① 두 hook REPOS 5→6 + wording 8행 현행화
3. ② propagate.sh C16 run-* cp 가드 (FILES 해결 직후 case-glob skip+WARN)
4. ③ GT push gate 의도 근거 실측 → 제외 의도 0 = GB/GD 동형 hooksPath 설정
5. self-test 3종 → master commit → propagate(2 hook) → 자식 path-limited commit → verify-sync → REPORT → §15/incident audit

## Notes
- 무접촉: 보호 5 · 제품 SoT · production · 기존 dirty (GB 2 · GD/GT 각 1).
- ③ STOP 조건: 의도 근거(제외) 발견 시 변경 금지·보고 — 실측 결과 포함 의도 확증이라 STOP 미발화.
