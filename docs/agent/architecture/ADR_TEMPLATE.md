# ADR-NNNN: <짧은 결정 제목>

> 이 문서는 Architectural Decision Record (ADR) 의 공통 템플릿이며 multi-repo propagation 대상이다.
> byte-identical 로 복사되며 repo 고유 정보는 포함하지 않는다.
> 사용법: 새 ADR 을 만들 때 이 파일을 복사한 뒤 `NNNN` 을 순번으로, 제목/섹션 내용을 채운다.
> 저장 위치는 각 repo 가 결정한다 (예: `docs/adr/NNNN-<slug>.md`).

---

## Status

<!-- 아래 중 하나. status 전이는 단방향이 원칙이며 변경 시 날짜와 사유를 남긴다. -->
- `Proposed` — 초안, 아직 채택되지 않음
- `Accepted` — 채택됨, 현재 운영 중
- `Deprecated` — 더 이상 권장되지 않음 (대체 ADR 링크 필수)
- `Superseded by ADR-MMMM` — 대체됨
- `Rejected` — 채택되지 않음 (이유 기록)

**Date (KST)**: YYYY-MM-DD
**Deciders**: <역할 이름만. 실명/이메일 금지>
**Related TaskId**: `<PREFIX>-<DOMAIN>-NNN` (해당 시)

---

## Context

<!--
결정을 촉발한 배경을 기술한다. 이 섹션은 "왜 지금 결정이 필요한가" 를 설명한다.
- 현재 상태
- 관찰된 문제 또는 기회
- 제약 (기술·비즈니스·운영·법적)
- 이 결정을 보류하면 발생하는 비용
-->

- **현재 상태**:
- **촉발 이슈**:
- **제약**:
- **보류 비용**:

---

## Decision

<!--
채택된 결정을 한 문장으로 명확하게 기술한 뒤, 구체 범위를 bullet 으로 정리한다.
"무엇을 할지" 와 "무엇을 하지 않을지" 를 함께 적는다.
-->

**결정**:

### 적용 범위 (In-Scope)

-

### 적용 제외 (Out-of-Scope)

-

---

## Consequences

<!--
긍정/부정/중립을 분리해 기록한다.
"나중에 알게 된 결과" 는 revision 으로 append 한다 (지우지 않는다).
-->

### Positive

-

### Negative

-

### Neutral / Accepted Trade-offs

-

---

## Alternatives Considered

<!--
검토한 대안들을 최소 2개 이상 기록한다. "대안 없음" 은 거의 항상 잘못이다.
각 대안은 채택 안과 같은 축으로 비교한다.
-->

### Alternative A — <이름>

- **요약**:
- **장점**:
- **단점**:
- **기각 사유**:

### Alternative B — <이름>

- **요약**:
- **장점**:
- **단점**:
- **기각 사유**:

---

## Relationship with DependencyDecision

<!--
이 ADR 이 새 라이브러리 도입을 수반하면 DependencyDecision 8항목 체크리스트로 세부 판단을 위임한다.
ADR 은 **상위 설계 판단**, DependencyDecision 은 **라이브러리별 수락 기준** 이다.
두 문서 모두가 필요할 수 있다.
-->

- 새 의존성 도입 여부: Yes / No
- Yes 면 DependencyDecision 작성 위치: `PLAN.md ## 2. DependencyDecision` 또는 별도 보고서 섹션
- 체크리스트 참조: `docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md`

---

## Implementation Notes (선택)

<!--
채택 직후 1회성 구현 가이드. 시간이 지나며 쇠퇴할 수 있으므로 상세 how-to 는 별도 문서로 분리하는 것을 권장한다.
-->

-

---

## Revision History

<!--
결정이 살아 있는 동안 accumulate 된다. 과거 항목을 지우지 않는다.
-->

| Date (KST) | Change | Author Role |
|---|---|---|
| YYYY-MM-DD | Initial draft | <role> |

---

## References

<!--
인용한 외부 자료, 관련 내부 문서, 선행/후행 ADR. 저자 PII 없이 링크와 제목만 기록한다.
-->

- 관련 ADR:
- 관련 내부 문서:
- 외부 자료:
