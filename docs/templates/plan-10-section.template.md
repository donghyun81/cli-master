# PLAN.md 10-section 스키마 template

> **출처**: `reporting.md` §5 verbatim 이전 (= MASTER-CLI-CONTEXT-DIET-2-001 T3 · 2026-07-10). 형식 SoT = 본 file · `reporting.md` §5 = pointer.
> **Read 시점**: Risk ≥ Medium cycle 만 (Low Risk = GATESv2+ChangeBudget+VerificationPlan+작업 목록 경량 · 템플릿 Read 불요).
> **N/A 처리 (T3 개정)**: 해당 없는 섹션 = 개별 나열 대신 말미 1줄 집계 허용 (예: `N/A: §3·§4·§5·§6·§7·§10`) — 섹션 판단 의무 자체는 불변.

---

## §5 PLAN.md 형식 (10-section 정규 스키마)

> 각 섹션은 이름이 있는 독립 관심사다. 해당하지 않으면 `N/A` 명시 — 섹션 삭제 금지.

```markdown
## GATESv2
| Field | Value |
|---|---|
| TaskId | ... |
| Mode | ... |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | .ai/tasks/<taskId>.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | N |
| Modules | ... |
| Risk | Low / Medium / High |
| DBMig | Yes / No |
| MoneyAuth | Yes / No |

## 2. DependencyDecision
_libs.versions.toml 변경이 없으면 `N/A` 명시. 변경이 있으면 라이브러리별 8개 항목 모두 기술._

| 항목 | 값 |
|---|---|
| Library | N/A |
| ①공식·표준 지위 | N/A |
| ②유지보수 품질 | N/A |
| ③KMP·CMP 호환 | N/A |
| ④transitive 비용 | N/A |
| ⑤기존 기능 중복 여부 | N/A |
| ⑥제거 난이도 | N/A |
| ⑦직접 구현 대비 우위 | N/A |
| ⑧UI 라이브러리 특별 정당화 | N/A |

## 3. ArchitectureImpact
_새 인터페이스·추상화 없으면 `N/A` 명시._

- 새 인터페이스/추상화: N/A
- 변동성 경계 유형: N/A
- 레이어 누수 위험: N/A
- shared-first 경계 영향: N/A

## 4. ModelBoundaryPlan
_모델 레이어 분리 변경 없으면 `N/A` 명시._

- DTO 변경: N/A
- Entity 변경: N/A
- DomainModel 변경: N/A
- UiState 변경: N/A
- 경계 매핑 추가/변경 (Repository·UseCase·ViewModel 위치): N/A
- I2 import 방향 영향: N/A

## 5. ErrorPolicy
_새 UseCase·Repository 작성 없으면 `N/A` 명시._

- typed Result 사용 여부: N/A
- 오류 모델 (sealed class/interface 명): N/A
- 기존 코드 교체 범위: N/A (전면 교체는 범위 초과 — 별도 task)

## 6. UIStateFlowPlan
_UI 또는 ViewModel 변경 없으면 `N/A` 명시._

- UiState 변경: N/A
- ViewModel 단방향 흐름 유지: N/A
- SharedUiState<T> 변형 사용: N/A

## 7. TestabilitySeams
_테스트 변경 없으면 `N/A` 명시. 있으면 새 테스트 파일명과 FakeXxx 여부 필수 명시._

- 테스트 파일: N/A
- FakeXxx 사용: N/A
- 심 주입 대상 (clock·dispatcher·identity·logger·uuid): N/A
- 심 연기 시 명시적 사유: N/A

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `./gradlew test` (예시 — 실행 가능 명령만 기입) |

> **Risk 기반 경량화**: Low Risk task는 §1 GATESv2, §2 ChangeBudget, §9 VerificationPlan + 작업 목록만 필수. 나머지 N/A. Medium 이상은 전체 10-section 필수.

## 9. RollbackStrategy
_문서 전용 변경: "git revert <commit>으로 즉시 복구 가능" 명시._
_제품 코드 변경: 아래 항목 모두 기술 필수 (N/A 불허)._

- 롤백 가능 지점: N/A
- 롤백 조건 (언제 실행하는가): N/A
- 복구 경로 (롤백 후 다음 단계): N/A

## 10. ExternalPrep / DeferredItems
_외부 의존 연기 항목 없으면 `N/A` 명시._

- 연기 항목: N/A
- user-prep 선행 조건: N/A
- stub/TODO(user-prep) 위치: N/A

## Plan

1. ...
2. ...

## Notes
```

