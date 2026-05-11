## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-RELEASE-CHECKLIST-TEMPLATE-001 |
| Mode | ops-layer (master template 신설) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | .ai/tasks/MASTER-RELEASE-CHECKLIST-TEMPLATE-001.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 7 (template 1 신설 · PACKAGE-OVERVIEW 1 edit · decision-log 1 append · task 1 신설 · PLAN/EVIDENCE/VERIFY/REVIEW 4 신설) |
| Modules | docs/templates · docs/release-readiness · .auto-memory · .ai/tasks · .ai/reports |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `test -f docs/templates/release-checklist.template.md && grep -c '^## [0-9]\. ' docs/templates/release-checklist.template.md && grep -c '^| MASTER-T03 .* ✓' docs/release-readiness/PACKAGE-OVERVIEW.md && grep -c 'MASTER-RELEASE-CHECKLIST-TEMPLATE-001' .auto-memory/decision-log.md` |

> **Risk 기반 경량화**: Low Risk = §1 ChangeBudget + §8 VerificationPlan + 작업 목록만 필수. §2~§7, §9~§10 = N/A.

## 2~7, 9~10 (N/A)
- §2 DependencyDecision: N/A (의존성 변경 없음)
- §3 ArchitectureImpact: N/A (ops-layer · 도메인 코드 무변경)
- §4 ModelBoundaryPlan: N/A
- §5 ErrorPolicy: N/A
- §6 UIStateFlowPlan: N/A
- §7 TestabilitySeams: N/A
- §9 RollbackStrategy: `git revert <commit>` 으로 즉시 복구 (문서 전용)
- §10 ExternalPrep / DeferredItems: N/A

## Plan

1. **task doc 신설** — `.ai/tasks/MASTER-RELEASE-CHECKLIST-TEMPLATE-001.md` (Meta + 원문 + 성공 조건 + EC1-EC5)
2. **PLAN.md 신설** (본 파일)
3. **EVIDENCE.md 신설** — Intake + Pre-EVIDENCE 계약 + Collect Results (3 자식 LAUNCH-STATUS §7~§9 공통 추출) + Cleanup Assessment N/A
4. **release-checklist.template.md 신설** — 9 섹션:
   - §1 Play Console (8 공통 + `<domain-special-disclosure>` placeholder)
   - §2 App Store Connect (Phase 2 lazy · placeholder)
   - §3 컴플라이언스 (Privacy + Terms + GDPR + KISA + 데이터 안전 폼)
   - §4 권한 (POST_NOTIFICATIONS 공통 + `<domain-permissions>` placeholder)
   - §5 성능 budget (`<apk-budget>` + cold start ≤ 1500ms + `<memory-budget>` + `<domain-latency>` placeholder)
   - §6 KPI baseline (D7 retention + paid conv + `<domain-kpi>` placeholder)
   - §7 kill-switch 게이트 (출시 후 8 주 평가)
   - §8 ASO (키워드 + 카피 + 스크린샷)
   - §9 Privacy 호스팅 (Privacy Policy URL + Terms URL)
5. **PACKAGE-OVERVIEW.md edit** — line 48 T03 row ☐ → ✓ + sha 12자 + 본심 / line 16 master row P0 progress 2/8 → 3/8
6. **decision-log.md append** — MASTER-T03 entry (cycle marker + 본심 + 근거 + 검증)
7. **VERIFY.md 신설** — verify cmds + LOG + exit code 기록
8. **REVIEW.md 신설** — 3-section Low Risk lightweight (Requirements + Regression + Secrets) + Verdict PASS
9. **commit** — `feat(template): MASTER-RELEASE-CHECKLIST-TEMPLATE-001 add release-checklist.template.md (자식 P4 cp 표준)` + 6-section body + Co-Authored-By

## Notes

- 자식 P4 진입 시 본 template `cp` 후 `<RepoName>` / `<domain-permissions>` / `<apk-budget>` / `<memory-budget>` / `<domain-latency>` / `<domain-kpi>` / `<domain-special-disclosure>` 도메인 치환 + 실측 갱신 의무.
- 본 cycle = master single-repo scope (자식 propagation X).
- 보호 파일 5종 sha 무변동 의무 (verify-sync 영향 X).
