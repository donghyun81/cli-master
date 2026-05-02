# Report Paths Rules

> **단일 목적**: 산출물 경로 규약 + stdout 출력 순서 + Task 문서 (`.ai/tasks/<taskId>.md`) 형식.
> **분할 출처**: 기존 evidence-and-reporting.md (438 줄) 의 line 1~70 발췌 (C2-RULES-RESTRUCTURE-001).
> **연관 파일**:
> - `report-formats.md` — EVIDENCE / PLAN / VERIFY / REVIEW 정규 스키마 + Subagent Return Contract
> - `cycle-discipline.md` §11 — 보고서 lightweight 옵션 (4 파일 vs 7 파일)
> SOT: `CLAUDE.md`

---

> 모든 산출물의 형식, 경로, 기록 기준을 정의한다.
> SOT: `CLAUDE.md`

---

## 산출물 경로 규약

| 파일 | 경로 | 특성 |
|---|---|---|
| Task 문서 | `.ai/tasks/<taskId>.md` | 불변 (원문 요구사항 + 메타) |
| Task 인덱스 | `.ai/tasks/INDEX.md` | 항상 최신 유지 |
| MODE | `.ai/reports/<taskId>/MODE.md` | 첫 단계에서 생성 |
| EVIDENCE | `.ai/reports/<taskId>/EVIDENCE.md` | 수집 근거 전체 |
| PLAN | `.ai/reports/<taskId>/PLAN.md` | ChangeBudget + 작업 계획 |
| VERIFY | `.ai/reports/<taskId>/VERIFY.md` | 검증 명령 + 결과 |
| REVIEW | `.ai/reports/<taskId>/REVIEW.md` | 최종 판정 |
| COMPOUND | `.ai/reports/<taskId>/COMPOUND.md` | compound-lint 결과 |
| TODO | `.ai/reports/<taskId>/TODO.md` | 후속 작업 목록 |

---

## stdout 출력 순서

항상 다음 순서를 따른다:

```
[EVIDENCE] 수집 근거 요약
[DIFF]     변경 내역 (파일:라인)
[LOG]      검증 명령과 exit code
```

---

## Task 문서 (.ai/tasks/<taskId>.md) 형식

```markdown
## Meta
| 항목 | 값 |
|---|---|
| TaskId | <PREFIX>-<DOMAIN>-NNN |
| Created (KST) | YYYY-MM-DD HH:MM |
| Status | COLLECT / PLAN / IMPLEMENT / VERIFY / REVIEW / DONE / STOP / BLOCKED |
| Risk | Low / Medium / High |
| DBMig | Yes / No |
| MoneyAuth | Yes / No |

## 원문 요구사항
[사용자 원문 그대로]

## 분해된 문제 진술
[requirements-analyst 결과]

## 성공 조건
[measurable success criteria]

## Measurable Exit Criteria
_자연어 성공 조건과 1:1 대응. 실행 가능한 검증 명령이나 grep 패턴으로 기술._
- [ ] `<검증 명령 또는 grep 패턴>` — <기대 결과>

## 비기능 요구사항
[non-functional requirements]

## 불확실성 (UNKNOWN)
[근거 없는 항목 + 확인 위치]
```

---

