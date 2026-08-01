# Safety and Secrets Rules

> 보안, 시크릿, 위험 명령에 관한 규칙.
> SOT: `CLAUDE.md`

---

## 절대 금지 명령

다음 명령은 `.claude/settings.json` deny 목록으로 차단된다 (Claude Code 세션):

> **enforcement 경계**: 아래 명령 차단은 `.claude/settings.json` deny list가 1차 담당한다.
> `pre-tool-use.sh` 훅은 `/tmp` 경로 차단을 별도 담당하며 아래 명령을 재차단하지 않는다.

| 명령 | 이유 |
|---|---|
| `curl`, `wget` | 외부 네트워크 접근 금지 |
| `sudo` | 권한 상승 금지 |
| `rm` | 비가역 삭제 금지 |
| `git push` | 원격 전송 금지 (Coin 소관) |
| `git reset` | 비가역 상태 변경 금지 |
| `git clean` | 추적 외 파일 삭제 금지 |
| `git rebase` | 이력 재작성 금지 (Coin 소관) |
| `git filter-branch` | 이력 파괴 재작성 금지 (Coin 소관) |

> **`git commit` / git log = cli 소관 (§5 v3 위임 · deny 아님)**: `docs/rules/cycle-discipline.md §5 git 역할 경계 정책 (v3)` 우선 — commit + git log 위생 = cli 가 cycle 마감 step 에서 수행(전 카테고리 · 영구). 본 표 = **push + 파괴 연산(reset / clean / rebase / filter-branch) 응급 백스탑 한정**. `git push` + 고위험 git(`--amend` / `--force` / `reflog expire` 등 · deny 패턴 불가분) = Coin 소관(승인+실행) · cli 실행 절대 X · 필요 시 STOP + Coin 회수. (v2 한시 허가 → v3 영구 정정 = 2026-07-15 · `settings.json` `Bash(git:*)` allow 실측 + 실운영 정합)

---

## 금지 경로

| 경로 | 이유 |
|---|---|
| `/tmp/*`, `$TMPDIR/*` | tmpdir 계열 사용 금지 |
| `~/.ssh/*`, `~/.gnupg/*` | 시스템 시크릿 접근 금지 |

---

## 역할별 경로 허용 매트릭스

> 선언적 정책. 현재는 agent가 자율 준수하며, 향후 Managed Agents API 전환 시
> scoped permissions enforcement로 연결될 수 있다.
> enforcement 수준: 규칙 기반 (reviewer가 REVIEW.md 섹션 4 Layer Boundaries에서 검증)
> 현재 구조: 단일 app/ 모듈 (KMP 미도입). 향후 모듈 확장 시 매트릭스 갱신 필요.

### 현재 경로 (단일 app/ 모듈)

| 역할 (write 허용) | 허용 경로 | 금지 경로 | 근거 |
|---|---|---|---|
| ui-implementer | `app/src/main/java/**`, `app/src/main/res/**` | ops-layer (`.claude/`, `scripts/`, `docs/`, `.ai/`) | 제품 코드 전용 |
| docs-change-communicator | `docs/**`, `.ai/uiux-sot/**` | `app/**` | DocSync 전용 |
| code-simplifier | 현재 task 변경 경로와 동일 모듈 | 변경 경로 밖 모듈 | cleanup pass 범위 제한 |

### [DEFERRED] KMP 도입 후 추가 예정 경로

| 역할 (write 허용) | 허용 경로 | 금지 경로 | 조건 |
|---|---|---|---|
| ui-implementer | `shared/feature-state/**` (추가) | `shared/domain/**` (read-only) | KMP 도입 후 |
| server-implementer | `server/**` | `app/**`, `shared/**`, `iosApp/**` | server/ 생성 후 |

> server-implementer는 에이전트 파일이 존재하나 현재 대상 경로가 없다.
> server/ 디렉터리 생성 시 이 매트릭스를 갱신하고 [DEFERRED] 태그를 해제한다.
> KMP/CMP 도입 시 `claude-cli-master` SoT에서 관련 경로 매트릭스를 재propagation한다.

read-only 역할(ux-auditor, backend-api-architect 등)은 Write/Edit 권한이 없으므로 매트릭스 대상이 아니다.

위반 감지 시:
- reviewer가 REVIEW.md "### 4. Architecture Integrity — Layer Boundaries"에서 경로 위반 확인
- 위반 발견 시 FAIL (블로커)

---

## 시크릿 기록 금지 규칙

**절대로 파일에 기록하지 않는 것:**
- API 키, 토큰 (ANTHROPIC_API_KEY, OPENAI_API_KEY 등 값)
- 백엔드 서비스 계정 키 내용 (Firebase, Supabase 등)
- 인증서 비밀 키 내용
- PII (이름, 이메일, 전화번호 등 실제 값)

**허용되는 것:**
- 변수명: `ANTHROPIC_API_KEY`
- 주입 경로: "환경변수로 주입", `.env` 파일 경로
- 구조: "값은 서버 Secret Manager에 저장" (Supabase Vault, 환경변수 등)

---

## macOS Keychain 측 secret 보관 paradigm

> **신설**: 2026-05-18 · `MASTER-CLI-SUPABASE-COMPREHENSIVE-001` · macOS native Keychain 측 secret 보관 + wrap script 측 추출 paradigm 단일 진실 영역.
> **연관**: `docs/rules/supabase-handling.md` §10.5 (= MCP server 측 Keychain reference) + `~/bin/claude-wrap.sh` (= 본 paradigm 측 진입점).

### 등록 paradigm (= 사용자 manual 진입 영역)

token 측 macOS Keychain 측 보관 영역. cli session 측 진입 차단 영역 (= token 평문 본문 측 cli session 측 inject 차단 의무).

```bash
security add-generic-password -a "$USER" -s <slot-name> -w
# -w flag = hidden prompt · token 측 stdout 노출 차단
```

slot 명세 (= 2026-07-29 `MASTER-CLI-STALE-SWEEP-4ACTIVE-001` 실측 현행화 · 구 판 = GB/GD/GT 3 slot 한정 `MASTER-CLI-SUPABASE-COMPREHENSIVE-001` baseline):
- `supabase-selfward-token` (= **활성** 도메인 자식 Selfward 측 PAT · staging+prod 단일 계정) → `SUPABASE_ACCESS_TOKEN_SELFWARD` → `.mcp.json` `supabase-selfward` (= **staging ref 단독 · `read_only=true`** · 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 등록 · Coin 본심 ④). **prod ref 등록 = STOP** (= 구조적 격리 · staging/prod 별 project).
- `supabase-gb-token` / `supabase-gd-token` / `supabase-gt-token` (= 동결 3 측 PAT · Keychain **잔존** · **`.mcp.json` 등록 = 2026-07-29 해제** → 현재 미소비 · wrap 은 계속 주입[warn+skip 정합]). 동결 repo 재조회 필요 시 = `.mcp.json` 재등록이 아니라 **Coin 회수** (= 동결 = 쓰기 0 · 읽기도 상시 배선 대상 아님).

**miss 정책** (= `~/bin/claude-wrap.sh` 정합 · 2026-07-29 정정): slot miss = **warn + skip · `claude` 기동 계속**. 구 판 fail-fast(`exit 1`)는 동결 slot 정리 시점에 `claude` 자체를 기동 불능으로 만들었다 (= 동결 3 slot 은 read_only MCP 편의 수단이지 기동 전제가 아님).

### 추출 paradigm (= wrap script 측 진입 영역)

`~/bin/claude-wrap.sh` 측 warn+skip paradigm:

```bash
inject_token() {
  local slot="$1" var="$2" val=""
  val="$(security find-generic-password -s "$slot" -a "$USER" -w 2>/dev/null)" || {
    echo "claude-wrap.sh: Keychain miss: $slot — skip" >&2   # 값 미출력 · 기동 계속
    return 0
  }
  export "$var=$val"
}
```

**bash semantics fact** (= 값 capture paradigm 정합 의무):
- `export VAR="$(failing)"` 측 exit code = 0 default (= `export` builtin 측 `$()` exit code propagate X)
- → local assignment + export 분리 paradigm 의무 (= 위 본문 정합)

### Keychain trust dialog paradigm

첫 access 시점 macOS Keychain 측 trust dialog 활성 영역. 사용자 본인 측 **"Always Allow"** 클릭 권장 (= 후속 access 측 자동 PASS default).

### 평문 차단 의무

본 paradigm 측 token 평문 commit / file 기록 차단 (= 기존 §시크릿 기록 금지 규칙 정합):
- `.mcp.json` 측 `${SUPABASE_ACCESS_TOKEN_<자식>}` env interpolation 정합 (= 평문 token 본문 X)
- wrap script 측 subshell `$()` capture + 변수 미echo (= stdout / stderr 노출 차단)
- commit log 측 `eyJ` (= JWT prefix) / `sbp_` (= Supabase PAT prefix) 평문 0 match 의무 (= §시크릿 스캔 패턴 grep 정합)
- **★검증 harness 자체가 노출 경로다** (= 2026-07-29 `MASTER-CLI-STALE-SWEEP-4ACTIVE-001` 실사고): secret 주입 script 를 dry-run / 진단할 때 **값이 아니라 존재 여부만** 출력한다. `${v:+SET}` / `${#v}` 는 안전하나 `${v:-UNSET}` 은 **값이 있으면 값을 출력한다** (= 그 사고의 정확한 기전 · 마스킹 의도가 정반대로 작동). 안전형 = `[ -n "$v" ] && echo SET || echo UNSET`. 노출 시 = 파일 기록 여부 전수 확인 + **해당 토큰 rotation 회수**(Coin 몫) 보고 의무 — 노출은 transcript 한정이어도 회수 대상이다.

---

## 시크릿 스캔 패턴

시크릿 grep 스캔 (= `grep -rE` 직접 실행 · 구 compound-lint 도구 = deprecated · 4-repo 부재 · MASTER-CLI-COMPOUND-LINT-DEPRECATE-001) 이 다음 패턴을 검사한다:

```
AKIA[0-9A-Z]{16}          # AWS Access Key
sk-[a-zA-Z0-9]{32,}       # OpenAI API Key
ghp_[a-zA-Z0-9]{36}       # GitHub Personal Access Token
xox[baprs]-[0-9a-zA-Z-]+  # Slack Token
ya29\.[a-zA-Z0-9._-]+     # Google OAuth Token
AIza[0-9A-Za-z\-_]{35}    # Google API Key
```

보고서 디렉터리(`.ai/reports/`)에서 위 패턴이 발견되면 즉시 삭제 또는 마스킹.

> ⚠ **스캔 범위 제한**: 시크릿 grep 스캔은 `.ai/reports/<taskId>/` 아래만 검사한다.
> product code / app source / server code 전체 스캔이 아니다.
> product code 내 시크릿은 별도 수동 확인이 필요하다.
> product code 확장 스캔 = 위 패턴 `grep -rE` 의 대상 경로(`app/`, `shared/`, `iosApp/`)를 직접 지정해 warn-only 로 수행 (구 COMPOUND_LINT_PRODUCT_SCAN=1 환경변수 스위치 = deprecated · 도구 부재).

---

## 알려진 시크릿 위치 (레포 기준)

| 항목 | 위치 | 주입 방식 |
|---|---|---|
| OPENAI_API_KEY | [LEGACY] `server/firebase-functions/` 참조 — 현재 레포에 부재 | 환경변수 (값 기록 금지) |
| ANTHROPIC_API_KEY | 레포 내 미발견 (UNKNOWN) | — |
| [CURRENT] Firebase 설정 | `google-services.json`, `GoogleService-Info.plist` | .gitignore로 제외 (현재 사실) |
| Keystore | `*.keystore`, `*.jks` | .gitignore로 제외 |

---

## 비가역 변경 STOP 정책

> **본 § = pointer 영역 default**. 본문 단일 SoT = [`stop-canonical.md`](./stop-canonical.md) (= 9 STOP 항 default · 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 로 master `CLAUDE.md §5` 에서 이동 · 구 canonical cycle = `MASTER-CLI-CYCLE-1-STOP-CANONICAL-INTEGRATION-001`). 본 § 본문 변경 시 = master cycle 신설 + 4-repo propagation 의무 default.

---

## macOS bash3 호환성

훅 스크립트는 macOS bash 3.x 호환으로 작성:
- `#!/bin/bash` 사용 (`#!/usr/bin/env bash` 금지 아님, 둘 다 가능)
- `declare -A` (연관배열) 사용 금지 (bash 4+ 전용)
- `${!var}` 간접 참조 최소화
- `[[ ... ]]` 사용 가능 (bash 3.2+)

---

## git commit 측 stage 정합 paradigm (= 2026-05-21 신설 · pointer)

> **본 § = pointer 영역 default**. 본문 단일 SoT = [`cycle-discipline.md` §22](../../docs/rules/cycle-discipline.md) (= `MASTER-CLI-GIT-MV-SED-STAGE-PARADIGM-CHECK-001` 마감 default). 본 § = 안내 + trigger 영역 단일 default · 보호 영역 본질 X default.

`git mv` 측 rename 호출 후 동족 file 측 sed content 정정 영역 측 stage 누락 사고 mitigation. post-rename `git add -u` 의무 paradigm 정합 의무 default. GB+GD 동족 사고 baseline default (= GT 측 자율 회피 default).

본 paradigm trigger 영역 default:

- `git commit` 호출 시점 = pre-commit hook (= `.claude/hooks/pre-commit-stage-check.sh`) 측 stage 영역 측 rename + working tree 측 unstaged 영역 측정 default
- 발화 시점 = stderr 측 warn 출력 default + post-rename `git add -u` 의무 paradigm 안내 default
- mode = warn default (= exit 0 · non-blocking default · enforce mode 별 cycle default)

상세 paradigm step + STOP 조건 = `cycle-discipline.md` §22 단일 SoT default. 본 § 본문 변경 시 = master cycle 신설 + 4-repo propagation 의무 default (= `cycle-discipline.md` §15 패턴 1 정합).
