---
name: survey
description: Use for investigation tasks — clarify UNKNOWNs, identify external dependencies, produce repo-grounded findings (EVIDENCE.md + VERIFY.md) without product changes. No PLAN/implement.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---

# survey

> Purpose: 레포 안에서 코드/문서 변경 없이 답만 모으는 read-only research 진입점. EVIDENCE+VERIFY 만 생성.

인자: `$ARGUMENTS` — 조사 주제 또는 question. 인자 끝에 명시적 taskId 가 포함되면 그 ID 를 사용한다.

## 목적

레포 안에서 답을 모으는 read-only research 진입점이다.
- 코드/문서 변경 없음
- PLAN.md 생성 없음, implement 진입 없음
- 산출물은 `EVIDENCE.md` + `VERIFY.md` 만 (REVIEW 단계 없음)

### 다른 커맨드와의 경계

| 상황 | 사용할 커맨드 |
|---|---|
| 코드/문서 변경 없이 repo 내 답만 모으기 | `/survey` (이 커맨드) |
| EVIDENCE → PLAN 까지 만들고 implement 진입 전 정지 | `/plan-first` |
| 문서 드리프트 감사, SoT 정합성, docs/** 구조 변경 | `/fulfill-doc-governance` |
| 제품 코드 구현·수정 (UI / shared / server) | `/fulfill-requirement` |

`/survey` 는 PLAN 도 REVIEW 도 만들지 않는다. 문서 본문을 바꾸는 작업이면 `/fulfill-doc-governance`, 구현을 포함하면 `/fulfill-requirement` 로 넘긴다.

## 실행 절차

### 1. Intake Normalization
프롬프트 수신 직후 아래를 먼저 판정한다:
- Work Type: **조사 (survey)** 로 고정
- Reading Mode: 주제에 맞춰 선택 (정책-계획 점검형 / UI-UX형 / API-서버형 / CLI 운영 레이어형 등)
- Requirement Source: 본 세션 프롬프트 + `.ai/tasks/<taskId>.md`
- 정보 공백: RESOLVABLE_IN_REPO / UNKNOWN / BLOCKED 분류
- STOP 위험 (MoneyAuth / DBMig / Auth / 비가역 변경) 점검 — 감지 시 즉시 STOP
- Implementer Entry → **항상 Blocked (조사형 task)**

### 2. TaskId 부여
형식: `SW-SURVEY-NNN` (사용자가 인자에 명시한 ID 가 있으면 그 ID 사용)
- 충돌 시 다음 번호로 부여
- `.ai/tasks/<id>.md` 생성 (Meta + 원문 요구사항 + 성공조건 + UNKNOWN)

### 3. /collect — read-only 수집만
- `CLAUDE.md`, `.claude/rules/` 관련 항목 읽기
- 관련 소스/문서 Grep / Read
- **0 matches 도 반드시 기록** (부재 증거)
- 제외 경로: `build/`, `.gradle/`, `generated/`, `.git/`, `app/build/`

### 4. EVIDENCE.md 작성
경로: `.ai/reports/<taskId>/EVIDENCE.md`
포함 항목 (`.claude/rules/reporting.md` 형식):
- Requirements Source
- Intake Normalization 표
- Pre-EVIDENCE Contract — `Implement entry: Blocked (survey task)`
- Collect Results (매칭 파일 + 0 matches)
- Key Findings
- UNKNOWN 항목 (확인 위치 명시)
- **Cleanup Assessment**: `N/A (조사형 task — 적용 안 함)`

### 5. VERIFY.md 작성 — 0 command 금지
조사형 task 라도 검증 명령 1건 이상 실제 실행 + exit code 기록.
허용 예시:
- `rg -n "<keyword>" <path>` — 수집 근거 재확인
- `find <dir> -maxdepth N -type f` — 부재 증거 재확인
- `git log --oneline -n 5 -- <path>` — 최근 변경 이력 확인
- `ls .ai/reports/<taskId>/` — 보고서 산출물 존재 (구 compound-lint 정합성 검사 = deprecated · 도구 부재)

각 명령 CMD/EXIT/STDOUT 을 VERIFY.md 표 + LOG 에 기록.

### 6. 완료 후 명시적으로 멈춤
```
[SURVEY 완료]
TaskId: <id>
EVIDENCE: .ai/reports/<id>/EVIDENCE.md
VERIFY: .ai/reports/<id>/VERIFY.md

PLAN/IMPLEMENT 진입 금지.
필요시 결과를 검토한 뒤 /fulfill-requirement 또는 /plan-first 로 후속 task 를 시작하세요.
```

`.ai/tasks/INDEX.md` Status 를 `SURVEY-DONE` 또는 `DONE` 으로 한 줄 append.

## 산출물

- `.ai/tasks/<id>.md`
- `.ai/reports/<id>/MODE.md`
- `.ai/reports/<id>/EVIDENCE.md`
- `.ai/reports/<id>/VERIFY.md`
- `.ai/tasks/INDEX.md` 한 줄 append

PLAN.md / REVIEW.md / COMPOUND.md / TODO.md 는 생성하지 않는다.
(stop-gate 는 PLAN.md 없는 task 를 차단하지 않으므로 정합성 유지.)

## 금지

- PLAN.md / REVIEW.md / 제품 코드 / 문서 본문 변경 금지
- implement (Edit / Write 권한 없음 — frontmatter `allowed-tools` 로 강제)
- 인터넷 조회, 외부 API 호출 금지
- 시크릿·키 값 기록 금지
- /tmp, $TMPDIR 경로 사용 금지

## STOP 조건

다음 감지 시 즉시 STOP, 사용자 보고:
- Auth / Billing / DB migration / secret / PII 영향 발견
- 조사 결과가 비가역 변경을 시사
- 범위 확장 (조사 → 구현 또는 문서 수정)
