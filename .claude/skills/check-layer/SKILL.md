---
name: check-layer
description: Use to scan shared/domain ↔ shared/feature-state ↔ app layer import violations (read-only grep). Reports stdout only — creates no files. Invoke when refactoring shared modules or before /verify-all.
allowed-tools:
  - Bash
  - Grep
---

# check-layer

> Purpose: shared/domain ↔ shared/feature-state ↔ app 레이어 import 위반을 read-only 스캔하여 stdout 출력.

read-only 커맨드 — 파일 변경 없음. 위반 항목을 stdout 출력만 한다.

> **Repo 적용성**: 환경변수는 각 repo 의 `scripts/agent/repo-config.sh` 에서 export 한다.
> 환경변수: `REPO_DOMAIN_PKG`, `REPO_DATA_PKG`, `REPO_SHARED_DOMAIN_PATH`, `REPO_APP_PKG`
> 상세: `docs/agent/architecture/PROPAGATION_PARAMETERS.md`

## 환경변수 로드

각 repo 가 자체 `scripts/agent/repo-config.sh` 를 소유하며, 실행 전에 source 한다.

```bash
. scripts/agent/repo-config.sh
```

실제 값(`REPO_APP_PKG`, `REPO_DOMAIN_PKG`, `REPO_DATA_PKG`, `REPO_SHARED_DOMAIN_PATH`) 은
해당 repo 의 `repo-config.sh` 에서 정의된다. 본 문서에는 default 를 명시하지 않는다.

## 실행 절차

사전 조건: `. scripts/agent/repo-config.sh` 로 env var 가 이미 로드되어 있어야 한다.

### 1. `$REPO_SHARED_DOMAIN_PATH` → Android 플랫폼 SDK import 검사
```bash
rg -n "^import android\." "$REPO_SHARED_DOMAIN_PATH/" 2>/dev/null || echo "0 matches"
```

### 2. `$REPO_SHARED_DOMAIN_PATH` → data 레이어 import 검사
```bash
rg -n "^import.*\.data[.;]" "$REPO_SHARED_DOMAIN_PATH/" 2>/dev/null || echo "0 matches"
```

### 3. `$REPO_SHARED_DOMAIN_PATH` → app/feature 상위 레이어 import 검사
```bash
rg -n "^import.*${REPO_APP_PKG}\.shared\.(app|feature)" "$REPO_SHARED_DOMAIN_PATH/" 2>/dev/null || echo "0 matches"
```

### 4. `$REPO_SHARED_DOMAIN_PATH` → koin/hilt DI 프레임워크 import 검사
```bash
rg -n "^import (org\.koin|dagger\.hilt|javax\.inject)" "$REPO_SHARED_DOMAIN_PATH/" 2>/dev/null || echo "0 matches"
```

### 5. app 레이어 → `$REPO_DOMAIN_PKG` 역방향 노출 검사 (선택)
```bash
rg -n "^import.*${REPO_DOMAIN_PKG}" app/src/ 2>/dev/null | head -20 || echo "0 matches"
```

## 결과 출력 형식

```
[CHECK-LAYER] I2 불변 원칙 위반 스캔 (scope: $REPO_DOMAIN_PKG @ $REPO_SHARED_DOMAIN_PATH)
1. domain → Android SDK: N matches
2. domain → data 레이어: N matches
3. domain → app/feature: N matches
4. domain → koin/hilt: N matches
5. app → domain (참고): N matches

종합: N violations / 0 violations
```

위반이 있으면 `file:line` 형태로 목록 출력. 없으면 "0 violations" 출력.

## 제약
- 파일 변경 금지 (read-only)
- 위반 자동 수정 금지
- 위반 발견 시 → layer-checker subagent 또는 별도 task 로 처리
- `$REPO_SHARED_DOMAIN_PATH` 없을 경우 → "UNKNOWN ($REPO_SHARED_DOMAIN_PATH 경로 없음)" 기록
