# Propagation Parameters

> **Source of Truth** for repo-specific environment variables and placeholder tokens used by ops-layer assets to support multi-repo propagation without source-side edits.
>
> Authority: `claude-cli-master`. Other repos consume this file as read-only spec.
> Created by: SW-OPS-PARAM-001
> Revised by: SW-OPS-PARAM-002 (per-repo `scripts/repo-config.sh` 외부화)

---

## 1. 목적

운영 자산(구 `scripts/agent/compound-lint.sh`(deprecated · 도구 부재 · MASTER-CLI-COMPOUND-LINT-DEPRECATE-001), `.claude/agents/active/layer-checker.md`, `docs/rules/domain-roles.md`, `.claude/commands/{check-layer,uiux-refresh}.md`, `docs/rules/uiux-sot-refresh.md`) 은 generic 하다 — 어떤 repo 에도 byte-identical 로 propagation 가능하다. (= domain-roles.md = MASTER-CLI-CLEANUP-7CYCLE-001 S3 안 `.claude/agents/active/` → `.claude/rules/` 이동 마감)

repo 고유 값(패키지/경로/파일명/이름) 은 각 repo 가 자체 `scripts/repo-config.sh` 에서 export 한다.
운영 스크립트는 실행 시점에 `repo-config.sh` 를 source 해 env var 를 로드한다.

이 디자인은 두 invariant 를 동시에 충족한다:
- **runtime 0-sed**: source → target propagation 시 string replacement 가 0 회 (byte-identical 복사)
- **0 repo-specific residue at targets**: source 자산에 특정 repo 의 패키지/경로 default 가 잔존하지 않음 — target propagation 후 source repo(= `claude-cli-master`) 식별자 0 hit

이전 디자인 (SW-OPS-PARAM-001) 은 env var fallback default 를 SteadyWell 값으로 두어 backward compatibility 를 확보했으나, multi-repo extension 시점(SW-OPS-REPROP-001 dry-verify) 에서 두 invariant 의 양립 불가가 surface 됐다. 본 revision 이 그 conflict 를 해소한다.

---

## 2. repo-config.sh 인터페이스

각 repo 는 `scripts/repo-config.sh` 를 소유하며 아래 변수를 export 한다.

### Repo identity (필수)

| 변수 | 의미 | 예시 |
|---|---|---|
| `REPO_NAME` | display name | `Selfward` / `app-foundation` / `toward-product-docs` |
| `REPO_PREFIX` | task ID prefix | `SW` / `FND` / `PDOCS` |

### 패키지 (필수)

`REPO_APP_PKG`, `REPO_DOMAIN_PKG` = I2 검사 소비자(layer-checker / check-layer)의 필수 입력이다 (구 compound-lint.sh FATAL(exit 2) 게이트 = deprecated · 도구 부재).

| 변수 | 의미 | 사용처 |
|---|---|---|
| `REPO_APP_PKG` | repo root Kotlin package | I2 regex 동적 조립 (shared.(app\|feature) 검사) |
| `REPO_DOMAIN_PKG` | shared domain layer package | I2 documentation + stdout echo |
| `REPO_DATA_PKG` | shared data layer package | I2 documentation 주석 |

### KMP shared 경로 (옵션 — 빈 값 허용)

| 변수 | 의미 |
|---|---|
| `REPO_SHARED_DOMAIN_PATH` | shared domain commonMain Kotlin source root |
| `REPO_SHARED_DATA_PATH` | shared data commonMain Kotlin source root (빈 값이면 [I2-data] skip) |

### 앱 진입점 / UI/UX SoT refresh read order 대상 (옵션 — 빈 값 허용)

| 변수 | 의미 |
|---|---|
| `REPO_APP_ROOT_COMPOSABLE` | Android app root composable file |
| `REPO_APP_ROOT_STATE` | Android app state holder file |
| `REPO_APP_ROUTES` | navigation route SoT file |
| `REPO_IOS_SHELL_VIEW` | iOS root shell view file (KMP/iOS 미도입 repo 는 빈 문자열) |
| `REPO_IOS_APP_CONTAINER` | iOS app container file (KMP/iOS 미도입 repo 는 빈 문자열) |

### 원칙

- **default 값은 repo-config.sh 가 소유**, source 자산은 placeholder 만 사용
- repo-config.sh 는 값 export 전용 — 로직/검증 금지
- 빈 값 허용 (해당 검사/read order 단계는 skip)
- ~~regex escape 는 compound-lint.sh 가 자동 처리~~ (deprecated · 도구 부재 — 현 소비자 layer-checker 는 rg 인용 직접 처리)

---

## 3. Placeholder 토큰 (uiux-refresh.md + uiux-sot-refresh.md)

source 문서에는 placeholder 토큰만 사용하며 default 값을 명시하지 않는다.
각 토큰은 해당 repo 의 `scripts/repo-config.sh` 변수로 매핑된다.

| 토큰 | repo-config 변수 | 의미 |
|---|---|---|
| `<APP_PKG>` | `$REPO_APP_PKG` | repo root Kotlin package |
| `<APP_ROUTES>` | `$REPO_APP_ROUTES` | navigation route SoT |
| `<APP_ROOT_COMPOSABLE>` | `$REPO_APP_ROOT_COMPOSABLE` | Android app root composable |
| `<APP_ROOT_STATE>` | `$REPO_APP_ROOT_STATE` | Android app state holder |
| `<IOS_SHELL_VIEW>` | `$REPO_IOS_SHELL_VIEW` | iOS root shell view (옵션) |
| `<IOS_APP_CONTAINER>` | `$REPO_IOS_APP_CONTAINER` | iOS app container (옵션) |

**해석 규칙**: 토큰은 source 파일에서 텍스트 그대로 유지된다. read order 적용 시점에 각 repo 가 자기 `repo-config.sh` 값으로 해석한다 — sed 치환 불필요.

---

## 4. 재 propagation 절차

### Step 1 — source-side
운영 자산(이 문서가 가리키는 7개 generic file) 을 generic 한 상태로 유지한다.
repo-specific default 가 잔존하지 않아야 한다.
repo-specific 섹션은 `<!-- propagation: repo-only -->` 마커로 격리한다.

### Step 2 — target-side propagation
1. generic 자산 7개를 source → target 으로 byte-identical 복사 (sed/치환 금지)
2. `<!-- propagation: repo-only -->` 마커 블록은 propagation 시 제외
3. 각 target 은 자체 `scripts/repo-config.sh` 를 소유 — propagation 대상이 아님

### Step 3 — target 에 repo-config.sh 신설/유지
target repo 는 자체 `scripts/repo-config.sh` 를 만들거나 유지한다.
이 파일은 repo 고유 — 다른 repo 에서 copy 받지 않는다.

### Step 4 — uiux-refresh.md placeholder 해석
target repo 는 `.claude/commands/uiux-refresh.md` 의 placeholder 토큰을 자기 `repo-config.sh` 값으로 매핑해 read order 를 적용한다. 파일 자체는 수정하지 않는다.

---

## 5. 회귀 보장

각 repo 의 `repo-config.sh` 가 정확한 값을 export 하면 운영 스크립트는 그 repo 의 baseline 결과를 재현한다.

검증 (구 compound-lint stdout 검증 = deprecated · 도구 부재): repo-config 값 정합은 실존 소비자 실행 시점에 확인한다 — `layer-checker` agent §Evidence to gather 의 직접 source + `rg` 실행이 실존 수단.

`repo-config.sh` 부재/변수 미설정 시 소비자(layer-checker 등)는 UNKNOWN(경로 없음) 기록 — 운영 스크립트 무력화 방지 (구 compound-lint.sh FATAL(exit 2) 게이트 = deprecated).

---

## 7. 관련 task

| TaskId | 역할 |
|---|---|
| SW-OPS-PROP-001 | 첫 propagation, 본 generic-ization 의 출처 IMPROVEMENTS.md 작성 |
| GD/GB/GT-OPS-002 | 각 target 의 cleanup pass — `(future) propagation source 측 generic-ization 권장` 합의 |
| SW-OPS-PARAM-001 | env var 외부화 + placeholder 도입 (default = SteadyWell, 1차 디자인) |
| SW-OPS-REPROP-001 | multi-repo dry-verify — 1차 디자인의 multi-repo invariant 충돌 surface |
| SW-OPS-PARAM-002 | per-repo `repo-config.sh` 외부화 — 두 invariant 동시 충족 (본 revision) |
| GD/GB/GT-OPS-004 | 각 target 의 `repo-config.sh` 신설 + generic 자산 재수신 |
