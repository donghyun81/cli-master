# Propagation REPORT — MASTER-CLI-CONTEXT-DIET-2-002

- **마감**: 2026-07-10 KST · Mode M5 cli-infra-ops · production 0 LOC.
- **master content commit**: `b7ac4ff` · **audit commit**: (본 REPORT 포함 commit).
- **선행**: MASTER-CLI-CONTEXT-DIET-2-001 (`f4e66ba` · PASS).

## propagate 대상 (2 file · 6-repo byte-identical)

| file | master sha-256 | ok/fail |
|---|---|---|
| `.claude/rules/mode-system.md` | `58ab19e7` | 5/0 |
| `.claude/hooks/measure-gsm-cycle.sh` | `d5607d11` | 5/0 |

- propagate ok=10/0 · post-propagate unique sha = 1 (byte-identical) 전수.

## 자식 commit (path-limited · WIP 무혼입 · name-only exact)

| repo | commit | 편집 파일 |
|---|---|---|
| app-foundation | `507f4d5` | CLAUDE.md + mode-system.md + measure-gsm-cycle.sh |
| GentlyBreath | `d6ed1b3` | CLAUDE.md + mode-system.md + measure-gsm-cycle.sh |
| GentlyDay | `7185b29` | CLAUDE.md + mode-system.md + measure-gsm-cycle.sh |
| GentlyTable | `5871e99` | CLAUDE.md + mode-system.md + measure-gsm-cycle.sh |
| gently-product-docs | `2a95840` | mode-system.md + measure-gsm-cycle.sh (CLAUDE.md 무접촉 · product-docs) |

## surgical (propagate X)

- CLAUDE.md ×6: 부모 root(git-X · sha-256 `6920a221`→`374c4a43`) + master(content commit) + 자식4(FND/GB/GD/GT · byte-identical). PDOCS CLAUDE.md 무접촉(banner 부재 · scope X).
- `.auto-memory/context-health-metrics.md` = master-only(§3.1 12-col + §6).

## verify-sync

- **164 PASS / 0 DRIFT / MISS 5** (= `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook · supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing).
- git-lock daemon 미활성 advisory = 비차단(follow-up launchctl load).

## char 실측 delta (measure-gsm-cycle.sh context-health · codepoint proxy)

| 지표 | before | after |
|---|---|---|
| parent_root CLAUDE.md | 9,094 | 9,750 |
| master CLAUDE.md | 47,004 | 47,564 (§15 entry append 후 재증식 · hot 14 > 10) |
| L0 kernel | 29,761 | 29,761 (무변동 · L0 rule 무편집) |
| child CLAUDE.md (×4 byte-identical) | 9,581 | 10,129 |

> 본 cycle = 진입 정독 **범위** 강등(T1) — char 자체는 소폭 증가(발췌 지시 + compact 지시 텍스트)하나, 실효는 **per-entry 정독 대상 축소**(전문→§5+§2 발췌)로 진입 로드 감소. char proxy ≠ 실 로드.
