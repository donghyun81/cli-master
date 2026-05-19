# Pencil MCP Tools Reference (12 official + 1 package-verified)

> **단일 목적**: Pencil MCP server 측 `mcp__pencil__*` 도구 전체 reference. 공식 12 + 본 패키지 검증 추가 1 분리 명시.
> **신설**: MASTER-CLI-PENCIL-OPTIMIZATION-001 (2026-05-19).
> **공식 근거**: pencil.dev `/getting-started/ai-integration` (2026-04-03 last updated).
> **연관 파일**:
> - `pencil-uiux-workflow.md` §1 — 본 SoT 단일 참조 의무 (도구 목록 중복 금지)
> - `pencil-cli-headless.md` — CLI headless shell 안에서도 동일 도구 surface 노출
> - `pencil-automation.md` §12 — 실 호출 sequence (children inline · 25 op limit)
> SOT: `CLAUDE.md`

---

## 0. 분리 원칙

본 SoT 안 도구 2 그룹 분리:

- **Part A (Official 12)** — pencil.dev 공식 doc 2026-04-03 명시. 호환 표준 = pencil.dev 모든 client.
- **Part B (Package-verified 1)** — 공식 doc 안 명시 X. 본 패키지 실 검증된 영역. 다른 client 측 동작 보장 없음.

신규 cli session 진입 시 = 본 SoT 단일 참조. 그 외 file (`pencil-uiux-workflow.md` 등) 안 도구 목록 중복 금지.

---

# Part A — Official 12 tools (pencil.dev 2026-04-03)

## 1. Design Operations (5 tools)

### 1.1 `batch_design`

- 본질: node 삽입 / 갱신 / 삭제 / 이동 / 복사 / 교체 일괄 op
- 호출 단위: 한 호출 안 op ≤ 25 (`pencil-automation.md` §12 정합)
- children 의무: inline 강제 (`I("root", { children: [...] })`) · flatten 발생 패턴 금지
- 분할 호출: op > 25 시 frame insert 1 op + children 22~25 op = 첫 호출 / 추가 children = 후속 호출 (각 호출 children inline)

#### 1.1.1 .pen format 13 Entity type 정합 호출 (= `MASTER-CLI-PENCIL-OPTIMIZATION-002` 강화)

본 cycle 측 강화 본문 (= H26 단계 1 마감). 호출 시 `type` field 측 13 Entity enum 단일 default (= `rectangle` / `ellipse` / `line` / `polygon` / `path` / `text` / `frame` / `group` / `note` / `prompt` / `context` / `icon_font` / `ref`). 본문 단일 SoT = `pencil-pen-format-schema.md` §2.

```javascript
batch_design({ ops: [
  I("dashboard", {
    type: "frame",
    layout: "vertical",
    gap: "$spacing.md",
    padding: "$spacing.lg",
    children: [
      I("header", { type: "frame", ... }),
      I("hero-text", { type: "text", content: "Welcome", ... }),
      I("cta", { type: "ref", ref: "primary-button", descendants: { "label/content": "Get Started" } })
    ]
  })
] })
```

#### 1.1.2 Component / Instance / Slot 호출 paradigm (= 강화 본문)

- **Component origin 신설**: `reusable: true` field 측정 (= `pencil-component-paradigm.md` §2 정합)
- **Instance 신설**: `type: "ref"` + `ref: <origin-id>` 명시 의무
- **Descendants override**: `descendants: { "<path>/<property>": <value> }` 형식 (= `pencil-component-paradigm.md` §4 정합 · slash-prefixed key syntax)
- **Slot container 신설**: empty `Frame` + `reusable: true` + `slot: [<recommended-component-id>]` array 동시 만족 의무

#### 1.1.3 Variable substitution 정합 호출

모든 numeric / color / boolean / string field 측 `$<variable-name>` reference 측 substitution 가능 (= document `variables` map 측 등록 변수 측). multi-axis variable 측 호출 = `pencil-theme-multi-axis.md` §5 정합.

### 1.2 `batch_get`

- 본질: pattern 또는 ID 측 node 검색 + 읽기
- 응답: node tree (children 포함 가능)
- 사용처: design state 검증 / 특정 component 추출 / debug

#### 1.2.1 13 Entity type 정합 검색 paradigm (= `MASTER-CLI-PENCIL-OPTIMIZATION-002` 강화)

본 cycle 측 강화 본문. `type` field 측 13 enum 측 filter 가능 (= 단일 type 한정 검색 default). 본문 단일 SoT = `pencil-pen-format-schema.md` §2.

```javascript
// 단일 type 검색 (= 모든 Component origin 추출)
batch_get({ pattern: { reusable: true } })

// 다중 조건 검색 (= 모든 Slot container 추출)
batch_get({ pattern: { type: "frame", reusable: true, "slot.length": { ">": 0 } } })

// nested component 측 검색 (= 모든 instance 측 origin chain 추출)
batch_get({ pattern: { type: "ref" }, include: "descendants" })
```

#### 1.2.2 Nested component search paradigm (= 강화 본문)

`type: "ref"` instance 측 origin chain 추적 paradigm:
- `ref` field 측 origin id 추출 → 다음 `batch_get({ id: <ref-id> })` 호출 측 origin 본문 측정
- nested instance (= origin 측 child 측 `type: "ref"`) 측 deeper chain 측 반복 default
- `descendants` field 측 override 본문 측 origin 측 default 측 비교 측 customization 추출 default

#### 1.2.3 Component instance audit paradigm

design system 측 token 정합 audit 측 권장 호출:

```javascript
// 모든 hardcoded color 검출 (= variable reference 미적용 instance 추출)
batch_get({
  pattern: { fill: { "$not_starts_with": "$" } },
  include: ["id", "name", "fill"]
})
```

`search_all_unique_properties` (= §3.1) + `replace_all_matching_properties` (= §3.2) 측 통합 audit + migration paradigm 정합 default.

### 1.3 `get_variables`

- 본질: design 측 variable (color / typography / spacing token) 읽기
- 응답: variable map (name → value)
- Variables ↔ Code Sync paradigm 진입점 (`design-to-code-sync.md` §9 정합)

### 1.4 `set_variables`

- 본질: design 측 variable 갱신
- 사용처: design token v2 도입 / inherit 적용 screen 일괄 반영 / Phase C type 5

### 1.5 `get_editor_state`

- 본질: document metadata + structure 조회
- 응답: 활성 component / layer 계층 / cursor 위치 등
- 사용처: agent 측 현재 state 인지 후 후속 op 결정

---

## 2. Layout / Structure tools (2)

### 2.1 `snapshot_layout`

- 본질: document structure + computed bounds 산출
- 핵심 옵션: `problemsOnly=true` (issues 만 반환 · 본 패키지 권장 default)
- export / screenshot 미수행 시 RCA-4 미해당 (F-1/F-2 검증 PASS · `pencil-automation.md` §12 정합)

### 2.2 `find_empty_space_on_canvas`

- 본질: 신규 요소 배치 가능한 empty region 산출
- 사용처: ux-auditor 측 new-element placement audit / batch 신설 시 자동 배치
- 본 cycle 안 신규 인용 도구 (`pencil-uiux-workflow.md` §1 추가 5종 중 1)

---

## 3. Property manipulation (2 · 본 cycle 안 신규 인용)

### 3.1 `search_all_unique_properties`

- 본질: node tree 안 unique property 재귀 검색
- 사용처: design system 측 token 정합 audit / hardcode hex 검출
- pattern: "모든 button 의 fill color 값 추출" 등

### 3.2 `replace_all_matching_properties`

- 본질: node tree 안 matching property 재귀 교체
- 사용처: token migration / design system v2 일괄 갱신
- pattern: "deprecated color `#FF0000` → token `error.primary` 일괄 교체"

---

## 4. Visual Operations (2)

### 4.1 `get_screenshot`

- 본질: 특정 node → PNG image render
- 사용처: P10 (`design-to-code-sync.md` §4) 시각 검증 / preview.png 신설 / 회귀 비교
- 산출: PNG byte stream

### 4.2 `export_nodes`

- 본질: 특정 node → 외부 file (PNG / JPEG / WEBP / PDF) export
- 사용처: docs/design/pencil-exports/ 안 preview asset 갱신 / 디자인 리뷰 자료 산출
- 옵션: scale (1x / 2x / 3x) · type (png/jpeg/webp/pdf)

---

## 5. Image Generation (`batch_design` 안 G() sub-op)

`batch_design` 호출 안 `G(...)` operation 측 이미지 생성. 독립 tool 이 아니라 design op 변종.

### 5.1 AI generation

```
G(nodeId, "ai", "minimalist mountain landscape at sunset")
```

- Claude / 다른 model 측 prompt → 이미지 자동 생성
- 사용처: placeholder photo / hero image / illustration

### 5.2 Stock photo (Unsplash)

```
G(nodeId, "stock", "coffee morning workspace")
```

- Unsplash API 측 keyword 검색 → 매칭 photo 자동 삽입
- 사용처: 실 photo 필요 + AI generation 부적합 시

### 5.3 Compose 측 placeholder paradigm

자식 repo Compose 측 `painterResource(R.drawable.<id>)` 또는 Coil load 측 placeholder image 신설 시 `G()` op 활용 가능. 단 production 측 이미지는 design 측 의도 측정 후 별 cycle 진입 권장.

---

## 6. Style & Guidelines (1)

### 6.1 `get_guidelines`

- 본질: "guide" category 측 design system 측 styles / guides 읽기
- 사용처: agent prompt context paradigm — design system 의도 보존 + token 정합
- 본 패키지 적용: ui-implementer agent 호출 시 design context 추출 (= ui-implementer.md 안 명시)

---

# Part B — Package-verified extension (1)

## 7. `open_document` (공식 doc 명시 X · 본 패키지 검증 영역)

- 본질: 신규 또는 기존 `.pen` 측 진입점
- 호출 패턴: `open_document(filePathOrTemplate="new")` 또는 `open_document(filePathOrTemplate="<path>.pen")`
- 본 패키지 검증된 한계: `filePathOrTemplate` 안 **"new" literal 만 유효** (path argument 미지원 · 신규 빈 canvas 신설 한정)
- 기존 `.pen` 편집 = desktop app 측 file open + `mcp__pencil__batch_design` 호출 (open_document path 형식 미지원)
- 공식 doc 명시 X = pencil.dev 측 client 업데이트 시 변경 가능 영역 · §FREEDOM
- 본 cycle (`MASTER-CLI-PENCIL-OPTIMIZATION-001`) 진입 시 baseline 명시 (= 후속 cycle 안 변동 시 STOP + Coin 재확인 의뢰)

---

# Part C — Operational paradigm

## 8. 25-op limit + children inline 강제

- `batch_design` 단일 호출 안 op ≤ 25 (pencil 백엔드 제한)
- children 별도 호출 X · inline 의무 (flatten 발생 회피 · F-1/F-2 검증 patterns)
- 분할 호출 시 각 호출 children inline 의무 (분할 = op 수 분할 단일 · 의미 분할 X)
- 본 paradigm SoT = `pencil-automation.md` §12 (본 SoT 안 중복 명시 X · 참조 only)

---

## 9. `batch_design` G() + Compose placeholder paradigm

자식 repo Compose 측 image placeholder 신설 cycle 안 권장 flow:

1. Pencil canvas 측 image frame 신설 (`batch_design` 안 frame insert op)
2. `G(frame_id, "ai", "<descriptive prompt>")` 또는 `G(frame_id, "stock", "<keyword>")` 추가 op
3. `save()` (CLI headless) 또는 hook 측 자동 저장
4. `export_nodes(frame_id, format="png", scale=2)` → `res/drawable/` 측 PNG file
5. Compose 측 `painterResource(R.drawable.<id>)` 참조

CI/CD 통합 = `pencil-cli-headless.md` §10 (lazy default · 별 cycle).

---

## 10. STOP 조건

- 공식 doc (pencil.dev) 측 12 tool list 변경 검출 → 본 SoT 갱신 cycle 진입 의무 (`MASTER-CLI-PENCIL-MCP-TOOLS-UPDATE-NNN` 패턴)
- `open_document` 측 path argument 지원 검출 → Part B 갱신 + 본 패키지 검증된 한계 영역 폐기
- 신규 도구 발견 (예: 12 → 13 official) → Part A 안 행 추가 + 본 cycle scope 외 별 trail

---

## 11. 본 SoT 의 변경 정책

- cli infra 권장 byte-identical (5-repo · master + 4 자식)
- 변경 시 master cycle 신설 + 5-repo propagation (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## 12. 명시 cycle 이력

- 2026-05-19 · MASTER-CLI-PENCIL-OPTIMIZATION-001 · 본 SoT 신설 (12 official + 1 package-verified 분리 명시) + 5-repo byte-identical propagation
