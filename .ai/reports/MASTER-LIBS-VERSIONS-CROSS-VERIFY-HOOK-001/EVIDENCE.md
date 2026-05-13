## Requirements Source
- 통합 prompt MASTER-LIBS-VERSIONS-CROSS-VERIFY-HOOK-001 (cowork 측 발행 · 2026-05-13).
- handoff v8 §B-4 baseline ingest stale 사고 #2 + #3 정합.
- `baseline_ingest_stale_pattern.md` (사용자 측 memory) 정합.
- Authority boundary: claude-cli-master 단일 source · 5-repo propagate target · 자식 도메인 코드 무접촉.

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (cli infra rule + hook 신설 + settings.json + propagation) |
| Reading Mode | CLI 운영 레이어형 |
| Requirement Source | 충족 (통합 prompt + handoff v8 + memory) |
| Info Gap | RESOLVABLE_IN_REPO (= 사고 #2 + #3 baseline 인용 PASS · 기존 hook patterns 인용 PASS) |
| STOP Risk | None (보호 5 + 자식 도메인 코드 무접촉 사전 확인) |
| Read-Only Fan-Out | text-degeneration-prevention.md (= hook scaffold 패턴) · post-edit-degeneration-check.sh (= hook patterns 차용) · repo-config.sh (= 5-repo propagate target list) |
| Implementer Entry | Allowed |

## Pre-EVIDENCE Contract
- Read evidence: master HEAD (dfea364) + 보호 5 sha (5b84cd9e/d3a0b573/e580b6d7/3a703b30/b27fbe16) + 자식 4-repo HEAD (GB 1176e56 / GD 2299ab0 / GT 587f549 / foundation 8ce75f6) + settings.json hooks 영역 + propagate.sh 인용 모두 실측 PASS.
- Remaining gaps: R2 (Kotlin ↔ supabase) hard enforce 영역 = lazy default · 본 cycle scope 외.
- Chosen path: 신 file `.claude/rules/libs-versions-cross-verify.md` 신설 + `.claude/hooks/libs-versions-cross-verify.sh` 신설 + settings.json PostToolUse Edit|Write 묶음 등록 + 5-repo propagate.
- Hold / Stop reasons: 없음 (= 단일 cycle 안 마감 가능 영역).
- Implement entry conditions: PLAN.md 작성 완료 + STOP 조건 5 항 모두 위반 X 사전 검증.

## Collect Results

### 매칭 파일 / 패턴
- `claude-cli-master/.claude/hooks/post-edit-degeneration-check.sh` — scaffold patterns 인용 (stdin/positional fallback · python3 inline · warn default · self-test).
- `claude-cli-master/.claude/hooks/check-abbreviation.sh` — Edit|Write matcher 동족 hook.
- `claude-cli-master/.claude/settings.json:127-148` — PostToolUse 묶음 baseline.
- `claude-cli-master/scripts/propagate.sh:1-50` — propagation 진입 패턴 (`--targets all` 옵션 인용).
- `claude-cli-master/scripts/repo-config.sh:27` — `TARGET_REPOS = GentlyBreath GentlyDay GentlyTable app-foundation` (4 자식).
- `app-foundation/gradle/libs.versions.toml:22` — `supabase = "3.0.2"` (= 본 chat 사고 #3 후 정정 결과).
- `app-foundation/gradle/libs.versions.toml:87` — `supabase-auth = "io.github.jan-tennert.supabase:auth-kt"` (= 3.x naming · 정합).
- `app-foundation/core/supabase/src/commonMain/kotlin/com/gently/foundation/supabase/auth/AnonymousAuthBootstrap.kt:3` — `import io.github.jan.supabase.auth.auth` (= 3.x convention).
- `.auto-memory/incident-log.md:331-345` — 직전 cycle (MASTER-INCIDENT-L2-CLASSIFICATION-2APPEND-001) 사고 14건 분류 baseline.

### 0 Matches (부재 증거)
- claude-cli-master 측 `gradle/libs.versions.toml` 부재 (= cli infra source · 의존 정의 X · 본 cycle self-test 안 trigger 조건 = TOML 부재 시 skip).
- 자식 3-repo (GB/GD/GT) 측 `libs.versions.toml` 안 `supabase` key 미발견 (= 별 trail audit 대상 · 본 cycle scope 외).
- 본 cycle 안 보호 5 file 측 sha 변동 0 + 자식 도메인 코드 측 .kt 변경 0.

## Key Findings
- 본 chat 사고 #2 + #3 모두 = `[versions]` 영역 단독 변경 후 [libraries] artifact 명 / source import 정합 자동 검증 부재 → compile 단계까지 진행 후 발견. mitigation 본질 = 사후 자동 검사 + 3-source 매트릭스.
- jan-tennert/supabase-kt 측 artifact rename history: 2.x = `gotrue-kt` + `io.github.jan.supabase.gotrue.*` package / 3.x = `auth-kt` + `io.github.jan.supabase.auth.*` package (3.0.0 release 안 rename · changelog 인용).
- foundation 측 `libs.versions.toml` 현 상태 = `supabase = "3.0.2"` + `auth-kt` artifact + `io.github.jan.supabase.auth.*` import 3-source 정합 PASS (= 본 cycle hook self-test 결과 exit 0).
- 자식 3-repo (GB/GD/GT) 측 `libs.versions.toml` 안 supabase 영역 미발견 = 별 trail audit 대상. 현 시점 hook 실행 시 본 영역 skip (= TOML 부재 또는 supabase key 부재 시 mismatch 검출 영역 X · false positive 회피 정합).

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경 · cli infra rule + hook 신설 영역).
