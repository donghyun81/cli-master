---
name: fulfill-requirement
description: Use to execute repo-first implementation workflow — intake→collect→plan→implement→verify→review for product code changes.
---

# Skill: fulfill-requirement

## Usage

```
/fulfill-requirement <추상 요구사항 한 줄>
```

또는 자연어로:
```
"<요구사항>을 구현해줘"
"<기능>이 필요해"
"<문제>를 해결해줘"
```

---

## 이 스킬이 하는 일

사용자가 추상 요구사항 한 줄을 제시하면, Claude Code가 다음을 자동으로 수행한다:

1. **Intake normalization**: intake-router가 작업 유형, reading order, requirement source, 정보 공백 3분류, STOP 위험, implementer entry를 먼저 고정
2. **TaskId 생성**: `<PREFIX>-<DOMAIN>-NNN` 형식
3. **Task 문서 생성**: `.ai/tasks/<taskId>.md`
4. **요구사항 구조화**: requirements-analyst가 실제 문제와 성공 조건을 명문화
5. **relevant read-only fan-out**: 필요한 전문가만 read-only로 선행 판단
6. **단계별 실행**: collect → plan → implement → verify → review
7. **산출물 생성**: `.ai/reports/<taskId>/` 아래 단계별 보고서
8. **완료 처리**: INDEX.md 갱신, DONE 판정

각 전문가는 앱 규칙(`.claude/rules/`)이 정한 경계 안에서 **자율적으로 판단**한다.
intake-router는 어떤 전문가가 필요한지 결정하며, 전문가에게 풀이 방법을 지시하지 않는다.
구현 역할은 pre-EVIDENCE 계약 완료 전 진입하지 않는다.

---

## 실행 흐름

```
사용자 입력: /fulfill-requirement <요구사항>
    │
    ▼
[1] intake-router — 트리아지 리드
    ├── Work Type / Reading Mode 판정
    ├── Requirement Source / Authority Boundary 확인
    ├── 정보 공백 분류 (`RESOLVABLE_IN_REPO` / `UNKNOWN` / `BLOCKED`)
    ├── 위험 신호 감지 (MoneyAuth, DBMig, Auth)
    │     └── 위험 감지 시 → [STOP]
    ├── 필수 reading order 조립
    ├── 필요한 read-only fan-out 결정
    ├── Implementer Entry 판정
    ├── TaskId 생성
    ├── .ai/tasks/<taskId>.md 생성
    └── .ai/reports/<taskId>/MODE.md 생성
    │
    ▼
[2] requirements-analyst — 문제 정의 전문가
    ├── 실제 문제 vs 표면 요청 구분
    ├── 숨은 제약, 측정 가능한 성공 조건 도출
    ├── 정보 공백 3분류와 확인 위치 명시
    └── EVIDENCE.md — Requirements Analysis 섹션
    │
    ▼ (병렬 실행 — 필요한 전문가만)
[3] relevant read-only fan-out — 각 전문 영역 독립 판단
    ├── ux-auditor: UX 원칙 준수, 상태 완전성
    ├── backend-api-architect: API 계약 안전성
    ├── data-schema-guardian: DBMig 판정 (Yes → STOP)
<!-- propagation: repo-only -->
    ├── billing-payments-guardian: MoneyAuth 판정 (Yes → STOP)
<!-- /propagation: repo-only -->
    ├── auth-security-privacy: 인증/PII 위험 (감지 → STOP)
    ├── performance-reliability-engineer: ANR/메모리 위험
    ├── test-strategist: 커버리지 공백, 회귀 위험
    └── 기타 필요 전문가
    │
    ▼
[4] system-architect — 통합 아키텍트
    ├── 전문가 분석 통합, 충돌 해결
    ├── 구현 단위 경계 확정 (병렬/순차 분류)
    └── EVIDENCE.md — Architecture Analysis 섹션
    │
    ▼
[5] change-planner — 조율 코디네이터
    ├── 전문가 제안을 실행 가능한 순서로 조직
    ├── ChangeBudget 확정
    ├── pre-EVIDENCE 계약 완료 여부 확인
    └── PLAN.md 생성
    │
    ▼
[6] 구현 전문가 (write 허용)
    ├── ui-implementer: 현재 repo UI 구현 패턴 준수
    ├── server-implementer: 현재 repo 백엔드 구현 패턴 준수 (시크릿 주입)
    └── 각 전문가의 자율 판단으로 구현 세부 결정
    │
    ▼ (구현 변경 시)
[6.5] docs-change-communicator — DocSync
    └── 문서-구현 드리프트 해소
    │
    ▼
[7] verifier — 기술적 타당성 평가
    ├── 실제 명령 실행 (최소 1개)
    ├── 성공 조건 충족 여부 기술 판단
    └── VERIFY.md 생성
    │
    ▼
[8] reviewer — 최종 기술 판정 (senior tech lead)
    ├── 회귀 위험, 아키텍처 건전성, 기술 부채 판단
    └── REVIEW.md — Verdict: PASS / FAIL / PARTIAL
    │
    ▼ (FAIL 시)
[REPLAN] change-planner → 구현 → verifier → reviewer (최대 2회)
    │
    ▼ (PASS 시)
[DONE] .ai/tasks/INDEX.md Status → DONE
```

---

## 전문가 자율성과 에스컬레이션

각 전문가는 자신의 도메인에서:
- **자율 판단**: 분석 방법, 위험 등급, 대안 비교, 권고안 제시
- **에스컬레이션**: 도메인 경계 밖 발견 시 → 해당 전문가 호출 또는 STOP

전문가가 STOP을 선언하면:
1. 현재 단계에서 즉시 멈춤
2. 감지 내용, 영향 경로, 다음 행동을 사용자에게 보고
3. 사용자 확인 없이 계속 진행하지 않음

---

## STOP 조건

| 조건 | 발생 역할 | 처리 |
|---|---|---|
| DBMig=Yes | data-schema-guardian | STOP, 사용자 승인 대기 |
| 인증 코드 변경 | auth-security-privacy | 즉시 STOP |
| 범위 확장 감지 | intake-router | STOP, 재설계 제안 |
| 2회 FAIL 루프 | reviewer | STOP, 사용자 판단 요청 |
| BLOCKED | 모든 역할 | 권한 부여 후 재실행 가능 |
<!-- propagation: repo-only -->
| MoneyAuth=Yes | billing-payments-guardian | 즉시 STOP, 상세 보고 |
<!-- /propagation: repo-only -->

---

## BLOCKED 종료

권한·환경 이슈에만 사용:
```
[BLOCKED] <이슈 설명>
재실행: 권한 부여 후 동일 프롬프트 재입력
필요한 것: <구체적 안내>
```

---

## 모델 비종속 운영 원칙

이 스킬과 모든 에이전트 역할은 특정 모델 버전에 종속되지 않는다:
- 에이전트 파일에 `model:` 버전 pinning 없음 (기본 상속)
- 역할의 판단 품질은 모델이 아니라 전문 판단 프레임, 규칙, 게이트로 보장한다
- 모델 교체 시 에이전트 파일 수정이 필요하지 않다

---

## verify/review 없이 종료 금지

다음이 완료되어야 DONE:
- VERIFY.md 존재 + 검증 명령 exit code 0
- REVIEW.md 존재 + Verdict PASS
- REVIEW.md 에 PromptFit 섹션 존재 (루브릭: `docs/agent/solutions/PROMPTFIT_RUBRIC.md`)
- `.ai/promptfit/INDEX.md` 에 해당 task 한 줄 append
- 2회 루프 후에도 FAIL → STOP → 사용자 판단 요청

---

## 템플릿 참조

- Task 문서 형식: `.claude/skills/fulfill-requirement/templates/task.md`
- 라우팅 참조: `.claude/skills/fulfill-requirement/routing-reference.md`
- 공통 intake / reading order: `docs/agent/process/REPO_FIRST_INTAKE_WORKFLOW.md`
- 역할 정의: `.claude/agents/`
- 세부 규칙: `.claude/rules/`

---

## 사용 예시

추상 요구사항 한 줄이면 충분하다. 스택·플랫폼 명칭은 사용자가 알 필요 없다.

```
/fulfill-requirement 저장 후 피드백 메시지가 화면에 표시되지 않는 버그를 수정해줘

/fulfill-requirement 구독 만료 후 프리미엄 기능 접근 시 업그레이드 안내로 이동하는 흐름을 추가해줘

/fulfill-requirement 공유 레이어에 핵심 도메인 모델을 정의해줘

/fulfill-requirement 앱 시작 시 3초 이상 걸리는 초기화 문제의 원인을 분석하고 개선 방향을 제안해줘

/fulfill-requirement 크래시 리포터에서 자주 발생하는 NullPointerException 의 근본 원인을 파악하고 수정해줘
```

<!-- propagation: repo-only -->
**현재 repo 컨텍스트가 반영된 예시** (`.claude/rules/` 참조):
- "무드 기록 화면" → SW-UI 도메인
- "구독/결제 흐름" → billing-payments-guardian STOP 트리거
- "공유 레이어 데이터 모델" → data-schema-guardian + system-architect
<!-- /propagation: repo-only -->
