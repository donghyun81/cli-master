## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-GB-AUTH-ACTIVATE-001 |
| Mode | ops-layer (도메인 활성화 패턴 3) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | `.ai/tasks/MASTER-GB-AUTH-ACTIVATE-001.md` |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 1 (deferred-domains.md) + auto memory 2 (decision-log + protected-file-hashes) + 4 report file |
| Modules | `.claude/rules/` + `.auto-memory/` + `.ai/reports/` |
| Risk | Low (ops-layer · 패턴 3 재사용 · 코드 변경 X) |
| DBMig | No |
| MoneyAuth | Yes (Auth governance · 정책 영역만 · 제품 코드 X) |

## 2. DependencyDecision
N/A (libs.versions.toml 변경 X)

## 3. ArchitectureImpact
N/A (ops-layer · 도메인 코드 미변경)

## 4. ModelBoundaryPlan
N/A (ops-layer)

## 5. ErrorPolicy
N/A (ops-layer)

## 6. UIStateFlowPlan
N/A (ops-layer)

## 7. TestabilitySeams
N/A (ops-layer)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/verify-sync.sh` (exit 0 + DRIFT 0 + MISS 0 의무) |

## 9. RollbackStrategy
문서 전용 변경: `git revert <commit>` 즉시 복구 가능 · master 1 + 자식 4 commit 모두 revert 시 baseline 복원.

## 10. ExternalPrep / DeferredItems
N/A (외부 의존 X)

## Plan

1. **Step 1 (BASELINE)**: 5-repo HEAD + deferred-domains.md §2 GB Auth 행 = UNKNOWN 실측 PASS + routing-and-delegation.md [DEFERRED] 부재 (이미 globally active) 실측 PASS + auth-rules.md GB-applicable READ-ONLY 검증 PASS + incident-log.md L40 GB SteadyWell drift entry 인지 PASS.
2. **Step 2 (EDIT)**: master `deferred-domains.md` §2 Auth 행 GB 열 UNKNOWN → ACTIVE³ + footnote ³ "Supabase Auth 익명 부트스트랩 + EncryptedSessionStore · Phase 2 진행 중 (GB-PHASE-2-AUTH-* baseline)" 추가 + §6 history append (2026-05-11 MASTER-GB-AUTH-ACTIVATE-001).
3. **Step 3 (PROPAGATE)**: `bash scripts/propagate.sh .claude/rules/deferred-domains.md --targets all` → 4-repo cp.
4. **Step 4 (VERIFY)**: `bash scripts/verify-sync.sh` PASS + 보호 파일 5종 sha 변동 0 확인.
5. **Step 5 (COMMIT)**: master + 4 자식 5 commit 박음 (각 6-section body).
6. **Step 6 (MEMORY)**: `.auto-memory/decision-log.md` + `protected-file-hashes.md` Recent updates append.
7. **Step 7 (REPORT)**: EVIDENCE.md + VERIFY.md + REVIEW.md (Verdict=PASS) 박음.

## Notes
- routing-and-delegation.md 의무 = vacuous (이미 globally active) · EVIDENCE.md §Key Findings 명시.
- GB SteadyWell propagation 잔존 drift entry (incident-log L40 · C4 baseline 채택) = 본 cycle 마감으로 자연 close (drift 흡수 후 GB Auth 정식 활성화).
- 보호 파일 5종 sha 변동 0 의무 (deferred-domains.md = 비보호 cli infra).
