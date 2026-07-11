# Pencil Component Paradigm SoT

> **단일 목적**: `reusable: true` Component definition + `type: "ref"` Instance + `descendants` nested customization + `slot` container 측 통합 paradigm 단일 SoT.
> **신설**: MASTER-CLI-PENCIL-OPTIMIZATION-002 (2026-05-19 H26 단계 1 마감).
> **공식 근거**: pencil.dev `/core-concepts/components` + `/core-concepts/slots` + `/for-developers/the-pen-format` (2026-04-03 last updated).
> **연관 파일**:
> - `pencil-pen-format-schema.md` §2.4 Frame + §2.8 Ref + §1 Variable system — 본 paradigm 측 schema 본문
> - `pencil-mcp-tools-reference.md` §1.1 `batch_design` — Component / Instance / Slot 생성 호출 paradigm
> - `pencil-theme-multi-axis.md` — Theme multi-axis 적용 Component 측 axis 별 propagation
> - `design-prompting-paradigm.md` §3 Reference Design Systems — 신규 Component 신설 vs 재사용 prompt paradigm
> - `design-to-code-sync.md` §9 — Compose 측 reusable component + Slot mapping paradigm
> SOT: `CLAUDE.md`

---

## 1. Component 측 본질

Pencil Component = 재사용 가능 design 단위 (= 단일 origin · 다중 instance · origin 측 변경 자동 propagation 적용). 본 패키지 측 Compose `@Composable` paradigm 측 정합 default (= `pencil-uiux-workflow.md` §3 5-type IMPL flow 정합).

### 1.1 Component lifecycle

```
[원소 신설] → [Cmd/Ctrl+Option/Alt+K] → [Component origin (Magenta bounding box)]
                                              ↓
                                        [복사 paradigm]
                                              ↓
                                     [Instance (Violet bounding box)]
                                              ↓
                                  [origin 측 변경 발화 시 자동 propagation]
```

### 1.2 Component origin 본질

- Magenta bounding box = origin 단일 표시 (= 시각 단서)
- 모든 instance 측 propagation 측 source default
- 본 schema 측 `reusable: true` 측정값 보유

### 1.3 Component instance 본질

- Violet bounding box = instance 측 시각 단서
- 단일 origin reference (= `pencil-pen-format-schema.md` §2.8 `Ref` 측 `ref` field)
- origin 변경 → 모든 instance 자동 propagation
- instance 별 override = `descendants` field 측 nested customization paradigm (= §4 참조)

---

## 2. Component 정의 paradigm (= `reusable: true`)

### 2.1 Schema 본문 인용

```typescript
export interface Entity extends Position, CanHaveRotation {
  id: string;
  reusable?: boolean;
  // ... 그 외 field
}
```

`reusable: true` 측정 시 → 본 entity 측 Component origin default. `id` field = 후속 `Ref` 측 `ref` 측 reference 측정값 default.

### 2.2 신설 paradigm (2 path)

| path | 본질 |
|---|---|
| **GUI path** | desktop app 측 원소 selection → `Cmd/Ctrl+Option/Alt+K` shortcut → properties panel 측 "Create component" button 클릭 |
| **batch_design path** | `mcp__pencil__batch_design` 호출 측 `reusable: true` field 명시 (= AI agent paradigm default) |

### 2.3 `batch_design` 호출 예

```javascript
batch_design({ ops: [
  I("ok-button", {
    type: "frame",
    reusable: true,
    width: 120,
    height: 48,
    cornerRadius: 8,
    fill: "$color.primary",
    children: [
      I("ok-button-label", {
        type: "text",
        content: "OK",
        fontWeight: "semibold",
        fontSize: 16,
        textAlign: "center"
      })
    ]
  })
] })
```

본 호출 마감 시점 → `"ok-button"` Component origin 생성 default. 후속 `type: "ref"` 측 `ref: "ok-button"` reference 측 instance 생성 가능.

### 2.4 Slot field 활성 조건

`reusable: true` + `type: "frame"` + 빈 `children` + `slot: [<recommended-component-id>]` 측 동시 만족 시 → Slot container default (= §3 참조).

---

## 3. Slot paradigm

Slot = Component origin 측 "drop zone" (= drag-and-drop 측 instance 측 content 측 삽입 영역). container component 측정 case = `panel` / `card` / `window` / `sidebar` / `table` 등 layout 측 wrapper default.

### 3.1 Schema 본문

```typescript
export interface Frame extends Rectangleish, CanHaveChildren, Layout {
  type: "frame";
  clip?: BooleanOrVariable;
  placeholder?: boolean;
  slot?: false | string[];
}
```

`slot` field 본질 = `[<recommended-component-id-1>, <id-2>, ...]` 측 array. 빈 array 측정 시 Slot 활성 단 recommend 부재 default · `false` 또는 undefined 시 미활성 default.

### 3.2 Slot 신설 paradigm

| step | 본질 |
|---|---|
| 1 | 빈 `Frame` 신설 (= children 미보유 default) |
| 2 | `Cmd/Ctrl+Option/Alt+K` 측 Component origin 전환 (= `reusable: true`) |
| 3 | properties panel 측 "Make a slot" button 클릭 또는 `batch_design` 측 `slot: [...]` field 명시 |
| 4 | suggested component id 측 array 등록 (= properties panel 측 `+` button 또는 batch 측 inline) |

### 3.3 시각 단서

- diagonal line patterns = canvas 측 slot 영역 표시
- properties panel 측 Slots 행 = 등록된 suggested component list

### 3.4 `batch_design` 호출 예

```javascript
batch_design({ ops: [
  I("card-container", {
    type: "frame",
    reusable: true,
    width: 320,
    height: "fit_content",
    layout: "vertical",
    padding: 16,
    gap: 12,
    fill: "$color.surface",
    cornerRadius: 12,
    slot: ["card-header", "card-body", "card-footer"]
  })
] })
```

본 호출 마감 시점 → `"card-container"` Slot container default. instance 측 `card-header` / `card-body` / `card-footer` 측 drop-in 가능.

### 3.5 Compose 측 mapping paradigm

Slot paradigm 측 Compose 측 정합 = `content: @Composable () -> Unit` slot pattern default.

```kotlin
@Composable
fun CardContainer(
    modifier: Modifier = Modifier,
    header: @Composable () -> Unit = {},
    body: @Composable () -> Unit,
    footer: @Composable () -> Unit = {}
) {
    Surface(
        modifier = modifier,
        shape = MaterialTheme.shapes.medium,
        color = MaterialTheme.colorScheme.surface
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            header()
            body()
            footer()
        }
    }
}
```

Pencil canvas 측 `card-container` Component origin ↔ Compose `CardContainer` Composable = 1:1 mapping default. instance 측 slot 측 drop-in component ↔ Composable 측 `content` lambda argument = 1:1 mapping default.

---

## 4. Descendants paradigm (= nested customization)

`descendants` field = Component instance 측 nested element customization paradigm. slash-prefixed key (= `"<descendant-path>/<property>"`) 측 path syntax default.

### 4.1 Schema 본문

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

### 4.2 path syntax 본문

| pattern | 본질 | 예 |
|---|---|---|
| `<child-id>` | 직접 child reference | `"label"` |
| `<child-id>/<property>` | child 측 property override | `"label/content"` |
| `<child-id>/<grandchild-id>/...` | deeper nesting | `"icon-wrapper/icon/fill"` |

### 4.3 customization 3 mode

#### 4.3.1 Property override

instance 측 origin 측 default value 변경:

```json
{
  "type": "ref",
  "ref": "ok-button",
  "id": "cancel-button-instance",
  "descendants": {
    "ok-button-label/content": "Cancel",
    "ok-button-label/fill": "$color.error"
  }
}
```

origin `ok-button` 측 `ok-button-label` child 측 `content` field + `fill` field 측 instance 단위 override default. origin 본문 무접촉 default.

#### 4.3.2 Object replacement

instance 측 origin child 측정 object 전체 교체:

```json
{
  "type": "ref",
  "ref": "icon-button",
  "descendants": {
    "icon": {
      "type": "icon_font",
      "iconFontFamily": "lucide",
      "iconFontName": "check"
    }
  }
}
```

origin `icon-button` 측 `icon` child 측 object 전체 교체 default (= type 변경 가능 단 valid Child type 의무).

#### 4.3.3 Children replacement

instance 측 children array 전체 교체:

```json
{
  "type": "ref",
  "ref": "list-container",
  "descendants": {
    "children": [
      { "type": "text", "content": "Item 1" },
      { "type": "text", "content": "Item 2" }
    ]
  }
}
```

origin `list-container` 측 children array 전체 교체 default.

### 4.4 nested instance customization (= deep descendants)

origin component 측 child 측 `type: "ref"` (= nested instance) 측정 시 → 본 nested instance 측 descendants 측 deeper path 측 customization 가능:

```json
{
  "type": "ref",
  "ref": "dialog",
  "descendants": {
    "ok-button/label/content": "Confirm",
    "cancel-button/label/content": "Discard"
  }
}
```

origin `dialog` 측 `ok-button` (= nested instance · `ref: "ok-button"`) 측 `label` child 측 `content` field 측 instance 단위 override default.

### 4.5 Compose 측 mapping paradigm

Descendants paradigm 측 Compose 측 정합 = Composable parameter default value override default.

```kotlin
@Composable
fun OkButton(
    label: String = "OK",
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Button(onClick = onClick, modifier = modifier) {
        Text(label)
    }
}

// Pencil descendants 측 "ok-button-label/content": "Cancel" ↔
// Compose OkButton(label = "Cancel", ...) 측 mapping
```

---

## 5. AI agent 측 호출 paradigm

### 5.1 신규 Component 신설 prompt 측 권장 형식

`design-prompting-paradigm.md` §1~§3 정합 default:

```
"Create a reusable card component named 'product-card' with:
- 320dp width, fit_content height
- 16dp padding, 12dp gap, vertical layout
- $color.surface fill, 12dp corner radius
- 3 children: 'card-image' (frame, 100% width, 200dp height),
  'card-title' (text, $typography.titleMedium),
  'card-description' (text, $typography.bodySmall)"
```

measurable values (= dp / variable reference) + named references (= `$color.*` / `$typography.*`) + scope bound (= 'product-card' 단일) 정합 default.

### 5.2 Instance 신설 prompt

```
"Create 3 instances of 'product-card' with descendants override:
- Instance 1: 'card-title/content' = 'Smartphone',
  'card-image/fill' = stock photo 'modern smartphone'
- Instance 2: 'card-title/content' = 'Laptop',
  'card-image/fill' = stock photo 'silver laptop'
- Instance 3: 'card-title/content' = 'Tablet',
  'card-image/fill' = stock photo 'tablet on desk'"
```

### 5.3 Slot container 신설 prompt

```
"Create a reusable 'panel' component as a slot container with:
- Vertical layout, 16dp padding, 8dp gap
- $color.surface fill, 1dp $color.border stroke
- 8dp corner radius
- Suggested slot components: ['panel-header', 'panel-body']
- Empty children (slot drop zone)"
```

---

## 6. STOP 조건

| trigger | mitigation |
|---|---|
| `descendants` key 측 origin 측 child id 미존재 발견 | batch_design 측 FAIL 발화 · agent prompt 측 path 재 확인 의뢰 |
| Slot container 측 children 비빈 발견 + `slot: [...]` 동시 적용 시도 | empty Frame 의무 default · 비빈 children 시 일반 Frame 분류 default |
| nested instance customization 측 deeper path 측 origin chain 깨짐 | `batch_get` 측 origin tree 본문 측정 후 prompt 재 작성 |
| `ref` field 측 component id 측 reusable 미보유 발견 | origin component 측 `reusable: true` 측정 의무 default · 미보유 component instance 신설 X |

---

## 7. 본 SoT 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 6-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## 8. 명시 cycle 이력

- 2026-05-19 · MASTER-CLI-PENCIL-OPTIMIZATION-002 · 본 SoT 신설 (= H26 단계 1 마감 · pencil.dev 공식 doc anchor §C #2 descendants + #3 Slot + #5 reusable 통합 흡수) + 5-repo byte-identical propagation
