# RULE-ARCH-PROPAGATE-001 — Verify-Sync Output

> `bash scripts/verify-sync.sh` 의 raw output (자동 생성: 2026-05-31T22:42:41+0900).

```
[verify-sync] ⚠ git-lock daemon 미활성 (C12 사고 패턴 재발 위험)
  plist 존재하나 load 안 됨 — 수정: launchctl load /Users/yundonghyeon/Library/LaunchAgents/com.coin.git-lock-cleaner.plist
  (--skip-daemon-check 로 본 진단 제외 가능)

═══════════════════════════════════════════════════════
[verify-sync] 5-repo sha 동기 검증
  master:  /Users/yundonghyeon/AndroidStudioProjects/claude-cli-master
  targets: GentlyBreath GentlyDay GentlyTable app-foundation
  files:   156 (전체)
═══════════════════════════════════════════════════════

═══════════════════════════════════════════════════════
[verify-sync] 요약
  PASS:  156 파일
  DRIFT: 0 (자식 sha ≠ master)
  MISS:  0 (자식 부재 또는 repo 부재)
═══════════════════════════════════════════════════════
[verify-sync] PASS — 모든 sha 일치
```

