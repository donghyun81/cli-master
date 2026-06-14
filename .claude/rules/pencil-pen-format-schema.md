# .pen Format Schema SoT

> **단일 목적**: `.pen` file format (현 version `"2.13"`) TypeScript schema 본문 + 13 Entity type 단일 reference + AI agent 측 `batch_design` / `batch_get` 호출 시 schema 정합 의무. ⚠ **본 body (§2~§5) = 2.11-shape · 2.13 structural delta = §1.1a 배너 참조 · body rewrite PENDING** (= `MASTER-CLI-PENCIL-SCHEMA-UPDATE-001`).
> **신설**: MASTER-CLI-PENCIL-OPTIMIZATION-002 (2026-05-19 H26 단계 1 마감).
> **공식 근거**: pencil.dev `/for-developers/the-pen-format` (2026-04-03 last updated).
> **연관 파일**:
> - `pencil-component-paradigm.md` — Component + Instance + Slot + Descendants paradigm (= reusable + ref + slot + descendants 본 schema 측 구체 활용)
> - `pencil-theme-multi-axis.md` — Theme multi-axis paradigm (= `themes` field 본 schema 측 정합)
> - `pencil-visual-primitives.md` — Fill / Stroke / Effect / Layout (= mesh_gradient + blur + flexbox 본 schema 측 본문)
> - `pencil-mcp-tools-reference.md` §1.1 `batch_design` + §1.2 `batch_get` — 본 schema 정합 호출 paradigm
> - `design-to-code-sync.md` §9 — Variables ↔ Compose Theme.kt sync paradigm
> SOT: `CLAUDE.md`

---

## 1. Document 본질

`.pen` file = JSON 직렬 + Git friendly 측 design source. encryption 영역 = MCP server 측 단일 access default (= Read / Grep direct 차단 의무 · `pencil` namespace tool 단일 진입점).

### 1.1 최상위 Document interface

```typescript
export interface Document {
  version: "2.13";
  themes?: { [key: string]: string[] };
  imports?: { [key: string]: string };
  variables?: { [key: string]: Variable };
  children: Child[];
}
```

| key | 본질 |
|---|---|
| `version` | `"2.13"` 고정 (= 2026-06-15 live MCP 측정 baseline · 2.13 structural delta body = §1.1a 배너 PENDING · 후속 변경 시 본 SoT 갱신 cycle 진입 의무) |
| `themes` | multi-axis theme map (= `mode` / `spacing` / `device` 등 axis 별 string[] · 상세 = `pencil-theme-multi-axis.md`) |
| `imports` | 외부 library import map (= `<alias>: <library-id>` · `.lib.pen` reference) |
| `variables` | document-scope variable map (= `<name>: Variable` · 본 §5 참조) |
| `children` | 최상위 Child[] (= 13 Entity type 측 union · 본 §2 참조) |

### 1.1a ⚠ 2.13 structural delta (= body rewrite PENDING · MASTER-CLI-PENCIL-SCHEMA-UPDATE-001)

> **본 SoT body (§2 union + §2.2~§2.8 + §4 graphics + §5 variable) 는 아직 2.11-shape 다.** 2026-06-15 live Pencil MCP (`get_editor_state(include_schema:true)` · active editor `GentlyTable/docs/design/pencil-sot/report-screen/report-screen.pen`) 측정 결과 disk `.pen` 5종이 2.13 auto-migration 됐고, 2.13 schema 는 minor bump 이 아니라 **structural** 이다. 본 cycle 은 version label 만 2.13 정합 (= "최소 정직") · body 전면 rewrite + 형제 Pencil rule 4종 정합 = **별 follow-up cycle**.
>
> **AI agent 의무**: `batch_design` / `batch_get` 전 반드시 `get_editor_state(include_schema:true)` 로 live 2.13 schema 를 pull 한다 (= 본 body 의 2.11-shape 표기를 신뢰하지 말 것 · MCP server 측 자체 지시 정합).

측정된 2.11 → 2.13 structural delta (8 건):

| # | 영역 | 2.11 (본 body 현 표기) | 2.13 (live 실측) |
|---|---|---|---|
| 1 | Entity union | `line` 포함 (§2 #3 · §2.2) | **`line` 제거** |
| 2 | Entity union | `icon_font` / `IconFont` (`iconFontName` · `iconFontFamily`) (§2 #12 · §2.7) | **`icon` / `Icon` rename** (`icon` · `library`) |
| 3 | Entity union | (부재) | **`script` / `Script` 신규** (`scriptUri` · `inputs` · `clip`) |
| 4 | Variable | `Variable = string` · raw 값 (§1.2 · §5) | **typed 선언** `{ type: "boolean"\|"color"\|"number"\|"string"; value }` |
| 5 | Stroke | `stroke?: Stroke` (nested · `pencil-visual-primitives.md §2`) | **flatten** `stroke?: Fills` + `strokeWidth` · `strokeLinecap` · `strokeLinejoin` · `strokeAlignment` |
| 6 | Fill | color / gradient / image / mesh_gradient (§4 · visual-primitives §1) | **`shader` fill 추가** |
| 7 | Text | `TextContent = StringOrVariable \| TextStyle[]` (§2.3) | **`StringOrVariable`** (array 형 제거) |
| 8 | Group | Layout + width / height 보유 (§2.5) | **Layout + width / height 상실** |

(minor) `Path.viewBox?` 추가 (§2.2) · `Entity` `CanHaveRotation` inline (§2.1). union count = 13 유지 (= −line −icon_font +icon +script). 형제 ripple (= 별 cycle): `pencil-visual-primitives.md` (stroke / shader / icon) · `pencil-mcp-tools-reference.md` (icon enum) · `pencil-component-paradigm.md §4.3.2` (iconFontFamily 예시) · `pencil-theme-multi-axis.md §2` (변수 raw-값 예시). 보호 `ui-spec.schema.json` = `.pen` ref 0 → 무접촉.

### 1.2 Variable / 측정 단위 type

```typescript
export interface Theme { [key: string]: string; }
export type Variable = string;
export type NumberOrVariable = number | Variable;
export type Color = string;
export type ColorOrVariable = Color | Variable;
export type BooleanOrVariable = boolean | Variable;
export type StringOrVariable = string | Variable;
```

Variable reference 측 syntax = `$` prefix 측정값 (= `"$color.background"` 등). 모든 numeric / color / boolean / string field 측 Variable substitution 허용 default.

---

## 2. 13 Entity type union (= Child)

```typescript
export type Child = Frame | Group | Rectangle | Ellipse | Line | Path |
  Polygon | Text | Note | Prompt | Context | IconFont | Ref;
```

| # | type | 본질 |
|---|---|---|
| 1 | `rectangle` | 사각형 도형 (= 기본 도형) |
| 2 | `ellipse` | 타원 / 원 |
| 3 | `line` | 선분 |
| 4 | `polygon` | 다각형 (= n각형) |
| 5 | `path` | 자유 path (= SVG geometry) |
| 6 | `text` | 텍스트 |
| 7 | `frame` | 컨테이너 (= children + layout + slot) |
| 8 | `group` | group 묶음 (= children + effect + layout) |
| 9 | `note` | annotation (= 디자인 의도 메모) |
| 10 | `prompt` | AI prompt node (= model field 동반) |
| 11 | `context` | AI context (= prompt 측 context 본문) |
| 12 | `icon_font` | icon font glyph (= lucide / feather / Material Symbols / phosphor) |
| 13 | `ref` | Component instance reference (= reusable component 측 instance) |

### 2.1 Entity base

```typescript
export interface Entity extends Position, CanHaveRotation {
  id: string;
  name?: string;
  context?: string;
  reusable?: boolean;
  theme?: Theme;
  enabled?: BooleanOrVariable;
  opacity?: NumberOrVariable;
  flipX?: BooleanOrVariable;
  flipY?: BooleanOrVariable;
  layoutPosition?: "auto" | "absolute";
  metadata?: { type: string; [key: string]: any };
}
```

| field | 본질 |
|---|---|
| `id` | unique identifier (= document scope 단일 default) |
| `reusable` | `true` 측정 시 Component origin (= `pencil-component-paradigm.md` §2 정합) |
| `layoutPosition` | `"auto"` (= flex 흐름 정합) 또는 `"absolute"` (= 절대 좌표) |

### 2.2 Rectangle / Ellipse / Line / Polygon / Path

```typescript
export interface Rectangleish extends Entity, Size, CanHaveGraphics {
  cornerRadius?: NumberOrVariable |
    [NumberOrVariable, NumberOrVariable, NumberOrVariable, NumberOrVariable];
}

export interface Rectangle extends Rectangleish { type: "rectangle"; }

export interface Ellipse extends Entity, Size, CanHaveGraphics {
  type: "ellipse";
  innerRadius?: NumberOrVariable;
  startAngle?: NumberOrVariable;
  sweepAngle?: NumberOrVariable;
}

export interface Line extends Entity, Size, CanHaveGraphics { type: "line"; }

export interface Polygon extends Entity, Size, CanHaveGraphics {
  type: "polygon";
  polygonCount?: NumberOrVariable;
  cornerRadius?: NumberOrVariable;
}

export interface Path extends Entity, Size, CanHaveGraphics {
  type: "path";
  fillRule?: "nonzero" | "evenodd";
  geometry?: string;
}
```

### 2.3 Text

```typescript
export interface TextStyle {
  fontFamily?: StringOrVariable;
  fontSize?: NumberOrVariable;
  fontWeight?: StringOrVariable;
  letterSpacing?: NumberOrVariable;
  fontStyle?: StringOrVariable;
  underline?: BooleanOrVariable;
  lineHeight?: NumberOrVariable;
  textAlign?: "left" | "center" | "right" | "justify";
  textAlignVertical?: "top" | "middle" | "bottom";
  strikethrough?: BooleanOrVariable;
  href?: string;
}

export type TextContent = StringOrVariable | TextStyle[];

export interface Text extends Entity, Size, CanHaveGraphics, TextStyle {
  type: "text";
  content?: TextContent;
  textGrowth?: "auto" | "fixed-width" | "fixed-width-height";
}
```

### 2.4 Frame (= children + layout + slot)

```typescript
export interface CanHaveChildren { children?: Child[]; }

export interface Frame extends Rectangleish, CanHaveChildren, Layout {
  type: "frame";
  clip?: BooleanOrVariable;
  placeholder?: boolean;
  slot?: false | string[];
}
```

`slot` field 본질 = `[<recommended-component-id>]` 측 array (= `pencil-component-paradigm.md` §3 정합). 빈 `Frame` 측 `reusable: true` 적용 후 `slot` field 활성 시 = Slot container default.

### 2.5 Group

```typescript
export interface Group extends Entity, CanHaveChildren, CanHaveEffects, Layout {
  type: "group";
  width?: SizingBehavior;
  height?: SizingBehavior;
}
```

Frame 측 차이 = Stroke 미보유 + Fill 미보유 (= 단순 묶음 default).

### 2.6 Note / Prompt / Context (= AI annotation)

```typescript
export interface Note extends Entity, Size, TextStyle {
  type: "note";
  content?: TextContent;
}

export interface Prompt extends Entity, Size, TextStyle {
  type: "prompt";
  content?: TextContent;
  model?: StringOrVariable;
}

export interface Context extends Entity, Size, TextStyle {
  type: "context";
  content?: TextContent;
}
```

`Note` = 디자이너 측 의도 메모 (= 변환 X). `Prompt` = AI 측 input prompt (= `model` field 측 `claude-opus-4-6` / `claude-sonnet-4-6` / `claude-haiku-4-5` 선택). `Context` = `Prompt` 측 context 본문 보강.

### 2.7 IconFont

```typescript
export interface IconFont extends Entity, Size, CanHaveEffects {
  type: "icon_font";
  iconFontName?: StringOrVariable;
  iconFontFamily?: StringOrVariable;
  weight?: NumberOrVariable;
  fill?: Fills;
}
```

`iconFontFamily` 허용 값 = `"lucide"` / `"feather"` / `"Material Symbols Outlined"` / `"Material Symbols Rounded"` / `"Material Symbols Sharp"` / `"phosphor"`. 상세 = `pencil-visual-primitives.md` §4.

### 2.8 Ref (= Component instance)

```typescript
export interface Ref extends Entity {
  type: "ref";
  ref: string;
  descendants?: {
    [key: string]: {};
  };
  [key: string]: any;
}
```

`ref` = origin component id reference. `descendants` = slash-prefixed key 측 nested customization (= `"ok-button/label"` 형식 · 상세 = `pencil-component-paradigm.md` §4).

---

## 3. Position / Size / Rotation

```typescript
export interface Position {
  x?: number;
  y?: number;
}

export interface Size {
  width?: NumberOrVariable | SizingBehavior;
  height?: NumberOrVariable | SizingBehavior;
}

export interface CanHaveRotation {
  rotation?: NumberOrVariable;
}

export type SizingBehavior = string;
// "fit_content" | "fill_container"
```

- `width` / `height` 측정값 = numeric (= 측정 단위 px default) 또는 Variable reference 또는 `SizingBehavior` ("fit_content" / "fill_container").
- `SizingBehavior` 측 Compose 측 mapping = `Modifier.wrapContentSize()` (= fit_content) / `Modifier.fillMaxWidth()` 또는 `Modifier.fillMaxHeight()` (= fill_container).

---

## 4. Graphics primitive (= Fill / Stroke / Effect 단일 reference)

```typescript
export interface CanHaveGraphics {
  stroke?: Stroke;
  fill?: Fills;
  effect?: Effects;
}

export interface CanHaveEffects {
  effect?: Effects;
}
```

상세 본문 = `pencil-visual-primitives.md` §1 (Fill 4 종 + Stroke + Effect 3 종 + BlendMode 17).

---

## 5. Variable / Theme system

### 5.1 Variable reference

document `variables` map 측 등록 후 모든 numeric / color / boolean / string field 측 `"$<name>"` 형태로 reference 가능.

```json
{
  "variables": {
    "color.primary": "#1A1A1A",
    "spacing.md": 16
  },
  "children": [
    {
      "type": "rectangle",
      "id": "button",
      "fill": "$color.primary",
      "width": "$spacing.md"
    }
  ]
}
```

### 5.2 Theme multi-axis

`themes` field 측 axis 본문:

```json
{
  "themes": {
    "mode": ["light", "dark"],
    "spacing": ["compact", "default", "comfortable"],
    "device": ["mobile", "tablet", "desktop"]
  }
}
```

상세 = `pencil-theme-multi-axis.md` §1.

### 5.3 Theme-specific variable assignment

variable 측 theme axis 별 value array 측 assignment:

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

---

## 6. AI agent 측 `batch_design` 호출 정합 paradigm

`mcp__pencil__batch_design` 측 호출 paradigm = 본 schema 정합 의무 (= `pencil-mcp-tools-reference.md` §1.1 정합).

### 6.1 children inline 강제

```javascript
// X (flatten 발생 · F-1/F-2 검증 사고 패턴)
batch_design({ ops: [
  I("document", { ... }),
  I("doc-child-1", { ... })  // 별 호출 추가
] })

// O (정상 · inline 강제)
batch_design({ ops: [
  I("document", {
    children: [
      I("child-1", { type: "frame", ... }),
      I("child-2", { type: "text", ... })
    ]
  })
] })
```

### 6.2 25-op limit + 분할 호출

단일 `batch_design` 호출 측 op ≤ 25 (= Pencil 백엔드 한계). 초과 시 frame insert 1 op + children 22~25 op = 첫 호출 / 추가 children = 후속 호출. 각 호출 children inline 의무.

### 6.3 13 Entity type 측 호출 시 정합 의무

- `type` field 정확 표기 (= `"rectangle"` / `"ellipse"` 등 13 enum 단일 default)
- `id` unique 의무 (= document scope · 중복 시 호출 FAIL)
- `position` / `size` field 측 numeric 또는 Variable reference (= mixed 허용)
- `reusable: true` 시 Component origin default (= `pencil-component-paradigm.md` §2 정합)
- `type: "ref"` 시 `ref` field 측 origin id 명시 의무
- `type: "frame"` 측 `slot` field 사용 시 Component origin + empty children 의무

---

## 7. STOP 조건

| trigger | mitigation |
|---|---|
| `version` field 측 `"2.13"` 외 measurement | 공식 doc 측 schema upgrade 측정 + 본 SoT 갱신 cycle 진입 (= `MASTER-CLI-PENCIL-SCHEMA-UPDATE-NNN`) |
| 14 번째 Entity type 발견 (= 공식 doc 측 신규 추가) | 본 SoT §2 union type 갱신 + 6-repo propagation cycle 진입 |
| `Ref` 측 `ref` field 미명시 + `type: "ref"` 호출 시도 | batch_design 측 FAIL 발화 · agent prompt 측 component id 명시 의뢰 |
| Variable reference 측 `$` prefix 부재 + 존재 X token 시도 | document `variables` map 측 등록 의무 (= 등록 X 시 raw string default) |
| schema 본문 측 mismatch + AI agent 측 prompt 측 임의 type 추가 시도 | 본 schema 13 type 외 추가 X default · prompt 재 작성 의뢰 |

---

## 8. 본 SoT 의 변경 정책

- cli infra 권장 byte-identical (6-repo · master + 5 자식)
- 변경 시 master cycle 신설 + 6-repo propagation (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## 9. 명시 cycle 이력

- 2026-05-19 · MASTER-CLI-PENCIL-OPTIMIZATION-002 · 본 SoT 신설 (= H26 단계 1 마감 · pencil.dev 공식 doc anchor §C #1 흡수 · 13 Entity type 통합 reference) + 5-repo byte-identical propagation
- 2026-05-31 · MASTER-CLI-PENCIL-RECOLOR-GENERATOR-001 · `.pen` version baseline `"2.10"` → `"2.11"` 갱신 (= 실 disk `.pen` 측 version `"2.11"` 실측 정합 default · §1.1 Document interface + §1.1 표 + §7 STOP 조건 + 본 목적 line 동기) + 5-repo byte-identical propagation. 13 Entity type union + Variable / Theme system 본문 무변경 (= minor version bump · schema 구조 동일 default).
- 2026-06-15 · MASTER-CLI-PENCIL-SCHEMA-UPDATE-001 · `.pen` version label `"2.11"` → `"2.13"` 갱신 (= 2026-06-15 live Pencil MCP `get_editor_state(include_schema:true)` 측정 · active editor `report-screen.pen` · disk 5종 v2.13 auto-migration 정합 · §1.1 Document interface + §1.1 표 + §7 STOP trigger + 목적 line 동기) + §1.1a structural delta 배너 신설. **2026-05-31 recolor 선례와 대비 = minor bump 아님 · structural** (= 8 delta: −line · −icon_font · +icon · +script · typed variables · stroke flatten · shader fill · TextContent · Group). Coin 본심 = "최소 정직" (= version label + §1.1a 유예 배너 · body §2 13 union + §2.2~§2.8 + §4 + §5 = 2.11-shape 유지 PENDING). body 전면 rewrite + 형제 Pencil rule 4종 (`pencil-visual-primitives.md` / `pencil-mcp-tools-reference.md` / `pencil-component-paradigm.md` / `pencil-theme-multi-axis.md`) 정합 = 별 follow-up cycle. 보호 `ui-spec.schema.json` = `.pen` ref 0 무접촉 + 6-repo byte-identical propagation.
