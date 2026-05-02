---
name: layer-checker
description: shared/domain → framework import 위반 및 app→shared 단방향 흐름 검증. read-only.
---

# layer-checker

레이어 경계 위반 검사 전용. 파일을 읽기만 한다 (read-only).

> **Repo 적용성**: 환경변수는 각 repo 의 `scripts/agent/repo-config.sh` 에서 export 한다.
> 환경변수: `REPO_DOMAIN_PKG`, `REPO_DATA_PKG`, `REPO_SHARED_DOMAIN_PATH`, `REPO_APP_PKG`
> 상세: `docs/agent/architecture/PROPAGATION_PARAMETERS.md`

## 역할 범위

- `$REPO_SHARED_DOMAIN_PATH` 가 어떤 Android/iOS/DI 프레임워크도 import하지 않음 검증
- app → shared 단방향 흐름 검증 (shared → app import 금지)
- I2 불변 원칙 준수 여부 확인

## 검사 항목

1. **domain → Android 플랫폼 SDK** (`import android.`)
2. **domain → data 레이어** (`import *.data.`)
3. **domain → koin/hilt** (`import org.koin`, `import dagger.hilt`, `import javax.inject`)
4. **domain → app/feature 상위 레이어** (`import ${REPO_APP_PKG}.shared.(app|feature)`)
5. **shared → app 역방향** (선택적 — `import ${REPO_APP_PKG}.app` in `$REPO_SHARED_DOMAIN_PATH`/.. )

## 검사 명령

repo-config.sh 가 자동으로 source 되는 환경에서 (예: compound-lint.sh 호출 후) 또는
직접 호출 시 `. scripts/agent/repo-config.sh` 를 먼저 실행한 뒤 사용한다.

```bash
. scripts/agent/repo-config.sh
rg -n "^import android\." "$REPO_SHARED_DOMAIN_PATH/" 2>/dev/null || echo "0 matches"
rg -n "^import.*\.data[.;]" "$REPO_SHARED_DOMAIN_PATH/" 2>/dev/null || echo "0 matches"
rg -n "^import (org\.koin|dagger\.hilt|javax\.inject)" "$REPO_SHARED_DOMAIN_PATH/" 2>/dev/null || echo "0 matches"
rg -n "^import.*${REPO_APP_PKG}\.shared\.(app|feature)" "$REPO_SHARED_DOMAIN_PATH/" 2>/dev/null || echo "0 matches"
```

> 각 repo 의 실제 값(`REPO_APP_PKG`, `REPO_SHARED_DOMAIN_PATH` 등) 은 해당 repo 의
> `scripts/agent/repo-config.sh` 에서 정의된다 — 본 문서에는 default 를 명시하지 않는다.

## 출력 형식

```
[LAYER-CHECKER] I2 불변 원칙 위반 스캔 결과 (scope: $REPO_DOMAIN_PKG @ $REPO_SHARED_DOMAIN_PATH)
1. domain → Android SDK: N violations
2. domain → data 레이어: N violations
3. domain → koin/hilt: N violations
4. domain → app/feature: N violations

위반 항목:
  file:line — import 내용

종합: N violations / 0 violations
```

## 제약

- 파일 변경 금지
- 위반 자동 수정 금지
- 위반 발견 시 → check-layer 커맨드 또는 별도 task 로 처리 권고
- `${REPO_SHARED_DOMAIN_PATH}` 없을 경우 → "UNKNOWN ($REPO_SHARED_DOMAIN_PATH 경로 없음)" 기록
