# EVIDENCE — MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001

## Intake / Mode
- Mode M5 cli-infra-ops. 도메인 키워드 (Auth/Data/Backend/Perf) = 0 hit (버전/cli infra 영역). Cleanup Assessment = N/A (ops-layer task).

## §0 baseline 재측정 + self-re-anchor (A1)
- paste §0/§11 baseline: `424644084dcc86bb95c104ac845e95774d8a063e`.
- 진입 측정 HEAD: `157a2c5` (drift = 선형 전진 ~16 commit · 424644 = ancestor). → Coin 결정 "adapt to live & proceed".
- 실행 중 re-drift: `157a2c5` → `fc51d04` (PENCIL-PHASE-B-PROTECTED-001 완결 cycle 3 commit: `57af6de` + `9858e6b` + `fc51d04` · 본 cycle scope 와 orthogonal) → Coin 결정 "재anchor = 현 HEAD fc51d04 · repo idle".
- 최종 anchor = `fc51d04`. commit guard = HEAD 재측정 후 commit (PASS) + path-limited.

## D-1 진단 (Claude Code 환경)
- `claude --version` = `2.1.170 (Claude Code)`. npm latest (`npm view`) = `2.1.170` → 교정 = no-op (이미 latest).
- 경로: `/Users/yundonghyeon/.nvm/versions/node/v22.21.1/bin/claude` (npm via nvm) + alias `~/bin/claude-wrap.sh`. native `~/.local/bin/claude` 부재 → npm scope 정합.
- `claude update` 이중 차단 = 정상: live env `DISABLE_UPDATES=1` + `DISABLE_AUTOUPDATER=1` (§13 정합 · 미실행).

## D-2 self-test 3/3 PASS (§13 9종 named-set)
1. `claude --version` = `2.1.170 (Claude Code)` ✓
2. `claude mcp list` → `pencil: … - ✔ Connected` ✓ (verbatim · 부수: pencil "Conflicting scopes" user/project 경고 = 선재 config hygiene · cycle scope 외).
3. `ToolSearch query="pencil"` → 9종 전수: batch_design / batch_get / export_nodes / get_editor_state / get_guidelines / get_screenshot / get_variables / set_variables / snapshot_layout ✓ (구 ≥13 카운트 = PENCIL-SELFTEST-GATE-RECALIBRATE 로 9종 named-set 정정 · paste 의 ≥13 = stale).

## #60956 live GitHub verify (§3 calibration · Coin 인가 condition 2)
- 제목(verbatim): `[BUG] autoUpdates: false in ~/.claude.json is not respected on native installation — CLI self-updates on launch #60956`
- state: OPEN. native installer 가 `autoUpdates: false` 무시 + launch 시 silent jump (2.1.100→2.1.145) + supply-chain 우려. → §13 native block 근거 (1) live-grounded.

## 보호 5 sha 재baseline (Coin condition 1 · fc51d04 기준)
- live `shasum -a 256` 5/5 = manifest baseline 일치 (PHASE-B 후): ui-spec `8502c014` · pencil-uiux `b09b8d50` · pencil-sot `2bfc81c5` · uiux-refresh `e3b9891d` · design-sot `4c566615`. drift 0. edit-set ∩ 보호 = ∅.

## §13 줄번호 live 재유도 (Coin condition · PHASE-B 가 cycle-discipline.md 변경)
- insertion point = line 203 (`관련 사고 누적` 마지막 bullet) 직후, `### 14)` (line 207) 앞. paste 의 "~198-203" 추정 대신 live grep 으로 확정.
