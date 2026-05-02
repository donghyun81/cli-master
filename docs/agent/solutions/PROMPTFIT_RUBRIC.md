# PromptFit Rubric

> 운영 레이어 — task 품질 평가 루브릭 (설명 레이어)
> SOT 참조: `CLAUDE.md` (REVIEW 섹션) | 인덱스: `.ai/promptfit/INDEX.md`

---

## 개요

모든 implement task는 REVIEW.md에 PromptFit 평가를 남긴다.
PromptFitScore는 0–100점이며, 6개 차원으로 구성된다.

---

## 채점 차원 (총 100점)

| 차원 | 배점 | 측정 기준 |
|---|---|---|
| Requirement Alignment | 25 | 요구사항의 성공 조건이 모두 반영됐는가? |
| Scope Control | 20 | 범위 이탈 없이 최소 변경 원칙을 지켰는가? |
| Evidence / Verify Quality | 20 | 근거 기록과 검증 명령이 충분한가? exit code 포함 여부 |
| Risk / STOP Handling | 10 | 위험 경로를 적절히 감지하고 STOP/UNKNOWN 처리했는가? |
| Output Contract Compliance | 10 | PLAN·EVIDENCE·VERIFY·REVIEW 형식 완전성 |
| Prompt Efficiency / Clarity | 15 | 프롬프트 대비 구현 효율. 불필요한 오버헤드 없음 |

---

## Verdict 기준

| Score | Verdict | 의미 |
|---|---|---|
| 90 – 100 | Excellent | 높은 품질, 재현 가능한 패턴 |
| 75 – 89 | Good | 기본 기준 충족, 일부 개선 가능 |
| 60 – 74 | Borderline | 조건부 통과, 주요 개선 필요 |
| 40 – 59 | Weak | 핵심 기준 미충족 |
| 0 – 39 | Misaligned | 요구사항과 근본적 불일치 |

---

## REVIEW.md 기록 형식

```markdown
## PromptFit

PromptFitScore: <0-100>
PromptFitVerdict: <Excellent / Good / Borderline / Weak / Misaligned>
PromptFitBreakdown:
- Requirement Alignment: <점수>/25 (<근거>)
- Scope Control: <점수>/20 (<근거>)
- Evidence/Verify Quality: <점수>/20 (<근거>)
- Risk/STOP Handling: <점수>/10 (<근거>)
- Output Contract Compliance: <점수>/10 (<근거>)
- Prompt Efficiency/Clarity: <점수>/15 (<근거>)
PromptFitIssues:
- <주요 감점 이유>
PromptFitNextActions:
- <다음 개선 액션>
PromptFitConfidence: <High / Medium / Low>
```

---

## 인덱스 기록 형식

`.ai/promptfit/INDEX.md` 에 task 완료 시 한 줄 append:

```
| <TaskId> | <Date KST> | <Score> | <Verdict> | <TopIssues> | <NextActions> | <Confidence> |
```

---

## Playbook 승격 기준

`.ai/promptfit/PLAYBOOK.md` 에 승격되는 조건:
- 동일 패턴의 개선이 3회 이상 반복 관찰됨
- 개선 방향이 명확하고 측정 가능함
- 루브릭 차원과 연결된 구체적 액션이 있음
