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
| `git commit` | 코드 변경 자동 커밋 금지 |
| `git push` | 원격 전송 금지 |
| `git reset` | 비가역 상태 변경 금지 |
| `git clean` | 추적 외 파일 삭제 금지 |

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
> KMP/CMP 도입 시 SteadyWell SoT에서 관련 경로 매트릭스를 재propagation한다.

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

## 시크릿 스캔 패턴

compound-lint(`scripts/agent/compound-lint.sh`)가 다음을 검사한다:

```
AKIA[0-9A-Z]{16}          # AWS Access Key
sk-[a-zA-Z0-9]{32,}       # OpenAI API Key
ghp_[a-zA-Z0-9]{36}       # GitHub Personal Access Token
xox[baprs]-[0-9a-zA-Z-]+  # Slack Token
ya29\.[a-zA-Z0-9._-]+     # Google OAuth Token
AIza[0-9A-Za-z\-_]{35}    # Google API Key
```

보고서 디렉터리(`.ai/reports/`)에서 위 패턴이 발견되면 즉시 삭제 또는 마스킹.

> ⚠ **스캔 범위 제한**: compound-lint 시크릿 스캔은 `.ai/reports/<taskId>/` 아래만 검사한다.
> product code / app source / server code 전체 스캔이 아니다.
> product code 내 시크릿은 별도 수동 확인이 필요하다.
> `COMPOUND_LINT_PRODUCT_SCAN=1` 환경변수로 `app/`, `shared/`, `iosApp/` 대상 warn-only 스캔 활성화 가능 (기본 비활성, false positive 방지).

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

다음이 감지되면 즉시 STOP, 자동 수정 금지:

1. 파일 삭제 시도
2. DB 스키마 변경 (migration 포함)
3. 기존 파일의 대규모 override
4. Auth/결제 코드 변경

STOP 시 기록 항목:
- 감지된 변경 설명
- 영향 경로 (파일:라인)
- 사용자가 취해야 할 다음 행동

---

## macOS bash3 호환성

훅 스크립트는 macOS bash 3.x 호환으로 작성:
- `#!/bin/bash` 사용 (`#!/usr/bin/env bash` 금지 아님, 둘 다 가능)
- `declare -A` (연관배열) 사용 금지 (bash 4+ 전용)
- `${!var}` 간접 참조 최소화
- `[[ ... ]]` 사용 가능 (bash 3.2+)
