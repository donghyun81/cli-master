# TODO — MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-001

## Status: DONE (회수 옵션 C 집행 완료)

직전 STOP(baseline 위반: 별 cycle WIP 2건이 commit/propagate target 에 혼재) → 사용자 회수 C 승인 →
§25.2 WIP park(byte-exact · `git checkout HEAD -- file` + §13 결정론 재적용) · §13 단독 land/6-repo propagate ·
§25.2 restore. 완료.

## 마감 결과
- master `9ba035c` (§13 only · cycle-discipline §13 item3 + incident-log + CLAUDE.md §15).
- 자식 5 commit: GB `d55e48e` · GD `583903f` · GT `452c9bf` · FND `d803fc1` · PDOCS `052aeff` (각 §13 only).
- propagate ok=5/0 · verify-sync 160/0/0 · 보호 5 git-sha1 §14a baseline 정확 일치(drift 0).
- self-test 9 종 전수 self-validating PASS.

## park-preserved (별 cycle · uncommitted 잔존 · 본 cycle 무오염)
- [ ] `.claude/rules/cycle-discipline.md §25.2` de-dup(표→pointer) — P2-MECHANISM 후속 후보 · WT 복원됨 · 자기 cycle 로 land.
- [ ] `scripts/propagate.sh` run-* prune exclude(`PRUNE_EXCLUDE_PATHS`) — inert WIP · 자기 cycle 로 land.

## 후속 (scope 외 · 별 cycle)
- [ ] `PENCIL-TOOLSET-REMOVAL-STALE-SWEEP`(가칭) — 광역 pencil 4 종 제거 stale:
  - 보호 file 2 (`pencil-uiux-workflow.md` + `pencil-sot-policy.md` · open_document · sha manifest 절차 동반)
  - 활성 agent `ux-auditor.md` (`find_empty_space_on_canvas` 호출 = 런타임 실패 위험)
  - `pencil-mcp-tools-reference.md` + `pencil-cli`/`pencil-pen-save` skills (open_document)
  - `cycle-discipline.md:227` Path 2-A open_document step 재설계
- [ ] env advisory: git-lock daemon 미load (`launchctl load …com.coin.git-lock-cleaner.plist`) — verify-sync 경고 · 본 cycle 무관.
