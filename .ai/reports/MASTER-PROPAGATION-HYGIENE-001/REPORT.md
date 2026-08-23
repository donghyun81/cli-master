# MASTER-PROPAGATION-HYGIENE-001 — REPORT

> master cycle · M5 (cli 운영 레이어형) · 진입 cwd = `~/AndroidStudioProjects` → 작업 repo = `claude-cli-master` · 4-repo propagation 동반.
> 집행일 = 2026-08-23 (KST) · 진입 HEAD = `3a62ad6` · 자 = `ugrep 7.5.0` (cowork = `GNU grep 3.7` · §0-C 5 분기 확인).

---

## ① §A 대조표 — §0-D 계수 + §0-F 대조군 before/after

### ①-1 §0-D 전수표 재현 (cowork 실측 ↔ 내 실측)

| id | cowork 값 | 내 실측 | 판정 |
|---|---|---|---|
| **d1** | HEAD `3a62ad6` · dirty(tracked) 0 · ahead 4 | 동일 | ✓ 일치 |
| **d2** | FND `b710f25`(0·1) · TPD `3c64088`(1 pre-existing = `.auto-memory/incident-log-cowork.md` · 19) · SW `eaddc95`(2 pre-existing · 3) | 동일 (SW pre-existing 2 = `.ai/reports/SELFWARD-SRV-OPSPREP-PREFLIGHT-001/REPORT.md` + `.auto-memory/incident-log.md`) | ✓ 일치 |
| **d3** | 실 MISS = FND 4 · TPD 4 · SW 2 (= 10) · 원인 file 4종 | `verify-sync` 실판독 = **MISS 10** · 원인 file 4종 동일 | ✓ 일치 (§12-1 답 = **cowork 이 맞았다**) |
| **d4** | charter 는 file 단위여야 한다 · 형제 `external-dep-abstraction.md` 는 **SW 에 실재** | ★**강화**: 형제는 SW 뿐 아니라 **FND · TPD · SW 전량 실재** · charter 는 3 자식 전량 부재 | ✓ 일치 + 근거 강화 (dir 제외 시 죽는 전파 = 1본이 아니라 **3본**) |
| **d5** | `stale-sweeps` = MISS+DRIFT 동시 · README master `d0c280da`↔SW `95b4781a` · SWEEP master `f49c2b50`↔SW `8b8ab20a` · 루트 `STALE-DEBT.md` master `4a09c7a7`↔SW `a871f982` | 5개 sha 전량 동일 실측 | ✓ 일치 |
| **d6** | `stale-artifact-tracking.md:70` 이 `<repo>/docs/stale-sweeps/…` 로 repo 별 정의 · `:93` = 2026-08-17 신설 | `:70` = `## §6. sweep 산출 (= <repo>/docs/stale-sweeps/SWEEP-YYYYMMDD.md 1본)` · `:93` 확인 · **추가** `:46` = 대장도 `<repo>/STALE-DEBT.md` | ✓ 일치 |
| **d7** | 유령 플래그 확정 — `propagate.sh:149` 주석 ↔ 파서 분기 4종 | `:149` verbatim 일치 · 파서 = `:44 --all)` `:48 --targets)` `:52 --prune)` `:56 --apply)` · 미지 flag 는 `:64 -*)` 가 `exit 2` | ✓ 일치 |
| **d8** | `git rm` hit 1 · `prune --apply` 0 · `삭제 전파` 0 | 동일 (`git rm` 유일 hit = `legacy-cleanup-governance.md:33`) | ✓ 일치 |
| **d9** | detail 333행 · cycle-discipline 161행 · kernel 103행 | 동일 | ✓ 일치 |
| **d10** | `propagate.sh:99~104`(5줄) · `verify-sync.sh:128~134`(6줄) · 양쪽 find 본문 동일 | 동일 | ✓ 일치 |
| **d11** | CHECK_FILES 미해소 — cowork 근사 163 ↔ cli 직전 보고 161 | ★**해소** = 아래 ①-2 | — |

### ①-2 ★d11 해소 — 163 도 161 도 틀리지 않았다. 라벨이 달랐다

내 실행값 = **`CHECK_FILES` 165**. 두 수의 정체:

| 수 | 정체 | 산식 |
|---|---|---|
| **163** (cowork) | find 산출분 **단독** | `find …`(제외 6종) = 163 |
| **165** (정본) | 실제 `CHECK_FILES` | 163 + C5 root 실재분 **2** (`.editorconfig` · `.mcp.json` 실재 / `gradlew` · `gradlew.bat` 부재) |
| **161** (cli 직전 보고) | 판독의 **`PASS:` 줄** — 분모가 아니다 | 165 − (문제 file 4본) = 161 |

⟹ cowork 의 163 은 find 부분값으로 정확했고, 그 위에 「+ C5 root 실재분」을 이미 적어 두었다(= 산식은 165 를 가리키고 있었다). cli 직전 보고의 161 은 `PASS` 를 `CHECK_FILES` 로 라벨링한 것이다. **어느 쪽도 계산이 틀리지 않았고 이름이 틀렸다.**

### ①-3 §0-F 대조군 — before / after (`grep -c -e '<pat>'` × 2 script)

| 자 (문자열) | propagate BEFORE→AFTER | verify-sync BEFORE→AFTER | 역할 | 판정 |
|---|---|---|---|---|
| `release-readiness` | **1 → 1** | **2 → 2** | 양성 | ✓ 무변 |
| `agent/audits` | **2 → 2** | **2 → 2** | 양성 | ✓ 무변 |
| `skills/run-` | **4 → 5** | **2 → 3** | 양성 (형식 선례) | ⚠ 계수 +1/+1 — 아래 ⑦ G2 |
| `CLI-MASTER-SCOPE-SEPARATION` | **0 → 2** | **0 → 2** | 음성→양성 | ✓ |
| `docs/ops` | **0 → 2** | **0 → 2** | 음성→양성 | ✓ |
| `stale-sweeps` | **0 → 3** | **0 → 3** | 음성→양성 | ✓ |
| `workflows` | **0 → 3** | **0 → 3** | 음성→양성 | ✓ |

BEFORE 7행 전량이 cowork 표와 **정확히 일치**했다 (= 자가 죽어 있지 않았다는 §0-F 의 주장 재현 성공).

---

## ② §1 verify-sync **집행 전** 판독 전문 (박제)

```
[verify-sync] ⚠ git-lock daemon 미활성 (C12 사고 패턴 재발 위험)
  plist 존재하나 load 안 됨 — 수정: launchctl load /Users/yundonghyeon/Library/LaunchAgents/com.coin.git-lock-cleaner.plist
  (--skip-daemon-check 로 본 진단 제외 가능)

═══════════════════════════════════════════════════════
[verify-sync] 4-repo sha 동기 검증
  master:  /Users/yundonghyeon/AndroidStudioProjects/claude-cli-master
  targets: app-foundation toward-product-docs Selfward
  files:   165 (전체)
═══════════════════════════════════════════════════════
  ✗ docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md  master=913f79c40658  app-foundation=MISS  toward-product-docs=MISS  Selfward=MISS
  ✗ docs/ops/production-cli-access-tokens.md  master=3b0e8131fb67  app-foundation=MISS  toward-product-docs=MISS  Selfward=MISS
  ✗ docs/stale-sweeps/README.md  master=d0c280dace76  app-foundation=MISS  toward-product-docs=MISS  Selfward=95b4781a492b(✗)
  ✗ docs/stale-sweeps/SWEEP-20260817.md  master=f49c2b507e1c  app-foundation=MISS  toward-product-docs=MISS  Selfward=8b8ab20a6252(✗)

═══════════════════════════════════════════════════════
[verify-sync] 요약
  PASS:  161 파일
  DRIFT: 2 (자식 sha ≠ master)
  MISS:  10 (자식 부재 또는 repo 부재)
═══════════════════════════════════════════════════════
[verify-sync] propagation-status.md 갱신 박음 (live 매트릭스 + footer)

[verify-sync] ⚠ 상태문서 부재 참조 (= stale ref · drift 재발 신호):
  - .claude/hooks/check-abbreviation.sh (in protected-file-hashes.md)
  - .claude/rules/abbreviation-policy.md (in protected-file-hashes.md)
  - .claude/rules/code-principles.md (in protected-file-hashes.md)
  - .claude/rules/design-to-code-sync.md (in protected-file-hashes.md)
  - .claude/rules/workflow-core.md (in protected-file-hashes.md)
  → 정정: 해당 .auto-memory 상태문서 본문 갱신 (master cycle)

[verify-sync] FAIL — drift / miss 발견. propagation cycle 권장.
```
`EXIT=1`

---

## ③ §C diff (파일:라인) + 분모 차이 산술

### ③-1 diff 좌표 (commit `a263767`)

| 파일 | hunk | 내용 |
|---|---|---|
| `scripts/propagate.sh` | `@@ -104 +104,5` | find 제외 4행 추가 (charter=file · `docs/ops/*` · `docs/stale-sweeps/*` · `.github/workflows/*`) |
| `scripts/propagate.sh` | `@@ -106,0 +111,20` | 제외 4종 사유 주석 20행 (실측 병기) |
| `scripts/propagate.sh` | `@@ -149 +173,7` | §D 유령 flag 처분 (1행 → 7행) |
| `scripts/verify-sync.sh` | `@@ -134 +134,5` | find 제외 4행 (동일 순서) |
| `scripts/verify-sync.sh` | `@@ -140,0 +145,18` | 제외 4종 사유 주석 18행 |

합계 = `2 files changed, 55 insertions(+), 3 deletions(-)`.

### ③-2 ★분모 차이 산술 (§0-C 2)

```
find(제외  6종) = 163      find(제외 10종) = 159      C5 root 실재분 = 2
CHECK_FILES before = 165   CHECK_FILES after = 161    차이 = 4
```

집합 차 (`diff <(before) <(after)`) 가 낸 **실제 4본**:

```
docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md
docs/ops/production-cli-access-tokens.md
docs/stale-sweeps/README.md
docs/stale-sweeps/SWEEP-20260817.md
```

예상 산식 = charter 1 + ops 1 + sweeps 2 + workflows **0** = **4** ⟹ 실측 4 와 일치. **glob 이 형제를 물지 않았다** (수만 맞은 게 아니라 이름까지 맞았다).

### ③-3 형제 잔존 실측 (G3 + `.github` 대조)

집행 후 분모에 **잔존**:
- `docs/architecture/external-dep-abstraction.md` ← charter 를 dir 로 뺐다면 사라졌을 본
- `.github/pull_request_template.md` ← `.github/workflows/*` 제외가 형제를 안 물었다는 동작 측 증거

---

## ④ §D census — 파서 분기 ↔ 안내 flag 차집합 (`scripts/*.sh` 전량)

| script | 파서 case 분기 | 주석 안내 | 차집합(안내−파서) | 판정 |
|---|---|---|---|---|
| `propagate.sh` | 4 (`--all` `--apply` `--prune` `--targets`) | 4 | **0** | ✓ 유령 해소 (집행 전 = `--include` 1) |
| `verify-sync.sh` | 4 (`--no-update` `--quick` `--skip-daemon-check` `--target`) | 4 | **0** | ✓ |
| `ensure-child-gitignore-patches.sh` | 2 (`--target` `--verify`) | 2 | **0** | ✓ |
| `report-gen.sh` | 1 (`--commit-msg`) | 1 | **0** | ✓ |
| `nightly-baseline-report.sh` | **0** | 6 | `--bare --help --no-update --setting-sources --settings --tools` | ★**census 위양성** (아래) |

★`nightly-baseline-report.sh` 의 6종은 **자기 flag 가 아니다.** 그 script 는 arg 파서 자체가 없고(= `case "$1"` / `while [ $# ` / `getopts` 전량 부재 = 인자 무수용), 6종은 전부 **다른 도구** 호출 문맥이다 — `:136`/`:230` = `verify-sync.sh --no-update` · `:292`/`:299~302` = `claude -p` 의 `--tools ""` / `--setting-sources ""` / `--settings` / `--bare`. ⟹ 유령 flag **아님**. 내 census 자(= 주석 줄의 `--[a-z-]+` 전량 수집)가 「자기 flag ↔ 남의 flag」를 못 가르는 것이고, 그 갈래는 **파서 부재 여부**로 판정했다.

★**양성 대조군** (살아 있는 flag 가 안내와 일치하는가): `scripts/README.md` 가 `propagate.sh` 에 대해 안내하는 flag = `--all` · `--targets` **2종** → 둘 다 파서 분기 실재 ✓. 파일 내 총 언급 = `--all` 6 · `--targets` 5 · `--prune` 10 · `--apply` 7 (각 파서 분기 1).

★**처분 방식** (G-2 정합): flag **구현 0**. `:173` 문면을 ⓐ 정책(「cli infra 외 영역 추가 = Coin 명시 의무」 = **보존**) ⓑ 거짓 안내(flag 사용법 = **제거**) 로 가르고, ⓑ 자리에 §E 절차 지시를 넣었다.

---

## ⑤ §E 새 절 전문 + rule 후보 8 소진 판정

### ⑤-1 자리 선정 (§12-3 답 · 후보 3본을 열어 보고 결정)

| 후보 | 열어 본 결과 | 판정 |
|---|---|---|
| `cross-repo-parallel-exec-detail.md` (333행) | §4 = 「cross-repo 정합 처리」(§4.2 sha 비교 · §4.3 drift mitigation). **삭제 = sha 가 없을 때의 정합** = 같은 축의 빈자리 | ★**채택** |
| `legacy-cleanup-governance.md` (202행) | 「적용 범위」 표가 **「문서형 task (DocSync, Drift Audit) → 적용 안 함」**을 스스로 명시 · 전 절이 코드 심볼·경로 축 | 기각 (축이 다르다) |
| `cycle-discipline.md` (161행) | §12~§29 가 전량 요약 pointer 로 축소된 다이어트 판 (본문 = COLD) · 본문 4명제를 얹으면 그 방향과 충돌 | 기각 |

⟹ cowork 의 배치 판단과 **같은 결론**. 단 cowork 은 행수만 봤고(§12-3 자인), 나는 세 문서의 주제 적합성을 열어 보고 판정했다.

### ⑤-2 새 절 전문 (`docs/rules/cross-repo-parallel-exec-detail.md` §5 · 333→381행 · +48)

```markdown
## 5. 삭제 전파 절차 (= master 에서 지운 것이 자식에서도 지워졌는지)

> **신설** = `MASTER-PROPAGATION-HYGIENE-001` (2026-08-23). 계기 = `MASTER-AIDOC-RELEASE-REALIGN-001` 이 `docs/rules/sot-code-name-map.md` 를 은퇴시킬 때, **그 삭제가 자식에 착지했는지 물어볼 자가 없다**는 것이 드러났다. 집행 전 census 실측 = `docs/rules` + `.claude/rules` 전량에서 `git rm` hit **1** (= `legacy-cleanup-governance.md:33` · 그것도 「지울지 말지」의 STOP 판정이지 「어떻게 전파하는지」가 아니다) · `prune --apply` **0** · `삭제 전파` **0**.
> **왜 신 rule 파일이 아니라 절인가**: `docs/rules/*.md` 계수(**42**)는 `rule-routing-table.md` 가 인용하는 분모이고 직전 판이 방금 재계수한 값이다. 신설은 언제나 누군가의 분모를 낡게 만든다 (= `cycle-discipline.md` §2 「OPS 신설 금지 원칙」 · 그 §2 의 신설 escape 는 「사용자 본심 외화」 한정인데 본 절은 거기 해당하지 않는다).
> **왜 이 파일인가**: §4 가 「cross-repo 정합 처리」(= sha 비교 · drift mitigation)를 다루고, **삭제는 sha 가 없을 때의 정합**이다 — 같은 축의 빈자리. (후보 3본 대조: `legacy-cleanup-governance.md` = 코드 심볼 제거 governance 축이라 「문서형 task → 적용 안 함」을 스스로 명시 · `cycle-discipline.md` = 전 절이 요약 pointer 로 축소된 다이어트 판이라 본문 4명제를 얹으면 그 방향과 충돌.)
> **좌표 규율**: 아래 인용은 `파일:행` **+ 앵커 문자열**을 함께 적는다. 행은 움직인다 (= `stale-artifact-tracking.md:50` 「좌표 = `file` + 앵커 문자열 · ★행 번호 금지 (= 행은 움직인다)」와 같은 이유 — 실제로 본 절을 쓰는 cycle 이 같은 script 를 편집해 좌표를 21행 밀었다). 행 수치 = **2026-08-23 실측**이고, 갈리면 앵커로 다시 찾는다.

### 5.1 명제 1 — `verify-sync.sh` 는 삭제의 착지를 증명하지 못한다

`scripts/verify-sync.sh:128` (앵커 `done < <(find .claude docs scripts/agent …`) 이 분모(`CHECK_FILES`)를 **master 에서** 만든다. 이어 `scripts/verify-sync.sh:196~198` (앵커 `MASTER_SHA=$(shasum -a 256 "$MASTER_DIR/$f"` → `if [ -z "$MASTER_SHA" ]` → `continue`) 이 master 측 sha 가 비면 그 행을 **건너뛴다**.

⟹ **master 에 없는 파일은 분모에 들지 않는다.** 자식에만 남은 잔존물은 MISS 도 DRIFT 도 아니고 **아무것도 아니다** — 자는 「없다」고 말하는 게 아니라 **묻지 않는다**. `verify-sync` 가 대답하는 질문은 「master 것이 자식에 있고 같은가」 하나다.

★**반증 경로** (= 이것이 신념이 아니라 명제인 이유): 「자식-단독 잔존이 판독에 뜨는 실행」 **1건**이면 반증된다. 본 절 신설 cycle 이 그 실험을 실제로 돌렸다 — `docs/stale-sweeps/*` 2본을 분모에서 뺀 뒤 **Selfward 디스크에는 그 2본이 그대로 남은 상태로** `verify-sync` 를 재실행했고, 판독은 그 2본을 **한 줄도 언급하지 않았다** (집행 전 판독에서는 같은 2본이 DRIFT 로 떴다). **분모가 무엇을 볼 수 있는지를 결정한다.**

### 5.2 명제 2 — 삭제 전파는 2단이다 (영역마다 경로가 다르다)

| 영역 | 경로 | 근거 (`파일:행` + 앵커) |
|---|---|---|
| `.claude/**` | `bash scripts/propagate.sh --prune --apply` (= 자동 `rm` + 자식 `git add`) | whitelist = `scripts/propagate.sh:180` 앵커 `PRUNE_BASE_PATHS=(.claude)` · 실행부 = `scripts/propagate.sh:246~252` 앵커 `# master 부재 여부` → `rm -f "$REPO_DIR/$f"` · `--apply` 미지정 = dry-run (`orphan:` list 만) |
| `docs/**` · `.ai/**` · `scripts/agent/**` · `app/**` | ★**자식별 수동 `git rm`** | `scripts/propagate.sh:172` 앵커 「자식의 도메인 영역 (docs/, .ai/, scripts/agent/, app/) = 자율 영역 = prune 안 함」 — **의도된 미포함**이지 누락이 아니다 |

★**whitelist 확장으로 해결하지 마라.** `PRUNE_BASE_PATHS` 를 넓히는 것 = master 가 자식 도메인 자율 영역을 일괄 `rm` 할 권한을 갖는 것이고, §4.2 「자식 도메인 source = 자식별 도메인 specific · drift 영역 X」 + §4.3 「자식 도메인 source drift = lazy default」와 정면 충돌한다. 확장은 Coin 명시 회수 사항 (= `scripts/propagate.sh:173` 앵커 「cli infra 외 영역 추가 = Coin 명시 의무」).

### 5.3 명제 3 — 삭제 판의 착지 게이트 = 자식 N개 각각의 `test -f` 부재

명제 1 때문에 `verify-sync` exit 0 은 **삭제 착지의 증거가 아니다**. 삭제를 포함한 cycle 은 게이트를 따로 세운다 (= 자식 수만큼 직접 측정 · 도구 판독 인용 금지):

```bash
for r in app-foundation toward-product-docs Selfward; do
  [ -f "../$r/<지운 path>" ] && echo "RESIDUAL $r" || echo "OK(absent) $r"
done
```

선례 = `MASTER-AIDOC-RELEASE-REALIGN-001` (2026-08-23 · 착지 `3a62ad6`) — `docs/rules/sot-code-name-map.md` 은퇴를 **4-repo 전량 `test -f` 부재 실측**으로 닫았다 (본 절 작성 시점 재측정: master · FND · TPD · SW 전량 부재 ✓).

### 5.4 명제 4 — 이력은 지우지 않는다 (`.auto-memory/<name>-COLD.md` verbatim 이관)

문서를 은퇴시킬 때 본문은 `.auto-memory/<name>-COLD.md` 로 **verbatim** 옮긴다 (= 삭제 0 · 소급 정정 금지 정합). **master 한정**이다 — `.auto-memory` 는 전파 분모 밖이라(= `scripts/verify-sync.sh:128` 의 find 진입 root 6종 = `.claude` `docs` `scripts/agent` `.ai/promptfit` `.ai/uiux-sot/refresh` `.github` · `.auto-memory` 부재) 자식 판에는 COLD 가 **없는 것이 정상**이다.

실측 선례 = `.auto-memory/*-COLD.md` **9본** (`ls -1 .auto-memory/*COLD*.md | wc -l` · 2026-08-23) — `abbreviation-policy` · `anchor-list` · `cross-repo-parallel-exec` · `cycle-discipline` · `master-cycle-history` · `mode-bundle` · `rule-routing-index` · `sot-code-name-map` · `text-degeneration-prevention`. 마지막에서 두 번째가 직전 판이 낸 것이다.

### 5.5 경계 — 제외(exclude)는 삭제가 아니다

find 제외 절에 1줄 넣는 것은 **분모에서 빼는 것**이지 자식 디스크에서 지우는 것이 아니다. 둘을 섞으면 「조용해졌으니 정리됐다」는 오독이 생긴다. 제외 후에도 자식 잔존물은 그대로 있고, 명제 1 때문에 **자는 그것을 영원히 언급하지 않는다** — 잔존을 없애야 한다면 명제 2·3 을 따로 밟는다.

★**file 단위 제외의 대가** (= 2026-08-23 실측 기반 결정): `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` 는 **dir 이 아니라 file 단위**로 제외했다 — 같은 dir 의 형제 `external-dep-abstraction.md` 가 FND/TPD/SW 전량에 실재하는 **살아 있는 전파**여서, dir 제외는 그 3본을 분모에서 함께 죽인다. 대가는 명시한다: **그 dir 에 master-only 문서가 또 생기면 그 1본이 다시 MISS 로 뜬다.** 그때의 처분 = 제외 행 1줄 추가이고, 「형제가 전파 중인지」를 먼저 `test -f` 로 재는 것이 순서다 (= 살아 있는 전파를 죽이는 것보다 MISS 1건이 싸다).
```

kernel pointer (1줄 · `.claude/rules/cross-repo-parallel-exec.md` §2 · 103→104행):

```markdown
- **삭제 전파** (= master 에서 지운 것): ★`verify-sync` 는 분모를 master 에서 만들어 **삭제 착지를 증명하지 못한다** — `.claude/**` = `propagate.sh --prune --apply` · `docs/**` = 자식별 수동 `git rm` · 착지 게이트 = 자식 N개 각각 `test -f` 부재. → detail §5 (= 유일 본문 canonical).
```

### ⑤-3 ★rule 후보 8 소진 판정

후보 8 = 「propagated-then-dead artifact retire sub-paradigm 명시」.

**판정 = 소진 (조건부).** 「전파됐다가 죽은 산출물을 **어떻게** 은퇴시키는가」축은 §5 가 전부 덮는다 — 은퇴 경로 2단(§5.2) · 착지 증명(§5.3) · 이력 처분(§5.4) · 제외와 삭제의 구분(§5.5) · 그리고 그 앞의 「자가 왜 못 보는가」(§5.1).

**잔여 = 판정 축 1개.** 「**언제** 은퇴시키는가」(= 은퇴 여부의 결정)는 §5 가 안 다룬다. 그건 `legacy-cleanup-governance.md`(코드 심볼) + `stale-artifact-tracking.md`(문면) 소관이고, **문서 산출물의 은퇴 판정**은 그 둘 사이에 여전히 명시처가 없다. 후보 8 을 「절차 축」으로 읽으면 소진, 「판정 축 포함」으로 읽으면 잔여 1. ⟹ 내 판정은 **절차 축 소진 · 판정 축은 별 후보로 분리**이고, 최종 개폐는 본인 몫으로 남긴다.

---

## ⑥ §F verify-sync **집행 후** 판독 전문 (②와 짝)

```
[verify-sync] ⚠ git-lock daemon 미활성 (C12 사고 패턴 재발 위험)
  plist 존재하나 load 안 됨 — 수정: launchctl load /Users/yundonghyeon/Library/LaunchAgents/com.coin.git-lock-cleaner.plist
  (--skip-daemon-check 로 본 진단 제외 가능)

═══════════════════════════════════════════════════════
[verify-sync] 4-repo sha 동기 검증
  master:  /Users/yundonghyeon/AndroidStudioProjects/claude-cli-master
  targets: app-foundation toward-product-docs Selfward
  files:   161 (전체)
═══════════════════════════════════════════════════════

═══════════════════════════════════════════════════════
[verify-sync] 요약
  PASS:  161 파일
  DRIFT: 0 (자식 sha ≠ master)
  MISS:  0 (자식 부재 또는 repo 부재)
═══════════════════════════════════════════════════════
[verify-sync] propagation-status.md 갱신 박음 (live 매트릭스 + footer)

[verify-sync] ⚠ 상태문서 부재 참조 (= stale ref · drift 재발 신호):
  - .claude/hooks/check-abbreviation.sh (in protected-file-hashes.md)
  - .claude/rules/abbreviation-policy.md (in protected-file-hashes.md)
  - .claude/rules/code-principles.md (in protected-file-hashes.md)
  - .claude/rules/design-to-code-sync.md (in protected-file-hashes.md)
  - .claude/rules/workflow-core.md (in protected-file-hashes.md)
  → 정정: 해당 .auto-memory 상태문서 본문 갱신 (master cycle)

[verify-sync] PASS — 모든 sha 일치
```
`EXIT=0`

### ⑥-1 짝 비교 (②↔⑥)

| 항목 | BEFORE | AFTER | Δ |
|---|---|---|---|
| files (`CHECK_FILES`) | 165 | 161 | −4 (= 제외 4본) |
| PASS | 161 | 161 | 0 (★변하지 않은 것이 요점 — 제외는 **PASS 를 늘려 성과를 만들지 않았다**) |
| DRIFT | 2 | **0** | −2 |
| MISS | 10 | **0** | −10 |
| exit | 1 | **0** | FAIL→PASS |
| ✗ 행 | 4 | 0 | −4 |

★**소음이 PASS 로 바뀐 게 아니라 질문에서 빠졌다.** PASS 161 무변이 그 증거다.

### ⑥-2 propagate 판독

```
files: 2 개 · targets: app-foundation toward-product-docs Selfward
  ✓ docs/rules/cross-repo-parallel-exec-detail.md  (80935b6c2da9)  × 3
  ✓ .claude/rules/cross-repo-parallel-exec.md      (abbfd7c552a9)  × 3
전체 요약: ok=6 fail=0 · .gitignore patches: 신규 0 / 이미 적용 3
```

★`scripts/propagate.sh` · `scripts/verify-sync.sh` 는 **전파하지 않았다** — 아래 ⑧-3 참조 (전파 분모 밖 + 이미 pre-existing 분기 상태).

---

## ⑦ §8 게이트 15종 — 각 값 / exit

| id | 명제 | BEFORE | AFTER | 판정 |
|---|---|---|---|---|
| **G1** | exclude 4종이 양쪽에 실재 | 0/0 · 0/0 · 0/0 · 0/0 | `CLI-MASTER-SCOPE-SEPARATION` **2/2** · `docs/ops` **2/2** · `stale-sweeps` **3/3** · `workflows` **3/3** | ✅ PASS |
| **G2** | 자가 살아 있다 | 1/2 · 2/2 · 4/2 | 1/2 ✓ · 2/2 ✓ · **5/3** | ⚠ **계수 FAIL · 실질 PASS** (아래 ⑦-1) |
| **G3** | 형제를 안 물었다 | (분모 내) | `docs/architecture/external-dep-abstraction.md` **잔존** · `.github/pull_request_template.md` **잔존** | ✅ PASS |
| **G4** | 분모 차이가 수로 맞음 | 165 | 161 · 차이 **4** · 집합 차 = 의도한 4본 **이름까지 일치** | ✅ PASS |
| **G5** | MISS 소멸 | 10 | **0** | ✅ PASS |
| **G6** | DRIFT 소멸 | 2 (`stale-sweeps` SW) | **0** | ✅ PASS |
| **G7** | before/after 짝 | — | ② + ⑥ 둘 다 전문 박제 | ✅ PASS |
| **G8** | 유령 제거 (`grep -c -e '--include'`) | **1** | **0** | ✅ PASS |
| **G9** | 정책 보존 (`grep -c 'Coin 명시 의무'`) | 1 | **1** | ✅ PASS |
| **G10** | 신설 파일 0 | 42 · 6 | **42 · 6** | ✅ PASS (무변) |
| **G11** | 라우팅 계수 무변 | 1 | **1** | ✅ PASS |
| **G12** | §5 실재 + 근거 병기 (`파일:행` hit) | 0 | **9** (≥4) | ✅ PASS |
| **G13** | kernel 무팽창 | 103 | **104** (pointer 1줄 상한) | ✅ PASS |
| **G14** | 4-repo byte-identical | DRIFT 2 / MISS 10 / exit 1 | **DRIFT 0 · MISS 0 · exit 0** | ✅ PASS |
| **G15** | production 무접촉 | — | 4-repo 전량 **빈 출력** | ✅ PASS |

**14 PASS · 1 조건부(G2)** · 추가 = 보호 5 sha 전량 manifest 일치 (STOP #5 clear) · `bash -n` 양 script OK.

### ⑦-1 ★G2 — 자가 아니라 게이트가 헐거웠다 (§10 마지막 bullet 대로 고치지 않고 보고)

`skills/run-` 계수가 4/2 → **5/3** 으로 올랐다. 원인은 내가 추가한 **주석 2줄**이 run-* 를 **형식 선례로 인용**한 것뿐이다 (§0-B 4 가 그렇게 하라고 요구한 그 인용):

```
propagate.sh   +  #   (루트 STALE-DEBT.md 동형: …) ⟹ .claude/skills/run-* 와 같은 결.
verify-sync.sh +  #   (루트 STALE-DEBT.md 동형: …) ⟹ skills/run-* 와 같은 결.
```

**실질 대조** — run-* 처리 기전 3곳 전량 무변:

| 기전 | 좌표 | 상태 |
|---|---|---|
| verify-sync find 제외 | `verify-sync.sh:132` `! -path '*skills/run-*'` | 무변 |
| propagate C16 cp 가드 | `propagate.sh:148` `.claude/skills/run-*)` | 무변 |
| prune path-glob EXCLUDE | `propagate.sh:188` `PRUNE_EXCLUDE_PATHS=('.claude/skills/run-*')` | 무변 |

⟹ **G2 의 자(`grep -c` 원문자열)가 「기전이 산다」와 「문자열이 늘었다」를 구분하지 못한다.** 같은 판이 §0-B 4 로 「run-* 를 형식 선례로 삼아라」라고 시키면서 §8 G2 로 「run-* 문자열 계수 무변」을 요구하면 두 지시가 서로 배타적이다. 게이트를 고치지 않고 보고한다 — 자를 고치려면 `grep -c "! -path '\*skills/run-\*'"` 처럼 **기전 행**을 세야 한다.

### ⑦-2 ★집행 전부터 green 이던 게이트 (§10 마지막 bullet)

G2 · G3 · G9 · G10 · G11 · G13 · G15 **7종**은 「무변/보존」을 묻는 **불변 게이트**라 집행 전부터 green 이다. 결함이 아니라 성질이고(= 회귀 대조군), 그래서 **before 값을 같이 박제**했다. 다만 이런 게이트는 「집행이 아무것도 안 했어도 통과」하므로, 본 판의 성과를 증명하는 것은 **G1 · G4 · G5 · G6 · G8 · G12 6종**뿐이다 (= 전부 음성→양성 전이 관측).

---

## ⑧ 미측정 / UNKNOWN + §12 3건 답

### ⑧-1 §12-1 — 「MISS 10건」이 근사였다는 자기의심에 대한 답

**cowork 이 맞았다.** `verify-sync` 실판독 = MISS **10** · DRIFT **2** — `test -f` 근사와 정확히 일치했다. 내부 산식도 재현된다: charter 3 + ops 3 + sweeps README (FND·TPD 부재 2) + SWEEP (FND·TPD 부재 2) = 10 MISS · SW 측 2본 = 2 DRIFT.

틀린 것은 MISS 가 아니라 **분모 라벨**이었고, 그건 cowork(163) 도 cli 직전 보고(161) 도 아닌 **165** 다 (①-2). 두 수 다 계산은 맞았고 이름이 틀렸다.

### ⑧-2 §12-2 — `stale-sweeps` 제외가 「sweep 이 전파돼야 하는 경우」를 막는가

**막지 않는다. cowork 판정 유지 — 단 근거는 sha 말고 rule 본문에서 다시 폈다.** `stale-artifact-tracking.md` 전문(93행)을 열어 소유 모델을 확인했다:

| 근거 | 내용 |
|---|---|
| `:46` §4 | 등재 대장 = **`<repo>/STALE-DEBT.md`** (repo 별) |
| `:70` §6 | sweep 산출 = **`<repo>/docs/stale-sweeps/SWEEP-YYYYMMDD.md`** (repo 별) |
| `:63~65` §5 | sweep trigger = **그 repo 대장의** OPEN 누적 / 분기 / 같은 좌표 3 cycle 재발 |
| `:93` §9 | 신설 cycle 이 대장·README 를 **`Selfward/` 에 먼저** 만들었다 (= master 판이 원본이 아니다) |

⟹ sweep 은 **repo 마다 자기 것을 낸다.** master 의 `docs/stale-sweeps/*` 는 master 자신의 산출물이고, 자식에 복사돼야 할 물건이 아니다. sha 4-repo 상이는 결과지 근거가 아니었다 — 근거는 rule 이 처음부터 `<repo>/` 로 쓴 것이다. **STOP 불요.**

### ⑧-3 §12-3 — §E 자리 최적성 (열어 보고 판정)

⑤-1 표 참조. 후보 3본을 전부 열어 주제 적합성으로 판정했고 **cowork 배치와 같은 결론**에 도달했다.

### ⑧-4 ★본 판 무관 잔존 (§7-4 · 흡수하지 않고 목록만)

1. **`protected-file-hashes.md` 의 부재 참조 5건** — `check-abbreviation.sh` · `abbreviation-policy.md` · `code-principles.md` · `design-to-code-sync.md` · `workflow-core.md`. 집행 **전·후 동일**하게 발화. 원인 = `MASTER-CLI-JUDGMENT-SHIFT-001`(2026-07-29 hook/rule 제거) + rule 이동 이후 manifest 미갱신 추정. 처분 = 별 master cycle.
2. **git-lock daemon 미활성** — `com.coin.git-lock-cleaner.plist` 가 존재하나 load 안 됨. 집행 전·후 동일 경고. 본 cycle 중 4-repo 어디에도 `index.lock` 잔존은 없었고 commit 6건 전부 성공. 해소 = `launchctl load …`(사용자 실기).
3. ★**`scripts/{propagate,verify-sync,repo-config}.sh` 의 verify-sync-비가시 분기** — master `aa0f0775`/`d634074f`/`e18f3fc5` ↔ FND·SW `9a5efee2`/`025debbf`/`7b235ab3` · **TPD 는 3본 전량 부재**. 이 3본은 find 진입 root 가 `scripts/agent` 뿐이라 **분모 밖**이고, 그래서 `verify-sync` 가 영원히 침묵한다. **pre-existing 이며 본 판이 만든 것이 아니다** — 그래서 내 §C/§D 편집분도 자식에 전파하지 않았다(전파하면 자식 script 를 분모 밖에서 손대는 것이라 scope 이탈). ★이건 §5.1 이 말한 「분모가 볼 수 있는 것을 정한다」의 **두 번째 실례**다. 처분 = 별 cycle (선택지 = 분모 편입 / 명시적 master-only 선언 / TPD 부재 정합).
4. **`nightly-baseline-report.sh:292` 의 `claude -p` 호출** — A6 / `cross-repo-parallel-exec.md §2.4` 가 회피 default 로 규정한 영역 3. 다만 주체가 cli session 이 아니라 launchd 야간 job 이라 A6 의 M(= cli session spawn 0)에 바로 걸리는지는 **미판정**. 무접촉 · 목록만.
5. **자식 미추적 산출물** — SW `.ai/reports/**` 다수 · TPD `docs/company/*.docx|jpg|pdf` 등. §11 쓰기 경계 밖이라 무접촉.

### ⑧-5 미측정 / UNKNOWN

- **§13 의 「선례 tracked 139 / 디스크 185」가 master 와 안 맞는다.** 실측 master `.ai/reports` = **tracked 416 / 디스크 416 / 미추적 0**. 「직전 판 미추적분도 함께 `git add`」 지시는 master 에서 **집행 대상 0** (이미 전량 tracked). 139/185 가 어느 repo·시점의 수인지 UNKNOWN — 자식 SW 의 미추적 다수(⑧-4 5)를 가리킨 것이라면 §11 밖이다.
- **§C-4(`.github/workflows/*`)의 동작 검증 불가** — 4-repo 전량 0본이라 「제대로 무는가」를 실물로 못 잰다. sandbox 재현(`globtest`)으로 의미만 확인했고, 실환경 대조는 형제 `.github/pull_request_template.md` 잔존 **1건**뿐이다. 정직하게: G1 의 `workflows` ≥1 은 **문면 실재**를 재는 것이지 동작을 재는 게 아니다.
- **`cycle-discipline.md §7`(commit body 6 섹션 필수) ↔ 실제 commit 관행 갈림** — 최근 30 commit 중 `[Goal]` 시작 body **5**건 · `Task:` 줄 **4**건. 본 판은 §7 을 따랐다(6 섹션 + `Task:` + trailer = 합집합). 이건 `stale-artifact-tracking.md §3` 상 **등재 대상**이나 `STALE-DEBT.md` 는 §11 쓰기 허용 밖이라 **등재하지 못했다** — 여기 남긴다.
- **`--prune --apply` 실경로 미실행** — §5.2 가 문서화한 `.claude/**` 자동 삭제 경로는 본 판에서 **실행 대상이 없어** 실측하지 않았다 (= 문서화만 · 동작 검증은 삭제를 포함하는 다음 cycle 몫).

### ⑧-6 ★계약 충돌 1건 — `CLAUDE.md §16-1` vs 발주서 §11 (본인 회수 후 집행)

`CLAUDE.md §16-1` = 「master 의 모든 cli infra 변경은 §15 표에 cycle entry 추가 **의무**」. 본 판은 cli infra 2본을 바꿨으니 대상이다. 그런데 발주서 §11 쓰기 허용 목록에 `CLAUDE.md` 가 없다(= 「그 외 전부」 금지). **문자 그대로는 두 계약이 동시에 만족 불가**라 자동 판단하지 않고 본심을 회수했고, **「§15 entry 추가」로 확정**받아 집행했다:

| 조치 | 내용 | 검증 |
|---|---|---|
| demote | `MASTER-BRAND-TOWARD-INFRA-001` 행을 `.auto-memory/master-cycle-history-COLD.md` §1 표 말미에 **verbatim** 이관 (hot 상한 3 규약) | COLD hit **1** · hot hit **0** = 삭제 0 |
| append | 본 cycle entry (**388 B** ≤ 400 B 상한) | hot entry 계수 **3** 유지 |
| 재전파 | 불요 — `CLAUDE.md` 는 전파 분모 밖 (find root 6종에 부재 · 자식 `CLAUDE.md` 는 자식 고유) | find 대조 hit **0** |

★부수 관측 (무접촉 · §7-4): hot 상한은 「각 ≤400B」인데 **기존 이웃 2본이 이미 초과**한다 — `MASTER-STALE-TRACKING-001` **547 B** · `MASTER-AIDOC-RELEASE-REALIGN-001` **657 B** (`MASTER-BRAND-TOWARD-INFRA-001` 은 395 B 였다). 본 판 entry 는 규약을 지켰다. 이웃 2본 = pre-existing · 본 판 무관 · 정정 안 함.

---

## 부록 — 변경 착지 요약

| repo | commit | 내용 |
|---|---|---|
| claude-cli-master | 1본째 | `scripts/propagate.sh` + `scripts/verify-sync.sh` (§C 제외 4종 + §D 유령 flag 처분) · +55/−3 |
| claude-cli-master | 2본째 | `docs/rules/cross-repo-parallel-exec-detail.md` §5 신설 + kernel pointer 1줄 · +49 |
| app-foundation · toward-product-docs · Selfward | 각 1본 | propagation 수신 2 file · 각 +49 (path-limited commit) |
| claude-cli-master | 3본째 | §G audit — `.auto-memory/propagation-status.md` + 본 REPORT + `CLAUDE.md §15` entry(+demote 1 → COLD) |

진입 대비 자식 **NEW dirty 0** (TPD 1 · SW 2 = 진입 시점 pre-existing 그대로 보존 · 무접촉).

---

고려했으나 hot 제외 영역: `PRUNE_BASE_PATHS` 확장(G-5 불승인) · `.github/workflows/ci.yml` 신설(G-6 불승인) · 자식 `stale-sweeps`/`STALE-DEBT` 내용 정리(G-7 불승인) · `docs/ops/**` 열람(§0-B 9 · 경로만 다룸) · `scripts/*.sh` 3본의 4-repo 분기 해소(⑧-4 3 · 별 cycle) · `protected-file-hashes.md` 부재 참조 5건 정정(⑧-4 1 · 별 cycle) · `STALE-DEBT.md` 등재(⑧-5 · §11 쓰기 경계 밖)
