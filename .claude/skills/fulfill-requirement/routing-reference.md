# Routing Reference — fulfill-requirement

> intake-router가 사용하는 빠른 참조표.
> 세부 규칙: `docs/rules/routing-and-delegation.md`

---

## 키워드 → 도메인 매핑

| 키워드 감지 | 도메인 태그 | 호출 역할 |
|---|---|---|
| 화면, 뷰, UI, 버튼, 레이아웃, Compose | ui-ux | ux-auditor, ui-implementer |
| 무드, 일지, 기록, 감정 | product | requirements-analyst |
| API, 엔드포인트, REST, Firebase Functions | backend-api | backend-api-architect |
| 서버, Functions, OpenAI | server | server-implementer |
| DB, Room, Firestore, 저장, 스키마 | data | data-schema-guardian |
| 로그인, 인증, 권한, Firebase Auth | auth-security | auth-security-privacy |
| 개인정보, PII, GDPR, 동의 | privacy | auth-security-privacy |
| 구독, 결제, In-App, SKU, 환불, 수익 | billing-payments | (repo 별 billing 가드 — 미정의 시 intake-router STOP) |
| 성능, 느림, 메모리, 크래시, ANR | performance-reliability | performance-reliability-engineer |
| 테스트, 검증, 커버리지 | testing | test-strategist |
| 로그, 알림, Crashlytics, 모니터링 | observability | observability-ops-analyst |
| 배포, 릴리즈, 롤백, feature flag | release | release-risk-manager |
| 문서, 운영 규칙 | docs | docs-change-communicator |
| 아키텍처, 모듈, 레이어, KMP, CMP | app-architecture | system-architect |

---

## 위험 키워드 (즉시 플래그)

| 키워드 | 위험 | 처리 |
|---|---|---|
| 결제, 과금, 수익, 구독, 환불, SKU | MoneyAuth=Yes | 즉시 STOP → 사용자 확인 |
| DB migration, 스키마 변경, 테이블 변경 | DBMig=Yes | STOP → 사용자 승인 대기 |
| 삭제, drop, 초기화 | 비가역 위험 | STOP → 사용자 확인 |
| 토큰, API key, 시크릿 | 보안 위험 | auth-security-privacy 순차 처리 |

---

## 역할 실행 방식 빠른 참조

| 상황 | 실행 방식 |
|---|---|
| read-only 분석 (독립 도메인) | 병렬 가능 |
| DBMig, MoneyAuth, Auth 감지 | 순차 (한 번에 하나) |
| 같은 파일 수정 가능성 | 순차 |
| 요구사항 불명확 | requirements-analyst 먼저 (순차) |
| 영향 범위 불명확 | system-architect 먼저 (순차) |
| 구현 전 근거 잠금 필요 | intake normalization + pre-EVIDENCE 계약 먼저 |

공통 intake / reading order:
`docs/agent/process/REPO_FIRST_INTAKE_WORKFLOW.md`

---

## Task ID 생성 규칙

1. `.ai/tasks/INDEX.md` 에서 마지막 번호 확인
2. PREFIX 결정:
   - GB: GentlyBreath Android/공통 변경
   - MP: Multiplatform/KMP/CMP 관련 변경 (해당 시)
3. DOMAIN 결정 (약어 3-7자):
   - UI, AUTH, DATA, API, SERVER, PERF, CONFIG, RELEASE, INFRA, DOCS, POLICY
4. NNN: 3자리 001~999

예: `SW-UI-003`, `MP-DATA-001`, `SW-AUTH-002`

---

## 출력 필수 항목 체크

intake-router 완료 후 아래가 반드시 존재해야 한다:

- [ ] `.ai/tasks/<taskId>.md` (원문 + 메타)
- [ ] `.ai/reports/<taskId>/MODE.md` (1줄 모드)
- [ ] `.ai/tasks/INDEX.md` 갱신 (Active Tasks 행 추가)
- [ ] stdout: `[EVIDENCE]`, `[LOG]` 섹션 출력
