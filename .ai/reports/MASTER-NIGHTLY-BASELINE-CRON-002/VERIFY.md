# VERIFY — MASTER-NIGHTLY-BASELINE-CRON-002

## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `grep -n 'mktemp\|/tmp\|TMPDIR\|PROMPT_FILE' scripts/nightly-baseline-report.sh` | 0 (= 매칭 잔존 영역 = 정책 인용 주석 2 줄만) | PASS — 코드 영역 매칭 0 (직전 4 → 2 = 주석 인용 영역) |
| `bash -n scripts/nightly-baseline-report.sh` | 0 | PASS — syntax 정합 |
| `bash scripts/nightly-baseline-report.sh` (self-test 재실행) | 0 | PASS — 55 초 · 6429 byte 종합 markdown 생성 · `claude_exit=0` |
| `diff .pre-baseline-sha.txt .post-baseline-sha.txt` (buffer = 보고서 dir 안) | 0 | PASS — 보호 파일 5종 × 5-repo sha 변동 0 |
| 자식 4 repo `git status --short` POST vs PRE | (동일) | PASS — 본 잡 자식 repo 영향 0 |
| `bash scripts/verify-sync.sh --no-update --skip-daemon-check` | 1 | 회귀 0 — drift 2 (app-foundation gradlew + gradlew.bat) = `§0` baseline · 본 cycle 무관 |

## Verification Summary

- **§4 위반 영역 잔존 0**: 코드 안 `mktemp` / `/tmp` / `$TMPDIR` / `PROMPT_FILE` 매칭 영역 0 (= 직전 4 매칭 → 정정 후 2 매칭 = 정책 인용 주석 영역 한정).
- **heredoc 변수 + here-string pipe patterns 정합**: `PROMPT_BODY=$(cat <<PROMPT ... PROMPT)` 안 interpolation 영역 정상 발화 + `<<< "$PROMPT_BODY"` stdin 채택 + 잡 안 OUT_FILE.tmp (= `$NIGHTLY_DIR` 안 = repo 안 = §4 정합) 만 trap 정리 영역.
- **self-test 회귀 0**: 정정 후 6429 byte 출력 (직전 6369 byte · 60 byte 미세 차이 = LLM 출력 비결정성 영역 · 본 cycle 정정 영향 X).
- **READ-ONLY 의무 검증 PASS**: 보호 파일 sha 변동 0 + 자식 4 repo git status PRE=POST.
- **buffer file 영역도 §4 정합**: 검증용 PRE/POST sha buffer 영역도 `.ai/reports/MASTER-NIGHTLY-BASELINE-CRON-002/` 안 (= repo 안 = §4 정합) · `/tmp` 미사용.

## UNKNOWN (검증 불가 항목)

- 직전 cycle TODO 영역 그대로 (launchctl 등재 실측 = Coin 손 작업 1 회 의무 영역).

## LOG

```
[LOG] 2026-05-14 16:34 KST
CMD: grep -n 'mktemp\|/tmp\|TMPDIR\|PROMPT_FILE' scripts/nightly-baseline-report.sh
EXIT: 0
STDOUT:
196:# CLAUDE.md §4 절대 금지 (/tmp · $TMPDIR 계열) + settings.json deny Bash(*tmp*) 정합:
197:# mktemp/$TMPDIR 미사용. heredoc 으로 prompt 영역을 shell 변수에 박고 stdin pipe.

[LOG] 2026-05-14 16:34 KST
CMD: bash -n scripts/nightly-baseline-report.sh
EXIT: 0
STDOUT: syntax PASS

[LOG] 2026-05-14 16:37 KST
CMD: bash scripts/nightly-baseline-report.sh
EXIT: 0
nightly.log: [2026-05-14T07:36:30Z] done · claude_exit=0 verify_sync_exit=1 out=.../2026-05-14.md
출력: 6429 byte 종합 markdown · LLM 발화 PASS

[LOG] 2026-05-14 16:37 KST
CMD: diff .pre-baseline-sha.txt .post-baseline-sha.txt
EXIT: 0
STDOUT: (empty · sha 변동 0)

[LOG] 2026-05-14 16:37 KST
CMD: bash scripts/verify-sync.sh --no-update --skip-daemon-check
EXIT: 1 (= app-foundation gradlew drift · 본 cycle 무관)
회귀: 본 cycle 정정 영역 회귀 0
```

## blob sha (정정 전 → 정정 후)

- 직전 (HEAD `d904a4e`): `scripts/nightly-baseline-report.sh` blob = `d6493b5435542d270f4713454056aab3f7259992`
- 정정 후: `scripts/nightly-baseline-report.sh` blob = `dcd865369c5dd25d79d86d571f233fb52ffb2c7d`
