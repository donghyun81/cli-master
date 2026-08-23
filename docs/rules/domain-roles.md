# Domain Roles — Navigation Index + agent→domain/rule 소유 매트릭스

> 모든 도메인 역할은 독립 에이전트 파일로 분리되었다.
> 이 파일은 generic 역할의 **agent→도메인/소유 SoT/상태·trigger/STOP 권한 매트릭스** + repo-specific 역할 격리 섹션 + 새 역할 추가 기준을 담는다.
>
> **Repo 적용성**: 본 navigation index 의 generic 섹션은 모든 repo 에 propagation 가능하다.
> repo-specific 섹션은 `<!-- propagation: repo-only -->` 마커로 격리되며 propagation 시 제외된다.
>
> **본 매트릭스 = agent→소유/consult rule·SoT 차원의 단일 SoT** (= MASTER-CLI-AGENT-ROLE-MATRIX-001 · 2026-06-02). 종전 정보는 4곳에 분산돼 있었다: ① 본 file 의 역할→파일→전문영역 nav index, ② `routing-and-delegation.md §전문영역→역할매핑`(= trigger→역할 routing 차원), ③ 개별 agent file 의 decision authority + SoT 참조, ④ `rule-routing-index.md §G`(= 사실→canonical rule). 본 매트릭스는 ②③④ 의 본문을 복제하지 않고 **없던 차원(agent→소유/consult SoT + 한 view 통합: active/deferred+trigger+STOP 권한)** 만 더한다.
>   - `routing-and-delegation.md §전문영역→역할매핑` = **trigger→역할 routing 차원 유지**(= 별 차원 · 본문 복제 X). 소유 SoT 상세는 본 매트릭스가 canonical.
>   - `rule-routing-index.md §G` = 사실→canonical rule(무변경). agent 소유 차원은 본 매트릭스가 SoT.
>   - 각 agent file 본문(Mission/decision authority)은 무변경. 본 매트릭스는 그 SoT 참조를 **색인할 뿐**이다.

---

## agent→domain/rule 소유 매트릭스 (25 agent 전수 · active 17 + deferred 8)

> 소유 SoT 열 = 각 agent file 의 실제 SoT 참조 + `routing-and-delegation.md` §DEFERRED 활성화 조건에서 도출(= 인용 · 발명 X). 도출 불가/모호 = `UNKNOWN(사유)`.
> STOP 권한 열 = 각 agent file `Must escalate when` 실측(= "즉시 STOP" = 도메인/안전 위험 직접 즉시 중단 권한 · "task-level STOP" = cleanup 한정 · "STOP(escalate)" = 조건 충족 시 상위 회수 · "—" = 독립 STOP 없음 = Evaluator FAIL/PARTIAL 또는 handoff).
> 경로는 repo-root 기준. (보호) = 보호 5종 byte-identical 영역.

| 분류 | 역할 (agent) | 파일 | 전문 영역 | 상태 · 활성화 trigger | 소유 · consult rule·SoT | STOP 권한 |
|---|---|---|---|---|---|---|
| 코어·파이프라인 (항상 활성) | intake-router | `.claude/agents/active/intake-router.md` | 트리아지 리드 | active | 소유 `routing-and-delegation.md`(triage·위임) · consult `supabase-handling.md §6`·`auth-rules.md §7`(키워드 routing)·`cycle-discipline.md §17`(BASELINE) | 즉시 STOP (MoneyAuth·DBMig·비가역·범위폭발·미지 상태) |
| 코어·파이프라인 (항상 활성) | requirements-analyst | `.claude/agents/active/requirements-analyst.md` | 문제 구조화 | active | consult `routing-and-delegation.md`(Planner)·`reporting.md §4`(EVIDENCE Requirements Analysis) | STOP(escalate) (불변 원칙 위반 → intake-router) |
| 코어·파이프라인 (항상 활성) | system-architect | `.claude/agents/active/system-architect.md` | 통합 아키텍트 | active | consult `routing-and-delegation.md`(Planner·설계 경계)·`.claude/rules/**`(아키텍처 컨텍스트) | STOP(escalate) (레이어 위반·범위 초과) |
| 코어·파이프라인 (항상 활성) | change-planner | `.claude/agents/active/change-planner.md` | 실행 조율 | active (write) | 소유 `reporting.md §5`(PLAN 10-section 산출) · consult `workflow-core.md §implement`(SoftBudget)·`routing-and-delegation.md`(Planner) | STOP(escalate) (MoneyAuth/DBMig·SoftBudget 심각 초과) |
| 코어·파이프라인 (항상 활성) | verifier | `.claude/agents/active/verifier.md` | 기술적 타당성 | active (Bash) | 소유 `verification-and-review.md §/verify` · consult `reporting.md §6`(VERIFY) | 즉시 STOP (예상 외 파일 변경·시크릿/PII 노출) |
| 코어·파이프라인 (항상 활성) | reviewer | `.claude/agents/active/reviewer.md` | 최종 기술 판정 | active | 소유 `verification-and-review.md`(12-section 체크리스트) · consult `reporting.md §7`(REVIEW schema)·`ux-laws.md §6`(§B) | 즉시 STOP (시크릿 노출) |
| 도메인 분석 (read-only) | ux-auditor | `.claude/agents/active/ux-auditor.md` | UX 원칙 준수, 화면 상태 완전성 | active | 소유 `ui-ux-analysis.md` · consult `ux-laws.md`(§5 매트릭스·§3 dark pattern) | — (billing/auth/domain-policy 연동 escalate) |
| 도메인 분석 (read-only) | auth-security-privacy | `.claude/agents/active/auth-security-privacy.md` | 인증/PII/시크릿 위험 | active | 소유 `auth-rules.md` · consult `safety-and-secrets.md` | 즉시 STOP (인증 코드·PII 추가·시크릿 로깅·HTTP·평문 토큰) |
| 도메인 분석 (read-only) | billing-payments-guardian | `.claude/agents/active/billing-payments-guardian.md` | 결제/구독/IAP/entitlement 보호 | active | 소유 `billing-rules.md`(§7 STOP) · consult `deferred-domains.md §2`·`safety-and-secrets.md`·`ux-laws.md §3.4` | 즉시 STOP (결제/IAP/entitlement·Edge Function 우회·시크릿) |
| 도메인 분석 (read-only) | test-strategist | `.claude/agents/active/test-strategist.md` | 테스트 ROI 우선순위·여러 경우 완전성·피라미드 적정성·회귀 위험 | active | 소유 `docs/agent/architecture/TESTING_STRATEGY.md` · consult `TDD_WORKFLOW.md`·`TESTABILITY_SEAMS.md` | — (고위험 도메인 무테스트 → reviewer §7 회귀 신호) |
| 도메인 분석 (read-only) | backend-api-architect | `.claude/agents/deferred/backend-api-architect.md` | API 계약 안전성 | deferred · trigger: API 연동 시작 시 | `deferred-domains.md §1`(Backend STOP) · consult `supabase-handling.md` · (API 연동 시 `<api>-rules.md` 신설) | STOP (Backend 도메인 감지 · deferred-domains §1) |
| 도메인 분석 (read-only) | data-schema-guardian | `.claude/agents/deferred/data-schema-guardian.md` | DBMig 판정, 데이터 보존 | deferred · trigger: Room DB 도입 시 | `deferred-domains.md §1`(Data STOP) · (DB 도입 시 `<data>-rules.md` 신설) | 즉시 STOP (DB schema/migration 감지) |
| 도메인 분석 (read-only) | performance-reliability-engineer | `.claude/agents/deferred/performance-reliability-engineer.md` | ANR/메모리/Rate limit | deferred · trigger: 성능 정책 정의 시 | `deferred-domains.md §1`(Perf STOP) — Perf = rule 부재(`rule-routing-index.md §A L3`) | 즉시 STOP (메인 스레드 차단·무한 루프·무한 재시도) |
| 도메인 분석 (read-only) | observability-ops-analyst | `.claude/agents/deferred/observability-ops-analyst.md` | 관측성, PII 로그 | deferred · trigger: 옵저버빌리티 설정 시 | UNKNOWN(관측성 도메인 rule 미신설) · consult `safety-and-secrets.md`(PII 로깅) | 즉시 STOP (PII 로깅 감지) |
| 도메인 분석 (read-only) | release-risk-manager | `.claude/agents/deferred/release-risk-manager.md` | 배포 위험, 롤백 전략 | deferred · trigger: 첫 릴리스 빌드 준비 시 | UNKNOWN(릴리스 도메인 rule 미신설) · 활성화 `deferred-domains.md §4` | — (배포 위험 분석 · 직접 STOP 없음) |
| 도메인 분석 (read-only) | domain-policy-analyst | `.claude/agents/deferred/domain-policy-analyst.md` | 도메인 정책 충돌·불변 원칙 | deferred · trigger: 도메인 정책 문서 작성 시 | UNKNOWN(도메인 정책 rule 미신설 · 활성화 시 신설) · 활성화 `deferred-domains.md §4` | 즉시 STOP (도메인 정책 영역 감지) |
| 도메인 분석 (read-only) | sync-offline-state-specialist | `.claude/agents/deferred/sync-offline-state-specialist.md` | 오프라인/동기화/충돌 해결 | deferred · trigger: 오프라인 지원 구현 시 | `deferred-domains.md §1`(Data·오프라인 STOP) — offline rule 미신설 | 즉시 STOP (오프라인/동기화 영역 감지) |
| 문서 거버넌스 (read-only · fulfill-doc-governance) | docs-drift-auditor | `.claude/agents/active/docs-drift-auditor.md` | 드리프트 감지, 참조 경로 감사 | active | consult `docs/agent/process/DOC_GOVERNANCE_WORKFLOW.md`·`DOC_TASK_TYPES.md` | STOP(escalate) (수정이 제품 코드 수반) · 시크릿 드리프트 → auth-security-privacy |
| 문서 거버넌스 (read-only · fulfill-doc-governance) | docs-structure-architect | `.claude/agents/active/docs-structure-architect.md` | 문서 계층·SOT 경계 분석 | active | consult `docs/agent/process/DOC_GOVERNANCE_WORKFLOW.md`·`DOC_TASK_TYPES.md` | STOP(escalate) (제품 코드 수반·routing 경로 파괴) |
| 구현 (write) | ui-implementer | `.claude/agents/active/ui-implementer.md` | UI/화면 구현 | active (write) | 소유 `ui-ux-analysis.md` · consult `pencil-uiux-workflow.md §3`(보호 · Pencil gate) | 즉시 STOP (.pen 부재 gate FAIL·SoftBudget 초과) |
| 구현 (write) | server-implementer | `.claude/agents/deferred/server-implementer.md` | 백엔드 구현 | deferred · trigger: Supabase Edge Functions 등 서버 연동 시작 시 | `supabase-handling.md`(서버 SoT) · consult `safety-and-secrets.md §역할별 경로`([DEFERRED] server/) | — (deferred · 활성화 시 재평가) |
| 구현 (write) | docs-change-communicator | `.claude/agents/active/docs-change-communicator.md` | DocSync, 문서 갱신 | active (write) | 소유 `cycle-discipline.md §20`(DocSync paradigm) · consult `reporting.md` | STOP(escalate) (문서 갱신이 구현 변경 수반) |
| 구현 (write) | code-simplifier | `.claude/agents/active/code-simplifier.md` | 구현 후 cleanup pass | active (Edit) | 소유 `legacy-cleanup-governance.md` | task-level STOP (auth/payment/privacy 경로·wiring 제거) |
| 검증 보조 (read-only) | layer-checker | `.claude/agents/active/layer-checker.md` | shared/domain I2 불변 원칙 위반 확인 | active (Bash) | `docs/agent/architecture/MODEL_SEPARATION.md`(I2 불변) · consult `docs/agent/architecture/PROPAGATION_PARAMETERS.md`(repo-config) | — (Evaluator · FAIL/PARTIAL · 고치지 않음) |
| Cross-repo 조율 (read-only · Task) | cross-repo-orchestrator | `.claude/agents/active/cross-repo-orchestrator.md` | cross-repo 라우팅·sub-agent fan-out·정합 | active (Task) | 소유 `cross-repo-parallel-exec.md` · consult `cycle-discipline.md §21`·`routing-and-delegation.md §실행`·`reporting.md §9`·`.auto-memory/protected-file-hashes.md` | 즉시 STOP (보호 5 sha drift·HIGH RISK 도메인 진입) |

> **reconcile 기록** (MASTER-CLI-AGENT-ROLE-MATRIX-001 · disk 실측): 종전 nav index 21 행 → 본 매트릭스 25 행. 신규 등재 4 = active 2 (`billing-payments-guardian`·`cross-repo-orchestrator`) + deferred 2 (`domain-policy-analyst`·`sync-offline-state-specialist`). 4 모두 5-repo(`master`+`app-foundation`+`GB`+`GD`+`GT`) 측 `.claude/agents/` 에 실재(byte-identical 전수) = generic 정합 → 아래 repo-only 블록 대상 아님.

<!-- propagation: repo-only -->
<!-- TODO: <REPO>-only 도메인 역할이 필요하면 propagation 후 자식 repo 에서 이 블록 안에 추가. master 에서는 비움. -->
<!-- 현재 master = 25 agent 전수 generic(4-repo byte-identical). 진짜 repo-specific agent(자식에만 존재 · master 부재) = 0 → 본 블록 비움 유지. 자식이 자기 도메인 전용 agent 를 신설하면 본 블록에 추가하고 위 매트릭스 형식(소유 SoT·상태·STOP 권한)으로 1행 등재한다. -->
<!-- /propagation: repo-only -->

---

## 역할 독립 파일 분리 기준

역할을 독립 `.claude/agents/<role>.md` 파일로 만들어야 하는 기준 (우선순위 순):

1. **고유한 판단 프레임** — 다른 역할의 판단 프레임과 명확히 다른 전문 관점이 있는가
2. **고위험 도메인** — MoneyAuth/DBMig/Auth/비가역 변경 등 즉시 STOP 권한이 있는가
3. **독립 에스컬레이션** — 독립적인 STOP 조건과 사용자 보고 시나리오가 있는가
4. **별도 도구/권한** — read-only vs write-enabled, 또는 Bash 실행 권한 분리가 필요한가

**"월 N회" 호출 빈도는 보조 신호**다 — 고위험 역할은 드물게 호출되더라도 독립 파일이어야 한다.

---

## 새 역할 추가 방법

1. `.claude/agents/<role-name>.md` 생성 (전문가 프레임 형식)
2. 이 파일의 **매트릭스에 1행 추가** (generic vs repo-only 구분 · 소유 SoT·상태·STOP 권한 열 disk 실측 채움)
3. `docs/rules/routing-and-delegation.md` 매핑 갱신 (trigger→역할 차원)

> 역할표 = step 2 의 본 file 매트릭스 단일. 직전 `docs/agent/solutions/README.md` 역할표는 본 매트릭스로 흡수됨 (= 부재 file · MASTER-CLI-AGENT-ROLE-MATRIX-001).

### 역할 파일 필수 섹션

```markdown
---
name: <role-name>
description: <언제 호출하는가 — 조건 명확히. 이 역할이 없으면 무엇이 안전하지 않은가.>
tools: [Read, Glob, Grep]  # 최소 권한. write 역할만 Write, Edit 추가.
---

## Mission
## Use when
## Think like
## Key questions
## Decision authority (자율 / NOT 결정)
## Must escalate when
## Evidence to gather
## Expected outputs
```

---

## 명시 cycle 이력

- 2026-06-02 · MASTER-CLI-AGENT-ROLE-MATRIX-001 · agent→domain/rule 소유 매트릭스 신설(= 종전 5 분산 nav 표 → 단일 25행 매트릭스 · 신 차원: 도메인/상태+활성화 trigger/소유·consult SoT/STOP 권한). 25 agent 전수(active 17 + deferred 8) · 신규 등재 4(active `billing-payments-guardian`·`cross-repo-orchestrator` + deferred `domain-policy-analyst`·`sync-offline-state-specialist`) reconcile. 소유 SoT 열 = 각 agent file 실측 인용(발명 X · 모호 = UNKNOWN). routing-and-delegation §전문영역→역할매핑(trigger→역할) + rule-routing-index §G(사실→rule) = 별 차원 무변경(본문 복제 0). agent file 본문 무변경(색인만). repo-only 블록 = 비움 유지(진짜 repo-specific agent 0 · disk 실측). 보호 5종 무접촉.
