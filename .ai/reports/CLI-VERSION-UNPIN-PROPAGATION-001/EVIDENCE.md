# EVIDENCE — CLI-VERSION-UNPIN-PROPAGATION-001

## Requirements Source

- 본 turn 사용자 prompt = "다중 repo cycle · Gently 4-repo cli infra propagation · Proto 3-repo 무접촉" + 새 본문 5 핵심 요소 + STOP 조건 + 산출물 의무 명시.
- 직전 cycle `CLAUDE-CODE-VERSION-UNPIN-VERIFY-001` (commit `7978638`) 산출물 4종 (.ai/reports/CLAUDE-CODE-VERSION-UNPIN-VERIFY-001/{PLAN,EVIDENCE,VERIFY,REVIEW}.md).
- master CLAUDE.md §16 본 SoT 변경 의무 절차 (§15 표 row append + protected-file-hashes.md baseline append).

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | ops-layer · cli infra propagation |
| Reading Mode | CLI 운영 레이어형 |
| Requirement Source | 사용자 turn 본문 + 직전 cycle 산출물 |
| Info Gap | RESOLVABLE_IN_REPO (모두 disk + 환경 안 직접 검증 가능) |
| STOP Risk | 4-repo byte-identical 깨짐 / env 차단 해제 / Proto 3-repo 접촉 / 보호 파일 5종 sha 변동 — 본 cycle 안 모두 회피 |
| Read-Only Fan-Out | N/A (cli infra ops-layer task · subagent 호출 X) |
| Implementer Entry | Allowed (intake normalization + pre-EVIDENCE 계약 모두 본 EVIDENCE 안 박음) |

## Pre-EVIDENCE Contract

- Read evidence: cycle-discipline.md §13 line 127~176 영역 본문 + .auto-memory/incident-log.md 안 CLAUDE-CODE-VERSION-UNPIN-VERIFY-001 entry + protected-file-hashes.md "Recent updates" 형식 + CLAUDE.md §15 표 형식 모두 read-only 검증 PASS.
- Remaining gaps: 0 (모든 산출물 위치 / 별 trail 위치 / §13 line 영역 모두 확정).
- Chosen path: §13 line 132+ 단락 영역 단일 Edit (old_string ↔ new_string · 5 핵심 요소 반영) + 자식 3-repo cp + 산출물 4종 + 별 trail 2 종 + protected-file-hashes.md append + CLAUDE.md §15 row append + 4 commit.
- Hold / Stop reasons: 없음 (baseline 정정 후 진행 결정 사용자 A 채택).
- Implement entry conditions: 모두 충족.

## Collect Results

### baseline 4 항목 (사전 검증 의무 §20)

| 항목 | 결과 |
|---|---|
| HEAD cli-master | `9487f16b4ea75cf779d5b675b6e1b09cacca9e15` ✓ baseline 일치 |
| HEAD GentlyBreath | `219a2245be36034ed1668d6f8e364e21fe871f21` (baseline 0552529 + drift 2 commit · Sentry/Firebase SDK 통합 · cli infra 무관) — 사용자 A 채택 baseline 갱신 |
| HEAD GentlyDay | `ffd82656078f7d6e13e6a0b764a137ca39f8bae3` (baseline 4d867cc + drift 2 commit · 동일 패턴) — 사용자 A 채택 baseline 갱신 |
| HEAD GentlyTable | `e8bca80c207158cd534ad2c76a44f359ed23f286` (baseline d90c19e + drift 2 commit · 동일 패턴) — 사용자 A 채택 baseline 갱신 |
| 4-repo cli infra sha 직전 | 모두 `4cd01b4eca11feeec8e67619df87c7cbed3d9913` ✓ (본 cycle 진입 baseline 일치) |

### self-test 3 항목 실측 (cycle 진입 첫 행동)

```
=== self-test 1: claude --version ===
2.1.121 (Claude Code)

=== self-test 2: claude mcp list ===
Checking MCP server health…

claude.ai Google Drive: https://drivemcp.googleapis.com/mcp/v1 - ! Needs authentication
claude.ai Gmail: https://gmailmcp.googleapis.com/mcp/v1 - ! Needs authentication
claude.ai Google Calendar: https://calendarmcp.googleapis.com/mcp/v1 - ! Needs authentication
pencil: /Applications/Pencil.app/Contents/Resources/app.asar.unpacked/out/mcp-server-darwin-arm64 --app desktop - ✓ Connected
```

self-test 3: ToolSearch query="+pencil mcp" max_results=15 = 13 mcp__pencil__* tools (verbatim 명단):

1. mcp__pencil__batch_design
2. mcp__pencil__batch_get
3. mcp__pencil__export_nodes
4. mcp__pencil__find_empty_space_on_canvas
5. mcp__pencil__get_editor_state
6. mcp__pencil__get_guidelines
7. mcp__pencil__get_screenshot
8. mcp__pencil__get_variables
9. mcp__pencil__open_document
10. mcp__pencil__replace_all_matching_properties
11. mcp__pencil__search_all_unique_properties
12. mcp__pencil__set_variables
13. mcp__pencil__snapshot_layout

→ 3 항목 모두 PASS ✓ (cycle 진행 가능 baseline).

### cp + cross-verify raw output

```
new master cycle-discipline.md sha: 0e4a7d01997c0d12ddb432d14ee37cdb1c4f1bbc

GentlyBreath cycle-discipline.md sha: 0e4a7d01997c0d12ddb432d14ee37cdb1c4f1bbc
  ✓ byte-identical
GentlyDay cycle-discipline.md sha: 0e4a7d01997c0d12ddb432d14ee37cdb1c4f1bbc
  ✓ byte-identical
GentlyTable cycle-discipline.md sha: 0e4a7d01997c0d12ddb432d14ee37cdb1c4f1bbc
  ✓ byte-identical
```

### 0 Matches (부재 증거)

- Proto 3-repo (ProtoGentlyBreath / ProtoGentlyDay / ProtoGentlyTable) cycle-discipline.md 무접촉 (본 cycle scope X · 별 cycle 책임).
- 보호 파일 5종 (`ui-spec.schema.json` · `pencil-uiux-workflow.md` · `pencil-sot-policy.md` · `uiux-sot-refresh.md` · `design-sot-policy.md`) 무접촉.
- `.mcp.json` / `settings.json` / `agents/active` / `workflow-core.md` / `code-principles.md` / `safety-and-secrets.md` / `auth-rules.md` / `ux-laws.md` / `design-to-code-sync.md` 무접촉.
- env 차단 (DISABLE_AUTOUPDATER + DISABLE_UPDATES) 해제 X (본 정책 default 유지).

## Key Findings

- 직전 #51736 회귀 본질 fix = changelog 안 v2.1.122 line "ToolSearch missing post-startup MCP tools in nonblocking mode". 2.1.121 환경 안 회귀 해소 실측 PASS (3 항목 모두).
- pin 폐기 정책 채택 = "문제 해결 = pin 폐기 + 최신 추격" (사용자 본심).
- 본 cycle = `CLAUDE-CODE-VERSION-PIN-2.1.114-001` 별 trail 실 close 영역 + `CLAUDE-CODE-LATEST-CHASE-001` 신설 open 영역.

## Cleanup Assessment

N/A (ops-layer task · 제품 코드 미변경)
