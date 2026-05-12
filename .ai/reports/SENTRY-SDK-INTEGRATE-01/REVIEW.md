# SENTRY-SDK-INTEGRATE-01 — REVIEW

## Meta
| 항목 | 값 |
|---|---|
| Cycle ID | SENTRY-SDK-INTEGRATE-01 |
| 일자 (KST) | 2026-05-11 |
| Scope | 3 repo (GB / GD / GT) × Sentry Android SDK + Gradle plugin + DSN injection + Crashlytics dedup |
| Verdict | **PASS** |

## 1. 결과 요약

3 repo × Sentry Android SDK `7.20.0` + Gradle plugin `4.14.1` 통합 commit 마감. Kotlin 2.0.21 호환 사전 검증 PASS (Firebase BoM 측 사고 패턴 재발 회피). Crashlytics 측 중복 capture 회피 paradigm (`isEnableUncaughtExceptionHandler = false`) 박음. DSN 측 `local.properties` 측 secret 보호 + BuildConfig injection 박음.

## 2. 3 commit sha

| repo | parent | new HEAD | files / insertions |
|---|---|---|---|
| GentlyBreath | `9e6ca5e` | **`219a224`** | 5 files · 32 insertions |
| GentlyDay | `4fcbfbf` | **`ffd8265`** | 5 files · 33 insertions |
| GentlyTable | `1744830` | **`e8bca80`** | 5 files · 32 insertions |

3 commit 측 subject 통일: `feat(sentry): SENTRY-SDK-INTEGRATE-01 integrate Sentry Android SDK + DSN injection + Crashlytics dedup`. body 6 섹션 ([Goal]/[Diff]/[Sha]/[EC]/[Next]/[Refs]) · cycle-discipline §6/§7 정합.

## 3. baseline 사전 검증 (cli 자체 자동)

| 항목 | 결과 |
|---|---|
| 4-repo HEAD baseline (사전) | GB `9e6ca5e` · GD `4fcbfbf` · GT `1744830` · master `9487f16` (FIREBASE-COMMIT-001 baseline 일치) |
| 3 repo × Firebase Crashlytics plugin apply 명시 | ✓ |
| 3 repo × `firebaseBom = "33.7.0"` 보존 | ✓ (drift 0) |
| 3 repo × `local.properties` SUPABASE_URL + SUPABASE_ANON_KEY 명시 | ✓ |
| 3 repo × `.gitignore` line 15 `local.properties` 명시 | ✓ |
| 보호 파일 5종 sha 변동 | ✓ 0 (본 cycle 측 미접촉) |

## 4. Sentry SDK Kotlin 2.0.21 호환 사전 검증 (paradigm 정착)

Firebase BoM 측 Kotlin 2.2.0 metadata incompatibility 사고 (2026-05-11T14:50 · `incident-log.md`) 측 재발 회피 paradigm 적용:

| step | 명령 | 결과 |
|---|---|---|
| 1 | GB × `libs.versions.toml` + `build.gradle.kts` × 2 측 Sentry 영역 edit (1 repo 한정) | ✓ |
| 2 | `./gradlew :app:compileDebugKotlin` | BUILD SUCCESSFUL **46s** · `kotlin_module metadata reject 0` · 호환 PASS |
| 3 | 3 repo × propagation (GD + GT × 5 file 박음) | ✓ |
| 4 | `./gradlew :app:assembleDebug` × 3 repo | BUILD SUCCESSFUL × 3 (GB 16s · GD 22s · GT 24s) |

cycle prompt 측 명시 STOP 조건 (`Sentry SDK 측 Kotlin 2.0.21 호환 mismatch 감지 → 즉시 STOP`) 측 발동 X.

## 5. 변경 영역 (3 repo × 5 file)

| file | 변경 line | byte-identical |
|---|---|---|
| `gradle/libs.versions.toml` | versions 2 (sentry 7.20.0 + sentryGradlePlugin 4.14.1) + library 1 (sentry-android) + plugin 1 (sentry-android) = **4 line** | ✓ |
| `build.gradle.kts` (root) | `alias(libs.plugins.sentry.android) apply false` = **1 line** | ✓ (GT 측 기존 roborazzi apply false 측 별 차이 영역) |
| `app/build.gradle.kts` | plugin alias 1 + sentryDsn val 1 + buildConfigField 1 + dependency 1 + sentry{} block 7 = **11 line** | ✓ (line offset 측 별 차이 = preceding code 측 별) |
| `*Application.kt` | `SentryAndroid` import 1 + `SentryAndroid.init { ... }` block 8 = **9 line** | ✓ |
| `.gitignore` | `# Sentry` + `sentry.properties` + `.sentryclirc` = **3 line** | ✓ |

## 6. Application 측 Sentry.init paradigm

```kotlin
SentryAndroid.init(this) { options ->
    options.dsn = BuildConfig.SENTRY_DSN
    options.environment = if (BuildConfig.DEBUG) "development" else "production"
    options.release = "${BuildConfig.APPLICATION_ID}@${BuildConfig.VERSION_NAME}+${BuildConfig.VERSION_CODE}"
    options.tracesSampleRate = 0.1
    options.isEnableUncaughtExceptionHandler = false
    options.isDebug = BuildConfig.DEBUG
}
```

paradigm 측 명시:
- **Crashlytics 측 중복 capture 회피** = `isEnableUncaughtExceptionHandler = false` (Sentry 측 자동 uncaught handler 측 비활성 → Crashlytics 측 단독 uncaught handler 채택)
- **quota 절약** = `tracesSampleRate = 0.1` (10% sample · Sentry Developer free 5K error/월 + performance trace 측 별 quota)
- **release tracking 박음** = `${APPLICATION_ID}@${VERSION_NAME}+${VERSION_CODE}` 형식 (사후 sentry-cli 측 release upload 활성 시점 측 자동 매칭)

## 7. selective add 결과 (cycle scope isolation 정합)

| 영역 | 처리 | 사유 |
|---|---|---|
| `gradle/libs.versions.toml` | ✓ git add | Sentry scope |
| `build.gradle.kts` | ✓ git add | Sentry scope |
| `app/build.gradle.kts` | ✓ git add | Sentry scope |
| `*Application.kt` | ✓ git add | Sentry scope |
| `.gitignore` | ✓ git add | Sentry secret 보호 (sentry.properties + .sentryclirc 추가) |
| `local.properties` | ✗ git add 제외 | `.gitignore` default · SENTRY_DSN secret 보호 |
| GB/GT × `docs/release-readiness/LAUNCH-STATUS.md` | ✗ git add 제외 | 본 cycle scope X · 별 cleanup pass 측 위임 |
| `.idea/*` · `cc-paste-*.md` · `.ai/reports/MULTI-REPO-RELEASE-LEDGER-INIT-001/` | ✗ git add 제외 | 본 cycle scope X |

## 8. cross-verify (byte-identical 측정)

### libs.versions.toml Sentry 영역 (3 repo × 4 line)
```
sentry = "7.20.0"
sentryGradlePlugin = "4.14.1"
sentry-android = { group = "io.sentry", name = "sentry-android", version.ref = "sentry" }
sentry-android = { id = "io.sentry.android.gradle", version.ref = "sentryGradlePlugin" }
```
→ 3 repo 측 byte-identical ✓

### root build.gradle.kts (Sentry plugin apply false)
```
alias(libs.plugins.sentry.android) apply false
```
→ 3 repo 측 byte-identical (GT 측 기존 `roborazzi apply false` 측 별 차이 영역 · pre-cycle baseline)

### Application class Sentry init (3 repo × 9 line + import 1)
→ 3 repo 측 byte-identical (block 내부 모든 line 동일 · 단 file 내부 위치 측 별 차이 = preceding existing code 측 별)

## 9. cycle prompt 측 명시 의무 측 충족

| 의무 | 결과 |
|---|---|
| Sentry SDK 측 Kotlin 2.0.21 호환 사전 검증 | ✓ GB 측 1 repo 한정 검증 PASS 후 propagation |
| 3 repo × byte-identical Sentry 영역 | ✓ |
| Sentry plugin 측 AGP 8.13.2 호환 | ✓ (assembleDebug PASS 측 정합) |
| DSN 측 local.properties 측 secret 보호 | ✓ (.gitignore line 15 + sentry.properties + .sentryclirc) |
| isEnableUncaughtExceptionHandler = false (Crashlytics dedup) | ✓ |
| 보호 파일 5종 sha 변동 0 | ✓ |
| BoM 33.7.0 baseline 보존 (drift 0) | ✓ |
| 3 commit + decision-log + incident-log + REVIEW.md | ✓ |
| selective add | ✓ out-of-scope 영역 제외 |

## 10. 다음 cycle 측 의뢰 (lazy)

- **Sentry release tracking 활성** — `sentry-cli` 측 release upload + ProGuard mapping upload · internal testing 진입 시점 별 cycle (`autoUploadProguardMapping.set(false)` → `true` 측 활성). Sentry organization slug (human-readable) paste 의무.
- **OkHttp interceptor 측 network error capture** — 도메인 코드 측 OkHttp 사용 시점 별 cycle (Sentry OkHttp module 측 추가).
- **`foundation/core/observability/` wrapper 코드** — 앞 chat 측 결정 영역 · 3-repo wrapper 통합 paradigm.
- **`MASTER-FIREBASE-CYCLE-INFRA-COMMIT-001`** — master cli infra 측 modified + untracked (`.auto-memory/{decision-log,incident-log}.md` + `.ai/reports/FIREBASE-BOM-DOWNGRADE-001/` + `.ai/reports/FIREBASE-COMMIT-001/` + `.ai/reports/SENTRY-SDK-INTEGRATE-01/`) 측 commit candidate.
- **출시 직전** `[FIREBASE-BOM-LATEST-AUDIT-001]` — BoM 33.x.x 마지막 Kotlin 2.0.x 호환 버전 측 binary search + 보안 패치.
- **출시 후** `[KOTLIN-UPGRADE-2.2.X-001]` — Kotlin 2.2 upgrade + Firebase BoM 34.x + Sentry SDK 측 latest 측 재 upgrade.

## 11. Remaining Risks

- Sentry SDK `7.20.0` 측 1차 candidate SUCCESS — 사후 Sentry SDK 측 latest 측 (출시 후 Kotlin 2.2 upgrade 시점) 재 upgrade 의무.
- Sentry plugin 측 Compose ComposeAnimatedProperty 측 unresolved 측 warn (build success · 영향 X) — Compose Animation 측 향후 Compose BoM 측 upgrade 시점 측 별 관찰.
- master cli infra (claude-cli-master) 측 working tree modified + untracked 잔존 — `MASTER-FIREBASE-CYCLE-INFRA-COMMIT-001` 측 lazy commit candidate.
- 3 repo × `docs/release-readiness/LAUNCH-STATUS.md` (GB/GT) + `.idea/*` + `cc-paste-*.md` + `.ai/reports/MULTI-REPO-RELEASE-LEDGER-INIT-001/` 측 working tree 잔존 — 별 cleanup pass 측 위임.

## 12. PromptFit

PromptFitScore: 96/100
PromptFitVerdict: PASS
PromptFitBreakdown:
- Requirement Alignment: 25/25 (Sentry SDK 통합 + DSN injection + Crashlytics dedup paradigm 측 완전 충족)
- Scope Control: 20/20 (Sentry scope 한정 selective add · out-of-scope 영역 측 자동 제외)
- Evidence/Verify Quality: 19/20 (compile 측 사전 호환 검증 + assembleDebug × 3 PASS + byte-identical cross-verify · 1 회 GT Application Edit 측 file-not-read 측 retry mitigation = -1)
- Risk/STOP Handling: 10/10 (Kotlin 호환 사전 검증 paradigm 정착 · cycle prompt 측 STOP 조건 미발동 · 사후 release tracking lazy 박음)
- Output Contract Compliance: 10/10 (3 commit + decision-log + incident-log + REVIEW.md 모두 산출)
- Prompt Efficiency/Clarity: 12/15 (Sentry SDK 측 latest stable 측 fetch 측 외부 docs 측 사전 prompt 측 추정 박음 측 1차 candidate 측 즉시 SUCCESS · 추가 분기점 binary search 측 X)
PromptFitConfidence: high
