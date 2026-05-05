# EVIDENCE — MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001

- 일자: 2026-05-05
- 본 cycle 정의: 부모 audit Phase 1 EVIDENCE §4.2 + §4.4 발견 borderline 3 (GB/GT splash dwell + GD onboarding wording) 의 §3 contextual review.
- scope: 다중 repo (GB + GT + GD) · CLI 영역 (Compose 코드 + strings.xml)
- baseline: 보호 5 + cli infra 5 (총 10) × 4 repos byte-identical (drift 0)

## 1. STEP 0 baseline 실측

### 1.1 보호 + cli infra 4-repo 정합 검증 (총 10 파일 × 4 repo)

| 영역 | 파일 | sha256 (4-repo 동일) |
|---|---|---|
| 보호 | docs/schemas/ui-spec.schema.json | f1edd397...82ce2aa445 |
| 보호 | .claude/rules/uiux-sot-refresh.md | ee377dc2...b6b8b260d3 |
| 보호 | docs/design/design-sot-policy.md | e5e3fe16...da49af03 |
| 보호 | .claude/rules/pencil-uiux-workflow.md | 7621013e...d6f0c0f |
| 보호 | docs/design/pencil-sot-policy.md | 96de2f5d...d05cba6559 |
| cli infra | .claude/rules/ux-laws.md | 80aa2915...912cb1373 |
| cli infra | .claude/rules/code-principles.md | 51b414f1...327d455b |
| cli infra | .claude/rules/report-formats.md | 184dc55b...152d26136 |
| cli infra | .claude/rules/ui-ux-analysis.md | e5b1af74...eda9bf3e0 |
| cli infra | .claude/rules/design-to-code-sync.md | 603bc994...657e5153d7 |

→ DRIFT 0건. 4 repos (claude-cli-master / GentlyBreath / GentlyDay / GentlyTable) byte-identical.

(주: prompt §1 "cli infra 6" 표기 = 5 의 misprint. 실 list 10 모두 정합)

### 1.2 borderline 3 영역 위치 사실

| ID | 파일:line | 코드 | 의미 |
|---|---|---|---|
| B1 | GentlyBreath/.../splash/SplashScreen.kt:42 + :51 | `private const val SplashDwellMs = 1200L` + `delay(SplashDwellMs)` | session 외부 인자 — 내부 prefetch X |
| B2 | GentlyTable/.../splash/SplashScreen.kt:32 + :66 | `private const val SplashDwellMillis = 1500L` + `delay(SplashDwellMillis)` | `dwellElapsed && destination resolved` AND gate |
| B3 | GentlyDay/.../onboarding/OnboardingScreen.kt:203 + strings.xml:43 | `Text(stringResource(R.string.onboarding_ready), ...)` + `<string name="onboarding_ready">준비 완료!</string>` | FinalStep 헤더 항상 표시 + errorRes 시 같은 화면 아래 error 동시 노출 |

## 2. 코드 read 결과 (full context)

### 2.1 B1 — GB SplashScreen.kt

```kotlin
private const val SplashAnimMs = 800
private const val SplashDwellMs = 1200L

@Composable
fun SplashScreen(
    session: AuthSession?,
    onNavigateOnboarding: () -> Unit,
    onNavigateMain: () -> Unit,
) {
    LaunchedEffect(Unit) {
        delay(SplashDwellMs)
        if (session != null) onNavigateMain() else onNavigateOnboarding()
    }
    SplashContent()
}
```

**사실**:
- `session` 은 SplashScreen composable 의 외부 인자. 호출자 (NavHost / App level) 가 이미 resolve 후 전달.
- splash 내부 = `delay(1200ms)` + UI 그림 만. prefetch / auth bootstrap 동시 진행 부재.
- §3.2 권장 패턴 (`prefetchComplete && minDwellElapsed`) 의 두 번째 condition (prefetch) 대상 행위 자체 없음.

### 2.2 B2 — GT SplashScreen.kt

```kotlin
private const val SplashFadeDurationMillis = 1200
private const val SplashDwellMillis = 1500L

@Composable
fun SplashRoute(
    onNavigateOnboarding: () -> Unit,
    onNavigateMain: () -> Unit,
    viewModel: SplashViewModel = koinViewModel(),
) {
    val destination by viewModel.destination.collectAsStateWithLifecycle()
    var dwellElapsed by remember { mutableStateOf(false) }

    SplashScreen(onComplete = { dwellElapsed = true })

    LaunchedEffect(dwellElapsed, destination) {
        if (!dwellElapsed) return@LaunchedEffect
        when (destination) {
            SplashDestination.Onboarding -> onNavigateOnboarding()
            SplashDestination.Main -> onNavigateMain()
            SplashDestination.Loading -> Unit
        }
    }
}

@Composable
fun SplashScreen(onComplete: () -> Unit) {
    ...
    LaunchedEffect(Unit) {
        visible = true
        delay(SplashDwellMillis)
        onComplete()
    }
    ...
}
```

**사실**:
- `SplashRoute` 는 ViewModel.destination resolution 과 dwell 을 병렬로 시작.
- navigate gate = `dwellElapsed && destination is Onboarding|Main` (Loading = 대기).
- §3.2 권장 패턴 (`Splash dismiss = prefetchComplete && minDwellElapsed`) 의 origin 형태 부합.
- 인위 wait 발생 영역 = destination 이 1500ms 보다 빨리 resolve 될 때만 (정상 케이스).

### 2.3 B3 — GD OnboardingScreen.kt FinalStep + strings.xml

```kotlin
@Composable
private fun FinalStep(
    loading: Boolean,
    @androidx.annotation.StringRes errorRes: Int?,
    onFinish: () -> Unit
) {
    Text(stringResource(R.string.onboarding_ready), style = MaterialTheme.typography.headlineSmall)
    errorRes?.let { errorResId ->
        Text(stringResource(errorResId), color = MaterialTheme.colorScheme.error)
    }
    Button(
        onClick = onFinish,
        enabled = !loading,
        modifier = Modifier.fillMaxWidth()
    ) {
        if (loading) CircularProgressIndicator()
        else Text(stringResource(R.string.onboarding_go_home))
    }
}
```

```xml
<string name="onboarding_ready">준비 완료!</string>
<string name="error_onboarding_failed">온보딩 완료 실패</string>
<!-- 외 error_login_required, error_samsung_failed 도 errorRes source 로 사용 -->
```

**사실**:
- `FinalStep` 헤더 = `onboarding_ready` "준비 완료!" 항상 표시 (조건 X).
- errorRes (3종 source: error_login_required / error_samsung_failed / error_onboarding_failed) 가 not-null 일 때 같은 화면 안 헤더 아래에 error 추가 표시.
- 결과: 실패 path 에서도 화면 상단 "준비 완료!" 헤더 + 하단 error 동시 노출.
- ViewModel 의 errorRes 분기 (OnboardingViewModel.kt:61, 70, 83, 97) 4 곳에서 errorRes 세팅.

## 3. §3 위반 등급 평가

| ID | §3 조항 | 위반 등급 | 근거 |
|---|---|---|---|
| B1 | §3.2 Doherty 의도적 지연 | **명백 위반** | 순수 dwell 1200ms (동시 작업 없음) = §3.2 가 정의하는 "의도적 지연" 그 자체. 정합 사유 fitting 어려움. |
| B2 | §3.2 Doherty 의도적 지연 | **부분 위반** | AND-gate 패턴 = §3.2 권장형 부합. destination 이 dwell 보다 빠를 때만 인위 wait. 사유 명시로 보완 가능. |
| B3 | §3.4 Peak-End 부정 위장 | **명백 위반** | 실패 path 에서 "준비 완료!" 헤더 그대로 노출 = 실패의 가짜 성공 framing. wording 정정 필수. |

## 4. Coin 결정 (3 Q)

| Q | 옵션 | 결정 | 사유 |
|---|---|---|---|
| Q1 GB | (a) 사유 주석 / (b) AND-gate 정정 / (c) dwell 단축 | **(a)** | (b) = `session` 이미 외부 resolve = 두 번째 condition trivially true → 실 이득 없음. (c) = §3.2 위반 그대로. (a) = §3.2 위반 인정 + 사유 주석 + 별 trail 기록. ROI 高. |
| Q2 GT | (a) 사유 주석 / (b) reframing | **(a)** | 코드 패턴 = §3.2 권장형 이미 부합. 사유 주석만으로 충분. |
| Q3 GD | (a) wording swap / (b) 헤더 숨김 / (c) 중립 표현 | **(a)** | (b) = layout shift. (c) = 정상 path 마감감 손실. (a) = 신규 string `onboarding_retry` "다시 시도해 주세요" 추가 + FinalStep 안 errorRes 따라 헤더 swap. layout 안정 + Peak-End 정정. |

## 5. 정정 영역 list

### 5.1 GB (사유 주석만)

- 파일: `GentlyBreath/app/src/main/java/com/example/gentlybreath/presentation/splash/SplashScreen.kt`
- 위치: line 42 (SplashDwellMs 정의) 위 또는 line 51 (delay 호출) 위
- 추가 주석 (KDoc 또는 line 주석):
  ```
  // 정합 사유 (§3.2 Doherty): logo 인지 가능 시간 (Material 권장 800~1500ms 하한 마진).
  // session 은 외부 인자로 이미 resolve 됨 — splash 내부 동시 작업 없음.
  // §3.2 위반 등급 = 명백. cycle MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001 별 trail.
  ```

### 5.2 GT (사유 주석만)

- 파일: `GentlyTable/app/src/main/java/com/example/gentlytable/presentation/splash/SplashScreen.kt`
- 위치: line 32 (SplashDwellMillis 정의) 위
- 추가 주석:
  ```
  // 정합 사유 (§3.2 Doherty): logo 인지 시간 + ViewModel destination resolution 안전 마진.
  // SplashRoute 의 navigate gate = `dwellElapsed && destination resolved` AND-gate
  // → §3.2 권장 패턴 (Splash dismiss = prefetchComplete && minDwellElapsed) 부합.
  // 부분 위반 영역 = destination 이 dwell 보다 빠를 때만 dwell 까지 wait.
  ```

### 5.3 GD (string 추가 + FinalStep 정정)

#### 5.3.1 strings.xml 추가 (line 43 다음 또는 onboarding 영역)

```xml
<string name="onboarding_retry">다시 시도해 주세요</string>
```

#### 5.3.2 FinalStep 정정 (OnboardingScreen.kt:198~206)

```kotlin
@Composable
private fun FinalStep(
    loading: Boolean,
    @androidx.annotation.StringRes errorRes: Int?,
    onFinish: () -> Unit
) {
    val headerRes = if (errorRes != null) R.string.onboarding_retry else R.string.onboarding_ready
    Text(stringResource(headerRes), style = MaterialTheme.typography.headlineSmall)
    errorRes?.let { errorResId ->
        Text(stringResource(errorResId), color = MaterialTheme.colorScheme.error)
    }
    Button(
        onClick = onFinish,
        enabled = !loading,
        modifier = Modifier.fillMaxWidth()
    ) {
        if (loading) CircularProgressIndicator()
        else Text(stringResource(R.string.onboarding_go_home))
    }
}
```

## 6. 검증 영역

| 검증 항목 | 방법 | 기대 결과 |
|---|---|---|
| 보호 + cli infra drift | `shasum -a 256` × 4 repo | DRIFT 0 유지 (본 cycle 정정 = 도메인 코드 / strings 만) |
| GB 사유 주석 추가 | `grep -nE '정합 사유.*§3.2' SplashScreen.kt` | 1 hit |
| GT 사유 주석 추가 | `grep -nE '정합 사유.*§3.2' SplashScreen.kt` | 1 hit |
| GD onboarding_retry string | `grep -n 'onboarding_retry' strings.xml` | 1 hit |
| GD FinalStep wording swap | `grep -nE 'headerRes = if.*errorRes' OnboardingScreen.kt` | 1 hit |
| compile 검증 | gradle build (CLI) | PASS |

## 7. 별 trail 기록

| 항목 | trail 위치 | 내용 |
|---|---|---|
| GB §3.2 명백 위반 | .auto-memory/incident-log.md | "GB Splash dwell 1200ms = §3.2 위반 인정 (사유 주석만). 향후 prefetch 동시 진행 패턴 도입 시 정합 가능" |
| GT §3.2 부분 위반 | (해당 cycle REVIEW 마감) | AND-gate 패턴 부합 — trail X (lazy) |
| GD §3.4 정정 | (해당 cycle REVIEW 마감) | wording swap = full mitigation, trail X |

## 8. self-verification

- [ ] 금지 어휘 grep ("박" 계열) — 본 EVIDENCE 안 0 회 ✓
- [ ] 모름 영역 명시 — Q1 (b) AND-gate 의 호출자 변경 비용 = "中 정도" 추정 (실 호출자 read 안 함, 추정 단정)
- [ ] 부분 성공 명시 — B1 = 사유 주석만 (정합 X, 인정 + trail), B2 = 사유 주석 (정합 부분), B3 = full 정정
