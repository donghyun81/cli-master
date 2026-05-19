# Pencil Visual Primitives SoT

> **단일 목적**: Pencil 측 시각 primitive 통합 SoT — Fill (4 종) + Stroke + Effect (3 종) + BlendMode (17) + Flexbox Layout + icon_font paradigm + Compose 측 mapping paradigm 본문.
> **신설**: MASTER-CLI-PENCIL-OPTIMIZATION-002 (2026-05-19 H26 단계 1 마감).
> **공식 근거**: pencil.dev `/for-developers/the-pen-format` "Fill / Stroke / Effect / Layout / IconFont" (2026-04-03 last updated).
> **연관 파일**:
> - `pencil-pen-format-schema.md` §4 Graphics primitive — 본 paradigm 측 schema 본문
> - `pencil-component-paradigm.md` — Component / Instance 측 visual primitive 적용
> - `pencil-theme-multi-axis.md` — theme axis 별 fill / typography variable assignment
> - `design-to-code-sync.md` §9 — Compose 측 Material3 effect / layout mapping paradigm
> SOT: `CLAUDE.md`

---

## 1. Fill paradigm (= 4 종)

`Fills` type = 단일 Fill 또는 array (= 다중 fill 측 layered rendering default · 첫 entry = 가장 위 layer default).

### 1.1 Color fill (= 단순 color · 가장 일반 case)

```typescript
export type Fill = ColorOrVariable | {
  type: "color";
  enabled?: BooleanOrVariable;
  blendMode?: BlendMode;
  color: ColorOrVariable;
};
```

직접 `Color` string 측정 가능 (= 단축 syntax default · `"fill": "#FF0000"`) 또는 object form (= `"fill": { "type": "color", "color": "$color.primary", "blendMode": "multiply" }`).

### 1.2 Gradient fill (= linear / radial / angular)

```typescript
{
  type: "gradient";
  enabled?: BooleanOrVariable;
  blendMode?: BlendMode;
  gradientType?: "linear" | "radial" | "angular";
  opacity?: NumberOrVariable;
  center?: Position;
  size?: { width?: NumberOrVariable; height?: NumberOrVariable };
  rotation?: NumberOrVariable;
  colors?: { color: ColorOrVariable; position: NumberOrVariable }[];
};
```

| `gradientType` | 본질 |
|---|---|
| `linear` | 선형 gradient (= 시작점 → 끝점) |
| `radial` | 방사형 gradient (= 중심점 → 외곽) |
| `angular` | 각도 gradient (= 중심점 측 회전) |

### 1.3 Image fill

```typescript
{
  type: "image";
  enabled?: BooleanOrVariable;
  blendMode?: BlendMode;
  opacity?: NumberOrVariable;
  url: string;
  mode?: "stretch" | "fill" | "fit";
};
```

| `mode` | 본질 |
|---|---|
| `stretch` | 측정 영역 측 비율 무시 측 stretch |
| `fill` | 비율 보존 + 측정 영역 측 가득 채움 (= 일부 crop 가능) |
| `fit` | 비율 보존 + 측정 영역 측 안 fit (= 빈 영역 발생 가능) |

### 1.4 Mesh gradient (= 다지점 색 보간)

```typescript
{
  type: "mesh_gradient";
  enabled?: BooleanOrVariable;
  blendMode?: BlendMode;
  opacity?: NumberOrVariable;
  columns?: number;
  rows?: number;
  colors?: ColorOrVariable[];
  points?: (
    | [number, number]
    | {
        position: [number, number];
        leftHandle?: [number, number];
        rightHandle?: [number, number];
        topHandle?: [number, number];
        bottomHandle?: [number, number];
      }
  )[];
};
```

본질 = `columns × rows` grid 측 vertex 측 color assignment + bezier handle 측 보간 곡선 측 정의. iridescent / aurora 측정 case 측 권장 default.

### 1.5 Compose 측 mapping paradigm

| Pencil Fill | Compose mapping |
|---|---|
| `type: "color"` | `Modifier.background(Color(...))` |
| `type: "gradient"` + `linear` | `Brush.linearGradient(colors, start, end)` |
| `type: "gradient"` + `radial` | `Brush.radialGradient(colors, center, radius)` |
| `type: "gradient"` + `angular` | `Brush.sweepGradient(colors, center)` |
| `type: "image"` | `Image(painterResource(...), contentScale = ContentScale.Fit/Crop/FillBounds)` |
| `type: "mesh_gradient"` | Compose 1.7+ 측 `Brush.meshGradient(...)` (= experimental · 본 패키지 미 측정 default · 후속 cycle 본문 갱신 후보) |

---

## 2. Stroke paradigm

```typescript
export interface Stroke {
  align?: "inside" | "center" | "outside";
  thickness?: NumberOrVariable | {
    top?: NumberOrVariable;
    right?: NumberOrVariable;
    bottom?: NumberOrVariable;
    left?: NumberOrVariable;
  };
  join?: "miter" | "bevel" | "round";
  miterAngle?: NumberOrVariable;
  cap?: "none" | "round" | "square";
  dashPattern?: number[];
  fill?: Fills;
}
```

| field | 본질 |
|---|---|
| `align` | stroke 측 경계 측 정렬 (= inside = 안 / center = 중앙 / outside = 밖) |
| `thickness` | 단일 numeric 또는 4-side object (= top/right/bottom/left 분리 가능) |
| `join` | corner 측 join style (= miter = 뾰족 / bevel = 깎임 / round = 둥글) |
| `cap` | endpoint 측 cap style (= round / square / none) |
| `dashPattern` | dash array (= `[5, 3]` 측 5px on + 3px off 반복) |
| `fill` | stroke 측 fill (= color 또는 gradient 등 · 본 §1 정합) |

### 2.1 Compose 측 mapping

```kotlin
Modifier
    .border(
        width = 1.dp,
        color = MaterialTheme.colorScheme.outline,
        shape = MaterialTheme.shapes.medium
    )
```

복잡 stroke (= 4-side 분리 + dashed + cap) 측 `Canvas` 측 `drawRect(style = Stroke(...))` 직접 호출 default.

---

## 3. Effect paradigm (= 3 종)

```typescript
export type Effect =
  | { enabled?: BooleanOrVariable; type: "blur"; radius?: NumberOrVariable }
  | { enabled?: BooleanOrVariable; type: "background_blur"; radius?: NumberOrVariable }
  | {
      type: "shadow";
      enabled?: BooleanOrVariable;
      shadowType?: "inner" | "outer";
      offset?: { x: NumberOrVariable; y: NumberOrVariable };
      spread?: NumberOrVariable;
      blur?: NumberOrVariable;
      color?: ColorOrVariable;
      blendMode?: BlendMode;
    };

export type Effects = Effect | Effect[];
```

### 3.1 Blur (= 측정 영역 측 blur)

```json
{ "type": "blur", "radius": 8 }
```

본 entity 측 자체 blur. Compose 측 → `Modifier.blur(8.dp)`.

### 3.2 Background_blur (= 측정 영역 측 뒤 background blur)

```json
{ "type": "background_blur", "radius": 12 }
```

본 entity 측 뒤 layer 측 blur (= frosted glass effect default). Compose 측 → `RenderEffect.createBlurEffect(...)` + `Modifier.graphicsLayer { renderEffect = ... }` (= Android 12+ default · `composeApp` 측 platform 분기 의무).

### 3.3 Shadow (= inner / outer 2 종)

```json
{
  "type": "shadow",
  "shadowType": "outer",
  "offset": { "x": 0, "y": 4 },
  "spread": 0,
  "blur": 8,
  "color": "#00000040"
}
```

| `shadowType` | Compose mapping |
|---|---|
| `outer` | `Modifier.shadow(elevation = N.dp, shape = ...)` 또는 `Material3 Surface(tonalElevation = N.dp)` |
| `inner` | Compose 측 default API 부재 default · `Canvas` 측 `drawIntoCanvas` 측 `BlurMaskFilter` 직접 호출 (= platform 분기 · Android 한정) |

### 3.4 Material3 mapping paradigm

```kotlin
Surface(
    modifier = Modifier.shadow(
        elevation = 4.dp,
        shape = MaterialTheme.shapes.medium,
        ambientColor = Color.Black.copy(alpha = 0.25f),
        spotColor = Color.Black.copy(alpha = 0.25f)
    ),
    tonalElevation = 2.dp,
    shape = MaterialTheme.shapes.medium,
    color = MaterialTheme.colorScheme.surface
) { ... }
```

`tonalElevation` = Material3 측 surface tint paradigm (= elevation 측 color shift default). Pencil 측 `shadow` + `background_blur` 조합 측정 시 → Compose 측 `Surface(tonalElevation + shadow)` 정합.

---

## 4. BlendMode paradigm (= 17 종)

```typescript
export type BlendMode = "normal" | "darken" | "multiply" | "linearBurn" |
  "colorBurn" | "light" | "screen" | "linearDodge" | "colorDodge" |
  "overlay" | "softLight" | "hardLight" | "difference" | "exclusion" |
  "hue" | "saturation" | "color" | "luminosity";
```

| 카테고리 | mode list |
|---|---|
| 기본 | `normal` |
| 어둡게 (darken family) | `darken` / `multiply` / `linearBurn` / `colorBurn` |
| 밝게 (lighten family) | `light` / `screen` / `linearDodge` / `colorDodge` |
| 대비 (contrast family) | `overlay` / `softLight` / `hardLight` |
| 반전 (inversion family) | `difference` / `exclusion` |
| 색상 (HSL family) | `hue` / `saturation` / `color` / `luminosity` |

Compose 측 mapping = `BlendMode.Multiply` / `Screen` / `Overlay` 등 (= `androidx.compose.ui.graphics.BlendMode` namespace 측 동일 enum 측정 default).

---

## 5. Flexbox Layout paradigm

```typescript
export interface Layout {
  layout?: "none" | "vertical" | "horizontal";
  gap?: NumberOrVariable;
  layoutIncludeStroke?: boolean;
  padding?: NumberOrVariable | [NumberOrVariable, NumberOrVariable] |
    [NumberOrVariable, NumberOrVariable, NumberOrVariable, NumberOrVariable];
  justifyContent?: "start" | "center" | "end" | "space_between" | "space_around";
  alignItems?: "start" | "center" | "end";
}

export type SizingBehavior = string;
// "fit_content" | "fill_container"
```

### 5.1 `layout` direction

| 측정값 | Compose mapping |
|---|---|
| `"none"` | absolute positioning (= `Box` 측 `Modifier.offset(...)`) |
| `"vertical"` | `Column { ... }` |
| `"horizontal"` | `Row { ... }` |

### 5.2 `gap` + `padding`

```kotlin
Column(
    modifier = Modifier.padding(16.dp),
    verticalArrangement = Arrangement.spacedBy(8.dp)
) { ... }
```

`gap` ↔ `Arrangement.spacedBy(<dp>)` · `padding` ↔ `Modifier.padding(<dp>)` (= 1 / 2 / 4 측정값 측 분기 mapping default).

### 5.3 `justifyContent` + `alignItems`

| Pencil | Compose (Column) | Compose (Row) |
|---|---|---|
| `justifyContent: "start"` | `verticalArrangement = Arrangement.Top` | `horizontalArrangement = Arrangement.Start` |
| `justifyContent: "center"` | `Arrangement.Center` | `Arrangement.Center` |
| `justifyContent: "end"` | `Arrangement.Bottom` | `Arrangement.End` |
| `justifyContent: "space_between"` | `Arrangement.SpaceBetween` | `Arrangement.SpaceBetween` |
| `justifyContent: "space_around"` | `Arrangement.SpaceAround` | `Arrangement.SpaceAround` |
| `alignItems: "start"` | `horizontalAlignment = Alignment.Start` | `verticalAlignment = Alignment.Top` |
| `alignItems: "center"` | `Alignment.CenterHorizontally` | `Alignment.CenterVertically` |
| `alignItems: "end"` | `Alignment.End` | `Alignment.Bottom` |

### 5.4 `SizingBehavior` (= width / height 측)

| 측정값 | Compose mapping |
|---|---|
| `"fit_content"` | `Modifier.wrapContentSize()` (= 또는 width / height 측 기본 default) |
| `"fill_container"` | `Modifier.fillMaxWidth()` / `Modifier.fillMaxHeight()` / `Modifier.fillMaxSize()` |
| numeric (= 측정값) | `Modifier.size(<dp>)` / `Modifier.width(<dp>)` / `Modifier.height(<dp>)` |

### 5.5 권장 spacing scale (= 본 패키지 측 baseline · `pencil-theme-multi-axis.md` 정합)

| token | default measurement |
|---|---|
| `spacing.xs` | 4dp |
| `spacing.sm` | 8dp |
| `spacing.md` | 16dp |
| `spacing.lg` | 24dp |
| `spacing.xl` | 32dp |

Pencil 측 raw numeric 측정 X · `$spacing.*` variable reference 권장 default (= `design-prompting-paradigm.md` §3 정합).

---

## 6. icon_font paradigm

```typescript
export interface IconFont extends Entity, Size, CanHaveEffects {
  type: "icon_font";
  iconFontName?: StringOrVariable;
  iconFontFamily?: StringOrVariable;
  weight?: NumberOrVariable;
  fill?: Fills;
}
```

### 6.1 허용 `iconFontFamily` 측정값

| family | 본질 | 본 패키지 측 권장 |
|---|---|---|
| `"lucide"` | Lucide icon set (= 1300+ icons · MIT) | 일반 UI icon default |
| `"feather"` | Feather icons (= 287 icons · MIT · 단순 line style) | minimal design 측 |
| `"Material Symbols Outlined"` | Material Symbols outlined variant | Material3 Compose 측 정합 default |
| `"Material Symbols Rounded"` | rounded variant | friendly tone design 측 |
| `"Material Symbols Sharp"` | sharp variant | sharp / professional tone design 측 |
| `"phosphor"` | Phosphor icons (= 1500+ icons · MIT · 다중 weight) | rich variety 측 |

### 6.2 `iconFontName` 측정값

각 family 측 icon 측 단일 name (= `"check"` / `"home"` / `"settings"` 등). family 측 doc 측 측정값 list 단일 reference default.

### 6.3 `weight` variable

Material Symbols + Phosphor family 측 variable weight 측정 가능 (= 100 / 200 / 300 / 400 / 500 / 600 / 700 / fill). Lucide + Feather 측 단일 stroke weight default (= weight field 무 효과).

### 6.4 Compose 측 mapping paradigm

#### 6.4.1 Material Symbols (= Material3 측 default 정합)

```kotlin
Icon(
    imageVector = Icons.Outlined.Check,
    contentDescription = "Check",
    modifier = Modifier.size(24.dp),
    tint = MaterialTheme.colorScheme.primary
)
```

Compose 측 `androidx.compose.material.icons.outlined.*` namespace 측정 default. Pencil `iconFontName: "check"` ↔ `Icons.Outlined.Check` = 1:1 mapping default.

#### 6.4.2 Lucide / Feather / Phosphor (= 3rd-party library 측 정합)

본 패키지 측정 시 추가 dependency 필요:
- Lucide: `androidx.compose:lucide-compose:*` (= 가정 · 실 library 측 사용자 확인 의무)
- Feather: 동족 paradigm
- Phosphor: `com.adamglin:phosphor-icon-compose:*` (= 후보 default)

`code-principles.md` §3 정합 · `libs.versions.toml` 측 신규 dependency 추가 시점 = `DependencyDecision` 8 항목 PLAN 명시 의무 default.

### 6.5 권장 paradigm (= 본 패키지 default)

본 패키지 default = `"Material Symbols Outlined"` (= Material3 정합 + 외부 dependency 없음). family 변경 측 별 cycle 분리 default.

---

## 7. AI agent 측 호출 paradigm

### 7.1 Mesh gradient 측 prompt 예

```
"Create a mesh gradient fill for the hero section with:
- 3 columns × 3 rows grid
- Top-left: $color.primary (#1A1A1A)
- Top-right: $color.accent (#FF6B35)
- Bottom-left: $color.surface (#F9FAFB)
- Bottom-right: $color.tertiary (#6366F1)
- Smooth bezier handle interpolation"
```

### 7.2 Layout 측 prompt 예

```
"Apply vertical flexbox layout to the form container:
- gap: $spacing.md (16dp)
- padding: $spacing.lg (24dp)
- justifyContent: start
- alignItems: stretch (fill_container width)"
```

### 7.3 Effect 측 prompt 예

```
"Add elevation effect to the card:
- outer shadow: offset (0, 4), blur 8, spread 0, color #00000040
- background_blur: radius 12 (frosted glass behind card)
- corner radius: 12dp"
```

### 7.4 Icon 측 prompt 예

```
"Add a check icon to the success button:
- iconFontFamily: Material Symbols Outlined
- iconFontName: check_circle
- size: 24dp
- weight: 400
- fill: $color.onPrimary"
```

---

## 8. STOP 조건

| trigger | mitigation |
|---|---|
| `iconFontFamily` 측 허용 외 measurement (= family list 측 부재 token) | family enumeration 측 본 SoT §6.1 정합 의무 default · prompt 재 작성 의뢰 |
| Mesh gradient 측 `columns × rows` vs `colors.length` mismatch 발견 | `columns * rows == colors.length` 등식 의무 default · prompt 측 grid 측정 재 확인 |
| `padding` array length 측 1 / 2 / 4 외 measurement | 1 (= 4-side 동일) / 2 (= vertical + horizontal) / 4 (= top + right + bottom + left) 외 X default · prompt 재 작성 의뢰 |
| `shadowType: "inner"` 측 Compose 측 default API 부재 | platform 분기 의무 default · Android 측 `BlurMaskFilter` direct call · iOS 측 별 paradigm 측정 의뢰 |
| BlendMode 측 17 enum 외 measurement | enum 단일 default · prompt 측 17 enum 측 재 선택 의뢰 |

---

## 9. 본 SoT 의 변경 정책

- cli infra 권장 byte-identical (5-repo · master + 4 자식)
- 변경 시 master cycle 신설 + 5-repo propagation (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## 10. 명시 cycle 이력

- 2026-05-19 · MASTER-CLI-PENCIL-OPTIMIZATION-002 · 본 SoT 신설 (= H26 단계 1 마감 · pencil.dev 공식 doc anchor §C #6 Mesh+Effect + #7 Flexbox + #8 icon_font 통합 흡수) + 5-repo byte-identical propagation
