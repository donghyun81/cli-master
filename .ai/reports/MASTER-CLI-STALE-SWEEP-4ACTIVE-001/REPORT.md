# MASTER-CLI-STALE-SWEEP-4ACTIVE-001 — REPORT

> Mode **M5 cli-infra-ops** · 2026-07-29 KST · production/EF/DB/Money **0 LOC** · 보호 5 **무접촉(sha 0 변동)**
> 본질 = 2026-07-17 `MASTER-T6-REPO-REALIGN-001` 재편(4-active + 3 동결)이 **실행 층**에 미전파된 stale 일소.

---

## §0. BASELINE 재측정 (진입 · paste §0 대조)

| repo | paste 기대 | 실측 | 판정 |
|---|---|---|---|
| claude-cli-master | `3129bebaf3fc` dirty 0 | `3129bebaf3fc` dirty 0 | **정확 일치** |
| app-foundation | `2acddb921b9e` dirty 0 | `4995b8be7f82` dirty 0 | **A1 forward-progress** (ANCESTOR ✓ · 3 commit = `FND-AUTH-MIRROR-HARDEN-010` · `core/supabase` + `.ai/reports` = **cli-infra edit-set 무접촉**) |
| gently-product-docs | `e3454545ef15` dirty 0 | `e3454545ef15` dirty 0 | 정확 일치 |
| Selfward | `0b71929cd564` dirty 31 | `0b71929cd564` dirty 31 | 정확 일치 |

보호 5 git-sha1(12) = `8b46bb4952be` / `68c6c213b18e` / `ce9c0d3e5453` / `7e70e365bb30` / `0d265e0bbc6f` — **5/5 paste 기대 일치** · 마감 시점 재측정 **동일** · `git diff` 보호 5 = **0 file**. STOP #5 미발동.

**paste 자진 정정 3** (= 전제 재측정 · 규칙 1 「부재는 전수 트리에서만 판정」 자기적용):

1. **§0 SW "ahead 34 미push" = 부정확.** 실측 `git rev-list --left-right --count @{u}...HEAD` = **0 0** (upstream `origin/main` 동기). dirty 31 = **전량 untracked**(`.ai/reports/` + `archive/` + `cc-paste-*`).
2. **§3-6 "`claude-wrap.sh` … Selfward slot 부재" = stale.** 실측 = **4 slot** 이미 존재(`supabase-selfward-token` = step 4 · "T2" 주석). Keychain 실측 = 4 slot 전량 **EXISTS** · paste 가 제안한 `supabase-sw-token` = **ABSENT** → **신설 X · 기존 이름 보존**(작동 중 설정 파괴 회피). ⟹ **"Keychain 신설 = Coin 몫" = 불요.**
3. **§0 census "master live 층 75 file" = 과소.** 전수 실측(tracked) = **378 match** · 그중 live 층 = **78**(`.claude/` 19 + `scripts/` 10 + `docs/` 47 + `CLAUDE.md` 1 + `.gitattributes` 1). paste G4 "docs 44(rules 38)" → 실측 **docs 47(`docs/rules/` 36)** + 미열거 5(`docs/architecture/` 2 · `docs/backend/` 1 · `docs/baseline/` 1 · `docs/release-readiness/` 1). 나머지 300 = `.ai/reports/` · `propagation-reports/` · `archive/` · `*COLD*` = **이력 보존 대상**.

---

## §1. 처분표 (census 전수 · 라인 단위)

| 군 | 실측 | 처분 | 결과 |
|---|---|---|---|
| **G1 `.claude/` 19** | 76 line | 현행 지시 = 4-active 정정 · 이력 = 보존 | **19/19 정정** |
| **G2 `scripts/` 10** | 41 line | alias 4종 + T6 lineage = 보존 · 기능 stale = 정정 | **8 정정 · 2 보존**(`repo-config.sh`/`ensure-child-gitignore-patches.sh` = lineage+alias 전용) |
| **G3 master `CLAUDE.md`** | 8 line | T7 기시행 = 전량 정당 | **본문 0 정정** · §15 entry append 만 |
| **G4 `docs/` 47** | 199 line | 오도 live 문면 한정 · 보호 5 무접촉 · 구조 = 후속 | **32 file 정정** · 보호 2 **무접촉** · 1 file **revert**(§3) |
| **G5 부모 root + wrap** | 2 file | §6 pointer 화 · wrap warn+skip | **2/2 정정** |

**보호 5 무접촉 확증**: edit-set ∩ 보호 5 = **∅** · `docs/rules/uiux-sot-refresh.md` + `docs/schemas/ui-spec.schema.json` 은 census 매치 보유했으나 **의도적 미편집**.

---

## §2. 핵심 결함 3 (= 서술 stale 아닌 **실행 결함**)

### ① hooks REPOS 구 6-repo 하드코딩 (paste §1 지목 · P0)

`baseline-snapshot.sh:34-41` + `instructions-loaded-baseline-verify.sh:63` + `measure-gsm-cycle.sh:175` = **활성 자식 Selfward 부재 + 동결 3 측정**.

**추가 발견(paste 미지목)**: `baseline-snapshot.sh:125` drift 루프가 동결 3 의 `cycle-discipline.md` sha 를 master 와 비교 → 동결 3 은 T6 시점 고정이라 **매 SessionStart 영구 false-positive DRIFT 3건**을 뱉고 있었다. 실측: 4-active `05836ebe1300…` ×4 vs 동결 3 `551899306fbd…` ×3.

**§5 FREEDOM 판단 — 동결 3 감시: `REPOS` 에서 제거 · 별 `FROZEN_REPOS` 관찰 유지.**
근거 = parity 비교 대상으로 두면 **영구 오탐**(경보 무뎌짐 = 감시 자체가 죽음). HEAD 만 `"frozen"` key 로 snapshot 에 기록 → **쓰기 0 위반 감지 보존 · 오탐 0**.
실측 결과: parity set = 4-active 정확 · frozen HEAD 기록 `a67a5a3aa235`/`912e80a109d5`/`6612e4d6acdf` · **DRIFT 3 → 0**.

### ② `com.coin.working-file-archiver.plist` = 동결 3 **쓰기** 유도 (신규 발견)

launchd 등록 **활성**(`launchctl list` = `com.coin.working-file-archiver`) · 매일 03:00 · 대상 = master + **GB/GD/GT** · 3 repo 전부 `working-file-archiver.sh` **EXECUTABLE** ⟹ **동결 3 에 실제 쓰기 중** (= 쓰기 0 위반 경로) · 동시에 **Selfward 누락**(= 활성 repo 미archive · SW 도 archiver EXECUTABLE).
→ repo copy = 4-active 로 정정(`plutil -lint` OK). **`~/Library/LaunchAgents/` 사본 갱신 + reload = Coin 몫**(§6).

### ③ `report-gen.sh:71` = 전파 대상 하드코딩

propagation REPORT 의 "자식 repo HEAD" 표가 **동결 3** 을 뽑고 있었다(실 전파 대상과 무관). → `repo-config.sh` source + `$TARGET_REPOS` 로 전환(= SoT 단일화 · 재발 차단).

동류 정정: `pencil-pending-sweep.sh`(활성 `.pen` = **Selfward 14** 인데 REPOS 에 부재) · `save-as-result-check.sh`(wrong-repo 검사 2→5 repo) · `nightly-baseline-report.sh`(문면 · 기능은 `$TARGET_REPOS` 라 이미 정상).

---

## §3. 사고 + 자기정정 3

### ★ 사고 1 — **PAT 4종 세션 transcript 노출 (Coin 조치 필요)**

`claude-wrap.sh` dry-run 시 **내 검증 harness** 가 `${n:-UNSET}` 을 써서 마스킹 의도와 **정반대로 값을 출력**했다. 노출 = `SUPABASE_ACCESS_TOKEN_{SELFWARD,GB,GD,GT}` **4개 전량**.

- **wrap script 자체 결함 아님** (`inject_token` 은 값을 출력하지 않음 · grep 0 match 확증).
- **디스크 기록 0** — 4-active + `~/bin` 전수 `sbp_` scan = **0 match**.
- ⟹ **노출 = 세션 transcript 한정**. **Coin 조치 = 4 PAT rotation 권장**(Supabase 콘솔 · 회수 대상).
- 재발 차단 = `safety-and-secrets.md §평문 차단 의무` 에 **규칙 신설**(`${v:-UNSET}` 금지 · 안전형 `[ -n "$v" ] && echo SET || echo UNSET` · "검증 harness 자체가 노출 경로다").

### 사고 2 — G4 기계 스윕이 **역사 서술 훼손** (§6-E 발동 · 자기 검출·복구)

토큰 스윕(92 line/33 file)이 date-guard 로 못 거른 **서사형 역사 문장**을 오염:
`PACKAGE-OVERVIEW.md` "propagation 대상이 5**→6-repo** 로 확장됐다" → "5**→4**-repo" (= 무의미) 외 다수.
→ **diff 전수 감사에서 자기 검출** → 해당 file **wholesale revert**(무접촉 복귀) + 후속 회부. 잔여 half-done 열거 6 file(4-repo 라벨 ↔ 구 6-repo 열거 병존) 개별 정정.

### 사고 3 — **master-only file 오전파 → 즉시 복구**

`CLI-MASTER-SCOPE-SEPARATION-CHARTER.md`(자기 선언 = "cli-master `docs/architecture/` 소속" · §15 = 의도적 MISS)를 변경분에 섞어 3 자식 전파. verify-sync **MISS 6→3** 이상 신호로 검출 → 자식 3 측 unstage + 삭제(전량 `A` staged-new = 사전 부재 확증 → 무손실) → **MISS 6 복귀**.

### 사고 4 — zsh word-split (선례 재발 · **파일 변경 0**)

`propagate.sh $FILES` 가 zsh 에서 미분할 → `files: 1 개` · **ok=0 fail=3**. 자식 dirty/staged **불변 확인**(무해 실패) → `bash -c` 내부 분할로 재실행 성공. (§15 선례 = S3-001 · SETTLE-001 동형 · MEASUREMENT-DISCIPLINE-001 은 literal 인자로 회피.)

---

## §4. 검증

| 항목 | 결과 |
|---|---|
| `bash -n` | hooks 4 + scripts 8 = **12/12 OK** · `plutil -lint` plist **OK** |
| hook 실동작 | `baseline-snapshot.sh` exit 0 · JSON valid · parity=4-active · frozen=3 HEAD · **DRIFT 3→0** |
| `TARGET_REPOS` clean-env | `app-foundation gently-product-docs Selfward` = **behavior 불변**(주석 편집 무영향) |
| propagate | **ok=150 fail=0** (50 file × 3) · `run-master/SKILL.md` = C16 가드로 **의도적 제외**(51−1) · **`--prune` 미사용 · `--all` 미사용** |
| verify-sync | **163 PASS / DRIFT 2 / MISS 6** = T6·T7·S3·SETTLE·MEASUREMENT post-state **동일** = **신규 drift 0** |
| DRIFT 2 | `release-checklist.template.md` FND/PDOCS = **P4-lazy pre-existing**(Selfward=✓) |
| MISS 6 | CHARTER ×3 + `production-cli-access-tokens.md` ×3 = **master-only pre-existing**(후자는 `.gitignore:42` `*-access-tokens.md`) |
| 보호 5 | sha **5/5 불변** · `git diff` **0 file** |
| production | **0 LOC** (변경 확장자 = `.md` / `.sh` / `.plist` 단독) |
| 동결 3 | **파일·커밋 0** (HEAD `a67a5a3`/`912e80a`/`6612e4d` 불변) |
| D-6 커밋 집합 대조 | 자식 3 각 **50/50 exact** · scope 밖 0 · **SW untracked WIP 32 무흡수** |

---

## §5. step 9 관측 (변경 0)

- **`claude doctor`** = TUI · 비대화 실행 불가(본 환경 `timeout` 명령 부재) → **skip · Coin 터미널 몫**.
- **CC version** = **2.1.220** (SessionStart hook 주입값과 일치).
- **CC native auto-memory = 활성**. `~/.claude/projects/<project>/memory/` 실재 · 본 project = `MEMORY.md` + memory 1 = **2 file**. `.claude/settings.json` = memory 관련 key **0**(top-level = `permissions` / `hooks` 뿐) ⟹ **settings 설정 아닌 CC 기본 활성**. 동결 3(GB/GD) project memory dir 도 잔존.

---

## §6. Coin 회수 (cli 소관 밖)

1. **★ PAT 4종 rotation** (= §3 사고 1 · Supabase 콘솔).
2. **archiver plist 반영**: `cp scripts/com.coin.working-file-archiver.plist ~/Library/LaunchAgents/` + `launchctl unload/load` (= 동결 3 쓰기 중단 + Selfward 편입 실효화). 미반영 시 **동결 3 쓰기 계속**.
3. `git push` (= 4-active 4 repo).

## §7. 후속 (scope 외 · 보고만 · 자율 진입 X)

- `PACKAGE-OVERVIEW.md` topology 재저작 (= §3 사고 2 revert 분 · 역사 서술 보존하며 현행화 = 별 cycle).
- **`nightly-baseline-report.sh` 가 `claude -p` 호출** — A6 「영역 3 회피」 정면 위반 · launchd **활성 등록**(`com.coin.nightly-baseline-report`) = Agent SDK credit pool 과금 경로. 본 cycle scope 밖(topology stale 아님) → **별 판단 회부**.
- `Selfward/.ai/reports/WALKTHROUGH/walkthrough.html` = **tracked file 에 JWT 12 match**(`sbp_` 0 · mtime 07-29 03:08 = 본 세션 무관 · pre-existing). anon key 면 무해하나 **확인 필요** = 별 cycle(도메인 repo).
- master `.mcp.json` = supabase **gb/gd/gt 3 server** 등록 · **Selfward server 부재**(wrap 은 `SUPABASE_ACCESS_TOKEN_SELFWARD` export 중) = 비대칭.
- verify-sync stale-ref 5 (= DIET-2-003 후속 pre-existing) · `docs/rules/` 구조 다이어트 = DIET-3.

---

## §8. Negative Space Line

고려했으나 hot 제외 영역: 보호 5(무접촉 의무) · production/EF/DB/Money(0 LOC) · 동결 3 repo 쓰기(0) · `docs/rules/` 구조 개편(DIET-3) · `PACKAGE-OVERVIEW.md`(사고 2 revert) · `nightly-baseline-report.sh` 의 `claude -p`(A6 · 별 판단) · `~/Library/LaunchAgents/` 실사본(Coin) · alias GB/GD/GT/FND 4종(v17.6 보존) · `--prune`(미사용) · cowork 3 file · `docs/ops/production-cli-access-tokens.md`(gitignored master-only).
