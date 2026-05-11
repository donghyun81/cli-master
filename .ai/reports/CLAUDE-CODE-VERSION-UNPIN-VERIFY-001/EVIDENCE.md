# EVIDENCE — CLAUDE-CODE-VERSION-UNPIN-VERIFY-001

## Requirements Source
- 본 chat 직접 prompt (Coin · 2026-05-11 KST)
- Authority boundary: cli-master 한정 · propagation 자체 금지 (별 cycle 책임)
- Requirement chain: PASS 4 항목 전부 통과 의무 → CLAUDE-CODE-VERSION-PIN-2.1.114-001 close 트리거 게이트

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | ops-layer · verification-only |
| Reading Mode | CLI 운영 레이어형 |
| Requirement Source | 본 chat 직접 prompt (충족) |
| Info Gap | RESOLVABLE_IN_REPO (실측 명령 4종 모두 가능) |
| STOP Risk | None (read-only · cli infra 무변경) |
| Read-Only Fan-Out | N/A |
| Implementer Entry | N/A (verification-only) |

## Pre-EVIDENCE Contract
- Read evidence: cycle-discipline.md §13 (2.1.114 pin 정책) + CLAUDE.md §15 cycle 이력
- Remaining gaps: 없음 (4 PASS criteria 모두 실측 가능)
- Chosen path: 4 실측 명령 순차 실행 → 산출물 5종 작성
- Hold / Stop reasons: 없음
- Implement entry conditions: N/A (verification-only)

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경)

## Baseline 실측 (사전 검증)

### git HEAD
```
b1b8ca552d48b9d676086204e62497be03f84115
```
- anchor 74d9ee5 이후 1 commit 추가: `b1b8ca5 chore(ops): MASTER-REPO-CONFIG-SOT-001 add repo-config.sh single SoT + drift mitigation`
- anchor mismatch 영향: 본 cycle 산출물 작성에 무영향 (Coin 측 staged change `scripts/repo-config.sh` 등 사전 commit 완료된 상태).

### 보호/cli-infra sha (anchor 일치)
```
.claude/rules/cycle-discipline.md = 4cd01b4eca11feeec8e67619df87c7cbed3d9913 (anchor 일치 ✓)
.claude/settings.json            = 66ed75bf89cff52d91731eaf4c5b871326a0382b (anchor 일치 ✓)
```

## PASS Criteria 4 항목 실측 결과 (verbatim)

### Criteria 1: claude --version = 2.1.121
실행 명령:
```bash
claude --version
```
Raw stdout:
```
2.1.121 (Claude Code)
```
Exit code: 0
판정: **PASS** (anchor 명시값 2.1.121 일치)

---

### Criteria 2: claude mcp list = "pencil ✓ Connected"
실행 명령:
```bash
claude mcp list
```
Raw stdout:
```
Checking MCP server health…

claude.ai Google Drive: https://drivemcp.googleapis.com/mcp/v1 - ! Needs authentication
claude.ai Gmail: https://gmailmcp.googleapis.com/mcp/v1 - ! Needs authentication
claude.ai Google Calendar: https://calendarmcp.googleapis.com/mcp/v1 - ! Needs authentication
pencil: /Applications/Pencil.app/Contents/Resources/app.asar.unpacked/out/mcp-server-darwin-arm64 --app desktop - ✓ Connected
```
Exit code: 0
판정: **PASS** ("pencil ... ✓ Connected" 명시 확인)

---

### Criteria 3: ToolSearch query="pencil" 결과 ≥ 13 tools (mcp__pencil__* prefix)
실행 명령 (본 CLI 세션 내):
```
ToolSearch(query="pencil", max_results=20)
```

반환된 13 tools verbatim 명단 (mcp__pencil__* prefix 전수):

| # | Tool 명 | 명단 일치 |
|---|---|---|
| 1 | `mcp__pencil__batch_design` | ✓ |
| 2 | `mcp__pencil__batch_get` | ✓ |
| 3 | `mcp__pencil__export_nodes` | ✓ |
| 4 | `mcp__pencil__find_empty_space_on_canvas` | ✓ |
| 5 | `mcp__pencil__get_editor_state` | ✓ |
| 6 | `mcp__pencil__get_guidelines` | ✓ |
| 7 | `mcp__pencil__get_screenshot` | ✓ |
| 8 | `mcp__pencil__get_variables` | ✓ |
| 9 | `mcp__pencil__open_document` | ✓ |
| 10 | `mcp__pencil__replace_all_matching_properties` | ✓ |
| 11 | `mcp__pencil__search_all_unique_properties` | ✓ |
| 12 | `mcp__pencil__set_variables` | ✓ |
| 13 | `mcp__pencil__snapshot_layout` | ✓ |

Count: **13** (anchor 명시 명단 13 와 정확히 일치)
판정: **PASS** (≥ 13 충족 + 13 tool 명단 verbatim 일치)

---

### Criteria 4: mcp__pencil__get_editor_state 실호출 성공
실행:
```
mcp__pencil__get_editor_state(include_schema=false)
```

Raw response (일부 발췌):
```
## Currently active editor
- `/Users/yundonghyeon/AndroidStudioProjects/GentlyTable/docs/design/pencil-sot/daily-prescription/daily-prescription.pen`

## Document State:
- No nodes are selected.

### Top-Level Nodes (4):
- `bi8Au` (frame): daily-prescription-INPUT [user visible]
- `E0aew` (frame): daily-prescription-RESULT [user visible]
- `C5epUP` (frame): daily-prescription-INPUT-FINAL [user visible]
- `NkanY` (frame): daily-prescription-RESULT-FINAL [user visible]

### Reusable Components (0):
- No reusable components found.
```

판정: **PASS** (구조화 response 정상 반환 · 활성 editor + 4 top-level nodes 확인 + InputValidationError / TIMEOUT / discovery failure 없음)

---

## Collect Results

### 매칭 파일/패턴
- `.claude/rules/cycle-discipline.md` §13 line 132+ — 2.1.114 pin 정책 ("2.1.116 이상 = stdio MCP tool discovery 회귀 (#51736)")
- `CLAUDE.md` §15 — `C9-GIT-LOCK-PID-VERIFY-001` ~ `C11-LOCK-WIDE-COVERAGE-001` 등 환경 정합 cycle 누적
- `.auto-memory/incident-log.md` — `CLAUDE-CODE-2.1.116-MCP-DISCOVERY-REGRESSION-001` 등 #51736 관련 누적 trail (15741 bytes)

### 0 Matches (부재 증거)
- 본 cycle 안 `.mcp.json` / `.claude/rules/` / `.claude/settings.json` 변경 일체 없음 (verification-only · STOP 조건 준수).

## Key Findings
- **2.1.121 에서 stdio MCP tool discovery 회귀 (#51736) 해소 확인**. PASS 4/4.
- pencil MCP server (Pencil.app native binary) `--app desktop` 모드 정상 Connected + 13 tool 전수 discovery + 실호출 성공.
- pin 정책 (`cycle-discipline.md` §13) 의 "2.1.114 의무" 영역은 본 cycle 결과를 근거로 **별 cycle 에서 unpin 가능** (본 cycle 자체는 §13 수정 금지).
