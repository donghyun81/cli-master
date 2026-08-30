# Protected File Hashes — claude-cli-master baseline

> master 가 4 보호 파일 + 신규 도구 무관 1 보호 파일 + cli infra 의 SoT.
> 자식 repo (GB/GD/GT) 의 모든 sha 는 본 master sha 와 byte-identical 강제.
> drift 감지 = `verify-sync.sh` 가 자동 발화 + propagation cycle trigger.
>
> ★**stale ref 3 병기 정정** (= 2026-08-30 `MASTER-PROPAGATE-DRIFT17-001` T3 · **구 문면 삭제 0**): `verify-sync.sh:310-326` 의 「상태문서 부재 참조」 WARN 이 본 manifest 에서 **백틱 인용 경로 3 종**(출현 4)을 문다 — 전부 **디스크 부재 실측**(2026-08-30):
>
> | 백틱 인용 (본문 잔존) | 실제 처분 | 처분 cycle | 후속 좌표 |
> |---|---|---|---|
> | `.claude/hooks/check-abbreviation.sh` (`:87`) | **소멸** (hook 등록 해제 + file 제거) | `MASTER-CLI-JUDGMENT-SHIFT-001` (2026-07-29) | 명명 SoT = `docs/rules/code-style-guide.md` §C |
> | `.claude/rules/abbreviation-policy.md` (`:76` · `:88`) | **소멸** (rule 자체 폐지 · 판단 위임) | 〃 | 원문 verbatim = `.auto-memory/abbreviation-policy-COLD.md` (**실재**) |
> | `.claude/rules/workflow-core.md` (`:100`) | ★**이동** (소멸 아님) | `MASTER-CLI-CONTEXT-DIET-2-003` | 현 경로 = `docs/rules/workflow-core.md` (**실재**) · 자동 주입층 6 만 `.claude/rules/` 잔존 |
>
> ★**셋을 한 묶음으로 읽으면 틀린다** — 앞 둘은 **소멸**(그 규약이 폐지됐다)이고 셋째는 **이동**(규약은 살아 있고 경로만 갈렸다)이다. WARN 은 「부재」 하나로만 보고하므로 **자가 그 차이를 못 낸다**. 그 구별이 sha record 폐기 사유의 본체다.
> ★**본 정정 후에도 WARN 은 계속 뜬다** — 끄려면 백틱 인용 자체를 지워야 하고 그것이 곧 구 문면 삭제(= 본 판 S5)다. **WARN 은 결함이 아니라 이력의 그림자**이고, 본 표가 그 그림자의 정체다. 실제 소멸/이동 여부는 위 「실재」 표기로 판정하라.
>
> **추적 항목 본질** (= Phase C 정정 · MASTER-CLI-POSTCYCLE-AUTOMATION-001 · 2026-06-01): 본 manifest 추적 = (a) **강제 byte-identical 보호 5종** (= 아래 "## 보호 파일 5 종" sha-256 baseline · master ↔ 자식 byte-identical 의무) + (b) cli infra **advisory** sha 기록 (= GLOBAL-NO-ABBREV cli infra 신설 영역 · 보호 5종 외 · 권장 byte-identical). "5종" = (a) 강제 영역 한정 표기. 직전 GLOBAL-NO-ABBREV 영역 안 no-abbreviation-policy.md / allowed-acronyms.md / forbidden-abbreviations.md 3 file = MASTER-CLI-CLEANUP-7CYCLE-001 (2026-05-21) 에서 abbreviation-policy.md 단일 통합 + 삭제 (= 현재 부재 · 아래 GLOBAL-NO-ABBREV 표 정정 정합).

## 보호 파일 5 종 (강제 byte-identical · master HEAD baseline · C2.5 갱신)

| 파일 | 분류 | sha-256 | 변동 |
|---|---|---|---|
| `docs/schemas/ui-spec.schema.json` | 도구 무관 (v0.3 generic 화) | `8502c01428fbc16fdcec55721951d6945d1e52e20fa10ceb13c230e37ea14eb0` | **MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 갱신** (2026-06-10 · `lastSyncedPencilStateHash` description 측 drift 감지 기준 1곳 compound-lint→drift warn 라벨 정정 · JSON 구조 무결 parse PASS · 이전 `f1edd39739d4…`) · 직전 MASTER-DOC-CITATION-FIX-001 (2026-05-04 · description 도구 generic 어휘 3곳 정정 · 필드명 alias 보존) |
| `docs/rules/uiux-sot-refresh.md` | 도구 무관 (95% generic) | `31c0da56aeecb914b7e4adf4cadcf58f89303d3ade4b5192e59ea76308ead457` | **MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001 갱신** (2026-06-18 · "Refresh Trigger Classification" 직후 "즉시 의무 vs Deferred (design-debt) 분기" subsection 신설(신규성×출시 4-row 표) + 게이트 line 재배선(REVIEW §1 FAIL → [Design SoT Sync] WARN + DESIGN-DEBT 등재 의무 + 출시 backstop) · 이전 `e3b9891d4be5…`) · 직전 MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 (2026-06-10 · :22 lineage Package Boundary 서술 폐기 = :27 폐기의 연장 · 이전 `75c0c47ee299…`) · 직전 MASTER-CLI-PROTECTED-STALE-PATH-FIX-001 (2026-06-10 · :27 lineage 계약 조항 폐기 + :61 repo-config 경로 `scripts/agent/`→`scripts/` 정정 · 이전 `ee377dc2ac32…`) · 직전 MASTER-PROTECTED-BASELINE-RESYNC-001 (2026-05-03 · baseline 정합) |
| `docs/design/design-sot-policy.md` | 도구 무관 (75% 공통 추출) | `92a5e99804ff712fde1c74edbeec984e631a857c81b40ff45117020e1edc490e` | **MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001 갱신** (2026-06-18 · §3 "원칙" code-first 역방향 항 → Deferred (design-debt) lane 등재 시 한정 허용 3-bullet 재배선(미등재=WARN / 출시 후 net-new=release FAIL / 등재+출시 전 해소) · Phase R 예외 무접촉 · 이전 `4c5666152f09…`) · 직전 MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 (2026-06-10 · §1.1 drift 기계 감지 2줄 + §6 drift 표 1줄 = 검증 수단 compound-lint→실존 수단(drift warn 수동 sha 대조 / REVIEW FAIL P9) 재배선 · 이전 `e5e3fe165ec3…`) · 직전 MASTER-PROTECTED-BASELINE-RESYNC-001 (2026-05-03 · 후속 cycle 으로 baseline 정합) |
| `docs/rules/pencil-uiux-workflow.md` | Pencil 도구 바인딩 (30% 잔존) | `202d3f4f29c0668eb5f1a33b6d40d5153888cf1f1e55da9958f9ab605c68f40a` | **MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001 갱신** (2026-06-10 · Pencil v1.1.62 제거 4종 stale sweep Phase B = :20 도구수 12+1→9 · :22 추가 5종 lineage 현존 2/제거 3 · :45/:56/:68 open_document step→현 메커니즘(`open -a Pencil` / `pencil interactive -o`) · :93 STOP moot 항→부활 검출 STOP · :11 pencil-sot-binding 죽은 명칭→실 file 병기 · §2.5 headless-primary 무접촉 · 이전 `2ec100bfc601…`) · 직전 MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 (2026-06-10 · :9 연관 파일 명칭 오기 정정 design-sot-refresh.md→실 file uiux-sot-refresh.md = F4 동족 · 이전 `52c075767388…`) · 직전 MASTER-CLI-PROTECTED-STALE-PATH-FIX-001 (2026-06-10 · :12 `save-as-result-check.sh` 경로 `.claude/hooks/`→`scripts/` stale 정정 · 이전 `e6a4a2a1457b…`) · 직전 MASTER-CLI-PENCIL-UIUX-HEADLESS-RESTRUCTURE-001 (2026-05-31 · headless 평문-JSON = .pen 변형 기본 경로 위계 §2.5 신설 + §9 승격 + stale 2.1.114 pin 2 줄 정정 · 본문 sha 변동 origin · 이전 `d64481370d...`) · 직전 MASTER-CLI-PENCIL-RECOLOR-GENERATOR-001 (2026-05-31 · §9.4 Recolor sub-flow 신설) · MASTER-CLI-PENCIL-OPTIMIZATION-001 (2026-05-19 · §1 도구 정정 + §9 Pencil CLI binding 신설) |
| `docs/design/pencil-sot-policy.md` | Pencil 도구 바인딩 (의미 = pencil-sot-binding) | `2bfc81c538b220669e123f520a02238933ddfe0a7ccc0987223ae16d88e8e85f` | **MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001 갱신** (2026-06-10 · Pencil v1.1.62 제거 4종 stale sweep Phase B = :40 §2 표 캔버스 열기 행 open_document→headless PRIMARY + 시각 `open -a Pencil` + 신규 `pencil interactive -o` · :77 §4 STOP moot 항→제거 도구 호출 시도 STOP · 이전 `ae20a79c42dc…`) · 직전 MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 (2026-06-10 · Path B fallback step 4 재검증 수단 = P1~P3 dual-layer sha 대조 재배선 · 이전 `96de2f5d10a7…`) · 직전 MASTER-PROTECTED-BASELINE-RESYNC-001 (2026-05-03 · MATCH 재확인) |

> **참고**: `design-sot-policy.md` 신설 sha = `e5e3fe165ec3...` (C2.5 마감 박음).

## CONVENTION — hash algorithm 분기 + resync trigger (MASTER-CLI-PROTECTED-FILE-HASH-CONVENTION-001 · 2026-05-30)

> 본 manifest = 보호 파일 sha 의 master-only authoritative SoT. 자식 (GB/GD/GT) 측 copy 는 byte-identical propagate 대상 X (= `propagate.sh` 측 별도 propagate X · 각 repo git-tracked manifest · 별 follow-up 정합).

### algorithm 분기 (= 3 layer 측 hash algorithm 상이 · 혼동 주의)

| layer | file | algorithm | 본 manifest 값 형식 |
|---|---|---|---|
| record manifest | `.auto-memory/protected-file-hashes.md` (본 file) | **sha-256** (`shasum -a 256`) | 64 char hex |
| runtime enforce | `.ai/baseline-snapshot/latest.json` | **sha-256** (`shasum -a 256`) | 64 char hex (= 본 manifest 와 동일 algorithm · 양 sha-256 정합 의무) |
| cycle baseline | `CLAUDE.md` §14a (보호 파일 sha baseline 표) | **git-sha1** (`git hash-object`) | 40 char hex |

⚠ 본 manifest 측 값 = **sha-256** default. `CLAUDE.md` §14a 측 git-sha1 (40 char) 과 직접 비교 금지 (= 다른 algorithm · 동일 file 측 두 값 모두 정답 · 형식만 상이). 동일 file 측 sha-256 == `baseline-snapshot/latest.json` 측 sha-256 정합 의무.

### resync trigger (= staleness 재발 방지)

보호 파일 본문 변경 + propagate cycle 진입 시점:
1. `propagate.sh` 측 보호 파일 baseline 변경 감지 WARN ("보호 파일 baseline 변경 감지 · `.auto-memory/protected-file-hashes.md` 갱신 의무") 발화 default.
2. 본 WARN 발화 시 = 본 manifest 측 해당 row sha-256 **수동 resync 의무** default (= 변동 attribution cycle ID 명시) + `CLAUDE.md` §14a git-sha1 row + §15 entry 정합 default.
3. WARN 미이행 = staleness 근본 원인 default (= 본 cycle 측 pencil row `7621013e...` → `f1825013...` resync = PENCIL-OPTIMIZATION-001 (2026-05-19) 측 WARN 미이행 누적 mitigation).

## 신설 cli infra (C2.5)

- `docs/rules/code-principles.md` (250 줄) — Q1 답: SOLID 5 + DRY/KISS/YAGNI + 코드 리뷰 체크리스트 + reviewer 자동 참조 · **MASTER-ENGINEERING-BASELINE-002 정정** (2026-08-29 · 구 표기 = `.claude/rules/` · 151 줄 · 실물 = `.claude/rules/` 잔존 6 file 에 부재 + `docs/rules/` 실재 · 행수 = 집행 시점 `wc -l` 실측 · 정정 방식 = 아래 `:126` 「구 경로 병기」 선례 동형)
- `docs/rules/design-to-code-sync.md` (261 줄) — Q2 답: pencil-uiux-workflow.md 의 70% 공통 추출 (도구 무관) · **MASTER-DOC-MANIFEST-SWEEP-001 정정** (2026-08-29 · 구 표기 = `.claude/rules/` · 103 줄 · 실물 = `.claude/rules/` 잔존 6 file 에 부재 + `docs/rules/` 실재 · 행수 = 집행 시점 `wc -l` 실측 · 정정 방식 = 위 `:44` 동형)
- `docs/design/design-sot-policy.md` (156 줄) — Q2 답: pencil-sot-policy.md 의 75% 공통 추출 (보호 신설) · **MASTER-DOC-MANIFEST-SWEEP-001 정정** (2026-08-29 · 구 표기 = 153 줄 · 경로 무변 · 행수 = 집행 시점 `wc -l` 실측 · ★본 행은 그 보호 file 을 **가리키는 행**이며 본문 무접촉)

## C2.5 분리 결과 — 도구 무관 vs Pencil 전용 매트릭스

| 영역 | 도구 무관 (공통) | Pencil 전용 (도구 바인딩) |
|---|---|---|
| Design SoT 정책 | `design-sot-policy.md` (보호 · §1~§8) | `pencil-sot-policy.md` (보호 · 의미 = `pencil-sot-binding.md`) — Pencil MCP tools / Path B fallback / 도구 한정 STOP |
| Design → Code sync | `design-to-code-sync.md` — 5-type IMPL / Output Checklist P1-P9 / STOP | `pencil-uiux-workflow.md` (보호) — Pencil 도구 호출 patterns / macOS 자동화 / Cmd+S / Save As 모달 |
| SoT refresh | `uiux-sot-refresh.md` (보호 · 95% generic) | (도구별 trigger 키워드는 본 파일 안 generic placeholder) |
| 자동화 hook | (도구 무관 hook 없음) | `pencil-auto-save.sh` (v2) + `save-as-result-check.sh` (Pencil 의존) |
| 자동화 rule | (도구 무관 rule 없음) | `pencil-automation.md` (Pencil .pen 자동화) |
| schema | `ui-spec.schema.json` (보호 v0.3 · designTool enum + 도구 무관 필드명) | (구 Pencil 명명 필드는 v0.3 alias 로 유지 + deprecated 예고) |

## verification

```bash
# master baseline 일관성 검증 (run from claude-cli-master/)
for f in docs/schemas/ui-spec.schema.json docs/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md docs/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md; do
  shasum -a 256 "$f" | awk '{print $1}'
done
# 위 5 sha 가 본 표와 일치 = master baseline PASS

# 3-repo 동기 검증
bash scripts/verify-sync.sh
```

## GLOBAL-NO-ABBREV-POLICY-001 신설 cli infra (2026-05-10)

| 파일 | sha-256 (full) | 비고 |
|---|---|---|
| ~~no-abbreviation-policy.md + allowed-acronyms.md + forbidden-abbreviations.md~~ (소멸) | — (sha record 폐기) | **MASTER-CLI-CLEANUP-7CYCLE-001 (2026-05-21) 통합 삭제**: 직전 3 file → `.claude/rules/abbreviation-policy.md` 단일 SoT 흡수 (§1 정책 + §2 금지 seed + §3 허용 약어) + 3 file 삭제. 현재 부재 · 본 manifest sha record 추적 X (= 보호 5종 외 cli infra advisory) · ★**흡수처도 이후 소멸** (2026-08-30 병기 · T3): 위 흡수 destination 인 `abbreviation-policy.md` **자신이** 2026-07-29 `MASTER-CLI-JUDGMENT-SHIFT-001` 에서 폐지됐다 ⟹ 본 행은 **「소멸한 3 file 이 소멸한 1 file 로 흡수됐다」**를 가리킨다. 원문 verbatim = `.auto-memory/abbreviation-policy-COLD.md` (실재) |
| ~~check-abbreviation.sh~~ (소멸 · 구 위치 = hooks 디렉터리) | — (sha record 폐기 · 최종 live `679e4cf10a3e…`) | **MASTER-CLI-JUDGMENT-SHIFT-001 (2026-07-29) 제거**: 명명 판정을 금지어 list 대조 → 주변 코드 관용 준수로 위임 (Coin 본심 ①). rule 원문 = `.auto-memory/abbreviation-policy-COLD.md` verbatim · 명명 SoT = `docs/rules/code-style-guide.md` §C 「명명·관용」. 현재 부재 · 본 manifest sha record 추적 X (= 보호 5종 외 cli infra advisory) |
| `.claude/settings.json` | `db3987072d4b811bc6f7b24c316fc5d12aefe359867c7d8688b687cfe2bb3ed7` | settings · **MASTER-CLI-JUDGMENT-SHIFT-001 resync** (2026-07-29 · hook 등록 17→14 = `check-abbreviation` + `post-edit-degeneration-check` + `stop-reflect` 등록 해제 + PostToolUse trace matcher `Bash\|Read\|Edit\|Write\|Glob\|Grep`→`Bash` 축소 · permissions 절 무접촉 · 4-repo byte-identical propagate · `baseline-snapshot/latest.json settingsSha` = 다음 SessionStart 시 runtime 재생성 self-heal · 이전 `313fec8d…`) · 직전 **MASTER-GIT-ROLE-COMMIT-V3-001 resync** (2026-07-15 · deny 배열에 `Bash(git rebase:*)` + `Bash(git filter-branch:*)` 2 추가 = **본문 변경** · 6-repo byte-identical propagate · `baseline-snapshot/latest.json settingsSha` = 다음 SessionStart 시 runtime 재생성 self-heal · 이전 `9696afb3…` = MASTER-CLI-GSM-MEASUREMENT-LAYER-001 (Stop 배열 measure-gsm 추가) · 직전 `d22047d8…` · `549b142d…` = MASTER-CLI-POSTCYCLE-AUTOMATION-001 Phase D) |

4-repo byte-identical: master 77ca613 · GB 628245f · GD 3a5b4ca · GT f4501d5
보호 파일 5종 sha 변동: 0 (cli infra 권장 파일 5종만 신설)

## GLOBAL-NO-ABBREV-POLICY-002 갱신 cli infra (2026-05-10)

| 파일 | sha-256 (full) | 변경 내용 |
|---|---|---|
| `.claude/hooks/check-abbreviation.sh` | `c232e2c7961bd9eeb1f5756337184e61c8a5469d29db872eaa84296f8d20c9ab` | Sub B: import line skip + generated path skip / Sub C: NO_ABBREV_ENFORCE default warn→enforce · ★**경로 부재** (2026-08-30 실측 · `MASTER-PROPAGATE-DRIFT17-001` T3 병기): 본 행은 **live sha record 형태로 남아 있으나 file 은 2026-07-29 `MASTER-CLI-JUDGMENT-SHIFT-001` 에서 제거**됐다 (= 금지어 list 대조 → 주변 코드 관용 준수 위임 · Coin 본심 ①). 위 `:77` 행이 같은 file 의 소멸을 이미 적고 있어 **한 file 이 「소멸 행」과 「live sha 행」으로 동시에 실재**한다 — 그 둘이 갈린 것이 이 WARN 의 원인이다. sha `c232e2c7…` = **2026-05-10 시점 박제**이지 현행 아님 (최종 live = `679e4cf1…` · `:98`) |
| ~~no-abbreviation-policy.md~~ (소멸) | — (sha record 폐기) | §3 hook 제외 대상 표 / §5.1 mode default enforce / §5.2 self-test 7 fixtures → 본문 `.claude/rules/abbreviation-policy.md` 흡수 (MASTER-CLI-CLEANUP-7CYCLE-001 · 위 GLOBAL-NO-ABBREV-001 통합 note 정합) · ★**흡수처도 이후 소멸** (2026-08-30 병기 · T3 · 위 `:76` 동형): `abbreviation-policy.md` = 2026-07-29 `MASTER-CLI-JUDGMENT-SHIFT-001` 폐지 · 원문 = `.auto-memory/abbreviation-policy-COLD.md` (실재) |

4-repo byte-identical: master 7a25854 · GB 2c83a4e · GD 8ad3e7d · GT 8647a4d
보호 파일 5종 sha 변동: 0 (cli infra 권장 파일만 갱신)

## Recent updates

- 2026-06-18 · MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001 · design SoT (`.pen`/`.ui-spec`) "즉시 갱신 의무 vs deferred(design-debt) 허용" 기준 명확화 + enforce wiring (Mode M5 · production 0 LOC · clarify+enforce · 신설 아님). 보호 2 file 의도적 변경: `uiux-sot-refresh.md`("즉시 의무 vs Deferred" 분기 subsection + 게이트 [Design SoT Sync] 재배선 · sha-256 `e3b9891d…`→`4d0b5279…`) + `design-sot-policy.md`(§3 code-first deferred 예외 3-bullet · sha-256 `4c566615…`→`92a5e998…`). §14a git-sha1 layer 동기(uiux `d2c62265…`→`0aeac86d…` · dsp `69649a36…`→`0d265e0b…` · ⚠ algorithm 교차 기입 X). 동반 비보호 4: `design-to-code-sync.md`(§10 Deferred Design Debt lane 신설 + §4 P11) · `verification-and-review.md`(§14 Design SoT Sync row 비블로커 + release backstop note + Low Risk 경량화 note) · `reporting.md §7`(### 14 Design SoT Sync 스키마 + Risk note) · `rule-routing-index.md §C`(row 2 UI-UX M/deviation + row 4 빌드-릴리즈 M release backstop + §F entry). 신 REVIEW row token "Design SoT Sync" = 3곳(verification-and-review §14 ↔ reporting §7 §14 ↔ rule-routing §C row 2) 정합. per-repo `DESIGN-DEBT.md` 실 entry seeding = 본 cycle 밖(후속 `3APP-AI-TIER-AD-GATE-DESIGN-RETROFIT-001`). 보호 `ui-spec.schema.json`(#1)·pencil 2종(#4#5) 무접촉. baseline-snapshot 재생성 동반(SessionStart self-heal). 나머지 보호 3 sha 변동 0. 6-repo byte-identical propagation + verify-sync PASS.
- 2026-06-10 · MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001 · Pencil v1.1.62 제거 4종 stale sweep **Phase B** (보호 2 file · Phase A 0e1f7e3 defer분 마감 · Coin 큐 확정 06-10). `pencil-uiux-workflow.md` 7곳(:11 sot-binding 죽은 명칭→실 file 병기 · :20 도구수 12+1→9 · :22 추가 5종 lineage 현존 2/제거 3 · :45/:56/:68 Type 1/2/3 open_document step→현 메커니즘 · :93 STOP moot→부활 검출 STOP) + `pencil-sot-policy.md` 2곳(:40 캔버스 열기 행→headless PRIMARY+시각 alternative · :77 STOP moot→제거 도구 호출 STOP) + 동반 비보호 `cycle-discipline.md`:227. §2.5 headless-primary 본질 무접촉. 보호 2 sha-256: pencil-uiux-workflow.md `2ec100bf…`→`b09b8d50…` · pencil-sot-policy.md `ae20a79c…`→`2bfc81c5…`. §14a git-sha1 layer 동기(`22570f97…`→`aba157e0…` · `acf88d95…`→`ce9c0d3e…` · ⚠ algorithm 교차 기입 X). baseline-snapshot 재생성 동반(직전 2-cycle stale `e6a4a2a1…`/`96de2f5d…` 정합 + PDOCS block 포함). 나머지 보호 3 sha 변동 0. 6-repo byte-identical propagation + verify-sync PASS.
- 2026-06-10 · MASTER-CLI-PROTECTED-STALE-PATH-FIX-001 · 보호 2 file 본문 stale 경로 3곳 수술 정정 (Mode M5 cli-infra-ops · production 무접촉 · audit-P1 F4+F9 + Coin lineage 조항 폐기 본심). ① `pencil-uiux-workflow.md`:12 save-as-result-check.sh 경로 `.claude/hooks/` → `scripts/` (S4 이동 기마감 반영 · design-to-code-sync.md:97 선례 정합) ② `uiux-sot-refresh.md`:61 repo-config.sh 경로 `scripts/agent/` → `scripts/` ③ `uiux-sot-refresh.md`:27 lineage 계약 조항(seed_audit_reference.md · `.ai/uiux-sot/lineage/` dir 6-repo 전수 부재 · 이행 0회) 폐기(strikethrough + 폐기 명시 1줄). 보호 2 sha-256: pencil-uiux-workflow.md `e6a4a2a1…`→`52c07576…` · uiux-sot-refresh.md `ee377dc2…`→`75c0c47e…`. §14a git-sha1 layer 동기(pencil `9d47624a…`→`bac8e801…` · uiux `d3a0b573…`→`b9a0c584…` · ⚠ algorithm 교차 기입 X). 나머지 보호 3 sha 변동 0. 6-repo byte-identical propagation + verify-sync PASS.
- 2026-06-06 · MASTER-PRELAUNCH3-SMALLFIX-001 · cli infra advisory hook `check-abbreviation.sh` 변경 (= `abbreviation-policy.md §3.8` framework/library API whitelist 반영 · `ALLOWED_FRAMEWORK_IDENTIFIERS` set 신설 + finditer 기반 identifier 추출 skip · Play Billing 타입명 `BillingFlowParams`/`ConsumeParams`/`QueryProductDetailsParams` false-block 해소 · GB-BILLING-CLIENT-001 side-finding mitigation). 새 advisory sha-256 = `679e4cf10a3ec929104f92fffa558ab17ae7985324a0391381add35f098981f6` (이전 live `3a69e262…` · GLOBAL-NO-ABBREV-002 표 `c232e2c7…` 이래 누적 변동 갱신 · 보호 5종 외 advisory 영역). 5-repo byte-identical propagation (master + GB + GD + GT + FND). 보호 5종 sha 변동 0.
- 2026-05-27 · MASTER-CLI-COMMANDS-TO-SKILLS-MIGRATION-001 · Commands × 8 → Skills 변환 마감 (Mode M5 · P0-2 옵션 A thin pointer paradigm 자연 후속 · Anthropic "Custom commands have been merged into skills" 정합). legacy `.claude/commands/` × 8 (606 lines) body → `.claude/skills/<name>/SKILL.md` 변환 (body byte-identical 보존 · frontmatter name + model-invocation 최적화 description + allowed-tools 보존 · action-heavy 3 (cycle-report + verify-all + review-task) disable-model-invocation: true) · 신 skill × 7 (uiux-refresh = §0.5 옵션 2 통합 · 기존 uiux-sot-refresh skill 단일 SoT 인용 · 신 skill 신설 X · command 가 이미 skill+rule 위임 구조) · 8 commands → thin pointer (description + allowed-tools 보존 · `/command-name` invocation 보존 · CLAUDE.md §7 routing table 무접촉) · 본인 본심 4 결정 모두 옵션 A · 5-repo byte-identical propagation (skill × 7 + command × 8) · 보호 5 file sha 변동 0 ✓ · 0 production code touch ✓. known follow-up (별 cycle · 본문 본질 보존 Q3 + A3 scope 한정으로 본 cycle 무접촉): review-task + survey skill body 측 stale ref evidence-and-reporting.md (= 소멸 · 현 `reporting.md` 통합) 정정.
- 2026-05-27 · MASTER-CLI-NATIVE-RUN-VERIFY-SANDBOX-INTEGRATION-001 · Anthropic v2.1.145+ native bundled skill (`/run` + `/verify` + `/run-skill-generator` + `/sandbox`) paradigm 통합 마감 (Mode M5 cli-infra-ops + M3 부분 적용). rules × 2 보강 (= `.claude/skills/runtime-crash-mitigation/SKILL.md` §3.3 신설 + §11 entry · `.claude/rules/workflow-core.md` `## implement 규칙` 측 `### Native run/verify integration trigger` sub-section + `## /verify 규칙` native `/verify` bullet · 본문 본질 보존 · 추가 한정 · 5-repo byte-identical propagation · ★**경로 이동** (2026-08-30 병기 · T3): 위 인용 `.claude/rules/workflow-core.md` = **현 경로 `docs/rules/workflow-core.md`** (= `MASTER-CLI-CONTEXT-DIET-2-003` 이 자동 주입층 6 을 뺀 나머지 rule 을 `docs/rules/` 로 이전). ★**소멸이 아니라 이동**이다 — 위 `:87`·`:76`·`:88` 3 건과 달리 **그 규약은 지금도 살아 있고 인용만 구 경로를 가리킨다**. WARN 은 둘을 같은 「부재」로 보고하므로 자로는 안 갈린다) + 자식별 launch recipe skill × 5 신설 (= run-master master self-test (verify-sync.sh + test-protected-file-hooks.sh) + run-foundation core 모듈 assemble/check + run-GB/GD/GT staging flavor `:composeApp:installStagingDebug` · `com.gently.<domain>.staging` · 각 자식 한정 · byte-identical 아님 · propagation 안 함 · L1-3 polyrepo 정합). `/run-skill-generator` 미가용 (v2.1.150 bundled skill 목록 부재) → manual authoring fallback (paste source §5.1 + §8 정합). baseline 정정: GB/GD/GT = `:composeApp` 단일 모듈 (§0.5 estimate 의 `:app` 모듈 정정) · app-foundation = `:core:*` 모듈 (app/composeApp 없음). 보호 파일 5종 sha 변동 0 ✓ · 0 production code touch ✓. staging flavor 한정 + production push 금지 강화 (master `CLAUDE.md §5` STOP #1 정합).
- 2026-05-26 · MASTER-CLI-INSTRUCTIONS-LOADED-PROTECTED-FILE-HOOK-INSTALL-001 · InstructionsLoaded + PreToolUse 보호 file hook 신설 마감. A1 baseline drift detection anchor + A2 protected file integrity guard anchor deterministic enforcement layer 신설 default (= advisory rule paradigm + native enforcement layer 통합 default). cli infra `.claude/hooks/` 측 신 hook × 2 (= `instructions-loaded-baseline-verify.sh` (InstructionsLoaded event · matcher `session_start` · warn-only default + `INSTRUCTIONS_LOADED_VERIFY_ENFORCE` env var upgrade path default · baseline = `.ai/baseline-snapshot/latest.json` 인용 default · 보호 5 file sha-256 drift detection default) + `pre-protected-file-edit-sha-verify.sh` (PreToolUse Edit\|Write matcher · warn-only default + `PROTECTED_FILE_EDIT_ENFORCE` env var upgrade path default · 보호 5 file path explicit match default · enforce mode 측 exit 2 + JSON deny output default) default) + `.claude/settings.json` registration (= InstructionsLoaded event group 신설 + PreToolUse Edit\|Write matcher group hooks 배열 append default) + `scripts/test-protected-file-hooks.sh` 5 fixture self-test runner (= master only default · propagation X default · sandbox-based mock baseline default · 5/5 PASS default ✓). 본인 본심 4 결정 정합 default (= warn-only + InstructionsLoaded 분리 신설 + bash+python heredoc + self-test runner default). 본심 회수 4 영역 정합 default (= Plugins paradigm 회피 default + Auto memory 분리 본질 명시 default + B-5 sub-agent spawn 0 보존 default + Enterprise managed settings 무효 default). `automation-policy.md §3 row 3` Hook 발화 = Transport OK 영역 정합 default. precedent `pre-screen-edit-pen-check.sh` + `baseline-snapshot.sh` + `check-abbreviation.sh` 정합 default. 5-repo byte-identical propagation default (= test runner master only default). 보호 파일 5종 sha 변동 0 ✓ default. 0 production code touch ✓ default.
- 2026-05-26 · MASTER-CLI-SKILLS-MIGRATION-PHASE-1-001 · Skills 마이그레이션 phase 1 마감. cli infra `.claude/rules/` 측 6 file (= runtime-crash-mitigation-process.md + launch-status-auto-sync.md + paste-authoring-disk-verification.md + recommended-option-disk-verification.md + pencil-cli-headless.md + pencil-automation.md · 합계 1225 lines) → `.claude/skills/<name>/SKILL.md` × 6 (= runtime-crash-mitigation + launch-status-sync + paste-source-authoring + disk-verification + pencil-cli + pencil-pen-save) 본문 본질 보존 변환 + 6 rule = thin pointer 갱신 (= 옵션 A · L1-4 단일 SoT paradigm 정합 default · 기존 pointer × N 무접촉 default · `cycle-discipline.md §23~§26` + `workflow-core.md` + `CLAUDE.md` 측 pointer × 다중 영역 path 본질 보존 default). Anthropic Skills paradigm 정합 (= trigger 시점 lazy load default · session token savings 정합 default · Live change detection 정합 default · `.claude/skills/` directory auto-discovery default · settings.json registration 의무 X default). 본심 회수 4 영역 정합 (= Plugins paradigm 회피 default + Auto memory 분리 본질 명시 default + B-5 sub-agent spawn 0 보존 default + Enterprise managed settings 무효 default). 5-repo byte-identical propagation default. 보호 파일 5종 sha 변동 0 ✓. 0 production code touch ✓.
- 2026-05-12 · CLAUDE-CODE-LATEST-CHASE-POLICY-CLARIFY-001 · cli infra `cycle-discipline.md` §13 본문 안 hardcode 영역 → 동적 영역 전환 마감. 정정 내용 = (1) line 163 "현 시점 default `2.1.121` · 회귀 발견 시점에 갱신" 영역 → 동적 영역 (`.auto-memory/incident-log.md` 안 `CLAUDE-CODE-LATEST-CHASE-001` trail 마지막 PASS entry reference default) (2) line 174 "새 known-working 등재 전까지 본 §13 안 기재 known-working 갱신 의무" 영역 → 폐기 명시 (lazy default · 매 갱신 의무 X). self-test 3 항목 영역 본문 무변경. cycle-discipline.md sha `0e4a7d01997c0d12ddb432d14ee37cdb1c4f1bbc` → `5726cb44c5f4d53d10db3018a74debea6ba5fc19` (4-repo byte-identical · git blob sha1). Gently 4-repo propagation scope (cli-master + GB + GD + GT) · Proto 3-repo 무접촉 (현 baseline `732017a7...` 유지 영역). 보호 파일 5종 sha 변동 0 (cli infra 권장 영역만 변경). 별 trail `CLAUDE-CODE-LATEST-CHASE-001` 첫 PASS entry append (2026-05-12 KST / 2.1.139 / 3/3 PASS).
- 2026-05-12 · MASTER-COWORK-HANDOFF-BASELINE-AUTOVERIFY-HOOK-001 · cli infra SessionStart hook 신설 `.claude/hooks/baseline-snapshot.sh` (sha `d41f25ffc2819a638c73a71a28d5804120df72095fb4f58bd9f69e3f0a9cadb9`) — 7-repo (cli-master + Gently 3 + Proto 3) HEAD + cycle-discipline.md sha + 보호 파일 5종 sha + settings.json sha 자동 캡처 → `.ai/baseline-snapshot/<timestamp>.json` + `latest.json` copy. macOS bash 3.x 호환 (printf-based JSON · associative array X). drift detection inline = cli-master cycle-discipline sha vs Gently 3 children 비교 (stderr warn-only · non-blocking exit 0). settings.json SessionStart 배열 등록 (기존 `session-start.sh` 와 묶음 · 새 sha `6919ac4ad00ab7962e0ef7393872c9c1c086e50b2af6a80e0ea0c1628581d80f`). 4-repo propagation scope = cli-master + Gently 3 (Proto 3 무접촉 = 별 cycle 분리). self-test PASS = exit 0 · JSON 6823 byte · 7-repo cycle-discipline sha `732017a7cdd589d496140156c019ab9b79439d4bb37a300e1d1c548d8948258d` byte-identical · drift 0. 보호 파일 5종 sha 변동 0 (cli infra 영역만 변경 · 보호 영역 무접촉). COWORK-PREP-BASELINE-MISMATCH-001~007 누적 영역 자동 캡처 mitigation 정착 (passive snapshot 단계).
- 2026-05-12 · PROTO-CLI-VERSION-UNPIN-PROPAGATION-001 · cli infra `cycle-discipline.md` Proto 3-repo (ProtoGentlyBreath + ProtoGentlyDay + ProtoGentlyTable) 확장 propagation 마감. Proto 3-repo baseline `8e48d486...` → `732017a7cdd589d496140156c019ab9b79439d4bb37a300e1d1c548d8948258d` (cli-master 정합) · 7-repo byte-identical 정합 영역 도달 (cli-master + GB + GD + GT + PB + PD + PT 모두 동일 sha `732017a7...` ✓). Proto 3-repo commit shas: PB `9805361c` / PD `f266338c` / PT `3d96668f` (parents PB `7ded7008` / PD `419d5a8b` / PT `a8ec3c1c`). Gently 4-repo 무접촉 (이미 직전 cycle `CLI-VERSION-UNPIN-PROPAGATION-001` 정합) · 보호 파일 5종 sha 변동 0 · Proto 3-repo 의 다른 unrelated 변경 무접촉 (명시적 stage 의무 충족).
- 2026-05-12 · CLI-VERSION-UNPIN-PROPAGATION-001 · cli infra `cycle-discipline.md` §13 본문 갱신 (pin 폐기 → 최신 추격 정책 전환 · npm scope + DISABLE_AUTOUPDATER + DISABLE_UPDATES 이중 차단 유지 + 주 1회 능동 갱신 default + self-test 3 항목 + FAIL 복귀 절차) · 4-repo byte-identical (`4cd01b4eca11feee...` → `0e4a7d01997c0d12...`) · master 0e4a7d0 / GB 0e4a7d0 / GD 0e4a7d0 / GT 0e4a7d0 (sha 동일 = byte-identical ✓) · 보호 파일 5종 sha 변동 0 · Proto 3-repo (8e48d48 baseline) 무접촉.
- 2026-05-11 · MASTER-GB-AUTH-ACTIVATE-001 · GB Auth 도메인 활성화 (UNKNOWN → ACTIVE ³) · master `deferred-domains.md` §2 매트릭스 GB 열 + footnote ³ + §6 history append (1 파일 변경) · 4-repo propagation (`propagate.sh` ok=4 fail=0) · verify-sync PASS 112/0/0 (exit 0) · 5-repo deferred-domains.md shasum 동일 (`f43303b082f6...`) · `auth-rules.md` SoT 재사용 (GB-applicable READ-ONLY 검증 PASS) · `routing-and-delegation.md` 의무 vacuous (이미 globally active) · 보호 파일 5종 sha 변동 0 · GB SteadyWell drift trail 자연 close.
- 2026-05-11 · MASTER-APP-FOUNDATION-SCAFFOLD-001 · `app-foundation` repo 신설 (HEAD `923346b` · scaffold cd6f418 + cli infra cp 923346b dual commit) + propagation 5→6 repo 확장 (`propagate.sh` / `verify-sync.sh` TARGET_REPOS + FND case + release-readiness/* exclude) + `COMMON-SETUP-SSOT-DRAFT.md` master → foundation docs/COMMON-SETUP-SSOT.md 이전 (= app-foundation 이전 · master 부재) + PACKAGE-OVERVIEW §3 MASTER-T01 ✓. propagate 112/0 · verify-sync PASS 112/0/0 (exit 0) · 보호 파일 5종 sha 변동 0.
- 2026-05-10 · MASTER-BILLING-DOMAIN-ACTIVATE-001 · Billing 도메인 4-repo 활성화 (UNKNOWN×4 → ACTIVE×4) · `billing-rules.md` SoT 신설 + `billing-payments-guardian` agent deferred/ → active/ + STEP-1 drift mitigation (master sot-code-name-map.md ← GT 흡수 · 새 sha `7f2f4e61c635d6f425232c4c5f0d5b7caed9a8da3036efcff6c67de9676068d2`) · 4-repo byte-identical (verify-sync 112/0/0) · 보호 파일 5종 sha 변동 0.
- 2026-05-05 · MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001 · cli infra ux-laws.md sha 변동 80aa2915... → 0f63f399... (322 line / §5.1 N/A 영역 7 신설) · 4-repo byte-identical · 보호 파일 5 종 sha 변동 0 · master 3c48df5 / GB a8d985e / GD dd4d6f0 / GT 25d2358.
- 2026-05-05 · MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001 Phase 1 정합 검증 · 보호 파일 5 종 + cli infra 6 종 4-repo byte-identical 재확인 (drift 0). prompt BASELINE 의 `design-sot-policy.md` 위치 가정 (`.claude/rules/`) 정정 → 실제 `docs/design/`. 보호 파일 sha 변동 0.
- 2026-05-04 · MASTER-DOC-CITATION-FIX-001 · ui-spec.schema.json description 의 Pencil 잔존 어휘 3곳 (`L129/191/210`) → 디자인 도구 generic 정정. 필드명 alias (`lastSyncedPencilStateHash` 등 v0.3 alias) 와 도구 바인딩 파일 인용 (`pencil-sot-binding.md`) 은 보존. 4-repo byte-identical propagation 동시.
- 2026-05-03 · MASTER-PROTECTED-BASELINE-RESYNC-001 · 보호 파일 5종 sha **MATCH 확정** + ui-spec.schema.json enum 에 "0.3" 추가 (description 은 변동 없음). 자식 ui-spec.json schemaVersion 마이그레이션은 별 cycle 분리.
- 2026-05-02 · C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 · 보호 파일 4종 sha **모두 갱신** (도구 무관 vs Pencil 전용 분리). 신설 보호 파일 1종 (`design-sot-policy.md`). 신설 cli infra 2종 (`code-principles.md` / `design-to-code-sync.md`).
- 2026-05-02 · C2-RULES-RESTRUCTURE-001 · 5 파일 신설 + 6 파일 deprecated + 5 파일 cross-reference 갱신. 보호 파일 4종 sha 변동 0.
- 2026-05-02 · C1-MASTER-BOOTSTRAP-001 · master baseline 신설.

## C6 신설/흡수 (2026-05-02)

### 흡수 6 파일 (3-repo byte-identical)
- `.ai/promptfit/PLAYBOOK.md` (PromptFit 평가 가이드)
- `.ai/uiux-sot/refresh/TRIGGERS.md` (refresh trigger patterns)
- `.ai/uiux-sot/refresh/VERIFY.md` (refresh 검증 명령)
- `.ai/uiux-sot/refresh/WORKFLOW.md` (refresh workflow)
- `.github/pull_request_template.md` (PR template)
- `archive/2026-08/RLS_AND_PLAY_INTEGRITY_GUIDE.md` (Supabase RLS + Play Integrity) — 2026-08-01 `MASTER-DOCS-STALE-SWEEP-002` 로 **전파 세트 이탈** (구 경로 = docs/backend/ · master archive 1부 보존 · 자식 3 삭제 · 내용 무편집)

### 신설 9 파일 (master 신규 SoT)
- `docs/guides/app-implementation-guide.md` (243 줄 · Claude CLI 진입 1차 가이드) — **MASTER-ENGINEERING-BASELINE-002 정정** (2026-08-29 · 구 표기 = 204 줄 · 경로 무변 · 행수 = 집행 시점 `wc -l` 실측)
- `docs/templates/api-spec.template.md`
- `docs/templates/data-model.template.md`
- `docs/templates/screen-flow.template.md`
- `docs/templates/ai-prompt-guide.template.md`
- `docs/templates/billing.template.md`
- `docs/templates/setup-guide.template.md`
- `docs/templates/pencil-dev-prompt.template.md`
- `.auto-memory/child-claude-md-header.template.md` (Nested CLAUDE.md 패턴)

보호 파일 5종 sha = C2.5 baseline 보존 (변동 0).
