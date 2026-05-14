# TODO — MASTER-NIGHTLY-BASELINE-CRON-002

## Coin 손 작업 1 줄 (본 cycle 마감 직후 install 진입)

```
bash $HOME/AndroidStudioProjects/claude-cli-master/scripts/install-nightly-baseline-report.sh
```

자동 동작 + 마감 보고는 직전 cycle TODO 영역 그대로 (`MASTER-NIGHTLY-BASELINE-CRON-001/TODO.md` 참조).

## Deferred (lazy · 별 cycle 후보)

### §1. agent self-verification 회로 audit patterns 강화

본 cycle 의 본질 = 직전 cycle 안 self-verification false positive. 정책 본문 anchor (CLAUDE.md §4 / settings.json deny list) 영역 grep audit 누락 → mktemp 위반 누락. mitigation 후보:

- 보고서 작성 자체에 의무 audit checklist 박음 (`verification-and-review.md` 안 새 항목): `grep -nE '$TMPDIR|mktemp|/tmp\b' <변경 영역>` 영역 의무 박음.
- 또는 PostToolUse hook 신설 (`.claude/hooks/check-tmpdir-violation.sh`) — shell script 변경 시 자동 grep audit + warn-only.

scope = 별 cycle (= 본 cycle scope 외 영역) · 사용자 결정 의뢰 patterns.

### §2 + §3 + §4. 직전 cycle TODO 영역 그대로 보존

- §2 (6/15 이후 Agent SDK 비용 실측)
- §3 (claude binary path nvm drift 진단)
- §4 (app-foundation gradlew drift 2 정정)

본 cycle 안 추가 변동 X · `MASTER-NIGHTLY-BASELINE-CRON-001/TODO.md` 영역 그대로 의무.

## 본 cycle 마감 조건 (모두 충족)

- [x] script 1 영역 정정 (Edit 3 묶음 · 위반 영역 잔존 0 검증)
- [x] bash -n syntax PASS
- [x] self-test 재실행 PASS (6429 byte 종합 markdown · claude_exit=0)
- [x] READ-ONLY 검증 PASS (보호 파일 5종 × 5-repo sha 변동 0)
- [x] 자식 4 repo git status POST = PRE
- [x] verify-sync 회귀 0
- [x] 보고서 5 file (EVIDENCE / PLAN / VERIFY / REVIEW / TODO)
- [x] buffer file 영역 정리 (= §4 정합 보존)
- [ ] commit 1 건 (script 정정 + 보고서 + 2026-05-14.md 갱신본 묶음)
- [ ] Coin 손 작업 1 줄 보고
