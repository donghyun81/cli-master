# MASTER-CLI-COMPOSITION-RULES-S3-001 — REPORT (paste-back)

> **cycle** = 조합 패러다임 규칙 정착 + 4-repo 전파 · **Mode M5** (cli-infra-ops) · **rule/docs only**
> **repo** = `claude-cli-master` (편집 대상) → 자식 3 propagate
> **초안 원천** = `Selfward/.ai/reports/SELFWARD-SSOT-COMPOSITION-S4-001/REPORT.md §5` (재유도 0 · bash 회수)
> **설계 SoT** = `BLUEPRINT-SELFWARD-DI-COMPOSITION-REDESIGN-20260725.md` S3 (+ S4 흡수)
> **판정 = PASS** · production 0 LOC · 구 서술 삭제 0 · push 0 (Coin 몫)

---

## 요약 (3 줄)

1. **S4 가 STOP 으로 넘긴 편집을 master 에서 끝냈다** — 대상 6 file 이 전량 master 소유임을 실측으로 재확인하고, S4 §5 완성 초안을 **재유도 없이** 적용했다. S4 의 STOP 판정은 옳았다.
2. **A~F 전량 적용 · G 미채택**(= paste 권고 정합 · 근거 §⑽). master content commit `41d7eda` (6 file · +126/-9).
3. **4-repo byte-identical 재일치 증명 완료** — per-file sha 6/6 동일 + `docs/rules` 44-file aggregate `b368fcdbffcdb0e5` 4-repo 동일 + verify-sync **신규 drift 0**.

---

## ⑴ §0 재측정 (+ 4-repo sha)

**HEAD** — paste 기대와 **전량 정확 일치** (STOP #4 미발동):

| repo | paste 기대 | 실측 | 판정 |
|---|---|---|---|
| claude-cli-master | `739ea9f` | `739ea9f` (ahead 1 · dirty 0) | ✓ |
| Selfward | `db1c106` (ahead 9) | `db1c106` (ahead 9 · dirty 27) | ✓ |
| app-foundation | `b1ff997` | `b1ff997` (ahead 2) | ✓ |
| gently-product-docs | `2d762a8` | `2d762a8` (ahead 1) | ✓ |

**진입 시점 4-repo rule sha (본 세션 실측 · 전 repo 동일 확인)**:

| 대상 | 진입 실측 (4-repo 공통) |
|---|---|
| `docs/rules/*.md` (44 file · concat) | `425f4d003eab5c5c` |
| `.claude/rules/*.md` (5 file · concat) | `84ee6331ab086cdc` |
| `docs/agent/architecture/KOIN_DI_BASELINE.md` | `b4cfeb093515b667` |

**★자진 정정 1 (§8 정합 · 실체가 이긴다)** — paste §0-1 이 인용한 aggregate sha 3종
(`b23a8524fe5e7f8f` / `214561870e869189` / `8e0694569c9e17fa`) 은 본 세션에서 **3 가지 방법 어느 것으로도 재현되지 않았다**:

| 방법 | `docs/rules` 결과 |
|---|---|
| concat 후 shasum (본 REPORT 채택) | `425f4d003eab5c5c` |
| per-file `shasum` 목록의 shasum (파일명 포함) | `dd8ba7af8d719fd8` |
| git index blob 목록의 shasum | `fa9bbb41f31a018b` |

→ **불변식(= 4-repo 동일)은 3 방법 전부에서 성립**했다. 따라서 이는 **측정 방법 차이이지 content drift 가 아니다**(STOP 미발동). 본 REPORT 는 **실측값으로 박제**하고 paste 인용값은 채택하지 않는다.

**전파 대상 실측** — `scripts/repo-config.sh:29` `TARGET_REPOS := "app-foundation gently-product-docs Selfward"` (3 자식 · paste §0-2 일치).

**소유권 전제 재확인**(paste §0-1) — 편집 6 file 전량 4-repo sha 동일 = master 소유 cli infra. 자식에서 고쳤다면 drift 사고가 추가될 자리였다. **S4 STOP 판정 = 옳았음이 실행으로 확인**됨.

---

## ⑵ 문서별 변경 요지 (A~F)

### A. `docs/rules/billing-rules.md` (+63 / −8) — **핵심**

- **제목(`:1`)** — `Mock-first paradigm` → **`명시 조합(explicit composition) paradigm`** + Edge Function 영수증 검증 paradigm.
- **§1 전문 재저작** (`:16`~`:36`) — 라이브러리는 계약·구현만 제공하고 **기본 선택을 하지 않는다** / 조합 루트가 모든 seam 을 명시 / **기본값 0 = 누락은 컴파일 오류** / 등록 순서 의존 금지 / **Mock 은 이름을 불러야만** + **debug guard 의무(불변)** / **통짜 mock 금지 = per-seam 의무** / NoOp = 삭제 아닌 **강등** / **★도구는 구조만 본다**.
- **§1.1 supersede 절 신설** (`:37`~`:54`) — 구 서술 **2종 verbatim 보존**(MASTER-BILLING-DOMAIN-ACTIVATE-001 2026-05-10 + FND-BILLING-SEAM-001 2026-06-05) + F1 구조적 원인 판정 + 대체 cycle 명시 + **불변 항목**(mock production 노출 금지 · 잔액 = 서버 단일 진실 · EF 단일 진입점).
- **§1.2 착지 좌표 표 신설** (`:55`~`:77`) — 좌표 5행 + per-seam 4행 + "생성자에 기본값을 추가하는 순간 F1 이 부활한다" 경고.
- **신설 유래 줄(`:4`) 처리** — **삭제하지 않고**(이력) `:5` 에 supersede 표식 1줄 추가: *"위 신설 유래 줄의 Mock-first = 2026-05-10 신설 시점 서술(= 이력 · 삭제 X) · 현행 paradigm = §1 명시 조합 · 현재형 규정 아님"*. (§FREEDOM 판단 — 모순 해소와 이력 보존을 동시에 만족시키는 형식.)
- **`:65` → 현 `:120`** — "본 §1 Mock-first + §2 ..." → "본 §1 **명시 조합** + §2 ...".
- **§10 이력 append** 1행.
- **무접촉**: §2(EF 영수증) · §3(시크릿) · §4(Repository 패턴) · §5(잔액=서버 단일 진실) · §7(STOP) · §8(절대 금지) — 전부 유효.

### B. `docs/rules/code-principles.md` (+22 / −0)

- **§2 말미 "암묵 기본값 금지 — 누락은 컴파일 오류여야 한다" 신설** — foundation 은 계약+구현 제공, 선택은 앱의 조합 루트 / 필수 협력자 기본값 금지 / **★핵심 근거 = DI 검증 도구는 구조적 존재만 본다**(*"structural dependency presence, not semantic correctness"*) → **기본값 제거가 유일한 구조적 방어** / 실증 2(F1 + `GentlyTheme` = 같은 계열 **반대 방향**) / Google 수동 DI 공식 근거(컨테이너 + 생성자 주입 · **`object` 싱글턴 아님**) / **deviation** 조항(의미상 유일 정답일 때만 · 협력자·정책·I/O·결제/권한 경계 적용 금지).
- **§4-C 체크리스트 2행 append** — 암묵 기본값 유무 / 조합 루트 단일 명시 여부.

### C. `docs/agent/architecture/KOIN_DI_BASELINE.md` (+19 / −0) — **★대상 재지정**

- **§5a "foundation ↔ 앱 책임 경계 (= 기본 선택은 앱의 몫)" 신설** — FND = *무엇이 가능한가* · 앱 = *무엇을 쓰는가* / aggregate 기본 인자 금지 / 구 `FND-BILLING-SEAM-001` 서술 **supersede 보존**.
- **재지정 근거(S4 자진 정정 채택)**: 원 paste 지정 `architecture-foundation-link-policy.md` 는 `:3` 에서 단일 목적이 **markdown link 표기 의무**로 선언되어 있어 주제 불일치. `KOIN_DI_BASELINE.md`(*"모든 레포에서 DI 구성을 일관되게 유지한다"* · 4-repo sha 동일)가 정확한 home. 삽입 위치 = §5 뒤 / §6(기존 container 잔존 처리) 앞 — 기존 번호 재배치 0(`5a` 신설로 §6~§7 번호 보존).

### D. `docs/rules/code-style-guide.md` (+2 / −0)

- **§C 가이드라인 절 1항 append** — 클래스 위임 `by` = 상속 없는 조합 + **★Kotlin 공식 주의**(*delegate 는 위임하는 클래스의 `override` 를 보지 못한다* → **"일부만 갈아끼우면 나머지가 따라온다"를 가정하지 말 것**) + 부분 교체 필요 시 **명시 조합**으로 유도. 가이드라인 등급 근거(도구 비강제 + 주관 여지 = 원칙 4) 병기.
- **§F 이력 append** 1행. **하드 규칙 3(C-1~C-3) · 후퇴/탈락 표 · §B pointer 표 무접촉**.

### E. `docs/rules/verification-and-review.md` (+5 / −1)

- **`/verify` §기본 원칙에 "production 바인딩 실체 검증 의무" 신설** — ① **identity assertion**(`assertSame`) + *"타입 assertion 은 기본값 부활을 못 잡는다"*(NoOp 도 정상 타입 · S1 실증) + `assertNotSame`/`assertFalse(x is NoOpX)` 명시 ② **음성 대조**(가드를 깨보고 FAIL 확인 · S0·S2 실증 3/3) + *"통과만 기록된 테스트는 공허한 테스트와 구분되지 않는다"*.
- **REVIEW 12-section §7 판정 기준 1줄 삽입**(−1/+1 = in-place 행 확장) — DI/seam 변경 시 identity assertion + 음성 대조 흔적 · **타입 assertion 단독 = 미충족**.

### F. `docs/rules/libs-versions-cross-verify.md` (+15 / −0) — **채택**

- **§9a 신설** — 현 baseline `koin = "4.0.0"` **실측 박제**(FND + SW `libs.versions.toml`) · 4-repo 동시 검증 절차 · **★플러그인은 F1 을 못 잡으므로 선결 조건 아님 + 안전성 근거가 될 수 없음**("플러그인을 넣었으니 기본값을 되살려도 된다" = 금지된 추론) 명기. **R1~R3 매칭 규칙 + hook 로직 무접촉**(`9a` 신설로 §10/§11 번호 보존).
- **§11 이력 append** 1행.

---

## ⑶ 모순 해소 grep 증명

```
$ grep -n "Mock-first\|NoOp 기본 bind\|billingMockModule" docs/rules/billing-rules.md
4:  > **MASTER-BILLING-DOMAIN-ACTIVATE-001 신설** (… Mock-first 패러다임 …)     ← 신설 유래(이력)
5:  > ⚠ 위 신설 유래 줄의 "Mock-first" = 2026-05-10 신설 시점 서술(= 이력 · 삭제 X) …  ← supersede 표식
40: *"§1 Mock-first paradigm (default · Phase 4 진입 전) …"*                    ← §1.1 supersede 내부
44: *"billingModule = production-safe NoOp 기본 bind · billingMockModule …"*     ← §1.1 supersede 내부
51: `billingMockModule` = **폐기**(실 심볼 0 · 2026-07-26 실측) …                ← §1.1 supersede 내부
157: 2026-07-26 · MASTER-CLI-COMPOSITION-RULES-S3-001 · §1 Mock-first → …        ← §10 이력
```

**절 경계 실측**: §1 = `:16` · §1.1 = `:37` · §1.2 = `:55` · §2 = `:78` · §10 = `:154`.

| 판정 항목 | 결과 |
|---|---|
| **§1 현행 본문(`:16`~`:36`) hit** | **0 건 ✓** |
| **제목(`:1`) hit** | **0 건 ✓** |
| `:40`/`:44`/`:51` 소속 | 전량 **§1.1 supersede 절 내부**(`:37`~`:54`) ✓ |
| `:157` 소속 | **§10 이력** ✓ |
| `:4`/`:5` 소속 | front-matter **신설 유래(이력)** + 명시적 supersede 표식 ✓ |

→ **현재형 규정으로 남은 구 서술 0 건.** (`:4` 는 dated cycle ID 에 귀속된 유래 서술이며 `:5` 가 현행 아님을 명문화 — 삭제 대신 표식을 택한 이유는 additive-ledger 보존.)

## ⑷ 이력 보존 grep 증명

```
$ grep -c "Mock-first paradigm" docs/rules/billing-rules.md              → 1   (≥1 ✓ supersede 인용)
$ grep -c "MASTER-BILLING-DOMAIN-ACTIVATE-001" docs/rules/billing-rules.md → 3   (≥1 ✓ 유래 보존)
$ grep -c "FND-BILLING-SEAM-001" docs/rules/billing-rules.md              → 1   (≥1 ✓ 구 FND 서술 보존)
```

**삭제 라인 −9 전량 in-place supersede 실측** (= "삭제 라인이 크면 이력 삭제 신호" 자가 점검 통과):

| 삭제 | 대체 |
|---|---|
| 구 §1 본문 6행 | §1.1 에 **verbatim 재수록** (문면 소실 0) |
| 제목 1행 | 새 제목 (구 표현은 `:4`/`:5`/§1.1/§10 에 잔존) |
| `:65` 1행 | "Mock-first" → "명시 조합" 1 단어 |
| REVIEW §7 표 1행 | 동일 행 확장 재작성 (기존 문안 전량 보존 + 문장 append) |

→ **이력 삭제 0.**

---

## ⑸ 전파 후 4-repo sha 재일치 증명 (**핵심 검증**)

`propagate.sh` (명시 file list · **`--prune` 미사용**) → **ok=18 fail=0**.

**per-file sha (6 file × 4 repo · 전량 동일)**:

| file | 4-repo 공통 sha | 판정 |
|---|---|---|
| `docs/rules/billing-rules.md` | `8f6c4a2dc79b` | ✓ |
| `docs/rules/code-principles.md` | `de906ed2445b` | ✓ |
| `docs/rules/code-style-guide.md` | `a2527f9b46ed` | ✓ |
| `docs/rules/verification-and-review.md` | `d2e5f7cba720` | ✓ |
| `docs/rules/libs-versions-cross-verify.md` | `eb0bbd798a56` | ✓ |
| `docs/agent/architecture/KOIN_DI_BASELINE.md` | `fe2f2da2da1e` | ✓ |

**aggregate 재일치**:

| 대상 | 진입 (4-repo 동일) | 마감 (4-repo 동일) |
|---|---|---|
| `docs/rules` 44-file concat | `425f4d003eab5c5c` | **`b368fcdbffcdb0e5`** ✓ |
| `.claude/rules` 5-file concat | `84ee6331ab086cdc` | **`84ee6331ab086cdc` 무변동** ✓ (= G 미채택 증명) |

**자식별 diff 0 실측** (master 6 file concat vs 자식 6 file concat): app-foundation ✓ / gently-product-docs ✓ / Selfward ✓ — **diff 0 = 정합 증명**(ChangeBudget 3층 계약 충족).

**verify-sync 실행**: **163 PASS / DRIFT 2 / MISS 6** (exit 1 = 비차단).

- **= T6/T7 post-state 와 동일 → 신규 drift 0.** 본 cycle 6 file 은 DRIFT/MISS 목록에 **부재 = 전량 PASS 실측**.
- DRIFT 2 = `release-checklist.template.md` FND/PDOCS (= `MASTER-CLI-RELEASECHECKLIST-LAUNCHGAP-001` **P4-lazy 의도적 미전파** · Selfward=✓) — **pre-existing · 본 cycle 무관 · 자율 해소 X**.
- MISS 6 = `CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` + `production-cli-access-tokens.md` (master-only) × 3 자식 — **pre-existing**.
- stale-ref 5 (`.claude/rules/*` in `.auto-memory` 상태문서) = `MASTER-CLI-CONTEXT-DIET-2-003` 후속 pre-existing non-blocking.

---

## ⑹ 자식 3 커밋 sha

| repo | commit | files | 흡수 검증 |
|---|---|---|---|
| app-foundation | **`08248c8`** | **6** exact | dirty 0 |
| gently-product-docs | **`24eb03f`** | **6** exact | dirty 0 |
| Selfward | **`624bec1`** | **6** exact | **dirty 27 WIP 무흡수 ✓** (진입 27 → 마감 27) |

전 자식 **path-limited commit**(명시 6 pathspec) · commit body = master `41d7eda` 인용.
master: content `41d7eda` + audit commit(§15 + propagation-status + 본 REPORT).

---

## ⑺ production 확장자 0 · 동결 3 무접촉

- **production 확장자 0 건** — `git diff --numstat | grep -E '\.(kt|kts|ts|sql|xml|java|swift|gradle)$'` → **0**(master) · 자식 3 커밋 = 전량 `.md` 6 file exact. **어느 repo에서도 production 0 LOC.**
- **동결 GB/GD/GT 무접촉** — HEAD 불변 (`a67a5a3` / `912e80a` / `6612e4d` · 전부 2026-07-15 = 본 cycle 이전). **전파 로그에 3 repo 이름 0건**(`TARGET_REPOS` 3 = 기본값 그대로 · `--targets` 미지정).
- **보호 5 file sha drift 0** — edit-set ∩ 보호 5 = **∅ 실측**(`ui-spec.schema.json` / `pencil-uiux-workflow.md` / `pencil-sot-policy.md` / `uiux-sot-refresh.md` / `design-sot-policy.md` 전량 무접촉) → manifest resync 불요. **STOP #5 미발동.**
- **`scripts/` 로직 · 서버/EF/DDL/prod · push = 전량 0.**

## ⑻ `run-*` recipe 보존 (prune 사고 방지)

**`--prune` 미사용**(명시 file list 전파) — 선례 사고(blanket prune 이 repo-local `run-*` recipe 를 false-orphan 으로 `git rm`) 회피.

| repo | `run-*` skill dir |
|---|---|
| claude-cli-master | 1 (보존) |
| app-foundation | 1 (보존) |
| Selfward | 1 (보존) |
| gently-product-docs | 0 (**pre-existing** — 앱 없는 문서 repo · 본 cycle 삭제 0 · 커밋 6 file 에 삭제 항목 0) |

## ⑼ 층별 ChangeBudget 재측정

| 층 | 계약 | 실측 | 판정 |
|---|---|---|---|
| master 규칙 문서 | 5~7 file · 순 **+100 ~ +320** | **6 file · +126 / −9 = 순 +117** | ✓ 범위 내 |
| `.claude/rules/` 신설 | 0~1 file (미신설 권장) | **0 file** | ✓ |
| 자식 3 전파 | master 변경분과 **byte-identical**(diff 0) | **diff 0 × 3** | ✓ |

file 별: KOIN_DI +19/−0 · billing-rules +63/−8 · code-principles +22/−0 · code-style-guide +2/−0 · libs-versions +15/−0 · verification-and-review +5/−1.

## ⑽ F / G 채택 여부와 이유

**F = 채택.** 비용이 작고(+15/−0 · 절차 신설만 · 실 상향 X), 가치의 본체가 **부정 명제**에 있다 — *"Koin Compiler Plugin 은 F1 을 못 잡는다 · 안전성 근거가 될 수 없다"*. 이 문장이 없으면 다음 세션이 플러그인 도입을 안전 조치로 오해해 **기본값을 되살릴 수 있다**(= 본 cycle 의 명제 "규칙이 코드보다 오래 산다"가 정확히 겨냥하는 실패). 현 `koin = "4.0.0"` 실측을 함께 박제해 상향 시점 기준선을 남겼다.

**G = 미채택 (신설 0).** paste 권고 + 실측 근거 3:

1. **비용** — `.claude/` = 세션 **자동 적재** 층(= `rule-routing-table.md` 명시: `.claude/rules/` 잔존 5 = 자동 주입 · Read 불요). 4-repo 상시 토큰 비용이며 `MASTER-CLI-CONTEXT-DIET-2-003`(T1)이 44 rule 을 `docs/rules/` 로 뺀 취지에 정면 역행.
2. **도달성 실측** — 본 cycle 내용은 이미 의무 로드 경로에 있다: `rule-routing-table.md` **Reading Mode 1(구현형)** = `verification-and-review`(L1) + `code-principles`(L2) 의무 · **Mode 3(API-서버형)** = 동일 + `billing-rules`(L3 키워드 trigger). 즉 **DI/seam/결제를 건드리는 모든 mode 에서 이미 도달**한다.
3. **중복 진실 회피** — 신설 시 `code-principles §2` ↔ 신 rule 의 이중 SoT 가 생긴다(`code-style-guide` §C 원칙 1 "양 최소 · 이중 진실 0" 정합).

→ **신설 0 이 낫다**는 paste 판단 그대로. `.claude/rules` aggregate sha **무변동**(`84ee6331ab086cdc`)으로 증명.

## ⑾ 미실행 · 이월

| 항목 | 사유 |
|---|---|
| `billing-rules.md:3` *"자식 repo (GT/GD/GB)"* + §9 footer *"6-repo"* topology 어휘 stale | **의도적 무접촉.** T6 재편(전파 자식 3) 이후의 stale 이나, `MASTER-T7-INSTRUCTIONS-REALIGN-001` §15 가 **"`.claude/rules`·`docs/rules` 층 topology 어휘 sweep = 별 cycle"** 로 이미 회부한 영역. 본 cycle 이 손대면 **STOP #2(scope expansion)** — 6 file 중 4 file 이 같은 stale 을 공유해 sweep 이 본 cycle 을 삼킨다. **별 cycle 몫.** |
| Koin 4.0.0 → 4.2 실 상향 | §9a 는 **절차만** 신설. 실 상향 = 후행 선택 cycle(그리고 §9a 자신이 "선결 조건 아님"을 명기). |
| `propagation-reports/<cycle-id>/REPORT.md` | 미생성 — 명시 file list propagate(`report-gen.sh` 미실행). 선례 = `MASTER-T6-REPO-REALIGN-001` 등 master-only/부분 propagate cycle. 본 `.ai/reports/` REPORT 가 대체 산출물. |
| verify-sync DRIFT 2 / MISS 6 / stale-ref 5 | **전량 pre-existing · 본 cycle 무관 · 자율 해소 금지**(scope 밖). |
| **push** | **Coin 몫.** 순서 = FND `b1ff997` → SW → 본 cycle 분(master `41d7eda`+audit · FND `08248c8` · PDOCS `24eb03f` · SW `624bec1`). |

---

## ⑿ 좌표 실측 9/9 (A5 — 추천·적용 전 disk 검증)

초안을 **그대로 믿지 않고** 인용 좌표를 전수 재측정한 뒤 반영했다(bash 전용 · `Read` 도구로 타 repo 미진입).

| # | 주장 | 실측 | 판정 |
|---|---|---|---|
| 1 | `BillingSeams.kt:39` 기본값 0 | `:39 class BillingSeams(` + 4 파라미터 전량 기본값 없음 | ✓ |
| 2 | `BillingModule.kt:36` | `:36 fun billingModule(seams: BillingSeams): Module` | ✓ |
| 3 | `FoundationKoin.kt:62` 기본 인자 0 | `:62 fun foundationCoreModules(billing: BillingSeams)` | ✓ |
| 4 | `SelfwardAppContainer.kt:61` **class**(object 아님) | `:61 class SelfwardAppContainer(` | ✓ |
| 5 | per-seam 선택 `:144` | `:144 fun selfwardBillingSeams(invoker, entitlementCache, isDebug)` + 선행 KDoc 4-seam 표 문면 일치 | ✓ (좌표 표기만 `:126-131` → `:144` KDoc 로 **정정 반영**) |
| 6 | `mockBillingSeams()` factory 실재 | `BillingSeams.kt:63 fun mockBillingSeams(` | ✓ |
| 7 | **`billingMockModule` 실 심볼 0** | **A7 dual grep** — decl-pattern 1 hit = `BillingModule.kt:14` **KDoc 인용**(` * … val billingMockModule 폐기`) · 유일 non-comment hit = `BillingSeamsTest.kt:74` **assertion 메시지 문자열** · **실 심볼 0 확정** | ✓ |
| 8 | `GentlyTheme` 기본값 제거 | `GentlyTheme.kt:16-19` `colorScheme` / `typography` / `content` **전량 필수 인자** | ✓ |
| 9 | `317f4e8` = S2 commit | `317f4e8 refactor(di)!: SELFWARD-COMPOSITION-ROOT-S2-001 조합 루트 도입` | ✓ |

**초안 보정 = 1 건**(#5 좌표 표기). 그 외 8 건은 초안 그대로 유효 → **재유도 0**(STOP #1 준수).

---

## ⒀ 사고 기록

- **zsh word-split 로 1차 자식 commit 3건 pathspec 오류** — `$P` 변수에 6 path 를 담아 전달했으나 zsh 는 기본 word-split 을 하지 않아 6 path 가 단일 pathspec 으로 해석됨. **결과 = commit 0 · 파일 변경 0 · 인덱스 무변**(에러 3건만 출력). 명시 인자로 즉시 재실행 → 3/3 성공. **부작용 없음.**
- git-lock daemon plist 미load advisory = 비차단(pre-existing · 수정 = `launchctl load …`).
- 그 외 사고 없음.

---

## ⒁ anchor negative space

고려했으나 hot 제외 영역: **A5(disk verification)** = 본 cycle 전 과정 적용(§⑿ 좌표 9/9 + `koin=4.0.0` + `TARGET_REPOS` + 4-repo sha 전량 실측 선행 · paste 인용값 무비판 채택 0) · **A7(filename + content dual grep)** = `billingMockModule` 판정 시 적용(hit 존재로 끝내지 않고 comment/문자열 대 실 심볼 분리 → "실 심볼 0" 확정) · **A1(baseline drift)** = §⑴ 자진 정정(paste aggregate sha 3종 미재현 → 방법 차이로 판정 + 실측 박제) · **A4(단방향 propagation)** = 본 cycle 의 존재 이유(자식 편집 대신 master → propagate) · **A10(책임 경계)** = paste 의 WHAT 을 뒤집지 않고 §FREEDOM 범위(문면·절 배치·supersede 형식·G 판단) 안에서만 자율. 그 외 = (없음).

---

## ⒂ 결론

**규칙이 코드보다 오래 산다** — S0~S2 가 코드에서 F1 을 제거했지만, 그 자리를 비워도 되게 만든 `billing-rules.md §1` 이 남아 있는 한 다음 세션이 규칙을 근거로 되돌릴 수 있었다. 본 cycle 이 그 근거를 제거했다: **기본값 금지 · per-seam 명시 · 도구는 구조만 본다 · identity assertion + 음성 대조**. 그리고 그것을 **4 repo 에 동일하게** 착지시켰다(drift 0).

구 서술은 **하나도 지우지 않았다**(§1.1 supersede + 유래 표식 + 이력 append). 왜 그 규칙이 있었는지, 무엇이 그것을 무효화했는지가 같은 자리에 남아 있다.

`Sources:` `docs/rules/billing-rules.md` §1/§1.1/§1.2 · `docs/rules/code-principles.md` §2 · `docs/agent/architecture/KOIN_DI_BASELINE.md` §5a · `docs/rules/code-style-guide.md` §C · `docs/rules/verification-and-review.md` /verify+§7 · `docs/rules/libs-versions-cross-verify.md` §9a · `CLAUDE.md` §15
