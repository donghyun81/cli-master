# PLAN — MASTER-CLI-SOT-CODE-NAME-MAP-VOLATILE-FLAG-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-SOT-CODE-NAME-MAP-VOLATILE-FLAG-001 |
| Mode | M5 cli-infra-ops (보호 file 아님) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cc-paste-MASTER-CLI-SOT-CODE-NAME-MAP-VOLATILE-FLAG-001.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 1 (sot-code-name-map.md · 보호 아님 · propagation) + CLAUDE.md §15 (master only) |
| Modules | cli infra (rule doc) |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2~7. (N/A — ops-layer · production code 무접촉)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | grep chat A=0 · banner grep>=1 · forward-pointer grep>=1 · 실재 화면명 grep=0(재매핑 안 함) · verify-sync PASS |

## 9. RollbackStrategy
- git revert df98ba6 + 자식 4 revert. 비가역 0 (배너 추가 + dead row 제거 · 다른 매핑 무접촉).

## 10. ExternalPrep / DeferredItems
- 전면 재매핑 + 구조결정 = rule-architecture 프로그램 이관 (= 본 cycle scope X · forward-pointer 만 도입).

## Plan (최소 cleanup · 전면 재매핑/구조결정 이관)
1. 상단 STALENESS/VOLATILITY 배너 신설 (= 측정 수치 + volatile artifact + 재매핑 이관 · 원칙 4).
2. GB paywall-screen dead chat-A TODO row 제거.
3. GD TicketScreen dead chat-A TODO row 제거.
4. §5 집계 TODO (chat A 의존) row 제거 (= 2→0 정합).
5. §6.3 dead chat-A clause → 재매핑 이관 STOP 정정.
6. §8 forward-pointer bullet 추가 (= ENTRY-PROMPT-rule-architecture-establishment.md).

## Notes
- 원칙 4 정합: 수기 재매핑 = 3주 뒤 재 stale → 회피. 배너로 misleading 해소 + 구조결정 이관.
- §2/§3/§4 다른 stale row + 표 카테고리 + §8 기존 bullet 무접촉 (= scope-out · A3).
- 보호 file 아님 → STOP-protocol(sha resync) 불요. byte-identical cli infra → propagation.
