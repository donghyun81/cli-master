---
name: resume-task
description: Use to read-only restore a STOPPED/BLOCKED task — reads .ai/tasks/<id>.md + .ai/reports/<id>/, parses HANDOFF.md frontmatter, outputs Resume Context + next-step candidates to stdout. Creates no files.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---

# resume-task

> Purpose: STOP/BLOCKED 로 멈춘 task 를 read-only 로 복원하고 다음 단계 후보만 stdout 출력.

인자: `$ARGUMENTS` — `<taskId>` (필수, 예: `SW-AUTH-SUPABASE-001`)

## 목적

기존 task 를 read-only 로 복원한다. 새 파일을 만들지 않고 stdout 출력만 한다.
- 마지막 Status 와 STOP/BLOCKED 사유 복원
- 잔여 TODO 항목 출력
- 다음 단계 후보 (PLAN 재작성 / verify 재실행 / 폐기) 제시

> **Context Reset Policy**: 이 커맨드는 장기 실행 task 의 context reset 후 재진입 엔트리다.
> `HANDOFF.md` 가 존재하면 최우선으로 읽고, EVIDENCE/PLAN/VERIFY/REVIEW/TODO 는 발췌 읽기만
> 한다 (bulk 전수 읽기 금지). 상세: `docs/rules/workflow-core.md` "Context Reset Policy" 섹션.
>
> **YAML 프런트매터 파싱**: HANDOFF.md에 YAML 프런트매터가 있으면 `taskId`, `status`,
> `nextEntry`, `riskFlags`를 먼저 파싱하여 재진입 판단에 사용한다. 본문은 상세 맥락이
> 필요할 때만 읽는다. 프런트매터와 본문이 충돌하면 본문이 우선한다.

## 실행 절차

### 1. 인자 검증 — taskId 존재 확인
```bash
test -f .ai/tasks/$ARGUMENTS.md && echo "TASK_FOUND" || echo "TASK_MISSING"
```
결과가 `TASK_MISSING` 이면 즉시 BLOCKED 종료:
```
[BLOCKED] task not found: .ai/tasks/$ARGUMENTS.md
재실행: 올바른 taskId 와 함께 다시 호출하거나 /fulfill-requirement 로 새 task 를 시작하세요.
```

### 2. Task 문서 read
- `.ai/tasks/$ARGUMENTS.md` Meta 표에서 Status / Risk / DBMig / MoneyAuth 추출
- 원문 요구사항 / 성공 조건 / 비기능 요구사항 / UNKNOWN 섹션 read

### 3. 보고서 7종 read (존재하는 것만)
`.ai/reports/$ARGUMENTS/` 디렉터리에서 다음 파일 중 존재하는 것만 read:
- `MODE.md`
- `EVIDENCE.md`
- `PLAN.md`
- `VERIFY.md`
- `REVIEW.md`
- `COMPOUND.md`
- `TODO.md`

존재하지 않는 파일은 "absent" 로 stdout 에 표기.

### 4. INDEX 대조
```bash
grep -E "^\| $ARGUMENTS " .ai/tasks/INDEX.md || echo "INDEX_MISSING_ROW"
```
- INDEX Status 와 task 문서 Meta Status 가 다르면 불일치를 stdout 에 표기 (자동 수정 금지)

### 5. STOP/BLOCKED 사유 복원 (있으면)
- VERIFY.md / REVIEW.md / 마지막 보고서 본문에서 `STOP` / `BLOCKED` / `FAIL` / `UNKNOWN` 키워드 grep
- 발견 항목을 `## Resume Context` 형식으로 stdout 에 정리 (파일에 쓰지 않는다)

### 6. 잔여 TODO 출력
- `.ai/reports/$ARGUMENTS/TODO.md` 가 있으면 본문 그대로 출력
- 없으면 "TODO.md absent" 표기

### 7. 다음 단계 후보 제시
사용자에게 stdout 으로 후보 옵션을 출력한다 (실행하지 않는다):
```
[RESUME-TASK 결과] $ARGUMENTS
Status (task doc): <값>
Status (INDEX):    <값>
Last stage:        <MODE/EVIDENCE/PLAN/VERIFY/REVIEW>
Blocking reasons:  <요약>

다음 단계 후보:
  1) PLAN 재작성 → /plan-first 또는 /fulfill-requirement
  2) verify 재실행 → /verify-all $ARGUMENTS
  3) review 재생성 → /review-task $ARGUMENTS
  4) 폐기 → INDEX Status 를 ABANDONED 로 갱신 (수동)
```

## 산출물

**없음.** 새 task ID 생성 금지. `.ai/reports/$ARGUMENTS/` 에 신규 파일 생성 금지.
결과는 stdout 출력만이다.

## 금지

- `.ai/tasks/`, `.ai/reports/` 어떤 파일도 변경 금지 (write/edit 권한 없음 — frontmatter 로 강제)
- 신규 task 문서 생성 금지
- 인터넷 조회, 외부 API 호출 금지
- /tmp, $TMPDIR 경로 사용 금지
- INDEX Status 자동 수정 금지 (불일치는 보고만)

## STOP 조건

다음 감지 시 즉시 STOP, 사용자 보고:
- task 문서가 손상되어 read 불가 (file corruption)
- 보고서 디렉터리에 예상 외 파일이 다수 발견 (unexpected system state)
- task 가 Auth / Billing / DBMig 영향 경로이며 사용자 재승인 없이 재개 위험
