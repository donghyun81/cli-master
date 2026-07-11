# Propagation REPORT — MASTER-CLI-CONTEXT-DIET-2-003

**마감**: 2026-07-11 KST · Mode M5 cli-infra-ops · production 0 LOC.

## 본질
`.claude/rules/` 49 unscoped rule 이 세션 시작 시 전문 자동 주입(base ≈288K tok 실측) → Reading Mode Read 와 이중 적재. 44 rule 을 `docs/rules/` 로 이동해 자동 주입층을 L0 kernel 5 로 축소, Read 를 유일 로드 경로화.

## 게이트 (프로브 A)
- subagent spawn: `INJECTED_RULES_PRESENT=YES` · `cycle-discipline.md`(이동대상) 헤딩을 tool 없이 인용 = 주입 확증 · **base ≈288,612 tok** (0 tool-use).
- 판정: rules 주입이 base 를 강하게 지배 → STOP 미발동 · PROCEED.

## 이동 (T1)
- 잔존 5 (`.claude/rules/`): safety-and-secrets · anchor-list · cross-repo-parallel-exec · rule-routing-table · rule-footer-common.
- 이동 44 (`docs/rules/`): git mv (이력 보존).

## 검증
| 항목 | 결과 |
|---|---|
| move-induced broken-link | **0** (전 49 rule file 스캔) |
| hot residual `.claude/rules/<moved>` | **0** (history/artifact 제외) |
| 보호 2 rebaseline | pencil-uiux sha256 `202d3f4f…` git1 `68c6c213…` · uiux-sot sha256 `31c0da56…` git1 `7e70e365…` (경로문자열만 변경) |
| 3 unmoved 보호 | moved-ref 0 · 무접촉 · sha 보존 |
| manifest ↔ live sha256 | 일치 (5/5) |
| instructions-loaded hook (real master) | 보호 5 drift **0** |
| test-protected-file-hooks | #3/#4/#5 PASS · #1/#2 pre-existing (stdout↔exit-capture · path-independent) |
| **verify-sync** | **164 PASS / 0 DRIFT / MISS 5** (=docs/ops master-only · exit 0 · --skip-daemon-check) |
| gsm stale_pointer (잔존5) | 0 |

## propagation (6-repo)
- `propagate.sh --all` ok=830 fail=0 → 자식 5 측 구 `.claude/rules/` orphan 44 surgical `git rm` (blanket --prune 미사용).
- master content `de37a6e` · GB `9ef5c89` · GD `e9494bc`(+CLAUDE.md `74b3a3b`) · GT `abda0c7` · FND `4a86f83` · PDOCS `6b1336c`.
- docs/rules 44 + .claude/rules 5 = 6-repo byte-identical.
- CLAUDE.md = 자식4 surgical(§15前 moved-ref · PDOCS 무접촉) · 부모 root 무접촉.

## 프로브 B (동일 세션)
- **미반영** (base ≈288,600 · cycle-discipline 여전히 주입). project instructions = 세션 시작 1회 로드 → same-session subagent = pre-move snapshot 상속.
- → **신 세션 확증 필요** (다음 `claude` 진입 시 `.claude/rules` 주입 = 5-kernel 감축 예상). 기전 가설 무해 정합.

## 사고
1. `docs/ops/production-cli-access-tokens.md` = `--all` 로 자식 5 유입(문서화 master-only 위반 · secret-value 0) → 자식 surgical rm+amend 로 복원. 근본 = propagate.sh docs/ops exclude 부재 (후속).
2. GD 동시 세션(GD-PEN-BACKSTOP-001) 도메인 커밋 2개 유입 → cli-infra 무접촉 확인(e9494bc 무결) · GD CLAUDE.md fix 신규 path-limited 커밋(WIP 무혼입).
3. zsh unquoted-var word-split → retain/rm 루프 오작동 → 리터럴 리스트/glob 복구.

## 후속 (scope 외)
프로브 B 신 세션 확증 · stale-3 + 삭제-file ref(workflow.md/evidence-and-reporting.md) + test #1/#2 harness + .auto-memory 서술 stale-ref(non-blocking) + propagate.sh docs/ops exclude + §15 hot 15>10 = S15-HOT-DEMOTE-005 · git-lock daemon launchctl load.
