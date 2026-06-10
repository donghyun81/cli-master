# Propagation Report — MASTER-CLI-PROTECTED-STALE-PATH-FIX-001

- **마감일**: 2026-06-10 KST
- **Mode**: M5 (cli-infra-ops · 보호 file 접촉 · 본심 회수 완료)
- **본질**: 보호 file 2종 본문 stale 경로 3곳 수술 정정 + 2층 hash resync + 6-repo byte-identical propagation. production/도메인 0 LOC.
- **origin**: cowork-infra-audit-P1 F4+F9 (DEAD-REF-SWEEP-001 ⑨ surface 후속) + Coin lineage 조항 폐기 본심.

## 정정 3곳 (보호 file 본문)

| # | file | 위치 | before → after |
|---|---|---|---|
| 1 | `.claude/rules/pencil-uiux-workflow.md` | :12 | `.claude/hooks/save-as-result-check.sh` → `scripts/save-as-result-check.sh` (S4 이동 기마감 반영 · pencil-auto-save.sh = hook 유지 무접촉) |
| 2 | `.claude/rules/uiux-sot-refresh.md` | :61 | `scripts/agent/repo-config.sh` → `scripts/repo-config.sh` (실위치=scripts/ · scripts/agent/=frontmatter-grep.sh 단독) |
| 3 | `.claude/rules/uiux-sot-refresh.md` | :27 | lineage 계약 조항(`.ai/uiux-sot/lineage/seed_audit_reference.md` · 6-repo 전수 부재 · 이행 0회) 폐기 — strikethrough + 폐기 명시 1줄 · git diff/commit 갈음(Latest-Only Policy 정합) |

실위치 disk 실측: `scripts/save-as-result-check.sh` ✓ · `scripts/repo-config.sh` ✓ · `.claude/hooks/save-as-result-check.sh` 부재 · lineage dir = 6-repo 전수 부재.

## 2층 hash resync (⚠ algorithm 교차 기입 금지)

| layer | file | file path | before | after |
|---|---|---|---|---|
| manifest (sha-256 · 64char) | `protected-file-hashes.md` | pencil-uiux-workflow.md | `e6a4a2a1457b…` | `52c075767388b36f7ea7611ec77cb6c861b62ce67fb92992cd36fa6a7e2a912f` |
| manifest (sha-256 · 64char) | `protected-file-hashes.md` | uiux-sot-refresh.md | `ee377dc2ac32…` | `75c0c47ee29993ae57a81b3060bd2b2c5f447e0b0fcb0f55a32feeee4d0ddca1` |
| §14a (git-sha1 · 40char) | `CLAUDE.md §14a` | pencil-uiux-workflow.md | `9d47624aafe3…` | `bac8e80151b9dee8090612dc7bfbe141e67862dc` |
| §14a (git-sha1 · 40char) | `CLAUDE.md §14a` | uiux-sot-refresh.md | `d3a0b57390bd…` | `b9a0c584b3c5a3f16c7c5e17de807f5e31b92c52` |

나머지 보호 3 sha 변동 0 (ui-spec.schema.json / pencil-sot-policy.md / design-sot-policy.md = git-sha1 `5b84cd9e…` / `b27fbe16…` / `e580b6d7…` 불변).

## propagation + cross-verify

- `propagate.sh .claude/rules/pencil-uiux-workflow.md .claude/rules/uiux-sot-refresh.md` → **ok=10 / fail=0** (2 file × 5 자식).
- `verify-sync.sh` → **PASS 160 / DRIFT 0 / MISS 0**. stale-ref WARN 0 (manifest Recent-updates 구경로 backtick→dir-only 회피로 scanner false-positive 해소).

## 6-repo 보호 2 file byte-identical (post-commit)

| repo | HEAD (post) | HEAD (pre) | pencil sha-256 | uiux sha-256 |
|---|---|---|---|---|
| claude-cli-master | (본 commit) | e471a87 | 52c07576… | 75c0c47e… |
| app-foundation | 5598b0e | c862134 | 52c07576… | 75c0c47e… |
| GentlyBreath | 282cb23 | 12d04f1 | 52c07576… | 75c0c47e… |
| GentlyDay | 4bd47eb | 3e13aca | 52c07576… | 75c0c47e… |
| GentlyTable | 612b11f | 94e0752 | 52c07576… | 75c0c47e… |
| gently-product-docs | 2f2e5a9 | 63a3e6a | 52c07576… | 75c0c47e… |

자식 commit = path-limited(`git commit -- <2 file>`) · 자식별 commit = 정확히 2 file · pre-existing dirty 보존(GB: TODO.md+package-lock.json · GD/GT: supabase/.temp/cli-latest · 0 NEW dirty 흡수).

## STOP 조건 점검 (전수 통과)

- ① 3곳 외 보호 본문 변경 = 0 (diff = 1+2 line · 본문 무변경).
- ② resync 실측 ≠ 기록 = 0 (manifest sha-256 + §14a git-sha1 + live disk 3중 정합).
- ③ propagation 후 자식 보호 sha ≠ master = 0 (verify-sync 160/0/0).

## §0 진입 의무 ② (latest.json PDOCS block)

parent-mount `.ai/baseline-snapshot/latest.json` 에 `gently-product-docs` block 존재 ✓ (grep count 2 · 직전 cycle ① 잔여 검증 PASS · 본 cycle scope 외).

## Refs

- cowork-infra-audit-P1 F4·F9 · `.auto-memory/protected-file-hashes.md` CONVENTION/resync trigger
- 직전 §15 entry: MASTER-CLI-DEAD-REF-SWEEP-001 (후속 F4·F9 명시)
- 후속 별 cycle: uiux-sot-refresh.md:22 `lineage/` 서술 정합 재검 · compound-lint 107-ref(4b) · O7 어휘 sweep(5)
