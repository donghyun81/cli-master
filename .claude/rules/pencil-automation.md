# Pencil Automation Rules

> **단일 목적**: Pencil .pen 저장 자동화 — 신규 doc 첫 저장 (Coin 1회 GUI 클릭 의무) + 기존 .pen 변경 저장 (agent 직접 호출 자동) 의 워크플로우.
> **분할 출처**: 기존 workflow.md (662 줄) §12 발췌 (line 451~501 · C2-RULES-RESTRUCTURE-001).
> **연관 파일**:
> - `pencil-uiux-workflow.md` (보호) — Pencil → Compose 본 작업 정책
> - `cycle-discipline.md` §13 — Claude Code 환경 정합 (2.1.114 pin)
> - `.claude/hooks/pencil-auto-save.sh` (v2 · master 채택) — 자동 호출 hook
> - `.claude/hooks/save-as-result-check.sh` (GD-only 흡수) — Save As 결과 검증
> SOT: `CLAUDE.md`

---

### 12) Pencil .pen 저장 자동화 (신규 doc 한계 인지 + agent 직접 호출)

**핵심 원칙**:
- **신규 .pen 첫 저장** = 사람 1회 클릭 필요 (macOS Save As 모달 다이얼로그)
- **기존 .pen 변경 저장** = agent 직접 호출로 자동 (Coin 손 작업 0)
- **headless mode 우회** = §13 (Pencil CLI headless reference) 활용 시 Save As 모달 자체 회피 가능. desktop app paradigm 과 분기 결정은 §13 표 참조.

**근거**: GB-PHASE-B-WORKFLOW-V12-REWRITE-AND-EXPAND-V3-001 (Cycle 8) 검증.
Pencil MCP `open_document` 로 신규 doc 생성 시 in-memory 만 형성. 첫 Cmd+S 시 macOS Save As 모달 다이얼로그 활성. 모달이 keyboard 입력을 가로채 자동 keystroke 차단. 우회 RCA cost 가 1회 사람 클릭보다 높음.

**신규 .pen 생성 워크플로우** (1회성 Coin 협조):
0. agent: 환경 검증 — Pencil 우측 하단 "Update Ready" 모달 활성 여부 확인. 활성 시 "Install on next launch" 클릭 의무 (Cmd+S keystroke 가로챔 회피). 근거: `PENCIL-UPDATE-MODAL-INTERCEPT-001` (CYCLE-PHASE-F-1-NEW-SCREEN-DEFINE-001 검증).
1. agent: `mcp__pencil__open_document(filePathOrTemplate="new")` — 빈 캔버스 생성 (path 명시 미지원 · "new" 리터럴만 유효)
2. agent: `mcp__pencil__batch_design` — **children inline 강제 + 25 op limit 시 분할 호출 patterns**:
   - X (flatten 발생): `root=I("document",{...}); child=I(root,{...})` (별 호출 추가한 patterns)
   - O (정상): `I("document",{children:[...]})` — 단일 호출에 inline
   - O (25 op 초과 시 분할 patterns 정착 · F-1/F-2 검증): frame insert 1 op + children 22-25 op = 첫 호출 / 추가 children = 후속 호출 (각 호출마다 children inline 강제). 분할 호출 추가한 patterns 도 RCA-4 미해당 (export/screenshot 미수행 시).
2-1. agent: `mcp__pencil__set_variables` — A-0_design-tokens inherit 적용 (color/typography 자동 inherit)
2-2. agent: `mcp__pencil__batch_design` — 6 영역 컴포넌트 모두 추가 (필요 시 분할 호출 · F-1/F-2 검증 patterns 차용)
2-3. agent: `mcp__pencil__snapshot_layout(problemsOnly=true)` — layout 문제 0건 확인 (export/screenshot 미수행 → RCA-4 미해당 · F-1/F-2 검증 PASS)
2-4. agent: `mcp__pencil__get_editor_state` — 6 영역 컴포넌트 모두 활성 확인
3. (이전 step 의 snapshot_layout / get_editor_state 가 viewport 활성화 + 컴포넌트 검증 통합 수행 — 별도 get_screenshot 호출 폐기 · F-1/F-2 검증 patterns)
4. agent: `bash .claude/hooks/pencil-auto-save.sh`
5. sleep 2
6. agent: `shasum -a 256 <screen>.pen` → 디스크 부재 (신규 doc Save As 모달 활성, 정상)
7. agent 멈춤 + Coin 안내: "신규 .pen `<screen>` Save As 다이얼로그 활성. path prefilled 확인 후 저장 클릭"
8. Coin: GUI 1회 클릭 → "done" 보고
9. agent: `shasum` 재검증 → PASS
10. agent: ui-spec.json 갱신 (visualSotPath / lastSyncedPencilStateHash / capturedAt)
11. agent: feat commit

**기존 .pen 변경 저장 워크플로우** (완전 자동):
1. agent: `mcp__pencil__batch_design` (변경)
2. agent: `bash .claude/hooks/pencil-auto-save.sh`
3. sleep 2
4. agent: `shasum` → sha 변경 = PASS
5. agent: ui-spec.json 갱신 + commit
→ Coin 손 작업 0

**SHA 형식 강제**: ui-spec.json 의 `lastSyncedPencilStateHash` = `.pen` 파일의 **64자 full SHA-256** (8자/12자 prefix 금지). 두 워크플로우 (신규/기존) 모두 동일.
근거: GB-GD-GT-SYNC-FULLHASH-FIX-001 (Cycle 15) 에서 prefix 저장 시 SYNC 검증이 substring match 로 false positive 발생 + collision 가능성 + Cycle 5/9 의 full sha 패턴과 충돌 사고.

**`.claude/settings.json` PostToolUse matcher 보존**: `mcp__pencil__batch_design` 매칭 미지원 확인 (Cycle 7-DEBUG, 0afbc77). claude code 의 향후 MCP hook 지원 시 자동 활성 위해 보존. 현 시점 작동은 agent 명시 호출이 담당.

**권한**: macOS Accessibility 1회 승인 (sunk cost, Cycle 7).

**fallback**: agent 워크플로우 실패 시 Coin GUI Cmd+S (B-4.1 절차 · pencil-uiux-workflow.md §4.1).

3-repo propagation 정책: settings.json + hook + 본 §12 모두 3-repo byte-identical 권장. F-1/F-2 검증 patterns (CYCLE-PHASE-F-1-NEW-SCREEN-DEFINE-001 + CYCLE-PHASE-F-2-NEW-SCREEN-DEFINE-001) 통계 기반 §12 갱신 명시됨 (`CYCLE-WORKFLOW-V12-REVISION-001` · 2026-05-01).

**WORKFLOW-V12-OVERCONSERVATIVE-001 별 trail close**: F-1+F-2 = 2 cycle 우회 patterns 검증 PASS · 본 §12 갱신 cycle 마감 시 close.

---

### 13) Pencil CLI headless mode 분기 (`pencil-cli-headless.md` 단일 SoT)

본 §13 = `pencil-cli-headless.md` 본문 인용 pointer. 상세 절차 (`@pencil.dev/cli` 설치 / `pencil interactive` shell / batch tasks.json / save() 호출 / 모델 선택 / CI/CD 통합 등) = 단일 SoT 참조 의무.

§12 desktop app paradigm 측 신규 `.pen` 첫 저장 시 Save As 모달 활성 한계는 macOS Pencil app 한정 사고. `pencil interactive -o <screen>.pen` 또는 `pencil --in <in>.pen --out <out>.pen --prompt "..."` 호출은 headless 환경 안에서 직접 `save()` 발행 → Save As 다이얼로그 자체 미발생. Coin GUI 클릭 의무 0.

**desktop vs headless 분기 표**:

| 사용 시점 | 권장 paradigm | 근거 |
|---|---|---|
| Coin 본인 측 design 실시간 검증 의무 (Pencil app viewport 시각 확인) | **desktop app** (현 §12 흐름) | 사용자 본인 측 의도 직접 측정 |
| batch cycle 측 다중 화면 일괄 신설 (예: feature 진입 시 5~10 screen 한꺼번에) | **headless mode** (§13 / `pencil-cli-headless.md` §5 tasks.json) | Coin GUI 손 작업 0 + CI/CD 통합 가능 |
| 단일 screen 신설 + 시각 검증 의무 X | desktop (default) 또는 headless (자동화 필요 시) | Coin 결정 자율 영역 |
| CI/CD 측 nightly design refresh / drift 정정 자동 | **headless mode** | scheduled 자동화 진입점 |

**공식 doc reference**:
- [Pencil CLI 명세](https://docs.pencil.dev/for-developers/pencil-cli)
- 본 패키지 측 단일 SoT = [`pencil-cli-headless.md`](./pencil-cli-headless.md)

