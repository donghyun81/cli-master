---
name: plan-first
description: Use to generate EVIDENCE.md + PLAN.md (10-section) without entering implement mode. Use before /fulfill-requirement for large or risky changes — implementer entry stays Blocked.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
---

# plan-first

> Purpose: EVIDENCE → PLAN.md(10-section) 까지만 생성하고 implement 진입 없이 정지.

인자: `$ARGUMENTS` — 요구사항 설명 또는 taskId

## 목적
구현 없이 EVIDENCE + PLAN 만 생성한다. implement 진입 금지.

## 실행 절차

### 1. Intake Normalization
프롬프트 수신 직후 아래를 먼저 판정한다:
- Work Type: 구현 / 조사 / 문서 / 검증 / 운영 레이어 변경
- Reading Mode
- Requirement Source 충족 여부
- 정보 공백: RESOLVABLE_IN_REPO / UNKNOWN / BLOCKED
- STOP 위험 (MoneyAuth / DBMig / Auth / 비가역 변경)
- 필요한 read-only fan-out
- Implementer 진입 가능 여부 → **이 커맨드에서는 항상 Blocked**

### 2. /collect — 제품 변경 없이 수집만
- CLAUDE.md, .claude/rules/ 관련 항목 읽기
- 관련 소스 파일 Grep/Read
- 0 matches 도 기록

### 3. EVIDENCE.md 작성
경로: `.ai/reports/<taskId>/EVIDENCE.md`
포함 항목:
- Requirements Source
- Intake Normalization 표
- Pre-EVIDENCE Contract (gaps / chosen path / hold reasons / **implement entry: Blocked**)
- Collect Results (매칭 파일 + 0 matches)
- Key Findings
- Cleanup Assessment (해당 task 유형에 따라 기록 또는 N/A)

### 4. PLAN.md 작성
경로: `.ai/reports/<taskId>/PLAN.md`
형식: 10-section 정규 스키마 (`## 1. ChangeBudget` ~ `## 10. ExternalPrep`)
해당 없는 섹션은 `N/A` 명시 — 섹션 삭제 금지.

### 5. 완료 후 명시적으로 멈춤
```
[PLAN-FIRST 완료]
EVIDENCE: .ai/reports/<taskId>/EVIDENCE.md
PLAN: .ai/reports/<taskId>/PLAN.md

implement 진입 금지. 계획을 검토한 뒤 /fulfill-requirement 또는 구현 프롬프트로 진행하세요.
```

## 금지
- implement (파일 생성/수정) 진입 금지
- VERIFY.md / REVIEW.md 생성 금지 (이 단계에서는 의미 없음)
- curl, wget, sudo, rm, git commit/push/reset/clean 사용 금지
- 시크릿·키 값 기록 금지
