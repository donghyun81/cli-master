# PLAN — MASTER-BILLING-DOMAIN-ACTIVATE-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-BILLING-DOMAIN-ACTIVATE-001 |
| Mode | ops-layer (cli infra · 도메인 활성화 패턴 3) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | 통합 prompt (사용자 지시 · cycle-discipline §15 패턴 3) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 5 (sot-code-name-map · billing-rules 신설 · deferred-domains · routing-and-delegation · CLAUDE.md §15) + propagation 자동 |
| Modules | .claude/rules · .claude/agents |
| Risk | Medium (ops-layer · 4-repo propagation) |
| DBMig | No |
| MoneyAuth | No (정책 SoT 신설 · 실 결제 코드 X) |

## 2. DependencyDecision
N/A

## 3. ArchitectureImpact
N/A (정책 SoT 신설 · 코드 변경 X)

## 4. ModelBoundaryPlan
N/A

## 5. ErrorPolicy
N/A

## 6. UIStateFlowPlan
N/A

## 7. TestabilitySeams
N/A

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/propagate.sh --all` + `bash scripts/verify-sync.sh` |

## 9. RollbackStrategy
- 롤백 가능 지점: 매 commit (5 분리 commit)
- 롤백 조건: verify-sync.sh DRIFT 발생 시
- 복구 경로: `git revert <commit>` + `propagate.sh --all` 재실행

## 10. ExternalPrep / DeferredItems
- Phase 4 (실 Google Play Billing 연동) = lazy · 자식 repo 별 cycle 진입 시
- RevenueCat / iOS IAP = Phase 2 별 trail (lazy)

## Plan
1. STEP-1: GT sot-code-name-map.md → master 흡수 (drift 정정)
2. STEP-2: billing-rules.md SoT 신설 (10-section · auth-rules.md 패턴)
3. STEP-3: `bash scripts/activate-agent.sh activate billing-payments-guardian`
4. STEP-4: deferred-domains.md L44 ACTIVE×4 + §6 이력 entry
5. STEP-5: routing-and-delegation.md L104 DEFERRED list 정리 (script L55 자동)
6. STEP-6: `propagate.sh --all` + `verify-sync.sh` PASS
7. STEP-7: 산출물 + 메모 + 분리 commit + CLAUDE.md §15 entry

## Notes
- Mock-first paradigm (GT CLAUDE.md §6) 명시 + 클라이언트 직접 Google Play Developer API 호출 STOP
- 시크릿 하드코딩 = 즉시 STOP (safety-and-secrets.md 정합)
- 4-repo byte-identical 의무 (cli infra 권장)
