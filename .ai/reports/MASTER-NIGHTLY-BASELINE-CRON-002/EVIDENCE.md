# EVIDENCE — MASTER-NIGHTLY-BASELINE-CRON-002

## Requirements Source

- 본 chat prompt: "MASTER-NIGHTLY-BASELINE-CRON-002 (mktemp §4 위반 정정)" · Cowork disk cross-verify 8 영역 PASS 중 1 건 finding 명시.
- 위반 line: `scripts/nightly-baseline-report.sh:196` `PROMPT_FILE="$(mktemp -t nightly-baseline-prompt.XXXXXX)"` — `mktemp -t` 가 `$TMPDIR` 안 file 신설.
- 위반 정책 출처:
  - `claude-cli-master/CLAUDE.md §4` 절대 금지: `경로: /tmp · $TMPDIR 계열`
  - `.claude/settings.json` deny list: `Bash(*tmp*)`, `Bash(*TMPDIR*)`
- 직전 cycle (MASTER-NIGHTLY-BASELINE-CRON-001 · `d904a4e`) 의 self-verification 안 본 위반 누락 = agent self-verification false positive (settings.json deny list 는 Claude Code Bash tool 호출만 가로채고 launchd 실행 영역엔 영향 X · 본 cycle false positive 본질).

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | mini 정정 cycle (ops-layer · §4 정합 정정) |
| Reading Mode | CLI 운영 레이어형 |
| Info Gap | RESOLVABLE_IN_REPO (위반 line 위치 + 정합 patterns 명시됨) |
| STOP Risk | 없음 |
| Implementer Entry | Allowed |

## Pre-EVIDENCE Contract

- Read evidence:
  - `scripts/nightly-baseline-report.sh:196-199` (PROMPT_FILE 생성 + trap + cat heredoc)
  - `scripts/nightly-baseline-report.sh:290` (PROMPT terminator)
  - `scripts/nightly-baseline-report.sh:308` (`< "$PROMPT_FILE"` stdin redirect)
- Chosen path: temp file 자체 제거 + heredoc 변수 (`PROMPT_BODY=$(cat <<PROMPT ... PROMPT)`) + here-string (`<<< "$PROMPT_BODY"`) · §4 금지 영역 (`/tmp`/`$TMPDIR`) 전체 회피.
- 대안 검토:
  - 옵션 A: PROMPT_FILE 위치를 `$NIGHTLY_DIR/.prompt-<pid>.txt` 영역 = repo 안 = §4 정합. 단 잡 자체 의 cleanup 책임 + 동시 실행 안전성 부담.
  - 옵션 B (채택): temp file 없이 heredoc 변수 + here-string pipe. 단순 + 동시 실행 안전 + 정리 영역 0.
- Implement entry conditions: 정정 1 묶음 (3 영역 Edit · L195-200 + L290 + L308) → bash -n syntax 검증 → self-test 재실행 → READ-ONLY 검증 → 보고서 + commit.

## Collect Results

- `grep -n 'mktemp\|/tmp\|TMPDIR\|PROMPT_FILE' scripts/nightly-baseline-report.sh` (직전 = 4 matches: L196 mktemp · L197 PROMPT_FILE · L199 PROMPT_FILE · L308 PROMPT_FILE)
- `grep -n 'mktemp\|/tmp\|TMPDIR\|PROMPT_FILE' scripts/nightly-baseline-report.sh` (정정 후 = 2 matches: L196 + L197 = 정책 인용 자체 주석 영역 = 정합)

## Key Findings

- 1 파일 1 영역 정정 (= 3 Edit 묶음). 잡 본체 측정 logic / claude -p flag spec / fallback 분기 / launchd 진입점 모두 무변경.
- `<<<` here-string macOS bash 3.x 호환 (bash 2.05b+ 부터 지원).
- 본 cycle 정정 후 blob sha = `dcd865369c5dd25d79d86d571f233fb52ffb2c7d` (직전 `d6493b5435542d270f4713454056aab3f7259992`).

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 무변경 · scripts 안 1 파일 정정 영역만)
