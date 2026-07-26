# MASTER-CLI-RULES-SETTLE-001 — REPORT

> **성격** docs-only · production **0 LOC** · 배포 0 · DB 0 · Money **기전** 0 (규칙 문서만).
> **Mode** M5 cli-infra-ops · **범위** master 편집 → `propagate.sh` 3 자식 (4-repo byte-identical).
> **마감** 2026-07-26 KST · **push 0** (= Coin 몫).

---

## §0. BASELINE (재측정 결과)

| repo | paste 기대 | 재측정 | 판정 |
|---|---|---|---|
| **claude-cli-master** | `5837604` · dirty 0 | **`5837604`** · dirty **0** · ahead 0 | ✅ 정확 일치 |
| Selfward | `1ec4c8e` · ahead 12 | **`fde306e`** · ahead 14 · dirty 35 | **A1 forward-progress** (아래) |
| app-foundation | `08248c8` | **`08248c8`** · dirty 0 | ✅ 일치 |
| gently-product-docs | `96d33c4` · ahead 1 | **`96d33c4`** · ahead 1 · dirty 0 | ✅ 일치 |

**Selfward drift = A1 forward-progress 판정** (STOP #4 미발동):
- `1ec4c8e..fde306e` = **2 commit** — `3d95752`(17:09:31) + `fde306e`(17:10:20) = 동시 세션 `SELFWARD-SUBDIR-ENTRY-REALIGN-002` (`composeApp/CLAUDE.md` + `supabase/CLAUDE.md`).
- **edit-set(`docs/rules` · `.claude/rules`) 접촉 = 0** 실측 (`git log 1ec4c8e..fde306e --name-only -- docs/rules .claude/rules` = 빈 결과).
- dirty 35 = **전량 untracked** (`??`) — `.ai/reports/**/_scratch/` 22 + `cc-paste-*.md` 13. **tracked 수정 0 · staged 0**.

**§0-1 대상 file sha12** — paste 인용 7종 **7/7 정확 일치** (`verification-and-review 10dd5af73f74` · `supabase-handling f567cff5a52e` · `reporting 88146a63254b` · `paste-authoring-disk-verification d33132a53023` · `cycle-discipline 3c3d5ea17a7e` · `code-principles cfa6c498278a` · `billing-rules 2bc697feb901`). 재측정 2종 = `cross-repo-parallel-exec-detail cb1ff4913c87`(314줄) · `.claude/rules/cross-repo-parallel-exec 7eea21948618`(110줄).

### §5-5 STOP (Selfward main checkout) — **미발동 판정 + 근거**

전파 **직전 재측정**(17:33 · 진입 대비 +23분): HEAD `fde306e` **불변**(새 commit 0) · **tracked-dirty 0** · **staged 0** · worktree = main **단독** · 전파 대상 경로(`docs/rules` `.claude/rules` `.claude/skills`) **clean**.
⟹ "main checkout dirty" 의 실질(= 커밋에 쓸려들 tracked WIP) = **0** · untracked 35 = 표준 노이즈(선례 = master §15 `SW dirty = untracked = §0 허용 노이즈`). 잔여 risk 는 **D-3/D-4 자기적용**(file 단위 명시 pathspec)으로 커버 — 결과 = 아래 §6 커밋 집합 대조 **4/4 정확 일치**.

---

## §1. 규칙 19 (13 + 정정 6) 정착 좌표 — **전수 file:line**

### §A — 검증·측정 규율 (7)

| # | 규칙 | 정착 좌표 | 실측 근거 (1줄) |
|---|---|---|---|
| **A-1** | 실 데이터 검증 의무 (빈 계정 금지) + seed 계정 자산화 | `docs/rules/verification-and-review.md:19` | F2 = 기록 **0건 200** / **실 기록 502** — "AI 기능이 한 번도 작동한 적 없다"가 몇 달간 미검출 |
| **A-2** | 성공 경로 관측 가능성 **선행** (관측 → 변경 · 역순 금지) | `verification-and-review.md:21` | ②가 같은 3 시도를 **성공 1 · 실패 2** 로 원장에서 실제로 갈랐다 |
| **A-3** | 외부 응답 검증 실패 = 진단 로그(분기 식별자 + 발췌 상한 + 에러) **+ 마스킹 의무** | `verification-and-review.md:23` **+** `supabase-handling.md:328` (§11.4 EF 측) | **A1 로그 1개**가 F2 의 미지를 **한 cycle 안에** 닫았다 |
| **A-4** | EF 로그 = Management API **`logs.all`** (동일 PAT · `function_logs`/`function_edge_logs`/`edge_logs`) · 콘솔 = fallback | `supabase-handling.md:76` (**§2.10 신설**) | `supabase functions logs` **부재 실측**(v2.98.2) → cowork 가 "콘솔만 가능" 오단정 |
| **A-5** | 수치 인용 = **산출 명령** 동반 | `reporting.md:193` (**§8.1 신설**) | 명령 없는 수치 = 재현 불가 = `[CONFIRMED]` 미달 |
| **A-6** | ChangeBudget **3층 분리**(실코드/주석·KDoc/test) · 실측 대응은 초과 아님 | `cycle-discipline.md:131` (**§30 신설**) | 5회 연속 초과 · 초과분은 매번 paste 자신이 요구한 문서·test |
| **A-7** | **표면 속성(이름·경로·도구 존재)으로 분류하지 않는다 — 불변식을 잰다** | `code-principles.md:79` | `probe.ts` 오분류(유일 Money probe 폐기 직전) · `docs/rules` 경로 오판(4-repo drift 직전) · `functions logs` 부재 |

**★정정 강화 2**

| # | 강화 | 좌표 |
|---|---|---|
| **A-5′** | **환경**까지 동반(shell / `LC_COLLATE` / 해시 도구 / glob 범위 `n`) · **aggregate 해시 = 정체성 아닌 drift 검출기** · 재현 대상 = "한 실행 안에서 N-repo 동일" **불변식** · 불일치 = **먼저 환경 차이 의심** · 산식 교체 시 박제 의무 | `reporting.md:198` · `paste-source-authoring/SKILL.md` §4.6 |
| **A-6′** | 밴드가 **분류 기준을 직접 말한다**(주석·KDoc·빈 줄 포함 여부 · 정의 없는 밴드는 스스로를 위반) + ★**재작성 file 은 라인 밴드에서 빼고 "재작성 N + 사유"로 별도 보고**(`numstat` 은 **재작성을 재지 변경을 재지 않는다**) | `cycle-discipline.md:135` |

### §B — Money (3 + 신설 1) · `billing-rules.md` **§5a 신설**

| # | 규칙 | 좌표 | 근거 |
|---|---|---|---|
| **B-1** | **`settle-after-success` = 기본** · `deduct-first` = 예외 + **사유 기재 의무** | `billing-rules.md:118` (§5a.1) | 같은 3 시도 = 구 판 **3 차감/결과 1** → 신 판 **1 차감/결과 1** (원장 실증) |
| **B-2** | **모호하면 차감하지 않는다** (under-charge < over-charge) + `skipped_ambiguous` 계측 | `billing-rules.md:124` (§5a.2) | `consume_ticket` 멱등 키 부재 |
| **B-3** | degrade = **내용 규칙 위반 경로 한정** (`MEASURE_LEAK` 존치 · **parse 실패 = 재시도가 정답**) | `billing-rules.md:130` (§5a.3) | A4 불채택 확정 |
| **B-4** | ★**신설** — 금전 변동 RPC 는 **멱등 fence** 를 갖는다. 없으면 rule 에 적고 **호출측이 재시도하지 않는다** | `billing-rules.md:135` (§5a.4) | 같은 파일 안 비대칭: `grant_ad_credit` PK dedup ✓ · `credit_purchase` `external_id` UNIQUE ✓ · **`consume_ticket` 만 부재** ✗ |

★**B-4 가 드러낸 것** — 구 `ConsumeFailed` 주석 *"차감 0 → 재시도 안전"* = **알 수 없는 것을 단언**(서버 커밋 후 응답 유실 = 차감됐는데 재-consume = 이중 과금). ②가 **과다 → 과소 청구**로 뒤집었다. 미도입 멱등 키 = `skipped_ambiguous` **계측치와 함께** 재판정(현재 실측 **0건**) — 본문에 명기.

### §C — AI/EF 계약 (3) · **소유 판정 = master** → `supabase-handling.md` **§11 신설**

| # | 규칙 | 좌표 | 근거 |
|---|---|---|---|
| **C-1** | JSON 계약에서 verbatim 인용 지시 시 **JSON-안전 인용부호(낫표 「」) 명시** | `supabase-handling.md:308` (§11.1) | F2 주 원인 — **프롬프트 자신의 verbatim 지시**가 raw `"` 유도 → 조기 종료 |
| **C-2** | ★**정정본** — 절단 감지 = **`stop_reason`(직접 신호) 1차** · `outputTokens>=maxTokens`(대리) = **취득 실패 시 폴백 전용** · **OR 금지**(취득했는데 `max_tokens` 아니면 정상 종료로 믿는다) · 로그에 `maxTokens` 동봉 | `supabase-handling.md:314` (§11.2) | 초안은 **대리 신호를 규칙으로 적으려 했다** = **§A-7 과 정면 충돌** · SDK 0.30.0 실취득 확인(배포 후 **23/23**) |
| **C-3** | 길이 절단·정규화는 **파싱 후 추출된 필드에** · 파싱 전 절단 금지 | `supabase-handling.md:322` (§11.3) | `MAX_OUTPUT_CHARS 5000` 선절단 → 초과 시 **100% 파싱 실패** |

### §D — ★★병렬 판정 기준 **정정** (본 cycle 핵심) · `cross-repo-parallel-exec-detail.md`

**정정 표식 = `:84`** (구 `:83` 본문 **바로 아래** · 구 문면 **무삭제**) · **본문 = `:99` §2.1.6 신설** · **kernel 동기화 = `.claude/rules/cross-repo-parallel-exec.md:28`**.

| # | 정착 | 좌표 |
|---|---|---|
| **D-1** | 판정 기준 정정 — file 겹침 = **필요조건이지 충분조건 아님** · **공유 자원 = `git index`**(repo 당 1개 · `add`→`commit` 비원자적) · 같은 repo 2+ workstream = **격리 의무** | `:107` |
| **D-2** | 영역 1.5(worktree) **"가능" → 같은 repo 병렬 시 「의무」 승격** (§2.1.5 표 ① 행 + kernel 1-bullet 동기화) | `:108` (+ `:53` 표 ① · kernel `:28`) |
| **D-3** | `git commit -- <pathspec>` = index 우회 **보조** · ★**HEAD 에 없는 신 file 에는 안 먹는다 = 반쪽** | `:109` |
| **D-4** | **디렉터리 단위 pathspec 금지 · file 단위 명시만 유효** | `:110` |
| **D-5** | **복구 절차는 절대 sha 로** — `HEAD~N` 은 문서가 쓰인 순간부터 부패(실측: `HEAD~1` 이 **남의 커밋**을 가리켰다) | `:111` |
| **D-6** | paste-back 회수 = **커밋 file 집합 대조 의무**(`git show --name-only <sha>` vs paste §2 scope) | `paste-source-authoring/SKILL.md:133` (§4.5) + detail `:112` |

**정정의 본질 (= paste §3-2 요구)**: `:84` 에 *"**★본 행의 판정 기준은 틀렸다**"* 를 명시하고 **왜** 틀렸는지(file ≠ 공유 자원)를 남겼다. 근거 = 2026-07-26 Selfward **3 cycle 동시 진행 · file 겹침 0 · 현행 규칙 전부 준수 · 그런데 커밋 오염 9건**. 대조 실측 = 격리 **없음** 오염 **1회** vs worktree 격리 **있음** 오염 **0회**(타 세션이 `gently-product-docs` 에 16:34 커밋했음에도 커밋 집합 정확히 24+1 · self-clean orphan 0).

---

## §2. §C 소유 판정 — **3 기준 실측** (경로로 판정하지 않음 · A-7 자기적용)

| 기준 | 측정 | 결과 |
|---|---|---|
| ① **4-repo byte-identical** | `git hash-object docs/rules/supabase-handling.md` × 4 repo | `f567cff5a52e` **× 4 동일** ✅ |
| ② **자기 선언** | `supabase-handling.md §8` 변경 정책 | → `rule-footer-common.md` (*"cli infra 권장 byte-identical · master cycle + propagation · **자식 repo 직접 수정 금지**"*) ✅ |
| ③ **`propagate.sh` 전파 경로** | `scripts/propagate.sh:99` scan set | `find .claude docs scripts/agent .ai/promptfit .ai/uiux-sot/refresh .github` → `docs/rules/**` ⊂ `docs` ✅ |

⟹ **master 소유 확정** (3/3 PASS) → §C 3 규칙 = `supabase-handling.md` **§11** 정착. **§5-7(Selfward 전유 시 REPORT 초안만) = 미발동.**
동반 판정: `.claude/skills/paste-source-authoring/SKILL.md` = `a0dfdb70f110` × 4 동일 + `.claude` ⊂ scan set ⟹ **master 소유** (D-6/A-5′ 정착처로 채택).

---

## §3. 전파 전 / 후 **4-repo 동일성** (§0-2 규약 · 산식 + 환경 병기)

**산식** `cat <repo>/docs/rules/*.md | shasum -a 256 | cut -c1-16`
**환경** `bash 3.2.57(1)-release` · `LC_COLLATE="C.UTF-8"` · `shasum -a 256` · `n=44`

| 시점 | master | app-foundation | gently-product-docs | Selfward | 불변식 |
|---|---|---|---|---|---|
| **전파 전** | `b368fcdbffcdb0e5` | `b368fcdbffcdb0e5` | `b368fcdbffcdb0e5` | `b368fcdbffcdb0e5` | ✅ **4-repo 동일** |
| **전파 후** | `52a4f0c0a62614e8` | `52a4f0c0a62614e8` | `52a4f0c0a62614e8` | `52a4f0c0a62614e8` | ✅ **4-repo 동일** |

**★A-5′ 자기적용 — paste 인용값(`ecda33841b2f1c32`) 과 다름**: 본 세션 실측은 전 · 후 모두 `ecda3384…` 를 재현하지 않았다. 그러나 **불변식(= 한 실행 안에서 4-repo 동일)은 전 · 후 양쪽에서 성립**했다. §0-2 규약대로 **hex 가 아니라 불변식**이 판정 대상이므로 **통과**로 판정하고, 사용한 **산식 + 환경을 위에 박제**한다. (참고: 전파 전 값 `b368fcdbffcdb0e5` = 직전 master §15 `MASTER-CLI-COMPOSITION-RULES-S3-001` 이 박제한 값과 **일치** — 즉 본 산식·환경 조합은 master 이력과 연속적이다.)

**per-file 4-repo sha12** (본 cycle 10 file · `git hash-object` · **10/10 동일**):
`cross-repo-parallel-exec.md 0b256b69775e` · `paste-source-authoring/SKILL.md 3caa9fa24d49` · `billing-rules.md 76e7c4682e88` · `code-principles.md 44abb9967462` · `cross-repo-parallel-exec-detail.md c5c53d0c4907` · `cycle-discipline.md ffb0bfa04dbe` · `paste-authoring-disk-verification.md 0cf424e2fc09` · `reporting.md 3494d1e15817` · `supabase-handling.md c634df1da629` · `verification-and-review.md f55ab2eb8308`

---

## §4. ChangeBudget (★분류 기준 명시 = **A-6′ 자기적용**)

| 층 | **세는 법 (= 분류 기준)** | 밴드 | 실측 | 판정 |
|---|---|---|---|---|
| rule 본문 | `git show --numstat` 전량 — 문서이므로 **주석/실코드 구분 없음** · **빈 줄 포함** · markdown 표 행 1 = 1 line | 순 **+150 ~ +320** | **+166 / −5 = 순 +161** | ✅ 밴드 안 |
| **재작성 file** | 통째 재작성한 file 수 + 사유 | **0 기대** | **0** | ✅ (전 file 기존 본문 잔존) |
| production | — | **0** | **0 LOC** (`.kt`/`.ts`/`.sql`/`.pen`/migration 0건) | ✅ |

**−5 라인의 정체 = 통째 재작성 아님 · in-place supersede 5건** (원문을 그 자리에서 확장하며 **verbatim 보존**):

| # | file | 삭제 라인 | 보존 |
|---|---|---|---|
| 1 | `cross-repo-parallel-exec.md` | 영역 1.5 bullet | ✅ 원문 + D-2 승격 문구 append |
| 2 | `cross-repo-parallel-exec-detail.md` | §2.1.5 표 ① 행 | ✅ 원문 + D-2 승격 append |
| 3 | `supabase-handling.md` | §2.1 `functions logs` 행 | ✅ 원문 + supersede 표식 append |
| 4 | `supabase-handling.md` | §4.4 `functions logs --tail` 행 | ✅ 원문 + supersede 표식 append |
| 5 | `supabase-handling.md` | §10.3 표 EF log tail 행 | ✅ 원문 + supersede 표식 append |

**검증 명령** = 삭제 5 라인 각각의 60자 prefix 가 added 라인에 존재하는지 대조 → **5/5 PRESERVED** (= additive-ledger · **기존 서술 삭제 0** · §5-2 STOP 미발동).

---

## §5. 요구 결과 (§3) 대조

| # | 요구 | 결과 |
|---|---|---|
| 1 | 13 + 정정 6 = **19 정착** · 기존 서술 **삭제 0** · 충돌 시 supersede + 원문 보존 | ✅ **19/19 좌표 확보**(§1) · 삭제 5 전량 in-place supersede 보존 · `billing-rules §1.1` 형식 준용 |
| 2 | ★§D 는 "추가"가 아니라 **"정정"** — `:83` 이 **틀렸다**는 사실 + **왜**(file ≠ 공유 자원) | ✅ `:84` 정정 표식 + `:99` §2.1.6 본문 + kernel `:28` 동기화 |
| 3 | 각 규칙에 **실측 근거 1줄** | ✅ 19/19 (§1 표 우측 열 = 본문에도 각 항 말미 인라인) |
| 4 | 전파 후 4-repo 동일성 (한 명령·한 환경 · 산식·환경 병기) | ✅ §3 (전 `b368fcdb…` / 후 `52a4f0c0…` · 양쪽 4-repo 동일) |
| 5 | **동결 GB/GD/GT HEAD 불변** 실측 | ✅ `a67a5a3` / `912e80a` / `6612e4d` = §0 baseline **정확 일치** · dirty 104/74/70 **불변** · **파일·커밋 0** |

---

## §6. 커밋 file 집합 = §2 scope 대조 (**D-6 자기적용**)

`git show --name-only <sha>` vs paste §2 scope(10 file) — **4/4 정확 일치 · scope 밖 0**:

| repo | commit | 집합 |
|---|---|---|
| claude-cli-master | `d9fd3c1` | **10/10 exact** |
| app-foundation | `6459f45` | **10/10 exact** |
| gently-product-docs | `d3fd51e` | **10/10 exact** |
| Selfward | `f21a506` | **10/10 exact** — ★**untracked WIP 35 무흡수** 실증 |

**자기적용 방식** = D-3 + D-4 준수: `git commit -- <file × 10 명시>` (**디렉터리 pathspec 0**). 전 10 file 이 HEAD 에 실재(= byte-identical cli-infra) → D-3 의 "HEAD 없는 신 file" 한계 **미해당**.

---

## §7. 검증 종합

| 항목 | 결과 |
|---|---|
| `propagate.sh` | **ok=30 fail=0** (10 file × 3 자식) · `--prune` **미사용**(명시 file list · run-* recipe 보존) |
| `verify-sync.sh` | **163 PASS / DRIFT 2 / MISS 6** = 직전 post-state(T6·T7·S3) **동일** ⟹ **신규 drift 0** |
| 본 cycle 10 file | verify-sync DRIFT + MISS **0건** (= 전량 PASS) |
| DRIFT 2 (pre-existing) | `docs/templates/release-checklist.template.md` FND `30fc93967106` + PDOCS `30fc93967106` ≠ master `e6c62fb280f4` = **P4-lazy 의도적 미전파**(`RELEASECHECKLIST-LAUNCHGAP-001`) · **Selfward = ✓** |
| MISS 6 (pre-existing) | `CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` + `docs/ops/production-cli-access-tokens.md` = **master-only** × 3 자식 |
| **보호 5 sha drift** | **0** — manifest **직접 grep 실측** 후 대조: `8502c014…` / `31c0da56…` / `92a5e998…` / `2bfc81c5…` / `202d3f4f…` 전부 baseline 일치. **edit-set ∩ 보호 5 = ∅** ⟹ manifest resync **불요** |
| production | **0 LOC** (4-repo 전부) |
| 동결 GB/GD/GT | **파일 · 커밋 0** (§5 표) |
| commit 자기 검증 (§9) | subject 1 task-id · body **6-section 전량**(`[Goal][Diff][Sha][EC][Next][Refs]`) |
| **push** | **0** (= Coin 몫 · §5-6) |

**A-4 근거 재실측** (본 cycle 자체 수행): `supabase functions --help` → available = `delete` `deploy` `download` `list` `new` `serve` **6종** · **`logs` 부재 확인**(CLI `v2.98.2`). ⟹ 규칙을 **문서에서 인용**하지 않고 **도구에서 측정**했다.

---

## §8. 사고 / 이탈

- **자식 commit 1차 pathspec 오류 3건** — `$FILES` 변수 전달이 zsh 에서 **word-split 되지 않아** 전체 문자열이 단일 pathspec 으로 해석. **commit 0 · 파일 변경 0**(3 자식 HEAD baseline 불변 실측 후) → **명시 인자 재실행 즉시 성공**. 동일 선례 = master §15 `MASTER-CLI-COMPOSITION-RULES-S3-001`.
- **비차단 pre-existing**: `verify-sync` stale-ref 5 (= `.auto-memory` 상태문서가 `.claude/rules/` 구 경로 참조 · `MASTER-CLI-CONTEXT-DIET-2-003` 후속) · git-lock daemon plist 미load advisory.

## §9. §FREEDOM 행사 (배치 판단 · paste §4)

1. **A-4 배치** — paste 지정 `§3.1`(= Production apply · 승인 게이트 영역) 대신 **`§2.10` 신설**(= CLI 자동 처리 영역). 근거: EF 로그 조회 = **read-only** = 승인 게이트 대상 아님. §3.1 과의 연결(= **동일 PAT**)은 §2.10 본문에 명시하여 paste 의도 보존.
2. **A-5′ / D-6 배치** — paste 지정 `paste-authoring-disk-verification.md` 는 **16줄 thin pointer**이고 **본문 SoT = `.claude/skills/paste-source-authoring/SKILL.md`** (자기 선언 · L1-4 단일 SoT). 본문을 pointer 에 넣으면 그 file 이 선언한 단일 SoT paradigm 을 스스로 위반하므로 **skill body 에 정착**(§4.5 · §4.6)하고 pointer 에는 **정착 좌표 1줄만** 기록. **= A-7 자기적용**(경로라는 표면이 아니라 "본문이 어디 사는가"라는 불변식으로 판정).
3. **§B 배치** — `billing-rules.md` **§5a 신설**(§5 entitlement 직후 · §6 앞). 기존 §1~§8 **무접촉**.
4. **supersede 표기 형식** — 3 곳 stale(`§2.1` · `§4.4` · `§10.3`)은 **원문 무접촉 + ⚠ 마커 append** 로 통일(1차 시도의 `~~취소선~~` 은 원문 연속성을 끊어 **철회**).

---

## §10. Negative Space

production/EF/DB/Money **기전** 0 · 보호 5 sha 0 · 기존 서술 삭제 0 · 동결 GB/GD/GT 0 · `--prune` 0 · `scripts/` 로직 0 · `.pen`/migration 0 · 자식 `docs/rules` 직접 편집 0(= 전량 `propagate.sh` 산출) · `billing-rules §1~§4·§6~§8` 0 · `supabase-handling §1·§3·§5~§7·§10 본문` 0 · rules 층 topology 어휘 sweep 0(= T7 이 별 cycle 로 회부 · STOP #2 준수).

**고려했으나 hot 제외 영역**: ① `billing-rules.md:3` *"자식 repo (GT/GD/GB)"* + §9 footer *"6-repo"* topology stale (= T7 회부분 · 본 cycle 접촉 = STOP #2) ② `rule-footer-common.md` 의 "6-repo" 문면(동일 class) ③ D-2 승격의 **hook enforce**(= 현재 문서 규범 단일 · 자동 차단 미신설) ④ `consume_ticket` 멱등 키 **실 도입**(= B-4 는 rule 만 · 구현 = 별 cycle · `skipped_ambiguous` 계측치 동반 재판정).
