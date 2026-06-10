# EVIDENCE — MASTER-CLI-INFRA-SMALL-BATCH-001

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (cli infra · hook + 도구 + repo-local config) |
| Reading Mode | 6. CLI 운영 레이어형 (M5) |
| Requirement Source | cc-paste-MASTER-CLI-INFRA-SMALL-BATCH-001.md ✓ |
| Info Gap | RESOLVABLE_IN_REPO (③ 의도 근거 = repo 기록 실측으로 해소) |
| STOP Risk | ③ 의도 근거(제외) 발견 시 변경 금지 — 실측 = 포함 의도 → 미발화 |
| Implementer Entry | Allowed |

## Baseline 실측 (live authoritative · §0 paste = Phase B 이전 stale)
- master HEAD `83b6506`(진입) — paste §0 `157a2c5` 대비 forward(PENCIL-PHASE-B `fc51d04` → CC-VERSION-UPDATE `83b6506` · 다른 session). 자식 5 = FND `4caa6f1` GB `aab577f` GD `4ffcb5d` GT `1e2cdf5` PDOCS `1db90fc`
- 보호 5 git-sha1: `8b46bb49`/`aba157e0`(pencil-uiux = Phase B)/`ce9c0d3e`(sot-policy = Phase B)/`d2c62265`/`69649a36` — 무접촉 의무 (본 cycle edit-set ∩ 보호 = ∅)
- 기존 dirty (무접촉): GB `.ai/reports/GB-VISION-MOTIVATION-001/TODO.md`(M)+`package-lock.json`(??) · GD/GT `supabase/.temp/cli-latest`(M)

## ① hook 8행 "5-repo" 실측 (REPO-COUNT-VOCAB-SWEEP STOP③ 보존분)
- instructions-loaded-baseline-verify.sh 7행: :7 :44 :45 :46 :56 :81 :129 + REPOS array :63
- pencil-pending-sweep.sh 1행: :34 + REPOS array :35
- 합 8 wording행 = STOP③ "instructions-loaded hook 7 + pencil-pending-sweep 1 = REPOS 하드코딩 5" 정합. REPOS 확장 시 실태 6 → 8행 거짓화 → 동반 현행화.
- 멤버십: instructions-loaded = `.claude/hooks/`(verify-sync FULL set · 6-repo byte-identical `4a7e313f`) · pencil-pending-sweep = `scripts/` 루트(verify-sync 미추적 · FND/GB/GD/GT present `5d151ee7` + PDOCS ABSENT)

## ② propagate run-* cp 가드 (실증)
- `--prune` PRUNE_EXCLUDE_PATHS=('.claude/skills/run-*') 역방향만 존재(:128). 순방향 cp 경로(--all `find .claude` 자동 포착 :95 + 명시 인자 FILES :65)엔 가드 0.
- 실증 = PROPAGATE-RUN-SKILL-RESEED-001(incident-log) — REPO-COUNT-VOCAB-SWEEP-001 중 run-master/SKILL.md 자식 5 재seeding → 즉발 회수.

## ③ GT push gate 의도 근거 실측 (STOP gate)
- core.hooksPath: GB/GD = `scripts/githooks` · **GT = (unset)** · FND = `.git/hooks`(기본)
- GT hook file = `scripts/githooks/pre-push`(1366B · executable) + `install.sh`(380B) 실존
- GT install.sh 주석: "core.hooksPath 는 per-clone local 설정(커밋 X)이라 새 clone 마다 1회 실행한다" + `git config core.hooksPath scripts/githooks`
- PRELAUNCH-CI-GATE-001(master-cycle-history-COLD:93): "GB/GD/GT push-time 게이트 ... pre-push hook(core.hooksPath) 이중 발화" + 게이트 생성 commit GT `4e910c7`
- **판정**: GT 포함이 의도(제외 의도 0) · unset = 이 clone에서 install.sh 미실행 gap(GB/GD는 실행됨). → §6 STOP 미발화 · GB/GD 동형 설정.

## Cleanup Assessment
N/A (ops-layer task — 제품 코드 미변경)
