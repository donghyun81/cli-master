# MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001 — Verify-Sync Output

> `bash scripts/verify-sync.sh` 의 raw output (자동 생성: 2026-05-19T23:07:16+0900).

```
[verify-sync] ⚠ git-lock daemon 미활성 (C12 사고 패턴 재발 위험)
  plist 존재하나 load 안 됨 — 수정: launchctl load /Users/yundonghyeon/Library/LaunchAgents/com.coin.git-lock-cleaner.plist
  (--skip-daemon-check 로 본 진단 제외 가능)

═══════════════════════════════════════════════════════
[verify-sync] 3-repo sha 동기 검증
  master:  /Users/yundonghyeon/AndroidStudioProjects/claude-cli-master
  targets: GentlyBreath GentlyDay GentlyTable app-foundation
  files:   133 (전체)
═══════════════════════════════════════════════════════
  ✗ docs/baseline/cowork-project-instructions-§20-redline-20260517.md  master=15bc24c867b2  GentlyBreath=MISS  GentlyDay=MISS  GentlyTable=MISS  app-foundation=MISS
  ✗ gradlew  master=3238afb2aed5  GentlyBreath=✓  GentlyDay=✓  GentlyTable=✓  app-foundation=734b3879d350(✗)
  ✗ gradlew.bat  master=1d297e00bd21  GentlyBreath=✓  GentlyDay=✓  GentlyTable=✓  app-foundation=57931b17dd22(✗)

═══════════════════════════════════════════════════════
[verify-sync] 요약
  PASS:  130 파일
  DRIFT: 2 (자식 sha ≠ master)
  MISS:  4 (자식 부재 또는 repo 부재)
═══════════════════════════════════════════════════════
[verify-sync] FAIL — drift / miss 발견. propagation cycle 권장.
```

