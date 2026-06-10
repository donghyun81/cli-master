# Pencil Theme Multi-Axis Paradigm SoT

> **단일 목적**: Pencil `themes` field 측 multi-axis paradigm (= `mode` / `spacing` / `device` 등 다축) + theme-specific variable assignment + Compose 측 multi-axis mapping paradigm 단일 SoT.
> **신설**: MASTER-CLI-PENCIL-OPTIMIZATION-002 (2026-05-19 H26 단계 1 마감).
> **공식 근거**: pencil.dev `/for-developers/the-pen-format` "Themes" + `/core-concepts/design-libraries` (2026-04-03 last updated).
> **연관 파일**:
> - `pencil-pen-format-schema.md` §1.1 Document + §5 Variable / Theme system — 본 paradigm 측 schema 본문
> - `design-to-code-sync.md` §9 Variables ↔ Code Sync paradigm — 본 SoT 측 multi-axis 강화 본문
> - `pencil-mcp-tools-reference.md` §1.3 `get_variables` + §1.4 `set_variables` — multi-axis variable 측 호출 paradigm
> - `pencil-component-paradigm.md` — Component 측 theme axis 적용 paradigm
> SOT: `CLAUDE.md`

---

## 1. Multi-axis 본질

Pencil Theme = 단일 axis (= `light` / `dark` 등 mode 단일) X · 다축 paradigm default. 직교 axis 측 조합 측 variable value 분리 default (= mode × spacing × device = 18 조합 가능 등).

### 1.1 Schema 본문

```typescript
export interface Document {
  themes?: { [key: string]: string[] };
  // ... 그 외 field
}
```

`themes` field 본질 = `{ <axis-name>: <value-list> }` map. axis 측정값 수 제한 없음 (= 단일 axis 가능 · 3 축 이상 가능). 각 axis 측 string[] 측정값 = 해당 axis 측 가능 measurement list default.

### 1.2 권장 baseline 3 axis

```json
{
  "themes": {
    "mode": ["light", "dark"],
    "spacing": ["compact", "default", "comfortable"],
    "device": ["mobile", "tablet", "desktop"]
  }
}
```

| axis | 본질 | 본 패키지 측 적용 |
|---|---|---|
| `mode` | light / dark / system 측 시각 모드 | `MaterialTheme.colorScheme.isLight` (= Compose `isSystemInDarkTheme()` 측정) |
| `spacing` | compact / default / comfortable 측 spacing density | Compose `LocalDensity` + 사용자 설정 |
| `device` | mobile / tablet / desktop 측 device class | Compose `WindowSizeClass` + `LocalConfiguration` |

---

## 2. Theme-specific variable assignment

variable 측 theme axis 별 value 분리 paradigm. 단일 variable name 측 다중 value 정의 (= 적용 axis 측정값 별 활성 value 선택 default).

### 2.1 단일 axis assignment (= legacy paradigm · `MASTER-CLI-PENCIL-OPTIMIZATION-001` 측 baseline)

```json
{
  "variables": {
    "color.background": [
      { "value": "#FFFFFF", "theme": { "mode": "light" } },
      { "value": "#1A1A1A", "theme": { "mode": "dark" } }
    ]
  }
}
```

mode 단일 axis 측 light / dark 측정값 별 background color 분리 default.

### 2.2 Multi-axis assignment (= 본 cycle 신 paradigm · 강화 영역)

```json
{
  "variables": {
    "spacing.md": [
      { "value": 8, "theme": { "spacing": "compact" } },
      { "value": 16, "theme": { "spacing": "default" } },
      { "value": 24, "theme": { "spacing": "comfortable" } }
    ],
    "typography.body.fontSize": [
      { "value": 14, "theme": { "device": "mobile", "spacing": "compact" } },
      { "value": 16, "theme": { "device": "mobile", "spacing": "default" } },
      { "value": 18, "theme": { "device": "tablet" } },
      { "value": 20, "theme": { "device": "desktop" } }
    ]
  }
}
```

`spacing.md` = spacing axis 단축 default (= 3 measurement). `typography.body.fontSize` = device + spacing 다축 cross-product default.

### 2.3 fallback rule

variable 측 theme 측정값 측 활성 axis 측정값 측 match X 발화 시 = 측정값 fallback 정의 (= 본 cycle scope 외 영역 default · 공식 doc 추가 측정 의무).

---

## 3. Component-scope theme override

Entity 측 `theme` field 측 component-scope theme assignment 가능:

```typescript
export interface Entity extends Position, CanHaveRotation {
  theme?: Theme;
  // ...
}

export interface Theme {
  [key: string]: string;
}
```

```json
{
  "type": "frame",
  "id": "dark-section",
  "theme": { "mode": "dark" },
  "children": [
    { "type": "text", "content": "Always dark mode", "fill": "$color.foreground" }
  ]
}
```

document-scope theme 측 override default · 본 frame children 측 `mode: "dark"` 측정값 단일 활성 default.

---

## 4. Compose 측 multi-axis mapping paradigm

본 패키지 측 Compose Theme.kt (= `app-foundation/core/designsystem/.../Theme.kt`) 측 multi-axis 정합 paradigm:

### 4.1 mode axis ↔ Compose `colorScheme`

foundation `GentlyTheme` 는 resolved 값을 **주입받는** no-default 시그니처 default (= foundation `core/designsystem/.../theme/GentlyTheme.kt` 실 시그니처 정합). mode axis (= `darkMode → colorScheme`) 해소 + typography 선택 = **per-child 래퍼(`<Child>Theme.kt`)** 측에서 수행 default (= foundation 측 내부 도출 X · 정체성 색·폰트 단일 source = 각 자식 default).

```kotlin
// foundation core/designsystem/.../theme/GentlyTheme.kt — no-default 주입 (= 기본값 X · 주입 컴파일 강제)
@Composable
fun GentlyTheme(
    colorScheme: ColorScheme,   // no-default · 주입 의무
    typography: Typography,      // no-default · 주입 의무
    content: @Composable () -> Unit,
) {
    MaterialTheme(
        colorScheme = colorScheme,
        typography = typography,
        content = content,
    )
}

// per-child 래퍼 (= <Child>Theme.kt) 측 mode axis 해소 + typography 주입
@Composable
fun GentlyBreathTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit,
) {
    GentlyTheme(
        colorScheme = if (darkTheme) GentlyBreathDarkColorScheme else GentlyBreathLightColorScheme,
        typography = GentlyBreathTypography,   // per-child 주입 (= 현 Typography())
        content = content,
    )
}
```

Pencil `mode: "light"` / `mode: "dark"` ↔ Compose `<Child>LightColorScheme` / `<Child>DarkColorScheme` = 1:1 mapping default. 본 mode axis 해소 = caller(per-child 래퍼) 측 default (= foundation `GentlyTheme` 는 resolved colorScheme 주입받음).

### 4.2 spacing axis ↔ Compose `LocalDensity` + 사용자 설정

```kotlin
enum class SpacingDensity { Compact, Default, Comfortable }

val LocalSpacingDensity = compositionLocalOf { SpacingDensity.Default }

data class GentlySpacing(
    val xs: Dp,
    val sm: Dp,
    val md: Dp,
    val lg: Dp,
    val xl: Dp
)

val CompactSpacing = GentlySpacing(
    xs = 2.dp, sm = 4.dp, md = 8.dp, lg = 12.dp, xl = 16.dp
)

val DefaultSpacing = GentlySpacing(
    xs = 4.dp, sm = 8.dp, md = 16.dp, lg = 24.dp, xl = 32.dp
)

val ComfortableSpacing = GentlySpacing(
    xs = 8.dp, sm = 12.dp, md = 24.dp, lg = 32.dp, xl = 48.dp
)

val LocalGentlySpacing = compositionLocalOf { DefaultSpacing }

@Composable
fun GentlySpacingProvider(
    density: SpacingDensity,
    content: @Composable () -> Unit
) {
    val spacing = when (density) {
        SpacingDensity.Compact -> CompactSpacing
        SpacingDensity.Default -> DefaultSpacing
        SpacingDensity.Comfortable -> ComfortableSpacing
    }
    CompositionLocalProvider(LocalGentlySpacing provides spacing, content = content)
}
```

Pencil `spacing.md` 측 axis-specific value ↔ Compose `LocalGentlySpacing.current.md` = 1:1 mapping default. 사용자 설정 측 SpacingDensity 변경 시점 → recomposition default.

### 4.3 device axis ↔ Compose `WindowSizeClass`

```kotlin
@Composable
fun GentlyDeviceTheme(
    windowSize: WindowSizeClass,
    content: @Composable () -> Unit
) {
    val deviceClass = when {
        windowSize.widthSizeClass == WindowWidthSizeClass.Compact -> DeviceClass.Mobile
        windowSize.widthSizeClass == WindowWidthSizeClass.Medium -> DeviceClass.Tablet
        else -> DeviceClass.Desktop
    }

    val typography = when (deviceClass) {
        DeviceClass.Mobile -> MobileTypography
        DeviceClass.Tablet -> TabletTypography
        DeviceClass.Desktop -> DesktopTypography
    }

    CompositionLocalProvider(LocalDeviceClass provides deviceClass) {
        MaterialTheme(typography = typography, content = content)
    }
}
```

Pencil `device: "mobile"` / `"tablet"` / `"desktop"` ↔ Compose `WindowWidthSizeClass.Compact` / `Medium` / `Expanded` = 1:1 mapping default.

### 4.4 Cross-axis combination (= 본 cycle 강화 본질)

`typography.body.fontSize` 측 `device + spacing` cross-product variable 측 Compose 측 mapping:

```kotlin
@Composable
fun bodyFontSize(): TextUnit {
    val device = LocalDeviceClass.current
    val spacingDensity = LocalSpacingDensity.current

    return when {
        device == DeviceClass.Mobile && spacingDensity == SpacingDensity.Compact -> 14.sp
        device == DeviceClass.Mobile && spacingDensity == SpacingDensity.Default -> 16.sp
        device == DeviceClass.Tablet -> 18.sp
        device == DeviceClass.Desktop -> 20.sp
        else -> 16.sp  // fallback
    }
}
```

Pencil 측 cross-axis variable assignment ↔ Compose 측 multi-source CompositionLocal cross-lookup = paradigm 정합 default.

---

## 5. Variables ↔ Compose Theme sync 양방향 paradigm (= `design-to-code-sync.md` §9 강화)

### 5.1 design tool → code (token export 방향)

```
"Update app-foundation/core/designsystem/.../Theme.kt with these Pencil multi-axis variables:
- color.* (mode axis: light + dark)
- spacing.* (spacing axis: compact + default + comfortable)
- typography.* (device axis: mobile + tablet + desktop)"
```

agent prompt 정합 → Compose 측 multi-axis Theme.kt 자동 갱신 default.

### 5.2 code → design tool (token import 방향)

```
"Create Pencil multi-axis variables from app-foundation/core/designsystem/.../Theme.kt:
- LightColorScheme + DarkColorScheme → mode axis
- CompactSpacing + DefaultSpacing + ComfortableSpacing → spacing axis
- MobileTypography + TabletTypography + DesktopTypography → device axis"
```

`mcp__pencil__set_variables` 호출 측 multi-axis assignment 자동 생성 default.

### 5.3 sync 방향 결정 (drift 발생 시)

| drift 시점 | 정답 (SoT) | sync 방향 |
|---|---|---|
| Pencil 측 신규 axis 추가 (예: `temperature: warm/cool`) | Pencil | design tool → Theme.kt (= 신규 axis 측 CompositionLocal + Provider 신설) |
| Compose 측 신규 SpacingDensity measurement 추가 (= `Spacious` 등) | Theme.kt | Theme.kt → Pencil (= `spacing` axis 측 measurement append) |
| 두 측 동시 충돌 (= 다른 axis 도입) | UNKNOWN | STOP → Coin 명시 결정 의뢰 |

---

## 6. AI agent 측 호출 paradigm

### 6.1 신규 axis 추가 prompt

```
"Add a new 'temperature' axis to the Pencil document themes with values: warm, neutral, cool.
Assign these color variables based on temperature axis:
- color.accent: warm = #FF6B35, neutral = #6B7280, cool = #06B6D4
- color.surface.tint: warm = #FFF7ED, neutral = #F9FAFB, cool = #ECFEFF"
```

### 6.2 cross-axis variable 호출 prompt

```
"Define typography.heading.fontSize across device + spacing cross-product:
- mobile + compact: 20sp
- mobile + default: 24sp
- tablet + default: 28sp
- desktop + default: 32sp
- desktop + comfortable: 36sp"
```

### 6.3 batch propagation prompt

```
"Sync all multi-axis variables from Pencil to Theme.kt.
Generate one CompositionLocal per axis + a Provider Composable for each axis.
Validate that all cross-axis variable combinations resolve in Compose."
```

---

## 7. STOP 조건

| trigger | mitigation |
|---|---|
| `themes` field 측 axis 명 측 reserved word 충돌 (= `mode` / `spacing` / `device` 측 다른 의미 적용 시도) | 표준 axis 명 권장 default · 변경 시 `pencil-component-paradigm.md` §3 Slot suggested + 본 SoT §1.2 정합 cycle 진입 |
| Cross-axis combination 측 fallback measurement 부재 발견 | document `variables` 측 default value 측정 의무 default · 미측정 시 raw string default (= variable substitution X) |
| Compose Theme.kt 측 axis CompositionLocal 측 Provider 누락 | runtime FAIL 발화 · `Theme.kt` 측 root Provider 측 axis 측 CompositionLocalProvider 묶음 의무 |
| Pencil multi-axis variable assignment 측 axis 측 invalid measurement (= `themes` 측 array 측 부재 token) | `set_variables` 측 FAIL · agent prompt 측 axis enumeration 재 확인 의뢰 |

---

## 8. 본 SoT 의 변경 정책

- cli infra 권장 byte-identical (6-repo · master + 5 자식)
- 변경 시 master cycle 신설 + 6-repo propagation (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## 9. 명시 cycle 이력

- 2026-05-19 · MASTER-CLI-PENCIL-OPTIMIZATION-002 · 본 SoT 신설 (= H26 단계 1 마감 · pencil.dev 공식 doc anchor §C #4 Multi-axis Theme 흡수 + `design-to-code-sync.md` §9 측 multi-axis 강화 paradigm 통합) + 5-repo byte-identical propagation
