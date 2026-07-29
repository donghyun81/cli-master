# MASTER-CLI-JUDGMENT-SHIFT-001 — REPORT

> **Mode**: M5 cli-infra-ops · **production/EF/DB/Money 0 LOC** · 보호 5 sha drift 0 · 동결 3(GB/GD/GT) 파일·커밋 0
> **본질**: Claude 5 세대 context engineering 반영 2차 — **구형 모델 전제 보호장치의 판단 위임 전환**.
> 근거 SoT = `GUIDE-CONTEXT-ENGINEERING-CLAUDE5-AUDIT-20260729.md` §3.3(hook 판정 표) + §5(적용 제외 경계) · Coin 본심 07-29 확정 ①②
> **cowork contract** = `cc-paste-MASTER-CLI-JUDGMENT-SHIFT-001.md`

---

## §0. 진입 재측정 (전량 정확 일치 · STOP#4 미발동)

| repo | 기대(12) | 실측(12) | dirty 기대 | dirty 실측 |
|---|---|---|---|---|
| claude-cli-master | `d04858b7715b` | `d04858b7715b` ✓ | 0 | 0 ✓ |
| app-foundation | `456a188750ae` | `456a188750ae` ✓ | 0 | 0 ✓ |
| gently-product-docs | `01c34834f6e6` | `01c34834f6e6` ✓ | 0 | 0 ✓ |
| Selfward | `94e8ccd34d4d` | `94e8ccd34d4d` ✓ | 32 (untracked) | 32 (전량 untracked) ✓ |

- 보호 5 git-sha1(12) 실측 = `8b46bb4952be`·`68c6c213b18e`·`ce9c0d3e5453`·`7e70e365bb30`·`0d265e0bbc6f` — **§0 기대 전량 일치**
- settings.json hook 등록 실측 = **17** · 본 cycle 대상 5종(check-abbreviation / post-edit-degeneration-check / stop-reflect / libs-versions-cross-verify / post-tool-use-trace) 등록 실존 확인 ✓
- **A1 forward-progress 0** (= 동시 세션 개입 없음 · 4/4 정확 일치)

---

## §1. 제거 3 (rule 원문 verbatim 보존 · 정보 소실 0)

| 제거 대상 | 대체 (판단 위임) | 원문 보존처 |
|---|---|---|
| `check-abbreviation.sh` + `docs/rules/abbreviation-policy.md` | `code-style-guide.md` §C 가이드라인 「명명·관용」 = *주변 코드처럼 읽히는 코드를 쓴다: 주석 밀도·명명·관용을 맞춘다* | `.auto-memory/abbreviation-policy-COLD.md` (R094 rename · 금지 seed + 허용 약어 전량) |
| `post-edit-degeneration-check.sh` + `docs/rules/text-degeneration-prevention.md` | 모델 판단 (n-gram 반복 퇴행 = 구세대 증상) | `.auto-memory/text-degeneration-prevention-COLD.md` (R090 rename · 3 metric + 임계 + paraphrase 의무) |
| `stop-reflect.sh` | `cycle-discipline.md` §19 「반복 패턴 자기관측 loop」 (임계 3 · 비차단 · 사용자 confirm = 불변) | git 이력 (rule 없음) |

**위임 1줄 문면 모델** (§3-2 아티클 N1 정합): 구형 *"default to writing no comments"* → 신형 *"Write code that reads like the surrounding code: match its comment density, naming, and idiom"*.
**금지어 list 폐기 근거 (실증)**: list 는 수동 유지 대상이라 프레임워크 API 명을 false positive 로 Edit 차단했다 (선례 = Play Billing `BillingFlowParams` 계열 · `MASTER-PRELAUNCH3-SMALLFIX-001` 이 whitelist 로 임시 봉합한 그 사고).

## §2. 축소 2 (§5 §FREEDOM 판단 + 근거)

### 2.1 `libs-versions-cross-verify.sh` — `.kt` 발동 폐지 → toml 접촉 시 한정

구 판은 `*/src/*` 아래 `.kt` 편집마다 발동해 **repo 전체 `.kt` glob 6 패턴 recursive** 를 돌렸다. 이 검사가 잡는 오류(artifact 명 ↔ import convention 불일치)는 **Gradle 빌드가 결정적으로 잡는다** — 매 Kotlin 편집마다 선행 재확인할 근거가 없다. 선언 SoT(toml)가 바뀌는 순간만 3-source 매트릭스를 검증한다.

`bash -x` 분기 실측: `.kt` → `case` 직후 **`exit 0`** (glob 미도달) · `toml` → `:` 통과(= 검사 진입). **R1a/R1b/R1c 규칙 본문 무변경.**

### 2.2 `post-tool-use-trace.sh` — matcher 6종 → **`Bash` 한정** (전면 제거 X)

**소비처 실측** (paste §5 요구):

| 소비처 | 실측 |
|---|---|
| 자동화(nightly · gsm · script) | **0 건** (repo 전수 grep — hook 자신 + gitignore 패턴 외 참조 없음) |
| 문서 | 2 건 — `reporting.md` §9.2 *"Trace Pointer (**선택**)"* + `cross-repo-orchestrator.md:121` |
| 실 산출물 | **`_unknown.jsonl` 단일 파일** (188KB · 1714 entry) |

**핵심 발견**: `reporting.md §9.2` 가 약속한 per-task 파일 `.ai/traces/<taskId>.jsonl` 은 **한 번도 생성된 적이 없다** — `CLAUDE_TASK_ID` 미export + `.ai/tasks/INDEX.md` 활성 행 부재 → 누적 1714 entry **전량**이 `_unknown` 으로 낙착. 즉 선언된 소비 계약이 구조적으로 미충족.

**그럼에도 전면 제거를 택하지 않은 이유**: 제거하면 `reporting.md §9.2` + `cross-repo-orchestrator.md` **동반 정정이 필수**인데, 그 2 file 은 paste §2 정합 목록 밖 = **STOP#2 scope expansion**. 살아있는 문서가 없는 기능을 가리키게 두는 것(= 이 repo 가 반복해 고쳐 온 stale pointer class)도, scope 를 임의 확장하는 것도 옳지 않다 → **이번엔 축소까지 · 전면 제거 = 후속 후보**(§7).

tool 분포 실측: Bash **56.8%** / Edit 23.0% / Read 16.0% / Write 4.1% / **Glob·Grep 0**. Read/Edit/Write 는 CC transcript 가 경로까지 보존 = 중복 · Bash = 명령 문자열이 transcript 밖에서 재구성 가치가 가장 큰 클래스.

## §3. stdout 다이어트 2 (부수 동작 전량 유지)

| hook | 전 (실측) | 후 (실측) |
|---|---|---|
| `session-start.sh` | **7 줄** — branch / open_tasks / last_review / protected_baseline_count / cc_version / arguments_purged / daemon | **1 줄** — `[session] branch=main · open_tasks=0 · last_review=… PASS` |
| `instructions-loaded-baseline-verify.sh` | **4 줄** (header + 4-active HEAD + 보호5 sha 5값 + drift) | **1 줄 · 135 char** — `[baseline] live: HEAD … | 보호5 drift=0` |

- **텔레메트리 = 삭제 X · 이동**: `protected_baseline_count` · `cc_version` · `arguments_purged` · `daemon` · `promptfit_avg5` → `.ai/hooks/session-telemetry.log` (gitignore `.ai/hooks/*.log`). 실측 append 확인 ✓
- **부수 동작 전량 보존**: git lock 광역 PID 정리 · `unset ARGUMENTS` · daemon 검증(WARN = 종전대로 stderr) · working-file-archiver sweep
- **4-active HEAD 는 유지 판단**: anchor **A1** 의 GSM-S 가 *"이후 cycle = SessionStart hook 주입값 인용 갈음"* 으로 이 값에 의존 — 빼면 매 cycle 재측정 = **순손실**. 반면 보호 5 의 sha 12-hex **원값**은 정상 시 인용되지 않고 판단에 쓰이는 건 drift 수치뿐 → 원값은 **drift ≠ 0 일 때만 전개**(A2 STOP#5 로직·enforce mode 무변).
- 추정 절감 ≈ **250–350 tok/세션 → ~40 tok** (§3-3 기준 대비).

## §4. stop-gate 범위 한정 + 주석↔exit 정합 (게이트 골격 무접촉)

1. **범위**: `.ai/reports/` **전수 순회** → SessionStart 가 남기는 `.ai/hooks/.session-marker` **이후 변경된 task 만**. marker 부재 시 = **구 전수 순회로 fallback** (게이트가 조용히 사라지지 않게).
2. **주석↔exit 정합**: Cleanup 분기는 주석이 *"exit 2 (완료 차단)"* 라 선언하면서 실제로는 `exit 1` 을 반환했다. **같은 파일이 `exit 1` 을 "internal error" 로 정의**하므로 정책 위반을 내부 오류로 신고한 셈이고 **차단도 되지 않았다** (= 선언된 게이트가 실재하지 않음) → **`exit 2` 로 정합**.

**술어 양방향 실측** (fixture 생성 0 — `rm` deny 로 정리 불가라 live 트리 marker mtime 조작으로 대체):

| marker | 선택된 task dir | gate exit |
|---|---|---|
| now | **0 / 91** | 0 (조기 exit) |
| 2020-01-01 (= 구 전수 등가) | **91 / 91** (술어가 실제 선택 = 공집합 아님 확증) | 0 |

**paste §3-4 전제 자진 정정**: *"과거 미완 task 1건이 전 세션 Stop 영구 차단"* = **구조적으로 참 · 현재 실발화 0건**. 실측 = PLAN+EVIDENCE 보유 task **91 건 전량이 VERIFY+REVIEW 완비** → 구 판도 현재는 차단 0. 따라서 exit 2 강화는 현 시점 위험 증가 없음(범위가 현 세션으로 좁혀져 **고칠 수 있는 사람 앞에서만** 발화).

## §5. 정합 (dangling reference 일소)

제거 5 file 의 **live 참조 전수 grep** 후, ⑴ 404 링크 ⑵ 존재하지 않는 기전을 현재형으로 주장하는 문면 을 정정. **순수 이력 line 은 verbatim 무접촉** (= 이력 삭제 0 doctrine).

| file | 정정 |
|---|---|
| `.claude/rules/rule-routing-table.md` | mode 5·6 의무 로드에서 `text-degeneration-prevention` 제거 + T4 abbreviation 각주 재작성 |
| `docs/rules/code-style-guide.md` | §C 「명명·관용」 **신설(위임 1줄)** + 연관 파일/§B 표/§C 후퇴 pointer 3곳 재지정 + §A enforcement 근거 hook 2종 supersede |
| `docs/rules/rule-routing-index.md` | §A 등록 2행 → 등록 해제 + COLD 링크 · enforce 표 · amend loop 2곳 |
| `docs/rules/cycle-discipline.md` | §19 제목·본문 재작성(hook → 자기관측) + supersede 근거 |
| `docs/rules/gsm-measurement.md` | 임계 N=3 근거 2종 supersede(값 3 계승) + 승격 경로 |
| `docs/rules/{libs-versions-cross-verify,automation-policy,terminology}.md` | 연관/근거 pointer 재지정 |
| `.claude/hooks/{stop-housekeeping,measure-gsm-cycle}.sh` | 주석 내 `stop-reflect.sh` 참조 |
| `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` | CLI-workflow rule 인벤토리 **18 → 16** (master-only) |
| `.gitignore` + `scripts/ensure-child-gitignore-patches.sh` | `.ai/hooks/.session-marker` (세션 로컬 산출물 · 커밋 차단) |

**무접촉 (의도적)**: `architecture-foundation-link-policy.md:128` · `scripts/test-protected-file-hooks.sh:17` · `rule-routing-index.md` §F 이력 = **순수 이력** → verbatim 보존.

## §6. 검증

- **보호 5 sha-256 drift 0** — 전후 `8502c014`·`202d3f4f`·`2bfc81c5`·`31c0da56`·`92a5e998` 불변 (edit-set ∩ 보호 5 = **∅**). manifest **직접 grep 실측 선행** 후 advisory tier 2건만 resync(`check-abbreviation.sh` 소멸 기록 · `settings.json` `313fec8d…`→`db398707…`).
- `bash -n` **7/7 OK** · `settings.json` JSON parse OK · hook 등록 **17 → 14** · hook 파일 **17 → 14**
- **propagate ok=48 fail=0** (16 file × 3 자식 · **명시 file list · `--prune` 미사용** = run-* recipe 보존)
- **verify-sync**: files 166→**161** · PASS 163→**158** (= −5 = 제거 5 file 산술 정확) · **DRIFT 2 / MISS 6 = 직전 cycle 과 동일 = 신규 drift 0**
  - DRIFT 2 = `release-checklist.template.md` FND/PDOCS (P4-lazy · Selfward ✓) · MISS 6 = CHARTER + `production-cli-access-tokens` master-only × 3 = **전량 pre-existing**
- **D-6 커밋 집합 대조 3/3 exact** — 각 자식 `files=22` (= 전파 16 + 삭제 5 + `.gitignore` 1) · scope 밖 **0**
- **STOP#6-C**: SW dirty 32 ∩ 변경 대상 = **∅** 실측 → 전파 진행 · 커밋 후 SW untracked **32 엔트리 불변**(= WIP 무흡수 · `ls-files` 65 vs `status` 32 차이 = 디렉터리 접힘일 뿐)
- **동결 3(GB/GD/GT) 파일·커밋 0** · production 확장자 변경 **0 건** (4-repo)
- **STOP#6-B 준수**: 본 cycle 검증 harness 는 secret env 를 읽거나 출력하지 않는다 (Keychain·PAT 미접촉).

## §7. 사고 / 후속

**commit 연쇄 (4 master + 2 자식 ×3)**

| # | master | 내용 | 자식 3 |
|---|---|---|---|
| 1 | `15b1ba1` | content (제거 3 · 축소 2 · 다이어트 2 · stop-gate · 정합) | FND `986a25b` / PDOCS `33c4d93` / SW `86b2e8f` (각 22 file) |
| 2 | `cbbf179` | audit (§15 + REPORT + manifest resync) | — (master-only) |
| 3 | `d295f82` | **잔여 참조 1건 정정** (아래) | FND `c2626e0` / PDOCS `442a9b8` / SW `63d70d5` (각 1 file) |
| 4 | `5099a60` | propagation-status 재생성 | — (master-only) |

**최종 dangling sweep = 5/5 ∅** (live 표면 `check-abbreviation` · `post-edit-degeneration` · `stop-reflect` · `abbreviation-policy.md` · `text-degeneration-prevention` 참조 0 · 이력 line 2건은 의도적 보존). `docs/rules` 44→**42 file · aggregate `91cc8c367ed418e8` 4-repo 동일** (산식 `cat docs/rules/*.md | shasum -a 256` · 환경 bash 3.2.57 · LC_COLLATE unset(C) · shasum 6.02).

**사고**: 없음. **자기검출 1** — 마감 전수 sweep 에서 `code-style-guide.md:89` §amend 의 `stop-reflect self-improving loop` 문면 1건 누락 발견(1차 grep 이 §19 정정 대상 file 들만 훑고 code-style-guide 재확인을 빠뜨림) → `d295f82` 로 정정 + 자식 3 재전파 + 4-repo 재일치(`6975c5525f516b80`) 확인. `--amend` 미사용(= Coin 소관 · git v3) → 별 commit 분리. (자식 commit pathspec 사고 = 재발 0 — 변수 미사용 literal heredoc. 진행 중 `libs-versions` self-test 1회가 stdin 대기로 timeout 됐으나 이는 **비-tty + 미존재 경로** 조합에서 발동하는 **기존 입력 해결 분기**의 성질이고 본 cycle 변경분 아님 · 실 PostToolUse stdin 경로로 재측정하여 해소 · 파일 변경 0.)

**후속 (scope 외 · 자율 진입 금지)**
1. **trace 전면 제거** — `reporting.md §9.2` + `cross-repo-orchestrator.md:121` 동반 정정 필요(§2.2). 겸하여 `_unknown` 낙착(taskId 미해결) 자체 처분.
2. **stale-ref 5 → 6** — `protected-file-hashes.md:87` 의 **과거 sha record 행**이 이제 부재 파일을 가리킨다(이력이라 verbatim 보존 = 삭제 X). DIET-2-003 잔여 5건과 **동일 class** → 같은 후속 묶음.
3. **`ensure-child-gitignore-patches.sh` = marker-only idempotent** — auto-managed block **본문이 바뀌어도 재patch 안 함**(본 cycle 실측: "이미 patch 박혀 있음" 3/3 skip → 1줄 수동 동기). 내용 대조 재patch = 별 cycle.
4. rules 층 topology 어휘 sweep (T7 회부분) · DIET-3 (동일 파일 접촉 → **본 cycle 착지 후 순차** · paste §11).
5. **§15 hot entry > 10** = `S15-HOT-DEMOTE-006` advisory (`measure-gsm-cycle.sh` Stop hook 자동 surface · 판정·이전 = 수동).
6. push = Coin.

**Negative Space (고려했으나 hot 제외)**: 결정적 집행층 전량 무접촉(보호5 sha hook · pre-commit-stage-check · pre-tool-use lock 정리 · pencil-auto-save · stop-housekeeping · post-policy-watch · deny 19 · **stop-gate 게이트 골격**) · settings.json permissions 절(= DIET-3 소관) 0 · 그 외 hook 무접촉 · 보호 5 sha 0 · 이력 line 삭제 0 · 동결 3 = 0 · `--prune` 0 · production/EF/DB/Money 0 · `.claude/rules/` 신설 0.
