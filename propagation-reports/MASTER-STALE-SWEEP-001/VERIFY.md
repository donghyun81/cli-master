# MASTER-STALE-SWEEP-001 — Verify-Sync Output

> `bash scripts/verify-sync.sh` 의 raw output (자동 생성: 2026-08-17T18:37:17+0900).

```
[verify-sync] ⚠ git-lock daemon 미활성 (C12 사고 패턴 재발 위험)
  plist 존재하나 load 안 됨 — 수정: launchctl load /Users/yundonghyeon/Library/LaunchAgents/com.coin.git-lock-cleaner.plist
  (--skip-daemon-check 로 본 진단 제외 가능)

═══════════════════════════════════════════════════════
[verify-sync] 4-repo sha 동기 검증
  master:  /Users/yundonghyeon/AndroidStudioProjects/claude-cli-master
  targets: app-foundation toward-product-docs Selfward
  files:   166 (전체)
═══════════════════════════════════════════════════════
  ✗ docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md  master=0944b3147b66  app-foundation=MISS  toward-product-docs=MISS  Selfward=MISS
  ✗ docs/ops/production-cli-access-tokens.md  master=3b0e8131fb67  app-foundation=MISS  toward-product-docs=MISS  Selfward=MISS
  ✗ docs/stale-sweeps/README.md  master=d0c280dace76  app-foundation=MISS  toward-product-docs=MISS  Selfward=95b4781a492b(✗)
  ✗ docs/stale-sweeps/SWEEP-20260817.md  master=f49c2b507e1c  app-foundation=MISS  toward-product-docs=MISS  Selfward=8b8ab20a6252(✗)

═══════════════════════════════════════════════════════
[verify-sync] 요약
  PASS:  162 파일
  DRIFT: 2 (자식 sha ≠ master)
  MISS:  10 (자식 부재 또는 repo 부재)
═══════════════════════════════════════════════════════

[verify-sync] ⚠ 상태문서 부재 참조 (= stale ref · drift 재발 신호):
  - .claude/hooks/check-abbreviation.sh (in protected-file-hashes.md)
  - .claude/rules/abbreviation-policy.md (in protected-file-hashes.md)
  - .claude/rules/code-principles.md (in protected-file-hashes.md)
  - .claude/rules/design-to-code-sync.md (in protected-file-hashes.md)
  - .claude/rules/workflow-core.md (in protected-file-hashes.md)
  → 정정: 해당 .auto-memory 상태문서 본문 갱신 (master cycle)

[verify-sync] FAIL — drift / miss 발견. propagation cycle 권장.
```

