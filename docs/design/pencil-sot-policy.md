# Pencil SoT Binding (도구 바인딩 · Pencil 전용)

> **단일 목적**: Pencil 도구 바인딩 — Pencil.dev 캔버스 + .pen 파일 의 도구별 구체 절차.
> **C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 분리**: 도구 무관 75% (SoT 계층 / lifecycle / 라벨 / Phase R / drift / LOCKED / STOP) 는 `design-sot-policy.md` 로 분리.
> **본 파일 = 보호 (강제 byte-identical)**.
> **파일명 변경 의무 (C2.5)**: 의미적으로 `pencil-sot-binding.md` 이지만 sandbox rm 권한 한계로 파일명 `pencil-sot-policy.md` 유지 (Coin mv 손 작업 분리).
> **연관 파일**:
> - `design-sot-policy.md` (보호 · 도구 무관 75%) — SoT 계층 / lifecycle / 라벨 / Phase R / drift / LOCKED / STOP
> - `pencil-uiux-workflow.md` (보호 · Pencil 도구 바인딩 30%)
> - `pencil-automation.md` — Pencil .pen 자동화 절차
> - `docs/schemas/ui-spec.schema.json` — 기계 스키마 (도구 무관 필드명)
> SOT: `CLAUDE.md`

---

## 1. Pencil 도구 바인딩 매핑

`design-sot-policy.md` §1 의 도구 무관 SoT 계층의 Pencil 구체화:

| 계층 | Pencil 구체 |
|---|---|
| 1a Structural SoT | `docs/design/pencil-sot/<screen>.ui-spec.json` |
| 1b Visual SoT | `docs/design/pencil-sot/<screen>.pen` (Pencil 캔버스 파일) |
| 2 텍스트 계약 | `docs/design/pencil-dev-prompt.md` |
| 3 토큰 export | `docs/design/pencil-exports/<screen>/pencil-vars-after.json` |
| 3a 토큰 diff | `docs/design/pencil-exports/<screen>/pencil-vars-before.json` |
| 4 검수 PNG | `docs/design/pencil-sot/<screen>.preview.{light,dark}.png` |

`<visual-ext>` = `.pen` (Pencil 전용).
`<design-tool>` = `pencil`.

---

## 2. 1a ↔ 1b 동기화 — Pencil 구체 (`design-sot-policy.md` §1.1 구체화)

### Pencil MCP tools (stdio)

| ops | Pencil MCP tool |
|---|---|
| 1b 캔버스 열기 | `mcp__pencil__open_document(filePathOrTemplate=<.pen 절대경로 \| "new">)` |
| 1b 캔버스 편집 | `mcp__pencil__batch_design(...)` (children inline · 25 op limit) |
| 1b → 1a 복원 | `mcp__pencil__batch_get(...)` |
| 1b layout 검증 | `mcp__pencil__snapshot_layout(problemsOnly=true)` |
| 1b 상태 조회 | `mcp__pencil__get_editor_state` |
| 1b 토큰 변수 | `mcp__pencil__set_variables` (A-0_design-tokens inherit) |
| 1b export PNG | `mcp__pencil__export_nodes` 또는 Coin GUI |
| 1b 저장 | `bash .claude/hooks/pencil-auto-save.sh [filename]` (v2) |

### sha 갱신 명령

```bash
shasum -a 256 docs/design/pencil-sot/<screen>.pen | awk '{print $1}'
# → 64 자 full sha → ui-spec.json 의 lastSyncedDesignToolStateHash 갱신
```

### Path B fallback (Coin GUI · `design-sot-policy.md` §1.1 도구별 구체)

1. Coin 이 Pencil GUI 에서 .pen 직접 편집 + Cmd+S
2. agent: `mcp__pencil__batch_get` 으로 캔버스 상태 read
3. agent: ui-spec.json 재생성 + `capturedAt` + `lastSyncedDesignToolStateHash` 갱신
4. 재검증 (= P1~P3 dual-layer sha 대조 · `design-to-code-sync.md` §4 · 구 compound-lint 재검증 = deprecated · 도구 부재 · MASTER-CLI-COMPOUND-LINT-DEPRECATE-001)

---

## 3. legacy artifact (Pencil 한정)

- `meta.json` (구 patterns) = legacy. 신규 작성 금지.
- 마이그레이션: `pencil-vars-after.json` 으로 흡수 + Coin 수동 rm

---

## 4. Pencil 한정 STOP (도구 의존)

`design-sot-policy.md` §8 도구 무관 STOP 외 추가:

- ToolSearch query="pencil" empty (= MCP discovery 회귀 · `cycle-discipline.md` §13)
- `mcp__pencil__open_document(filePathOrTemplate=<path>)` 가 path 명시 미지원 → "new" 리터럴만 사용
- Pencil app Update Ready 모달 활성 → Cmd+S keystroke 차단 위험 (Step 0 환경 검증 의무 · `pencil-uiux-workflow.md`)
- macOS Save As 모달 keystroke 차단 + filename 자동 입력 실패 → Coin GUI fallback

---

## 5. 향후 Figma / Sketch 도입 시

별 바인딩 파일 신설 patterns:
- `figma-sot-binding.md` (보호 · Figma 전용)
- `sketch-sot-binding.md` (보호 · Sketch 전용)

각 바인딩 파일 = 본 파일과 동일 구조 (1~4 섹션) + 도구별 MCP / 자동화 / STOP 박음.

`design-sot-policy.md` (도구 무관) + `design-to-code-sync.md` (5-type 분류) = 그대로 재사용.
