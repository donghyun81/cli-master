## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-DOCS-ARCHITECTURE-EXTERNAL-DEP-ABSTRACTION-001 |
| Mode | docs / paradigm-SoT 신설 |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cowork H2 chat prompt §4 본문 명시 영역 |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 5 (= 5-repo · byte-identical) + 4 report file |
| Modules | docs/architecture/ 신설 영역 |
| Risk | Low (= docs-only · cli infra rule 변경 X) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision
N/A (= libs.versions.toml 변경 X)

## 3. ArchitectureImpact
N/A (= 신규 interface / 추상화 X · 본문 = paradigm 정책 문서)

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
| VerifyCmds | `git hash-object docs/architecture/external-dep-abstraction.md` (5-repo · sha-16 byte-identical 검증) |

## 9. RollbackStrategy
git revert <propagation commit> 5-repo 측 · 신규 file 영역 한정 (= 비가역 변경 X)

## 10. ExternalPrep / DeferredItems
- `#7-γ GB/GD/GT-MIGRATE-FACADE-001` 별 cycle (= consumer 측 facade 인용 migrate)
- 보호 file 등록 검토 = 별 cycle 영역 (= 본 cycle 시점 P1 권장 등급 한정)

## Plan

1. master 측 `docs/architecture/external-dep-abstraction.md` 신설 (§4 본문 4 sub-section)
2. 4 자식 repo 측 `mkdir -p docs/architecture/` + `cp` (byte-identical)
3. 5-repo sha-16 cross-verify (= 동일 sha 의무)
4. 4 자식 측 stage + commit (cli infra propagation 패턴)
5. master 측 audit commit (= SoT 신설 + propagation 마감 검증)
6. `.ai/reports/<taskId>/` 안 4 file (PLAN + EVIDENCE + VERIFY + REVIEW) 신설

## Notes

- propagate 등급 = P1 권장 byte-identical (cli infra 동족 영역)
- 본문 분량 = B2 적정 (= ~2 page) 정합
- cli session 자체 결정 권한 X 영역 = §4 본문 영역 (= prompt 명시 영역 한정)
