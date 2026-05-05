# PLAN — MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001

- 일자: 2026-05-05
- 본 PLAN scope: CLI 측 정정 영역 절차 명시 (Cowork 영역 = EVIDENCE / REVIEW / 부모 EVIDENCE 갱신).

## 0. STEP 0 — baseline 사전 검증 (CLI 진입 첫 turn)

CLI 측 진입 시 먼저 실행:

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
for f in docs/schemas/ui-spec.schema.json .claude/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/ux-laws.md .claude/rules/code-principles.md .claude/rules/report-formats.md .claude/rules/ui-ux-analysis.md .claude/rules/design-to-code-sync.md; do
  for r in . ../GentlyBreath ../GentlyDay ../GentlyTable; do
    [ -f "$r/$f" ] && shasum -a 256 "$r/$f" | awk -v r="$r" -v f="$f" '{print r":"f":"$1}'
  done
done | sort | awk -F: '{key=$2":"$3; if (key != prev) {if (count > 0 && count != 4) print "DRIFT:", prev; count=1} else {count++}; prev=key} END {if (count != 4) print "DRIFT:", prev}'
```

DRIFT 발견 시 STOP + Coin 보고.

## 1. STEP 1 — GB SplashScreen 사유 주석 추가

### 1.1 파일

`GentlyBreath/app/src/main/java/com/example/gentlybreath/presentation/splash/SplashScreen.kt`

### 1.2 정정 (line 41~42 영역)

기존:

```kotlin
private const val SplashAnimMs = 800
private const val SplashDwellMs = 1200L
```

정정 후:

```kotlin
private const val SplashAnimMs = 800

// 정합 사유 (§3.2 Doherty): logo 인지 가능 시간 (Material 권장 800~1500ms 하한 마진).
// session 은 외부 인자로 이미 resolve 됨 — splash 내부 동시 작업 없음.
// §3.2 위반 등급 = 명백. cycle MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001 별 trail.
private const val SplashDwellMs = 1200L
```

### 1.3 commit

```
git -C ~/AndroidStudioProjects/GentlyBreath add app/src/main/java/com/example/gentlybreath/presentation/splash/SplashScreen.kt
git -C ~/AndroidStudioProjects/GentlyBreath commit -m "docs(splash): §3.2 dwell 정합 사유 주석 추가

cycle: MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001
영향: 코드 동작 변경 없음 (주석 추가)
사유: dwell 1200ms 의 §3.2 위반 등급 = 명백, 인정 + 별 trail 기록
"
```

## 2. STEP 2 — GT SplashScreen 사유 주석 추가

### 2.1 파일

`GentlyTable/app/src/main/java/com/example/gentlytable/presentation/splash/SplashScreen.kt`

### 2.2 정정 (line 31~32 영역)

기존:

```kotlin
private const val SplashFadeDurationMillis = 1200
private const val SplashDwellMillis = 1500L
```

정정 후:

```kotlin
private const val SplashFadeDurationMillis = 1200

// 정합 사유 (§3.2 Doherty): logo 인지 시간 + ViewModel destination resolution 안전 마진.
// SplashRoute 의 navigate gate = `dwellElapsed && destination resolved` AND-gate
// → §3.2 권장 패턴 (Splash dismiss = prefetchComplete && minDwellElapsed) 부합.
// 부분 위반 영역 = destination 이 dwell 보다 빠를 때만 dwell 까지 wait.
private const val SplashDwellMillis = 1500L
```

### 2.3 commit

```
git -C ~/AndroidStudioProjects/GentlyTable add app/src/main/java/com/example/gentlytable/presentation/splash/SplashScreen.kt
git -C ~/AndroidStudioProjects/GentlyTable commit -m "docs(splash): §3.2 AND-gate 정합 사유 주석 추가

cycle: MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001
영향: 코드 동작 변경 없음 (주석 추가)
사유: dwell+destination AND-gate 패턴 = §3.2 권장형 부합 명시
"
```

## 3. STEP 3 — GD onboarding_retry string 추가 + FinalStep wording swap

### 3.1 파일 1: strings.xml

`GentlyDay/app/src/main/res/values/strings.xml`

### 3.2 정정 (line 43 다음 또는 onboarding 영역)

기존 (line 43):

```xml
<string name="onboarding_ready">준비 완료!</string>
```

추가 (line 43 다음 또는 적절한 영역):

```xml
<string name="onboarding_ready">준비 완료!</string>
<string name="onboarding_retry">다시 시도해 주세요</string>
```

### 3.3 파일 2: OnboardingScreen.kt

`GentlyDay/app/src/main/java/com/example/gentlyday/presentation/onboarding/OnboardingScreen.kt`

### 3.4 정정 (line 198~206 FinalStep)

기존:

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
        ...
    )
}
```

정정 후:

```kotlin
@Composable
private fun FinalStep(
    loading: Boolean,
    @androidx.annotation.StringRes errorRes: Int?,
    onFinish: () -> Unit
) {
    // 정합 사유 (§3.4 Peak-End): errorRes != null 시 "준비 완료!" 헤더 노출 = 실패의 가짜 성공 framing.
    // wording swap 으로 정정 — 정상 path 마감감 유지 + 실패 path 정직 framing.
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

### 3.5 commit

```
git -C ~/AndroidStudioProjects/GentlyDay add app/src/main/res/values/strings.xml app/src/main/java/com/example/gentlyday/presentation/onboarding/OnboardingScreen.kt
git -C ~/AndroidStudioProjects/GentlyDay commit -m "fix(onboarding): §3.4 Peak-End 정정 — FinalStep wording swap

cycle: MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001
영향: errorRes != null 시 헤더 wording 'onboarding_ready'(준비 완료!) → 'onboarding_retry'(다시 시도해 주세요) swap
신규 string: onboarding_retry
사유: 실패 path 에서 '준비 완료!' 헤더 노출 = 가짜 성공 framing (§3.4 위반) — 정정
"
```

## 4. STEP 4 — 사후 검증

```bash
# (1) 사유 주석 추가 검증
grep -nE '정합 사유.*§3.2' ~/AndroidStudioProjects/GentlyBreath/app/src/main/java/com/example/gentlybreath/presentation/splash/SplashScreen.kt
grep -nE '정합 사유.*§3.2' ~/AndroidStudioProjects/GentlyTable/app/src/main/java/com/example/gentlytable/presentation/splash/SplashScreen.kt

# (2) GD string + wording swap 검증
grep -n 'onboarding_retry' ~/AndroidStudioProjects/GentlyDay/app/src/main/res/values/strings.xml
grep -nE 'headerRes = if.*errorRes' ~/AndroidStudioProjects/GentlyDay/app/src/main/java/com/example/gentlyday/presentation/onboarding/OnboardingScreen.kt

# (3) 보호 + cli infra drift 재검증 (정정 영역 = 도메인 코드만 = drift 없어야 함)
# (STEP 0 의 동일 명령 재실행)

# (4) compile 검증 (각 repo)
cd ~/AndroidStudioProjects/GentlyBreath && ./gradlew compileDebugKotlin
cd ~/AndroidStudioProjects/GentlyTable && ./gradlew compileDebugKotlin
cd ~/AndroidStudioProjects/GentlyDay && ./gradlew compileDebugKotlin
```

## 5. STEP 5 — REVIEW.md 작성 + Coin 보고

CLI 측에서 다음 정보 수집 후 Cowork 측 REVIEW.md 갱신용으로 보고:

- GB commit sha
- GT commit sha
- GD commit sha
- 사후 검증 결과 (STEP 4 의 4 항목)
- compile PASS / FAIL

## 6. STOP 조건

| 조건 | 행위 |
|---|---|
| STEP 0 baseline DRIFT 발견 | STOP + Coin 보고 |
| compile FAIL | STOP + 정정 + Coin 보고 |
| SplashDwellMs/Millis 상수 변경 시도 | STOP + Coin 결정 의뢰 (관용 UX 시간 영역) |
| FinalStep 의 다른 영역 (Button / loading) 정정 시도 | STOP + Coin 결정 (본 cycle scope 외) |
