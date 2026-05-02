# Code Principles Rules

> **단일 목적**: 모든 자식 repo (도메인 무관) 의 코드 작성 / 리뷰 시 적용되는 원칙 + 코드 리뷰 체크리스트.
> **C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 신설** (Q1 답 박음).
> **연관 파일**:
> - `workflow-core.md` §implement (TDD / 직접 구현 우선 / 외부 준비 연기)
> - `verification-and-review.md` §review (REVIEW.md 12-section)
> - `legacy-cleanup-governance.md` (cleanup pass)
> SOT: `CLAUDE.md`

---

## 1. SOLID 5 원칙

### S — Single Responsibility Principle
- 한 클래스 / 함수 / 모듈 = 하나의 변경 이유.
- 적용 예: ViewModel = UI state 만 / UseCase = business rule 만 / Repository = data source 추상화만.
- 위반 신호: 한 파일에 "AND" 로 연결된 책임 (예: "User 인증 + Profile 캐시 + Logging").

### O — Open / Closed Principle
- 확장에 열림 + 변경에 닫힘.
- 적용 예: 새 인증 방식 추가 시 기존 `AuthProvider` 수정 X / `OAuthAuthProvider` 신설.
- 위반 신호: enum 확장마다 모든 caller `when` 분기 갱신 의무.

### L — Liskov Substitution Principle
- 서브타입은 슈퍼타입 자리에서 동작 보장.
- 적용 예: `Repository<User>` 의 모든 구현이 `getById(id): User?` 의 null 반환 계약 준수.
- 위반 신호: 서브 클래스에서 `throw NotImplementedError()` / 슈퍼 메서드의 precondition 강화.

### I — Interface Segregation Principle
- 큰 인터페이스 1 개 < 작은 인터페이스 N 개.
- 적용 예: `UserRepository` 가 read-only 와 write 분리 → `UserReadRepository` + `UserWriteRepository`.
- 위반 신호: 구현 클래스 안에 사용 안 하는 메서드가 절반 이상.

### D — Dependency Inversion Principle
- 고수준 모듈 = 저수준 모듈에 의존 X. 양쪽 모두 추상에 의존.
- 적용 예: ViewModel → `interface AuthRepository` → `SupabaseAuthRepository impl`.
- 적용 의무: clock / dispatcher / identity / logger / uuid 인터페이스 주입 (`workflow-core.md` §implement Testability Seams 박힘).

---

## 2. 보조 원칙 (DRY / KISS / YAGNI)

### DRY — Don't Repeat Yourself
- 동일 logic 2 곳 이상 = 1 곳으로 추출 평가.
- 단 **너무 이른 추상화 금지** (KISS 우선) — 3 곳 이상 발생 후 추출.
- 적용 예: 동일 Date 포맷 변환이 2 곳 → KISS 우선 / 3 곳 이상 → 헬퍼 추출.

### KISS — Keep It Simple, Stupid
- 직접 구현 우선 (`workflow-core.md` §implement 박힘).
- 새 추상화 추가 전 직접 구현이 더 단순한지 평가.
- 적용 예: state machine 라이브러리 도입 전 sealed class + when 으로 충분한지 검토.

### YAGNI — You Aren't Gonna Need It
- "나중에 쓸 것" 으로 추가하지 않음.
- 적용 예: API stub 의 응답 형식을 미래 가정으로 확장 X / 실제 필요 시점에 추가.
- DEFERRED domain 정책 (`deferred-domains.md`) = YAGNI 의 큰 적용.

---

## 3. 라이브러리 사용 최소화 (의존성 정책)

`CLAUDE.md` §10 + `ui-ux-analysis.md` §UI 라이브러리 억제 박힘 + 본 §3 강화:

### 신규 의존성 도입 의무 (DependencyDecision 8 항목)

PLAN `## 2. DependencyDecision` 에 모두 작성 (`report-formats.md` 박힘):

1. 도입 사유 (해결하는 구체 문제)
2. 직접 구현 비교 (LOC + 유지비)
3. 라이센스 호환성 + 유지 활성도
4. 의존성 트리 영향 (transitive 충돌 위험)
5. APK / Bundle size 영향
6. ProGuard / R8 의 keep rule 영향
7. 보안 취약점 history (CVE)
8. 제거 절차 (cleanup 후보 시점)

### UI 라이브러리 억제 default

- Compose 표준 만 사용. 외부 UI 라이브러리 도입 금지 (Coin 명시 승인 필수).
- 예외: Material3 의 누락 컴포넌트 (예: BottomSheet) → Compose-Foundation 래퍼 우선.

---

## 4. 코드 리뷰 체크리스트 (reviewer.md 자동 참조)

reviewer agent 가 REVIEW.md 12-section 작성 시 본 체크리스트 적용 의무:

### A. 기능 정확성
- [ ] PLAN.md 의 ChangeBudget 범위 안에서 변경됐나?
- [ ] verifier 의 Exit Criteria PASS 했나?
- [ ] STOP 트리거 (DBMig / MoneyAuth) 위반 X?

### B. SOLID + 보조 원칙
- [ ] **SRP**: 변경 클래스 / 함수 = 단일 책임 유지?
- [ ] **OCP**: 새 case 추가 시 기존 caller 영향 최소?
- [ ] **DIP**: 구현 클래스 직접 인용 X · 인터페이스 주입?
- [ ] **DRY**: 같은 logic 3 곳 이상 X (3 곳 이상이면 추출 의무)?
- [ ] **KISS**: 새 추상화 가 직접 구현보다 단순한 근거 있나?
- [ ] **YAGNI**: 가정한 미래 사용 case 가 현재 PLAN 안에 있나?

### C. 아키텍쳐 정합
- [ ] DTO · Entity · DomainModel · UiState 혼용 X?
- [ ] ViewModel → UI 단방향 (UI state mutation X)?
- [ ] shared/domain → framework import X (layer-checker 자동 검증)?
- [ ] 신규 Koin 모듈 = `app/` 또는 `shared/app` 안만?

### D. 의존성
- [ ] 신규 의존성 = DependencyDecision 8 항목 모두 작성?
- [ ] 라이브러리 대체 = 직접 구현 비교 LOC 기록?
- [ ] APK size 영향 측정 (예: BundleAnalyzer)?

### E. 테스트
- [ ] 신규 UseCase / Coordinator = `FakeXxx` 기반 테스트 함께 / 먼저?
- [ ] 테스트 심 (clock / dispatcher / identity / logger / uuid) 인터페이스 주입?
- [ ] verifier 의 Exit Criteria 가 실행 가능 명령 (0 command 금지)?

### F. 안전성
- [ ] 시크릿 / PII 하드코딩 X (`safety-and-secrets.md` 박힘)?
- [ ] HTTP X · HTTPS only?
- [ ] 비가역 변경 (파일 삭제 / 스키마 변경) = Coin 명시 승인?

### G. cleanup
- [ ] EVIDENCE.md `## Cleanup Assessment` 섹션 작성됐나?
- [ ] 미사용 import / dead code / 중복 포맷터 제거?
- [ ] Deferred Cleanup 항목 = TODO.md 에 lazy 박힘?

### H. UX Laws (`.claude/rules/ux-laws.md` 자동 참조 의무 · UI/UX task 한정)
- [ ] task 유형 식별 → §5 매트릭스 row 추출됐나?
- [ ] 매트릭스 row 의 권장 법칙 모두 PLAN.md / IMPL / REVIEW §B [UX Laws] 인용됐나?
- [ ] §3 비권장 5 항목 (의도적 지연 / 인위적 진척 / 부정 위장 / 카운트다운 / Cognitive Bias 활용) 위반 X?
- [ ] Dark Patterns 5 종 (Roach Motel / Confirmshaming / Disguised Ads / Forced Continuity / Hidden Costs) 위반 X?
- [ ] 게슈탈트 5 (F-1~5) + Fitts (≥ 48dp) + Doherty (< 400ms) + Choice Overload (≤ 7) 명시 검증?

---

## 5. 위반 시 처리

### REVIEW 결과 분류

| 분류 | 조건 | 처리 |
|---|---|---|
| **PASS** | A~G 모두 ✓ | DONE 마감 |
| **PARTIAL** | 1~3 항목 ✗ + 본 작업 직접 영향 X | TODO.md 에 lazy 박음 + DONE |
| **FAIL** | 4 항목 이상 ✗ 또는 본 작업 직접 영향 1+ | replan (change-planner 재호출) |

### SOLID 위반 mitigation 패턴

- **SRP 위반**: 큰 클래스 → 책임별 분리 (`UserRepository` → `UserReadRepository` + `UserWriteRepository`)
- **OCP 위반**: enum 확장마다 caller 갱신 → strategy pattern 도입 평가
- **DIP 위반**: 구현 직접 인용 → 인터페이스 추출 + Koin 주입

---

## 6. 본 rule 의 변경 정책

본 파일 = cli infra 권장 byte-identical (보호 파일 X).
변경 시 master 에서 cycle 신설 + propagation (`cycle-discipline.md` §3 §15 패턴 1).
