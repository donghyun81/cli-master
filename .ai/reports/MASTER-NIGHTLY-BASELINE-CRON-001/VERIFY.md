# VERIFY — MASTER-NIGHTLY-BASELINE-CRON-001

## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `bash scripts/nightly-baseline-report.sh` (claude -p 첫 시도) | 0 (잡 exit · claude -p exit=1 fallback 발화) | FAIL (claude -p auth 차단) → 진단 |
| `echo "say hi in korean" \| claude -p --tools "" --setting-sources "" --no-session-persistence --output-format text --max-budget-usd 0.50` | 0 | PASS (claude -p OAuth 채택 + hook 차단 patterns 정합 검증) |
| `bash scripts/nightly-baseline-report.sh` (script 수정 후 2 차) | 0 | PASS — 6369 byte markdown 종합 출력 + LLM 의 "재개 우선 cycle" 단서 추출 |
| `diff /tmp/nightly-pre-baseline-sha.txt /tmp/nightly-post-baseline-sha.txt` | 0 | PASS — 보호 파일 5종 × 5-repo sha 변동 0 (= READ-ONLY 의무 검증) |
| `bash scripts/verify-sync.sh --no-update --skip-daemon-check` | 1 | 회귀 0 — drift 2 (app-foundation gradlew + gradlew.bat) = 본 cycle prompt §0 명시된 기존 drift (본 cycle 무관). 본 cycle 산출물 추가로 인한 추가 drift = 0. |
| `git -C "$HOME/AndroidStudioProjects/{GB,GD,GT,app-foundation}" status --short` (POST vs PRE) | 0 | PASS — 4 자식 repo git status post-run = pre-run (본 잡 자식 repo 변경 0) |

## Verification Summary

- **claude -p flag spec 1 차 진단**: `--bare` 가 OAuth keychain 차단 (`claude --help`: "Anthropic auth is strictly ANTHROPIC_API_KEY or apiKeyHelper via --settings (OAuth and keychain are never read)") · `Not logged in` 으로 fallback 발화.
- **mitigation**: `--bare` 제거 + `--setting-sources ""` (settings.json 미로드 → SessionStart hook 부산물 file 생성 차단). 정상 OAuth keychain 채택 + hook 발화 0 영역 도달.
- **2 차 호출 PASS**: 55 초 (claude -p 호출 50 초 + 측정 5 초) · 야간 1 회 1 분 미만 OK.
- **종합 markdown 품질**: LLM 이 측정 데이터 안에서 "재개 우선 cycle = MASTER-LIBS-VERSIONS-CROSS-VERIFY-HOOK-001 (Verdict 완료 · TODO 10 항목 잔존)" 단서를 자동 추출 — 본 cycle 의도 부합.
- **READ-ONLY 의무 검증 PASS**: 보호 파일 5종 × 5-repo sha 변동 0 + 자식 4 repo git status PRE = POST + verify-sync 회귀 0.

## UNKNOWN (검증 불가 항목)

- **launchctl 등재 + 04:00 KST 자동 발화**: Coin 손 작업 1 회 (`bash scripts/install-nightly-baseline-report.sh`) 이후 launchd 환경 안 실측 단계. 본 CLI 가 직접 launchctl load 수행 X (= sandbox 외 시스템 영향 영역 · 사용자 손 작업 의무). 단 본 잡 script 자체는 직접 호출 PASS · launchd 환경 시뮬레이션 (env -i PATH 빈약) 도 PATH resolve fallback patterns 으로 정합 보장 의무.

## LOG

```
[LOG] 2026-05-14 16:18 KST
CMD: bash scripts/nightly-baseline-report.sh  (1 차 · claude -p exit=1)
EXIT: 0 (잡 자체)
STDOUT: (잡 stdout 없음 · 출력은 .ai/nightly-baseline/<date>.md 만)
NIGHTLY.LOG: [2026-05-14T07:16:38Z] done · claude_exit=1 verify_sync_exit=1 out=.../2026-05-14.md
진단: latest.md 마지막 섹션 "claude -p output" = "Not logged in · Please run /login"

[LOG] 2026-05-14 16:19 KST
CMD: bash scripts/nightly-baseline-report.sh  (2 차 · script 수정 후)
EXIT: 0
NIGHTLY.LOG: [2026-05-14T07:18:37Z] done · claude_exit=0 verify_sync_exit=1 out=.../2026-05-14.md
출력 file: 6369 byte · TL;DR 3 줄 + 보호 파일 표 + cli infra drift + 진행 중 cycle 표 + 최근 commit + repo 도메인 표

[LOG] 2026-05-14 16:19 KST
CMD: diff /tmp/nightly-pre-baseline-sha.txt /tmp/nightly-post-baseline-sha.txt
EXIT: 0
STDOUT: (empty · diff 0)

[LOG] 2026-05-14 16:19 KST
CMD: bash scripts/verify-sync.sh --no-update --skip-daemon-check
EXIT: 1 (= 기존 app-foundation gradlew 2 drift · 본 cycle 무관)
STDOUT: PASS 118 / DRIFT 2 / MISS 0
회귀: 본 cycle 산출물 추가로 인한 추가 drift = 0
```
