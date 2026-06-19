# MASTER-SUPABASE-PROD-APPLY-RECIPE-001 — Verify-Sync Output

> `bash scripts/verify-sync.sh` 의 raw output (자동 생성: 2026-06-19T15:37:16+0900).

```
[verify-sync] ⚠ git-lock daemon 미활성 (C12 사고 패턴 재발 위험)
  plist 존재하나 load 안 됨 — 수정: launchctl load /Users/yundonghyeon/Library/LaunchAgents/com.coin.git-lock-cleaner.plist
  (--skip-daemon-check 로 본 진단 제외 가능)

═══════════════════════════════════════════════════════
[verify-sync] 6-repo sha 동기 검증
  master:  /Users/yundonghyeon/AndroidStudioProjects/claude-cli-master
  targets: GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs
  files:   161 (전체)
═══════════════════════════════════════════════════════
  ✗ docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md  master=dee1d4170623  GentlyBreath=✓  GentlyDay=✓  GentlyTable=6c47d056e503(✗)  app-foundation=✓  gently-product-docs=✓
  ✗ docs/ops/production-cli-access-tokens.md  master=33064f09f4e2  GentlyBreath=MISS  GentlyDay=MISS  GentlyTable=MISS  app-foundation=MISS  gently-product-docs=MISS

═══════════════════════════════════════════════════════
[verify-sync] 요약
  PASS:  159 파일
  DRIFT: 1 (자식 sha ≠ master)
  MISS:  5 (자식 부재 또는 repo 부재)
═══════════════════════════════════════════════════════
[verify-sync] FAIL — drift / miss 발견. propagation cycle 권장.
```

