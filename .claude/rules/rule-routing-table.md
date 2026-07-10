# Rule Routing Table — 행동(Reading Mode 7종) → 의무 로드 (intake 시 본 표만 정독)

> 본 file = `rule-routing-index.md` §B 의 독립 실사용 판 (= MASTER-CLI-CONTEXT-DIET-2-001 T2 · 원문 §B = index-COLD 보존). **intake 시 = 본 표만 정독** · index 전문 정독 = 색인 갱신 cycle 한정. 갱신 = index §D 와 동기 의무.
> **L0 (항상 적용)** = `safety-and-secrets` + `anchor-list` + `cross-repo-parallel-exec`(kernel) + master `CLAUDE.md §5`(STOP 9항) + 부모 root `CLAUDE.md`.
> **L0 재정독 개정 (T5)**: 세션 **최초 1회 Read** → 이후 cycle = SessionStart hook 주입값(branch·baseline 등) + 경량 실측(HEAD sha · 보호 manifest 대조)로 **갈음** · drift 신호 시만 해당 파일 재Read + 재실측. **STOP #5 (보호 sha drift) 로직 불변**.

| Reading Mode | 의무 로드 (L0 +) |
|---|---|
| 1. 구현형 | L1: workflow-core · cycle-discipline · verification-and-review · reporting · routing-and-delegation · legacy-cleanup-governance · mode-system(M1/M3) · libs-versions-cross-verify(의존성 변경 시) / L2: code-style-guide · code-principles · 테스트 시 TESTING_STRATEGY+TDD_WORKFLOW+TESTABILITY_SEAMS / L3(키워드 시): auth-rules · billing-rules · supabase-handling · deferred-domains |
| 2. UI-UX형 | L1: workflow-core · cycle-discipline · verification-and-review · reporting / L2: code-style-guide · design-to-code-sync · design-prompting-paradigm · code-principles · 테스트 시 TESTING_STRATEGY / L3: ui-ux-analysis · ux-laws · uiux-sot-refresh(보호) · sot-code-name-map + Pencil 시 pencil-uiux-workflow(보호) 및 Pencil cluster |
| 3. API-서버형 | L1: workflow-core · cycle-discipline · verification-and-review · reporting / L2: code-style-guide · code-principles · 테스트 시 TESTING_STRATEGY / L3: supabase-handling · auth-rules · billing-rules · deferred-domains(Backend/Data STOP) |
| 4. 빌드-릴리즈형 | L1: cycle-discipline(§13 환경 정합) · libs-versions-cross-verify · initiatives-auto-sync · verification-and-review · reporting · working-file-lifecycle |
| 5. 정책-계획 점검형 | L1: workflow-core · cycle-discipline · mode-system · automation-policy · plugin-policy · workflow-policy(Workflow 도구 시) · recommended-option-disk-verification · paste-authoring-disk-verification · terminology · text-degeneration-prevention · architecture-foundation-link-policy · reporting |
| 6. CLI 운영 레이어형 (M5) | L0 강조: cross-repo-parallel-exec(kernel) · safety-and-secrets / L1: cycle-discipline(§3·§15) · mode-system(M5) · automation-policy · reporting · working-file-lifecycle · recommended-option-disk-verification · paste-authoring-disk-verification · text-degeneration-prevention · gsm-measurement(계측·amend 시) + cross-repo 행동 시 cross-repo-parallel-exec-detail |
| 7. task 재개-후속형 | L1: workflow-core(Context Reset/HANDOFF) · reporting(§9 Subagent Return) · cycle-discipline(§8) |

> `abbreviation-policy` = 의무 로드 제외 (T4 · enforcement SoT = `check-abbreviation.sh` hook enforce · 위반 시 stderr 노출). L3 = 키워드 trigger 시만 (무조건 로드 X). bulk read 금지. PLAN/REVIEW 스키마 템플릿 = **Risk ≥ Medium 시만** `docs/templates/{plan-10-section,review-12-section}.template.md` Read (T3).
