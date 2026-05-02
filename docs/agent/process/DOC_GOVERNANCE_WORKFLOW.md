# Doc Governance Workflow

> 이 문서는 운영 레이어의 문서 거버넌스 워크플로를 정의한다.
> SOT: `CLAUDE.md` | 스킬: `.claude/skills/fulfill-doc-governance/SKILL.md`

---

## 언제 문서 거버넌스 작업이 필요한가

| 트리거 | 예시 | 적합한 스킬 |
|---|---|---|
| 구현 완료 후 문서 갱신 | 기능 변경 → 아키텍처 문서 업데이트 | `fulfill-requirement` (DocSync 단계) |
| 참조 경로 파괴 감지 | 에이전트 파일이 없는 규칙 파일을 참조 | `fulfill-doc-governance` |
| 문서 구조 재설계 | `docs/agent/` 하위 디렉터리 정비 | `fulfill-doc-governance` |
| 주기적 드리프트 감사 | 분기 감사, 신규 에이전트 추가 후 | `fulfill-doc-governance` |
| 누락 문서 채우기 | `docs/agent/solutions/` 가 비어있음 | `fulfill-doc-governance` |

---

## 워크플로 단계

```
/fulfill-doc-governance <요구사항>
    │
    ▼
[1] intake-router
    ├── 문서 거버넌스 작업 확인
    ├── 제품 코드 변경 없음 확인
    ├── CLI ops reading order 조립
    ├── 정보 공백 3분류
    └── TaskId 생성 (SW-DOCS-NNN 또는 SW-CLI-NNN)
    │
    ▼
[2] requirements-analyst (read-only)
    ├── 범위 / 성공 조건 / requirement source 고정
    └── EVIDENCE.md pre-EVIDENCE 계약 보강
    │
    ▼
[3] docs-drift-auditor (read-only)
    ├── 참조 경로 전수 확인
    ├── 드리프트 우선순위 분류 (Critical/High/Medium/Low)
    └── EVIDENCE.md 작성
    │
    ▼ (구조 결정 필요 시만)
[4] docs-structure-architect (read-only)
    ├── SOT 경계 분석
    ├── 누락·중복·충돌 식별
    └── EVIDENCE.md 보강
    │
    ▼
[5] change-planner
    └── PLAN.md (10-section, pre-EVIDENCE 계약 확인, RollbackStrategy="git revert로 즉시 복구")
    │
    ▼
[6] docs-change-communicator (write)
    ├── 최소 변경
    └── 제품 코드 미접촉 확인
    │
    ▼
[7] verifier → VERIFY.md
    │
    ▼
[8] reviewer → REVIEW.md (Verdict PASS/FAIL/PARTIAL)
```

공통 intake / reading order:
`docs/agent/process/REPO_FIRST_INTAKE_WORKFLOW.md`

---

## 문서 거버넌스 PLAN.md 특이사항

문서 전용 task의 PLAN.md 10-section 기본값:

| 섹션 | 기본값 |
|---|---|
| 2. DependencyDecision | N/A (libs 변경 없음) |
| 3. ArchitectureImpact | N/A (문서 전용 — 인터페이스 없음) |
| 4. ModelBoundaryPlan | N/A (모델 변경 없음) |
| 5. ErrorPolicy | N/A (UseCase 없음) |
| 6. UIStateFlowPlan | N/A (UI 없음) |
| 7. TestabilitySeams | N/A (테스트 없음) |
| 9. RollbackStrategy | "git revert <commit>으로 즉시 복구 가능" |
| 10. ExternalPrep | N/A |

**항상 필수**: 1. ChangeBudget, 8. VerificationPlan

---

## 드리프트 감사 주기 권고

| 이벤트 | 감사 범위 |
|---|---|
| 새 에이전트 파일 추가 | routing-and-delegation.md + domain-roles.md 참조 일관성 |
| 새 규칙 파일 추가 | CLAUDE.md 참조 경로 확인 |
| 에이전트 파일 삭제/이름 변경 | 전체 에이전트 참조 경로 전수 확인 |
| 새 스킬 추가 | AI_CLI_SETTINGS_SNAPSHOT.md 스킬 인벤토리 갱신 |
| 분기 정기 감사 | docs/agent/ 전체 + .claude/ 참조 경로 |

---

## 산출물 경로

| 산출물 | 경로 |
|---|---|
| Task 문서 | `.ai/tasks/SW-DOCS-NNN.md` 또는 `.ai/tasks/SW-CLI-NNN.md` |
| 보고서 | `.ai/reports/<taskId>/{MODE,EVIDENCE,PLAN,VERIFY,REVIEW,COMPOUND,TODO}.md` |
| 드리프트 감사 | EVIDENCE.md 내 Drift Audit 섹션 |

---

## 관련 파일

- 드리프트 감사 역할: `.claude/agents/docs-drift-auditor.md`
- 문서 구조 역할: `.claude/agents/docs-structure-architect.md`
- 문서 갱신 역할: `.claude/agents/docs-change-communicator.md`
- 스킬 (Claude): `.claude/skills/fulfill-doc-governance/SKILL.md`
- 작업 유형 분류: `docs/agent/process/DOC_TASK_TYPES.md`
