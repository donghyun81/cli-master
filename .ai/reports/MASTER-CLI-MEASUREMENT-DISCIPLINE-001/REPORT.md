# MASTER-CLI-MEASUREMENT-DISCIPLINE-001 — REPORT

- **Mode**: M5 (cli-infra-ops) · docs-only · production/EF/DB/Money **0 LOC**
- **마감**: 2026-07-26 (KST)
- **원천**: `AUDIT-SELFWARD-SOT-COHERENCE-LEDGER-20260726.md` §8-P + `RULES-CANDIDATES-FROM-CHAT-20260726.md` §A-7/§D-5/§D-7
- **contract**: `cc-paste-MASTER-CLI-MEASUREMENT-DISCIPLINE-001.md`
- **선행**: `MASTER-CLI-RULES-SETTLE-001` (= 19 규칙 정착 · 본 2건 미포함 실측 확인)

---

## §0. BASELINE 재측정 — A1 forward-progress (STOP#1 미발동)

| repo | paste 기대 | 실측 HEAD | 판정 |
|---|---|---|---|
| claude-cli-master | `b5d3def` (ahead 2) | `b5d3def` ahead 2 dirty 0 | ✓ **정확 일치** |
| gently-product-docs | `a17375b` (ahead 3) | `a17375b` ahead 3 dirty 0 | ✓ **정확 일치** |
| app-foundation | `08248c8` | **`6459f45`** ahead 1 dirty 0 | **forward 1** |
| Selfward | `fde306e` (ahead 14) | **`f21a506`** ahead 15 dirty 37 | **forward 1** |

**판정 = A1 forward-progress · STOP#1 미발동.** 근거:

1. **ancestry 실측** — `merge-base --is-ancestor` 4/4 ANCESTOR. FND/SW 의 delta 1 commit = **각각 `6459f45` / `f21a506` = `MASTER-CLI-RULES-SETTLE-001` propagate commit 그 자체** (= paste 자신이 §11 에서 인용한 직전 cycle). 즉 paste §0 이 **전파 이전(= §0 gate 시점) sha** 를 인용했다.
2. **STOP#1 의 실질 조건은 통과** — 조항 문면 = *"§0 sha 불일치 **또는** 대상 rule 이 4-repo byte-identical 아님(= **이미 drift** · 선행 해소 필요)"*. 대상 rule 실측 = **4-repo byte-identical** (아래 §1) → **drift 0** = 조항이 막으려던 상태가 아니다. paste 인용값대로였다면 FND/SW 가 master 보다 **뒤처진 상태** = 실제 drift 였을 것 — **실측이 paste 기대보다 안전한 방향**.
3. **Selfward dirty 37 = 전량 untracked (`??`)** · `docs/rules` + `.claude/` **0 hit** (tracked 수정 0 · staged 0) = 전파 경로 clean.
4. 선례 = `MASTER-T7-INSTRUCTIONS-REALIGN-001` / `MASTER-CLI-RULES-SETTLE-001` §0 gate (= A1 forward-progress → STOP 미발동 → raw 보고).

### 진입 시점 대상 rule 4-repo 동일성 (= STOP#1 실질 조건)

| file | 4-repo sha-256 (진입) |
|---|---|
| `docs/rules/paste-authoring-disk-verification.md` | `9edd66771a118e3a` ×4 (= paste §0 인용값 **일치**) |
| `docs/rules/code-principles.md` | `1f3bd3832d2f1c94` ×4 |
| `docs/rules` aggregate | `52a4f0c0a62614e8` ×4 (n=44) |

---

## §1. paste 전제 재측정 (= §8 "본 paste 도 반증 대상")

### §1 실측 사례 5 — **5/5 substantiated** (1 수치 불일치)

| # | 사건 | 재측정 |
|---|---|---|
| 1 | `probe.ts` 파일명 오분류 | ✓ **이미 disk 박제** — `code-principles.md` §2 실측 사례 3 중 1 |
| 2 | `docs/rules` 경로 소유권 오판 | ✓ **이미 disk 박제** — 동 §2 |
| 3 | `supabase functions logs` 부재 → "채널 전체 없음" | ✓ **이미 disk 박제** — 동 §2 + `supabase-handling.md` §2.10 |
| 4 | staged subset 28 file 위임 → "죽은 경로 13건" | ✓ **verbatim 확인** — `AUDIT-…-20260726.md:63` = *"cowork 가 staged subset 28 file 만 올려 감사관에게 준 결과, "죽은 경로" 오탐 13건이 발생했다. 실 disk 재측정으로 전량 기각"* |
| 5 | `GROUND-TRUTH-*.md` repo 내부 glob 부재 판정 | ✓ **실존 확인** (부모 mount root) · **tracked 0/4 repo** (= paste ★ "pointer 부적격" 근거 성립) · ⚠ **bytes 불일치** |

**⚠ 자진 정정 1 (수치)** — paste §1-#5 = *"실존(부모 mount root · **16,022 bytes**)"*. 실측 = `GROUND-TRUTH-SELFWARD-RECORD-AXES-20260725.md` **17,903 bytes** (mtime `Jul 26 20:54` · 산식 `ls -la` · 근거 ledger mtime `20:18` = **측정 후 file 증가**가 유력). **파일 정체성·결론 불변** (실존 ✓ · tracked 0/4 ✓). 본 수치는 **규칙 본문에 인용하지 않았다** (= 부재 판정의 논리 구조와 무관한 우발 수치 · §8.1 산출 명령 미동반 인용의 실례이기도 함).

### §2 상충 3 — **3/3 CONFIRMED** (1 건은 독립 교차 확인)

| # | paste | 재측정 |
|---|---|---|
| 1 | `SELFWARD-DOCS-ENTRY-REALIGN-001` | ✓ `:126` 요건 7 = *"supersede 배너 신설 — 문서 **상단** 1블록: 구 판 시점(2026-05-18 GD 스냅샷)"* ↔ `:137` xverify = *"`grep -n "GentlyDay\|…"` → **이력 블록 내부에만** hit"* · 이력 블록 = `:100` **문서 말미** ⟹ **동시 충족 불가** |
| 2 | `PDOCS-SOT-COHERENCE-REALIGN-001` | ✓ `:120` S10 대상 = `L3·L8·L12·L51·L85·`**`L99`**`·L131·L156` ↔ `:65` D3 = 「티켓」 zone 보호. ★**독립 교차 확인** — *후행* paste `PDOCS-UPSTREAM-LAYER-EVICTION-001` §2.4 가 **자기 문서에** 박제: *"`96d33c4` cycle 에서 **§3-S10 이 §2.3 D3 zone 과 상충**했다(L99)"* |
| 3 | `PDOCS-UPSTREAM-LAYER-EVICTION-001` | ✓ `:188` ChangeBudget = *"본문 축출(순감) **−120 ~ −40 lines** ★본 cycle 은 **줄어드는 게 정상**"* ↔ `:130` §3-B 규칙 2 = *"**구 문면 = 삭제 0.** `<details>` 또는 status entry 로 verbatim 보존"* + `:190` *"이력 보존 **+140**"* ⟹ **순감 구조적 불가** |

**★재측정이 규칙을 강화한 발견 1** — #3 의 그 paste 는 §2.4 에서 **교차 검사를 실제로 돌리고 "충돌 0" 을 선언**했다 (*"2회 연속 결함 재발 방지 · 본 paste 는 발행 전 교차 검사를 돌렸다 · §3-A 축출 7종 × §2.3 ⓓ 8종 = 충돌 0"*). 그럼에도 #3 이 남았다 — **①(문면×문면)은 통과했고 ②(문면×밴드/수치)를 안 봤기 때문**. ⟹ 규칙 2 본문에 **"①의 통과가 ②의 알리바이가 되지 않는다"** 를 명문화 (= paste ★#3 지적의 실측 뒷받침).

### paste §11 grep 주장 + sha 귀속

- ✓ `grep -rn "전수 트리\|판정 보류\|교차 검사\|제외 표\|부재 판정" docs/rules/` → **0 hit** (진입 시점) = 본 2 규칙 미정착 확인.
- ⚠ **자진 정정 2 (귀속)** — paste §11 = *"`d3fd51e MASTER-CLI-RULES-SETTLE-001`"*. 실측 `d3fd51e` = **gently-product-docs 측 propagate commit**. master content commit = **`d9fd3c1`**. (판정 불변)

---

## §2. ★정착처 재판정 (= paste §3.1 원안 기각 · §FREEDOM 행사)

### 발견 = paste 내부 상충 1건 (**규칙 2 자기 시연**)

paste §3.1 = *"`docs/rules/paste-authoring-disk-verification.md` — 규칙 1·2 **본문 신설**"* (+45 밴드). **disk 실측**:

- 그 file = **17 line thin pointer** · `:3` = *"**본문 단일 SoT** = `.claude/skills/paste-source-authoring/SKILL.md`"* · 본문 **0**.
- **직전 cycle 이 의도적으로 thin 유지** — `:17` (`MASTER-CLI-RULES-SETTLE-001`) = *"본 thin pointer 는 **thin 유지**(= L1-4 단일 SoT paradigm 정합 · **본문 복제 0** · 정착 좌표만 본 이력에 기록)"*.
- 실제 본문 SoT (= skill) 은 paste **§3.3 무접촉** + **§6 STOP#2** (`.claude/skills/` 접촉 = STOP) 대상.

⟹ **§3.1(scope) × §3.3·§6-2(제외) = 충돌 1.** paste §3.4 자가 교차 검사는 *"scope 2종 × 제외 4종 = 충돌 0"* 을 선언했으나, **"지정된 정착처가 본문을 담을 수 있는 file 인가"** 를 보지 않았다. 원안대로 +45 를 그 file 에 쓰면 ① 직전 cycle 의 L1-4 판정을 **1 commit 만에 반전** ② paste §3.1★ 자신의 경고(*"중복 박제 = 재drift 원인"*)를 **위반**.

**처리 = §8 대칭 의무 준수** — 자동 봉합 X · **본 REPORT + paste-back 에 보고** · §3.1★ §FREEDOM(*"더 맞다고 판단되면 근거와 함께 옮겨라"*)으로 **재판정**.

### 재판정 결과 (본문 1곳 + pointer · 중복 박제 0)

| 규칙 | 정착처 | 근거 |
|---|---|---|
| **1. 부재는 전수 트리에서만** | **본문** = `code-principles.md` §2 「부재는 전수 트리에서만 판정한다」 | 그 §의 기존 실측 3 사례 = **paste §1 의 #1·#2·#3 과 동일 사건**. 즉 rule 1 은 새 규칙이 아니라 **같은 절의 *부재* 축**이고, 나머지 2 사례(#4·#5)만 신규다. 다른 file 에 두면 **한 원칙이 두 file 로 쪼개진다**. paste 자신도 *"「표면 속성으로 분류 금지」의 부재 축 확장"* 이라 규정 |
| | pointer = `cycle-discipline.md` §17 (1행) | §17 BASELINE 4-step 이 **전수 트리 전제** 위에서만 유효함을 그 자리에서 고지 |
| **2. paste 발행 전 교차 검사** | **본문** = `cycle-discipline.md` **§31 신설** | authoring 측 canonical(skill)이 STOP#2 로 막혀 있고, 본 규칙은 **cowork 저작 + cli 집행 대칭 의무** 양쪽에 걸림 → `docs/rules/` 본문이 옳다. **§30(ChangeBudget) 바로 뒤** = paste ★#3 의 *"문면 ↔ 밴드/수치"* 축과 **같은 자리** |
| **양쪽** | pointer = `paste-authoring-disk-verification.md` (이력 1행) | **thin 유지** · 정착 좌표만 기록 (= 직전 cycle 선례 그대로 · 본문 복제 0) |

**scope 변화**: paste 2 file → 실제 **3 file**. 추가 1 = `cycle-discipline.md` (= §3.1★ 이 **명시 허용한 재판정 대상**). paste 원 scope file 2 개는 **둘 다 유지**(1 은 본문, 1 은 pointer 로 역할 전환).

---

## §3. 변경 실측

| file | 변경 | 내용 |
|---|---|---|
| `docs/rules/code-principles.md` | **+22 / −0** | §2 「부재는 전수 트리에서만 판정한다」 신설 (= 6 규범 bullet + 실측 사례 2) |
| `docs/rules/cycle-discipline.md` | **+12 / −0** | §31 신설 (6 bullet) + §17 범위 축 pointer 1행 + demote 이력 1행 |
| `docs/rules/paste-authoring-disk-verification.md` | **+1 / −0** | 이력 entry (정착 좌표 2 + thin 유지 판정 근거) |
| **계** | **+35 / −0** | **순수 additive · 삭제 0 · 통째 재작성 0** |

**ChangeBudget 대조** (= §30 3층 분리 자기적용): 문서 cycle 이므로 **① 실코드 0 · ② 주석/KDoc N/A · ③ test 0** · **문서 산문 +35** (= 빈 줄 포함 · 밴드 정의 명시). paste 밴드 = 본문 +45 / pointer+changelog +12 = **+57** ⟹ **실측 +35 = 밴드 내(하회)**. 하회 사유 = rule 1 을 **기존 절 안에** 착지시켜 header/전제 서술 재기술이 불요했고, `cycle-discipline.md` 는 dense 1-line bullet 체를 따랐다.

---

## §4. 검증

| 항목 | 결과 |
|---|---|
| **본문 1곳 + pointer** (중복 박제 0) | ✓ `grep -rn "전수 트리\|판정 보류\|교차 검사" docs/rules/ .claude/` → 본문 2(각 1곳) + pointer 2 · **동일 규칙 본문 2회 박제 0** |
| **`.claude/` 접촉 0** (STOP#2) | ✓ 위 grep 에서 `.claude/` **0 hit** · edit-set = `docs/rules/` 3 file 단독 |
| **4-repo byte-identical** | ✓ **3/3 file × 4 repo 동일** — code-principles `1eb738b2fb80992a` · cycle-discipline `05836ebe130008a0` · paste-authoring-disk-verification `b4ce494dab8097ea` |
| **aggregate 불변식** | ✓ `52a4f0c0a62614e8` → **`0c4090af02e5ebf8` 4-repo 동일** · 산식=`cat docs/rules/*.md \| shasum -a 256` · 환경=bash 3.2.57 · LC_COLLATE=unset(C) · shasum 6.02 · **n=44** (= §8.1 자기적용) |
| **propagate** | ✓ **ok=9 fail=0** (3 file × 3 자식) · **명시 file list** (`--all`/`--prune` **미사용** = STOP#4 준수 · run-* recipe false-orphan 회피) |
| **verify-sync** | ✓ **163 PASS / DRIFT 2 / MISS 6** = T6·T7·S3·SETTLE post-state **동일** ⟹ **신규 drift 0** (본 cycle 3 file = **DRIFT+MISS 0건**) |
| **보호 5 sha drift** | ✓ **0** — manifest **직접 grep 실측 선행** · edit-set ∩ 보호 = **∅** → resync 불요 |
| **production 0 LOC** | ✓ 4-repo 전부 · 변경 확장자 = `.md` 단독 |
| **D-6 커밋 집합 대조** | ✓ **3/3 exact × 3 자식** (`git show --name-only`) · **scope 밖 0** · ★**Selfward untracked WIP 37 무흡수** · **file 단위 명시 pathspec** (디렉터리 pathspec 0 = D-4) |
| **동결 GB/GD/GT** | ✓ **파일·커밋 0** (전파 대상 X · T6) |

**pre-existing (본 cycle 무관 · 자율 해소 X)**: DRIFT 2 = `release-checklist.template.md` FND/PDOCS **P4-lazy** (`RELEASECHECKLIST-LAUNCHGAP-001` 의도적 미전파 · Selfward=✓) · MISS 6 = `CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` + `production-cli-access-tokens.md` **master-only** × 3 자식 · verify-sync stale-ref 5 = `DIET-2-003` 후속 non-blocking.

---

## §5. commit

| repo | sha | 내용 |
|---|---|---|
| claude-cli-master (content) | `9973d10` | 3 rule file |
| app-foundation | `179dc0f` | propagate 3 file |
| gently-product-docs | `a4bbc24` | propagate 3 file |
| Selfward | `044dda3` | propagate 3 file |
| claude-cli-master (audit) | (본 commit) | §15 entry + propagation-status + REPORT |

**push = 하지 않음 (Coin 몫)** · `propagation-reports/` 없음 (= 명시 file list propagate · `report-gen.sh` 미실행 · 선례 S3-001 / SETTLE-001).

---

## §6. 사고

**없음.** (git-lock daemon plist 미load advisory = 비차단 · verify-sync stale-ref 5 = pre-existing.)
★직전 2 cycle 에서 반복된 **zsh word-split pathspec 오류 재발 0** — 자식 commit 을 변수 없이 **literal 인자**로 실행.

---

## §7. 후속 (scope 외 · 보고까지 · STOP#6 준수)

- `billing-rules.md:3` (*"자식 repo (GT/GD/GB)"*) + §9 footer *"6-repo"* topology 어휘 = **T7 이 별 cycle 로 회부한 rules 층 sweep** (본 cycle **무접촉 준수**). `rule-footer-common.md` · `cross-repo-parallel-exec.md` 도 동일 class ("6-repo" 잔존).
- 규칙 2 의 hook enforce (현재 문서 규범 단일) — paste 발행 측이 cowork 라 cli hook 으로는 반쪽.
- `GROUND-TRUTH-*.md` bytes 불일치 (§1-#5) = 우발 수치 · 재측정 갈음.
- push = Coin.

---

## §8. Negative Space (= `anchor-list.md` §4 의무)

고려했으나 hot 제외: **`verification-and-review.md`** (= 규칙 1 의 *"받은 부재 보고는 회수 시 재측정"* 이 `/verify` 층에도 걸리나, **본문 1곳** 원칙상 pointer 조차 4번째 file 을 여는 scope 확장이라 제외 — 해당 의무는 `code-principles.md` §2 본문 bullet 으로 이미 규범화) · **`reporting.md` §8.1 역방향 pointer** (= §8.1 이 이미 `code-principles.md` §2 를 인용 = 링크 기성립 · 중복 불요) · **`.claude/rules/` 신설 0** (= 세션 자동 적재 층 · T1 다이어트 취지 역행) · **`.claude/skills/` 0** (STOP#2) · **동결 GB/GD/GT 0** · **`--prune` 0** · **`scripts/` 로직 0** · **production/EF/DB/Money 0** · **보호 5 sha 0** · **기존 서술 삭제 0** · **rules 층 topology sweep 0**.
