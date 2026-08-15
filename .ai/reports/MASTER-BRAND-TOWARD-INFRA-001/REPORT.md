# MASTER-BRAND-TOWARD-INFRA-001 — cli infra 문서 브랜드 문면 Gently → Toward (#40) + #38 부모 root 정정

> **마감** 2026-08-15 KST · **Mode** M5 (cli 운영 레이어형) · **branch** main · **판정** PASS (STOP 발동 0 · FAIL 0)
> **서식 주의** — 본 REPORT 는 **자기 commit sha 를 담지 않는다** (= 본 cycle 이 신설한 `reporting.md §8.2` 의 첫 준수). 인용 sha = 전부 **선행** commit. 본 REPORT 를 담은 audit commit 은 `CLAUDE.md §15` 의 `[R]` 링크 + cycle-id 로 지시한다.

---

## §0. BASELINE (진입 시 전량 재측정 · cowork 인용값 대조)

| 항 | cowork 인용 | cli 실측 | 판정 |
|---|---|---|---|
| master HEAD | `eaff4bb` (ahead 4) · dirty 1 | `eaff4bb` · dirty 1 (`M .ai/reports/MASTER-CLI-SLOT-SPEC-AND-COMMIT-FENCE-001/REPORT.md`) | 일치 ✓ |
| 부모 root `CLAUDE.md` | `4f43d1ae` | `4f43d1ae7735b3e8…` (sha-256) | 일치 ✓ |
| app-foundation | `fa7cee5` · dirty 2 | `fa7cee5` · dirty 2 | 일치 ✓ |
| toward-product-docs | `3fe454a` · dirty 3 | `3fe454a` · dirty 3 (`M .auto-memory/incident-log-cowork.md` 포함 = §0.3 선언분) | 일치 ✓ |
| Selfward | `c67d627` · dirty 2 | `c67d627` · dirty 2 | 일치 ✓ |
| 동결 3 | (미인용) | GB `a67a5a3` · GD `912e80a` · GT `6612e4d` | 기록 (쓰기 0 대상) |

baseline mismatch **0** (= A1 정합).

---

## §1. census — 승계값 46 vs 실측, 그리고 그 grep 이 못 본 것

paste §0 의 「46 hit」은 ① cli census 승계값. §7-1 이 「재측정이 정본 · 수치 불일치 = STOP 아님 · 분류가 자」로 명시한 대로 재측정했다.

| 측정 | 명령 | 결과 |
|---|---|---|
| 승계 census (대문자) | `grep -rn 'Gently' docs/rules/ docs/agent/ docs/templates/` | **51 hit / 14 file** (승계 46 ≠ 51) |
| **보강 census (소문자)** | `grep -rni 'gently' … \| grep -v 'Gently'` | **+5 hit / 4 file** |
| 합계 | — | **56 hit** · 미분류 0 |

> ★**본 cycle 의 실질**: 승계 census 명령은 **대소문자를 구분**한다. 그래서 `Gently*` 51 hit 을 전수 분류한 결과 **㉮ = 0** 이었고, 정작 치환이 필요한 살아있는 stale 은 **그 grep 밖 소문자 `gently-product-docs`** 에 있었다. 이것은 직전 `MULTI-REPO-RENAME-TOWARD-001`(92 file 치환)이 남긴 잔존이다.
> **방향은 실물이 실증한다** — 기계층 `scripts/repo-config.sh` 는 이미 `TARGET_REPOS := "app-foundation toward-product-docs Selfward"`. 즉 **문서층만 rename 을 못 따라간 stale** 이며, 치환 방향 판단에 추측이 개입하지 않았다 (= A5 정합).

---

## §2. 3 분류 전수표 (56 hit · 미분류 0)

### ㉮ 브랜드 서술 문면 → **치환 3** (전량 소문자 · 전량 `gently-product-docs` → `toward-product-docs`)

| file:line | 문맥 | 존치 3 해당 여부 |
|---|---|---|
| `docs/agent/architecture/COMMON_ARCHITECTURE.md:4` | 「적용 대상: 4-active — … · `gently-product-docs` · `Selfward`」 | 코드 심볼 X · 동결 계보 X · dated 이력 X → ㉮ |
| `docs/agent/architecture/PROPAGATION_PARAMETERS.md:34` | `REPO_NAME` display name 예시 행 | 동일 → ㉮ |
| `docs/agent/architecture/TESTING_STRATEGY.md:246` | 「cli infra 권장 byte-identical (4-repo · … + `gently-product-docs` + Selfward …)」 | 동일 → ㉮ |

### ㉯ 코드 심볼·API 인용 → **존치 28** (#39 유지층 · 접촉 0)

| file | line | 심볼 | n |
|---|---|---|---|
| `docs/rules/deferred-domains.md` | 52 | `GentlyDayApplication.onCreate()` | 1 |
| `docs/rules/design-to-code-sync.md` | 153·174·179·192·214·217 | `LocalGentlySpacing` · `GentlyTheme` · `GentlyTheme.kt` 실 경로 | 6 |
| `docs/rules/code-principles.md` | 71 | `GentlyTheme` (기본값 제거 사례) | 1 |
| `docs/rules/pencil-theme-multi-axis.md` | 133·136·138·152·156·157·158·164·173·181·185·189·193·196·205·209·215 | `GentlyTheme` · `GentlySpacing` · `LocalGentlySpacing` · `GentlySpacingProvider` · `GentlyBreathTheme` · `GentlyBreath{Light,Dark}ColorScheme` · `GentlyBreathTypography` · `GentlyDeviceTheme` | 17 |
| `docs/agent/audits/TESTING-BACKFILL-AUDIT.md` | 69 | `GentlyButton` 스냅샷 | 1 |
| `docs/rules/sot-code-name-map.md` | 32·83 | `com/gently/selfward/shared/auth/SignInScreen.kt` 실 파일 경로 (appId 패키지) | 2 |

### ㉰ 동결 3 계보 · dated 이력 → **존치 25**

| file | line | 성격 | n |
|---|---|---|---|
| `docs/rules/deferred-domains.md` | 100 | 2026-06-22 dated 이력 entry | 1 |
| `docs/rules/sot-code-name-map.md` | 28·52·78 | GB/GD/GT 매핑 heading = 동결 계보 | 3 |
| `docs/rules/cross-repo-parallel-exec-detail.md` | 25·26·27·132·133·134·220 | 동결 3 repo cwd 예시 | 7 |
| `docs/rules/pencil-pen-format-schema.md` | 42 | 2026-06-15 dated 실측 `.pen` 경로 인용 | 1 |
| `docs/rules/libs-versions-cross-verify.md` | 111 | §7 적용 영역 표 · 동결 3 실명 | 1 |
| `docs/rules/working-file-lifecycle.md` | 38 | 2026-08-15 dated 정정 주석 | 1 |
| `docs/rules/supabase-handling.md` | 241·242·243 | supabase project ↔ 동결 3 매핑 | 3 |
| `docs/rules/pencil-mcp-tools-reference.md` | 47 | MCP active workspace 실측 관측 | 1 |
| `docs/agent/audits/TESTING-BACKFILL-AUDIT.md` | 4·36·37·38 | dated audit HEAD baseline + 측정값 | 4 |
| `docs/agent/architecture/COMMON_ARCHITECTURE.md` | 4 | 괄호부 「GentlyBreath · GentlyDay · GentlyTable = T6 동결 계승 원천」 | 1 |
| `docs/templates/release-checklist.template.md` | 7·33 | placeholder 치환 예시 · 동결 3 실명 | 2 |

> `COMMON_ARCHITECTURE.md:4` = **한 line 에 두 분류 공존** (소문자 토큰 = ㉮ 치환 · 대문자 토큰 3 = ㉰ 존치). 치환은 토큰 단위로 집행했다.

**합계 검산**: 대문자 51 = ㉯ 26 + ㉰ 25 · 소문자 5 = ㉮ 3 + ㉯ 2 · 총 **56 = ㉮ 3 + ㉯ 28 + ㉰ 25** ✓ 미분류 0.

---

## §3. 집행 내역

| # | 항 | 내용 |
|---|---|---|
| 1 | ㉮ 치환 3 | 위 §2 표 · 토큰 단위 · 각 file 1 line |
| 2 | rule 1줄 신설 | `docs/rules/reporting.md` **§8.2** — 「★REPORT 는 자기 commit sha 를 담지 않는다」 (배치 = §8 근거 기록 기준 하위 · §8.1 수치/sha 인용 기준의 형제 자리 = §FREEDOM 행사) |
| 3 | #38 부모 root 정정 | `CLAUDE.md` §2.1 Selfward 행 1 line · 신구 쌍 verbatim (아래 §4) |
| 4 | master commit 1 | `7891342` · 6 file (㉮ 3 + reporting.md + CLAUDE.md §15 + COLD) |
| 5 | §15 + COLD demote | entry 신설 **395B** (≤400B) · 상한 3 유지 · **16 회차** demote = `SELFWARD-PRELAUNCH-SWEEP-002` verbatim → COLD (표 행 grep 0 hit = 최초 수록 · 153→154) |
| 6 | propagation | 4 file → FND/PDOCS/SW · `ok=12 fail=0` |
| 7 | 자식 commit 3 | FND `e792c40` · PDOCS `1777e24` · SW `f62d469` (각 4 file) |

### §3.1 #38 신구 쌍 (부모 root `CLAUDE.md` §2.1 Selfward 행 · 그 외 셀 무변)

- **구**: `**1 앱 N 도메인** (= `shared/` 실측 mood · learning · daily · record · reply · companioninsight · ticketshop 등 · 구 GB+GD+GT 3 도메인 계승 흡수)`
- **신**: `**1 앱 · 단일 기록 축**(= `records` 단일 + 사용자 `theme` + 작성 보조 렌즈 「느낀 것·배운 것·겪은 것」 = 07-26 헌법 재저작 정합 · ★구 `shared/` 도메인 모듈 열거 = **부재 실측**(2026-08-15) · 구 GB+GD+GT 3 도메인 = 계승 흡수 **이력**)`

**신 문면의 주장을 재실측으로 독립 확인** (= 인용이 아니라 근거):

| 주장 | 실측 | 결과 |
|---|---|---|
| 구 판 `shared/` 도메인 모듈 = 부재 | `ls -d Selfward/shared` → `No such file` · `settings.gradle.kts` include = `:composeApp` 단독 (+ `includeBuild ../app-foundation`) | **부재 확인** ✓ |
| 구 판 열거 모듈명 실재? | `composeApp/.../selfward/shared/` 하위 = daily·record·reply·ticketshop 등 실재하나 **mood·learning·companioninsight 부재** | 열거 자체도 오류 ✓ |
| `records` 단일 | `supabase/migrations/20260725120000_r4_record_unify.sql:38` `CREATE TABLE public.records` | 실재 ✓ |
| 사용자 `theme` | 동 migration `:43` `theme text` — 헤더 「'축' 개념 폐기. 기록은 한 종류(records)이고 그 위에 파라미터(theme)가 붙는다」 | 실재 + 의도 일치 ✓ |

⟹ 구 문면은 **층(gradle 모듈 vs UI 패키지)과 내용 양쪽이 틀렸다**. 신 문면의 「부재 실측」 표기가 정확하다.

---

## §4. 게이트 G1~G7 (FAIL 0 · STOP 발동 0)

| G | 자 | 실측 | 판정 |
|---|---|---|---|
| **G1** | 사후 ㉮ 술어 grep (분류표 대조) | commit 실물 `git grep -c 'gently-product-docs' HEAD -- docs/rules docs/agent docs/templates` = **0 hit** · ㉯㉰ = 분류표 전량 등재 · **미분류 0** | **PASS** |
| **G2** | `grep -c 'GentlyTheme\|LocalGentlySpacing'` 전후 | hit **15 line 무변** · 심볼 보유 file 3 (`design-to-code-sync` · `code-principles` · `pencil-theme-multi-axis`) = **`git diff --stat` 변경 목록에 부재** = 접촉 0 | **PASS** (#39 보전) |
| **G3** | 부모 `CLAUDE.md` 1행 정정 실증 | `grep -c 'shared/. 실측 mood'` = **0** · 신 문면 = **1** · line 수 **180 무변** (= 1 line in-place) · 신 sha ↓ | **PASS** |
| **G4** | `verify-sync.sh` | **PASS 161 · DRIFT 0 · MISS 6** (= 선재 master-only 2 file × 자식 3 · #37 · 직전 audit `eaff4bb` 와 동일 수치) | **PASS** |
| **G5** | §15 entry ≤400B · 최근 3 유지 · REPORT 자기 sha 0 | 신 entry **395B** ✓ · 표 행 **3** ✓ · demote 대상 hot 잔존 **0** ↔ COLD 실재 **1** (무손실 대칭) · 본 REPORT 자기 sha **0** | **PASS** |
| **G6** | 동결 3 HEAD · 타 repo 선재 dirty | GB `a67a5a3` / GD `912e80a` / GT `6612e4d` = §0 무변 · 자식 선재 dirty FND 2 / PDOCS 3 / SW 2 = **무변 · 흡수 0** (TPD `M incident-log-cowork.md` = unstaged 분리 확인 후 path-limited commit) | **PASS** |
| **G7** | commit 실물 spot ≥4 (repo 당 1) | `git show HEAD:` 측정 — 4 repo 전량 `toward-product-docs`=1 · `gently-product-docs`=0 · `§8.2`=1 (master `7891342` / FND `e792c40` / PDOCS `1777e24` / SW `f62d469`) | **PASS** |

**부모 root `CLAUDE.md` sha** (git repo 밖 · `shasum -a 256`):
- 구 `4f43d1ae7735b3e80123a0fb6ee1541512eac4d23eedf9689746b6cf63e92f2b`
- **신 `f3f03d754ffa977e4a7229ed96f5c33709044d7fd538ecdf2c55a82b9de57bac`**

**신규 dirty 0** (= scope-외 변경 0 · A3 정합). master 잔존 dirty = 선재 1 + `propagation-status.md` (verify-sync 자동 갱신분 · audit commit 대상).

---

## §5. 유보 열거 (치환 0 · 판정 근거 동반)

§7-2 「문면↔심볼 경계가 갈리면 존치+유보가 기본값 · 브랜드 소거의 완결성보다 #39 보전이 우선」 정합.

| # | 대상 | 성격 | 유보 사유 |
|---|---|---|---|
| **1** | `docs/release-readiness/PACKAGE-OVERVIEW.md` :25 · :30(×3) · :71 · :125 · :165 | 살아있는 서술 + **깨진 상대경로 3** — `../../../gently-product-docs/docs/{PRODUCT-VISION,PRODUCT-PRINCIPLES,PRODUCT-STRATEGY}-SOT.md` (실측: `gently-product-docs` 디렉터리 **부재** · `toward-product-docs` 실재) | **scope 밖** (§2-1 census = `docs/rules·agent·templates` 한정) → §4 STOP ⑸ 정합 무접촉. ★단 이것은 문면이 아니라 **실 breakage** (pointer 가 없는 곳을 가리킨다) — 후속 cycle 권장도 1 순위. `:37` 은 2026-06-06 dated 이력이라 존치가 맞다 |
| **2** | master `CLAUDE.md:1` 「# Gently Master」 · `.gitattributes:1` · `.gitignore:1` (동 문면 · `.gitattributes` 는 「5-repo SoT」 stale 동반) | 브랜드 **제목층** | scope 밖 (census 3 디렉터리 밖) · 자식 4 판 동시 영향 + 헌법 제목 = 별 cycle 의제 |
| **3** | `cross-repo-parallel-exec-detail.md` 동결 3 cwd 예시 7 · `libs-versions-cross-verify.md:111` §7 적용 영역 표 · `release-checklist.template.md:7·33` placeholder 예시 | ㉰ 로 존치했으나 **4-active 미반영 stale 예시** (Selfward 부재 · 동결 3 을 살아있는 예시로 제시) | **브랜드 치환 대상 아님** — `GentlyBreath`→`Toward*` 치환은 오히려 오류를 만든다. 필요한 처분은 **예시 현행화**(동결 3 → 4-active)이며 이는 다른 cycle |
| **4** | `PROPAGATION_PARAMETERS.md:28` 「각 repo 는 `scripts/repo-config.sh` 를 소유하며 아래 변수를 export」 | 문서↔실물 계약 갭 | 실측: TPD `repo-config.sh` **부재** · FND/SW 는 실재하나 `REPO_NAME`/`REPO_PREFIX` **미정의**. 본 cycle 은 같은 표의 **브랜드 토큰만** 접촉 — 계약 갭 정정은 scope 밖 |
| **5** | `verify-sync` 상태문서 부재 참조 6 (`abbreviation-policy.md` · `check-abbreviation.sh` · `code-principles.md` · `design-to-code-sync.md` · `domain-roles.md` · `workflow-core.md`) | 선재 stale ref (`.auto-memory` 상태문서 본문) | 선재 · 본 cycle 무접촉 · #37 계열 |

---

## §6. 신설 rule 전문 (`docs/rules/reporting.md §8.2`)

> ### §8.2 ★REPORT 는 자기 commit sha 를 담지 않는다 (= 2026-08-15 · MASTER-BRAND-TOWARD-INFRA-001)
>
> REPORT 가 자기 자신을 담은 commit 의 sha 를 인용하면, 그 값은 **commit 이 존재한 뒤에만 알 수 있다** — 즉 **backfill(사후 재편집 + 재commit)을 구조적으로 강제**한다. 종단 산출물은 **자기 sha 없이 완결되는 서식**으로 저작한다 (인용 대상 = **선행** commit sha · 자기 commit 은 `[R]` 링크 + cycle-id 로 지시). 근거 = `PDOCS-BRAND-TOWARD-001` 사고.

본 REPORT 자체가 첫 준수 사례 (= 자기 sha 0 · 인용 sha 는 전부 선행 commit).

---

## §7. 산출물

- `propagation-reports/MASTER-BRAND-TOWARD-INFRA-001/{REPORT,DIFF,VERIFY}.md` (= `report-gen.sh` 자동)
- `.ai/reports/MASTER-BRAND-TOWARD-INFRA-001/REPORT.md` (= 본 file)
- `.auto-memory/propagation-status.md` (= `verify-sync.sh` 자동 갱신)

---

고려했으나 hot 제외 영역: ⑴ `docs/release-readiness/` 깨진 pointer 3 (= scope 밖 · 유보 1 · 후속 1 순위) ⑵ 브랜드 제목층 「Gently Master」 3 file (= 유보 2) ⑶ 동결 3 예시의 4-active 현행화 (= 유보 3) ⑷ `repo-config.sh` 문서↔실물 계약 갭 (= 유보 4) ⑸ 승계 census 명령 자체의 대소문자 갭 — 본 cycle 이 보강 census 로 우회했으나 **census 명령 규약화**(대소문자 무시 기본)는 별 의제로 남긴다.
