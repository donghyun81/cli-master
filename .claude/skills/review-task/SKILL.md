---
name: review-task
description: Use to regenerate REVIEW.md only for a given taskId — runs compound-lint, reads VERIFY.md + PLAN.md + EVIDENCE.md, produces evidence-based 12-section judgment + PromptFit, appends .ai/promptfit/INDEX.md. Manual trigger with /review-task <taskId>.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
disable-model-invocation: true
---

# review-task

> Purpose: 구현이 끝난 task 의 compound-lint 재실행 + REVIEW.md 재생성 + PromptFit 갱신 + INDEX append.

인자: `$ARGUMENTS` — taskId (예: `SW-UI-001`)

## 실행 절차

### 1. compound-lint 실행
```bash
bash scripts/agent/compound-lint.sh $ARGUMENTS 2>&1
```
exit code 와 stdout 을 기록한다.

### 2. 필수 아티팩트 확인
`.ai/reports/$ARGUMENTS/` 디렉터리에서 다음을 확인:
- EVIDENCE.md 존재 여부
- PLAN.md 존재 여부
- VERIFY.md 존재 여부 + 명령 흔적 1개 이상

### 3. REVIEW.md 생성 (12-section 정규 스키마)
`.ai/reports/$ARGUMENTS/REVIEW.md` 를 생성한다.
형식: `.claude/rules/evidence-and-reporting.md` 의 REVIEW.md 12-section 스키마 준수.

필수 포함 항목:
- 1. Requirements Coverage
- 2. Regression Risk
- 3. Architecture Integrity — SOLID
- 4. Architecture Integrity — Layer Boundaries
- 5. Model Separation
- 6. Dependency Governance
- 7. TDD Evidence & Testability Seams
- 8. Error / Result Policy
- 9. External Prep / Deferred Items
- 10. DocSync
- 11. Secrets Safety (compound-lint 결과 인용)
- 12. Rollback Viability
- 13. Cleanup Governance

Findings, Verdict (PASS/FAIL/PARTIAL) 포함.

### 4. PromptFit 평가
REVIEW.md 마지막 섹션에 PromptFit 평가 추가:
- PromptFitScore (0~100)
- PromptFitVerdict
- PromptFitBreakdown (6개 기준 각 점수)
- PromptFitIssues
- PromptFitNextActions
- PromptFitConfidence
루브릭: `docs/agent/solutions/PROMPTFIT_RUBRIC.md`

### 5. `.ai/promptfit/INDEX.md` append
다음 형식으로 한 줄 추가:
```
| $ARGUMENTS | <Score> | <Verdict> | <date KST> | <한 줄 요약> |
```

## 금지
- compound-lint FAIL 상태에서 REVIEW.md Verdict=PASS 판정 금지
- VERIFY.md 존재하지 않으면 REVIEW Verdict=PASS 금지
- 시크릿·키 값 기록 금지
