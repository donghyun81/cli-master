# EVIDENCE — GD-ANON-AUTH-SIGNUP-DIAGNOSE-001

## Requirements Source
- 부모 cycle = `MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001` (PARTIAL · 2026-05-05) Findings F7 + F8
- F7: GD onboarding step5 anon auth 진입 시 "로그인이 필요합니다 · 다시 시도해 주세요 · 홈으로 이동" → 익명 부트스트랩 실패
- F8: F7 cascade 영역 → main 5 화면 (Sleep / Habits / Reports / Settings / Ticket) BLOCKED (audit 진입 불가)
- 본 cycle = F7 + F8 mitigation 진단 단일 cycle
- Coin 결정 (2026-05-05 turn) = 옵션 A (b) 진단 보고 마감 + 별 cycle 분리

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | 진단 보고 (audit / read-only) |
| Reading Mode | Auth 도메인 / GD repo |
| Requirement Source | 부모 runtime audit Findings F7/F8 인용 |
| Info Gap | RESOLVABLE_IN_REPO (코드 영역 / build config) + BLOCKED (Supabase project 영역 = Coin prep) |
| STOP Risk | Auth 도메인 (deferred-domains.md §1 trigger) — Coin 명시 진입 ✓ |
| Read-Only Fan-Out | auth-security-privacy agent (활성 영역 인지만 / 호출 X) |
| Implementer Entry | Blocked (코드 영역 변경 의무 0 · envvar 영역 = Coin prep) |

## Pre-EVIDENCE Contract
- Read evidence: auth-rules.md §1~4 / GD auth 코드 5 파일 (AnonymousAuthBootstrap / SupabaseAuthClient / SupabaseAuthClientImpl / AuthRepositoryImpl / GentlyDayApp / AppModule) / app/build.gradle.kts SUPABASE 영역 / local.properties 부재 / adb logcat
- Remaining gaps: Supabase dashboard 안 Anonymous Sign-In provider 활성 영역 = CLI 측 검증 X (Coin prep)
- Chosen path: 진단 보고 마감 + 별 cycle 분리 (Coin 결정 A)
- Hold/Stop reasons: STOP 조건 1 (Supabase project URL/anon key 본질 변경) + STOP 조건 2 (auth-rules.md §1 SoT 변경) + STOP 조건 3 (보호 파일 5 sha 변동) 모두 진입 X
- Implement entry conditions: 별 cycle (Coin prep 마감 후) — 본 cycle = read-only audit 한정

## Collect Results

### 본질 영역 (CONFIRMED)

**`~/AndroidStudioProjects/GentlyDay/local.properties` 파일 부재** — `ls -la` 결과 `No such file or directory`

영향 흐름:
```
local.properties 부재
  ↓
app/build.gradle.kts:36-49 localOrStub() fallback
  ↓
BuildConfig.SUPABASE_URL = "https://placeholder.supabase.co"
BuildConfig.SUPABASE_ANON_KEY = "placeholder-anon-key"
  ↓
SupabaseProvider.getClient() (GentlyDay/app/src/main/java/com/example/gentlyday/data/remote/SupabaseProvider.kt:19-20)
  ↓
client.auth.signInAnonymously() (SupabaseAuthClientImpl.kt:13)
  ↓
Supabase API (placeholder host) 호출 → DNS 해석 실패 또는 401 unauthorized
  ↓
AnonymousAuthBootstrap.kt:32-44 (1차 + 1회 retry) 모두 fail
  ↓
DomainResult.Failure(DomainError.Network(...))
  ↓
GD onboarding step5 UI = "로그인이 필요합니다 · 다시 시도해 주세요 · 홈으로 이동"
  ↓
F7 cascade → F8 main 5 화면 BLOCKED (audit 진입 X)
```

### 코드 영역 정합 cross-verify (CONFIRMED)

| 파일 | line | 정합 영역 | auth-rules.md 정합 |
|---|---|---|---|
| `data/auth/AnonymousAuthBootstrap.kt` | 25-45 | 기존 userId 재사용 → 없으면 signInAnonymously + 1회 retry → 실패 시 `DomainError.Network` | §1 익명 부트스트랩 paradigm ✓ |
| `data/auth/SupabaseAuthClientImpl.kt` | 11-23 | `client.auth.signInAnonymously()` + `currentSessionOrNull()` → SessionData 변환 | Supabase Kotlin SDK 표준 patterns ✓ |
| `data/auth/Auth.kt` | 9-13 | `interface SupabaseAuthClient` + `SessionData` data class | DIP (`code-principles.md` §1.D) ✓ |
| `data/repository/AuthRepositoryImpl.kt` | 30-87 | bootstrap → state 갱신 / signOut → rebootstrap / refreshSessionIfNeeded | §4 AuthRepository 패턴 ✓ |
| `GentlyDayApp.kt` | 20-29 | `Application.onCreate()` 안 `GlobalContext.get().get<AnonymousAuthBootstrap>()` 호출 | §1 "Application.onCreate() 진입 시 호출" ✓ |
| `di/AppModule.kt` | 131 | `single { AnonymousAuthBootstrap(get(), get(), get(), get()) }` Koin 등록 | DI baseline ✓ |
| `data/remote/SupabaseProvider.kt` | 19-20 | `BuildConfig.SUPABASE_URL` + `BuildConfig.SUPABASE_ANON_KEY` 주입 | envvar 의존 영역 ✓ |

**판정**: 코드 영역 = auth-rules.md §1~4 정합 ✓ · 정정 의무 0.

### envvar / build config 영역 (CONFIRMED)

`app/build.gradle.kts:36-49`:
```kotlin
// TODO(user-prep): local.properties 에 SUPABASE_URL, SUPABASE_ANON_KEY 주입
buildConfigField(
    "String",
    "SUPABASE_URL",
    "\"${localOrStub("SUPABASE_URL", "https://placeholder.supabase.co")}\""
)
buildConfigField(
    "String",
    "SUPABASE_ANON_KEY",
    "\"${localOrStub("SUPABASE_ANON_KEY", "placeholder-anon-key")}\""
)
```

`localOrStub()` 함수가 `local.properties` 안 키 부재 시 두 번째 인자 (placeholder) 영역 fallback. 본 cycle 진단 시점 = `local.properties` 자체 부재 → 두 placeholder 모두 BuildConfig 주입.

### Supabase project 영역 (BLOCKED — Coin 측 검증 의무)

`AnonymousAuthBootstrap.kt:16` 인용 명시:
```
* user-prep: Supabase project 의 Anonymous provider 활성화 의무.
```

`auth-rules.md` §1 정합:
```
- GoTrue REST `POST /auth/v1/signup` body `{}` (Supabase 익명 user 자동 생성)
```

CLI 측 검증 X 영역:
- Supabase dashboard 안 GD project 신설 또는 GT/GB 기존 project 공용 결정
- Anonymous Sign-In provider 활성 여부

### auth-security-privacy agent 영역 (CONFIRMED)

`/Users/yundonghyeon/AndroidStudioProjects/GentlyDay/.claude/agents/active/auth-security-privacy.md` 존재 → ACTIVE 영역. 본 cycle 진입 시 자동 발화 trigger 정합 (`deferred-domains.md` §5 키워드 "anon" / "auth" / "signin"). 본 cycle = Coin 명시 진입 영역 → STOP 회피 ✓.

### adb logcat 영역 (RESOLVABLE_IN_REPO · 부분)

`adb -s emulator-5554 logcat -d | grep -iE 'supabase|anon|signup|auth'` 결과:
- 시간 영역 = 2026-05-03 23:50 ~ 2026-05-06 04:30
- 본 GD 앱 영역 (com.example.gentlyday tag) = 진입 0 회
- 시스템 영역 만 인용 (BiometricService / CredentialManager / Bugle / Authzen)

해석: emulator 영역 본 GD 앱 진입 시점 logcat rotate 또는 audit 시점 (2026-05-05) 이후 진입 X. F7 cascade = step5 UI 인용만 (코드 흐름 진단 = static analysis 영역 정합 ✓).

### 0 Matches (부재 증거)

- `~/AndroidStudioProjects/GentlyDay/local.properties` = 부재 (CONFIRMED)
- adb logcat 안 `com.example.gentlyday` tag = 0 hits
- Supabase signup 호출 흔적 (logcat) = 0 hits

### scope 외 영역 검증 (STOP 조건 진입 X)

| STOP 조건 | 진입 여부 |
|---|---|
| 1. Supabase project 본질 변경 (URL / anon key) | X (Coin prep 영역 분리) |
| 2. auth-rules.md §1 SoT 갱신 | X (코드 정합 ✓ · 갱신 의무 X) |
| 3. 보호 파일 5 종 sha 변동 | X (read-only audit) |
| 4. auth-security-privacy agent 자체 변경 | X (인지만 / 호출 X) |
| 5. anon auth 외 영역 (이메일 / 패스워드 auth) | X (scope 한정) |

## Key Findings

1. **본질 영역 (F7 RCA)** = `~/AndroidStudioProjects/GentlyDay/local.properties` 파일 부재 → BuildConfig placeholder fallback → Supabase API placeholder host 호출 → `DomainError.Network` → step5 wording.
2. **코드 영역 정합 ✓** = auth-rules.md §1~4 / `code-principles.md` §1.D (DIP) 모두 PASS. 정정 의무 0.
3. **F8 cascade** = F7 직접 영향 (main 5 화면 진입 차단). F7 mitigation 마감 시 자동 해결.
4. **mitigation 영역 = Coin prep 영역 분리** (Supabase project + local.properties 작성). CLI 측 정정 영역 0.

## Cleanup Assessment

N/A (audit / read-only task — 제품 코드 미변경).
