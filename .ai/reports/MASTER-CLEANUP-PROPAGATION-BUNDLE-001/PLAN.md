# PLAN — MASTER-CLEANUP-PROPAGATION-BUNDLE-001

## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-CLEANUP-PROPAGATION-BUNDLE-001 |
| Mode | ops-layer (cli infra propagation) |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | 본 cycle prompt + cowork chat baseline 재 측정 |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 자식 4 측 cycle scope file 변경 (app-foundation 2 + GB/GD/GT 각 1) + master 측 산출물 4 + memory 3 + report dir 신설 = 자식 5 commit + master 1 audit commit |
| Modules | cli infra 권장 (.claude/rules + docs/templates) · .auto-memory · .ai/reports |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A (의존성 변경 X · 본 cycle = 단순 file propagation)

## 3. ArchitectureImpact

N/A (도메인 코드 무접촉)

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
| VerifyCmds | `bash scripts/verify-sync.sh` + 5-repo sha-16 cross-verify (cycle-discipline.md + release-checklist.template.md) + 보호 5 sha 재 측정 |

## 9. RollbackStrategy

문서 / cli infra 전용 영역 — git revert 측 자식 5 commit + master audit commit 1 회 측 복구 가능. 도메인 코드 무접촉 · 빌드 영역 무관 (= 즉시 복구 가능).

## 10. ExternalPrep / DeferredItems

N/A

## Plan

1. STEP 1 — baseline 사전 검증 (5-repo HEAD + 두 source sha + 보호 5 sha + 작업 트리 dirty 영역 사전 인지).
2. STEP 2 — TRAIL-1+11 propagation (cycle-discipline.md master HEAD blob → app-foundation · cp + 명시 path add).
3. STEP 3 — TRAIL-2 propagation (release-checklist.template.md master HEAD blob → 자식 4 · mkdir + cp + 명시 path add).
4. STEP 4 — byte-identical 5/5 cross-verify (양쪽 file · 보호 5 sha 재확인).
5. STEP 5 — 자식 4 측 commit (app-foundation 2 file 묶음 + GB/GD/GT 1 file 단일).
6. STEP 6 — 산출물 (EVIDENCE/PLAN/VERIFY/REVIEW.md) + memory 3 entry 갱신 + master audit commit (명시 path 만 add).

## Notes

- 본 cycle = ops-layer 영역 · code-principles.md §B 적용 X (= 도메인 코드 무접촉).
- mitigation patterns 3 step (text-degeneration-prevention.md §11 정합) 의무 = 산출물 작성 시 paraphrase + mental scan + hook 사후 재 검증 영역 정합.
- 별 cycle (= TRAIL 외 영역) 자체 흡수 X 의무.
