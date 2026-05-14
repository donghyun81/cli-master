# PLAN — MASTER-NIGHTLY-BASELINE-CRON-001

## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-NIGHTLY-BASELINE-CRON-001 |
| Mode | ops-layer (cli infra 운영 자동화 신설) |
| Workflow | intake → collect → plan → implement → verify → review |
| Requirements Source | 본 chat prompt (자체 완결) |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 8 신설 (scripts 3 + .ai/reports 5) + 출력 dir 1 (`.ai/nightly-baseline/`) |
| Modules | scripts/ + .ai/reports/ + .ai/nightly-baseline/ |
| Risk | Low (단일 repo · ops-layer · 보호 파일 무접촉 · 자식 repo read-only · 비가역 변경 없음) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A (외부 의존 추가 없음 · 모두 master repo 안 기존 도구 + macOS 기본 binary + 기존 `claude` CLI 재사용)

## 3. ArchitectureImpact

N/A (새 인터페이스·추상화 없음 · 기존 scripts/ 패턴 그대로 차용)

## 4. ModelBoundaryPlan

N/A (모델 레이어 무관)

## 5. ErrorPolicy

N/A (새 UseCase/Repository 없음. shell script error path 는 `set -uo pipefail` + 측정 실패 시 stderr + exit code 보존)

## 6. UIStateFlowPlan

N/A (UI 무관)

## 7. TestabilitySeams

N/A (shell script + launchd plist · 표준 patterns 차용)

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/nightly-baseline-report.sh` (1 회 강제 실행 + 출력 file 생성 검증) + `for r in claude-cli-master GentlyBreath GentlyDay GentlyTable app-foundation; do git -C "$HOME/AndroidStudioProjects/$r" status --short; done` (READ-ONLY 무변동 검증 · diff 0 의무) + `bash scripts/verify-sync.sh --no-update` (본 cycle 산출물 추가 후 기존 검증 회귀 0 확인) |

## 9. RollbackStrategy

- 롤백 가능 지점: 본 cycle 의 commit 직전 sha (실측 박힘 — VERIFY.md 안 명시)
- 롤백 조건: self-test FAIL · 5-repo READ-ONLY 검증 FAIL · verify-sync 회귀 발견
- 복구 경로: `git revert <cycle-commit>` (산출물 8 file 모두 revert 단일 commit) · launchctl 등재 안 됐으므로 시스템 변경 영향 0

## 10. ExternalPrep / DeferredItems

- 외부 의존: Coin 손 작업 1 회 = `bash scripts/install-nightly-baseline-report.sh` 실행 (plist install + launchctl load + sleep 검증 자동) · 본 cycle 마감 시 보고에 1 줄 인용
- Deferred: 6/15 이후 `claude -p` Agent SDK 크레딧 차감 영역 — 본 잡 1 회 호출 / 야간 1 회 / `--max-budget-usd 0.50` cap → 월 ~15 USD 미만 예상 · 별 cycle 측정 후보

## Plan

1. **scripts/nightly-baseline-report.sh** (야간 잡 본체):
   - 절대경로 setup (PARENT_DIR/MASTER_DIR/CLAUDE_BIN nvm path resolve · 잡 시작 시 `command -v claude` + fallback list patterns)
   - 측정 단계 (bash):
     - 5-repo HEAD sha (full 64자)
     - 보호 파일 5 종 × 5-repo sha matrix (drift 식별)
     - cli infra drift = `verify-sync.sh --no-update` 캡처 (exit code + PASS/DRIFT/MISS count 파싱)
     - 진행 중 cycle 미완 항목 = `ls -lt .ai/reports/ | head -10` + 각 dir 의 REVIEW.md Verdict / TODO.md 잔존 항목 1줄 (read-only 캡처)
     - 5-repo 측 최근 commit 5건 (`git log --oneline -5`)
   - 종합 단계 (claude -p 1 회 호출):
     - `$CLAUDE_BIN -p --bare --tools "" --no-session-persistence --output-format text --max-budget-usd 0.50 --append-system-prompt "<formatter persona>" "$PROMPT"`
     - prompt 본문 = 측정 결과 raw + §D/§20 컨텍스트 (본 작업 정의 1 단락 + repo 도메인 표 + 진행 중 cycle 미완 항목) + markdown layout 의무
     - 출력 redirect → `.ai/nightly-baseline/<date>.md.tmp`
   - 마감 단계: tmp → `<date>.md` + `latest.md` 갱신 + nightly.log 한 줄 append (timestamp + exit code)
2. **scripts/com.coin.nightly-baseline-report.plist** (launchd plist):
   - Label = `com.coin.nightly-baseline-report`
   - ProgramArguments = `/bin/bash -c "PATH=/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$HOME/.nvm/versions/node/v22.21.1/bin:$PATH; $HOME/AndroidStudioProjects/claude-cli-master/scripts/nightly-baseline-report.sh"`
   - StartCalendarInterval Hour=4 Minute=0 (working-file-archiver 03:00 + 1 시간 시차)
   - StandardOutPath + StandardErrorPath = `~/Library/Logs/nightly-baseline-report.{log,err}`
   - RunAtLoad=false (시스템 부팅 시 자동 발화 X · 04:00 일정만)
   - `{{HOME}}` placeholder (install script 안 sed 치환)
3. **scripts/install-nightly-baseline-report.sh** (Coin 손 작업 1 줄):
   - plist src → `~/Library/LaunchAgents/com.coin.nightly-baseline-report.plist` sed HOME 치환 cp
   - 기존 등재 시 unload → load
   - sleep 6 + `launchctl list | grep com.coin.nightly-baseline-report` 검증
   - self-test 1 회: `launchctl kickstart -k gui/$(id -u)/com.coin.nightly-baseline-report` (= 즉시 1 회 강제 실행 · 출력 file 생성 확인)
4. **.ai/nightly-baseline/** 출력 dir (`.gitkeep` 신설 · cycle 마감 후 `<date>.md` + `latest.md` + `nightly.log` 누적)
5. **self-test 절차** (CLI 자체 수행):
   - `bash scripts/nightly-baseline-report.sh` 1 회 직접 호출 (launchd 환경 모사: `env -i PATH=/usr/bin:/bin HOME="$HOME" bash ...` 도 검증)
   - 출력 file `.ai/nightly-baseline/<today>.md` + `latest.md` 생성 확인
   - 5-repo git status 무변동 확인 (= READ-ONLY 의무 검증)
   - verify-sync.sh `--no-update` 회귀 0 확인
6. **VERIFY.md / REVIEW.md / TODO.md** 작성 + commit (`chore(infra): MASTER-NIGHTLY-BASELINE-CRON-001 ...` · §5 v2 자동 허용 카테고리 = infra/discipline)

## Notes

- 본 cycle 의 산출물 commit = `cycle-discipline.md` §5 v2 자동 허용 카테고리 (chore/infra/discipline) 정합. Coin 명시 승인 불필요.
- text-degeneration 정책 (`text-degeneration-prevention.md` §3 metric M1/M2) 적용 — 보고서 본문·script 안 동일 token 3+/문장 5+/문단 회피.
- no-abbreviation 정책 (`no-abbreviation-policy.md` §1) 적용 — shell script 안 `cfg`/`tmp`/`err`/`msg`/`util` 등 사용자 정의 축약 회피.
- READ-ONLY 의무 — 본 잡 자신의 출력 file (`.ai/nightly-baseline/`) 외 어느 경로도 쓰기 X · 보호 파일 sha 무변동 · 자식 repo git status diff 0.
