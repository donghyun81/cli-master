# Domain Roles — Navigation Index

> 모든 도메인 역할은 독립 에이전트 파일로 분리되었다.
> 이 파일은 generic 역할 목록 + repo-specific 역할 격리 섹션 + 새 역할 추가 기준을 담는다.
>
> **Repo 적용성**: 본 navigation index 의 generic 섹션은 모든 repo 에 propagation 가능하다.
> repo-specific 섹션은 `<!-- propagation: repo-only -->` 마커로 격리되며 propagation 시 제외된다.

---

## 코어 역할 (모든 repo 공통 — 항상 활성)

| 역할 | 파일 | 전문 영역 |
|---|---|---|
| intake-router | `.claude/agents/active/intake-router.md` | 트리아지 리드 |
| requirements-analyst | `.claude/agents/active/requirements-analyst.md` | 문제 구조화 |
| system-architect | `.claude/agents/active/system-architect.md` | 통합 아키텍트 |
| change-planner | `.claude/agents/active/change-planner.md` | 실행 조율 |
| verifier | `.claude/agents/active/verifier.md` | 기술적 타당성 |
| reviewer | `.claude/agents/active/reviewer.md` | 최종 기술 판정 |

## 도메인 분석 역할 — generic (모든 repo 공통, read-only)

| 역할 | 파일 | 전문 영역 |
|---|---|---|
| ux-auditor | `.claude/agents/active/ux-auditor.md` | UX 원칙 준수, 화면 상태 완전성 |
| backend-api-architect | `.claude/agents/deferred/backend-api-architect.md` | API 계약 안전성 |
| data-schema-guardian | `.claude/agents/deferred/data-schema-guardian.md` | DBMig 판정, 데이터 보존 |
| auth-security-privacy | `.claude/agents/active/auth-security-privacy.md` | 인증/PII/시크릿 위험 |
| performance-reliability-engineer | `.claude/agents/deferred/performance-reliability-engineer.md` | ANR/메모리/Rate limit |
| test-strategist | `.claude/agents/deferred/test-strategist.md` | 테스트 커버리지 공백 |
| observability-ops-analyst | `.claude/agents/deferred/observability-ops-analyst.md` | 관측성, PII 로그 |
| release-risk-manager | `.claude/agents/deferred/release-risk-manager.md` | 배포 위험, 롤백 전략 |

## 문서 거버넌스 역할 (모든 repo 공통, read-only — fulfill-doc-governance 전용)

| 역할 | 파일 | 전문 영역 |
|---|---|---|
| docs-drift-auditor | `.claude/agents/active/docs-drift-auditor.md` | 드리프트 감지, 참조 경로 감사 |
| docs-structure-architect | `.claude/agents/active/docs-structure-architect.md` | 문서 계층·SOT 경계 분석 |

## 구현 역할 (모든 repo 공통, write 허용)

| 역할 | 파일 | 전문 영역 |
|---|---|---|
| ui-implementer | `.claude/agents/active/ui-implementer.md` | UI/화면 구현 |
| server-implementer | `.claude/agents/deferred/server-implementer.md` | 백엔드 구현 |
| docs-change-communicator | `.claude/agents/active/docs-change-communicator.md` | DocSync, 문서 갱신 |
| code-simplifier | `.claude/agents/active/code-simplifier.md` | 구현 후 cleanup pass |

## 검증 보조 역할 (모든 repo 공통, read-only)

| 역할 | 파일 | 전문 영역 |
|---|---|---|
| layer-checker | `.claude/agents/active/layer-checker.md` | shared/domain I2 불변 원칙 위반 확인 |

<!-- propagation: repo-only -->
<!-- TODO: <REPO>-only 도메인 역할이 필요하면 propagation 후 자식 repo 에서 이 블록 안에 추가. master 에서는 비움. -->
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
2. 이 파일의 인덱스 테이블에 추가 (generic vs repo-only 구분)
3. `.claude/rules/routing-and-delegation.md` 매핑 갱신
4. `docs/agent/solutions/README.md` 역할표 갱신

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
