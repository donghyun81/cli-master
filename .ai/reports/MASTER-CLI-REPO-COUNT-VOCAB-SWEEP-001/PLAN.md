# PLAN — MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001 |
| Mode | M5 (cli-infra-ops) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cc-paste-MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001.md (audit P2 O7 + 4b 표면화 잔여) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | master 50 (rules 32 + agents 2 + skills 9 + hooks 2 + scripts 4 + CLAUDE.md) + 부모 root CLAUDE.md 1 + 자식 5 × 45 (propagation) |
| Modules | cli infra 한정 (rule / agent / skill / hook / script 텍스트층) |
| Risk | Low (production 0 LOC · 어휘·경로 텍스트 한정 · script 로직 무변경) |
| DBMig | No |
| MoneyAuth | No |

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `shasum -a 256` 보호 5 (drift 0) · `grep -rn -i "5-repo"` live 영역 잔존 분류 (현재형 0) · `bash scripts/propagate.sh` ok/fail · `bash scripts/verify-sync.sh` exit 0 |

## 9. RollbackStrategy
- master + 자식 5: `git revert <commit>` 즉시 복구 가능 (텍스트 한정 변경).
- 부모 root CLAUDE.md (git 외): 본 cycle 치환 1건(`(= 6-repo 공통 아키텍처)` → 구문 역치환)으로 수동 복원 가능 · 구/신 shasum = EVIDENCE.md 기록.

## Plan
1. 6-repo HEAD + dirty + 보호 5 sha 라이브 재측정 (§0 baseline 대조) — 일치 확인.
2. live 영역 전수 grep + 건별 live/역사/보존 분류 (집계 기준 명시).
3. 건별 단언 치환표(apply_sweep.py) 2-phase 집행 — blanket sed 금지 준수.
4. scope ② 소형 3 (design-sot-refresh 명칭 2 + repo-config 경로 4 + 동일 유형 check-layer 4).
5. master commit → 45 cli infra file 6-repo propagation → 자식 5 path-limited commit → verify-sync → REPORT.
6. 부모 root CLAUDE.md 직접 갱신(§7 정합) + CLAUDE.md §15 entry + audit commit.

## Notes
- 2/3/4/5/6/7/10 섹션 = N/A (ops-layer 어휘 정정 · 의존성/아키텍처/모델/오류/UI/테스트 변경 없음).
