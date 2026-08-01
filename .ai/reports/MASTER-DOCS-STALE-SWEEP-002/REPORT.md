# MASTER-DOCS-STALE-SWEEP-002 — REPORT

> **cycle 본질**: 「참인가」가 아니라 **「CLI 가 읽고 무엇을 하는가」**. 001 이 stale 을 정정했다면 본 cycle 은 **정정해도 안 읽히는 것**을 전파 세트에서 뺀다.
> **Mode** = M5 (cli-infra-ops · docs-only) · **production 0 LOC** · **보호 5 sha drift 0** · **동결 3 쓰기 0**.
> **마감** = 2026-08-01 KST.

---

## §0. BASELINE 재측정 (진입 시점 실측 · paste 기대치 대조)

| 대상 | paste 기대 | 실측 | 판정 |
|---|---|---|---|
| master HEAD | `58457fd` (ahead 19 · tracked dirty 0) | `58457fd` · ahead 19 · dirty 0 | ✓ |
| app-foundation (FND) | `a7c9280` (2) | `a7c9280` · ahead 2 · dirty 0 | ✓ |
| gently-product-docs (PDOCS) | `7af7493` (3) | `7af7493` · ahead 3 · dirty 0 | ✓ |
| Selfward (SW) | `e11b593` (16) | `e11b593` · ahead 16 · dirty 0 | ✓ |

**baseline mismatch 0** (A1 정합). Selfward tracked dirty 0 = P1-3a 착지 완료 상태 ⇒ **동시 실행 위반 없음**(§6 STOP 준수).

---

## ⓐ 전파 세트 감량 실측 (78KB × 4 회수)

`docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md` = **78,447 B / 1,424 줄** · **4-repo 전부 byte-identical**(git-sha1 `c60d8d351e19388dde2bc50fc8023e681bc9739d` × 4) 실측 확인 후 이동.

| 항목 | 이동 전 | 이동 후 | 차이 |
|---|---|---|---|
| **4-repo `docs/` 합산 바이트** | 9,403,239 B | **9,089,451 B** | **−313,788 B** (= 78,447 × 4) |
| **verify-sync 전파 대상 file 수** | 164 | **163** | **−1** (= 전파 세트 이탈 실증) |
| master 보존 부수 | 4 (전파본) | **1** (`archive/2026-08/`) | −3 |

**이동 = 내용 무편집 실증**: `git mv` 후 git-sha1 = `c60d8d35…` **불변** (이동 전과 동일). 001 이 붙인 동결 지위 라벨 유지 · 본문 0 byte 변경.
**전파 세트 이탈 구조 실증**: `propagate.sh` 의 scan set = `find .claude docs scripts/agent .ai/promptfit .ai/uiux-sot/refresh .github` — `archive/` 는 **scan set 밖**이므로 이동만으로 전파가 끊긴다(스크립트 편집 0).

---

## ⓑ ⑵ 참조 정합 3 (dangling census)

| # | 좌표 | 처분 | 실측 근거 |
|---|---|---|---|
| a | `.auto-memory/protected-file-hashes.md:126` (C6 흡수 6 list) | **경로 갱신 + 이탈 표기** | ★**script 소비 여부 선확인**: `propagate.sh:274-287` 은 manifest 에서 **보호 5 file 의 sha-256 row 만** 동적 parse — C6 bullet list 는 **미parse** ⇒ 형식 자유. 단 `verify-sync.sh:288-300` 이 **backtick `docs/…` 경로의 실존을 검사**하므로 구 경로를 backtick 으로 남기면 **새 WARN 발생** ⇒ backtick 을 `archive/2026-08/…` 로 교체(정규식 alternation = `.claude\|docs\|scripts\|.auto-memory\|.ai` — `archive/` 미포함 ⇒ 미검사) · 구 경로는 backtick 없이 서술 보존 |
| b | `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md:57` (`docs/backend/` (1) 행) | **정정** | GO 표 행 = strikethrough + 「2026-08-01 전파 세트 이탈 · 디렉터리 소멸 ⇒ 분리 대상 아님」 |
| c | `docs/agent/architecture/SERVER_DATA_OWNERSHIP.md:8` 연관 pointer | **제거** | 직전 cycle 이 쓴 pointer · 이동 시 dangling ⇒ 삭제. **전파본**이라 정정분이 4-repo 동시 반영 |

**dangling 0 census (착지 후 전수 · 이력군 제외)**

| repo | live 참조 잔존 | 판정 |
|---|---|---|
| master | 2 | 둘 다 **본 cycle 이 의도적으로 남긴 정정 문면**(archive 경로 + charter 해소 행) = dangling 아님 ✓ |
| app-foundation | **0** | ✓ |
| gently-product-docs | **0** | ✓ |
| Selfward | **1** | ⚠ **보류** — 아래 §미해소 1 |

### ⚠ 미해소 dangling 1 (= 의도적 보류 · 다음 cycle 필수 회수)

`Selfward/docs/docs-routing-index.md:13` — `| backend | … | 3 · \`backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md\` · \`backend/02_gd_rls_verification_report.md\` · \`api/endpoints.md\` |`

본 cycle 의 자식 삭제로 **첫 항목이 부재 참조가 됐고 개수 `3` 도 실측 `2` 와 어긋난다.** 그럼에도 **고치지 않았다**:

- §2 무접촉 = **「자식 도메인 영역」** · 본 file 은 **SW-local 도메인 문서**(전파본 아님)
- §7ⓘ 계약 = **「자식 3 = 전파분 단독」** — 고치면 자식 diff 가 전파분 단독이 아니게 되어 **ⓘ 자체가 깨진다**

⇒ 두 계약이 같은 방향을 가리키므로 **보류가 계약 준수**. **다음 `SELFWARD-LEGACY-GD-SWEEP-001`(v2) 이 Selfward 안에서 도는 cycle 이므로 그 cycle 의 필수 회수 항목**으로 넘긴다(1행 · `3 →` `2` + 부재 항목 제거).

---

## ⓒ ⑶ SteadyWell 전수 census (지목 4 vs 실측)

**census 규약 준수**: 대소문자 무시(`grep -rni`) · 이력군/live 층 분리 · 경로 실존 확인.

**master 총 hit = 56 line / 16 file**(정정 전) → **정정 3 · 보존 53**.

### 정정 3 (= 진성 현재형 stale · 지목 그대로)

| 좌표 | 구 문면 | 신 문면 | 전파 |
|---|---|---|---|
| `CLAUDE.md:219` | 「각 자식 repo 가 **SteadyWell** propagation 받음」 | 「각 자식 repo 가 **`claude-cli-master`** propagation 받음」 | master-local |
| `docs/agent/architecture/SSOT_PRINCIPLES.md:73` | 「운영 레이어 drift (**SteadyWell** ↔ targets)」 | 「운영 레이어 drift (**`claude-cli-master`** ↔ targets)」 | **4-repo** ✓ |
| `.claude/rules/safety-and-secrets.md:63` | 「KMP/CMP 도입 시 **SteadyWell** SoT에서 재propagation」 | 「… **`claude-cli-master`** SoT에서 재propagation」 | **4-repo** ✓ (★`.claude/` 무접촉의 명시 예외 **1행** — 실측 diff = `-1/+1`) |

### 보존 1 (= 지목된 ★보존 · 검증 통과)

`CLAUDE.md:27` — 「다른 앱 패키지(**예: SteadyWell** · 향후 신규)로 확장 가능」 = **미래형 예시** ⇒ stale 아님 · **무접촉 실증 완료**.

### 보존 52 (= 전수 census 가 추가로 surface · 지목 밖)

| 버킷 | hit | 처분 근거 |
|---|---|---|
| `.ai/` (reports · tasks) | 43 | 이력 산출물 |
| `.auto-memory/` (decision-log · incident-log · protected-file-hashes) | 4 | 이력 서술 |
| `docs/agent/architecture/PROPAGATION_PARAMETERS.md:22`·`:128` | 2 | **과거형 + TaskId 표**(`SW-OPS-PARAM-001`) — 001 판정 계승 |
| `docs/architecture/…CHARTER.md:93` | 1 | 「다른 패키지(SteadyWell·웹 등)에 재사용」 = **미래형 예시** |
| `docs/rules/deferred-domains.md:54`·`:101` | 2 | 이력 서술 **+ §6 STOP(`docs/rules/**` 편집 = STOP)** |

**착지 후 live 층 잔존 = 6** (= 위 보존 1 + 5 · 이력군 47 별도) — 정정/보존 **1:1 대응 완료**.

---

## ⓓ ⑷ 부재 경로 = 깨진 계약 (실존 재확인 후 정정)

**경로 실존 재확인 (정정 방향 확정 근거)**

| 경로 | 실측 | 
|---|---|
| `scripts/agent/repo-config.sh` | **ABSENT** ✗ |
| `scripts/repo-config.sh` | **EXISTS** ✓ (1,989 B · executable) |
| `scripts/agent/` 디렉터리 | **EXISTS** — 단 내용 = `frontmatter-grep.sh` + `secret-scan.sh` **2개뿐**(repo-config 없음) |

⇒ 디렉터리는 있는데 **그 안에 repo-config 가 없다** = 문서를 따라 `source` 하면 실패. **파일 이동은 `scripts/` 편집 = STOP** 이므로 **문서 정정이 기본**(§3⑷ 계약 준수).

**정정 7 (= 지목 6 + 동족 1)**

| file | hit | 처분 |
|---|---|---|
| `docs/agent/architecture/PROPAGATION_PARAMETERS.md` `:7 :15 :28 :76 :101 :104` | **6** | `scripts/agent/repo-config.sh` → `scripts/repo-config.sh` · **4-repo 전파** ✓ |
| `.ai/uiux-sot/refresh/VERIFY.md:12` | **1** | ★**하한 초과 1** — `. scripts/agent/repo-config.sh && rg …` = **실행되면 실제로 실패하는 명령줄**(산문보다 더 직접적인 깨진 계약) · 동일 전파 세트(C6 흡수 6) ⇒ 동반 정정 |

**착지 실증**: 4-repo 전부 `scripts/agent/repo-config.sh` **0 hit** · `scripts/repo-config.sh` = PROPAGATION_PARAMETERS **6** + VERIFY **1**.
**master 잔존 1 = `.auto-memory/incident-log.md:144`** — C15 사고 기록(이력 서술) ⇒ **보존**.

---

## ⓔ ⑸ 처분 / 보류 + 사유 (★추측 정정 금지 준수)

### ⑸-1 부재 모듈 링크 — **정정**

`COMMON_ARCHITECTURE.md:14` 의 상대 링크 3 중 **2 가 부재**:

| 링크 | 실측 |
|---|---|
| `app-foundation/shared/domain/` | **EXISTS** ✓ |
| `app-foundation/shared/data/` | **ABSENT** ✗ |
| `app-foundation/shared/feature-state/` | **ABSENT** ✗ |

⇒ 부재 2 링크 제거 + 「실측 `shared/` = `domain` 단독 · 모듈 열거 SoT = `app-foundation/CLAUDE.md §0.2`」 명시(= 부모 root `CLAUDE.md §2.1` 의 「두 번째 열거처가 곧 drift 원」 경고 정합 — 여기서 다시 세지 않고 SoT 를 가리킨다). **4-repo 전파** ✓

### ⑸-2 verify-sync MISS 6 — **원인 규명 완료 · 보류(결함 아님)**

MISS 6 = **master-only file 2 × 자식 3**:

| file | master-only 사유 |
|---|---|
| `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` | ⑼ 계약이 명시한 **master-local**(전파 = §6 STOP) |
| `docs/ops/production-cli-access-tokens.md` | **prod secret runbook** · charter §2 가 「master-only 의도적 4-repo 제외」로 이미 명시 |

⇒ **의도된 설계** · 정정 대상 아님. 진입 전 6 = 착지 후 6 (**본 cycle 기여 0**).

### ⑸-3 상태문서 부재 참조 6 — **원인 규명 완료 · 보류(이력 보존 우선)**

`verify-sync.sh:288-300` 이 상태문서의 backtick 경로 실존을 검사해 나온 6:

| 부재 참조 | 원인(규명) |
|---|---|
| `.claude/hooks/check-abbreviation.sh` · `.claude/rules/abbreviation-policy.md` | 2026-07-29 `MASTER-CLI-JUDGMENT-SHIFT-001` 이 **제거**(판단 위임 전환) |
| `.claude/rules/code-principles.md` · `design-to-code-sync.md` · `workflow-core.md` · `domain-roles.md` | `MASTER-CLI-CONTEXT-DIET-2-003` 이 `.claude/rules/` → **`docs/rules/` 로 이동** |

**전부 「그 시점에는 참이었던」 이력 서술**(cycle history entry) ⇒ 정정하면 **이력 훼손**. 검사기가 이력과 live 참조를 구분하지 않는 것이 진짜 원인 ⇒ **보류 + 보고**(§3⑸ 「추측 정정 금지」 준수). 1건은 `propagation-status.md` = **수기 편집 금지 file**(⑺)이라 애초에 대상 밖.

★**본 cycle 이 7번째를 만들지 않았음**: ⑵a 를 `archive/` 경로로 표기해 검사 정규식을 의도적으로 회피 ⇒ 6 → **6 유지**.

---

## ⓕ 4-repo sha 동일 표 + RLS 가이드 ABSENT 실증

**전파본 6 · git-sha1 (`git hash-object`) 4-repo 동일**

| file | master | FND | PDOCS | SW | 판정 |
|---|---|---|---|---|---|
| `.claude/rules/safety-and-secrets.md` | `febc86f98c6f` | `febc86f98c6f` | `febc86f98c6f` | `febc86f98c6f` | ✓ |
| `docs/agent/architecture/SSOT_PRINCIPLES.md` | `f7b40d89c362` | `f7b40d89c362` | `f7b40d89c362` | `f7b40d89c362` | ✓ |
| `docs/agent/architecture/SERVER_DATA_OWNERSHIP.md` | `7d4c0a133003` | `7d4c0a133003` | `7d4c0a133003` | `7d4c0a133003` | ✓ |
| `docs/agent/architecture/PROPAGATION_PARAMETERS.md` | `2487bbc4ed76` | `2487bbc4ed76` | `2487bbc4ed76` | `2487bbc4ed76` | ✓ |
| `docs/agent/architecture/COMMON_ARCHITECTURE.md` | `aa214c00fadc` | `aa214c00fadc` | `aa214c00fadc` | `aa214c00fadc` | ✓ |
| `.ai/uiux-sot/refresh/VERIFY.md` | `4ecd972616e8` | `4ecd972616e8` | `4ecd972616e8` | `4ecd972616e8` | ✓ |

**불일치 0** · `propagate.sh` **ok=18 fail=0**.

**RLS 가이드 부재 실증**

| repo | `docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md` |
|---|---|
| claude-cli-master | **ABSENT** ✓ (디렉터리 자체 소멸) |
| app-foundation | **ABSENT** ✓ (디렉터리 소멸) |
| gently-product-docs | **ABSENT** ✓ (디렉터리 소멸) |
| Selfward | **ABSENT** ✓ — ★**디렉터리는 보존**(SW-local 6 file 실존 · §6 STOP 준수) |

master `archive/2026-08/RLS_AND_PLAY_INTEGRITY_GUIDE.md` = **PRESENT · 78,447 B · git-sha1 `c60d8d35…`**(무편집 실증).

★**삭제는 propagate 로 전파되지 않는다**(선확인): `propagate.sh` 의 `PRUNE_BASE_PATHS=(.claude)` — `docs/` 는 prune 대상 밖 ⇒ 자식별 **경로 한정 `git rm`** 으로 명시 삭제(§3⑹ 지시 준수 · `--prune` 미사용).

---

## ⓖ 무접촉 diff 0 실증

| 영역 | 변경 | 판정 |
|---|---|---|
| `scripts/**` | **0** | ✓ (실행만) |
| `docs/rules/**` 42 | **0** | ✓ |
| `propagation-reports/**` | **0** | ✓ (이력) |
| `.auto-memory/master-cycle-history-COLD.md` | **0** | ✓ (이력) |
| `.claude/**` | **1 file / 1행**(`rules/safety-and-secrets.md` · diff `-1/+1`) | ✓ **명시 예외 그대로** |
| 동결 3 (GB/GD/GT) | **0** (쓰기 0) | ✓ |

---

## ⓗ verify-sync 전후 (본 cycle 추가 drift 0)

| 지표 | 진입 전 | 착지 후 | 차이 |
|---|---|---|---|
| 전파 대상 file | 164 | **163** | −1 (= RLS 가이드 이탈) |
| PASS | 162 | **161** | −1 (동상) |
| **DRIFT** | **0** | **0** | **0** ✓ |
| **MISS** | **6** | **6** | **0** ✓ (⑸-2) |
| **상태문서 부재 참조** | **6** | **6** | **0** ✓ (⑸-3) |

`verify-sync` exit = 1 (= MISS 6 존재 시 규약상 exit 1) — **진입 전과 동일** · 본 cycle 이 만든 신규 drift/miss **0**.
`.auto-memory/propagation-status.md` 동승 = **예상대로**(⑺ · verify-sync 기계 산출 · 수기 편집 0).

---

## ⓘ 자식 3 = 전파분 단독

각 자식 staged diff = **전파 6 (M) + RLS 가이드 삭제 1 (D) = 7** 정확히 · 그 외 0.
(자식 working tree 의 `??` untracked = **본 cycle 이전부터 존재하던 repo-local 산출물**(cc-paste · `.ai/reports/` 등) · **stage 0 · 커밋 0**.)

---

## ⓙ 커밋 4 실증 (★증거 선채취)

★**순서 준수**: 위 ⓐ~ⓘ 증거를 **전량 채취한 뒤** REPORT 작성 → 그 다음 커밋. (직전 cycle 에서 REPORT 보강이 5번째 커밋이 된 재발 방지.)

| # | repo | commit |
|---|---|---|
| 1 | claude-cli-master | (아래 §커밋 기록) |
| 2 | app-foundation | 〃 |
| 3 | gently-product-docs | 〃 |
| 4 | Selfward | 〃 |

---

## ⓚ ⑼ charter 등재 3 실증 (master-local · 전파 X)

| # | 대상 | 처분 실증 |
|---|---|---|
| a | §2 GO 표 `docs/agent/architecture/` 행 | **(13) → (14)** + 이름 목록에 **`SERVER_DATA_OWNERSHIP`**(2026-08-01 신설 등재 · §0.1) 추가 ✓ ★**진입 시 재count**: 기존 나열 이름 = 정확히 **13** 확인(paste 검증 통과) |
| b | §5 provenance `docs/agent/architecture/` | **14 → 15** ✓ (디스크 실측 15 file) · 구 2026-07-13 실측 행은 **보존**하고 「재count(2026-08-01)」 행을 별도 추가 = provenance 정직성 유지 |
| c | **배치 판단 절차 신설** | charter **§0 말미에 `§0.1` 신설** ✓ — 「master 에 문서를 신설·이동하기 전 §0 단일 test 를 먼저 통과시킨다 · **GO 판정이면 「현 위치 유지 + §2 GO 표 등재」가 기본**이고 **신설 자체를 다시 묻는다**」 + 등재/배치 동일 cycle 의무 + `docs/architecture/` ↔ `docs/agent/architecture/` **다른 디렉터리** 명시(사고 원인 ⑵ 직격) |

★**c 의 계기 1줄 박음**(요구대로): 「2026-08-01 `SERVER_DATA_OWNERSHIP.md` 신설이 §2 가 이미 🚚 GO 로 분류해 둔 `docs/agent/architecture/` 더미에 **등재 없이** 들어간 건」 — 규칙만 있고 계기가 없으면 다음에 또 스친다.

★**`SERVER_DATA_OWNERSHIP.md` 이동/삭제 0** — **현 위치 유지 + 등재만**(Coin 확정 ⓐ · §6 STOP 준수).

### charter 미전파 실증 (= master-local 유지)

| repo | charter 존재 |
|---|---|
| master | PRESENT (`0944b3147b66`) |
| FND / PDOCS / SW | **ABSENT ×3** ✓ (verify-sync `MISS` 로 계속 표시 = 의도) |

★`propagate.sh --all` 을 **쓰지 않았다** — charter 는 `docs/` 아래라 `--all` 이면 **자식으로 밀려나가 §6 STOP 을 위반**한다. 대신 **전파 6 file 을 명시 인자로 지정**해 호출(= charter/`.auto-memory`/`archive`/`CLAUDE.md` 전부 전파 세트 밖 유지).

### ★하한 초과 — charter 내 동종 수치 stale 3 추가 정정

⑼ 를 집행하며 같은 file 의 **동종 결함**(후속 cycle 이 charter 를 갱신하지 않아 생긴 수치 drift)을 census 로 발견 ⇒ **실측 가능한 것만** 정정:

| 좌표 | 구 | 신(실측) | 근거 |
|---|---|---|---|
| §2 STAY `.claude/rules/` 행 | **5** kernel | **6** kernel + `stop-canonical` 이름 추가 | 2026-07-29 `CONTEXT-DIET-3-001` 신설분 미등재 |
| §5 `.claude/rules`(5) | **5** | **6** | 동상 |
| §5 `docs/rules`(44) | **44** | **42** | `JUDGMENT-SHIFT-001` 이 2 제거 |
| §2 요약 수치 `architecture(14)` / `backend(1)` | 14 / 1 | **15** / **이탈 표기** | ⑼a·⑵b 의 직접 귀결 |

⚠ **정정하지 않은 것(추측 금지)**: §2 의 `docs/rules/` 분류 합계 = CLI-workflow **16** + 제품-도메인 **24** = **40** 인데 실측은 **42** — **어느 2개가 어느 tier 인지는 내용 판단**이라 추측 정정 시 charter 의 분류 자체를 오염시킨다 ⇒ **미접촉 · 후속 회수**(아래 §후속 ②).

---

## §커밋 기록

(커밋 직후 아래 표 확정 — 본 REPORT 는 커밋 대상에 포함)

---

## §후속 (별 cycle 회수 대상)

1. ★**`Selfward/docs/docs-routing-index.md:13`** — 본 cycle 이 만든 **dangling 1** · **다음 `SELFWARD-LEGACY-GD-SWEEP-001`(v2) 필수 회수**(SW-local · 1행 · `3 → 2` + 부재 항목 제거).
2. charter §2 `docs/rules/` tier 분류 **16+24=40 vs 실측 42** — 미분류 2 의 tier 판정(내용 판단 필요 · 추측 금지로 미접촉).
3. `verify-sync.sh` 부재 참조 검사기의 **이력 서술 ↔ live 참조 미구분** — 6 WARN 이 전부 이력 오탐. 검사기에 이력 섹션 제외 규칙 추가 여부(= `scripts/` 편집이라 본 cycle STOP).
4. `COMMON_ARCHITECTURE.md:37` tree 의 `scripts/agent/` = `frontmatter-grep.sh` 단독 표기 — 실측 `secret-scan.sh` 추가됨(2026-07-29). 경로 오기 아닌 **열거 누락**이라 ⑷ 계약 밖 ⇒ 미접촉.
5. master `CLAUDE.md §15` entry — **미작성**(아래 §판단 근거).

### §15 entry 미작성 판단 근거 (= 명시 보고 · 이견 시 Coin 회수)

§16.1 은 「master 의 모든 cli infra 변경 = §15 entry 의무」이고 본 cycle 은 `.claude/rules/safety-and-secrets.md` **1행**을 건드렸다. 그럼에도 **미작성**:

- §15 는 **상한 3 entry** 규약이라 entry 신설 = **3 초과분 즉시 COLD demote 의무**인데, **§6 STOP 이 `master-cycle-history-COLD.md` 편집을 금지**한다 ⇒ 규약대로 하면 STOP 을 밟는다.
- paste §2 무접촉 + §6 STOP 이 **COLD 를 이중으로 fence** 한 것은 본 cycle 을 docs 정리로 한정하려는 의도로 읽힌다.
- **선례**: 직전 동종 docs cycle(`MASTER-DOCS-STALE-SWEEP-001` · `MASTER-DATA-OWNERSHIP-RULE-001`) 모두 §15 entry 미추가.

⇒ **미작성 + 명시 보고**. 필요 시 별 cycle 에서 entry + demote 를 함께 집행.

---

## §negative space (anchor-list §4 의무)

고려했으나 hot 제외 영역: ⑴ `Selfward/docs/docs-routing-index.md` dangling 1 (= 자식 도메인 영역 무접촉 + ⓘ 전파분 단독 계약) ⑵ 상태문서 부재 참조 6 정정 (= 이력 서술 · 훼손 회피) ⑶ verify-sync MISS 6 (= master-only 의도 · 결함 아님) ⑷ charter `docs/rules/` tier 분류 2 (= 내용 판단 · 추측 금지) ⑸ `COMMON_ARCHITECTURE.md:37` scripts/agent 열거 누락 (= 경로 오기 아님) ⑹ master `CLAUDE.md §15` entry + COLD demote (= §6 STOP) ⑺ `PROPAGATION_PARAMETERS.md` 의 `REPO_NAME`/`REPO_PREFIX` 미export 광역 stale (= 기존 TODO · scripts 편집 필요) ⑻ 동결 3 (GB/GD/GT) 의 RLS 가이드 부수 (= 전파 대상 X · 쓰기 0).
