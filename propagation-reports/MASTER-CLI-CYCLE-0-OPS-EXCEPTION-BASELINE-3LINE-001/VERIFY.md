# MASTER-CLI-CYCLE-0-OPS-EXCEPTION-BASELINE-3LINE-001 — Verify-Sync Output

> `bash scripts/verify-sync.sh` 의 raw output (자동 생성: 2026-05-24T18:20:53+0900).

```
[verify-sync] ⚠ git-lock daemon 미활성 (C12 사고 패턴 재발 위험)
  plist 존재하나 load 안 됨 — 수정: launchctl load /Users/yundonghyeon/Library/LaunchAgents/com.coin.git-lock-cleaner.plist
  (--skip-daemon-check 로 본 진단 제외 가능)

═══════════════════════════════════════════════════════
[verify-sync] 3-repo sha 동기 검증
  master:  /Users/yundonghyeon/AndroidStudioProjects/claude-cli-master
  targets: GentlyBreath GentlyDay GentlyTable app-foundation
  files:   134 (전체)
═══════════════════════════════════════════════════════
  ✗ gradle.properties  master=51e4b5a131eb  GentlyBreath=7ee2174dc737(✗)  GentlyDay=7ee2174dc737(✗)  GentlyTable=7ee2174dc737(✗)  app-foundation=✓

═══════════════════════════════════════════════════════
[verify-sync] 요약
  PASS:  133 파일
  DRIFT: 3 (자식 sha ≠ master)
  MISS:  0 (자식 부재 또는 repo 부재)
═══════════════════════════════════════════════════════
[verify-sync] FAIL — drift / miss 발견. propagation cycle 권장.
```

