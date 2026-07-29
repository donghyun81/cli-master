# Libs Versions Cross-Verify Policy

> **단일 목적**: `gradle/libs.versions.toml` 안 `[versions]` ↔ `[libraries]` artifact 명 ↔ source `.kt` import 의 3-source 정합 사후 검증 (post-edit).
> **신설**: MASTER-LIBS-VERSIONS-CROSS-VERIFY-HOOK-001 (= 본 chat baseline ingest stale 사고 #2 + #3 본질 mitigation · 2026-05-13).
> **연관**:
> - `cycle-discipline.md` §15 패턴 1 (master cycle 신설 + 4-repo propagation)
> - `.claude/hooks/libs-versions-cross-verify.sh` (PostToolUse Edit|Write matcher 자동 검사)
> - `text-degeneration-prevention.md` (동일 hook scaffold patterns)
> SOT: `CLAUDE.md`

---

## 1. 왜 필요한가

본 chat 안 사고 누적 baseline:

| # | 사고 source | 본질 | 발견 시점 |
|---|---|---|---|
| 사고 #2 | `[versions] supabase = "2.6.1"` ↔ `[libraries] supabase-auth = "auth-kt"` | 2.x naming = `gotrue-kt` · 3.x naming = `auth-kt` (3.0.0 rename) → 호환 X | FND-GRADLE-BASELINE-001 안 1차 compile FAIL |
| 사고 #3 | `[versions] supabase = "3.3.0"` ↔ project `[versions] kotlin = "2.0.21"` | 3.3.0 → Kotlin 2.3 stdlib + Ktor 3.3.3 (Kotlin 2.2+ metadata) transitive 인용 → 호환 X | 동 cycle 2차 compile FAIL |

두 사고 모두 = `[versions]` 영역 단독 변경 → 후속 source / artifact 명 정합 검증 부재 → compile 단계에 가서야 발견. mitigation 방향 = **수정 직후 자동 사후 검사** + `[versions]` ↔ `[libraries]` ↔ source import 의 3-source 매트릭스 cross-verify.

---

## 2. 검증 대상 영역

| source | 무엇 | 위치 |
|---|---|---|
| **A** | `[versions] <key> = "<value>"` | `gradle/libs.versions.toml` |
| **B** | `[libraries] <alias>.module = "<group>:<artifact>"` (+ `version.ref = "<key>"`) | 동 file |
| **C** | source import 문 (`import <package>.<symbol>`) | `<repo>/src/**/*.kt` (`commonMain` + `androidMain` + `iosMain` + `main` 모두 cover · `app/src/**/*.kt` 포함) |

---

## 3. 매칭 규칙 (확장 가능 · 본 cycle 초기 seed)

### R1 — supabase-kt naming ↔ version major 매핑

| version 영역 | 인증 artifact | 인증 package |
|---|---|---|
| 1.x | `gotrue-kt` | `io.github.jan.supabase.gotrue` |
| 2.x | `gotrue-kt` | `io.github.jan.supabase.gotrue` |
| 3.x | `auth-kt` | `io.github.jan.supabase.auth` |

위반 case (cross-check FAIL):
- `[versions] supabase` 이 `"2.*"` 으로 시작 + `[libraries]` 안 `auth-kt` artifact 인용 → FAIL.
- `[versions] supabase` 이 `"3.*"` 으로 시작 + `[libraries]` 안 `gotrue-kt` artifact 인용 → FAIL.
- source import 에 `io.github.jan.supabase.auth.*` 있고 `[versions] supabase` 이 `"2.*"` → FAIL.
- source import 에 `io.github.jan.supabase.gotrue.*` 있고 `[versions] supabase` 이 `"3.*"` → FAIL.

### R2 — Kotlin major minor ↔ supabase major 호환 매트릭스 (참고만 · enforce 영역 X)

| kotlin 영역 | 호환 supabase 영역 (검증된 baseline) |
|---|---|
| 2.0.x | supabase 3.0.x ~ 3.0.2 |
| 2.1.x | supabase 3.1.x ~ |
| 2.2.x | supabase 3.2.x ~ |
| 2.3.x | supabase 3.3.x ~ |

본 표 = lazy default · 본 cycle hook 안 hard check 영역 X (= 경고 warn 영역). 향후 별 cycle 안 확장 검토.

### R3 — 신규 매칭 규칙 추가 절차

1. 본 §3 측 새 sub-section 추가 (R<n>).
2. `.claude/hooks/libs-versions-cross-verify.sh` 안 RULES 영역 갱신.
3. master cycle 신설 (`MASTER-LIBS-VERSIONS-CROSS-VERIFY-RULE-ADD-NNN` 또는 동등).
4. 4-repo propagate 의무.

---

## 4. 검증 진입 조건 (trigger)

PostToolUse `Edit|Write` matcher 안 본 hook 발화. 본 hook 안 = 다음 영역 변경 감지 시점만 검증 진입:

| 영역 | trigger 조건 |
|---|---|
| `gradle/libs.versions.toml` | 직접 변경 → 무조건 검증 |
| `**/src/**/*.kt` (commonMain / androidMain / iosMain / main / app) | 검증 진입 (= 변경 file 안 supabase 또는 등록 패키지 import 인용 영역만) |
| 그 외 | skip |

---

## 5. mode (env var: `LIBS_VERSIONS_ENFORCE`)

| mode | 기본 | 동작 |
|---|---|---|
| `warn` | **default** | stderr 측 mismatch 인용만 출력 · exit 0 (도구 사용 허용) |
| `enforce` | (= 별 cycle 후보) | mismatch 발견 시 exit 2 (도구 사용 차단) |

승격 영역 = baseline ingest stale 사고 누적 추가 발화 시 별 cycle 진입 평가.

---

## 6. self-test 방법

```bash
# 자체 baseline 검증 (= mismatch 0 의무 · 4-repo 마감 후 PASS)
bash .claude/hooks/libs-versions-cross-verify.sh

# 특정 파일 simulate (= positional arg fallback)
bash .claude/hooks/libs-versions-cross-verify.sh gradle/libs.versions.toml
```

---

## 7. 적용 영역

| repo | hook 활성 | 의무 |
|---|---|---|
| claude-cli-master | ✓ | `libs.versions.toml` 인용 부재 (= cli infra source) · self-test 만 의무 |
| GentlyBreath / GentlyDay / GentlyTable | ✓ | `gradle/libs.versions.toml` + app/src/**/*.kt 변경 시 자동 검사 |
| app-foundation | ✓ | `gradle/libs.versions.toml` + core/**/src/**/*.kt 변경 시 자동 검사 |

---

## 8. STOP 조건

- hook self-test 안 본 SoT 또는 hook script 자체가 §3 R1 위반 (= 자체 정합 사고)
- 신규 rule 추가 시 R3 절차 미준수
- 사용자 측 mismatch 발견 후 mitigation 부재 시점

---

## 9. mitigation cycle 패턴

| 단계 | 절차 |
|---|---|
| 1. 감지 | hook warn 또는 사용자 지적 |
| 2. 분류 | 어느 R<n> 위반 |
| 3. 정정 | `[versions]` 또는 `[libraries]` 또는 source import 측 한 영역 정정 (= cli session freedom · 사용자 결정 의뢰 default) |
| 4. 재검증 | hook 재 실행 → mismatch 0 확인 |
| 5. 기록 | 한 줄 entry 를 `.auto-memory/incident-log.md` append (= 누적 추적) |

---

## 9a. Koin 4.0.0 → 4.2 + Compiler Plugin 상향 (후행 · 선택)

현 baseline = `koin = "4.0.0"` (app-foundation + Selfward `libs.versions.toml` 실측 · 2026-07-26).

- 상향 시 4-repo 동시 검증: master 정의 → `propagate.sh` → 자식별 `./gradlew test` + 조합 회귀 가드
  (production 바인딩 identity assertion · `verification-and-review.md` §/verify) 재실행 → `verify-sync.sh` exit 0.
- **★선결 조건이 아님을 명기**: Koin Compiler Plugin 은 **F1 을 잡지 못한다.** 플러그인의 검증 범위는
  *"structural dependency presence, **not semantic correctness**"* 이므로 **NoOp 기본값은 언제나
  정상 해석된다.** 구조적 방어는 플러그인이 아니라 **기본값 제거**다
  (`code-principles.md` §2 암묵 기본값 금지 · `billing-rules.md` §1 명시 조합). 도입은 **후행 선택**이며
  **안전성 근거가 될 수 없다** — "플러그인을 넣었으니 기본값을 되살려도 된다" = 금지된 추론.

---

## 10. 본 SoT 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 4-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## 11. 명시 cycle 이력

- 2026-05-13 · MASTER-LIBS-VERSIONS-CROSS-VERIFY-HOOK-001 · 본 SoT 신설 + hook `libs-versions-cross-verify.sh` + settings.json PostToolUse 등록 + 5-repo propagation.
- 2026-07-26 · MASTER-CLI-COMPOSITION-RULES-S3-001 · §9a Koin 4.0.0 → 4.2 + Compiler Plugin 상향 절차 신설 (= 후행·선택 · 플러그인이 F1 을 잡지 못함을 명기 = 안전성 근거 오용 차단). R1~R3 매칭 규칙 + hook 로직 무접촉. 4-repo byte-identical propagation.
