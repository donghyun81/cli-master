# MASTER-CLI-RULES-TOKEN-SLOT-WRITER-001 — REPORT

> Mode **M5** (CLI 운영 레이어형) · 2026-08-03 KST · contract = `cc-paste-MASTER-CLI-RULES-TOKEN-SLOT-WRITER-001.md`
> 성격 = **docs-only** · production **0 LOC** · migration 0 · EF 0 · test 0 · **토큰 값 접촉 0**
> 선행 = `ADR-0002-SERVER-WRITE-PATH-BEYOND-SYNC.md`(부모 root) **존재 확인 ✓ 9,420B · Accepted 2026-08-02** → §2-3 C **BLOCKED 아님**

---

## 1. baseline ↔ 착지 (4-repo HEAD)

| repo | 진입 HEAD | 진입 ahead / `-uno` | 착지 HEAD | 착지 ahead / `-uno` |
|---|---|---|---|---|
| `claude-cli-master` | `b8e2283` | 20 / **0** | **`a8f49ac`** | 21 / 0 (→ audit commit 후 재측) |
| `app-foundation` | `53ee7ee` | 3 / **0** | **`8a86f19`** | 4 / **0** |
| `gently-product-docs` | `90010a5` | 5 / **0** | **`31c1c65`** | 6 / **0** |
| `Selfward` | `140dd8c` | 13 / **0** | **`014660e`** | 14 / **1** ⚠ (= **본 cycle 무관** · §4-2) |

진입 baseline = paste §0 표와 **4/4 전량 일치** (= 재측정 결과 mismatch 0).
`Selfward` `HEAD~1` = **`140dd8c`** = 진입 baseline 일치 (= 내 commit 이 남의 commit 위에 얹히지 않았음 확증).

### 대상 3 file sha (`git hash-object` · 4-repo)

| file | 진입 (4/4 공통) | 착지 (4/4 공통) | 판정 |
|---|---|---|---|
| `docs/rules/supabase-handling.md` | `08d9a67034cb` | **`06980be515c8`** | 변경 ✓ · distinct sha **1** |
| `.claude/rules/safety-and-secrets.md` | `febc86f98c6f` | **`ed55bfae2584`** | 변경 ✓ · distinct sha **1** |
| `docs/agent/architecture/SERVER_DATA_OWNERSHIP.md` | `7d4c0a133003` | **`686fee3c19e1`** | 변경 ✓ · distinct sha **1** |

line 수: 333→**368** / 202→**212** / 212→**225**.

---

## 2. 처분 12 전량 1:1 (§2 처분표 = 좌표 단일 SoT)

### A. `docs/rules/supabase-handling.md` (7/7)

| # | 지시 좌표 | 착지 좌표 | 판정 |
|---|---|---|---|
| **A1** | `:246` 문장 끝 정정 추가 | **`:249`** (동일 행 · diff hunk `-246 +249` = 1 line 치환) | ✅ 구 문면 **무삭제** — 「wrap script … `SUPABASE_ACCESS_TOKEN_{GB,GD,GT}` env var inject 통합 … 자식별 진입 시점 (= 사용자 본인 terminal 또는 cli session 내부):」 전량 생존 + 뒤에 정정 병기 |
| **A2** | `:249` env 간접 예시 대체 | **`:252`** (`# ★CLI 명령 경로 = slot 직독`) | ✅ slot 직독형 · ref `pdaqmzmgotwodyokdkhn` (Selfward staging) |
| **A3** | `:250-251` alias 대체 + repo 밖 명시 | **`:256`**(alias 신형) · **`:259-261`**(구 판 보존 블록 주석) | ✅ `~/.zshrc` = **repo 밖 → Coin 손** 명시 · 구 2줄 = 주석으로 **생존** |
| **A4** | `:278` §10.5 staging 행 | **`:288`**(활성 신행) + **`:289`**(구 행 폐기 표식) | ✅ 삭제 0 · **prod 행 무접촉**(diff hunk = `-278 +288,2` = 1행→2행 · prod 행 미포함) |
| **A5** | `:301` 뒤 §10.8 신설 | **`:313`** (`### §10.8`) | ✅ §10.7 끝 ↔ `---` 사이 · 24 line |
| **A6** | §9 이력 1 entry append | **`:226`** (표 맨 아래) | ✅ 기존 4 entry 무접촉 |
| **A7** | `:195` 뒤 trigger 2줄 | **`:196`**(`SUPABASE_ACCESS_TOKEN_SELFWARD`) · **`:197`**(`401 / Unauthorized / 토큰 만료 / PAT 재발급`) | ✅ **`:195` 자체 무접촉**(diff hunk `-195,0 +196,2` = 순수 삽입) |

### B. `.claude/rules/safety-and-secrets.md` (2/2)

| # | 지시 좌표 | 착지 좌표 | 판정 |
|---|---|---|---|
| **B1** | `:104` 뒤 · `miss 정책` 앞 | **`:106`** (`★env 주입 값 = 기동 시점 스냅숏 · Keychain slot = SoT`) · 9 line | ✅ slot 명세 bullet 2 무접촉 · `miss 정책` 앞 착지 |
| **B2** | `:137` 뒤 bullet 1 | **`:147`** | ✅ 기존 4 bullet 무접촉 (4→5) |

### C. `docs/agent/architecture/SERVER_DATA_OWNERSHIP.md` (3/3 · ADR-0002 선행 충족)

| # | 지시 좌표 | 착지 좌표 | 판정 |
|---|---|---|---|
| **C1** | `:163` 뒤 §5-1 신설 | **`:165`** (`### 5-1.`) · 12 line | ✅ §5 기존 bullet 4 **무접촉** · `---` 앞 |
| **C2** | `:202` 뒤 체크박스 1행 | **`:215`** (= 구 `:202` 「왕복이 1쌍인가」 **직후**) | ✅ 좌표 준수 — ⚠ paste 괄호 서술과 불일치 (§4-3) |
| **C3** | `:5` ADR-0002 병기 | **`:5`** | ✅ 구 문면(「변경은 새 ADR 로 한다 — 이 file 을 직접 고쳐 덮지 않는다(§9).」) **무삭제** · 문장 뒤 병기 |

### D. 전파 (2/2)

| # | 결과 |
|---|---|
| **D1** | `propagate.sh` **literal 인자** 형태로 실행 (= zsh word-split 3회차 선례 `incident-log:526` 회피 · 변수 미경유) → **ok=9 / fail=0** (3 file × 3 자식) · `files: 3 개` 정상 파싱 확인 |
| **D2** | 4-repo `git hash-object` 재대조 → 3 file 전량 **distinct sha = 1** (= 4/4 byte-identical) · 진입 sha 와 **전부 상이**(= 편집 반영 확증) |

**처분 12/12 + D 2/2 = 전량 착지. 미이행 0 · BLOCKED 0.**

---

## 3. V1~V10 실측값 (기대치 아님 · 실제 출력)

| # | 검증 | 기대 | **실측** | 판정 |
|---|---|---|---|---|
| **V1** | 4-repo `-uno` | 편집 파일만 | master `M .auto-memory/propagation-status.md`(= verify-sync 자동 산출 · §4-5) / FND **0** / PDOCS **0** / **SW 1** (= `strings.xml` · **본 cycle 무관** · §4-2) | ⚠ 설명됨 |
| **V2** | 처분 개수 | A 7 · B 2 · C 3 = **12** | **A 7 · B 2 · C 3 = 12** | ✅ |
| **V2b** | §6 trigger 블록 줄 수 | 16 → **18** | 진입 **16** → 착지 **18** | ✅ |
| **V3** | 구 문면 생존 (`SUPABASE_ACCESS_TOKEN_GB`) | 원 좌표 `:195`/`:249`/`:251` **3 전량 생존** | `:195`(**무접촉 원위치**) · `:260`(구 `:249` 문면 = 블록 주석) · `:261`(구 `:251` 문면 = 블록 주석) → **3/3 생존** | ✅ |
| **V4** | `security find-generic-password` 건수 | 3 → **≥6** | 진입 **3** → 착지 **6** | ✅ |
| **V5** | §10.8 본문 블록 `${v:-UNSET}` **실사용형** | **0** | 블록 내 hit **1** = `` - `${v:-UNSET}` 류 = **금지**(…) `` = **금지를 서술하는 문장 안 인용** → 실사용형 **0** | ✅ |
| **V6** | SDO §5 기존 bullet | 4 → **4** | 진입 **4** → 착지 **4** | ✅ |
| **V7** | SDO §8 체크박스 | 11 → **12** | 진입 **11** → 착지 **12** | ✅ |
| **V7b** | safety §평문 차단 의무 bullet | 4 → **5** | 진입 **4** → 착지 **5** | ✅ |
| **V8** | 4-repo byte-identical | 각 file 4/4 | 3 file 전량 **distinct sha = 1** (`06980be515c8` / `ed55bfae2584` / `686fee3c19e1`) | ✅ |
| **V9** | production/migration/EF/test diff | **0 file** | master diff = **편집 3 file 단독** · 자식 3 commit = **각 3 file 단독** · production/migration/EF/test = **0** | ✅ |
| **V10** | 시크릿 `sbp_` / `eyJ` 평문 | **0 match** | 편집 3 file **0/0/0** · 4 commit diff **0/0/0/0** | ✅ |

**보강 실측 (계약 밖 · 자발)** — `verify-sync.sh`: **PASS 161 / DRIFT 0 / MISS 6** · exit **1**.
· **DRIFT 0** = 본 cycle 신규 drift **0** (STOP #6 미발동) · 편집 3 file 은 PASS 161 에 포함(실패분만 출력되는 구조).
· MISS 6 = pre-existing **의도분** (`CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` + `docs/ops/production-cli-access-tokens.md` × 자식 3 = master-only 설계).
· exit 1 = MISS 6 기인 (= `incident-log` 「`verify_sync_exit=1` 전 이력 100% = 버그 아님」 정합).

---

## 4. ★§2 표를 넘어선 실측 (전량 열거 · **8 건** · 「없었다」 아님)

### 4-1. ⚠ `safety-and-secrets.md:104` = **stale drift 1건** (본 cycle 무접촉 · 회부)

paste A4 문면(「slot 삭제됨」) ↔ 디스크 canonical(`:104` 「Keychain **잔존** · wrap 은 계속 주입」)이 **상충**해 실측했다.

| 근거 | 판정 |
|---|---|
| `.ai/reports/MASTER-CLI-RESIDUAL-OPS-001/REPORT.md:33-35` | `supabase-gb/gd/gt-token` = **MISS (slot 폐기)** ✓ ×3 |
| `.auto-memory/incident-log.md:540` | Coin 실행 = `security delete-generic-password -a "$USER" -s supabase-{gb,gd,gt}-token` ×3 |

⟹ **paste 가 옳고 `:104` 가 stale.** `:104` 는 2026-07-29 `MASTER-CLI-STALE-SWEEP-4ACTIVE-001` 시점 문면이고, **같은 날 뒤이어** `MASTER-CLI-RESIDUAL-OPS-001` 이 slot 을 실제 삭제했는데 그 문면이 갱신되지 않았다.
**처분 = 무접촉** (= §2 처분표 = 좌표 단일 SoT · B 는 B1/B2 뿐 · 임의 확장 = STOP #2). → **회부 R-AH**.

### 4-2. ★⚠ `Selfward` 동시 세션 near-miss — **git index 경합** (무손상 · 보고 의무)

진입 시 `-uno` **0** 이던 `Selfward` 가 착지 시 **1** 이었다. 실측:

- 대상 = `composeApp/src/commonMain/composeResources/values/strings.xml` (= **production code**)
- 내용 = **`SELFWARD-T1-4-AI-WAIT-COPY-001`** (대기 문면 수치 제거 · `ai_generating_wait` 신설) = **본 cycle 과 무관한 별 workstream**
- mtime = **12:56:32** = **내 `Selfward` commit 과 동일 초**
- `Selfward/.git/hooks/` = sample 외 **비어 있음** ⟹ hook 이 쓴 것 **아님** ⟹ **다른 cli session 이 동시 진행 중**

**무손상 확증 3**:
1. 내 commit `014660e` 파일 목록 = **정확히 3 file** · `strings.xml` 포함 여부 **grep = 0**
2. `strings.xml` = 지금도 **unstaged working-tree 단독** (= 내가 stage/commit/수정 **0**)
3. `Selfward HEAD~1` = **`140dd8c`** = 진입 baseline 일치

★**이것이 정확히 `cross-repo-parallel-exec.md §2` 영역 1.5 가 경고하는 형태다** — 「공유 자원은 file 이 아니라 `git index`(repo 당 1개 · `add`→`commit` 비원자적)이므로 **file 겹침 0 이어도 격리 없이 병렬 금지**」. 내 `git commit` 은 index **전체**를 커밋하므로, 저 세션이 내 `git add`↔`git commit` **사이**(sub-second)에 `git add` 를 했다면 **남의 미완 production 변경이 내 docs commit 에 삼켜졌다**. 이번엔 삼키지 않았으나 **마진이 1초 미만**이었다. → **회부 R-AI**.

### 4-3. paste C2 좌표 서술 내부 불일치 (판단 + 보고)

`| **C2** | `:202` 뒤 (§8 마지막 체크박스 · `---`(`:206`) **앞**) |` — `:202` = 「왕복이 1쌍인가」이고 **§8 마지막 체크박스는 `:204`**(「검증 7 항…」)이다. 두 서술이 같은 자리를 가리키지 않는다.
**채택 = `:202` 뒤** (근거 3): ⑴ paste 자신이 「§2 처분표 = 좌표 단일 SoT」 선언 ⑵ C1 이 같은 형식(`:163` 뒤 = §5 **마지막 bullet** 앞)에서 **좌표를 anchor 로** 쓴다 ⑶ §8 은 문서 순서 체크리스트라 **§5-1 항은 §5 항(`:202`) 직후**가 문서 순서 정합. `---` 앞 조건도 동시 충족. V7(11→12) 무영향.

### 4-4. A4 폐기 행 = paste 판보다 **구 셀 2개 더 보존** (S6 우선 적용)

paste §2-1-b 의 폐기 행은 구 행의 **적재 방식** 셀(`~/bin/claude-wrap.sh` → env `SUPABASE_ACCESS_TOKEN_<self>` **상시 inject**)을 「상시 inject」로, **사용** 셀(`§2 CLI 자동 + §10.2 (cli 자율)`)을 통째로 **축약**했다 — 그 자체가 구 문면 삭제다.
paste §2-1-b 자기 주석이 「**판정 기준은 「구 문면 삭제 0」 하나**」라고 못박았고 S6 도 동일하므로, **구 5 셀 전량 verbatim 보존 + 폐기 표식 append** 형태로 착지시켰다. (= 지시의 *형태*가 아니라 지시의 *판정 기준*을 따랐다 · 정보량은 paste 판 ≤ 착지 판)

### 4-5. `verify-sync.sh` 부수 산출물 → audit commit (표 밖 1 file)

`verify-sync.sh` 가 `.auto-memory/propagation-status.md` 를 **자동 갱신**한다(스크립트 설계). master `CLAUDE.md §3` step 6(「master 에 audit commit (propagation-status.md 갱신)」) 정합으로 **REPORT 와 함께 audit commit** 처리. ⟹ 실 commit = **master 2 + 자식 3 = 5** (paste §5 의 「4」 = 처분 commit 기준 · 차이 = REPORT + auto-generated audit).

### 4-6. ⚠ `CLAUDE.md §15` entry = **미이행** (§16-1 의무 · 본심 회수 대상)

master `CLAUDE.md §16-1` = 「master 의 **모든 cli infra 변경**은 §15 표에 cycle entry 추가 **의무**」. 본 cycle 은 `.claude/rules/safety-and-secrets.md` = **cli infra 변경**에 해당 ⟹ §16-1 발동.
**미이행 사유** = §2 처분표 12 에 부재 + §15 는 **hot 3 상한**이라 entry 신설 시 **최고참 1(`MASTER-CLI-STALE-SWEEP-4ACTIVE-001`) COLD demote 동반**이 강제됨 → `CLAUDE.md` + `.auto-memory/master-cycle-history-COLD.md` **2 file 추가 변경** = paste 표 밖 확장(STOP #2). paste 설계 자체가 「표 밖 = 회부·보고」 형태(§7)이므로 **실행하지 않고 회수**. 선례 = `MASTER-CLI-RESIDUAL-OPS-001` 의 명시적 「§15 미기입 판단」(단 그 cycle 은 cli infra **0 변경**이라 §16-1 미발동 · 본 cycle 은 **발동**). → **회부 R-AJ · Coin 본심**.

### 4-7. `verify-sync` stale ref **6** = pre-existing (본 cycle 무관 · 무접촉)

`protected-file-hashes.md` 5 + `propagation-status.md` 1 이 **부재 file** 참조(`check-abbreviation.sh` · `abbreviation-policy.md` · `code-principles.md` · `design-to-code-sync.md` · `domain-roles.md` · `workflow-core.md`). = `MASTER-CLI-JUDGMENT-SHIFT-001` 제거분 + `DIET-2-003` `docs/rules/` 이전 미반영 (= `incident-log` 후속 ⓑ 기등재). 본 cycle 무접촉.

### 4-8. DRIFT = **0** (진입 인계 기대 「DRIFT 2」보다 양호)

`incident-log`(2026-07-29) 는 `DRIFT 2`(release-checklist) 를 인계했으나 실측 **0** — `MASTER-DOCS-STALE-SWEEP-002`(`b8e2283`)에서 이미 해소됨. 기대치가 아니라 실측을 기록한다.

---

## 5. BLOCKED / Coin 손 잔여 (= **문서만 고쳤고 실사본은 안 고쳤다**)

| 대상 | 상태 | 소관 |
|---|---|---|
| `~/bin/claude-wrap.sh` | ★**무접촉** (S3) · repo 밖(`git ls-files | grep -c 'claude-wrap'` = **0**) — 본 cycle 은 **문서가 정한 형태**만 확정했고 **실 script 는 그대로**다 | **Coin 손 (R-AE)** |
| `~/.zshrc` alias `supabase-gb` | ★**무접촉** (S3) · repo 밖 — `§10.2` 착지본이 신형 alias(`supabase-sw` · slot 직독)를 **주석으로 제시**할 뿐 실 alias 는 **구형 그대로** | **Coin 손 (R-AE)** |
| `~/bin/claude-wrap.sh` 의 동결 3 slot 주입 잔존 | 미확인 (repo 밖 · 본 cycle 측정 X) | Coin 손 (R-AF) |

**BLOCKED = 0** (= `ADR-0002` 존재 확인으로 S7 미발동 · C 3 전량 실행).

---

## 6. ★값 접촉 0 선언

| 항목 | 실측 |
|---|---|
| `security … -w` **실행 횟수** | **0** (= S1 준수 · §10.8 snippet 은 **문서에 적히는 텍스트**로만 존재 · 실행 0) |
| `security` 명령 실행 (형태 불문) | **0** — slot 상태 판정은 **repo 문서 실측**(`RESIDUAL-OPS-001 REPORT` + `incident-log`)으로만 수행 |
| 토큰 값 stdout/stderr 노출 | **0** |
| PAT 재발급 제안 | **0** (= S2 준수 · 본 cycle 은 재발급을 **막으려고** 돈 cycle) |
| 시크릿 grep (`sbp_` / `eyJ`) | 편집 3 file **0** · 4 commit diff **0** |

---

## 7. STOP 준수 (S1~S9)

| # | 준수 | 근거 |
|---|---|---|
| S1 | ✅ | `security … -w` 실행 **0** (§6) |
| S2 | ✅ | 재발급 제안 **0** · §10.8 이 오히려 **①생략 재발급 = STOP** 을 규칙화 |
| S3 | ✅ | `~/bin/claude-wrap.sh` · `~/.zshrc` **무접촉** (§5) |
| S4 | ✅ | production/migration/EF/test **0 file** (V9) — ★단 `Selfward` production 1 file 이 **타 세션에 의해** dirty (= 내 손 아님 · §4-2 3중 확증) |
| S5 | ✅ | 자식 3 = `propagate.sh` 산출물 **단독** · 자식 직접 편집 **0** |
| S6 | ✅ | 구 문면 삭제 **0** — A2/A3 구 2줄 = `:260-261` 블록 주석 **생존**(V3 3/3) · A4 구 행 = 5 셀 **전량 verbatim 생존**(§4-4) |
| S7 | ✅ | `ADR-0002` **존재**(9,420B) → C 전량 실행 · BLOCKED 0 |
| S8 | ✅ | §10.5 **prod 행 무접촉** (diff hunk `-278 +288,2` = staging 행만) |
| S9 | ✅ | `git push` **0** (= Coin 본인 터미널) |

---

## 8. commit

| repo | commit | 파일 |
|---|---|---|
| `claude-cli-master` | **`a8f49ac`** | 3 (처분) |
| `claude-cli-master` | *(audit · 본 REPORT 와 동시)* | 2 (REPORT + `propagation-status.md` · §4-5) |
| `app-foundation` | **`8a86f19`** | 3 |
| `gently-product-docs` | **`31c1c65`** | 3 |
| `Selfward` | **`014660e`** | 3 |

전량 `git add` **path-limited** (= `-A` 금지 준수). **push = 0** (Coin 소관).

---

## 9. 회부 (본 cycle scope 외 · 보고만)

| ID | 항 | 소관 |
|---|---|---|
| **R-AE** | `~/bin/claude-wrap.sh` 주석 현행화 + `~/.zshrc` alias slot 직독형 교체 (= **문서가 정한 형태의 실 반영**) | Coin 손 |
| **R-AF** | wrap 이 동결 3 slot 을 아직 주입 시도하는지 (= slot 은 **실제 삭제됨**(§4-1) 이므로 warn+skip 경로 상시 발화 중일 것) | Coin 손 |
| **R-AG** | 401 재발 **계측** (= §10.8 ①에서 걸린 횟수를 남길 자리 부재) | 별 cycle |
| **★R-AH** | **`safety-and-secrets.md:104` stale** — 「Keychain 잔존 · wrap 은 계속 주입」 → 실제 **삭제 완료**(§4-1). 본 cycle 이 B1 을 그 **바로 아래**에 착지시켰으므로 같은 §안에 stale 과 신 조항이 공존 | **별 cycle (권장 우선)** |
| **★R-AI** | **동시 cli session ↔ git index 경합** (§4-2) — 같은 repo 병렬 = 「의무」 격리(영역 1.5 worktree)인데 실제로는 **미격리 병렬**이 돌았다. sub-second near-miss 실측 | **Coin 본심** |
| **R-AJ** | **`CLAUDE.md §15` entry 미이행** (= §16-1 의무 발동 · hot 3 상한 → COLD demote 1 동반 필요 · §4-6) | **Coin 본심** |
| **R-AA** | ★**본 cycle 로 종결** (= C1/C2/C3 + `ADR-0002` Follow-up #4 소진) | — |

---

## 10. negative space (= 고려했으나 hot 제외)

- **`CLAUDE.md §15` entry + COLD demote** — §16-1 의무이나 표 밖 2 file 확장이라 **제외 → R-AJ 회수** (§4-6)
- **`safety-and-secrets.md:104` stale 정정** — 실측으로 확증했으나 §2 표 밖이라 **제외 → R-AH 회수** (§4-1)
- **`Selfward` `strings.xml` 정리/stage** — 남의 in-flight 작업이라 **접촉 0** (§4-2)
- **`verify-sync` stale ref 6 정정** — pre-existing · 기등재 후속 ⓑ (§4-7)
- **`~/bin/claude-wrap.sh` · `~/.zshrc` 실 반영** — repo 밖 = S3 (§5)
