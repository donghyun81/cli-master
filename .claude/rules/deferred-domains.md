# Deferred Domains — 미정의 영역 통합 STOP + 활성화 trigger

> **단일 목적**: 자식 repo (GB/GD/GT) 의 미정의 도메인에 대한 통합 STOP 정책 + 도메인 활성화 시 분리 의무 + 활성화 trigger 정의.
> **C2-RULES-RESTRUCTURE-001 흡수**: 기존 4 pointer rule (`auth-security-privacy.md` · `backend-and-api.md` · `data-and-migrations.md` · `performance-reliability.md`) 삭제 + 본 파일에 통합.
> **연관 파일**:
> - `routing-and-delegation.md` — 전문가 역할 매핑 ([DEFERRED] 라벨 동기 의무)
> - `safety-and-secrets.md` — 시크릿 / PII 처리 공통 규칙
> - `cycle-discipline.md` §STOP 조건
> SOT: `CLAUDE.md`

---

## 1. 공통 STOP 조건 (5 영역 통합)

아래 영역 중 하나라도 변경이 감지되면 **즉시 STOP** 하고 Coin 에 보고:

| # | 영역 | STOP trigger 키워드 / 패턴 |
|---|---|---|
| 1 | **인증 / 보안 (Auth)** | 로그인 방식 / 세션 / 토큰 / 역할 / PII 수집-삭제 / 시크릿 주입 / 암호화 / 동의 흐름 / OAuth / SSO |
| 2 | **데이터 / 마이그레이션 (Data)** | 스키마 변경 / 마이그레이션 / 캐시 정책 / 데이터 플로우 / 오프라인 지원 / Room migration / SQLite |
| 3 | **백엔드 / API (Backend)** | API 계약 변경 / DTO 변경 / 에러 모델 / 버전닝 / 클라이언트-서버 영향 / Supabase Edge Function |
| 4 | **성능 / 안정성 (Perf)** | 메인 스레드 차단 (ANR) / 무한 루프 / >10MB 인메모리 / 무한 재시도 / 메모리 leak / battery drain |
| 5 | **결제 / 과금 (Billing)** | 구독 / 인앱 결제 / entitlement / SKU / 가격 정책 / Google Play Billing / refund |

STOP 시 자동 발화 agent (`.claude/agents/deferred/`):
- `auth-security-privacy.md`
- `data-schema-guardian.md`
- `backend-api-architect.md`
- `performance-reliability-engineer.md`
- `billing-payments-guardian.md`

---

## 2. 현재 상태 (3 자식 repo 통합 baseline)

> master baseline = 모두 UNKNOWN. 자식 repo 별 도메인 활성화는 자식 repo 의 별도 cycle 에서 진행 + master propagation 시 본 표 갱신.

| 도메인 | master | GB | GD | GT |
|---|---|---|---|---|
| Auth / Security | **ACTIVE** ¹ | UNKNOWN | UNKNOWN | **ACTIVE** ¹ |
| Data / Migration | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN |
| Backend / API | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN |
| Performance | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN |
| Billing | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN |

¹ Supabase Auth 익명 부트스트랩 + JSON backup · GT-AUTH-PIVOT-001 박힌 패러다임 · `auth-rules.md` SoT (MASTER-AUTH-DOMAIN-ACTIVATE-001).

> **GB SteadyWell propagation 잔존 drift** (`incident-log.md` 박힘): GB 의 deferred-domains.md 가 cycle 진척 전 ACTIVE 표기 유지. C4 propagation 시 master baseline 으로 통일.

---

## 3. 금지 사항 (모든 도메인 공통)

- 시크릿 하드코딩 금지
- PII 로그 출력 금지
- HTTP 금지 (HTTPS only)
- plaintext 토큰 SharedPreferences 금지 (`EncryptedSharedPreferences` 사용)
- SQL injection 가능 쿼리 금지
- `fallbackToDestructiveMigration()` 금지
- Breaking API 변경 금지
- mock 결제 결과 production 노출 금지

---

## 4. 도메인 활성화 절차 (UNKNOWN → ACTIVE)

해당 도메인 기능이 자식 repo 에서 실제 구현될 때:

1. **신규 rule 파일 신설** — `.claude/rules/<domain>-rules.md` 작성 (master 에서 신설 + propagation)
2. **deferred-domains.md 본 표 갱신** — UNKNOWN → ACTIVE + 비고 (예: "Supabase Auth + EncryptedSessionStore")
3. **routing-and-delegation.md 갱신** — 해당 agent 의 `[DEFERRED]` 라벨 제거 + 활성 매핑 추가
4. **agent 폴더 mv** — `.claude/agents/deferred/<name>.md` → `.claude/agents/active/<name>.md` (`scripts/activate-agent.sh` 자동 · C3 신설)
5. **3-repo propagation** — `bash scripts/propagate.sh --all` (C3 신설)
6. **신규 rule 파일이 보호 등급이면** `.auto-memory/protected-file-hashes.md` 갱신

---

## 5. 활성화 trigger 키워드 (자동 STOP)

매 prompt 진입 시 본 키워드 감지 → 자동 STOP + Coin 확인:

| 영역 | trigger 키워드 (한국어 + 영어) |
|---|---|
| Auth | 로그인 / 회원가입 / 인증 / 토큰 / 세션 / OAuth / SSO / login / auth / token / session / signin / signup |
| Data | DB / 마이그레이션 / Room / SQLite / Realm / migration / schema / dao |
| Backend | API / 서버 / Supabase / Firebase / endpoint / REST / GraphQL / gRPC |
| Perf | ANR / 메모리 / battery / leak / OOM / GC / profile |
| Billing | 결제 / 구독 / IAP / entitlement / SKU / Google Play Billing / RevenueCat |

---

## 6. C2 변경 이력

- 2026-05-02 · MASTER-AUTH-DOMAIN-ACTIVATE-001 · Auth 도메인 master + GT 활성화 (GD/GB 별 cycle) · `auth-rules.md` SoT 신설 + agent deferred/ → active/ 이전.
- 2026-05-02 · C2-RULES-RESTRUCTURE-001 · 기존 4 pointer rule 삭제 + 본 파일에 통합 (Billing 신설 · 활성화 trigger 키워드 표 신설 · 3 자식 repo 상태 매트릭스 신설).
- 2026-05-02 · C1-MASTER-BOOTSTRAP-001 · GT 의 UNKNOWN baseline 채택 (master baseline).
