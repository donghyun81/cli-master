# MASTER-SELFWARD-CLAUDE-PARITY-001 — Propagation Report

> 생성: 2026-07-17 (KST) · master content HEAD: `0c62052` · contract: `cc-paste-MASTER-SELFWARD-CLAUDE-PARITY-001` (authored-by cowork · 2026-07-16)

---

## 1. Cycle 메타

- cycle ID: MASTER-SELFWARD-CLAUDE-PARITY-001 (⑦ Selfward `.claude` parity: propagation 대상 편입 + 초회 전파)
- 마감일: 2026-07-17 (KST)
- Mode: M5 cli-infra-ops · production 0 LOC · cli-infra propagate only · 도메인 rule 내용 변경 0 · 보호 5 무접촉
- 발동 근거: Selfward = `.claude/` 부재로 T1~T5 내내 **paste 문면이 유일 rule 가드** → T6(정체성·repo 재편 대작업) 전 rule 백스탑 확보 (HANDOFF-T5 §3 · BLUEPRINT-T5 §6 근거).
- 본질: master 단방향 propagate 대상에 Selfward **6번째 편입** + `--all` set − master-only 2 = **165 file 초회 전파**. Selfward = master `1163a71` byte-identical.

## 2. §0 baseline gate (진입 재측정 · 상이 = STOP · 박제 금지)

| 항목 | 기대 | 측정값 | 판정 |
|---|---|---|---|
| master HEAD | `1163a71` | `1163a71` | ✓ |
| Selfward HEAD | `20eae9c` | `20eae9c` | ✓ |
| Selfward `.claude/` | 부재 | 부재 | ✓ |
| Selfward WT | `supabase/_ops/` 단독 | `?? supabase/_ops/` | ✓ |
| 전 7-repo ahead | 0 | 0 (master/Selfward/GB/GD/GT/FND/PDOCS 전량) | ✓ |
| propagate.sh TARGET_REPOS default | 5자식 string | `GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs` | ✓ |

pre-existing (STOP 무관 · 무접촉): GB/GD/GT dirty 104/77/70 (도메인 WIP).

## 3. 계약 이행 (§3 outcome)

| # | 계약 | 이행 |
|---|---|---|
| 1 | propagation 대상 편입 (최소 변경 · 보호 manifest grep 선행) | `repo-config.sh` TARGET_REPOS += Selfward (1행 SoT · manifest grep → 비보호 확인 · 기존 5자식 무접촉) |
| 2 | 초회 전파 → verify-sync PASS | 165 file propagate ok=165/0 · verify-sync Selfward **164 PASS / DRIFT 0 / MISS 2**(master-only 2 = pre-existing) |
| 3 | rule 백스탑 로드 상태 | Selfward `.claude/rules`·`settings.json`·hooks·agents·skills 실존 → cwd cli 세션 rule 로드 성립. CLAUDE.md = 기존 4-repo byte-identical clone `753a2e0` 유지(무접촉) |
| 4 | trail 등재 | §15 row + incident-log trail entry + propagation-status(auto) + 본 REPORT |
| 5 | commit master + Selfward 각 1+ | master 2(content `0c62052` + audit) + Selfward 1(`8e2a45d`) · push=Coin |

## 4. 보호 manifest 처리 내역 (실측 선행 · "기억 단정" 금지)

- 편집 대상 = `scripts/repo-config.sh` (TARGET_REPOS SoT).
- `.auto-memory/protected-file-hashes.md` **직접 grep 실측**: 보호 5종 = `docs/schemas/ui-spec.schema.json` + `docs/rules/pencil-uiux-workflow.md` + `docs/design/pencil-sot-policy.md` + `docs/rules/uiux-sot-refresh.md` + `docs/design/design-sot-policy.md`. `scripts/*` / `propagate.sh` / `repo-config.sh` / `verify-sync.sh` = manifest 보호 목록 부재 = **비보호** (propagation 도구 = master-only · 자식 전파 X).
- `.claude/settings.json` = advisory-tracked byte-identical (`313fec8d…`) · Selfward 전파분 = master 일치 (verify-sync PASS).
- 결론: 편집 대상 ∩ 보호 5 = ∅ → **manifest 갱신 불요**. propagate.sh 보호 baseline WARN 미발화 (manifest == live-disk).

## 5. targets diff (`scripts/repo-config.sh`)

```
-#   TARGET_REPOS   기본: "GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs"
+#   TARGET_REPOS   기본: "GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs Selfward"
...
+# Selfward 편입 = MASTER-SELFWARD-CLAUDE-PARITY-001 (2026-07-17 · 6th propagation target · .claude 초회 backstop)
-: "${TARGET_REPOS:=GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs}"
+: "${TARGET_REPOS:=GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs Selfward}"
```

(1 file · +3 / −2 · 기존 5자식 순서 보존 · Selfward 말미 추가.)

## 6. 전파 파일 목록 + sha 대조 (Selfward == master 유일값)

- 총 propagate = **165** (master `--all` set 167 − master-only 2).
- Selfward 실변 89 (git-tracked): 신규 83 (A) + 갱신 5 (M) + `.gitignore` 1 (M) · 무변 77 byte-identical no-op (미staged).
- sha 대조: Selfward 전파 164 file == master (verify-sync ✓ · master unique sha).

| 구분 | 수 | 내역 |
|---|---|---|
| 신규 (A) | 83 | `.claude/**` 76 (agents 25·skills 20·hooks 17·commands 8·rules 5·settings.json 1) + `.editorconfig` + `.mcp.json` + `.github/pull_request_template.md` + `.ai/uiux-sot` 3 + `.ai/promptfit` 1 |
| 갱신 (M) | 5 | stale cli-infra → master SoT: `docs/rules/cycle-discipline.md` · `docs/rules/design-to-code-sync.md` · `docs/rules/pencil-mcp-tools-reference.md` · `docs/rules/pencil-theme-multi-axis.md` · `docs/templates/release-checklist.template.md` |
| `.gitignore` (M) | 1 | `ensure-child-gitignore-patches.sh` C14 marker block (`.claude/settings.local.json`·`.ai/*`·`.kotlin/`·`supabase/.temp/` 등) |
| 무변 (no-op) | 77 | 기존 byte-identical cli-infra docs + `gradle.properties`(도메인 무관 일치) |

## 7. verify-sync raw (6-repo · Selfward 포함)

```
targets: GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs Selfward
files:   166 (전체)
✗ docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md  master=f7ca0507f2fe  GB=MISS GD=MISS GT=MISS FND=MISS PDOCS=MISS  Selfward=MISS
✗ docs/ops/production-cli-access-tokens.md                  master=3b0e8131fb67  GB=MISS GD=MISS GT=MISS FND=MISS PDOCS=MISS  Selfward=MISS
✗ docs/templates/release-checklist.template.md             master=e6c62fb280f4  GB=30fc93967106(✗) GD=…(✗) GT=…(✗) FND=…(✗) PDOCS=…(✗)  Selfward=✓
PASS: 163  DRIFT: 5  MISS: 12
```

Selfward 단독 (`verify-sync --target Selfward --no-update`):
```
✗ docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md  Selfward=MISS
✗ docs/ops/production-cli-access-tokens.md                  Selfward=MISS
PASS: 164  DRIFT: 0  MISS: 2
```

**pre-existing 구분**:
- DRIFT 5 = `release-checklist.template.md` 5자식 stale (`30fc9396`) · master `e6c62fb2` · **Selfward=✓** (초회 전파 = 최신 · 신규 drift 0).
- MISS 12 = CHARTER(6) + production-cli-access-tokens(6) · 양 file **master-only** (header/§15 "6-repo propagation 대상 X") · Selfward 포함 전 repo MISS = 의도적 exclusion-list gap (pre-existing · 본 cycle 무관).
- **Selfward 순수 결과 = 164 PASS / DRIFT 0 / MISS 2** (master-only 2 = 5자식 동일 pre-existing).

## 8. CLAUDE.md 처분 + 사유

- Selfward top-level CLAUDE.md **이미 실존** = 4-repo byte-identical 자식 clone `753a2e0…`(== GB/GD/GT/FND 4/4 sha 일치).
- 처분 = **무접촉 · propagate 절대 금지 준수** (자식별 dedup 관례 · propagate = 파괴).
- rule 로딩은 `.claude/` 만으로 성립하나, 기존 CLAUDE.md = 이미 올바른 child clone → 유지 (최소 stub/저작 불요 · STOP 미발동).
- §1 registry Selfward 미등재 = T6 repo 재편 몫 (본 cycle scope 밖).

## 9. Negative space (무접촉 확인)

- 기존 5자식(GB/GD/GT/FND/PDOCS): dirty 104/77/70/0/0 **불변** · `.gitignore`/`.claude` 무변 (env `TARGET_REPOS=Selfward` isolation).
- 보호 5 file sha drift 0 (edit-set ∩ 보호 = ∅).
- production/도메인/build 0 LOC: `gradlew`/`gradlew.bat`/`build.gradle.kts`/`settings.gradle.kts` = master 부재 → 미전파 · `gradle.properties` = byte-identical no-op · Selfward Android build 무변.
- master-only 2 (CHARTER/tokens) Selfward 미전파.
- `skills/run-*` propagate 제외 (자식별 launch recipe).
- Selfward `supabase/_ops` = pre-existing WT · 무접촉(미커밋).
- secret grep 0.

## 10. commit (git v3 · commit=cli · push=Coin)

- Selfward: `8e2a45d` — `feat(infra): MASTER-SELFWARD-CLAUDE-PARITY-001 초회 .claude propagate` (89 file · +8388 / −20)
- master content: `0c62052` — `feat(infra): … repo-config TARGET_REPOS += Selfward` (1 file · +3 / −2)
- master audit: `<본 커밋>` — `audit(infra): … §15 + incident-log + propagation-status + REPORT`
- push = 전 repo **Coin** (cli 실행 X)

## 11. 후속 (scope 외)

- Selfward run-* launch recipe 신설 (자식별 · 별 cycle).
- CLAUDE.md §1 registry Selfward 등재 + repo 재편 = **T6**.
- §15 hot 20 > 10 = **S15-HOT-DEMOTE-005** advisory.
- verify-sync stale-ref 5 (`.claude/rules/*` in status docs) = DIET-2-003 후속 pre-existing non-blocking.
- 기존 5자식 release-checklist stale + CHARTER/tokens MISS = 다음 일반 propagation cycle 또는 exclusion-list 정리 (본 cycle 무관).
