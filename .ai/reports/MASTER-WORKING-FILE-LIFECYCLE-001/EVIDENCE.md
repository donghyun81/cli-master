# MASTER-WORKING-FILE-LIFECYCLE-001 — EVIDENCE

## STEP 0 — pre-baseline
- 4-repo working tree clean 확인 (gradlew.bat dirty 부재 — 이미 정리됨)
- stash 불필요

## STEP 1 — BASELINE 실측

### HEAD sha (4-repo · 변경 전)
- claude-cli-master: efd3eb8
- GentlyBreath: fcc21a0
- GentlyDay: 61d9f82
- GentlyTable: d65f35e

### .claude/rules sha (17 파일 4-repo byte-identical)
모두 일치 PASS.

### .claude/hooks sha (7 파일 4-repo byte-identical)
모두 일치 PASS. session-start.sh = `f1096e35` (baseline).

### 부모 root archive 상태
이전 cycle 활성. INDEX.md 4 entry 존재 (prior cycles).

## STEP 10 — cross-verify (6 종 byte-identical)

| 파일 | sha (4-repo 동일) |
|---|---|
| .claude/rules/working-file-lifecycle.md | 05b27eea |
| scripts/working-file-archiver.sh | e94e7834 |
| scripts/restore.sh | ab45c3c6 |
| scripts/com.coin.working-file-archiver.plist | 040aa648 |
| scripts/install-working-file-archiver.sh | b8a1eb22 |
| .claude/hooks/session-start.sh | d26e1f49 (이전 f1096e35 → 신 d26e1f49) |

부모 root scripts 4 종 vs master byte-identical OK.

## STEP 8 — .gitignore delta (자식 3 repo)

| repo | before | after | delta |
|---|---|---|---|
| GentlyBreath | 56 | 60 | 4 |
| GentlyDay | 52 | 56 | 4 |
| GentlyTable | 52 | 56 | 4 |

모두 정상 (≤ 4 line append).

## STEP 11 — git commit
- claude-cli-master: c64cddb (feat)
- GentlyBreath: d9686a3 (chore)
- GentlyDay: 498f056 (chore)
- GentlyTable: 13bc27a (chore)

## Cleanup Assessment
N/A (ops-layer task — 제품 코드 미변경)
