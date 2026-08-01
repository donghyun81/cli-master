# MASTER-DATA-OWNERSHIP-RULE-001 — 서버 데이터 소유 규약 신설 + `COMMON_ARCHITECTURE §4.1` 정정 + 4-repo 전파

- **Mode**: M5 (cli 운영 레이어형 · docs-only) · **Risk**: Low (prod 코드 0 · DDL/EF/배포 0 · 보호 5 sha 0)
- **마감(KST)**: 2026-08-01 · **repo**: `claude-cli-master` 진입 · 전파 3 (FND · PDOCS · SW)
- **paste**: `cc-paste-MASTER-DATA-OWNERSHIP-RULE-001.md` (= `cc-paste-FND-DATA-OWNERSHIP-RULE-001` **철회분 대체** · 그 file = disk 전수 find **부재** → archive 이동 대상 없음)
- **결정 기록**: `ADR-0001-SERVER-DATA-OWNERSHIP-SEPARATION`(부모 root · Accepted 2026-08-01)

---

## §0. BASELINE 재측정 (진입 시점 실측 · paste §0 대조)

| 항 | paste 기대 | 실측 | 판정 |
|---|---|---|---|
| master HEAD | `7972ce4` (ahead 16) | `7972ce4` · ahead **16** | ✓ |
| master tracked dirty | 0 | **0** | ✓ |
| FND / PDOCS / SW HEAD | `78dc842` / `dc2cbb8` / `be13c6d` | 동일 | ✓ |
| `COMMON_ARCHITECTURE.md` sha | `6177dda1…` | `6177dda18914d6ea…` (**sha-256**) · git-sha1 = `dc423f15…` | ✓ **알고리즘 정합** |
| 4-repo byte-identical (변경 전) | 동일 | 4/4 동일 · 7,753 B · 117 줄 | ✓ |
| `docs/agent/architecture/` | 14 | **14** (4 repo 전부) | ✓ |
| `docs/rules/` | 42 | **42** (4 repo 전부) | ✓ |

★**baseline 정정 1 (A1)**: paste 인용 `6177dda1…` 는 **sha-256** 이고 `git hash-object`(git-sha1) 는 `dc423f15…` 다. 두 알고리즘 직접 비교 금지(master `CLAUDE.md §14a` CONVENTION 정합). mismatch 아님.

★**baseline 정정 2**: 자식 3 = untracked 잔존 (FND 2 · PDOCS 1 · SW 54) — 단 **tracked dirty = 0 (3/3)**. 전파 commit 은 path-scoped 라 무영향(ⓖ 실증).

---

## ⓐ 정정 전 `§4.1` verbatim 박제 + 정정 후 문면 + 전이 사유

### 정정 **전** (verbatim · 원본 = `dc423f15…` line 82~91)

```markdown
### 4.1 다중 값 컬럼 타입 표현 규약 (앱-중립 · persistence 한정)

다중 값 컬럼은 의미 구조에 따라 일관된 Postgres 타입으로 표현한다(앱 무관).

- **문자열 리스트 = `TEXT[]`** (네이티브 배열). 예: 태그·선호·제한·환경 목록. CSV 문자열(쉼표 구분 한 컬럼) 금지 — 타입 미강제·파싱 오류 회피.
- **중첩/구조화 객체 = `JSONB`**. 예: 분석 결과·분포·외부 페이로드 등 키-값/중첩.
- **단일 스칼라 = scalar**(`TEXT`/`BOOLEAN`/`TIMESTAMPTZ` 등). 배열로 승격하지 않는다.
- **승격 규칙**: 새 다중 값 컬럼은 `TEXT[]` 기본. 항목에 **중첩 구조**가 필요해질 때만 `JSONB`로 승격한다.

> 도메인 의미(verbatim recognition·enum 라벨 금지 등)는 본 절이 아니라 각 앱 design SoT·product 원칙에서 다룬다(본 절 = persistence 표현 한정).
```

### 정정 **후** (착지분 · `9ef0dedc…`)

- 머리에 **정정 · supersede 고지 blockquote** 신설 (ADR-0001 인용 + 사유 + 「덮어쓰기가 아니라 전이」 명시 + 구 문면 verbatim 좌표 = 본 REPORT).
- bullet 2 「중첩/구조화 객체 = `JSONB`」 → **「구조를 가진 항목의 목록 = 자식 테이블」**(`position integer` · PK `(parent_id, position)`).
- bullet 신설 **「우리가 형태를 정하지 않는 외부 페이로드 = `JSONB`」**.
- bullet 4 「승격 규칙」 **삭제**(3분 갈림길이 대체).
- **갈림길 1문** 병기: 「이 안의 필드에 **제약을 걸고 싶어질 것 같은가**?」 → 자식 테이블.

### 무변 실증 (계약 = 3줄 무접촉)

| 항 | 상태 |
|---|---|
| `TEXT[]` 존속 (bullet 1 전단) | **무변** (diff context) |
| CSV 금지 (bullet 1 후단) | **무변** (diff context) |
| 단일 스칼라 승격 금지 (bullet 3) | **무변** (diff context) |
| 도메인 의미 위임 blockquote | **무변** (diff context) |

### 전이 사유 1줄

> 구 승격 규칙이 `JSONB` 로 보낸 항목은 **종별 제약(1:1 UNIQUE·종류별 NOT NULL·열거형 CHECK)을 걸 수 없게** 되는데 그 대가가 비용으로 세어지지 않았고, 구 규칙의 `TEXT[]` 실적용처(`user_profiles` 3컬럼 = GT 계보)는 **살아있는 적용처가 0**(P1-1 에서 테이블째 DROP)이었다.

---

## ⓑ 신설 본문 절 수 실측 + 별첨 대비 대조

| 계약 | 기대 | 실측 | 판정 |
|---|---|---|---|
| `## ` (H2) | 10 | **10** (`## 0` ~ `## 9`) | ✓ |
| §2 하위 (`### 2-`) | 6 | **6** (2-1 ~ 2-6) | ✓ |
| §3 하위 (`### 3-`) | 7 | **7** (3-1 ~ 3-7) | ✓ |
| H3 총계 | — | 15 (= 6 + 7 + 4-1 + 4-2) | 참고 |
| 별첨 ↔ 착지 sha-256 | 동일 | `55d49183bd01216b…` **동일** · `diff` **0** | ✓ |
| 크기 | — | **17,806 B · 212 줄** | 참고 |

★**문면 재저작 0** — `cp` 무손실 배치 · 오탈자 정정조차 불요(`diff -q` = 무출력). §2「확장을 전제로 나눈다」+ §2-2 「나누면 걸 수 있는 것 ↔ 합치면」 표 = **원형 보존**.

---

## ⓒ ★4-repo sha 동일 실증 (2 file × 4 repo = **8 측정**)

| repo | `COMMON_ARCHITECTURE.md` | `SERVER_DATA_OWNERSHIP.md` |
|---|---|---|
| claude-cli-master | `9ef0dedcf80c179833786bf7a2253ead35fadb9948916dc1f0f0c4dbf848dd08` | `55d49183bd01216b391cf02db9649cd6622f75b60afc245506294043909c9758` |
| app-foundation | `9ef0dedcf80c…dd08` **동일** | `55d49183bd01…9758` **동일** |
| gently-product-docs | `9ef0dedcf80c…dd08` **동일** | `55d49183bd01…9758` **동일** |
| Selfward | `9ef0dedcf80c…dd08` **동일** | `55d49183bd01…9758` **동일** |

**8/8 일치 · 불일치 0 · 부분 전파 0.** `propagate.sh` = ok **6** / fail **0**.

---

## ⓓ 전파 세트 수 변화

| 세트 | 전 | 후 | 4-repo 정합 |
|---|---|---|---|
| `docs/agent/architecture/` | 14 | **15** | 4/4 전부 15 ✓ |
| `docs/rules/` | 42 | **42 무변** | 4/4 전부 42 ✓ |

---

## ⓔ 무접촉 실증 (master tracked diff)

| 영역 | 변경 file 수 |
|---|---|
| `.claude/**` | **0** |
| `scripts/**` | **0** (propagate/verify **실행**만 · 편집 0) |
| `docs/rules/**` 42 | **0** |
| 그 외 `docs/agent/**` 13 | **0** (변경분 = 대상 2 file 단독) |
| 코드 / DDL / EF / 배포 | **0** |

`git status --porcelain` (master · REPORT 작성 전 시점) = `M COMMON_ARCHITECTURE.md` + `?? SERVER_DATA_OWNERSHIP.md` + `M .auto-memory/propagation-status.md` **3 항 단독**.

---

## ⓕ ADR-0001 인용 좌표 정합 (3방향)

| 방향 | 좌표 | 실측 |
|---|---|---|
| ADR → 규약 본문 | `docs/agent/architecture/SERVER_DATA_OWNERSHIP.md` | ✓ 착지 완 |
| ADR → 정정 대상 | `docs/agent/architecture/COMMON_ARCHITECTURE.md §4.1` | ✓ 정정 완 |
| §4.1 → ADR | `ADR-0001-SERVER-DATA-OWNERSHIP-SEPARATION` | ✓ 고지 신설 |
| 본문 → ADR | `SERVER_DATA_OWNERSHIP.md` 머리 「결정 기록」 | ✓ 기재 |
| 본문 → 상위 | `COMMON_ARCHITECTURE.md §4` | ✓ 실재 |
| §4 → 본문 | §4 말미 pointer 「형태 층 상세」 | ✓ 신설 |

ADR 인용 **9 좌표 전수 실존 확인**: `ADR_TEMPLATE.md`(첫 사용례 ✓) · `supabase-handling.md` · `docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md` · `MODEL_SEPARATION.md` · `SSOT_PRINCIPLES.md` · `LOCK-DATA-SOT-SERVER-AUTHORITATIVE-001.md`(부모 root) · `LOCK-CUMULATIVE-XAXIS-ACTIVITY-001.md`(부모 root) · `SELFWARD-SCHEMA-TRUTH-AUDIT-001/REPORT.md` · `SELFWARD-P1-1-DDL-001/REPORT.md`.
착지 좌표 `be13c6d` + migration `20260801120000_p1_server_ownership.sql` = **실재 확인**.
★**ADR 파일 이동/재저작 0** — 부모 root 거주 유지(`docs/adr/` master 신설 **0** = 전파 오염 차단).

---

## ⓖ 자식 3 커밋 = 전파분 단독 실증 (numstat)

| repo | staged file 수 | numstat | unstaged tracked |
|---|---|---|---|
| app-foundation | **2** | `9 2 COMMON_ARCHITECTURE.md` · `212 0 SERVER_DATA_OWNERSHIP.md` | **0** |
| gently-product-docs | **2** | 동일 | **0** |
| Selfward | **2** | 동일 | **0** |

도메인 변경 동승 **0**. 자식 untracked 잔존분(FND 2 · PDOCS 1 · SW 54)은 **stage 진입 0** — path-scoped commit 로 격리.

---

## ⓗ ★stale 보고 (무접촉 · 보고만)

**`COMMON_ARCHITECTURE.md` 안 SteadyWell 서술 = 5 곳** (paste 는 §5 만 지목했으나 실측 census 결과 header 2 곳 추가):

| line | 서술 | 상태 |
|---|---|---|
| 4 | 「적용 대상: SteadyWell, GentlyDay, GentlyBreath, GentlyTable」 | **stale ×2** — SteadyWell 부재 + GB/GD/GT = 2026-07-17 T6 **동결**(전파 대상 X) |
| 5 | 「변경은 SteadyWell에서 먼저 반영 후 propagation」 | **stale** — 현행 SoT = `claude-cli-master` 단방향 |
| 103 | §5 「SoT 원본: 변경은 SteadyWell repo에서 먼저 반영」 | **stale** (paste 지목분) |
| 104 | §5 「Verify in source: SteadyWell에서 PASS」 | **stale** |
| 107 | §5 「Drift Audit: SteadyWell ↔ targets」 | **stale** |

실측: `~/AndroidStudioProjects/SteadyWell` = **ABSENT**(umbrella 7-repo 미등재 · 부모 root `CLAUDE.md §2` 정합). 본 cycle **무접촉**(§6 STOP 「§4.1 밖 편집 = STOP」 준수) · **후속 cycle 후보**로 회수.

**추가 stale (verify-sync 자체 신고 · 본 cycle 무관)**: `protected-file-hashes.md` 가 부재 file 5 참조(`check-abbreviation.sh` · `abbreviation-policy.md` · `code-principles.md` · `design-to-code-sync.md` · `workflow-core.md`) + `propagation-status.md` 가 `domain-roles.md` 참조 — 전부 `MASTER-CLI-JUDGMENT-SHIFT-001` / `CONTEXT-DIET-3-001` 이전분 잔재.

---

## §V. verify-sync 결과 (master `CLAUDE.md §3` step 4 · §16.4 의무)

```
PASS: 161 · DRIFT: 2 · MISS: 6 · exit: 1
```

★**본 cycle 은 drift 를 0 추가했다** — 실증:

| 항 | 직전 기록(2026-07-29) | 본 cycle 후 | 델타 |
|---|---|---|---|
| pass | 160 | **161** | **+1** (= 신설 file 1) |
| drift | 2 | **2** | **0** |
| miss | 6 | **6** | **0** |
| exit | 1 | **1** | **0** |

`drift 2 / miss 6 / exit 1` 은 **본 cycle 진입 전부터 기록돼 있던 값**(propagation-status.md diff 에서 전부 context line = 무변). 내역:

| file | 성격 | 판정 |
|---|---|---|
| `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` | master-only 감사 지도 (master `CLAUDE.md §0` 역할 정합 note) | MISS ×3 = **구조적 정상** |
| `docs/ops/production-cli-access-tokens.md` | master **untracked** file | MISS ×3 = **구조적 정상** |
| `docs/templates/release-checklist.template.md` | FND `30fc9396` · PDOCS `30fc9396` ≠ master `e6c62fb2` (SW ✓) | **DRIFT ×2 = 선행 · 후속 cycle 후보** |

⟹ paste §6 STOP 「전파 후 4-repo sha 불일치 = STOP」 = **대상 2 file 기준 불일치 0** → **STOP 미발동**. exit=1 은 선행 잔재 계승분.

---

## §S. 계약 이행 대조 (paste §3 · §5 · §6)

| 계약 | 이행 |
|---|---|
| ⑴ 문면 재저작 금지 | ✓ `diff` 0 · sha 동일 |
| ⑵ⓐ 3분 + 갈림길 1문 + supersede 고지 | ✓ 3분 bullet + 1문 + 머리 고지 |
| ⑵ 그 외 §1·§2·§3·§4 본문·§5 무접촉 | ✓ diff hunk = line 84~97(§4.1 블록) + 124(§6) **단독** |
| ⑶ ADR 위치(부모 root) | ✓ 이동 0 · `docs/adr/` 신설 0 |
| ⑷ 4-repo byte-identical | ✓ 8/8 |
| ⑸ 수 대조 14→15 · rules 42 | ✓ |
| §6 STOP 전항 | 미발동 (코드 0 · DDL 0 · 동결 3 무접촉 · push 0) |

**§FREEDOM 행사**: §4.1 정정 문면 = **bullet 형식**(표 아님 · 주변 §4 텍스처 정합) · pointer 문장 어휘 · `--targets all` 호출 형태 · REPORT 표 구성.

---

## §D. Deviation 보고 (2 항 · Coin 회수)

1. **`.auto-memory/propagation-status.md` 1 file 추가 변경** — paste `[Diff]` 는 master 3 file(신설1+변경1+REPORT1)을 열거했으나, master `CLAUDE.md §3` step 4 + §16.4 가 `verify-sync.sh` 실행을 의무화하고 그 script 가 해당 file 의 **auto-generated 영역을 재생성**한다(본문 「수기 편집 금지 · 매 실행 시 live sha 재생성」). 변경 = **3 줄**(sha row 1 + timestamp + pass count) = 기계 재생성분 · 내용 저작 0. `.auto-memory/` 는 paste §2 무접촉 목록·§6 STOP 목록 **양쪽 모두 미열거**. → master commit 에 **동승**시킴.
2. **master `CLAUDE.md §15` entry 미추가** — §16.1 은 「모든 cli infra 변경」에 §15 entry 를 의무화하나, ⑴ 본 cycle 변경분은 `.claude/**` cli infra 가 아닌 `docs/agent/**` docs 이고 ⑵ paste `[Diff]` 가 master 3 file 을 명시했으며 ⑶ §15 는 **hot 상한 3 entry** 라 entry 추가 시 즉시 COLD demote(= `master-cycle-history-COLD.md` 동반 변경)가 걸려 scope 가 확장된다(A3). → **미추가 + 보고**. 필요 시 별 cycle 로 회수.

---

## §13. negative space

고려했으나 hot 제외 영역: ⑴ `COMMON_ARCHITECTURE` SteadyWell stale 5 곳 정정(= §6 STOP 「§4.1 밖 편집」 저촉 · 후속 cycle) ⑵ `release-checklist.template.md` 선행 DRIFT ×2 해소(= 본 cycle scope 외 · 전파 cycle 별건) ⑶ `protected-file-hashes.md` 부재 참조 5 정정 ⑷ master `CLAUDE.md §15` entry + COLD demote ⑸ `SERVER_DATA_OWNERSHIP.md` 를 `docs/rules/supabase-handling.md` 측에서 역참조(= 양방향 배선 · 본 cycle 은 단방향만).

---

`Sources:` `cc-paste-MASTER-DATA-OWNERSHIP-RULE-001.md` · `ADR-0001-SERVER-DATA-OWNERSHIP-SEPARATION.md`(부모 root) · `Selfward/.ai/reports/SELFWARD-P1-1-DDL-001/REPORT.md` · `Selfward/.ai/reports/SELFWARD-SCHEMA-TRUTH-AUDIT-001/REPORT.md`
