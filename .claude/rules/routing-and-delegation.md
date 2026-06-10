# Routing and Delegation Rules

> intake-router가 이 규칙을 기준으로 전문가를 선택·위임한다.
> SOT: `CLAUDE.md` | 역할 정의: `.claude/agents/{active,deferred}/`

---

## 라우팅 철학

intake-router는 키워드 분류기가 아니다 — **어떤 전문 판단이 필요한가**를 결정하는 트리아지 리드다.
또한 prompt 수신 직후 intake normalization을 수행해 reading order와 implementer entry gate를 먼저 잠근다.

라우팅 질문은 "이 요구사항에 어떤 단어가 포함되었는가"가 아니라:
1. 이 변경이 어떤 **위험 경로**를 건드리는가?
2. **어떤 전문가의 판단**이 없으면 이 변경이 안전하지 않은가?
3. 전문가들이 **병렬**로 일할 수 있는가, 아니면 **순차**가 필요한가?
4. repo 안에서 더 읽어서 풀 수 있는 공백(`RESOLVABLE_IN_REPO`)이 남아 있는가?

공통 intake 절차와 task-aware reading order:
`docs/agent/process/REPO_FIRST_INTAKE_WORKFLOW.md`

---

## 즉시 STOP 트리거 (위험 감지 시 최우선)

| 위험 감지 | 역할 | 처리 |
|---|---|---|
| 인증/PII/시크릿 변경 | auth-security-privacy | STOP → 사용자 확인 |
| DB 스키마/마이그레이션 | data-schema-guardian | STOP → 사용자 승인 대기 |
| 비가역 변경(파일삭제, override) | intake-router 직접 | 즉시 STOP |
| 범위 확장 감지 | intake-router 직접 | STOP, 재설계 제안 |
<!-- propagation: repo-only -->
| 결제/과금/구독/entitlement 경로 | billing-payments-guardian | 즉시 STOP → 사용자 확인 |
<!-- /propagation: repo-only -->

---

## 전문 영역 → 역할 매핑

### 분석 전문가 (병렬 실행 가능 — read-only)

| 필요한 전문 판단 | 역할 | 파일 |
|---|---|---|
| 요구사항 구조화, 숨은 제약 식별 | requirements-analyst | `.claude/agents/active/requirements-analyst.md` |
| UX 원칙 준수, 화면 상태 완전성 | ux-auditor | `.claude/agents/active/ux-auditor.md` |
| [DEFERRED] API 계약 안전성, Breaking change | backend-api-architect | `.claude/agents/deferred/backend-api-architect.md` |
| [DEFERRED] 데이터 보존, 마이그레이션 위험 | data-schema-guardian | `.claude/agents/deferred/data-schema-guardian.md` |
| 인증/PII/시크릿 노출 | auth-security-privacy | `.claude/agents/active/auth-security-privacy.md` |
| [DEFERRED] ANR/메모리/Rate limit 위험 | performance-reliability-engineer | `.claude/agents/deferred/performance-reliability-engineer.md` |
| 테스트 ROI 우선순위, 여러 경우 완전성, 회귀 위험 | test-strategist | `.claude/agents/active/test-strategist.md` |
| [DEFERRED] 관측성, 로그 안전, 크래시 추적 | observability-ops-analyst | `.claude/agents/deferred/observability-ops-analyst.md` |
| [DEFERRED] 배포 위험, 롤백 전략 | release-risk-manager | `.claude/agents/deferred/release-risk-manager.md` |
<!-- propagation: repo-only -->
| [DEFERRED] 비즈니스 정책, 불변 원칙 충돌 | domain-policy-analyst | `.claude/agents/deferred/domain-policy-analyst.md` |
| 결제 플로우, entitlement 보호 | billing-payments-guardian | `.claude/agents/active/billing-payments-guardian.md` |
| [DEFERRED] 오프라인/동기화/충돌 해결 | sync-offline-state-specialist | `.claude/agents/deferred/sync-offline-state-specialist.md` |
<!-- /propagation: repo-only -->

### 통합/조율 전문가 (순차)

| 역할 | 언제 호출하는가 |
|---|---|
| system-architect | 여러 모듈 영향, 설계 충돌, 구현 단위 경계 확정 |
| change-planner | 전문가 분석 완료 후 PLAN.md 작성, FAIL 후 재계획 |
| docs-change-communicator | 구현 완료 후 DocSync 단계 |

### 문서 거버넌스 전문가 (read-only — fulfill-doc-governance 스킬 전용)

| 역할 | 파일 | 언제 호출하는가 |
|---|---|---|
| docs-drift-auditor | `.claude/agents/active/docs-drift-auditor.md` | 참조 경로 감사, 드리프트 감지, 문서-실물 불일치 확인 |
| docs-structure-architect | `.claude/agents/active/docs-structure-architect.md` | 문서 계층 결정, SOT 경계 분석, 누락·중복 식별 |

> 문서 거버넌스 작업 흐름: `docs/agent/process/DOC_GOVERNANCE_WORKFLOW.md`
> 작업 유형 분류: `docs/agent/process/DOC_TASK_TYPES.md`

### 구현 전문가 (순차 — write 허용)

| 역할 | 언제 호출하는가 |
|---|---|
| ui-implementer | PLAN 확정 후 현재 repo UI 구현 패턴 변경 |
| server-implementer | PLAN 확정 후 현재 repo 백엔드/서버 구현 패턴 변경 |
| code-simplifier | 구현 완료 후 cleanup pass — 미사용 import/데드 코드/네이밍 일관성 검사 (SoftBudget Low) |

### 검증 보조 (read-only)

| 역할 | 파일 | 언제 호출하는가 |
|---|---|---|
| layer-checker | `.claude/agents/active/layer-checker.md` | shared/domain I2 불변 원칙 위반 확인, app→shared 단방향 흐름 검증 |

### 검증/판정 (항상 마지막)

| 역할 | 순서 |
|---|---|
| verifier | 구현 완료 후 → VERIFY.md |
| reviewer | VERIFY.md 존재 확인 후 → REVIEW.md |

### DEFERRED 역할

아래 역할은 해당 기능 미구현 상태로 비활성. 각 agent 파일에 활성화 조건 명시.
기능 도입 시 개별 agent 파일을 복원하고 이 테이블에서 [DEFERRED] 제거.

**비활성 목록:**
- domain-policy-analyst — 도메인 정책 문서 작성 시
- sync-offline-state-specialist — 오프라인 지원 구현 시
- server-implementer — Supabase Edge Functions 등 서버 연동 시작 시
- backend-api-architect — API 연동 시작 시
- data-schema-guardian — Room DB 도입 시
- performance-reliability-engineer — 성능 정책 정의 시
- observability-ops-analyst — 옵저버빌리티 설정 시
- release-risk-manager — 첫 릴리스 빌드 준비 시

---

## Planner / Generator / Evaluator 경계

장기 실행 harness 에서 품질이 유지되려면 **계획하는 역할**, **만드는 역할**, **판정하는 역할**
이 서로 다른 관점을 유지해야 한다. 같은 역할이 두 bucket 을 겸하면 self-cite 루프가 생기고
약한 근거도 강해 보이기 시작한다.

| Bucket | 관점 | 소속 역할 | 출력물 |
|---|---|---|---|
| Planner | "어떤 단위로 나누고 어떤 순서로 할 것인가" | intake-router, requirements-analyst, system-architect, change-planner, release-risk-manager | MODE.md, EVIDENCE.md(pre), PLAN.md |
| Generator | "이 단위를 실제로 만든다" | ui-implementer, server-implementer, docs-change-communicator, code-simplifier | 제품 코드·문서 diff, EVIDENCE.md(post) |
| Evaluator | "만들어진 것이 목적을 충족하는가, 회귀 위험은 없는가" | verifier, reviewer, layer-checker, 그리고 read-only 분석 11 종 (ux-auditor, backend-api-architect [DEFERRED] 등 · §분석 전문가 표 [DEFERRED] 표기 정합) | VERIFY.md, REVIEW.md, 분석 리포트 |

교차 권한 금지 규칙:

1. **Planner 는 검증하지 않는다**: change-planner 가 "이 변경은 안전하다" 고 결론 내려도
   reviewer 는 그 문장을 그대로 근거로 삼지 않는다. reviewer 는 independent 관점으로 다시
   서술한다.
2. **Generator 는 스스로 PASS 를 부여하지 않는다**: implementer 가 내놓은 diff 에 대해
   같은 task 내에서 implementer 가 "문제 없음" 을 선언할 수 없다. Evaluator 통과 없이
   DONE 처리 금지.
3. **Evaluator 는 고치지 않는다**: verifier/reviewer/read-only 분석 역할은 직접 코드를
   수정하지 않는다. FAIL/PARTIAL 판정 + 구체적 수정 방향 제시 후 change-planner 루프로
   돌려보낸다.
4. **같은 prompt 재사용 금지**: Planner 가 작성한 PLAN.md 문장을 Evaluator 가 근거 텍스트
   로 그대로 복사하면 self-cite 다. Evaluator 는 자신의 관찰 근거(file:line, exit code)를
   중심으로 판정한다.
5. **skeptic evaluator tuning**: reviewer 는 약한 근거부터 의심한다. 상세는
   `.claude/agents/active/reviewer.md` 의 "Skeptic Evaluator Tuning" 참조.

---

## 실행 방식 규칙

### 병렬 실행 가능 조건 (모두 충족)
- read-only 분석 단계
- same-file 충돌 없음
- 공유 상태(shared state) 없음
- MoneyAuth/DBMig/Auth risk 없음

### 순차 실행 필수 조건 (하나라도 해당)
- 같은 파일 수정 가능성
- 공유 상태 또는 DB/스키마 변경
- Money/Auth 영향 경로
- 선행 단계 결과가 다음 단계 인풋

역할별 경로 스코핑: `.claude/rules/safety-and-secrets.md` "## 역할별 경로 허용 매트릭스" 참조.

### Cross-repo 영역 (= 6-repo · master + app-foundation + GB + GD + GT + gently-product-docs) — 2026-05-19 신설

> 본 sub-section = `MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001` 안 추가. cross-repo 영역 본질 발견 시점 본 sub-section 정합 + `.claude/rules/cross-repo-parallel-exec.md` SoT reading 의무.

#### cross-repo paradigm 분기 (= cli session 자율 판단 default)

| paradigm | 진입 조건 | 호출 방식 |
|---|---|---|
| **영역 1** (= 단일 cli session 측 sub-agent 병렬) | 가벼운 cross-repo 정합 영역 + 동족 자식 측 동일 paradigm 신설 + cli infra propagation cycle | `cross-repo-orchestrator` sub-agent 호출 → 자식별 Task tool sub-agent fan-out + return 통합 |
| **영역 2** (= 다중 cli session 운영) | 단일 자식 측 무거운 IMPL + 다른 자식 무접촉 + 자식별 도메인 specific cycle 동시 운영 | 사용자 본인 측 terminal × cli session ×N · cross-repo 정합 책임 = 사용자 영역 |

paradigm 선택 본심 = cli session 측 자율 판단 default (= 사용자 본심 정합 = 요청사항 본질 측정 후 paradigm 선택). 본 분기 본문 단일 SoT = `.claude/rules/cross-repo-parallel-exec.md` §2 정합.

#### cross-repo sub-agent (= cross-repo-orchestrator)

cross-repo 영역 본질 발견 시점 (= 키워드: "6-repo" / "5-repo" / "3 자식" / "GB + GD + GT" / "cross-repo" / "동족 자식" / "병렬" / "fan-out" / "byte-identical" / "propagation" 등) `cross-repo-orchestrator` sub-agent 호출 default. 본 sub-agent 측 routing 본질:

- `intake-router.md` 측 **단일 repo routing paradigm** 측 cross-repo 측 확장 영역 default (= 2 영역 분리 paradigm 정합)
- 본 sub-agent 측 직접 해법 결정 X (= routing + 통합 영역 단일 default · Planner 경계 정합)
- 자식별 sub-agent fan-out 측 cwd 분리 paradigm 의무 (= `cross-repo-parallel-exec.md` §3 정합)
- sub-agent return 측 Subagent Return Contract 정합 의무 (= `reporting.md` §9 정합 · ≤ 4k token / 5 섹션 의무)

#### cross-repo 영역 STOP 조건

| trigger | mitigation |
|---|---|
| 보호 5 file sha drift 발견 (= 자식별 sub-agent 측정 결과 mismatch) | 즉시 STOP + 사용자 회수 default |
| 자식별 sub-agent 결과 본질 어긋남 (= 동족 자식 측 paradigm 정합 측 mismatch) | STOP + 사용자 회수 default |
| cross-repo 영역 측 HIGH RISK 도메인 진입 (= DB migration / Money / Auth / production push 영향) | 즉시 STOP default |
| sub-agent return body 측 raw output 그대로 (= 4k token 한도 초과) | sub-agent 재 호출 + return 본문 압축 의무 |

---

## 전문가 호출 흐름

```
abstract requirement
    ↓
intake-router — 작업 유형 / reading order / 위험 신호 / implementer entry 판단
    ↓
[위험 감지 시 즉시 STOP]
    ↓
requirements-analyst — 실제 문제 진술, 요구사항 출처, 숨은 제약, 공백 분류
    ↓
[relevant read-only agents fan-out — 필요한 전문가만]
    ↓
system-architect — 전문가 분석 통합, 구현 단위 경계
    ↓
change-planner — PLAN.md 작성, 실행 순서 조율
    ↓
[구현 전문가 — pre-EVIDENCE 계약 완료 후에만 진입]
    ↓
verifier → VERIFY.md
    ↓
reviewer → REVIEW.md
    ↓
(FAIL 시) → change-planner / system-architect 루프
```

구현 역할 직행 금지:

- implementer는 `EVIDENCE.md` 의 intake normalization / pre-EVIDENCE 계약이 채워지기 전 호출하지 않는다
- low-risk 단건 수정이라도 read-only 판단이 `N/A` 인지 명시해야 한다

---

## STOP 자동 트리거 조건

| 감지 | 처리 |
|---|---|
| MoneyAuth=Yes | 즉시 STOP, 근거와 영향 경로 기록 |
| DBMig=Yes | 사용자 명시 승인 대기 |
| 범위 확장 감지 | STOP, 재설계 제안 |
| 비가역 변경 징후 | STOP, 자동 수정 금지 |

---

## 전문가를 추가하는 방법

새 역할을 독립 파일로 만들어야 하는 기준 (우선순위 순):

1. **고유한 판단 프레임** — 다른 역할과 명확히 다른 전문 관점이 있는가
2. **고위험 도메인** — STOP 권한, 비가역 변경, 사용자 확인 시나리오가 있는가
3. **독립 에스컬레이션** — 독립적인 STOP 조건과 보고 흐름이 필요한가
4. **별도 도구/권한** — read-only vs write-enabled 분리가 필요한가

위 기준 중 하나라도 해당하면 독립 파일:
1. `.claude/agents/active/<role>.md` 신규 파일 생성 (DEFERRED 인 경우 `.claude/agents/deferred/<role>.md`) (전문가 프레임 형식)
2. 이 파일 매핑 테이블에 독립 파일 경로 반영
3. `.claude/rules/domain-roles.md` 의 agent→domain/rule 소유 매트릭스 갱신 (= 직전 `docs/agent/solutions/README.md` 역할표 흡수 · 부재 file · MASTER-CLI-AGENT-ROLE-MATRIX-001)

"호출 빈도"는 보조 신호다 — 고위험 역할은 드물게 호출되더라도 독립 파일이어야 한다.

---

## agent teams 승격 기준 (옵션)

기본값은 subagents + skills + hooks 조합이다.
아래 조건을 **동시에** 만족할 때만 teams 검토:

1. 3개 이상 완전 독립 트랙 존재
2. 직접 상호 메시징 또는 공유 task list가 유리
3. same-file 충돌 가능성 낮음
4. 순차 의존보다 병렬 탐색 가치가 큼

위 조건 미충족 시 teams를 사용하지 않는다.
teams 사용 조건 상세: `docs/agent/solutions/README.md`
