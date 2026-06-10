# Propagation Report — MASTER-CLI-DEAD-REF-SWEEP-001

- **Date (KST)**: 2026-06-10
- **Mode**: M5 (cli-infra-ops) · production 무접촉
- **Origin**: cowork-infra-audit-P1/P2-20260610 (F1·F3·F5·F6·F7·F8·F10·F12·O3(D4)·O8)
- **Master commit**: `7654d36` (parent `0233d7d`)

## 6-repo HEAD (post-cycle)

| repo | HEAD | role |
|---|---|---|
| claude-cli-master | `7654d36` (+ audit commit) | master source |
| app-foundation | `c862134` | propagate byte-identical |
| GentlyBreath | `12d04f1` | propagate byte-identical (pre-existing dirty 보존: TODO.md + package-lock.json) |
| GentlyDay | `3e13aca` | propagate byte-identical (pre-existing dirty 보존: supabase/.temp/cli-latest) |
| GentlyTable | `94e0752` | propagate byte-identical (pre-existing dirty 보존: supabase/.temp/cli-latest) |
| gently-product-docs | `0a108dd` (propagate) + `63a3e6a` (⑤ run-master rm) | propagate + PDOCS-only |

## propagate / verify-sync

- `propagate.sh` (10 cli-infra files × 5 children): **ok=50 / fail=0**
- `verify-sync.sh`: **PASS 160 / DRIFT 0 / MISS 0**
- 보호 5 file sha drift: **0** (edit-set ∩ 보호 = ∅)
- production code touch: **0 LOC**

## propagated files (6-repo byte-identical · 10)

`.claude/hooks/baseline-snapshot.sh` · `.claude/hooks/measure-gsm-cycle.sh` · `.claude/rules/cycle-discipline.md` · `domain-roles.md` · `mode-system.md` · `routing-and-delegation.md` · `rule-routing-index.md` · `text-degeneration-prevention.md` · `ui-ux-analysis.md` · `workflow-core.md`

## outcome 처분 (10)

| # | 처분 |
|---|---|
| ① | baseline-snapshot.sh REPOS + drift loop 에 `gently-product-docs` literal 추가 → 6-repo. snapshot 재생성 PDOCS block 확인. |
| ② | **HOLD** — `compound-lint.sh` 라이브 grep 107 인용 (live operational gate · verify-all 실행/PROPAGATION_PARAMETERS/COMMON_ARCHITECTURE) but file 전 6-repo 부재 = §6 STOP ① (>10). 3 ref 무접촉. 별 cycle 표면화. |
| ③ | ui-ux-analysis(:11-13,:124) + workflow-core(:147-148) 부재 reading list → 제품 SoT(`../gently-product-docs/docs/` §I) + 자식 docs/CLAUDE.md·docs/design + docs/agent/architecture 재배선. |
| ④ | solutions/README(부재) 역할표 갱신 의무 ×2 → domain-roles:77 redundant step 제거 + routing:251 매트릭스 retarget (domain-roles 흡수). |
| ⑤ | PDOCS `run-master` seeding artifact `git rm` (PDOCS 단독 `63a3e6a`). |
| ⑥ | mode-system §4 `<repo>/.claude/CLAUDE.md` → `<repo>/CLAUDE.md` (root 실측). |
| ⑦ | cycle-discipline:270 역사 인용 라벨 + text-degeneration:128 현행 `.ai/reports/<taskId>/HANDOFF.md` retarget. |
| ⑧ | `archive/propagation-status.md.bak` → `archive/2026-06/` 정식 등재 + INDEX 1행 (rm deny → mv-only). |
| ⑨ | measure-gsm-cycle `stale_pointer_count()` scan 확장 (backtick .sh/.json/.md master-owned dir + FP 억제) + scope label + `GSM_STALE_SELFTEST` fixture. self-test=3. 실 stale 7 surface. |
| ⑩ | rule-routing-index L0 note "42 집합" → "46 집합". |

## ⑨ self-test (§7)

```
GSM_STALE_SELFTEST=1 bash .claude/hooks/measure-gsm-cycle.sh <fixture>/.claude/rules
→ stale_pointer_count = 3  (F3 `scripts/agent/compound-lint.sh` + F5 `docs/agent/solutions/README.md` + md-link `../missing-doc.md`)
실 .claude/rules → stale_pointer_count = 7 (surface-only · §8)
```

## 후속 (별 cycle)

- **②** compound-lint 107-ref: missing-tool 구현 vs 일괄 deprecate 결정 (사용자 본심).
- **F4·F9 보호 file stale 2** (⑨ surface 재확인 · §6 STOP ② 무접촉): `pencil-uiux-workflow.md` → `.claude/hooks/save-as-result-check.sh` (실위치 `scripts/`) + `uiux-sot-refresh.md` → `scripts/agent/repo-config.sh` (실위치 `scripts/`).
- **④ scope-외 동족 3**: routing-and-delegation:268 + docs-change-communicator:28 + DOC_TASK_TYPES:88 (solutions/README 잔존 인용).
- **O7** "5-repo" 어휘 sweep (본 cycle 무접촉 · A3).

## Negative Space Line

고려했으나 hot 제외 영역: ② compound-lint 3-ref 직접 정정(107-ref 부분 정정 = 비정합 증가 · HOLD) · 보호 file F4·F9 stale 정정(§6 STOP ② · 별 cycle) · ⑨ 확장 scan 의 non-backtick/cross-repo/§-level 검출(scope label 로 명시 · 측정기 폭발 회피).
