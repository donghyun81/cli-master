# Incident Log — claude-cli-master

> 사고 기록 누적. 패턴 2회 이상 재발 시 별 trail 신설.
> 자식 repo 의 사고는 자식 repo 의 `.auto-memory/incident-log.md` 에 기록 (master 와 별도).
> master 사고 = cli infra / propagation / 보호 파일 / scripts 관련만.

## 사고 분류 (CLAUDE.md §22 추상 분류 참조)

- **도메인 도구 한계** — 외부 도구 미지원 기능
- **자동화 install ≠ activation** — 설치는 됐으나 작동 검증 안 됨
- **3-repo drift** — 보호 파일 또는 cli infra 의 byte-identical 깨짐
- **agent self-verification false positive** — agent EC PASS 보고하나 실측 FAIL
- **사용자 의도 vs 정책 충돌** — 정책이 반복 의도와 어긋남
- **cycle scope 부풀음** — 한 cycle 에 다른 영역 묶임

## 기록 형식

```
## YYYY-MM-DDTHH:MM:SS+0900
- type: <분류>
- cycle: <cycle-id>
- summary: <1줄>
- mitigation: <대응 1줄>
- trail: <별 trail ID 또는 close>
```

## 2026-05-11T16:30:00+0900
- type: 도메인 도구 한계 사전 검증 PASS (Sentry SDK ↔ Kotlin 2.0.21 호환 baseline 박음)
- cycle: SENTRY-SDK-INTEGRATE-01 (사전 의무 검증 · 마감)
- summary: Firebase BoM 34.13.0 측 Kotlin 2.2.0 metadata incompatibility 사고 (2026-05-11T14:50) 측 재발 회피 paradigm 측 적용 — Sentry Android SDK `7.20.0` + Gradle plugin `4.14.1` 측 1차 candidate 박음. GB 측 1 repo 측 한정 file edit (libs.versions.toml + build.gradle.kts × 2) 후 `:app:compileDebugKotlin` 측 BUILD SUCCESSFUL exit 0 (kotlin_module metadata reject 0 · 사전 검증 PASS 신호) → 3 repo 측 propagation + 5 file 측 통합 + 3 commit (GB 219a224 · GD ffd8265 · GT e8bca80). 측 cycle prompt 측 명시 STOP 조건 ("Sentry SDK 측 Kotlin 2.0.21 호환 mismatch 감지 → 즉시 STOP") 측 발동 X.
- mitigation: paradigm 정착 — 외부 SDK 통합 시 1 repo 측 한정 build script edit 후 `:app:compileDebugKotlin` 측 사전 호환 검증 (assembleDebug 측 진입 전) → PASS 시 3 repo propagation. 호환 mismatch 시 분기점 binary search 또는 SDK 측 alternative 검토.
- trail: close (SENTRY-SDK-INTEGRATE-01 마감) · paradigm 측 향후 외부 SDK 통합 cycle (Sentry release tracking · OkHttp interceptor · foundation/core/observability/ wrapper) 측 재사용 의무.

## 2026-05-11T14:50:00+0900
- type: 도메인 도구 한계 (Firebase BoM ↔ Kotlin metadata 버전 호환)
- cycle: FIREBASE-COMMIT-001 (STOP 보고) · FIREBASE-BOM-DOWNGRADE-001 (mitigation 마감)
- summary: Firebase BoM `34.13.0` 측 transitive `com.google.android.gms:play-services-measurement-{impl,api}:23.2.0` 측 Kotlin `2.2.0` build 박힘 (`META-INF/*.kotlin_module` metadata binary version) ↔ 프로젝트 Kotlin `2.0.21` 측 metadata reader 측 reject → 3 repo (GB/GD/GT) × `:app:compileDebugKotlin` BUILD FAILED · `Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 2.2.0, expected version is 2.0.0.` × 5+ `kotlin_module` 측 동시 reject. assembleDebug 측 진입 불가.
- mitigation: `[FIREBASE-BOM-DOWNGRADE-001]` cycle 측 BoM 34.13.0 → 33.7.0 측 1 line downgrade (3 repo byte-identical · firebase-analytics 22.1.2 + firebase-crashlytics 19.3.0 측 resolve) → 3 repo × `:app:assembleDebug` BUILD SUCCESSFUL (exit 0) · build 4-line line edit (libs.versions.toml `firebaseBom` 측 1 line × 3 repo). cycle prompt 측 STOP 조건 ("AGP / Kotlin / Crashlytics plugin 측 호환 불호환") 측 정확 발동 + 별 cycle 측 file edit only 측 mitigation 마감.
- trail: close (FIREBASE-BOM-DOWNGRADE-001 마감) · 후속 `[KOTLIN-UPGRADE-2.2.X-001]` 별 trail 후보 (출시 후 시점 진입) · BoM `33.x.x` 측 마지막 Kotlin 2.0.x 호환 line 측 식별 lazy (33.16.0 측 실측 검증 별 cycle 후보 · 출시 직전 보안 패치 적용 시점).

## 2026-05-10T23:41:00+0900
- type: 3-repo drift (master ↔ GT)
- cycle: MASTER-BILLING-DOMAIN-ACTIVATE-001 STEP-1 (drift mitigation)
- summary: master `.claude/rules/sot-code-name-map.md` 가 GT 의 GT-PHASE-3-SOT-001 갱신 1 row + aggregate 1 update 미반영 (daily-prescription-screen 누락 · 1:1 직매핑 GT 11/21 → 12/22 갱신 누락)
- mitigation: master Edit 2회 surgical (row insert + aggregate 갱신) → shasum 일치 (`7f2f4e61c635d6f425232c4c5f0d5b7caed9a8da3036efcff6c67de9676068d2`) → 본 cycle propagation 으로 4-repo 통일 (verify-sync 112/0/0)
- trail: close (본 cycle 마감)

## C1 baseline 사고 (참조용 · 자식 repo 에서 발견된 drift)

```
## 2026-05-02T05:50:00+0900
- type: 3-repo drift
- cycle: (CLI-GUIDE-001 보고서 작성 중 발견)
- summary: GB 의 deferred-domains.md 가 SteadyWell propagation 잔존으로 ACTIVE 표기 (CLAUDE.md "현재 미정의" 와 불일치)
- mitigation: master 가 GT 의 UNKNOWN baseline 채택 → C4 propagation 시 GB 도 통일
- trail: close (C4 마감 시)
```

```
## 2026-05-02T05:50:00+0900
- type: 3-repo drift
- cycle: (CLI-GUIDE-001 보고서 작성 중 발견)
- summary: GT 의 routing-and-delegation.md 가 [DEFERRED] 라벨 미부착 (GB/GD 와 불일치)
- mitigation: master 가 GB+GD 의 [DEFERRED] 명시 채택 → C4 propagation 시 GT 도 통일
- trail: close (C4 마감 시)
```

```
## 2026-05-02T05:50:00+0900
- type: 사용자 의도 vs 정책 충돌
- cycle: (CLI-GUIDE-001 보고서 작성 중 발견)
- summary: 자식 repo 가 cli infra 직접 수정 가능 → master SoT 위반 위험 + propagation 의무 누락 패턴
- mitigation: master 신설 + 단방향 propagation 정책 박음 (CLAUDE.md §0 §3 §4)
- trail: close (C4 마감 + 자식 repo CLAUDE.md propagation 시)
```

```
## 2026-05-02T07:50:00+0900
- type: 자동화 install ≠ activation
- cycle: C8-GIT-LOCK-AUTOMITIGATION-001
- summary: sandbox / agent crash 후 잔존 .git/index.lock = 다음 git command 차단 → Coin 매번 손 작업 rm 의무 반복
- mitigation: pre-tool-use.sh = git command 감지 시 stale > 30s 자동 정리 + session-start.sh = 세션 시작 시 stale > 5분 자동 정리
- trail: close (C8 박힘 · cli infra 권장 byte-identical · C4 propagation 시 자식 자동 적용)
```

```
## 2026-05-02T08:10:00+0900
- type: 자동화 install ≠ activation (재발 · C8 mitigation 한계)
- cycle: C9-GIT-LOCK-PID-VERIFY-001
- summary: C8 박힌 hook 자동화 = Claude Code Bash tool 만 발화 → Coin 의 IDE/터미널/Cowork 에서 git 호출 시 hook X + stale 마진 30s/5분 너무 김
- mitigation: PID 기반 검증 (lock 안 PID 죽음 = 즉시 rm · mtime 무관) + standalone scripts/git-safe.sh wrapper (Coin 환경 alias 권장) + mtime 마진 단축 (pre-tool-use 5s / session-start 30s)
- trail: close (C9 박힘 · 99.9% case 자동 mitigation · alias 적용 시 Coin 환경 100%)
```

```
## 2026-05-02T08:30:00+0900
- type: 자동화 install ≠ activation (재재발 · C9 mitigation 한계 · 환경 진단 박힘)
- cycle: C10-LAUNCHD-DAEMON-001
- summary: C9 PID 검증 박았으나 사용자 환경 = Cowork chat 의 자체 file ops 가 git operation 호출 시 hook X · wrapper X · sandbox 권한으로 lock rm 절대 불가 (실측 PASS) · Coin 환경 alias 박혀 있어도 본 메시지는 sandbox 환경 발생
- mitigation: macOS launchd 백그라운드 데몬 박음 (5초마다 PID 검증 + stale rm) — 환경 무관 (Cowork/IDE/터미널/sandbox/모든 도구) 자동 작동 + scripts/install-git-lock-daemon.sh 1회 install 후 영구
- trail: close (C10 박힘 + Coin install 1회 후 99.99% 자동 mitigation · daemon log = ~/Library/Logs/git-lock-daemon.log)
```

```
## 2026-05-02T08:50:00+0900
- type: 자동화 install ≠ activation (재재재발 · C10 mitigation 한계 · lock 종류 사고 발견)
- cycle: C11-LOCK-WIDE-COVERAGE-001
- summary: C10 daemon + C8/C9 hook/wrapper 모두 .git/index.lock 만 처리 → GT commit 시 .git/HEAD.lock 발생 (commit op = HEAD ref 갱신 시 박힘) · git lock 종류 다양: index/HEAD/packed-refs/config/refs/heads/<branch>/refs/tags/* 모두 발생 가능
- mitigation: 4 layer (daemon + 2 hooks + wrapper) 모두 광역 검사 박음 — index.lock + HEAD.lock + packed-refs.lock + config.lock + refs/**/*.lock 동일 PID 검증 + stale rm patterns 적용
- trail: close (C11 박힘 + Coin daemon install 1회 후 모든 git lock 종류 자동 mitigation)
```

```
## 2026-05-02T09:30:00+0900
- type: 자동화 install ≠ activation (재발) + 사용자 의도 vs 정책 충돌 (잔존)
- cycle: C4-VERIFY-001
- summary: C4 propagation 정합 (sha 109/0/0 PASS) 사후 검증 = 4 종 누락 발견 — (1) C11 hook 갱신 후 자식 propagate 누락 → drift 6 (sandbox cp 즉시 정정), (2) C2 분할의 deprecated pointer 6 종 master + 3 자식 4-way 잔존 = 24 (Coin rm), (3) 자식 flat agents 25 × 3 = 75 (active/deferred 폴더 이전 후 잔존 · Coin rm), (4) C4-1 BASELINE 검증용 sandbox testfile × 3 (Coin rm)
- mitigation: sandbox 권한 가능 정정 = 즉시 cp / 권한 X 정정 = Coin 손 작업 1 paste (102 파일 rm + master 1 commit + 자식 3 commit) · 후속 옵션 = `propagate.sh --prune` 신설 검토 (cycle 우선순위 낮음)
- trail: close (Coin 손 작업 후 verify-sync 103/0/0 회복 시 baseline 정정)
```

```
## 2026-05-02T10:00:00+0900
- type: 자동화 install ≠ activation (재5발 · launchd daemon 미활성)
- cycle: C12-LOCK-RECURRENCE-DIAGNOSIS-001
- summary: C4-VERIFY commit paste 실행 중 4-repo 모두 .git/index.lock 차단 (반복 발생). C8/C9/C10/C11 mitigation 모두 적용 후에도 재발 = launchd daemon (com.coin.git-lock-cleaner) install 누락 또는 비활성 강력 시사. macOS 터미널 / Cowork chat 의 git op = hook 발화 X (Claude Code Bash tool 한정) → daemon 만이 유일한 자동 mitigation 인데 미활성 = 영구 lock.
- mitigation: Coin 1 paste (광역 lock rm + daemon 진단 + install + commit 재시도) → 4-repo commit 성공 + verify-sync 103/0/0
- trail: close (사고 해결) + C13 후속 검토 (verify-sync.sh 첫 줄에 daemon 활성 자동 체크 + 미활성 시 즉시 install 권장)
```

```
## 2026-05-02T11:00:00+0900
- type: 3-repo drift (자식 .gitignore propagation 누락) + sandbox 자체 미발견
- cycle: C13-VERIFY-FULL-001
- summary: C1~C4 광역 검증 중 발견 — master `.gitignore` 12 줄에 `.claude/settings.local.json` 등록 / 3 자식 `.gitignore` 모두 미등록 = drift. propagate.sh 에 `.gitignore` 가 cp 대상 미포함 (find 의 base path = .claude/docs/scripts/agent/.ai/promptfit/.ai/uiux-sot/refresh/.github + root 5 만). 결과: 자식 git status 매번 settings.local.json untracked 표시.
- mitigation: 옵션 A (`.gitignore` 4-repo 동기 cp + propagate.sh root 파일 list 에 추가) · 옵션 B (자식 .gitignore 만 즉시 cp + propagate.sh 갱신은 별 cycle)
- trail: open (다음 cycle 권장 항목 = C14-PROPAGATION-COVERAGE-001)
```

```
## 2026-05-02T12:00:00+0900
- type: prompt 작성 baseline 검증 의무 (C15 사고 사전 차단)
- cycle: C14+C13+C15-INFRA-MITIGATION-001 (sandbox 진입 중 발견)
- summary: C15 초안 (--prune 전 cli infra base path orphan 검사) sandbox dry-run 시 자식 도메인 311 파일 false positive 발견 — docs/setup/{DDL,phase3,partB} / docs/design/pencil-sot/*.pen / docs/agent/solutions/MANAGED_AGENTS_READINESS.md / scripts/agent/repo-config.sh / .ai/promptfit/INDEX.md 등 모두 repo-specific. `--apply` 실행 시 도메인 전체 날아감.
- mitigation: 정책 변경 = whitelist `.claude/` 만 prune 후보 (default). `--include <path>` flag 신설 = 별 cycle 검토. 사전 dry-run 검증으로 사고 사전 차단.
- trail: close (사고 사전 차단 · 학습 = 새 자동화 모드 신설 시 dry-run 의무 + whitelist 우선)
```

```
## 2026-05-02T12:00:00+0900
- type: 3-repo drift (Android Studio .gitignore vs master .gitignore 비호환)
- cycle: C14+C13+C15-INFRA-MITIGATION-001
- summary: C14 초안 (master .gitignore byte-identical cp) sandbox 진입 중 발견 — 자식 .gitignore = build/gradle/local.properties/Thumbs.db 등 Android Studio repo 패턴 보유 / master .gitignore = 단순 generic. 단순 cp 시 자식 빌드 차단.
- mitigation: 정책 변경 = master .gitignore 자체 propagate X (자식 자율). 별 script `ensure-child-gitignore-patches.sh` 가 cli infra patterns 만 자식에 marker block 으로 patch (idempotent). propagate.sh 자동 호출.
- trail: close (사고 사전 차단 · 학습 = 자식 자율 영역과 master cli infra 영역 명확 분리 의무)
```

## 2026-05-09T00:00:00+0900

```
- type: 3-repo drift + cycle scope 부풀음 (seed 결함 전파)
- cycle: NEW-REPO-BASELINE-GT-CLAUDE-MD-RCA-001
- summary: GT CLAUDE.md 가 master SoT (`# Gently Master — Claude Code 운영 SoT`) 의 verbatim cp 였음. GD/GB 는 SteadyWell propagation 을 통해 자식 Nested pattern (`# Claude Code 운영 헌법`) baseline 보유. RCA 결과 = GentlyClean seed `GentlyTable/00-CLAUDE-헌법.md` 자체가 master SoT cp 결함 + NEW-REPO-BASELINE cycle 의 verbatim cp 로 GT 만 master cp baseline 노출. 동족 사고 누적 = COWORK-PREP-BASELINE-MISMATCH-001~004 (Cowork ↔ CLI handoff baseline 미참조 4회) + 본 사고 = 5회.
- mitigation: GT CLAUDE.md 재작성 (자식 Nested pattern + GT 도메인 1 섹션). CLAUDE.md §2 정합 강제 표 권한 (CLAUDE.md 본문 도메인 섹션 = repo-specific 자유) 인용으로 master cycle 의무 없이 GT-only 정정 타당화. 5 검증 명령 PASS (sha 비교 / line 수 / title / Gently Master grep 0 hit / 도메인 keyword 16 hit).
- trail: close (본 cycle) · 별 trail 2 open: (1) GentlyClean seed `00-CLAUDE-헌법.md` 자체 정정 cycle (lazy · 다음 자식 repo 신설 시 자연 trigger) (2) GD/GB 도메인 헌법 1 섹션 추가 cycle (lazy · GD/GB 본 작업 진입 시 자연 trigger). 6회차 재발 시 mitigation 강화 cycle 진입 (Cowork 측 baseline 자동 검증 hook 도입 검토).
```

## 2026-05-10T18:30:00+0900

```
- type: paste-back 정확성 영역 (사고 3) + cowork sandbox memory algorithm 모순 RCA (사고 1) = 사고 4 종 누적
- cycle: MASTER-INCIDENT-LOG-PASTE-BACK-ACCURACY-AND-SHA-ALGORITHM-RCA-001
- summary: 직전 cycle MULTI-REPO-CLAUDEMD-DOMAIN-CONTEXT-FILL-001 paste-back 보고 영역 사고 3 + cowork baseline anchor algorithm mismatch RCA 사고 1 = 4 종. (사고 1) GB parent 표기 오류 — paste-back "GB 036592a · parent 64de5a5" / 실 chain 036592a ← d220153 ← 64de5a5 = 1 단계 누락. (사고 2) 보호 file count 6 → 5 누락 — paste-back "보호 5 sha" / cowork prompt 의무 = 6 (auth-rules.md 6d3e107ddac612e9 누락). (사고 3) sha algorithm mismatch — paste-back = sha-256 prefix (f1edd397...) / cowork prompt 의무 = git blob sha (5b84cd9e...). (사고 4 RCA) cowork sandbox memory pencil_sot_consolidated §2 자체 algorithm 모순 — 표기 = git blob sha 16자 prefix / 검증 명령 = sha256sum = 진입 cross-verify 시 6/6 mismatch false positive trigger. 본질 영향 0 (4 사고 모두 4-repo file content byte-identical ✓ / 표기 layer 사고만).
- mitigation: (1) paste-back 시 `git log -1 --format='%h %p'` direct 인용 의무 (single-step parent 검증). (2) cowork prompt 안 보호 file count N 명시 → paste-back 동일 N 의무 (count cross-check). (3) cowork prompt 안 algorithm 명시 의무 ("git blob sha 16자 prefix") + paste-back 동일 algorithm 의무. (4) cowork sandbox memory pencil_sot §2 갱신 마감 (algorithm "git blob sha 16자 prefix" 명시 + sha-256 reference column 추가 + 검증 명령 = `git hash-object` 정정).
- trail: close (본 cycle 마감 · 사고 본질 영향 0 · drift 0 · commit chain 정합 ✓). 동족 사고 누적 영역 = (i) 2026-05-08 paste-back PASS 후 disk cross-check 의무 (memory feedback_paste_back_disk_verification) (ii) 2026-05-09 사용자 의도 추측 X (memory feedback_no_speculation_user_intent_assumption) (iii) 본 사고 = paste-back 정확성 영역 + cowork sandbox memory 자체 정합 영역 = 3 누적. 학습 = cowork ↔ CLI handoff 시 (1) algorithm 명시 / (2) count 명시 / (3) parent commit single-step 인용 / (4) memory 자체 모순 사전 검증 = 4 hook 영역. 5회차 재발 시 mitigation 강화 cycle 진입 (handoff 자체 검증 hook 도입 검토).
```

## 2026-05-11T00:00:00+0900

```
- type: verify-sync.sh false positive drift/miss (ledger repo-specific 영역 vs propagation 검증 정책 mismatch · 도구 부산물 1건 동시 발생)
- cycle: MULTI-REPO-RELEASE-LEDGER-INIT-001
- summary: 4-repo ledger 신설 commit 4건 마감 후 verify-sync.sh exit 1 출력 (PASS 112 / DRIFT 0 / MISS 6). MISS 6 = master/docs/release-readiness/PACKAGE-OVERVIEW.md + COMMON-SETUP-SSOT-DRAFT.md 가 자식 3-repo MISS. 본 cycle 의도 = ledger file = repo-specific 구조 (master 측 거시 SoT 2 file + 자식 측 LAUNCH-STATUS.md 1 file 각각). verify-sync.sh = docs/ 전체 propagation 대상 + release-readiness/ exclude 정책 X = false positive. 핵심 의무 모두 PASS (HEAD baseline 일치 4/4 · 보호 5 sha 변동 0 · billing-rules.md sha 0ec5d54f49dfd6e2 무결성 PASS · ledger line 96/114/184/181/194 일치 · protected-file-hashes.md 변동 0 · Stage 격리 100%). 부산물 사고 1 = verify-sync.sh 실행 시 .auto-memory/propagation-status.md 자체 갱신 박음 (도구 부산물 · 본 cycle scope X · CLI stage 안 함 의무 준수). 부산물 경고 1 = git-lock daemon 미활성 (C12 사고 패턴 재발 위험 경고 · 본 cycle scope 외 · 사용자 결정 영역).
- mitigation: 별 mitigation cycle 권장 분리 = (1) verify-sync.sh 안 release-readiness/ 영역 exclude 정책 추가 (제안: docs/release-readiness/* glob 패턴 propagation 대상 제외) (2) propagation-status.md 자체 갱신 부산물 처리 결정 (도구 행동 변경 vs 별 cycle 단독 commit). 본 cycle REVIEW.md 4건 = Verdict=PASS 조건부 박음 + 사용자 회수 의무 4건 명시 (.ai/reports/MULTI-REPO-RELEASE-LEDGER-INIT-001/REVIEW.md 안 박음).
- trail: open (별 mitigation cycle 분리 · ledger 영역 도구 정책 mismatch 첫 사고). 동족 사고 누적 영역 = COWORK-PREP-BASELINE-MISMATCH-001~004 (Cowork ↔ CLI handoff 영역 4회) + paste-back 정확성 영역 4회 + 본 사고 = 9 누적 (단 영역 분리 — 본 사고 = CLI ↔ 도구 영역 첫 사고). 학습 = repo-specific 영역 신설 시 verify-sync.sh exclude 정책 사전 검증 의무 · 본 cycle 진입 전 release-readiness/ 영역 처리 정책 prompt 본문 명시 X → CLI 자체 판단 영역 X → 사용자 회수 영역 의무.
```

## 2026-05-11T17:00:00+0900

```
- type: verification PASS (cli infra 환경 정합 영역 · pin 정책 unpin 게이트)
- cycle: CLAUDE-CODE-VERSION-UNPIN-VERIFY-001
- summary: claude 2.1.121 환경 안 stdio MCP tool discovery 회귀 (#51736) 해소 실측 검증. PASS 4/4 — (1) claude --version = 2.1.121 (2) mcp list pencil ✓ Connected (3) ToolSearch query="pencil" = 13 tools (mcp__pencil__* prefix 전수 명단 verbatim 일치 · batch_design/batch_get/export_nodes/find_empty_space_on_canvas/get_editor_state/get_guidelines/get_screenshot/get_variables/open_document/replace_all_matching_properties/search_all_unique_properties/set_variables/snapshot_layout) (4) mcp__pencil__get_editor_state 실호출 PASS (active editor daily-prescription.pen + 4 top-level frames). cli-master 한정 · propagation 자체 금지 · .mcp.json/.claude 무변경 STOP 조건 모두 준수. 산출물 = .ai/reports/CLAUDE-CODE-VERSION-UNPIN-VERIFY-001/{PLAN,EVIDENCE,VERIFY,REVIEW}.md 4 파일 + 본 incident-log entry.
- mitigation: 별 cycle CLI-VERSION-UNPIN-PROPAGATION-001 진입 권장 (cycle-discipline.md §13 안 2.1.114 pin 의무 영역 → 2.1.121+ unpinned 갱신 + 4-repo propagation + CLAUDE.md §15 entry). Coin 결정 게이트 통과 후 진입 의무.
- trail: 부분 close — CLAUDE-CODE-VERSION-PIN-2.1.114-001 별 trail = 본 cycle PASS 로 unpin 게이트 통과 / 실 close 는 별 cycle CLI-VERSION-UNPIN-PROPAGATION-001 마감 시점. #51736 회귀 본질 영향 0 (2.1.121 에서 해소 실측 확인 · single 환경 한계 단서 잔존).
```

## 2026-05-11T16:44:58+0900
- type: blocked-tasks
-   - MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001: 누락= VERIFY.md
-   - MASTER-WORKING-FILE-LIFECYCLE-001: 누락= VERIFY.md
-   - MULTI-REPO-BILLING-MODEL-RECONCILE-001: 누락= VERIFY.md
-   - MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001: 누락= VERIFY.md

## 2026-05-11T16:45:13+0900
- type: blocked-tasks
-   - MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001: 누락= VERIFY.md
-   - MASTER-WORKING-FILE-LIFECYCLE-001: 누락= VERIFY.md
-   - MULTI-REPO-BILLING-MODEL-RECONCILE-001: 누락= VERIFY.md
-   - MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001: 누락= VERIFY.md

## 2026-05-12T00:00:00+0900

```
- type: cli infra propagation 마감 (cycle-discipline.md §13 본문 갱신 · pin 폐기 → 최신 추격 정책 전환) + 별 trail 2 종 갱신 (close + open)
- cycle: CLI-VERSION-UNPIN-PROPAGATION-001
- summary: 직전 cycle CLAUDE-CODE-VERSION-UNPIN-VERIFY-001 안 #51736 회귀 해소 실측 PASS (2.1.121 환경) 후 본 cycle 안 정책 본문 전환 마감. cycle-discipline.md §13 line 132+ "2.1.114 pin 의무" 단락 → "최신 추격 정책 (npm scope + DISABLE_AUTOUPDATER + DISABLE_UPDATES 이중 차단 유지 + 주 1회 능동 갱신 default + 매 cycle 진입 self-test 3 항목 + FAIL 시 복귀 절차)" 본문 갱신 + 4-repo byte-identical propagation. 새 sha = `0e4a7d01997c0d12ddb432d14ee37cdb1c4f1bbc` (4-repo 모두 동일 ✓). #51736 본질 fix verbatim 인용 박음 (changelog v2.1.122 line "ToolSearch missing post-startup MCP tools in nonblocking mode"). 산출물 4종 = .ai/reports/CLI-VERSION-UNPIN-PROPAGATION-001/{PLAN,EVIDENCE,VERIFY,REVIEW}.md. self-test 3 항목 본 cycle 마감 시점 모두 PASS (claude --version = 2.1.121 / mcp list pencil ✓ Connected / ToolSearch query="pencil" = 13 mcp__pencil__* tools). 보호 파일 5종 sha 변동 0 (CONFIRMED). Proto 3-repo (8e48d48 baseline) 무접촉 의무 준수 (별 cycle 책임).
- mitigation: env 차단 (DISABLE_AUTOUPDATER + DISABLE_UPDATES) 본문 안 명시 유지 (해제 X · STOP 조건 정합) · 능동 갱신 = 사용자 자율 영역 명시 박음 (default 주 1회 권장) · self-test 3 항목 매 cycle 진입 의무 박음 (FAIL 시 직전 known-working = 현 시점 2.1.121 복귀 절차 + CLAUDE-CODE-LATEST-CHASE-001 entry append 의무).
- trail: 2 종 갱신 — (a) close `CLAUDE-CODE-VERSION-PIN-2.1.114-001` (본 cycle 마감으로 pin 폐기 정책 채택 + #51736 회귀 해소 실측 + 4-repo propagation 마감 영역 모두 close) (b) open 신설 `CLAUDE-CODE-LATEST-CHASE-001` (회귀 누적 영역 · 현 시점 known-working = 2.1.121 · 새 회귀 발견 시 entry append + known-working 갱신 + 별 cycle 진입). 동족 사고 영역 = baseline anchor mismatch 5 누적 (COWORK-PREP-BASELINE-MISMATCH-001~004 + 본 cycle 자식 3-repo HEAD drift 발견 후 사용자 A 채택 baseline 갱신 진행 = 5회차) → mitigation 강화 cycle 진입 권장 (별 cycle MASTER-COWORK-HANDOFF-BASELINE-AUTOVERIFY-HOOK-001 후보).
```
