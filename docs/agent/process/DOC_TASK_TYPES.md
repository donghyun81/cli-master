# Doc Task Types — 분류 기준

> 문서 관련 작업의 유형을 분류하고, 각 유형에 적합한 스킬과 역할을 정의한다.
> SOT: `CLAUDE.md` | 워크플로: `docs/agent/process/DOC_GOVERNANCE_WORKFLOW.md`

---

## 분류 기준

문서 작업을 요청받으면 아래 분류표로 적합한 스킬을 결정한다.
분류 전에 먼저 `docs/agent/process/REPO_FIRST_INTAKE_WORKFLOW.md` 기준 intake normalization을 수행한다.

---

## Type 1: DocSync (구현 후 문서 갱신)

**정의**: 제품 또는 운영 레이어 구현 변경 후 관련 문서를 갱신하는 작업.

**특징**:
- 구현 task의 일부분 (독립 task 아님)
- 구현 결과를 문서에 반영 (역방향 없음)
- 최소 변경 — 변경된 내용만 반영

**사용 스킬**: `fulfill-requirement` (DocSync 단계 포함)
**담당 역할**: `docs-change-communicator`
**Task ID**: 독립 ID 없음 (구현 task의 서브단계)

**예시**:
- 새 에이전트 추가 후 `domain-roles.md` 갱신
- 새 규칙 파일 추가 후 `CLAUDE.md` 세부 규칙 경로 갱신
- API 변경 후 `AI_CLI_SETTINGS_SNAPSHOT.md` 갱신

---

## Type 2: Drift Audit (드리프트 감사)

**정의**: 현재 repo 실물과 문서 간의 불일치를 체계적으로 감지·보고하는 작업.

**특징**:
- read-only 분석 (수정 없음)
- 우선순위 드리프트 목록 생성
- 후속 수정 task의 근거 자료

**사용 스킬**: `fulfill-doc-governance`
**담당 역할**: `docs-drift-auditor`
**Task ID**: `SW-DOCS-NNN` 또는 `SW-CLI-NNN`

**예시**:
- "운영 레이어 참조 경로가 유효한지 전수 감사해줘"
- "에이전트 파일들이 참조하는 규칙 파일이 모두 존재하는지 확인해줘"

---

## Type 3: Doc Restructuring (문서 재구성)

**정의**: 문서 계층·경로·카테고리를 변경하는 구조 작업.

**특징**:
- 구조 결정이 포함됨 (docs-structure-architect 필요)
- 참조 경로 파괴 위험 있음 → 신중한 계획 필요
- 기존 참조 업데이트가 수반됨

**사용 스킬**: `fulfill-doc-governance`
**담당 역할**: `docs-structure-architect` + `docs-change-communicator`
**Task ID**: `SW-DOCS-NNN` 또는 `SW-CLI-NNN`

**예시**:
- "`docs/agent/` 하위에 새 카테고리 디렉터리 추가"
- "운영 레이어 문서를 기능별로 재배치"

---

## Type 4: Doc Creation (신규 문서 생성)

**정의**: 존재하지 않는 문서를 새로 만드는 작업.

**특징**:
- 내용 결정이 필요 (단순 갱신 아님)
- 기존 문서와의 일관성 확인 필요
- 다른 파일에서 참조 업데이트가 수반될 수 있음

**사용 스킬**: `fulfill-doc-governance`
**담당 역할**: `docs-structure-architect` (내용 결정) + `docs-change-communicator` (작성)
**Task ID**: `SW-DOCS-NNN` 또는 `SW-CLI-NNN`

**예시**:
- "`docs/agent/solutions/PROMPTFIT_RUBRIC.md` 가 참조되지만 없다 — 만들어줘"
- "`docs/agent/solutions/README.md` 역할표를 채워줘"

---

## Type 5: Doc Policy Update (문서 정책 갱신)

**정의**: CLAUDE.md, 규칙 파일(.claude/rules/)처럼 운영 정책이 담긴 문서를 갱신하는 작업.

**특징**:
- 다른 에이전트·스킬의 동작에 직접 영향
- 범위 확장 위험 높음 → 신중한 계획 필수
- 기존 에이전트 동작과 정합성 확인 필요

**사용 스킬**: `fulfill-doc-governance` (단, intake-router가 영향 범위 확인 필수)
**담당 역할**: `requirements-analyst` + `docs-structure-architect` + `change-planner` (신중한 PLAN)
**Task ID**: `SW-CLI-NNN`

**STOP 조건**: 정책 변경이 MoneyAuth / Auth / DBMig 동작에 영향을 주면 STOP

**예시**:
- "CLAUDE.md STOP 조건에 새 항목 추가"
- "routing-and-delegation.md에 새 역할 매핑 추가"

---

---

## Code-level Task와 Cleanup Governance

구현 변경이 수반되는 task (Type 1의 구현 부분 포함)는 **cleanup assessment가 항상 적용**된다.

| Task 성격 | Cleanup Assessment |
|---|---|
| 제품 코드 구현/수정 | **필수** (EVIDENCE.md `## Cleanup Assessment` 섹션) |
| ops-layer 변경 (CLAUDE.md, rules, hooks, skills 수정) | N/A 명시 |
| Type 2 (Drift Audit), Type 3 (Restructuring), Type 4 (Creation) | 적용 안 함 (선택) |
| Type 5 (Policy Update) | 제품 코드 변경 없으면 N/A 명시 |

상세: `docs/rules/legacy-cleanup-governance.md`

---

## 유형 판정 흐름

```
문서 요구사항 입력
    │
    ▼
구현 변경이 수반되는가?
    ├── Yes → fulfill-requirement (DocSync 포함)
    └── No ↓
        │
        ▼
    운영 정책 파일 변경인가? (CLAUDE.md, rules/)
        ├── Yes → Type 5 (주의 — intake-router 영향 범위 확인)
        └── No ↓
            │
            ▼
        새 파일 생성인가?
            ├── Yes → Type 4
            └── No ↓
                │
                ▼
            구조 변경(경로 이동/재배치)인가?
                ├── Yes → Type 3
                └── No ↓
                    │
                    ▼
                감사(확인) 목적인가?
                    ├── Yes → Type 2
                    └── 기존 파일 내용 갱신 → Type 1 (DocSync)
```

---

## 관련 파일

- 워크플로: `docs/agent/process/DOC_GOVERNANCE_WORKFLOW.md`
- 드리프트 감사 역할: `.claude/agents/docs-drift-auditor.md`
- 문서 구조 역할: `.claude/agents/docs-structure-architect.md`
- 문서 갱신 역할: `.claude/agents/docs-change-communicator.md`
