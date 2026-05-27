---
name: verify-all
description: Use to run architectureCheck + unit test + compound-lint in sequence with up to 2 retries. Reports PASS/FAIL per stage. STOP on 2 consecutive failures. Manual trigger with /verify-all <taskId>.
allowed-tools:
  - Bash
disable-model-invocation: true
---

# verify-all

> Purpose: architectureCheck + unit test + compound-lint 일괄 실행. 최대 2회 재시도로 간헐적 환경 문제를 흡수하되 실패는 STOP 보고.

인자: `$ARGUMENTS` — taskId (예: `SW-UI-001`)

0 command 금지 원칙에 따라 최소 1개 명령을 반드시 실행한다.

## 실행 절차

1. architectureCheck 실행:
```bash
./gradlew architectureCheck 2>&1
```
exit code 0이면 PASS. non-zero면 실패 로그를 기록하고 2단계로 진행.

2. unit test 실행:
```bash
./gradlew test 2>&1
```
exit code 0이면 PASS. non-zero면 실패 로그를 기록하고 3단계로 진행.

3. compound-lint 실행:
```bash
bash scripts/agent/compound-lint.sh $ARGUMENTS 2>&1
```
exit code 0이면 전체 PASS. non-zero면 FAIL — 아래 재시도 절차 진행.

## 실패 시 자동 재시도 (최대 2회)

1회 실패 후:
- 실패 원인을 분석한다 (VERIFY.md 누락인지, 시크릿 감지인지, PLAN 섹션 누락인지)
- 수정 가능한 경우: 해당 아티팩트를 보완한 뒤 `bash scripts/agent/compound-lint.sh $ARGUMENTS` 재실행
- 2회 연속 실패 시: STOP — 사용자에게 실패 사유와 수동 해결 방법 보고

## 결과 출력 형식

```
[VERIFY-ALL] TaskId: <taskId>
architectureCheck: PASS / FAIL (exit N)
test: PASS / FAIL (exit N)
compound-lint: PASS / FAIL (exit N)
종합: PASS / FAIL
```

## 금지

- curl, wget, sudo, rm, git commit/push/reset/clean 사용 금지
- /tmp 경로 사용 금지
- 시크릿·키 값 출력 금지
