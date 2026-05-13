## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-LIBS-VERSIONS-CROSS-VERIFY-HOOK-001 |
| Mode | ops-layer (cli infra rule + hook 신설 + 5-repo propagation) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cycle prompt (cowork 발행 · 2026-05-13) + handoff v8 §B-4 + baseline_ingest_stale_pattern.md memory |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | master 3 (rule + hook + settings.json edit) + 자식 4 × 3 (propagate cp) + report 4 + task 1 + decision-log entry = 본 cycle 합본 |
| Modules | `.claude/` (rule + hook + settings.json) · `.auto-memory/` (decision-log entry) · `.ai/{tasks,reports}/` |
| Risk | Low (ops-layer · 제품 코드 미변경 · warn default) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision
N/A — 신규 의존성 0 (= python3 + bash 기존 hook 패턴 차용).

## 3. ArchitectureImpact
- 새 인터페이스 / 추상화: PostToolUse Edit|Write matcher 묶음 안 hook 추가 (= 기존 patterns 정합 · text-degeneration-prevention + post-policy-watch + check-abbreviation 동족).
- 변동성 경계 유형: ops-layer (= 제품 코드 영역 외).
- 레이어 누수 위험: N/A (rule + hook 영역 단일).
- shared-first 경계 영향: N/A.

## 4. ModelBoundaryPlan
N/A.

## 5. ErrorPolicy
N/A.

## 6. UIStateFlowPlan
N/A.

## 7. TestabilitySeams
N/A · 단 hook self-test 영역 의무 (= positional arg fallback + mismatch fixture 안 R1a+R1b 검출 검증).

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash .claude/hooks/libs-versions-cross-verify.sh /Users/yundonghyeon/AndroidStudioProjects/app-foundation/gradle/libs.versions.toml` (exit 0 의무 · foundation 측 baseline mismatch 0) + `bash scripts/propagate.sh .claude/rules/libs-versions-cross-verify.md .claude/hooks/libs-versions-cross-verify.sh .claude/settings.json --targets all` (ok=12 fail=0 의무) + `bash scripts/verify-sync.sh` (= 본 cycle 측 3 file PASS 의무 · 잔존 DRIFT 2 = FND-GRADLE-BASELINE-001 측 gradlew + gradlew.bat 영역 = 본 cycle scope 외) + `for f in <보호 5>; do git hash-object $f; done` (= 보호 sha 무변동 의무) |

## 9. RollbackStrategy
`git revert <commit>` 으로 즉시 복구 가능 (= 단일 commit · 신설 영역만 · 기존 file 측 settings.json edit = 1 hook entry 추가 영역 단독).

## 10. ExternalPrep / DeferredItems
- 별 trail N1-β (baseline ingest 전반 hook 확장 · master HEAD + cli infra 9 file + 보호 5 sha 흡수 정합) = 본 cycle 마감 후 별 cycle.
- 자식 repo 측 `libs.versions.toml` 안 supabase 영역 미발견 audit = 별 cycle (자식 측 의존 위치 측정).
- R2 (Kotlin ↔ supabase 호환 매트릭스) hard enforce 영역 = 향후 별 cycle 후보 (현 시점 warn-only).

## Plan

1. STEP 1 — `.claude/rules/libs-versions-cross-verify.md` 신설 (정책 SoT · 11 섹션 · R1 supabase naming 매핑 + R2 Kotlin 호환 매트릭스 + R3 rule 추가 절차).
2. STEP 2 — `.claude/hooks/libs-versions-cross-verify.sh` 신설 (bash + python3 inline · trigger filter · 3-source parse · R1a/R1b/R1c 검출 · warn default + enforce mode).
3. STEP 3 — `chmod +x` 부여.
4. STEP 4 — `.claude/settings.json` PostToolUse Edit|Write 묶음 안 hook 등록.
5. STEP 5 — self-test (= master self · foundation toml self · mismatch fixture R1a+R1b 검출 검증 · enforce mode exit 2 검증).
6. STEP 6 — 5-repo propagate (= `propagate.sh ... --targets all`).
7. STEP 7 — verify-sync 측 본 cycle 3 file PASS 확인 (잔존 DRIFT 2 = 본 cycle scope 외 명시).
8. STEP 8 — 자식 4-repo 각 commit (= propagation 영역 단독 · `chore(infra)` 자동 허용).
9. STEP 9 — 산출물 4 file + decision-log entry + master 단일 commit (`docs(rule)` 또는 `chore(infra)` · cycle-discipline §5 v2 자동 허용).

## Notes
- 사용자 freedom 안 결정 = 신 file `.claude/rules/libs-versions-cross-verify.md` 신설 (= 기존 rule 확장 X · 단일 목적 SoT 정합).
- mode = warn default (= 본 cycle 진입 시점 사용자 측 부담 회피 · enforce 승격 = 별 cycle 후보).
- 3-source 알고리즘 = artifact name + version major 매핑 (R1) + source import package 정합 (R1b/R1c). R2 (Kotlin ↔ supabase 호환) = lazy default · 본 cycle scope 안 hard check X.
- self-test 측 fixture = mismatch case `supabase = 2.6.1 + auth-kt + auth.* import` (= 본 chat 사고 #2 + #3 본질 재현) → R1a + R1b violation 검출 PASS.
