# MASTER-LIFECYCLE-4ACTIVE-REALIGN-001 — REPORT

> **cycle** = archiver 계 4-active 정합 (R2 §7 확정 5항 · Coin 결정 일수 **7**) + 부모 CLAUDE.md 회사 축 등재(#33) + archive 직속 1건 정리(#22) + run-master 실체 관측(#6)
> **Mode** = M5 (cli 운영 레이어) · **마감** = 2026-08-15 KST · **production 0 LOC** · **보호 5 sha 무접촉**
> **원천** = `cc-paste-MASTER-LIFECYCLE-4ACTIVE-REALIGN-001.md` (cowork 발행) · scope SoT = `DESIGN-OPS-R2-DOC-SYNC-ENFORCE-20260815.md` §7

---

## §0. BASELINE 재측정 (진입 시 전량 재측정 · paste §0 대조)

| 항 | paste §0 인용 | cli 실측 | 판정 |
|---|---|---|---|
| master HEAD | `b9812ff` (ahead 0) | `b9812ff` · `## main...origin/main` = **ahead 0** | 일치 |
| master 선재 dirty | `M .ai/reports/MASTER-CLI-SLOT-SPEC-AND-COMMIT-FENCE-001/REPORT.md` 1행 | 동일 1행 | 일치 |
| script `:15` | `MTIME_THRESHOLD_DAYS=7` | `15:MTIME_THRESHOLD_DAYS=7` | 일치 |
| plist `:11` | 5경로 loop · `[ -x ] &&` 조용 skip | 동일 (부모+master+FND+PDOCS+SW) | 일치 |
| script 실배포 | master·SW·부모root 실재 / **FND·PDOCS 부재** | 동일 (3 실재 / 2 부재) | 일치 |
| rule §3 | 「archive 위치 5」 T6 재편 미반영 **의심** | **확정** — GentlyBreath / GentlyDay / GentlyTable 열거 (§9-1 전문 정독) | 의심 → 확정 |
| stale 1 | `reporting.md:18` 「mtime 14일」 = 유일 | `grep -rln '14일' docs/rules/` = **1본** | 일치 |
| 부모 CLAUDE.md | `607b02f6` | **607b02f6** (편집 후 역산 대조 · §G8) | 일치 |
| #22 대상 | 직속 실재 · `archive/2026-07/` 실재 | 동일 | 일치 |
| #6 대상 | `.claude/commands/run-master` — 실체 미판정 | **좌표 오류** — 아래 §4 | 정정 |

**A1 baseline mismatch = 0.** 진입 좌표 전량 실측 일치 (§6 STOP ⑴ 미발동).

---

## §1. 변경 (master commit `bfb8f9c` · 6 file)

| # | file | 변경 |
|---|---|---|
| ⑴ | `docs/rules/reporting.md` | §1 인접 「mtime **14일** fallback」 → 「**7일**」 + 일수 SoT pointer(script 상수 정본 · 본 문면 = 인용) + trigger 문면에 `REPORT.md` 병기 |
| ⑵ | `docs/rules/working-file-lifecycle.md` | §3 위치 = 동결 3 열거 → **plist 실물 5 경로**(정정 고지 병기) · §1 패턴 = 「script `sweep_candidates()` 정본 · 본 절 발췌」 pointer 형(구 5종 → 실측 root **9종** + `.ai/prompts`) + `is_excluded()` 2종 반영 · §2 머리 = 일수 SoT 문단 · §4 trigger 종류 + `REPORT.md PASS` · §5(b) 갱신 |
| ⑶ | `scripts/working-file-archiver.sh` | `REPORT_BASENAMES="REVIEW.md REPORT.md"` 도입 · repo-local + sibling 양 경로 적용 · `MATCH_BASENAME` 으로 INDEX trigger 칸에 실제 매칭 file 명 기록 |
| ⑷ | `scripts/com.coin.working-file-archiver.plist` | `[ -x ] && run` → `if/else` + `echo "archiver skip: $r" 1>&2` |
| ⑸ | `CLAUDE.md` §15 | entry 1행 append (**397B** ≤ 400B) |
| ⑸' | `.auto-memory/master-cycle-history-COLD.md` | 상한 3 초과분 **즉시 demote** (`cycle-discipline.md §15` ② · advisory 대기 금지) |

부모 root (git 밖 · 직접): ⑹ `CLAUDE.md` §2.1 PDOCS 셀 1곳 · ⑺ `archive/HANDOFF-SELFWARD-IA-REFRAME-20260724.md` → `archive/2026-07/`

---

## §2. 게이트 실측 (자 = 명령 · 전문)

### G1 — `grep -rln '14일' docs/rules/`
```
hit = 0
```
**PASS.** (§9-5 교차: `grep -rln '14일' .claude/` = **0 hit** — skills·commands·hooks 층 잔존 없음. master 전역 잔여 4본 = COLD 이력 1 + `archive/` 구 paste 2 + `.ai/reports/` 1 = 전량 **이력 영역** · `docs/templates/release-checklist.template.md` 1본 = 아래 §5 회부)

### G2 — `grep -c 'MTIME_THRESHOLD_DAYS' docs/rules/{reporting,working-file-lifecycle}.md`
```
docs/rules/reporting.md:1
docs/rules/working-file-lifecycle.md:1
15:MTIME_THRESHOLD_DAYS=7      # script 상수 무변
```
**PASS** (각 ≥1 = pointer 성립 · script `:15` = `=7` 무변).

### G3 — rule §3 위치 목록 ↔ plist `:11` 5경로 문자열 대조
```
diff <(plist 5경로) <(rule §3 5경로) → 차이 0
G3 = PASS (5/5 문자열 일치)
```
5경로 = `~/AndroidStudioProjects` · `/claude-cli-master` · `/app-foundation` · `/gently-product-docs` · `/Selfward`. **PASS.**

### G4 — 자식 3 script 실재 + `x` 비트
```
-rwxr-xr-x  6560  app-foundation/scripts/working-file-archiver.sh        (신규)
-rwxr-xr-x  6560  gently-product-docs/scripts/working-file-archiver.sh   (신규)
-rwxr-xr-x  6560  Selfward/scripts/working-file-archiver.sh              (갱신)
```
commit 측에도 `create mode 100755` 실착지 (FND·PDOCS). **PASS.**

### G5 — verify-sync + 전파 3본 sha 대조 (★`git show HEAD:` 판 = commit 실착지)
| file | master | FND | PDOCS | SW |
|---|---|---|---|---|
| `scripts/working-file-archiver.sh` | `86631437201ad748` | 동일 | 동일 | 동일 |
| `docs/rules/working-file-lifecycle.md` | `dc216f2f6c66e8fd` | 동일 | 동일 | 동일 |
| `docs/rules/reporting.md` | `128da90c0c53076d` | 동일 | 동일 | 동일 |

`verify-sync.sh` = **PASS 161 / DRIFT 0 / MISS 6**. **본 cycle 신규 drift 0** (MISS 6 = `CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` + `production-cli-access-tokens.md` **master-only** × 3 자식 = 전량 pre-existing). 직전 baseline 의 DRIFT 2(release-checklist.template)는 **이미 해소된 상태로 관측**. **PASS.**

### G6 — plist skip 분기 실측 (부재 경로 dry)
```
[stderr] archiver skip: /Users/yundonghyeon/AndroidStudioProjects/app-foundation
[stderr] archiver skip: /Users/yundonghyeon/AndroidStudioProjects/gently-product-docs
[stderr] archiver skip: /Users/yundonghyeon/AndroidStudioProjects/NO-SUCH-REPO
```
stderr 1줄/경로 출력. `plutil -lint` = OK. **PASS.**
(FND·PDOCS 는 본 cycle 로 script 가 배포됐으므로 재적재 후 실사양에서는 `NO-SUCH-REPO` 같은 진짜 부재만 남는다.)

### G7 — script `REPORT.md` 인정 (★실 report 데이터 대조 · 부작용 0)
실 script 본문에서 판정 함수 3조각을 verbatim 추출해 eval (사본 아님 · file 생성 0):
```
REPORT_BASENAMES = [REVIEW.md REPORT.md]

(A) REPORT.md-only cycle  C1-MASTER-BOOTSTRAP-001    MATCH via=REPORT.md
                          C3-AUTOMATION-SCRIPTS-001  MATCH via=REPORT.md
                          C4-VERIFY-001              MATCH via=REPORT.md
(B) REVIEW.md 우선순위    CLAUDE-CODE-LATEST-CHASE-POLICY-CLARIFY-001  MATCH via=REVIEW.md
                          CLAUDE-CODE-VERSION-UNPIN-VERIFY-001         NOMATCH  ← REVIEW 존재하나 PASS 아님
(C) ★빈 task_id                                                        NOMATCH
(D) task-ID 有 · report 부재  NO-SUCH-TASK-999                         NOMATCH
```
**PASS.** (B)의 NOMATCH 가 **PASS 판정이 여전히 강제됨**(= file 존재만으로 통과 X)을, (C)가 **task-ID 요건 유지**를 각각 실증. `bash -n` = OK.

### G8 — 부모 CLAUDE.md
```
grep -c '회사 운영 문서 축' CLAUDE.md  = 1        (26행 = PDOCS 행 단독)
신 sha (shasum -a 256 [:8])            = aed9af7b
역산 대조: 삽입 구절 제거판 sha        = 607b02f6  ← §0 baseline 정확 일치
diff(역산판, 현행판) 행 수             = 2 (1< / 1>) = 해당 셀 1곳
master §15 신 entry                    = 397B ≤ 400B
```
**PASS.** (★부모 root 는 git 밖이라 사후 되돌리기 근거가 없다 — 편집 전 sha 를 못 잡았으므로 **삽입 구절만 제거한 판을 재구성해 baseline 과 대조**하는 방식으로 「그 외 무변」을 증명했다.)

### G9 — #22 mv
```
이동 전  51c562f36270cea52a85b0c4d4c771ff8561a9b7a446feb5e6118ee07a902091
도착     51c562f36270cea52a85b0c4d4c771ff8561a9b7a446feb5e6118ee07a902091   (동일)
ls archive/ | grep -c 'HANDOFF-SELFWARD-IA-REFRAME'  = 0
도착지 충돌 = 없음
```
**PASS.**

### G10 — 동결 3 + 타 repo 선재 dirty
| repo | HEAD (paste 기대) | 실측 | dirty |
|---|---|---|---|
| GentlyBreath | `a67a5a3` | `a67a5a3` | 104 (선재) |
| GentlyDay | `912e80a` | `912e80a` | 74 (선재) |
| GentlyTable | `6612e4d` | `6612e4d` | 70 (선재) |

**PASS** — 동결 3 파일·커밋 **0** (STOP ⑶ 미발동). master 선재 dirty 1행 = **흡수 0** (path-limited · file 단위 명시 pathspec · 디렉터리 pathspec 0 = D-4).

**게이트 종합 = G1~G10 전량 PASS (FAIL 0 · STOP 발동 0).**

---

## §3. commit 좌표

| repo | commit | file 집합 (D-6 대조) |
|---|---|---|
| claude-cli-master (변경) | `bfb8f9c` | 6/6 정확 일치 — `CLAUDE.md` · `.auto-memory/master-cycle-history-COLD.md` · `docs/rules/reporting.md` · `docs/rules/working-file-lifecycle.md` · `scripts/working-file-archiver.sh` · `scripts/com.coin.working-file-archiver.plist` |
| app-foundation | `b6f34eb` | 3/3 정확 일치 |
| gently-product-docs | `7d80476` | 3/3 정확 일치 |
| Selfward | `fe58e08` | 3/3 정확 일치 |
| claude-cli-master (audit) | 아래 §6 | `.auto-memory/propagation-status.md` + `propagation-reports/` + 본 REPORT |

**D-7 게이트** (= `cross-repo-parallel-exec-detail.md §2.1.6): 자식 3 모두 **commit 직전 `-uno` 재측정** 수행 — scope 3 file 외 tracked dirty **0/0/0** ⟹ 타 workstream live 신호 없음, commit 진행. Selfward untracked WIP 2(`.ai/_scratch/` · `supabase/_ops/mgmt-auth-anon-off.ts`) **무흡수** 실증.

**propagation 채널** (§9-2 답): **공식 채널** = `bash scripts/propagate.sh scripts/working-file-archiver.sh docs/rules/working-file-lifecycle.md docs/rules/reporting.md --targets FND,gently-product-docs,Selfward` → `ok=9 fail=0`. `scripts/` · `docs/rules/` 양 경로 모두 **사양상 처리 가능**했다 (= 명시 인자 경로는 `--all` 의 find 집합에 구속되지 않음 · `propagate.sh:334` `mkdir -p "$(dirname "$DST")"` 가 자식 신규 경로도 생성). **§5-⑵ 수동 복사 우회 = 미사용.**

---

## §4. 관측 항 (변경 아님)

### #6 — `run-master` 실체 = **paste §0 좌표가 layer 오류**
```
ls .claude/commands/  → cycle-report.md · review-task.md · uiux-refresh.md · verify-all.md  (4본)
                        → run-master 부재
ls -la .claude/skills/run-master/  → drwxr-xr-x  +  SKILL.md (1536B · Jul 29 15:28)
file .claude/skills/run-master     → directory
```
**판정**: `.claude/commands/run-master` 는 **애초에 없는 좌표**다 (cowork VM `ls` 무출력 = 자 밖이 아니라 **실제 부재**). 실체는 `.claude/skills/run-master/SKILL.md` — `propagate.sh:113` C16 가드가 `.claude/skills/run-*` 를 **자식 repo-local recipe**(master=run-master · FND=run-foundation · SW=run-Selfward)로 명시 제외하는, 설계상 의도된 물건이다. **「.md 부재」는 결함이 아니다** — skills 는 전부 디렉터리 형식(18/18)이고 본체 `SKILL.md` 는 실재한다. **조치 불요.**

### 부모 `archive/` 직속 census — paste 문면 「1」 vs 실측 불일치의 정체
```
직속 file 수 (mv 전) = 57 →  (mv 후) = 56  = INDEX.md 1 + working file 55
확장자                = 전량 .md
접두 분포             = cc-paste-* 43 · HANDOFF-* 3 · SELFWARD-* 5 · cowork-* 3 · RECOVERY-* 1
mtime 범위            = 2026-07-10 ~ 2026-08-01
★YYYY-MM/ 안 동명 중복 = 0  ⟹ 55 = 전량 유일본 (stray 사본 아님)
★INDEX.md 기록        = 표본 3 전부 row=0  ⟹ 미기록
```
**rule 원문 기준 판정**: `working-file-lifecycle.md §3` 이 규정한 구조는 `archive/INDEX.md` + `YYYY-MM/` 뿐이다 ⟹ 직속 file 중 **정합은 INDEX.md 1건뿐**, 나머지 **55건은 비정합**. 그리고 script `archive_one()` 은 항상 `$ARCHIVE_DIR/$MONTH_DIR/` 로만 mv 하므로 **daemon 이 만든 잔존이 아니다** — 55건은 **수동 이동 유래**(그래서 INDEX row 도 없다). paste 의 「#22 = 직속 1건」은 census 가 아니라 **지정 처리 1건**이었고, 실제 모집단은 55다.
**처방 = Coin 회수** (§4 「mass move 금지」 준수 — 본 cycle 이동 = #22 지정 1건 **단독**).

### launchd
```
launchctl list | grep working-file-archiver  →  -   0   com.coin.working-file-archiver
~/Library/LaunchAgents/com.coin.working-file-archiver.plist  (1201B · Jul 29 17:49)
diff(master 판, LaunchAgents 판)  →  본 cycle 편집 **전** = identical
```
= 등재·load 상태 · 마지막 종료코드 0 · 현재 미실행. **★본 cycle 의 plist 수정은 master repo 판에만 적용됐고 `~/Library/LaunchAgents/` 판은 구 문면 그대로다 ⟹ 재적재 전까지 미발효** (아래 §6 Coin 실기 1줄).

---

## §5. 회부 (본 cycle 미해소 · 처방 = Coin)

1. ★**부모 root `scripts/working-file-archiver.sh` = 본 cycle 이후 유일한 구 판**. 실측 = 편집 전 master 판과 **byte-identical**(`5ded4ab4…`)이었고, 전파 대상 3(FND/PDOCS/SW)만 갱신됐으므로 **지금은 부모 root 만 REPORT.md 를 인정하지 않는다**. 하필 조기-archive 수요가 가장 큰 곳(= 부모 root 는 cc-paste 가 실제로 쌓이는 자리 · 직속 55건)이다. 본 file 은 paste §2 의 부모 root 접촉 열거(⑹⑺)에 없어 **STOP ⑵(scope 밖 file) 준수로 무접촉**했다. 처방 = `cp claude-cli-master/scripts/working-file-archiver.sh scripts/` 1줄이면 끝나나 **지시 회수 후 집행**.
2. `docs/templates/release-checklist.template.md` 의 「14일」 1본. G1 자(= `docs/rules/`)의 **밖**이라 게이트에는 안 잡히고, 본 cycle scope(⑴ = `reporting.md` 단독) 밖이라 무접촉. 성격 판정(= archiver 일수 인용인지, 릴리즈 soak 기간처럼 무관한 14일인지)부터 필요.
3. ★**`review_says_pass()` 의 legacy 분기가 REPORT.md 에서는 실질적으로 느슨하다** — 본 cycle 이 넓힌 건 인정 file 집합 1개뿐이지만, 실측상 **REPORT.md 는 `## Verdict` 을 쓰는 판이 0/30**이라 REPORT.md 경로는 사실상 legacy 분기(`^##.*PASS`)로만 발화한다. 즉 `## 4. 보호 파일 sha 검증 (PASS)` 같은 **절 단위 PASS 표기**가 마감 신호로 읽힌다. 단 ⒜ 이 느슨함은 **기성 성질**이다(REVIEW.md 도 `### 1. Requirements Coverage — PASS` 로 매칭 · legacy 분기 매칭 4본 실측) ⒝ REPORT.md 는 관례상 **마감 시점 저작물**이라 오발동 창이 좁고 ⒞ `mv only` + INDEX 기록 + `restore.sh` 로 가역이다. 판정 = **STOP ⑷ 미발동**(요건을 넓힌 게 아니라 같은 요건을 file 1개에 더 적용) · 다만 판정 술어를 `## Verdict` 표준형으로 조이는 건 **별 cycle 감**.
4. R2 §7 「frontmatter task-ID 부재」 이중 불일치의 **나머지 반쪽** = 본 cycle 미해소 (paste §9-4 지시대로 **회부 유지**). 조기-archive 는 frontmatter 가 있어야 발화하는데 실제 cc-paste 다수가 frontmatter 없이 발행된다 — 본 cycle 은 「REVIEW.md 만 본다」쪽 반쪽만 고쳤다.
5. `verify-sync.sh` stale ref 6건(`protected-file-hashes.md` 5 + `propagation-status.md` 1) = pre-existing · 비차단.

---

## §6. 다음 단계 (Coin 실기)

```
launchctl unload ~/Library/LaunchAgents/com.coin.working-file-archiver.plist && \
cp ~/AndroidStudioProjects/claude-cli-master/scripts/com.coin.working-file-archiver.plist ~/Library/LaunchAgents/ && \
launchctl load ~/Library/LaunchAgents/com.coin.working-file-archiver.plist
```
= plist 수정(⑷ skip 가시화)은 **재적재 전 미발효**. `git push` = Coin 소관.

---

## §7. Negative Space (고려했으나 hot 제외)

동결 3 = 파일·커밋 0 · production 0 LOC · 보호 5 sha 무접촉(edit-set ∩ 보호 5 = ∅) · `--prune` 미사용 · `--all` 미사용(명시 file list) · plist 는 전파 대상 아님(자식 3 실측 부재 = 정상 · 머신 단위 launchd 설정) · 부모 root archive mass move 0(지정 1건 단독) · `docs/templates/` 무접촉 · `.claude/` 무접촉 · 부모 root `scripts/` 무접촉(§5-1 회부).
