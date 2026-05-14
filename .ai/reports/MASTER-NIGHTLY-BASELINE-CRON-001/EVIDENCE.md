# EVIDENCE — MASTER-NIGHTLY-BASELINE-CRON-001

## Requirements Source

- 본 chat 안 Cowork prompt: "MASTER-NIGHTLY-BASELINE-CRON-001 — 매 Cowork chat 진입 시 수동으로 하던 §D/§20 baseline 조사(보호 파일 sha N-repo 정합 + cli infra drift + 진행 중 cycle 미완)를 야간 자동 잡으로 대체. 아침에 사람이 읽는 baseline 리포트 준비"
- Authority boundary = claude-cli-master 단일 repo scope. 자식 repo (GB/GD/GT/app-foundation) read-only.
- 보호 파일 5 종 + cli infra (`.claude/`) 무접촉 의무.

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (ops-layer · scripts + .ai 산출물) |
| Reading Mode | CLI 운영 레이어형 |
| Requirement Source | 본 chat prompt (자체 완결 · 추가 요구사항 출처 없음) |
| Info Gap | RESOLVABLE_IN_REPO (모든 baseline 도구·patterns 실측 확인됨) |
| STOP Risk | 없음 (제품 코드·보호 파일·자식 repo 무접촉) |
| Read-Only Fan-Out | N/A (단일 cycle · subagent 호출 없음) |
| Implementer Entry | Allowed (intake + pre-EVIDENCE 계약 마감 후) |

## Pre-EVIDENCE Contract

- Read evidence:
  - `scripts/verify-sync.sh` (8691 byte · 5-repo PROTECTED+CORE_CLI sha drift 검증 도구 · `--no-update` flag 지원)
  - `.claude/hooks/baseline-snapshot.sh` (7-repo HEAD + 보호 5 sha + cycle-discipline sha JSON 출력 · SessionStart hook)
  - `scripts/repo-config.sh` (PARENT_DIR/MASTER_DIR/TARGET_REPOS/PROTECTED_FILES SoT · `: "${VAR:=default}"` 환경 변수 override 지원)
  - `scripts/com.coin.git-lock-cleaner.plist` + `scripts/install-git-lock-daemon.sh` (StartInterval=5 + RunAtLoad + `{{HOME}}` 치환 + launchctl unload→load + sleep 6 검증)
  - `~/AndroidStudioProjects/scripts/com.coin.working-file-archiver.plist` (StartCalendarInterval Hour/Minute 패턴 + StandardOut/Err log path)
  - `claude --help` (flag spec: `-p` print + `--bare` (hook/LSP/skill skip + 자동 메모리 X) + `--tools ""` (모든 도구 비활성) + `--no-session-persistence` + `--output-format text` + `--max-budget-usd` cap + `--permission-mode plan` + `--exclude-dynamic-system-prompt-sections` prompt cache 재사용)
  - `claude` 절대경로 = `/Users/yundonghyeon/.nvm/versions/node/v22.21.1/bin/claude` (nvm path · 노드 버전 갱신 시 변동 가능 → 잡 안 runtime resolve 의무)
- Remaining gaps: none (모든 baseline 실측 확인 + 디자인 결정 사용자 측 4 축 명시됨).
- Chosen path: 하이브리드 (bash 측정 + claude -p 1 회 종합 호출 · §4 명시 그대로).
- Hold / Stop reasons: none.
- Implement entry conditions: PLAN.md 마감 → scripts 3 file + nightly-baseline 출력 dir + self-test 1 회 + READ-ONLY 검증 → VERIFY.md / REVIEW.md / TODO.md.

## Collect Results

### baseline 도구·patterns 매칭

- `scripts/verify-sync.sh:7` `--no-update` flag = 검증만 (propagation-status.md 갱신 X) — 본 cycle READ-ONLY 의무 정합 채택.
- `scripts/verify-sync.sh:213` `if [ "$NO_UPDATE" = 0 ] && [ "$QUICK" = 0 ]; then` → `--no-update` 명시 시 status file 갱신 skip 검증됨.
- `.claude/hooks/baseline-snapshot.sh:112-126` drift detection inline (cli-master cycle-discipline.md sha 와 자식 sha 비교) — 본 cycle 도 동일 inline patterns 차용 (외부 hook 재호출 X · 자체 측정).
- `scripts/repo-config.sh:32-38` PROTECTED_FILES 5 종 + TARGET_REPOS 4 자식 (GB/GD/GT/app-foundation) — 본 잡 안 동일 list source.
- `scripts/com.coin.git-lock-cleaner.plist:34-38` EnvironmentVariables dict + `{{HOME}}` 치환 patterns — 본 cycle plist 도 동일 patterns 차용.
- `scripts/install-git-lock-daemon.sh:30,40,44` sed HOME 치환 + launchctl unload→load + sleep 6 검증 — 본 cycle install 도 동일 구조 차용.
- `~/AndroidStudioProjects/scripts/com.coin.working-file-archiver.plist:13-19` StartCalendarInterval Hour=3 Minute=0 + RunAtLoad=false — 본 cycle 도 Hour=4 Minute=0 채택 (working-file-archiver 와 1 시간 시차 + 같은 시간대 동시 부하 회피).

### 0 matches (부재 증거)

- `grep -rn "nightly-baseline" .` master repo 안 = 0 matches (= 본 cycle 신규 영역).
- `~/Library/LaunchAgents/com.coin.nightly-baseline-report.plist` = 부재 확인 (Coin install 후 신설 예정).

## Key Findings

- 본 cycle scope = scripts/ 3 file + .ai/nightly-baseline/ output dir + .ai/reports 5 file 만. 보호 파일 / cli infra (.claude/) / 자식 repo 무접촉.
- claude binary path 는 nvm 안 nvm 환경. launchd 안 `/bin/bash -c` 호출 시 PATH 부재 → 잡 내부에서 `command -v claude` 우선 + fallback path resolve 의무 (`PATH=...:$HOME/.nvm/versions/node/*/bin` 광역 추가 패턴).
- 본 cycle 산출물 추가 후 verify-sync.sh 가 본 file 들 추적 영역 X (scripts/ 직속 신규 = CORE_CLI 명단 X · 전체 검증 `find` scope 도 `.claude docs scripts/agent .ai/promptfit .ai/uiux-sot/refresh .github` 한정).
- self-test 의무 = (1) launchctl 등재 확인 (= Coin install 단계), (2) 잡 1 회 강제 실행 (= CLI 직접 가능), (3) 출력 file 존재 검증, (4) 5-repo git status 무변동 검증 (READ-ONLY 확인).

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 무변경 · scripts/ + .ai/ 신설 영역만)
