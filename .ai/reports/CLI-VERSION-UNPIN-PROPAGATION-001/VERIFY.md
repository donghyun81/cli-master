# VERIFY — CLI-VERSION-UNPIN-PROPAGATION-001

## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `git -C <repo> hash-object .claude/rules/cycle-discipline.md` × 4-repo | 0 | PASS — 4-repo 모두 `0e4a7d01997c0d12ddb432d14ee37cdb1c4f1bbc` 동일 |
| `shasum -a 256 <보호파일>` × 5 | 0 | PASS — 5종 sha 변동 0 (`protected-file-hashes.md` baseline 일치) |
| `grep -c "최신 추격\|self-test 3 항목\|known-working\|CLAUDE-CODE-LATEST-CHASE-001\|DISABLE_AUTOUPDATER" <repo>/.claude/rules/cycle-discipline.md` × 4-repo | 0 | PASS — 4-repo 모두 10 hit 동일 (byte-identical 정합) |
| self-test 1 `claude --version` | 0 | PASS — `2.1.121 (Claude Code)` |
| self-test 2 `claude mcp list` | 0 | PASS — `pencil ✓ Connected` 명시 |
| self-test 3 `ToolSearch query="+pencil mcp" max_results=15` | 0 | PASS — 13 mcp__pencil__* tools |

## Verification Summary

| 영역 | PASS / FAIL |
|---|---|
| 4-repo byte-identical (cycle-discipline.md) | PASS — sha `0e4a7d01997c0d12ddb432d14ee37cdb1c4f1bbc` |
| 보호 파일 5종 sha 변동 0 | PASS |
| 본 cycle 5 핵심 요소 모두 반영 (grep ≥ 5 종 키워드 동시 hit · 4-repo 동일 count) | PASS |
| self-test 3 항목 모두 PASS (cycle 진입 baseline) | PASS |
| Proto 3-repo 무접촉 | PASS (cp 명령 target X) |
| `.mcp.json` / `settings.json` / `agents/active` / 다른 cli infra rule 무접촉 | PASS (Edit target = cycle-discipline.md 단일) |

## UNKNOWN (검증 불가 항목)

없음.

## LOG

```
[LOG] 2026-05-12 KST
CMD: git hash-object .claude/rules/cycle-discipline.md (× 4-repo)
EXIT: 0
STDOUT: 0e4a7d01997c0d12ddb432d14ee37cdb1c4f1bbc (× 4)

CMD: shasum -a 256 docs/schemas/ui-spec.schema.json .claude/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md
EXIT: 0
STDOUT: f1edd397... ee377dc2... e5e3fe16... 7621013e... 96de2f5d...
NOTE: 모두 protected-file-hashes.md baseline 안 5종 sha 와 일치 (변동 0).

CMD: grep -c "최신 추격|self-test 3 항목|known-working|CLAUDE-CODE-LATEST-CHASE-001|DISABLE_AUTOUPDATER" .claude/rules/cycle-discipline.md (× 4-repo)
EXIT: 0
STDOUT: 10 (× 4-repo · 동일 count = byte-identical 정합)

CMD: claude --version
EXIT: 0
STDOUT: 2.1.121 (Claude Code)

CMD: claude mcp list
EXIT: 0
STDOUT: pencil: /Applications/Pencil.app/Contents/Resources/app.asar.unpacked/out/mcp-server-darwin-arm64 --app desktop - ✓ Connected

CMD: ToolSearch query="+pencil mcp" max_results=15
EXIT: 0
STDOUT: 13 mcp__pencil__* tools (batch_design / batch_get / export_nodes / find_empty_space_on_canvas / get_editor_state / get_guidelines / get_screenshot / get_variables / open_document / replace_all_matching_properties / search_all_unique_properties / set_variables / snapshot_layout)
```
