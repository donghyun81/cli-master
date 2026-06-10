---
name: fulfill-doc-governance
description: Use for documentation governance — drift audit, SoT boundary analysis, doc hierarchy decisions without product code changes.
---

# Skill: fulfill-doc-governance

## Usage

```
/fulfill-doc-governance <문서 거버넌스 요구사항 한 줄>
```

또는 자연어로:
```
"문서가 최신인지 감사해줘"
"운영 레이어 문서 구조를 정리해줘"
"<특정 영역> 문서가 구현과 일치하는지 확인해줘"
"docs/agent/solutions/ 에 필요한 문서를 만들어줘"
```

---

## 이 스킬과 fulfill-requirement의 차이

| 항목 | fulfill-requirement | fulfill-doc-governance |
|---|---|---|
| 대상 | 제품 기능, 앱 코드, 운영 레이어 일반 | 문서 자체 — 구조, 드리프트, 거버넌스 |
| 구현 역할 | ui-implementer, server-implementer | docs-change-communicator |
| 분석 역할 | 도메인 전문가 팀 | requirements-analyst, docs-drift-auditor, docs-structure-architect |
| 위험 프레임 | MoneyAuth, DBMig, Auth | 경로 파괴, SOT 분산, 드리프트 |
| 제품 코드 변경 | 허용 (PLAN 확정 후) | **금지** — 운영/문서 레이어만 |

---

## 이 스킬이 하는 일

사용자가 문서 거버넌스 요구사항을 제시하면:

1. **Intake normalization**: intake-router가 작업 유형, CLI ops reading order, requirement source, 정보 공백 3분류, STOP 위험, implementer entry를 먼저 고정
2. **요구사항 구조화**: requirements-analyst가 범위와 성공 조건을 정리
3. **드리프트 감사**: docs-drift-auditor가 현재 드리프트 상태를 체계적으로 감지
4. **구조 분석**: docs-structure-architect가 문서 계층·SOT·중복을 분석
5. **계획**: change-planner가 PLAN.md 작성
6. **구현**: docs-change-communicator가 최소 변경으로 문서 갱신
7. **검증/리뷰**: verifier + reviewer

제품 코드를 건드리지 않는다.

---

## 실행 흐름

```
사용자 입력: /fulfill-doc-governance <요구사항>
    │
    ▼
[1] intake-router — 문서 거버넌스 태스크 확인
    ├── 제품 코드 변경 없음 확인
    ├── CLI ops reading order 조립
    ├── 정보 공백 분류
    ├── TaskId 생성 (SW-DOCS-NNN 또는 SW-CLI-NNN)
    ├── .ai/tasks/<taskId>.md 생성
    └── .ai/reports/<taskId>/MODE.md 생성
    │
    ▼
[2] requirements-analyst — 문제 정의 및 범위 고정 (read-only)
    └── EVIDENCE.md — Requirements Analysis
    │
    ▼
[3] docs-drift-auditor — 드리프트 감사 (read-only)
    ├── 참조 경로 전수 확인
    ├── 문서-구현 불일치 감지
    └── EVIDENCE.md — Drift Audit 섹션
    │
    ▼ (구조 결정이 필요한 경우)
[4] docs-structure-architect — 구조 분석 (read-only)
    ├── SOT 경계 분석
    ├── 누락·중복·충돌 식별
    └── EVIDENCE.md — Structure Analysis 섹션
    │
    ▼
[5] change-planner — PLAN.md 작성
    ├── 드리프트 수정 우선순위
    ├── ChangeBudget (문서 전용 — DBMig=No, MoneyAuth=No)
    ├── pre-EVIDENCE 계약 완료 여부 확인
    └── VerifyCmds 확정
    │
    ▼
[6] docs-change-communicator — 문서 갱신 (write 허용)
    ├── 최소 변경 원칙
    ├── 드리프트 수정
    ├── 참조 경로 수정
    └── INDEX.md 갱신
    │
    ▼
[7] verifier — VERIFY.md
    │
    ▼
[8] reviewer — REVIEW.md (Verdict: PASS/FAIL/PARTIAL)
```

---

## 문서 거버넌스 STOP 조건

| 조건 | 처리 |
|---|---|
| 드리프트 수정이 제품 코드 변경을 수반함 | STOP → fulfill-requirement로 전환 제안 |
| 문서 구조 변경이 routing 규칙 경로를 파괴함 | STOP → system-architect 검토 요청 |
| 시크릿·PII 드리프트 감지 | STOP → auth-security-privacy 즉시 에스컬레이션 |
| 범위 확장 (문서 → 기능 구현) | STOP, 분리 제안 |

---

## Task ID 패턴

문서 거버넌스 작업:
- `SW-DOCS-NNN`: 앱 문서 (docs/)
- `SW-CLI-NNN`: CLI/운영 레이어 문서 (.claude/, docs/agent/)
- `SW-INFRA-NNN`: 인프라·설정 문서

---

## 완료 조건

- VERIFY.md 존재 + 검증 명령 exit code 0
- REVIEW.md 존재 + Verdict PASS
- REVIEW.md에 PromptFit 섹션 존재
- `.ai/promptfit/INDEX.md`에 해당 task 한 줄 append
- 제품 코드 변경 없음 (= `git status --porcelain` 실측 제품 경로 0 · 구 compound-lint scope=ops_doc = deprecated)
- `EVIDENCE.md` 에 intake normalization / pre-EVIDENCE 계약 존재

공통 intake / reading order:
`docs/agent/process/REPO_FIRST_INTAKE_WORKFLOW.md`

---

## 사용 예시

```
/fulfill-doc-governance docs/agent/solutions/ 디렉터리가 비어있다 — 참조되는 핵심 문서들을 채워줘

/fulfill-doc-governance CLAUDE.md가 참조하는 파일 경로들이 실제로 존재하는지 전수 검사해줘

/fulfill-doc-governance .claude/agents/ 역할 목록과 routing-and-delegation.md 매핑이 일치하는지 감사해줘

/fulfill-doc-governance 운영 레이어 docs/agent/process/ 문서가 없다 — 워크플로 프로세스 문서를 만들어줘
```
