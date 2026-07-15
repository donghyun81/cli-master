# MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-002 — Propagation Report

> 생성: 2026-07-15 (KST) · master content HEAD: f38e6fd · contract: cc-paste-MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-002 (authored-by cowork · 2026-07-15)

---

## 1. Cycle 메타

- cycle ID: MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-002
- 마감일: 2026-07-15 (KST)
- Mode: M5 cli-infra-ops · production 0 LOC · 보호 5 무접촉
- 발동 근거: 진입 self-test ③ named-set FAIL — 실측 toolset(`set_variables` 부재 + `export_html` 존재 · 9종) ≠ §13 구 named-set. 게이트 self-exception(본 cycle 인가 주제) → §13 known-working 복귀/CC 다운그레이드 기각.
- 본질: Pencil app v1.1.62 → v1.1.69 MCP surface **1-swap**(`set_variables` 제거 + `export_html` 추가 · count 9 유지 · **count-invariant**) 반영. count 불변(9=9)이라 §10 count STOP 미발동 → **named-set 게이트가 검출**. RECALIBRATE-001 의 13→9 count 축소와 대비.
- 겸결: CC 2.1.210 trail PASS entry(UPGRADE-001 / CLAUDE-CODE-LATEST-CHASE-001 잔여) 동시 마감.

## 2. §0 baseline gate (진입 cli 재측정 · 박제 금지)

| 항목 | 측정값 | 판정 |
|---|---|---|
| master HEAD (진입) | `5d8d485` = 기대 일치 | ✓ |
| working tree | clean (0 dirty) | ✓ |
| `cycle-discipline.md` blob | `3bfd634` | ✓ |
| `pencil-mcp-tools-reference.md` blob | `16797ec` | ✓ |
| `design-to-code-sync.md` blob | `d758fdd` | ✓ |
| `pencil-theme-multi-axis.md` blob | `b617d03` | ✓ |
| `pencil-cli/SKILL.md` blob | `2152b23` (보류 대상 · 무접촉) | ✓ |
| `pencil-pen-save/SKILL.md` blob | `7cb3b56` | ✓ |
| `incident-log.md` blob | `a72317f` | ✓ |
| 보호 2 (무접촉) | `pencil-sot-policy.md` `ce9c0d3` · `pencil-uiux-workflow.md` `68c6c21` = §14a baseline 일치 | ✓ |
| CC 환경 | 2.1.210 (유지 · 다운그레이드 X) | ✓ |

## 3. §3-2 확증 (판정 전 확인)

| 확증 | 결과 |
|---|---|
| ⓐ ToolSearch 재실측 (cli VS Code endpoint) | 9종 = batch_design/batch_get/**export_html**/export_nodes/get_editor_state/get_guidelines/get_screenshot/get_variables/snapshot_layout · `select:set_variables` **미해결**(부재 확증) · `select:export_html` 해결(schema 획득) |
| ⓑ Pencil app 버전 (read-only) | `defaults read /Applications/Pencil.app/…/CFBundleShortVersionString` = **1.1.69** (구 v1.1.62 → 서버측 toolset 재변경) |
| ⓒ endpoint 대조 | user scope = VS Code endpoint(본 세션 측정) + project scope = desktop endpoint · toolset 상이 미발견 → **corroborate 유지**(§6-2 미발동) |

## 4. 변경 (5 propagated + master-only 2 + REPORT · pencil-cli 보류)

| # | 파일 | 영역 | 변경 |
|---|---|---|---|
| T1 | `docs/rules/cycle-discipline.md` | 6-repo | §13 L69 named-set 1-swap(`set_variables` 제거 → `export_html` 삽입 · 알파벳 batch_get 다음 · 9종 유지) |
| T2 | `docs/rules/pencil-mcp-tools-reference.md` | 6-repo | §0.1a v1.1.69 1-swap 기록 신설 + §1.4 `set_variables` REMOVED stub + §4.3 `export_html` 신규(ToolSearch schema 실측) + header/§0 Part A/§1(5→4)/§4(2→3)/§10 named-set STOP 정합 · 역사(v1.1.62 4종=§0.1) 무접촉 |
| T3a | `docs/rules/design-to-code-sync.md` | 6-repo | L142 `mcp__pencil__set_variables` → headless 평문-JSON(§2.5 PRIMARY) |
| T3b | `docs/rules/pencil-theme-multi-axis.md` | 6-repo | L9 pointer + L285 실호출 workflow + L336 STOP row = headless 평문-JSON write |
| T3c | `.claude/skills/pencil-pen-save/SKILL.md` | 6-repo | L39 `mcp__pencil__set_variables` → headless 평문-JSON(open_document 선례 style) |
| T4 | `.auto-memory/incident-log.md` | master-only | entry 2 append (① RECALIBRATE-002 · ② CHASE-001 PASS 2.1.210) |
| — | `CLAUDE.md` §15 | master-only | cycle row |
| — | `.auto-memory/propagation-status.md` | master-only | verify-sync 자동 매트릭스 |

- **보류 (별 surface · §6-4 부분 land)**: `.claude/skills/pencil-cli/SKILL.md` (L96/L176 `pencil interactive` REPL `set_variables({...})` + L270 weekly label) = 헤드리스 CLI REPL surface(관측 0.2.6 · MCP 와 **별 endpoint** · 본 cycle 미측정). MCP-only 측정으로 CLI REPL surface 변경 단정 회피 → 측정 후 별 판단.

## 5. propagation 결과

- `propagate.sh` 5 file → 5 자식: **ok=25 / fail=0** (blanket --prune 미사용 · per-file)

| repo | HEAD (post-commit) | dirty | 비고 |
|---|---|---|---|
| claude-cli-master | `f38e6fd` (content) | — | + master-only audit commit (별도) |
| GentlyBreath | `a67a5a3` | WIP 무혼입 | 5 file byte-identical (name-only exact) |
| GentlyDay | `912e80a` | WIP 무혼입 | 〃 |
| GentlyTable | `6612e4d` | WIP 무혼입 | 〃 |
| app-foundation | `6d6a601` | WIP 무혼입 | 〃 |
| gently-product-docs | `2e91d1b` | WIP 무혼입 | 〃 |

## 6. byte-identical sha (검증 · shasum-256 12)

| 파일 | sha-256 (12) | 범위 |
|---|---|---|
| `docs/rules/cycle-discipline.md` | `551899306fbd` | 6-repo |
| `docs/rules/pencil-mcp-tools-reference.md` | `f87443053e1a` | 6-repo |
| `docs/rules/design-to-code-sync.md` | `81a52a9bc694` | 6-repo |
| `docs/rules/pencil-theme-multi-axis.md` | `42fa0fbdd9b2` | 6-repo |
| `.claude/skills/pencil-pen-save/SKILL.md` | `f77763ff80fe` | 6-repo |

## 7. self-test (self-validating · 재보정 후)

| item | 결과 |
|---|---|
| ① `claude --version` | **2.1.210** ✓ |
| ② `claude mcp list` pencil | **✔ Connected** ✓ (user/VS Code endpoint) |
| ③ ToolSearch pencil 9종 named-set 전수 | ✓ (batch_design/batch_get/export_html/export_nodes/get_editor_state/get_guidelines/get_screenshot/get_variables/snapshot_layout = §13 재보정 named-set 정확 일치) |

→ **3/3 PASS** → T4 ② CHASE-001 PASS entry 발행 조건 충족.

## 8. verify-sync (raw 요약)

- **PASS: 163** (본 cycle 5 file 전량 PASS · 6-repo byte-identical 직접 재확인)
- DRIFT: 5 — `release-checklist.template.md` (5 자식) = `RELEASECHECKLIST-LAUNCHGAP-001` P4-lazy 의도적 미전파 · **본 cycle 무관 pre-existing**
- MISS: 10 — `CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` + `production-cli-access-tokens.md` (master-only) · **본 cycle 무관 pre-existing**
- 신규 DRIFT (본 cycle edit-set): **0** → §6 STOP 미발동
- stale-ref 5 (abbreviation-policy · code-principles · design-to-code-sync · domain-roles · workflow-core) = DIET-2-003 후속 pre-existing non-blocking
- git-lock daemon 미활성 advisory = 비차단 (follow-up: launchctl load)

## 9. 보호 / STOP / Negative Space

- 보호 5 file sha drift: **0** (edit-set ∩ 보호 5 = ∅ · pencil-uiux-workflow.md/pencil-sot-policy.md 무접촉 · manifest 갱신 불요)
- STOP 9 항: 미발동 (§0 gate PASS · corroborate 유지 · 신규 DRIFT 0 · self-test 3/3 PASS · Money/Auth/DB 0)
- §6 STOP: ① 보호 접촉 X · ② corroborate 유지 · ③ self-test 재FAIL X(3/3 PASS) · ④ 대체 불확실 = pencil-cli 보류(부분 land) · ⑤ scope 확장 회피(보호 2/scope-conflict/.pen/Selfward 무접촉·보고만) · ⑥ CC 다운그레이드 X
- Negative Space: production/EF/DB/Money 0 LOC · 역사 서술(§0.1) 무접촉 · pencil-cli 보류 · 보호 2 set_variables 잔존 무접촉 · pencil scope-conflict 무접촉 · `.pen` 실파일 0 · blanket --prune 미사용

## 10. 후속 (scope 외) + push

- pencil-cli CLI REPL surface(`pencil interactive` 0.2.6) 측정 → set_variables 존재 여부 확정 후 pencil-cli 정합 (별 판단)
- Phase B 확장 후보: 보호 2 `set_variables` 잔존 (pencil-sot-policy.md:45 + pencil-uiux-workflow.md:58/:76) + 기존 open_document Phase B 잔존 묶음 (Coin 승인 게이트)
- pencil scope-conflict: `claude mcp` user(VS Code) / project(desktop) 중복 endpoint → 하나 정리 (`claude mcp remove pencil -s <scope>`) 별 판단
- git-lock daemon launchctl load · §15 hot 19>10 = **S15-HOT-DEMOTE-005** advisory

**push = 전 repo Coin** (cli 실행 X · 6-repo content commit 완료 · master audit commit 완료 · Coin push 대기).
