# Scripts — claude-cli-master 자동화 도구

> C3 cycle 에서 신설 예정. 현 상태 = 빈 seed.

## 예정 script (4 종) + slash command (1 종)

### 1. `propagate.sh` — master → 자식 repo 단방향 cp

```bash
# 단일 파일
bash scripts/propagate.sh .claude/rules/workflow.md --targets GB,GD,GT

# 다중 파일
bash scripts/propagate.sh .claude/rules/workflow.md .claude/settings.json --targets all

# 전 cli infra 일괄
bash scripts/propagate.sh --all
```

기능:
- master 파일 sha 계산
- 각 자식 repo path 해결 (`<PARENT>/GentlyBreath` 등 placeholder 변환)
- cp + 자식 repo 안 git stage
- cross-verify (자식 sha = master sha 확인)
- 결과 stdout 출력

### 2. `verify-sync.sh` — 3-repo cli infra 동기 검증

```bash
bash scripts/verify-sync.sh
```

기능:
- master `.claude/` 60 파일 sha 계산
- 각 자식 repo 의 동일 path sha 비교
- `.auto-memory/propagation-status.md` 자동 갱신
- DRIFT 발견 시 stderr 경고 + exit 1 (자동화 pipeline 차단)
- 모두 PASS 시 exit 0 + silent

### 3. `report-gen.sh` — propagation 보고서 자동 생성

```bash
bash scripts/report-gen.sh <cycle-id>
```

기능:
- `propagation-reports/<cycle-id>/` 폴더 신설
- REPORT.md / DIFF.md / VERIFY.md 자동 생성
- master commit log + 자식 repo commit log 인용
- `verify-sync.sh` 출력 첨부

### 4. `activate-agent.sh` — agent 활성/비활성 toggle

```bash
bash scripts/activate-agent.sh activate billing-payments-guardian
bash scripts/activate-agent.sh deactivate billing-payments-guardian
```

기능:
- `.claude/agents/deferred/<name>.md` ↔ `.claude/agents/active/<name>.md` mv
- `.claude/rules/routing-and-delegation.md` 의 `[DEFERRED]` 라벨 toggle
- `.claude/rules/deferred-domains.md` 의 "현재 상태" 표 갱신
- propagation 호출 (3-repo 동기)

### 5. `/cycle-report` slash command (`.claude/commands/cycle-report.md`)

```
/cycle-report propagate <file>            # propagate + verify-sync + report-gen 자동
/cycle-report status                      # 현 propagation-status 출력
/cycle-report drift                       # drift 만 표시
```

기능:
- 위 4 script 의 묶음 자동 실행 + Coin 검증 한 줄 묻기
- 결과를 자식 repo 의 `.ai/reports/PROPAGATE-<cycle-id>/` 에도 mirror

## 5. `git-safe.sh` — git wrapper (PID 기반 stale lock 자동 정리 · C9 신설)

```bash
bash scripts/git-safe.sh <any git args>
# 예:
bash scripts/git-safe.sh add -A
bash scripts/git-safe.sh commit -m "..."
```

**Coin 환경 alias 권장** (~/.zshrc 박음):
```bash
alias git='bash ~/AndroidStudioProjects/claude-cli-master/scripts/git-safe.sh'
```

→ Coin 의 macOS 터미널 / IDE / Cowork chat 에서 git 호출 시 자동 stale lock 정리 + git 실행.

작동:
1. `.git/index.lock` 안 PID 검증 (살아있음 = 보호 / 죽음 = 즉시 rm)
2. PID 박힘 X = mtime 5s 보조 (`STALE_THRESHOLD_S` env override)
3. 정리 후 git command 정상 실행

verbose 로그: `GIT_SAFE_VERBOSE=1 bash scripts/git-safe.sh ...`

## 6. `git-lock-daemon.sh` + launchd plist — 환경 무관 영구 mitigation (C10 신설 · 권장 최강)

**최강 mitigation**: macOS launchd 백그라운드 데몬 = 환경 (Cowork / IDE / 터미널 / sandbox / 기타 모든 도구) 무관 5초마다 자동 git lock 정리.

### Coin 설치 (1회만)

```bash
bash ~/AndroidStudioProjects/claude-cli-master/scripts/install-git-lock-daemon.sh
```

→ `~/Library/LaunchAgents/com.coin.git-lock-cleaner.plist` 신설 + launchctl load + 활성 검증.

### 작동 (자동 · Coin 손 작업 0)

- 5초마다 `~/AndroidStudioProjects/*/.git/index.lock` 검사
- PID 검증: 죽음 = 즉시 rm / 살아있음 = 보호
- PID 박힘 X = mtime 3s 마진
- 정리 로그: `~/Library/Logs/git-lock-daemon.log`

### 제거 (필요 시)

```bash
launchctl unload ~/Library/LaunchAgents/com.coin.git-lock-cleaner.plist
rm ~/Library/LaunchAgents/com.coin.git-lock-cleaner.plist
```

### 이전 mitigation 와 관계

| layer | 환경 | C10 후 역할 |
|---|---|---|
| C8 hook (pre-tool-use / session-start) | Claude Code Bash tool | **백업** (daemon 이 5초 내 처리 안 한 경우) |
| C9 git-safe.sh wrapper | Coin alias 박힌 환경 | **백업** (daemon 안 깔린 환경 fallback) |
| **C10 launchd 데몬** | **모든 macOS 환경** | **주력 mitigation** |

C10 적용 후 = 99.99% 자동 (daemon 죽거나 macOS 외 환경 만 미적용).

## 기본 환경 변수

| 변수 | default | 의미 |
|---|---|---|
| `PARENT_DIR` | `~/AndroidStudioProjects` | 부모 폴더 (자식 repo 들이 있는 곳) |
| `MASTER_DIR` | `$PARENT_DIR/claude-cli-master` | master repo |
| `TARGET_REPOS` | `GentlyBreath GentlyDay GentlyTable` | 자식 repo 명단 (env 로 override) |

## 신규 자식 repo 추가 절차

1. `<PARENT>/<NewRepo>/` 신설 (Android Compose 단일 모듈)
2. `claude-cli-master/CLAUDE.md` §1 표에 행 추가
3. `claude-cli-master/.auto-memory/propagation-status.md` 표에 행 추가
4. `TARGET_REPOS` env 에 추가
5. `bash scripts/propagate.sh --all --targets <NewRepo>` 호출 → 첫 propagation
6. `<NewRepo>/CLAUDE.md` 작성 (master CLAUDE.md 의 자식 패턴 참조)
7. cycle 마감
