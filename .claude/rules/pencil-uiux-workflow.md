# Pencil UI/UX Workflow — 도구 바인딩 (Pencil 전용)

> **단일 목적**: Pencil 도구 (Pencil.dev 캔버스 + .pen 파일) 의 구체 절차 + macOS 자동화 + MCP tool 호출 patterns.
> **C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 분리**: 도구 무관 70% (Path B / 5-type / Output Checklist / STOP / Refresh) 는 `design-to-code-sync.md` 로 분리.
> **본 파일 = 보호 (강제 byte-identical)**. 자식 repo 가 Pencil 사용 시 의무 적용.
> **연관 파일**:
> - `design-to-code-sync.md` — 도구 무관 일반 패턴 (5-type 분류 / Output Checklist P1-P9 / STOP)
> - `design-sot-policy.md` (보호) — dual-layer SoT 정책 (도구 무관)
> - `design-sot-refresh.md` (보호) — refresh trigger 분류 (도구 무관)
> - `pencil-automation.md` — Pencil .pen 자동화 절차
> - `pencil-sot-binding.md` (보호) — Pencil ↔ ui-spec.json 도구 바인딩
> - `.claude/hooks/pencil-auto-save.sh` (v2) + `.claude/hooks/save-as-result-check.sh`
> SOT: `CLAUDE.md`

---

## 1. 전제 (Pencil 공식 근거)

- Pencil.dev = macOS 캔버스 디자인 도구 + .pen 파일 형식
- Pencil MCP server (stdio) = `mcp__pencil__*` tools = **12 official** (pencil.dev 공식 doc 2026-04-03 기준) + **1 package-verified** (`open_document` · 공식 doc 명시 X / 본 패키지 검증된 영역 · §FREEDOM)
- 도구 list 전체 단일 SoT = `pencil-mcp-tools-reference.md` (본 file 내 도구 목록 중복 금지)
- 본 cycle (`MASTER-CLI-PENCIL-OPTIMIZATION-001` · 2026-05-19) 안 명시적 추가 5 종 = `search_all_unique_properties` / `replace_all_matching_properties` / `find_empty_space_on_canvas` / `get_guidelines` / `export_nodes` (각 도구 본문 = 참조 file)
- Claude Code 2.1.114 pin 의무 (`cycle-discipline.md` §13 명시됨 · 2.1.116+ 회귀로 본 작업 차단)

## 2. Pencil 도구 바인딩 매핑

`design-to-code-sync.md` §1 의 dual-layer SoT 의 Pencil 구체화:
- Visual SoT 파일 형식 = `.pen`
- Visual SoT 디렉터리 = `docs/design/pencil-sot/<screen>/<screen>.pen`
- Structural SoT 디렉터리 = `docs/design/pencil-sot/<screen>/<screen>.ui-spec.json`
- preview.png 디렉터리 = `docs/design/pencil-sot/<screen>/preview.<theme>.png`

## 3. 5-type IMPL 흐름 (Pencil 도구 호출 구체화)

### Type 1: drift 정정 (Path 2-A 표준)
1. `mcp__pencil__open_document(filePathOrTemplate=<.pen 절대경로>)` — 기존 .pen 열기
2. `mcp__pencil__batch_design(...)` — 변경 적용 (children inline · 25 op limit)
3. `bash .claude/hooks/pencil-auto-save.sh` — Cmd+S 자동
4. `sleep 2`
5. `shasum -a 256 <screen>.pen` → sha 갱신
6. ui-spec.json 의 `lastSyncedDesignToolStateHash` 갱신 (full 64자)
7. Compose 코드 IMPL
8. P1~P9 Output Checklist (`design-to-code-sync.md` §4)

### Type 2: SoT 신설 (신규 .pen)
1. **환경 검증** — Pencil 우측 하단 "Update Ready" 모달 활성 여부 확인. 활성 시 "Install on next launch" 클릭 의무 (`workflow-core.md` §implement Step 0).
2. `mcp__pencil__open_document(filePathOrTemplate="new")` — 빈 캔버스
3. `mcp__pencil__batch_design(children=[...inline...])` — 25 op limit + 분할 호출 patterns (F-1/F-2 검증)
4. `mcp__pencil__set_variables` — A-0_design-tokens inherit
5. `mcp__pencil__snapshot_layout(problemsOnly=true)` — layout 문제 0건 확인
6. `mcp__pencil__get_editor_state` — 컴포넌트 활성 확인
7. `bash .claude/hooks/pencil-auto-save.sh <screen>` (v2 = filename 인자 전달)
8. `sleep 2` → `shasum` → 디스크 부재 (Save As 모달 활성)
9. **Coin 1 회 GUI 클릭** (Save As 모달 path prefilled 확인 후 저장)
10. `shasum` 재검증 → ui-spec.json 갱신 → commit

### Type 3: Phase R (역공학)
1. preview.png 분석 + Compose 코드 분석으로 [CURRENT] 추정
2. `mcp__pencil__open_document(filePathOrTemplate="new")` + 추정 frame 추가
3. ui-spec.json `lifecycle: reverse-engineered` 명시 + Coin 명시 승인 의무
4. 이후 Type 1 흐름 적용

### Type 4: 초기 신설 (bulk)
- 모든 화면 일괄 Type 2 적용 + sub-batch 분할 (5~10 화면 단위)

### Type 5: 일괄 갱신 (디자인 시스템)
- A-0_design-tokens 변경 + `mcp__pencil__set_variables` 호출
- inherit 적용 화면 모두 자동 반영 + Type 1 흐름 적용

---

## 4. Pencil 측 금지 (리뷰 블로커)

- `mcp__pencil__batch_design` 호출 시 children 별도 호출 (flatten 발생) — 반드시 inline
- `pencilFrameCode` 의 spec id 와 캔버스 내부 id 동일 가정 (Stage 1B 명시된 사고 — 캔버스 id 자체 생성)
- 25 op 초과 시 분할 안 함 — 첫 호출 24 op + 후속 호출 patterns

---

## 5. STOP 조건 (Pencil 도구 한정)

- ToolSearch query="pencil" empty (= MCP discovery 회귀 · `cycle-discipline.md` §13)
- Save As 모달 keystroke 차단 + filename 자동 입력 실패 → Coin GUI 손 작업 fallback
- `mcp__pencil__open_document(filePathOrTemplate=<path>)` 가 path 명시 미지원 (= "new" 리터럴만)

도구 무관 STOP = `design-to-code-sync.md` §5 명시됨.

---

## 6. 환경 의존성

- macOS 만 (Pencil = macOS-only 도구)
- Claude Code 2.1.114 pin (`cycle-discipline.md` §13)
- Accessibility 권한 (Cmd+S keystroke 자동 · sunk cost · Cycle 7)
- Pencil app 활성 + Update Ready 모달 미활성

---

## 7. 본 파일의 변경 정책

본 파일 = **보호 (강제 byte-identical)** + cli infra 권장 byte-identical 의 상위.
변경 시:
1. master 에서 cycle 신설 (절대 자식 repo 직접 수정 금지)
2. `protected-file-hashes.md` 새 sha baseline
3. commit body `[Sha]` 새 sha 명시
4. propagation 즉시 (lazy 금지)

---

## 8. 공식 근거 인용

- Pencil .dev 공식 문서: design tool 의 in-memory + Save As 모달 patterns
- macOS Accessibility API: System Events osascript keystroke
- Claude Code MCP stdio binding: `anthropics/claude-code` GitHub

---

## 9. Pencil CLI binding (headless mode 진입점)

Pencil 측 작업은 desktop app stdio (= 본 file §3 Type 1~5) 외에 별도 headless 진입점이 존재. SoT = [`pencil-cli-headless.md`](./pencil-cli-headless.md).

### 9.1 desktop app vs CLI headless 선택 기준

| 시나리오 | 권장 binding |
|---|---|
| Coin 본인 측 design 실시간 시각 검증 의무 | desktop app (§3 흐름) |
| batch 다중 screen 일괄 신설 (5+ screen 한 cycle) | CLI headless (`pencil interactive` / `pencil --tasks tasks.json`) |
| Save As 모달 회피 의무 (Coin 클릭 0) | CLI headless (`save()` 직접 호출) |
| CI/CD scheduled design refresh | CLI headless |
| 단일 screen + 시각 검증 X | 둘 다 가능 (Coin 자율) |

### 9.2 호출 paradigm

CLI headless 환경 안에서 `mcp__pencil__*` namespace 와 동일한 tool surface 가 shell 명령으로 노출. 예: `batch_design({ ... })`. 상세 = `pencil-cli-headless.md` §4 + §6 (`save()` 호출).

### 9.3 STOP 조건

- Node.js < 18 → headless mode 미지원 → desktop app fallback
- `PENCIL_CLI_KEY` 부재 + `pencil login` 미실행 → 인증 실패 → STOP
- `pencil status` FAIL → headless 진입 차단 → desktop app fallback

### 9.4 Recolor sub-flow (= gray-trap → brand 결정론 remap · headless 경로)

자식 `.pen` 이 foundation Neutral 색을 capture 한 gray-trap 을 활성 자식 brand colorScheme 으로 결정론 remap 하는 경로. 본문 단일 SoT = [`.claude/skills/pencil-recolor/SKILL.md`](../skills/pencil-recolor/SKILL.md). `.pen` = plain JSON (`version: "2.11"`) 직접 read/write — Pencil app / MCP tool 불요 (= `pen_recolor.py` 측 `json.load`).

#### 9.4.1 진입 조건

| 조건 | 본질 |
|---|---|
| 활성 자식 `<Repo>Theme.kt` 측 full colorScheme 존재 | `lightColorScheme(role = ValName, ...)` block + `val ValName = Color(0xFFRRGGBB)` parse 가능 (= role→hex resolve table) |
| 대상 `.pen` 측 foundation Neutral hex 잔존 | gray-trap 상태 (= 자식 brand identity 미반영) |
| 색만 교체 의무 | 구조 / 좌표 / 텍스트 무변경 (= §3 Type 1 drift 정정 sub-case 정합) |

#### 9.4.2 호출 paradigm

```bash
python3 .claude/skills/pencil-recolor/pen_recolor.py \
  --pen  docs/design/pencil-sot/<screen>/<screen>.pen \
  --theme <repo>/.../shared/ui/theme/<Repo>Theme.kt \
  --out  docs/design/pencil-sot/<screen>/<screen>.pen
```

generator 가 출력 후 모든 fill / stroke 를 4 bucket 으로 분류 (= TRUE LEAK / role-gap / off-token / active). **TRUE LEAK ≠ 0 = FAIL (exit 2) + 즉시 STOP** (= remap 누락 신호 · fingerprint dict 재측정 의무). role-gap + off-token = WARN (PASS).

#### 9.4.3 dual-layer sha sync (= 후속 step · §3 Type 1 step 5~6 정합)

```bash
NEW_SHA=$(shasum -a 256 docs/design/pencil-sot/<screen>/<screen>.pen | cut -d' ' -f1)
# <screen>.ui-spec.json 의 lastSyncedDesignToolStateHash = $NEW_SHA (full 64자) 갱신
```

`design-to-code-sync.md` §4 Output Checklist P1~P3 정합 (= Visual SoT sha 갱신 + ui-spec.json full 64자 sha + 두 SoT sha 일치).

#### 9.4.4 STOP 조건 (recolor 한정)

- TRUE LEAK ≠ 0 → 즉시 STOP + `FOUNDATION_NEUTRAL` fingerprint dict 재측정
- generator 가 색 외 구조 / 좌표 / 텍스트 변경 징후 → STOP (= scope expansion)
- `.pen` json.load FAIL (= encryption / 비-JSON) → STOP + MCP tool 경로 (`pencil-cli` skill) 재평가
