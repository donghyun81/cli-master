# MULTI-REPO-RENAME-TOWARD-001 — REPORT

> **cycle** = repo명 `gently-product-docs` → `toward-product-docs` (Gently → Toward 브랜드층)
> **집행** = 2026-08-15 KST · 부모 mount 진입 (T6형 · 매핑표 #6 「repo 재편·이름 변경」)
> **paste source** = `~/AndroidStudioProjects/cc-paste-MULTI-REPO-RENAME-TOWARD-001.md`
> **선행 의존** = ① `PDOCS-BRAND-TOWARD-001` 착지 확인 (`1532a81` → PDOCS HEAD `86ab577`) — R2-B 순서 준수

---

## §0. BASELINE 재측정 (진입 시점 · paste §0 대조)

| 항 | paste §0 (17:0x cowork) | cli 실측 | 판정 |
|---|---|---|---|
| master HEAD | `8bfd718` | `8bfd718` | 일치 |
| FND HEAD | `b6f34eb` | `b6f34eb` | 일치 |
| PDOCS HEAD | ① 착지 후 재측정 | `86ab577` | ① 착지 확인 |
| SW HEAD | `fe58e08` | `fe58e08` | 일치 |
| 부모 CLAUDE.md sha | `aed9af7b` 예상 | `aed9af7b` | 일치 |
| 동결 3 HEAD | — | GB `a67a5a3` · GD `912e80a` · GT `6612e4d` | 기록 |

**선재 dirty** (= 본 cycle 무관 · 흡수 0 의무): master ` M .ai/reports/MASTER-CLI-SLOT-SPEC-AND-COMMIT-FENCE-001/REPORT.md` · FND `?? app-foundation` `?? cc-paste-FND-F3-KDOC-COORD-FIX-001.md` · PDOCS `?? .ai/reports/PDOCS-SHARED-QUESTION-POOL-P6-LAND-001/` `?? archive/` · SW `?? .ai/_scratch/` `?? supabase/_ops/mgmt-auth-anon-off.ts`

### census 대조 (= paste §7-1 「수치 아닌 술어가 자」 정합)

paste §0 census (29/11/34/31/54) = 살아있는-층 근사. cli 실측 = **§1 술어 기준 기계층 분해**:

| repo | paste 근사 | 기계층 실측 | 비고 |
|---|---|---|---|
| master | 29 | **29** | 일치 (= .claude 9 + docs/rules 10 + scripts 9 + CLAUDE.md 1) |
| FND | 11 | **21** | paste 근사는 `.claude`+`CLAUDE.md`+`scripts` 11 만 셈 · **자식 `docs/rules/` 10 누락** |
| SW | 34 | **21** | paste 근사 34 = 이력층 포함 값 · 기계층 술어 = 21 |
| PDOCS | 31 | **20** | 동상 · 기계층 = 20 |
| 부모 root md | 54 | **56 중 기계층 1 + 안내층 2** | 나머지 53 = 이력층 존치 |

★**자식 `docs/rules/` 편입 근거** = `verify-sync.sh:128` FULL mode 가 `find .claude docs …` 전 트리를 master ↔ 자식 byte-identical 대조 → 자식 `docs/rules/` 미치환 시 **G4 DRIFT 30 발생**. paste §1 기계층 술어(「실행·자동로드 파일」) 정합이자 G4 통과 필요조건.

---

## §1. 집행 결과 (§2 step 순서)

### step 1 — dir rename

`mv gently-product-docs toward-product-docs` (부모 root · git 밖). 내부 `.git` 무접촉 → HEAD `86ab577` 유지 · remote URL 무변.

### step 2~3 — 치환 전수표 (총 **95 file**)

| 층 | repo / 위치 | file | 내역 |
|---|---|---|---|
| 기계 | master | **29** | `.claude/` 9 (agents 1 · hooks 3 · rules 3 · skills 2) + `docs/rules/` 10 + `scripts/` 9 + `CLAUDE.md` 1 |
| 기계 | app-foundation | **21** | `.claude/` 9 + `docs/rules/` 10 + `scripts/pencil-pending-sweep.sh` 1 + `CLAUDE.md` 1 |
| 기계 | Selfward | **21** | 동상 |
| 기계 | toward-product-docs | **20** | `.claude/` 9 + `docs/rules/` 10 + `CLAUDE.md` 1 (= `scripts/` 구 이름 hit 0) |
| 기계 | 부모 root | **1** | `CLAUDE.md` (= `claude-wrap.sh` · root `.claude/` · root `scripts/` 전량 hit 0) |
| 기계 | **repo 밖 배포 사본** | **1** | `~/Library/LaunchAgents/com.coin.working-file-archiver.plist` (§3-b 참조) |
| 안내 | 부모 root | **2** | `STATUS-NOW-SSOT.md` 1 hit · `cc-handoff-SELFWARD-v14-20260815.md` 5 hit (§3-a 참조) |

★paste §2-2 지정 좌표 전량 포함 확인: `docs/rules/working-file-lifecycle.md` §3 위치 목록(:44) · `scripts/com.coin.working-file-archiver.plist` :11 5-경로 loop · `scripts/repo-config.sh` TARGET_REPOS(:18 주석 · :28 · :29).

### step 4 — commit

| repo | commit | file | 비고 |
|---|---|---|---|
| claude-cli-master | `631b092` | 30 | 29 치환 + `.auto-memory/master-cycle-history-COLD.md` (§15 demote) |
| app-foundation | `fa7cee5` | 21 | |
| toward-product-docs | `3fe454a` | 20 | |
| Selfward | `c67d627` | 21 | |
| 부모 root (git 밖) | 직접 | 3 | `CLAUDE.md` · `STATUS-NOW-SSOT.md` · `cc-handoff-SELFWARD-v14-20260815.md` |

master `CLAUDE.md §15` = entry 1 신설 + 상한 3 초과분 즉시 COLD demote (= `MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001` verbatim append · 15 회차 · demote 직전 COLD 전수 grep **표 행 0 · 어떤 형태 언급도 0** = 최초 수록). COLD diff = **append-only** (구 이름 삭제 줄 0 · 신 이름 추가 줄 0 · entry 수 152→153 bookkeeping 만).

### step 5 — 동작 검증

| # | 검증 | 결과 |
|---|---|---|
| ⑴ | `verify-sync.sh --no-update` | targets = `app-foundation toward-product-docs Selfward` 정상 해석 · files 163 · **PASS 161 / DRIFT 0 / MISS 6** · exit 1 |
| ⑵ | `plutil -lint` (repo판 + 설치본) | 양쪽 **OK** |
| ⑶ | archiver dry (설치본 plist :11 5-loop) | **5/5 RUN · skip stderr 0 줄** |
| ⑷ | hooks repo 목록 변수 | `baseline-snapshot.sh` REPOS[] · `instructions-loaded-baseline-verify.sh:66` REPOS · `measure-gsm-cycle.sh:175` 전량 신 이름 · 구 이름 잔존 0 |
| +⑸ | 변경 `.sh` 12 file `bash -n` | **12/12 OK** |

★**MISS 6 = 선재분** (= `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` + `docs/ops/production-cli-access-tokens.md` × 자식 3 = master-only 2 file). 직전 cycle 감사 commit 기록 「verify-sync = PASS 161 / DRIFT 0 / MISS 6 (전량 pre-existing master-only 2 file x 3 자식)」과 **수치 동일** ⟹ 본 cycle 신규 drift 0. exit 1 = 그 선재 MISS 에 대한 script 판정이며 본 cycle 유래 아님.

---

## §2. 게이트 (§3 표)

| G | 자 | 결과 |
|---|---|---|
| **G1** | `ls -d toward-product-docs` + `git -C … status` | **PASS** — dir 실재 · HEAD `86ab577` 유지 · dirty = 선재 2 · remote 무변 |
| **G2** | 기계층 술어 경로 `grep -rln 'gently-product-docs'` 사후 | **PASS (0 hit)** — 단 §15 이력 entry 1줄 = **의도적 존치** (아래 주) |
| **G3** | 이력층 무접촉 (`archive/`·`.ai/`·`.auto-memory/` 부재) | **PASS** — 자식 3 = 0 · master 1 = `.auto-memory/master-cycle-history-COLD.md` (= §15 규약이 마감 step 안에서 강제하는 demote · append-only · 이름 치환 0) |
| **G4** | verify-sync + plutil + archiver dry | **PASS** — DRIFT 0 · plutil OK ×2 · archiver skip 0 |
| **G5** | 부모 root 원장 신 sha + `grep -c` ≥1 | **부분 PASS** (아래 표) |
| **G6** | 동결 3 HEAD 무변 + 선재 dirty 흡수 0 | **PASS** — GB `a67a5a3` · GD `912e80a` · GT `6612e4d` 무변 · 선재 dirty 7건 전량 미staged 잔존 |
| **G7** | commit 실물 spot 6 `git show HEAD:<path>` | **PASS (7 spot)** |

### G2 주 — 의도적 존치 1줄

`claude-cli-master/CLAUDE.md:302` = 본 cycle 의 §15 이력 entry. 「repo명 `gently-product-docs` → `toward-product-docs`」 서술이므로 **구 이름을 적는 것이 기록의 내용 자체**. 잔여물 아님 (= 감사 추적 요건).

### G5 실측

| file | 신 sha[:8] | 구 sha[:8] | `toward-` hit | `gently-` hit |
|---|---|---|---|---|
| 부모 `CLAUDE.md` | **`4f43d1ae`** | `aed9af7b` | 5 | 0 |
| `STATUS-NOW-SSOT.md` | **`5c9f333f`** | — | 1 | 0 |
| `cc-handoff-SELFWARD-v14-20260815.md` | **`d8efe953`** | — | 5 | 0 |
| `RULES-COWORK-RULER-LEDGER-SSOT.md` | `fcc17461` (**무변**) | 동 | **0** | **0** |

★`RULES-…-LEDGER-SSOT.md` = G5 의 「≥1」 미충족. **근거 = 구 이름 hit 도 0** (= 원장이 애초에 repo 이름을 참조하지 않음) ⟹ 접촉 불요이지 누락 아님. paste §7-1 (「수치 불일치 = STOP 아님」) 정합.

### G7 spot 7

1. master `scripts/repo-config.sh:29` `TARGET_REPOS:=app-foundation toward-product-docs Selfward`
2. master `scripts/com.coin.working-file-archiver.plist` 5-경로 = `/` `claude-cli-master` `app-foundation` `toward-product-docs` `Selfward`
3. master `CLAUDE.md:60` §1.2 `| toward-product-docs (PDOCS) | … | <PARENT>/toward-product-docs |`
4. FND `.claude/rules/stop-canonical.md` hit 1
5. PDOCS `CLAUDE.md` hit 3
6. SW `docs/rules/working-file-lifecycle.md:44` `~/AndroidStudioProjects/toward-product-docs/archive/`
7. master `.claude/hooks/baseline-snapshot.sh` :3 · :39 · :150

---

## §3. 자 확장 2건 (= paste 문면 대비 · 근거 + 되돌리기 동봉)

### §3-a. handoff v14 — 「§11 한정」 → file 전체 5 hit

paste §1 = 「`cc-handoff-SELFWARD-v14-…`(★§11 진입 프롬프트의 경로만 — 본문 이력 서술 존치)」.

**실측**: §11(:161~ 진입 프롬프트 블록) = 구 이름 **hit 0**. 실 hit 5 의 분포 —

| 줄 | 위치 | 성격 |
|---|---|---|
| :76 · :82 · :84 | **§4 「진입 시 재야 할 것 (인용 금지 · 전부 재측정)」 코드블록** | **작동 표면** — 다음 세션이 그대로 붙여 실행하는 블록 |
| :55 | §2 「★회사 운영 문서 = …/docs/company/ 6축 파일이 진입점」 | **live pointer** (이력 서술 아님) |
| :145 | §9 「SoT / memory 포인터 — 회사 축 = …」 | **live pointer** (이력 서술 아님) |

**판정 근거** = paste §7-2 가 명시한 자 그대로: 「진입 프롬프트는 박제가 아니라 **작동 표면**(경로가 죽으면 다음 세션이 죽는다)」. §11 은 그 자의 *추정 위치*였고, 실제 작동 표면은 §4 블록이었다. §55·§145 는 「본문 **이력** 서술」이 아니라 live pointer 이므로 존치 조항의 보호 대상이 아니다 ⟹ **5 전량 치환**. 파일 자체는 paste §1 이 지명한 살아있는 안내층이므로 신규 file 편입 = 0 (scope 확장 아님 · 술어 적용).

**되돌리기 1줄**: `sed -i '' 's|toward-product-docs|gently-product-docs|g' ~/AndroidStudioProjects/cc-handoff-SELFWARD-v14-20260815.md`

### §3-b. repo 밖 배포 사본 plist 1

**실측**: `~/Library/LaunchAgents/com.coin.working-file-archiver.plist` = 구 경로 보유. repo 판(치환 전 `HEAD~1`)과 **byte-identical** (= 심링크 아닌 순수 배포 사본 · 차이는 이름 토큰 1 뿐) 확인 후 동일 치환 적용 → repo 판과 재일치 · `plutil -lint` OK.

**근거**: paste §1 기계층이 `plist` 를 명시 지명 · paste §7-4 「누락 층(`~/.claude` 사용자 전역 등)은 **네 실측이 정본**」. **치환하지 않으면 §2-6 의 launchd 재적재만으로는 발효 불가** (= bootstrap 이 읽는 실물이 이 파일). 단 `launchctl` 호출 자체는 §2-6 대로 **Coin 실기로 남겨 둠** (cli 미실행).

**되돌리기 1줄**: `sed -i '' 's|toward-product-docs|gently-product-docs|g' ~/Library/LaunchAgents/com.coin.working-file-archiver.plist`

---

## §4. 판정 유보 열거 (= 치환 X · §1 「미확정 = 치환 말고 열거」 정합)

| # | 대상 | hit | 유보 근거 |
|---|---|---|---|
| 1 | `cowork-project-instructions.md` (2) · `-FULL.md` (7) · `-H3-COLD.md` (1) | 10 | **cli scope 밖 명문화** — `stop-canonical.md` 머리말 「`cowork-project-instructions.md §D-1` = cowork sandbox 영역 (= 본인 manual paste replace · cli scope X)」. Coin manual 몫 |
| 2 | `cc-paste-PDOCS-COMPANY-AXIS-POLISH-001.md` | 1 | **미집행 발행 대기 paste** (= handoff v14 §3-1 「발행 승인 대기」). §1 이력층 정의는 「cc-paste **기집행분**」이므로 이 건은 이력층 아님 · 집행 시점 경로 갱신 필요 |
| 3 | `cowork-handoff-active.md` | 10 | 이름은 active 이나 **hit 10 전량이 dated trail 서술**(:23 chat 마감 실측 · :30 cycle 0 paste-back · :271 항목 ③ PASS 등) = 이력층 판정 → 무접촉 |
| 4 | `~/.claude/sessions/12661.json` | 1 | **Claude Code 내부 런타임 상태** (기동 시점 cwd 스냅숏) · 우리 기계층 아님 · 세션 재기동 시 갱신 |
| 5 | `~/.claude/projects/-Users-…-gently-product-docs/` transcript dir | 다수 | cc 내부 세션 이력 디렉터리 · 신 cwd 진입 시 새 디렉터리 자동 생성 |
| 6 | 부모 root 직속 md **53** (dated 산출물 · 구 handoff v12/v13 · 기집행 cc-paste · cowork-* charter/audit) | — | §1 이력층 = 무접촉 (당시 사실) |
| 7 | 각 repo `.auto-memory/` · `.ai/reports/` · `archive/` | — | 동상 |

---

## §5. 관측 (변경 아님)

1. **live cli session 1 이 구 경로에서 기동 중** — pid 12661 (`claude --dangerously-skip-permissions` · 기동 cwd = 구 `gently-product-docs`). `mv` 는 동일 파일시스템 inode 보존이므로 **실 cwd 는 `toward-product-docs` 로 자동 추종** (`lsof` 실측) ⟹ 파손 0. 단 그 세션의 in-context 경로 문면은 구 이름이므로 **재기동 권장**.
2. **handoff v14 :145 의 원장 sha 인용이 stale** — v14 는 `RULES-COWORK-RULER-LEDGER-SSOT.md`(`83aa0371`) 로 적었으나 실측 `fcc17461`. 본 cycle 무접촉 파일이므로 **선재 drift** (본 cycle 유래 0).
3. **git-lock daemon 미활성** — `verify-sync` 진입 진단 「plist 존재하나 load 안 됨」. C12 사고 패턴 (0-byte stale `index.lock` 이 commit 차단) 재발 위험. 해소 = `launchctl load ~/Library/LaunchAgents/com.coin.git-lock-cleaner.plist` (Coin 실기).
4. **verify-sync 상태문서 stale ref 6** — `protected-file-hashes.md` 5 + `propagation-status.md` 1 이 부재 파일 참조 (`check-abbreviation.sh` · `abbreviation-policy.md` 등 = `MASTER-CLI-JUDGMENT-SHIFT-001` 제거분). 선재 · 본 cycle 무관 · 별 mitigation cycle 후보.

---

## §6. STOP / FAIL

**STOP 발동 0 · FAIL 0.** paste §4 STOP 5항 전량 미발동 — ⑴ G1 정상 ⑵ 판정 불가 hit = §4 유보 열거로 처리(치환 0) ⑶ 동결 3·appId·코드 심볼 무접촉 ⑷ `propagate.sh` 미경유(= 치환 commit 만 · byte-identical 는 G4 판정) ⑸ scope 밖 신규 file 편입 0.

고려했으나 hot 제외 영역: 부모 root 이력층 md 53 일괄 치환 (= §1 술어상 존치가 정답) · `~/.claude` transcript 층 (= cc 내부 관할).
