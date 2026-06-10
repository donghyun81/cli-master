# PLAN — MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001 |
| Mode | M5 (cli-infra-ops) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cc-paste-MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001.md (audit-P2 D1 = O1+O2+O5 + D3) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | master 6 (CLAUDE.md + cold + hook + cycle-discipline + context-health-metrics + propagation-status) + 자식 4 CLAUDE.md + 5-repo propagation 2 file |
| Modules | cli infra only |
| Risk | Low (doc + warn-only hook) |
| DBMig | No |
| MoneyAuth | No |

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash -n` + hook fixture self-test + cold verbatim subset 검증 + 4-repo sha 동일성 + `bash scripts/verify-sync.sh` |

## 9. RollbackStrategy
- 문서 + warn-only hook 전용: `git revert <commit>` 으로 즉시 복구 가능 (자식 4 CLAUDE.md 포함 · 각 repo 별 revert).

## Plan (outcome 5 + §FREEDOM 판정)
1. **①** master §15 hot 14 → 최근 5 + 본 cycle entry (9 entry verbatim → cold 94→103 · COLD-002 전례 절차 · 무손실).
2. **②** 재증식 자동 감시 = `measure-gsm-cycle.sh` 확장 채택 (= §FREEDOM hook 선택 · 근거: GSM-CONTEXT-HEALTH-ABSORB-001 이 동일 "기존 Stop hook 확장 · 신 hook 0 · settings 무접촉" 전례 + 본 hook 이 이미 master CLAUDE.md context 측정 보유 + 5-repo 전파 대상). hot > 10 시 advisory surface · warn-only · Transport(측정)/Inspection(판정·이전 수동) 경계.
3. **③** 자식 4 CLAUDE.md: §15 박제 → cold pointer 1행(사전 6/6 verbatim ∈ cold 검증) + 화자 2문 자식 framing + banner 정합. 4-repo byte-identical 유지.
4. **④** cycle-discipline §단위 판정 (= §FREEDOM 전권 · skill body coverage grep 실측 후):
   - 후퇴: §23(disk-verification skill) · §24(runtime-crash-mitigation skill) · §25 잔여(initiatives-sync skill · §25.2 = 기존 pointer verbatim 보존) · §26(paste-source-authoring skill) · §27(anchor-list.md) · §28(automation-policy.md) · §29(mode-system.md) — 각 § sub-내용(precedent·trigger baseline·사고 수치) skill/rule body 기존재 grep 확인.
   - 보존: §21(cross-repo cycle 운영 표준 — §21.1 분류·§21.3 7-step·§21.5 산출물 = 본 § 자체 canonical) · §22(git mv+sed stage — safety-and-secrets 가 본 § 를 pointer 하는 canonical).
5. **⑤** §22.2 step 7 = 확장/이동 cycle 마감 dual grep sweep(A7) gate 1행 (= rename cycle 마감 절차 위치).
6. propagation: cycle-discipline.md + measure-gsm-cycle.sh × 5 자식 · 자식 CLAUDE.md = repo-specific 직접 정정(path-limited commit · 동시 session sweep 회피).
