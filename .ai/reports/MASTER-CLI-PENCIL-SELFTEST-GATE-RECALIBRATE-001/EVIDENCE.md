# EVIDENCE — MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-001

## Requirements Source
- paste source: `/Users/yundonghyeon/AndroidStudioProjects/cc-paste-MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-001.md`
- Authority boundary: M5 cli-infra-ops · §13 self-test 게이트 단일 재보정 · 광역 pencil stale = 별 cycle (무접촉)

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (cli infra) |
| Reading Mode | 6. CLI 운영 레이어형 (cli-ops · M5) |
| Requirement Source | paste source 충족 |
| Info Gap | RESOLVABLE_IN_REPO |
| STOP Risk | 보호 5 sha drift / 9 종 mismatch / 자식 sha 불일치 |
| Read-Only Fan-Out | N/A (단일 cli session · sub-agent 불요) |
| Implementer Entry | Allowed (M5 직접 프롬프트) |

## Pre-EVIDENCE Contract
- Read evidence: cycle-discipline.md §13 (line 158-166) · incident-log.md tail · CLAUDE.md §15 table
- Chosen path: §13 item 3 게이트 = 단순 ≥13 카운트 → 9 종 named-set 전수 존재 판정 재보정
- Hold/Stop reasons: 9 종 ≠ 측정 / 보호 file 편집 충동 / 보호 sha drift
- Implement entry conditions: HEAD baseline 정합 + self-test 측정 PASS

## Collect Results (Step 0 self-test — 게이트 self-exception 적용)
### baseline anchor (A1)
- HEAD 진입 재측정: `424644084dcc86bb95c104ac845e95774d8a063e` — cowork 측정값과 일치 (drift 0)

### self-test 3 항목
1. `claude --version` → `2.1.156 (Claude Code)` — 본 cycle 버전 무관 (Issue A 독립)
2. `claude mcp list | grep pencil` → `pencil: ... --agent claudeCodeCLI - ✓ Connected` (+ user/project 중복 scope warning · 본 cycle scope 외)
3. `ToolSearch query="pencil"` → **9 종 verbatim** (`mcp__pencil__*` prefix):
   - batch_design / batch_get / export_nodes / get_editor_state / get_guidelines / get_screenshot / get_variables / set_variables / snapshot_layout
   - = §3 named-set 정확 일치 (정렬 후 동일) · 추가/누락 0
- Pencil app 버전: `defaults read /Applications/Pencil.app/Contents/Info.plist CFBundleShortVersionString` → **1.1.62**
- 구 13 종 중 제거 4 종: find_empty_space_on_canvas / open_document / replace_all_matching_properties / search_all_unique_properties (= pencil 서버 측 제거 · CC 무관)
- 9<13 판정: 게이트 noise FAIL = 본 cycle 의 인가된 주제 → 2.1.139 downgrade 기각 · 진행 인가

### 2-환경 corroborate (CC 회귀 X 근거)
- cli ToolSearch 결과 9 종 + cowork 환경 deferred pencil tool 목록 9 종 동일 → 원인 = pencil 서버 toolset 변경 · Claude Code 버전 무관

## Key Findings
- §13 item 3 = 단순 카운트 게이트라 pencil 서버 도구 축소(13→9)에 취약 → named-set 전수 존재 판정으로 견고화 (= 구조 개선 + baseline 갱신)

## Cleanup Assessment
N/A (ops-layer task — 제품 코드 미변경)

## 베이스라인 불일치 (A1 · 기록 · forward-progress)
- cowork 측정 WT(§0) = `?? archive/propagation-status.md.bak` 만(무접촉) 이었으나, cli 진입 실측 시 **`scripts/propagate.sh` 가 추가로 modified** 상태.
- 내용 = `PRUNE_EXCLUDE_PATHS=('.claude/skills/run-*')` 추가 (= run-recipe prune gotcha 방어 · memory `propagate-prune-run-recipe-gotcha` corroborate).
- 판정: 본 cycle 무관 + 기존 in-progress 변경 + 두 hunk 모두 `if [ "$PRUNE_MODE" = 1 ]` 블록 내부 → 비-prune propagate 에 **inert**.
- 처리: **무접촉** (stage/commit/propagate X · A3 scope containment) · 본 EVIDENCE + paste-back 에 surface · 본 cycle 진행 (forward-progress · 안전 영향 0).
