# Pencil MCP Tools Reference (9 tools · Pencil v1.1.62 surface)

> **단일 목적**: Pencil MCP server 측 `mcp__pencil__*` 도구 전체 reference. 현 surface = 9 종 (Pencil v1.1.62) · 구 13 종(공식 12 + package-verified 1) 중 4 종 제거 = deprecated 기록 보존.
> **신설**: MASTER-CLI-PENCIL-OPTIMIZATION-001 (2026-05-19).
> **공식 근거**: pencil.dev `/getting-started/ai-integration` (2026-04-03 last updated).
> **연관 파일**:
> - `pencil-uiux-workflow.md` §1 — 본 SoT 단일 참조 의무 (도구 목록 중복 금지)
> - `pencil-cli-headless.md` — CLI headless shell 안에서도 동일 도구 surface 노출
> - `pencil-automation.md` §12 — 실 호출 sequence (children inline · 25 op limit)
> SOT: `CLAUDE.md`

---

## 0. 분리 원칙 + 현 surface

본 SoT 안 도구 2 그룹 분리:

- **Part A (Official · 현 9)** — pencil.dev 공식 doc 명시. 호환 표준 = pencil.dev 모든 client. (구 12 중 3 제거 = Pencil v1.1.62.)
- **Part B (Package-verified · 현 0)** — 구 1 (`open_document`) = Pencil v1.1.62 제거. 본 패키지 검증 영역 폐기.

신규 cli session 진입 시 = 본 SoT 단일 참조. 그 외 file (`pencil-uiux-workflow.md` 등) 안 도구 목록 중복 금지.

### 0.1 제거 도구 (= Pencil v1.1.62 surface 축소 · `MASTER-CLI-PENCIL-TOOLSET-REMOVAL-STALE-SWEEP-001`)

구 13 종 surface 중 아래 4 종 = Pencil v1.1.62 측 제거 (= `ToolSearch query="pencil"` 측정 9 종 정합 · 게이트 baseline = `cycle-discipline.md §13`). 본 SoT 안 §2.2 / §3.1 / §3.2 / §7 = deprecated 기록 (호출 X).

| 제거 도구 | 구 위치 | 본질 (구) | 대체 메커니즘 (현) |
|---|---|---|---|
| `find_empty_space_on_canvas` | §2.2 | empty region 산출 (placement audit) | `snapshot_layout(maxDepth=0)` 측 top-level bounds 기반 빈 영역 판단 |
| `search_all_unique_properties` | §3.1 | unique property 재귀 검색 (token audit) | `batch_get` (= §1.2 pattern 검색) 또는 headless 평문-JSON 경로 (`pencil-uiux-workflow.md §2.5` PRIMARY) |
| `replace_all_matching_properties` | §3.2 | matching property 재귀 교체 (token migration) | `batch_design` (= §1.1) 또는 headless 평문-JSON 경로 (`pen_recolor.py` style · §2.5 PRIMARY) |
| `open_document` | §7 (Part B) | `.pen` 진입점 (new canvas) | headless `pencil interactive -o <path>` (`pencil-cli` skill PRIMARY) 또는 desktop visual = `open -a Pencil <abspath>` (Bash) + `batch_design` (active-doc MCP) |

### 0.2 멀티-repo workspace + cross-version 마이그 caveat (= `MASTER-CLI-PENCIL-MULTIREPO-HEADLESS-001` · 2026-06-24)

본 패키지 = 6-repo umbrella (= master + app-foundation + GB + GD + GT + gently-product-docs) · 자식 3 (GB/GD/GT) 측 `.pen` 보유. 아래 §1~§6 desktop-stdio 도구 운영 시점 3 caveat 정합 의무 (= HOME-PEN-2.13 혼선 근본 mitigation).

1. **MCP = single active workspace**: 본 §1~§6 desktop-stdio 도구 (`get_editor_state` · `batch_get` · `batch_design` · `get_screenshot` · `snapshot_layout` 등) 는 **현재 active editor/workspace 하나**에만 작동한다. 6-repo umbrella 측 MCP 는 단일 workspace (= 관측상 GentlyTable) 에 anchored default → 자기 active-workspace 가 아닌 다른 repo (GB/GD) 의 `.pen` 을 MCP 로 측정·편집 시도 시 **GT 측 file 이 반환·편집됨** (= 타 repo 오염 risk). 멀티-repo `.pen` 작업 경로 = `pencil-cli` skill §7.3 headless 의무.

3. **cross-verify = disk**: 멀티-repo `.pen` 검증 = `shasum -a 256` + 평문-JSON grep 단일. `get_editor_state` 측 검증 금지 (= active-workspace 따라 타 repo 반환). dual-sha = `.pen` shasum == `ui-spec.json` 측 `lastSyncedDesignToolStateHash`.

4. **버전업 마이그 ≠ `save()` 재직렬화**: cross-version schema 마이그 (= 예 2.11→2.13 · delta canonical = `pencil-pen-format-schema.md §1.1a`) 는 headless `pencil interactive -i/-o` 측 `save()` 로 불가. CLI (= 관측 0.2.6) 측 입력 `.pen` 을 **target schema 로 검증** → 입력 측 target-invalid (legacy) construct 잔존 시 load 실패 → `save()` 가 **0 byte** 출력 (= 실 file 파괴 risk). `save()` = **동일-version 재직렬화 한정** 안전. 버전업 = delta-aware 변환만 (= desktop app lenient auto-migrate semantic 재매핑 또는 전-delta surgical 평문-JSON 변환) · 마이그 전 pre-scan 의무 (= §1.1a delta 1~10 전수 · `pencil-cli` skill §7.3 rule 5). **마이그 후 post-check assert 의무** (= version `"2.13"` 선언·commit 전 모든 2.11-form construct grep = 0 · `json.load` 통과 = syntax-valid ≠ 2.13-schema-valid · ≠0 = inconsistent 2.13 · 본문 canonical = `pencil-cli` skill §7.3 rule 6).

> 본 §0.2 = 멀티-repo 운영 caveat pointer (= SSOT 6-rule 중 1·3·4 소관 · 번호 정합 유지 · 4 말미 post-check pointer 동반) · 나머지 2 (멀티-repo headless 필수) + 5 (pre-scan 전수) + 6 (post-check assert) 본문 canonical = `pencil-cli` skill §7.3 단일. 본문 복제 X.

---

# Part A — Official tools (현 9 · 구 12 중 3 제거 = Pencil v1.1.62)

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

token audit + migration 통합 paradigm = `batch_get` (= 위 pattern 검색) + `batch_design` (= §1.1 교체) 또는 headless 평문-JSON 경로 (`pencil-uiux-workflow.md §2.5` PRIMARY) default. (구 `search_all_unique_properties`/`replace_all_matching_properties` = Pencil v1.1.62 제거 · §0.1.)

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

## 2. Layout / Structure tools (1 · 구 2 중 find_empty_space_on_canvas 제거)

### 2.1 `snapshot_layout`

- 본질: document structure + computed bounds 산출
- 핵심 옵션: `problemsOnly=true` (issues 만 반환 · 본 패키지 권장 default) · `maxDepth=0` (top-level node bounds = 빈 영역 도출 · 구 `find_empty_space_on_canvas` 대체)
- export / screenshot 미수행 시 RCA-4 미해당 (F-1/F-2 검증 PASS · `pencil-automation.md` §12 정합)

### 2.2 `find_empty_space_on_canvas` — ⚠ REMOVED (Pencil v1.1.62)

- **제거 도구 · 호출 X** (= `ToolSearch query="pencil"` 측정 부재 · §0.1).
- 구 본질: 신규 요소 배치 가능한 empty region 산출 (placement audit).
- **대체**: `snapshot_layout(maxDepth=0)` 측 top-level node bounds 기반 빈 영역 판단.

---

## 3. Property manipulation (0 · 구 2 = Pencil v1.1.62 제거)

### 3.1 `search_all_unique_properties` — ⚠ REMOVED (Pencil v1.1.62)

- **제거 도구 · 호출 X** (= §0.1).
- 구 본질: node tree 안 unique property 재귀 검색 (token audit / hardcode hex 검출).
- **대체**: `batch_get` (= §1.2 pattern 검색) 또는 headless 평문-JSON 경로 (`pencil-uiux-workflow.md §2.5` PRIMARY).

### 3.2 `replace_all_matching_properties` — ⚠ REMOVED (Pencil v1.1.62)

- **제거 도구 · 호출 X** (= §0.1).
- 구 본질: node tree 안 matching property 재귀 교체 (token migration / design system v2 일괄 갱신).
- **대체**: `batch_design` (= §1.1) 또는 headless 평문-JSON 경로 (`pen_recolor.py` style · §2.5 PRIMARY).

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

# Part B — Package-verified extension (0 · 구 1 = Pencil v1.1.62 제거)

## 7. `open_document` — ⚠ REMOVED (Pencil v1.1.62)

- **제거 도구 · 호출 X** (= `ToolSearch query="pencil"` 측정 부재 · §0.1). 구 Part B (package-verified · 공식 doc 명시 X) 영역 폐기.
- 구 본질: 신규/기존 `.pen` 진입점 (`filePathOrTemplate="new"` literal 만 유효).
- **대체 (현 open/new 메커니즘)**:
  - PRIMARY = headless 평문-JSON 직접 read/write (`pencil-uiux-workflow.md §2.5` D7 · open 자체 불요) · 신규 doc = `pencil interactive -o <path>` (`pencil-cli` skill).
  - visual-verify alternative = `open -a Pencil <abspath>` (Bash) + active-doc MCP (`batch_design` / `batch_get`).

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

- 현 9 tool surface 변경 검출 (`ToolSearch query="pencil"` ≠ 9 종) → 본 SoT 갱신 cycle 진입 의무 (`MASTER-CLI-PENCIL-MCP-TOOLS-UPDATE-NNN` 패턴 · `cycle-discipline.md §13` 게이트 동기).
- 제거 4 종 (§0.1) 부활 검출 → 본 SoT + §13 게이트 재보정 cycle 진입.
- 신규 도구 발견 (예: 9 → N) → Part A 안 행 추가 + 본 cycle scope 외 별 trail.

---

## 11. 본 SoT 의 변경 정책

- cli infra 권장 byte-identical (6-repo · master + 5 자식)
- 변경 시 master cycle 신설 + 6-repo propagation (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## 12. 명시 cycle 이력

- 2026-05-19 · MASTER-CLI-PENCIL-OPTIMIZATION-001 · 본 SoT 신설 (12 official + 1 package-verified 분리 명시) + 5-repo byte-identical propagation
- 2026-06-10 · MASTER-CLI-PENCIL-TOOLSET-REMOVAL-STALE-SWEEP-001 · 도구 surface 13→9 정정 (Pencil v1.1.62 측 find_empty_space_on_canvas / search_all_unique_properties / replace_all_matching_properties / open_document 제거) — §0.1 제거 도구 표 + 대체 메커니즘 신설 · §2.2/§3.1/§3.2/§7 deprecated stub · header/count/§1.2.3/§10 STOP 정합 · 6-repo byte-identical propagation. PENCIL-SELFTEST-GATE-RECALIBRATE-001 (§13 게이트 9종) 후속.
- 2026-06-24 · MASTER-CLI-PENCIL-MULTIREPO-HEADLESS-001 · §0.2 멀티-repo workspace + cross-version 마이그 caveat 신설 (= rule 1 MCP single active workspace anchored[GT] → 타 repo `.pen` MCP 측정·편집 = 오염 risk · rule 3 cross-verify = disk shasum/평문-JSON · rule 4 버전업 ≠ `save()` 재직렬화[CLI 0.2.6 target-schema 검증 → legacy construct 시 0 byte 파괴]) · 멀티-repo 작업 + rule 2/5 본문 canonical = `pencil-cli` skill §7.3. pointer only (본문 복제 X · 도구 surface 9종 무변동 · add-only) · 6-repo byte-identical propagation. HOME-PEN-2.13 혼선 근본 mitigation.
- 2026-06-24 · MASTER-CLI-PENCIL-PRESCAN-EXHAUSTIVE-001 · §0.2 rule 4 말미 post-check pointer 1줄 추가 (= 마이그 후 version `"2.13"` 선언·commit 전 모든 2.11-form construct grep = 0 assert · `json.load` 통과 = syntax-valid ≠ schema-valid · 본문 canonical = `pencil-cli` skill §7.3 rule 6) + footer SSOT 5-rule→6-rule reconcile + rule 4 pre-scan 참조에 "§1.1a delta 1~10 전수" 명시. 본문 canonical (= rule 5 전수화 + rule 6 post-check) = `pencil-cli` skill §7.3 단일 · 본 §0.2 = pointer only (= 본문 복제 X · 도구 surface 9종 무변동 · add-only). 6-repo byte-identical propagation. ONBOARDING-2.13 GB onboarding.pen `thickness`×7 미flatten = inconsistent 2.13 재발 근본 mitigation.
