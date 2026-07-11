# RLS 매트릭스 + Play Integrity 도입 가이드

> **대상**: GB (GentlyBreath) · GD (GentlyDay) · GT (GentlyTable)
> **작성일 (KST)**: 2026-04-20
> **전제**: Phase 0 Dashboard 작업에서 CAPTCHA 를 **기본 비적용**으로 결정. 대체 스택으로 **RLS 정책 강화 + Play Integrity API + Rate Limits** 를 모바일 표준 조합으로 채택.
> **SoT**: 이 파일 = 계획·설계 SoT. 실제 Supabase 정책 반영은 Coin 수동 (SQL Editor). 실제 코드 반영은 CLI 프롬프트 실행 후 repo.
> **정책 방향 (A안 채택, 2026-04-20)**: 익명 사용자도 Play Integrity 통과 + Edge Function quota 범위 내라면 유료 AI 기능 이용 가능. RLS 단의 `is_anonymous` 차별 정책(PERMANENT_ONLY)은 **미채택**. 어뷰즈 방어선은 "DB 자물쇠" 가 아니라 "서버 게이트(Integrity 토큰 + 사용자당 daily quota + 티켓 차감)" 로 이동.

---

## 계층 1. 배경 · 의사결정 요약 (비실행)

### 1-1. 왜 이 조합인가

| 이슈 | 웹 표준 대응 | 모바일 표준 대응 (A안 채택) |
|------|-------------|----------------------|
| 자동 가입 봇 | CAPTCHA | Play Integrity API (Android) + Edge Function 가입 rate limit |
| 어뷰저 자동 요청 | CAPTCHA | Edge Function Rate Limit + Play Integrity 토큰 |
| 익명 사용자 무제한 AI 호출 | 앱 내 제한 | **Edge Function 사용자당 daily quota + Play Integrity 토큰 필수 + 티켓 차감** (RLS 단 `is_anonymous` 차별 정책은 미채택) |
| 결제·티켓 남용 | — | Play Integrity 토큰 필수 + 서버 `service_role` 전용 쓰기(BLOCK_ALL) + Play Billing 서명 검증 |

### 1-2. Cowork 담당 vs CLI 담당 분리

| 작업 | 담당 | 경로 |
|------|------|------|
| RLS 매트릭스 설계 (표·정책 템플릿) | **Cowork (이 파일)** | `RLS_AND_PLAY_INTEGRITY_GUIDE.md` §2-A |
| SQL Editor 에서 RLS 정책 반영 | **Coin 수동** (Supabase Dashboard → SQL Editor) | — |
| 감사 SQL 쿼리 제공 (정책 검증용) | **Cowork (이 파일)** | §2-A-4 |
| RLS 매트릭스 repo 이관 (`docs/backend/rls-matrix.md` 신설) | **CLI 프롬프트 3종** | §2-B |
| Play Integrity 클라이언트 + Edge Function 구현 | **CLI 프롬프트 3종** | §2-C |
| Play Console 프로젝트 링크 + 키 발급 | **Coin 수동** (Google Play Console) | §2-C-0 |
| 사용자당 daily quota 설계 (숫자 결정) | **Coin 결정 필요** | §2-C-4 |
| Edge Function 안 quota 체크 · Integrity 검증 구현 | **CLI 프롬프트 (Sub-task SERVER)** | §3 |

### 1-3. STOP 경계

아래 영역 변경은 모두 **Auth · DB migration · Money/Billing** 중첩 → 각 repo 의 `docs/rules/deferred-domains.md` 기준 즉시 STOP 경로.
- RLS SQL 실제 적용: **Coin 수동 only** (agent 자동 적용 금지)
- DDL 파일 (`docs/setup/01_*_supabase_ddl.sql`) 수정: CLI 프롬프트 대상 아님 — repo 문서 `docs/backend/rls-matrix.md` 신설만 담당
- Edge Function 실제 배포: **Coin 수동** (Supabase CLI `supabase functions deploy`)
- Play Integrity 키 발급 / Cloud Project 링크: **Coin 수동**

### 1-4. A안 결정 근거 (익명도 AI 허용)

**결정 요지**
Play Integrity 통과 + Edge Function quota 범위 내라면 **익명 사용자에게도 유료 AI 기능을 허용**한다. RLS 단에서 `is_anonymous = false` 를 요구하는 패턴(PERMANENT_ONLY)은 사용하지 않는다.

**근거**
1. **Play Integrity 가 대부분의 자동화 어뷰즈를 막는다**: 봇/에뮬레이터/루팅폰에서 온 요청은 Integrity 토큰 발급 실패 → Edge Function 초단에서 거부.
2. **`is_anonymous` 만 막아도 완전한 방어가 아니다**: 진짜 사람이 이메일 alias 로 영구 계정 N개를 만들면 동일 어뷰즈 가능 → PERMANENT_ONLY 는 결정적 방어가 아니라 "가입 마찰" 에 가깝다.
3. **실질 방어는 사용자당 quota 에서 나온다**: 익명/영구 무관, 단일 `auth.uid()` 당 daily 호출 상한 + 티켓 차감. 이 조합은 정회원이든 익명이든 동일한 한도를 강제한다.
4. **제품 UX 일관성**: 티켓 결제(`ticket_balances`·`ticket_transactions`)는 BLOCK_ALL(서버 전용)이라 구조상 익명 결제 허용 여지가 있는 구조. "익명이 돈은 내되 AI 는 못 쓴다" 는 모순을 피한다.

**A안의 적용 범위 (중요)**
A안은 **AI 호출·티켓 차감 등 "연산/금전 경로"** 에 한정해 익명을 허용한다. 아래는 **A안과 별개로 `is_anonymous` 차별을 유지**한다:
- **스토리지 업로드** (`profile-images` 등): 저장 용량·부적절 콘텐츠 업로드 어뷰즈는 Play Integrity 로 완전 차단 불가. 영구 가입 요구가 적절한 마찰 장치. → §2-A-6 이슈 B 유지.
- **결제·티켓 쓰기** (`ticket_balances`·`ticket_transactions`): BLOCK_ALL 상태 유지. 서버 Edge Function 안쪽에서만 Integrity+Play Billing 서명 검증 후 쓰기.

즉 "PERMANENT_ONLY 패턴은 미사용" 은 §2-A-3 의 **AI 관련 테이블** 에 한정된 설명이며, 스토리지·결제 경로의 `is_anonymous` 체크는 별도 근거로 유지된다.

**남은 어뷰즈 시나리오 (수용)**
- 동일 사용자가 실기기로 여러 익명 계정을 만들어 각각 무료 quota 를 소진: 실질 호출량이 IP/디바이스 단위 rate limit 에 걸리도록 별도 방어.
- 익명 계정의 데이터 손실 리스크는 제품 UX 정책(익명→영구 전환 시점에 데이터 이관) 으로 유도.

**funnel 유인 대체안 (가이드 범위 외, Coin 결정)**
- 기기 변경 시 데이터 복구 (영구 가입 전용)
- 장기 트렌드/월간 리포트 열람 (영구 전용)
- 프리미엄 티켓 구매 보너스 (영구 가입 시 할인 등)

---

## 계층 2-A. RLS 매트릭스 (Cowork 직접 산출 — Coin 이 SQL Editor 에 반영)

### 2-A-1. 매트릭스 템플릿 (3 repo 공통 형식)

아래 표가 repo 별 정책의 canonical 설계다. Coin 은 이 표를 읽고 Supabase Dashboard → SQL Editor 에서 해당 SQL 을 실행한다.

**컬럼 정의**
- 테이블: repo 내 Supabase 테이블명
- 읽기 (SELECT): 익명 허용 여부 · 조건
- 쓰기 (INSERT): 익명 허용 여부 · 조건
- 수정 (UPDATE): 익명 허용 여부 · 조건
- 삭제 (DELETE): 익명 허용 여부 · 조건
- 근거 정책 ID: 아래 §2-A-2 의 정책 패턴 ID

**범례**
- `ALLOW_OWN`: 자신의 `user_id` 행만 허용 (현재 DDL 기본값, 익명/영구 무관)
- `PERMANENT_ONLY`: `is_anonymous = false` 이고 자신의 행만 허용 (**A안 하에서 §2-A-3 매트릭스(AI/연산 경로)는 미사용**, 단 §2-A-6 의 스토리지·결제 경로에서는 별도 근거로 사용 중)
- `BLOCK_ALL`: RLS 정책으로 전면 차단 (서버 Service Role Key 로만 쓰기 — 주로 `SECURITY DEFINER` 함수 또는 Edge Function)
- `PUBLIC_READ`: 모든 인증 사용자 읽기 허용 (공용 참조 데이터)

### 2-A-2. 참조 정책 패턴 SQL (Policy Cookbook)

Coin 이 실제 정책을 작성할 때 복붙 기본형.

**패턴 A — `ALLOW_OWN` (현재 DDL 기본, 변경 없음)**
```sql
CREATE POLICY <name> ON <table> FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY <name> ON <table> FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY <name> ON <table> FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

**패턴 B — `PERMANENT_ONLY` (§2-A-3 매트릭스는 미사용, §2-A-6 스토리지/결제 경로에서는 사용)**

> **A안 채택 이후 §2-A-3 AI/연산 경로 매트릭스에서는 사용하지 않음.** 단 §2-A-6 GB `profile-images` 버킷 정책처럼 스토리지·결제 경로에서는 Play Integrity 로 완전 차단 불가능한 어뷰즈(저장 용량·콘텐츠)가 있어 별도 근거로 유지. AI/연산 경로에 재도입할 때는 §1-4 결정 근거를 다시 검토할 것.

```sql
-- is_anonymous 클레임이 'false' 인 영구 사용자만 쓰기 허용
-- 익명 사용자는 UI 에서 업그레이드 안내로 유도
CREATE POLICY <name> ON <table> FOR INSERT
  WITH CHECK (
    auth.uid() = user_id
    AND (auth.jwt() ->> 'is_anonymous')::boolean = false
  );

CREATE POLICY <name> ON <table> FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (
    auth.uid() = user_id
    AND (auth.jwt() ->> 'is_anonymous')::boolean = false
  );
```

**패턴 C — `BLOCK_ALL` (Service Role Key 전용, 서버 쓰기만)**
```sql
-- SELECT 만 자기 것 허용, 쓰기는 RLS 로 전면 차단 (서버 SECURITY DEFINER 함수가 우회)
CREATE POLICY <name>_select ON <table> FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT/UPDATE/DELETE 정책을 생성하지 않음 → RLS 활성 상태에서 클라이언트 거부
-- 서버측은 supabase_admin 또는 service_role JWT 로 우회
```

**패턴 D — `PUBLIC_READ` (공용 참조 데이터, 쓰기는 관리자만)**
```sql
CREATE POLICY <name>_select ON <table> FOR SELECT
  USING (true);

-- INSERT/UPDATE/DELETE 정책 미생성 → RLS 활성 상태에서 클라이언트 거부
```

### 2-A-3. repo 별 매트릭스

아래 판정은 각 repo 의 `docs/setup/01_*_supabase_ddl.sql` 현재 상태와 제품 성격을 바탕으로 작성. Coin 은 최종 판정 전 본인 제품 정책과 대조할 것 (특히 "익명 허용 여부" 는 제품 UX 정책).

#### GB (GentlyBreath) — 11 테이블

| 테이블 | 읽기 | 쓰기 | 수정 | 삭제 | 정책 ID | 비고 |
|--------|------|------|------|------|---------|------|
| users | ALLOW_OWN | (Auth trigger) | ALLOW_OWN | ALLOW_OWN | A | `auth.users` 미러, 자동 동기화 |
| user_preferences | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | — | A | 온보딩 데이터, 익명도 저장 필요 |
| emotion_checkins | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A | 기본 기록 기능, 익명 허용 |
| emotion_journals | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A | 일지 기능, 익명 허용 |
| breath_sessions | ALLOW_OWN | ALLOW_OWN | — | — | A | 호흡 기록, 익명 허용 |
| meditation_sessions | ALLOW_OWN | ALLOW_OWN | — | — | A | 명상 기록, 익명 허용 |
| weekly_reports | ALLOW_OWN | **BLOCK_ALL** | — | — | C | 서버 생성만 (Edge Function) |
| monthly_reports | ALLOW_OWN | **BLOCK_ALL** | — | — | C | 서버 생성만 |
| ticket_balances | ALLOW_OWN | **BLOCK_ALL** | **BLOCK_ALL** | — | C | **금전 경로** — 서버만 |
| ticket_transactions | ALLOW_OWN | **BLOCK_ALL** | — | — | C | **금전 경로** — 서버만 |
| ai_logs | **BLOCK_ALL** | **BLOCK_ALL** | — | — | C | 서버 전용 (Edge Function `generate-checkin-response` + `service_role`). §2-A-6 로 RLS 활성화, 정책 전무 → 모든 client 경로 차단 |

**GB 판정 요약**
- 기본 기록 (checkins · journals · breath · meditation): 익명 허용 (B2C 앱 특성상 트라이얼 필요)
- 리포트 2종: 서버 생성 전용 (현재 DDL 도 INSERT 정책 없음)
- 티켓 2종: 서버 생성 전용 + 금전 경로 (현재 DDL 도 INSERT 정책 없음)
- `ai_logs`: **BLOCK_ALL** — §2-A-6 GB 보안 마이그레이션으로 RLS 활성화. 정책 전무 → 모든 client 경로 차단, Edge Function(`service_role`) 만 쓰기 가능 (service_role 은 RLS 우회)

#### GD (GentlyDay) — 12 테이블

| 테이블 | 읽기 | 쓰기 | 수정 | 삭제 | 정책 ID | 비고 |
|--------|------|------|------|------|---------|------|
| users | ALLOW_OWN | (Auth trigger) | ALLOW_OWN | ALLOW_OWN | A | |
| sleep_records | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A | 수면 기록, 익명 허용 |
| sleep_stages | ALLOW_OWN | ALLOW_OWN | — | — | A | 수면 단계 자동 계산 |
| routines | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A | 루틴 생성, 익명 허용 |
| routine_items | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A | |
| routine_completions | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A | |
| habits | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A | 습관 추적, 익명 허용 |
| habit_logs | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A | |
| weekly_reports | ALLOW_OWN | **BLOCK_ALL** | — | — | C | 서버 생성만 |
| ticket_balances | ALLOW_OWN | **BLOCK_ALL** | **BLOCK_ALL** | — | C | **금전 경로** |
| ticket_transactions | ALLOW_OWN | **BLOCK_ALL** | — | — | C | **금전 경로** |
| ai_insights | ALLOW_OWN | **BLOCK_ALL** | — | — | C | 서버 전용 (Edge Function + service_role). 현재 DDL INSERT 정책 부재 상태 유지 |

**GD 판정 요약**
- 루틴·습관 기본 기능: 익명 허용
- 리포트 + 티켓 2종: 서버 전용
- `ai_insights`: **BLOCK_ALL 유지** — 현재 DDL 에 INSERT 정책이 부재해 사실상 `service_role` 만 쓰기 가능한 상태(BLOCK_ALL 과 동치). Edge Function + `service_role` 로 AI 결과를 직접 넣는 현재 구조와 정합. `PERMANENT_ONLY` 로 변경하면 익명↔영구 JWT 구분이 아니라 서버 내부 호출을 제한하게 되어 필요 없는 복잡도 유발 → 현 상태 유지.

#### GT (GentlyTable) — 11 테이블

| 테이블 | 읽기 | 쓰기 | 수정 | 삭제 | 정책 ID | 비고 |
|--------|------|------|------|------|---------|------|
| users | ALLOW_OWN | (Auth trigger) | ALLOW_OWN | — | A | |
| user_profiles | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | — | A | 온보딩 프로필, 익명 허용 |
| daily_conditions | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | — | A | 일일 컨디션, 익명 허용 |
| food_db | PUBLIC_READ | **BLOCK_ALL** | **BLOCK_ALL** | — | D | 공용 참조 데이터, 서버만 쓰기 |
| meal_recommendations | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | — | A | 익명/영구 공통. AI 어뷰즈 방어는 Edge Function(Integrity+quota+티켓) 담당 |
| exercise_recommendations | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | — | A | 익명/영구 공통. 동일 Edge Function 게이트 |
| daily_tips | ALLOW_OWN | **BLOCK_ALL** | — | — | C | 서버 생성 (AI) · EF generate-daily-tip persist (GT-AI-FEEDBACK-HISTORY-PERSIST-001 · read=`gt_daily_tips_select`) |
| weekly_reports | ALLOW_OWN | **BLOCK_ALL** | — | — | C | 서버 생성만 |
| monthly_reports | ALLOW_OWN | **BLOCK_ALL** | — | — | C | 서버 생성만 |
| ticket_balances | ALLOW_OWN | **BLOCK_ALL** | **BLOCK_ALL** | — | C | **금전 경로** |
| ticket_transactions | ALLOW_OWN | **BLOCK_ALL** | — | — | C | **금전 경로** |

**GT 판정 요약**
- 기본 온보딩/컨디션: 익명 허용
- `food_db`: 공용 참조 (모든 인증 사용자 읽기), 쓰기는 서버 관리자 전용
- 추천 2종 (meal · exercise): **A안 ALLOW_OWN 유지** — AI 호출 어뷰즈 방지는 RLS 단이 아니라 Edge Function 단(Play Integrity 토큰 필수 + 사용자당 daily quota + 티켓 차감)에서 처리. 현재 GT 의 INSERT 정책은 `auth.uid() = user_id` (패턴 A) → 매트릭스와 정합 → **DDL 변경 불필요**. 익명 도입 후의 실질 방어는 Edge Function `recommend-meal` · `recommend-exercise` 함수 초단의 Integrity+quota 게이트에 의존.
- 리포트 3종 + 티켓 2종: 서버 전용

### 2-A-4. 감사 SQL (Coin 이 SQL Editor 에서 실행해 현재 상태 확인)

**쿼리 1 — 모든 테이블의 RLS 활성 여부**
```sql
SELECT
  schemaname,
  tablename,
  rowsecurity AS rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;
```
기대: 모든 비참조 테이블 `rls_enabled = true`. `false` 가 있으면 즉시 `ALTER TABLE <t> ENABLE ROW LEVEL SECURITY;` 실행.

**쿼리 2 — 현재 정책 목록 (CMD/ROLE/조건)**
```sql
SELECT
  schemaname,
  tablename,
  policyname,
  cmd,         -- SELECT / INSERT / UPDATE / DELETE
  roles,
  qual,        -- USING 절
  with_check   -- WITH CHECK 절
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, cmd;
```
기대: §2-A-3 매트릭스와 1:1 대응.

**쿼리 3 — `is_anonymous` 기반 정책 잔존 여부 감사 (A안)**
```sql
-- is_anonymous 클레임을 사용하는 정책 조회 (public 스키마)
SELECT
  tablename,
  policyname,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND with_check LIKE '%is_anonymous%';

-- storage 스키마의 profile-images 정책 별도 조회
SELECT
  policyname,
  with_check
FROM pg_policies
WHERE schemaname = 'storage'
  AND with_check LIKE '%is_anonymous%';
```
**A안 기대값**
- public 스키마 결과: **0건** (AI/연산 경로에서는 `is_anonymous` 차별 정책 미사용). 예상 외로 조회되면 이전 PERMANENT_ONLY 잔재 → DROP 대상.
- storage 스키마 결과: `profile_images_insert` 1건 (§2-A-6 이슈 B). 이건 A안과 별개로 유지.

**쿼리 4 — 익명 사용자 수 확인 (주기적 모니터링)**
```sql
SELECT
  COUNT(*) FILTER (WHERE is_anonymous = true) AS anonymous_count,
  COUNT(*) FILTER (WHERE is_anonymous = false) AS permanent_count,
  COUNT(*) AS total
FROM auth.users;
```
> `auth.users` 접근에는 Postgres 관리 권한 필요. Dashboard SQL Editor 는 service_role 권한으로 실행하므로 접근 가능.

### 2-A-5. Coin 실행 순서 (SQL Editor) — A안

1. **쿼리 1 · 2 실행**: 현재 정책 스냅샷 확보 → 결과 복사해 로컬에 보관 (Rollback 증거)
2. **AI/연산 경로 정합화** (A안 — `is_anonymous` 차별 정책 미사용):
   - GT: `meal_recommendations` · `exercise_recommendations` 의 INSERT/UPDATE 정책이 `is_anonymous = false` 조건을 포함하면 DROP → 패턴 A (`auth.uid() = user_id` 만) 로 재생성
   - GD: `ai_insights` 는 INSERT 정책 부재(BLOCK_ALL) 유지. 추가 작업 없음
   - GB: AI 관련 테이블에 변경 없음 (§2-A-6 별도)
3. **GB 보안 마이그레이션 적용** — §2-A-6 참조 (`ai_logs` RLS 활성화 + `profile-images` 익명 업로드 차단). 이건 A안과 별개 (스토리지·콘텐츠 어뷰즈 방어).
4. **쿼리 3 실행**: A안 정합 검증 — public 스키마 결과 0건 / storage 스키마 결과 1건 (`profile_images_insert`) 만 기대.
5. **기존 `BLOCK_ALL` 정책 누락 여부 확인**: 쿼리 2 결과에서 티켓/리포트 테이블에 INSERT 정책이 존재하면 DROP (현재 DDL 기준 이미 부재 — 실행 불필요 추정).
6. **Rollback**: 필요 시 쿼리 1/2 스냅샷으로 복원.

> **주의**: 단계 2 의 GT INSERT 정책 DROP/재생성은 단일 트랜잭션(`BEGIN; ... COMMIT;`) 으로 묶을 것. 중간 실패 시 정책 공백으로 클라이언트 쓰기 차단 발생 가능 → 사용자 영향.

### 2-A-6. GB 보안 마이그레이션 (Coin 이 SQL Editor 에서 실행)

> GB (GentlyBreath) 현재 DDL 분석 결과 2건의 익명 도입 관련 이슈가 발견됨. 둘 다 단일 트랜잭션으로 적용 가능.

#### 이슈 A — `ai_logs` RLS 비활성 상태

**근거**:
- GB DDL 에 `ALTER TABLE ai_logs ENABLE ROW LEVEL SECURITY;` 부재
- Edge Function `generate-checkin-response/index.ts` 가 `SUPABASE_SERVICE_ROLE_KEY` 로 insert → RLS 활성화해도 서버 경로 영향 없음 (service_role 은 RLS 우회)
- GB `app/` 디렉터리 grep 결과 `ai_logs | AiLog | aiLog` 매칭 **0 건** → 클라이언트 Kotlin 코드는 이 테이블을 참조하지 않음

**판정**: RLS 활성화 적용. 클라이언트 영향 없음, 서버 영향 없음.

#### 이슈 B — `profile-images` 버킷 익명 업로드 허용

**근거**:
- 현재 `profile_images_insert` 정책은 `auth.uid()::text = (storage.foldername(name))[1]` 만 검증 → 익명 JWT 도 uid 가 있으면 업로드 가능
- Coin 결정: **옵션 1 — 영구 사용자만 업로드 허용** (익명 차단)

#### 실행 SQL

```sql
BEGIN;

-- (A) ai_logs — RLS 활성화
ALTER TABLE ai_logs ENABLE ROW LEVEL SECURITY;

-- (B) profile-images — 익명 업로드 차단 (옵션 1)
DROP POLICY IF EXISTS "profile_images_insert" ON storage.objects;
CREATE POLICY "profile_images_insert" ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'profile-images'
    AND auth.uid()::text = (storage.foldername(name))[1]
    AND (auth.jwt() ->> 'is_anonymous')::boolean = false
  );

COMMIT;
```

#### 검증 쿼리 (실행 후 결과 확인)

```sql
-- (A) 검증: ai_logs RLS 활성 여부
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'ai_logs';
-- 기대: rowsecurity = true

-- (B) 검증: profile_images_insert 정책에 is_anonymous 체크 포함 여부
SELECT policyname, cmd, with_check
FROM pg_policies
WHERE schemaname = 'storage' AND tablename = 'objects'
  AND policyname = 'profile_images_insert';
-- 기대: with_check 에 is_anonymous = false 포함
```

#### Rollback

```sql
BEGIN;

-- (A) ai_logs RLS 비활성 복원
ALTER TABLE ai_logs DISABLE ROW LEVEL SECURITY;

-- (B) profile_images_insert 원복
DROP POLICY IF EXISTS "profile_images_insert" ON storage.objects;
CREATE POLICY "profile_images_insert" ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'profile-images'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

COMMIT;
```

---

## 계층 2-B. RLS 매트릭스 repo 이관 CLI 프롬프트 (3 repo × self-contained)

각 repo 에 `docs/backend/rls-matrix.md` 를 신설해 §2-A-3 매트릭스의 repo 별 섹션을 담는다. Low Risk · 문서 전용 · ops-layer.

---

### CLI 프롬프트 RLS-DOC-GB-001 (GentlyBreath)

```
# RLS-DOC-GB-001 — GentlyBreath RLS 매트릭스 문서 신설

## 요구사항
GentlyBreath repo 에 익명 로그인 도입 후 RLS 정책 매트릭스의 단일 문서 SoT 를 신설한다.
Supabase 실제 정책 SQL 은 Coin 이 Dashboard SQL Editor 에서 수동 반영한다. 이 task 는
문서 신설 only — Supabase 에 직접 접근하지 않는다.

## 읽어야 할 파일 (현재 live 확인)
1. `CLAUDE.md`
2. `.claude/rules/workflow.md` — Low Risk 경량화 기준
3. `.claude/rules/evidence-and-reporting.md` — PLAN.md 3-section 경량화 형식
4. `.claude/rules/safety-and-secrets.md` — 시크릿 기록 금지
5. `docs/setup/01_gb_supabase_ddl.sql` — 현재 테이블·정책 목록 (읽기 only, 수정 금지)
6. `.ai/tasks/INDEX.md` (있으면)

## 외부 참조 (external-prep)
- Supabase 공식 문서 Anonymous Sign-Ins: is_anonymous JWT claim 사용법 — 참조만, fetch 금지

## scope
| 항목 | 포함 여부 |
|------|-----------|
| `docs/backend/rls-matrix.md` 신설 | 포함 |
| `docs/backend/` 디렉터리 생성 (없으면) | 포함 |
| `.ai/tasks/RLS-DOC-GB-001.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GB-001/EVIDENCE.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GB-001/PLAN.md` 생성 (3-section) | 포함 |
| `.ai/reports/RLS-DOC-GB-001/VERIFY.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GB-001/REVIEW.md` 생성 (3-section) | 포함 |
| `docs/setup/01_gb_supabase_ddl.sql` 수정 | **제외** (STOP — DB 스키마) |
| 실제 Supabase SQL 실행 | **제외** (Coin 수동) |
| `app/` 하위 제품 코드 수정 | **제외** |

## 분류
- Work Type: 문서형
- Reading Mode: 정책-계획 점검형
- Risk: Low
- DBMig: No (문서만)
- MoneyAuth: Auth 인접 (문서화는 허용, 실제 정책 반영은 scope 제외)
- Cleanup Assessment: N/A (ops-layer task — 제품 코드 미변경) → EVIDENCE.md 에 명시

## STOP 조건
1. `docs/setup/01_gb_supabase_ddl.sql` 를 Edit/Write 시도 감지 → 즉시 STOP
2. SQL 실행 명령 (psql, supabase CLI) 시도 → 즉시 STOP
3. `app/src/main/java/**` 수정 시도 → 즉시 STOP (경로 밖)
4. 시크릿 기록 시도 (JWT 샘플, 실제 user_id, service_role 키) → 즉시 STOP

## 신설 문서 내용 (docs/backend/rls-matrix.md 본문)

제목: GentlyBreath RLS 정책 매트릭스

섹션 구성:
1. 목적 — 익명 로그인 도입 후 RLS 정책 분포의 단일 SoT
2. 정책 패턴 (Cookbook) — 패턴 A/B/C/D 정의
   - A: ALLOW_OWN — `auth.uid() = user_id`
   - B: PERMANENT_ONLY — `auth.uid() = user_id AND (auth.jwt() ->> 'is_anonymous')::boolean = false`
   - C: BLOCK_ALL — 쓰기 정책 미생성, SELECT 만 auth.uid() = user_id
   - D: PUBLIC_READ — SELECT USING true, 쓰기 정책 미생성
3. 테이블 매트릭스 (아래 표 그대로 기록)

| 테이블 | SELECT | INSERT | UPDATE | DELETE | 정책 ID |
|--------|--------|--------|--------|--------|---------|
| users | ALLOW_OWN | (Auth trigger) | ALLOW_OWN | ALLOW_OWN | A |
| user_preferences | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | — | A |
| emotion_checkins | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A |
| emotion_journals | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A |
| breath_sessions | ALLOW_OWN | ALLOW_OWN | — | — | A |
| meditation_sessions | ALLOW_OWN | ALLOW_OWN | — | — | A |
| weekly_reports | ALLOW_OWN | BLOCK_ALL | — | — | C |
| monthly_reports | ALLOW_OWN | BLOCK_ALL | — | — | C |
| ticket_balances | ALLOW_OWN | BLOCK_ALL | BLOCK_ALL | — | C |
| ticket_transactions | ALLOW_OWN | BLOCK_ALL | — | — | C |

4. 운영 메모
   - GB 의 현재 판정: 기본 기록 기능(checkins · journals · breath · meditation) 은 익명 쓰기 허용 — 트라이얼 UX 우선
   - 리포트 2종 + 티켓 2종: 서버 전용 (Edge Function + service_role)
   - 추후 `PERMANENT_ONLY` 필요 판정 시 별도 task (RLS-POLICY-GB-NNN) 로 분리

5. SoT 경계
   - 이 문서: 정책 설계 SoT
   - 실제 Postgres 정책: Supabase Dashboard SQL Editor (Coin 수동 반영)
   - 두 경계의 동기화 검증: `.ai/tasks/RLS-AUDIT-GB-NNN` (별도 task)

6. Rollback
   - 이 문서 revert: `git revert <commit>`
   - DB 정책 rollback: 이 문서 범위 외 — Coin 수동 (Dashboard SQL Editor)

## Measurable Exit Criteria
- [ ] `docs/backend/rls-matrix.md` 존재 확인 — `test -f docs/backend/rls-matrix.md && echo EXISTS`
- [ ] 매트릭스 표 10개 테이블 기재 확인 — `grep -c "^| " docs/backend/rls-matrix.md` ≥ 11 (헤더 + 구분 + 10행)
- [ ] 패턴 A/B/C/D 정의 섹션 존재 — `grep -c "^### 패턴 " docs/backend/rls-matrix.md` = 4
- [ ] `app/` 하위 변경 0 — `git status app/ | wc -l` = 0
- [ ] DDL 파일 변경 0 — `git diff --name-only | grep -c "01_gb_supabase_ddl.sql"` = 0

## verify 명령 (허용된 것만)
| 명령 | 기대 exit |
|------|----------|
| `git diff --name-only` | 0 |
| `test -f docs/backend/rls-matrix.md` | 0 |
| `grep -c "^| " docs/backend/rls-matrix.md` | 0 (stdout ≥ 11) |

## 출력물 경로 (모두 필수)
- `docs/backend/rls-matrix.md` (신설)
- `.ai/tasks/RLS-DOC-GB-001.md` (신설)
- `.ai/reports/RLS-DOC-GB-001/EVIDENCE.md` (신설, Cleanup Assessment = N/A)
- `.ai/reports/RLS-DOC-GB-001/PLAN.md` (신설, 3-section 경량화)
- `.ai/reports/RLS-DOC-GB-001/VERIFY.md` (신설)
- `.ai/reports/RLS-DOC-GB-001/REVIEW.md` (신설, 3-section 경량화)

## 금지 명령
curl · wget · sudo · rm · git commit · git push · git reset · git clean · /tmp · $TMPDIR
```

---

### CLI 프롬프트 RLS-DOC-GD-001 (GentlyDay)

```
# RLS-DOC-GD-001 — GentlyDay RLS 매트릭스 문서 신설

## 요구사항
GentlyDay repo 에 익명 로그인 도입 후 RLS 정책 매트릭스의 단일 문서 SoT 를 신설한다.
Supabase 실제 정책 SQL 은 Coin 이 Dashboard SQL Editor 에서 수동 반영한다. 이 task 는
문서 신설 only — Supabase 에 직접 접근하지 않는다.

## 읽어야 할 파일 (현재 live 확인)
1. `CLAUDE.md`
2. `.claude/rules/workflow.md` — Low Risk 경량화 기준
3. `.claude/rules/evidence-and-reporting.md`
4. `.claude/rules/safety-and-secrets.md`
5. `docs/setup/01_gd_supabase_ddl.sql` — 현재 테이블·정책 목록 (읽기 only, 수정 금지)
6. `.ai/tasks/INDEX.md` (있으면)

## 외부 참조 (external-prep)
- Supabase 공식 문서 Anonymous Sign-Ins: is_anonymous JWT claim — 참조만, fetch 금지

## scope
| 항목 | 포함 여부 |
|------|-----------|
| `docs/backend/rls-matrix.md` 신설 | 포함 |
| `docs/backend/` 디렉터리 생성 (없으면) | 포함 |
| `.ai/tasks/RLS-DOC-GD-001.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GD-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md` 생성 | 포함 |
| `docs/setup/01_gd_supabase_ddl.sql` 수정 | **제외** (STOP — DB 스키마) |
| 실제 Supabase SQL 실행 | **제외** (Coin 수동) |
| `app/` 하위 제품 코드 수정 | **제외** |

## 분류
- Work Type: 문서형
- Reading Mode: 정책-계획 점검형
- Risk: Low
- DBMig: No (문서만)
- MoneyAuth: Auth 인접 (문서만)
- Cleanup Assessment: N/A (ops-layer task)

## STOP 조건
1. `docs/setup/01_gd_supabase_ddl.sql` 를 Edit/Write 시도 → 즉시 STOP
2. SQL 실행 명령 시도 → 즉시 STOP
3. `app/src/main/java/**` 수정 시도 → 즉시 STOP
4. 시크릿 기록 시도 → 즉시 STOP

## 신설 문서 내용 (docs/backend/rls-matrix.md 본문)

제목: GentlyDay RLS 정책 매트릭스

섹션 구성:
1. 목적
2. 정책 패턴 (Cookbook)
   - A: ALLOW_OWN — `auth.uid() = user_id`
   - B: PERMANENT_ONLY — `auth.uid() = user_id AND (auth.jwt() ->> 'is_anonymous')::boolean = false`
   - C: BLOCK_ALL — 쓰기 정책 미생성
   - D: PUBLIC_READ — SELECT USING true
3. 테이블 매트릭스

| 테이블 | SELECT | INSERT | UPDATE | DELETE | 정책 ID |
|--------|--------|--------|--------|--------|---------|
| users | ALLOW_OWN | (Auth trigger) | ALLOW_OWN | ALLOW_OWN | A |
| sleep_records | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A |
| sleep_stages | ALLOW_OWN | ALLOW_OWN | — | — | A |
| routines | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A |
| routine_items | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A |
| routine_completions | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A |
| habits | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A |
| habit_logs | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | A |
| weekly_reports | ALLOW_OWN | BLOCK_ALL | — | — | C |
| ticket_balances | ALLOW_OWN | BLOCK_ALL | BLOCK_ALL | — | C |
| ticket_transactions | ALLOW_OWN | BLOCK_ALL | — | — | C |
| ai_insights | ALLOW_OWN | **BLOCK_ALL** | — | — | C |

4. 운영 메모
   - GD 의 현재 판정: 수면/루틴/습관 기본 기능은 익명 쓰기 허용
   - `ai_insights`: BLOCK_ALL 유지 — 현재 DDL INSERT 정책 부재 상태이므로 사실상 `service_role` 만 쓰기 가능. Edge Function + service_role 로 직접 쓰는 현재 서버 구조와 정합
   - 리포트 + 티켓 2종: 서버 전용
   - 추후 PERMANENT_ONLY 확장 필요 시 별도 task 분리

5. SoT 경계
   - 이 문서: 정책 설계 SoT
   - 실제 Postgres 정책: Supabase Dashboard SQL Editor (Coin 수동)
   - 동기화 검증: `.ai/tasks/RLS-AUDIT-GD-NNN` (별도 task)

6. Rollback
   - 이 문서 revert: `git revert <commit>`
   - DB 정책 rollback: 이 문서 범위 외

## Measurable Exit Criteria
- [ ] `docs/backend/rls-matrix.md` 존재 확인
- [ ] 매트릭스 표 12개 테이블 기재 확인 — `grep -c "^| " docs/backend/rls-matrix.md` ≥ 13
- [ ] 패턴 정의 섹션 4개 존재
- [ ] `ai_insights` 의 정책 ID = C 기재 확인 — `grep "ai_insights.*| C |" docs/backend/rls-matrix.md`
- [ ] `app/` 하위 변경 0
- [ ] DDL 파일 변경 0

## verify 명령
| 명령 | 기대 exit |
|------|----------|
| `git diff --name-only` | 0 |
| `test -f docs/backend/rls-matrix.md` | 0 |
| `grep -c "^| " docs/backend/rls-matrix.md` | 0 (stdout ≥ 13) |
| `grep "ai_insights" docs/backend/rls-matrix.md` | 0 |

## 출력물 경로
- `docs/backend/rls-matrix.md`
- `.ai/tasks/RLS-DOC-GD-001.md`
- `.ai/reports/RLS-DOC-GD-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md`

## 금지 명령
curl · wget · sudo · rm · git commit · git push · git reset · git clean · /tmp · $TMPDIR
```

---

### CLI 프롬프트 RLS-DOC-GT-001 (GentlyTable)

```
# RLS-DOC-GT-001 — GentlyTable RLS 매트릭스 문서 신설

## 요구사항
GentlyTable repo 에 익명 로그인 도입 후 RLS 정책 매트릭스의 단일 문서 SoT 를 신설한다.
Supabase 실제 정책 SQL 은 Coin 이 Dashboard SQL Editor 에서 수동 반영한다. 이 task 는
문서 신설 only — Supabase 에 직접 접근하지 않는다.

## 읽어야 할 파일
1. `CLAUDE.md`
2. `.claude/rules/workflow.md`
3. `.claude/rules/evidence-and-reporting.md`
4. `.claude/rules/safety-and-secrets.md`
5. `docs/rules/pencil-uiux-workflow.md` — 참고 (UI/UX trigger 아님, 무관함 명시 목적)
6. `docs/setup/01_gt_supabase_ddl.sql` — 현재 정책 목록 (읽기 only)
7. `GT_AUTH_ANON_MIGRATION_GUIDE.md` (workspace root, 있으면) — Phase 0 맥락
8. `.ai/tasks/INDEX.md` (있으면)

## 외부 참조
- Supabase 공식 문서 Anonymous Sign-Ins: is_anonymous JWT claim — 참조만

## scope
| 항목 | 포함 여부 |
|------|-----------|
| `docs/backend/rls-matrix.md` 신설 | 포함 |
| `docs/backend/` 디렉터리 생성 | 포함 |
| `.ai/tasks/RLS-DOC-GT-001.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GT-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md` 생성 | 포함 |
| `docs/setup/01_gt_supabase_ddl.sql` 수정 | **제외** (STOP) |
| 실제 Supabase SQL 실행 | **제외** (Coin 수동) |
| `app/` 수정 | **제외** |

## 분류
- Work Type: 문서형
- Reading Mode: 정책-계획 점검형
- Risk: Low
- DBMig: No
- MoneyAuth: Auth 인접 (문서만)
- Cleanup Assessment: N/A (ops-layer)

## STOP 조건
1. `docs/setup/01_gt_supabase_ddl.sql` 수정 → STOP
2. SQL 실행 명령 → STOP
3. `app/src/main/java/**` 수정 → STOP
4. 시크릿 기록 → STOP

## 신설 문서 내용 (docs/backend/rls-matrix.md 본문)

제목: GentlyTable RLS 정책 매트릭스

섹션 구성:
1. 목적
2. 정책 패턴 (Cookbook) — A/B/C/D 정의
3. 테이블 매트릭스

| 테이블 | SELECT | INSERT | UPDATE | DELETE | 정책 ID |
|--------|--------|--------|--------|--------|---------|
| users | ALLOW_OWN | (Auth trigger) | ALLOW_OWN | — | A |
| user_profiles | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | — | A |
| daily_conditions | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | — | A |
| food_db | PUBLIC_READ | BLOCK_ALL | BLOCK_ALL | — | D |
| meal_recommendations | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | — | A |
| exercise_recommendations | ALLOW_OWN | ALLOW_OWN | ALLOW_OWN | — | A |
| daily_tips | ALLOW_OWN | BLOCK_ALL | — | — | C |
| weekly_reports | ALLOW_OWN | BLOCK_ALL | — | — | C |
| monthly_reports | ALLOW_OWN | BLOCK_ALL | — | — | C |
| ticket_balances | ALLOW_OWN | BLOCK_ALL | BLOCK_ALL | — | C |
| ticket_transactions | ALLOW_OWN | BLOCK_ALL | — | — | C |

4. 운영 메모 (A안 정책 반영)
   - GT 의 현재 판정:
     - 기본 온보딩/컨디션: 익명 허용
     - `food_db`: 공용 참조 (PUBLIC_READ, 서버만 쓰기)
     - 추천 2종 (`meal_recommendations` · `exercise_recommendations`): **ALLOW_OWN 유지** (A안). 익명/영구 공통으로 자기 행만 쓰기 허용. AI 호출 어뷰즈 방지는 RLS 단이 아니라 Edge Function `recommend-meal` · `recommend-exercise` 함수 초단의 **Play Integrity 토큰 검증 + 사용자당 daily quota + 티켓 차감** 조합이 담당
     - 리포트 3종 + 티켓 2종: 서버 전용 (현재 DDL 에도 INSERT 정책 없음)
   - 현재 DDL 과 매트릭스 정합성:
     - meal_recommendations · exercise_recommendations INSERT 정책: `auth.uid() = user_id` (패턴 A) — A안 매트릭스와 일치 → **DDL 변경 불필요**
     - 만약 과거에 `is_anonymous = false` 가 추가되어 있다면 Coin 이 Dashboard 에서 DROP 후 패턴 A 로 재생성 (트랜잭션 단위로)
   - 방어 책임 분리:
     - RLS 단: 사용자 신원 확인 (자기 행만)
     - Edge Function 단: 봇 차단 (Integrity) + 비용 어뷰즈 (quota/티켓)
     - 두 겹이 독립적으로 작동해야 A안 가정이 유지됨

5. SoT 경계
   - 이 문서: 정책 설계 SoT
   - 실제 Postgres 정책: Supabase Dashboard SQL Editor (Coin 수동)
   - 동기화 검증: `.ai/tasks/RLS-AUDIT-GT-NNN` (별도 task)

6. Rollback
   - 이 문서 revert: `git revert <commit>`
   - DB 정책 rollback: 이 문서 범위 외

## Measurable Exit Criteria
- [ ] `docs/backend/rls-matrix.md` 존재
- [ ] 매트릭스 11개 테이블 기재 확인 — `grep -c "^| " docs/backend/rls-matrix.md` ≥ 12
- [ ] 패턴 정의 섹션 4개
- [ ] `meal_recommendations` 정책 ID = A 확인 — `grep "meal_recommendations.*| A |" docs/backend/rls-matrix.md`
- [ ] `exercise_recommendations` 정책 ID = A 확인 — `grep "exercise_recommendations.*| A |" docs/backend/rls-matrix.md`
- [ ] 매트릭스 표 행에 PERMANENT_ONLY 0건 — `grep -cE "^\| [a-z_]+ \|.*PERMANENT_ONLY" docs/backend/rls-matrix.md` = 0 (Cookbook 섹션의 패턴 B 정의 본문은 카운트 제외)
- [ ] `food_db` 정책 ID = D 확인 — `grep "food_db.*| D |" docs/backend/rls-matrix.md`
- [ ] `app/` 변경 0
- [ ] DDL 변경 0

## verify 명령
| 명령 | 기대 exit |
|------|----------|
| `git diff --name-only` | 0 |
| `test -f docs/backend/rls-matrix.md` | 0 |
| `grep -c "^| " docs/backend/rls-matrix.md` | 0 (stdout ≥ 12) |
| `grep "meal_recommendations.*\| A \|" docs/backend/rls-matrix.md` | 0 |
| `grep "exercise_recommendations.*\| A \|" docs/backend/rls-matrix.md` | 0 |
| `grep "food_db.*\| D \|" docs/backend/rls-matrix.md` | 0 |
| `grep -cE "^\| [a-z_]+ \|.*PERMANENT_ONLY" docs/backend/rls-matrix.md` | 1 (stdout = 0, 매트릭스 행에 PERMANENT_ONLY 없음) |

## 출력물 경로
- `docs/backend/rls-matrix.md`
- `.ai/tasks/RLS-DOC-GT-001.md`
- `.ai/reports/RLS-DOC-GT-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md`

## 금지 명령
curl · wget · sudo · rm · git commit · git push · git reset · git clean · /tmp · $TMPDIR
```

---

### CLI 프롬프트 RLS-DOC-GB-002 (GentlyBreath — `ai_logs` 행 추가 정정)

> **배경 (블록 밖 요약)**: RLS-DOC-GB-001 생성 시점에는 `ai_logs` 테이블이 GB 매트릭스 대상에서 누락되어 있었다. 이후 Coin 이 Supabase Dashboard 에서 `ALTER TABLE ai_logs ENABLE ROW LEVEL SECURITY;` 를 포함한 GB 보안 마이그레이션을 반영함. 이 정정 task 는 repo 의 `docs/backend/rls-matrix.md` 에 `ai_logs` 행을 추가하고 운영 메모를 보강한다.

```
# RLS-DOC-GB-002 — GentlyBreath RLS 매트릭스에 ai_logs 행 추가 정정

## 요구사항
GentlyBreath repo `docs/backend/rls-matrix.md` 의 테이블 매트릭스에 `ai_logs` 행을 추가한다.
현재 문서는 10 테이블만 기재되어 있어 실제 Supabase 테이블 분포 (11 테이블) 와 drift 상태다.
Supabase 측 RLS 는 별도 보안 마이그레이션으로 이미 활성화됨. 이 task 는 문서 SoT 정정 only —
Supabase 에 직접 접근하지 않고 DDL 도 수정하지 않는다.

## 읽어야 할 파일 (현재 live 확인)
1. `CLAUDE.md`
2. `.claude/rules/workflow.md` — Low Risk 경량화 기준
3. `.claude/rules/evidence-and-reporting.md` — PLAN.md 3-section · REVIEW.md 3-section 형식
4. `.claude/rules/safety-and-secrets.md` — 시크릿 기록 금지
5. `docs/rules/legacy-cleanup-governance.md` — ops-layer task cleanup 규약
6. `docs/backend/rls-matrix.md` — 현재 매트릭스 (수정 대상)
7. `docs/setup/01_gb_supabase_ddl.sql` — 현재 테이블 목록 (읽기 only, 수정 금지)
8. `.ai/reports/RLS-DOC-GB-001/` 산출물 — 1차 task 증거 (참조)
9. `.ai/tasks/INDEX.md` (있으면)

## 외부 참조 (external-prep)
없음. 본 task 는 repo 문서 내부 수정 only.

## scope
| 항목 | 포함 여부 |
|------|-----------|
| `docs/backend/rls-matrix.md` 매트릭스 표에 `ai_logs` 행 1개 추가 | 포함 |
| `docs/backend/rls-matrix.md` "운영 메모" 섹션에 `ai_logs` 1줄 설명 추가 | 포함 |
| `docs/backend/rls-matrix.md` 변경 이력 또는 header 에 "11 테이블" 반영 (헤더에 테이블 수 표기가 있는 경우만) | 포함 (해당 시) |
| `.ai/tasks/RLS-DOC-GB-002.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GB-002/EVIDENCE.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GB-002/PLAN.md` 생성 (3-section) | 포함 |
| `.ai/reports/RLS-DOC-GB-002/VERIFY.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GB-002/REVIEW.md` 생성 (3-section) | 포함 |
| `docs/setup/01_gb_supabase_ddl.sql` 수정 | **제외** (STOP — DB 스키마) |
| 실제 Supabase SQL 실행 | **제외** (Coin 이 별도 Dashboard 에서 이미 실행) |
| `app/` 하위 제품 코드 수정 | **제외** |
| 매트릭스 다른 행 수정 | **제외** (이 task 는 `ai_logs` 행 정정 only) |

## 분류
- Work Type: 문서형 (정정 drift)
- Reading Mode: 정책-계획 점검형
- Risk: Low
- DBMig: No (문서만)
- MoneyAuth: Auth 인접 (문서화는 허용, 실제 정책 반영은 scope 제외)
- Cleanup Assessment: N/A (ops-layer task — 제품 코드 미변경) → EVIDENCE.md 에 명시

## STOP 조건
1. `docs/setup/01_gb_supabase_ddl.sql` 를 Edit/Write 시도 감지 → 즉시 STOP
2. SQL 실행 명령 (psql, supabase CLI) 시도 → 즉시 STOP
3. `app/src/main/java/**` 수정 시도 → 즉시 STOP (경로 밖)
4. 시크릿 기록 시도 (JWT 샘플, 실제 user_id, service_role 키) → 즉시 STOP
5. `ai_logs` 외 다른 매트릭스 행 수정 시도 → 즉시 STOP (scope 확장)

## 추가할 매트릭스 행 (정정 내용 — 블록 안 인라인)

기존 `ticket_transactions` 행 바로 아래에 `ai_logs` 행 1개를 추가한다.

| 테이블 | SELECT | INSERT | UPDATE | DELETE | 정책 ID |
|--------|--------|--------|--------|--------|---------|
| ai_logs | BLOCK_ALL | BLOCK_ALL | — | — | C |

## 추가할 운영 메모 (블록 안 인라인)

기존 "운영 메모" 섹션 내 리포트/티켓 설명 뒤에 아래 한 줄을 추가한다.

> - `ai_logs`: 서버 전용 (Edge Function `generate-checkin-response` + `service_role` 키). RLS 활성화 상태이며 정책 미생성 → 모든 client 경로 차단. service_role 은 RLS 우회하므로 서버 쓰기 경로 영향 없음.

## Measurable Exit Criteria
- [ ] `docs/backend/rls-matrix.md` 에 `ai_logs` 행 존재 — `grep -c "^| ai_logs " docs/backend/rls-matrix.md` = 1
- [ ] `ai_logs` 행의 정책 ID = C — `grep "^| ai_logs " docs/backend/rls-matrix.md | grep -c "| C |"` = 1
- [ ] `ai_logs` 행의 SELECT = BLOCK_ALL — `grep "^| ai_logs " docs/backend/rls-matrix.md | grep -c "BLOCK_ALL"` ≥ 2
- [ ] 운영 메모에 `ai_logs` 언급 — `grep -c "\`ai_logs\`" docs/backend/rls-matrix.md` ≥ 2
- [ ] 기존 10 행 그대로 유지 — `grep -c "^| users \|^| user_preferences \|^| emotion_checkins \|^| emotion_journals \|^| breath_sessions \|^| meditation_sessions \|^| weekly_reports \|^| monthly_reports \|^| ticket_balances \|^| ticket_transactions " docs/backend/rls-matrix.md` = 10
- [ ] `app/` 하위 변경 0 — `git status app/ | wc -l` = 0
- [ ] DDL 파일 변경 0 — `git diff --name-only | grep -c "01_gb_supabase_ddl.sql"` = 0

## verify 명령 (허용된 것만)
| 명령 | 기대 exit |
|------|----------|
| `git diff --name-only` | 0 |
| `test -f docs/backend/rls-matrix.md` | 0 |
| `grep "^| ai_logs " docs/backend/rls-matrix.md` | 0 |
| `grep "\`ai_logs\`" docs/backend/rls-matrix.md` | 0 |

## 출력물 경로
- `docs/backend/rls-matrix.md` (편집)
- `.ai/tasks/RLS-DOC-GB-002.md` (신설)
- `.ai/reports/RLS-DOC-GB-002/EVIDENCE.md` (신설, Cleanup Assessment = N/A)
- `.ai/reports/RLS-DOC-GB-002/PLAN.md` (신설, 3-section 경량화)
- `.ai/reports/RLS-DOC-GB-002/VERIFY.md` (신설)
- `.ai/reports/RLS-DOC-GB-002/REVIEW.md` (신설, 3-section 경량화)

## 금지 명령
curl · wget · sudo · rm · git commit · git push · git reset · git clean · /tmp · $TMPDIR
```

---

### CLI 프롬프트 RLS-DOC-GD-002 (GentlyDay — `ai_insights` 판정 정정)

> **배경 (블록 밖 요약)**: RLS-DOC-GD-001 생성 시점에는 `ai_insights` 행이 `PERMANENT_ONLY / B` 로 기재되었다. 이후 설계 SoT 재검토에서 현 DDL 이 `ai_insights` INSERT 정책 부재 상태로 사실상 `BLOCK_ALL` 동치이고 Edge Function + `service_role` 로만 쓰기가 이루어지므로 `BLOCK_ALL / C` 로 판정 변경. 이 정정 task 는 repo 의 `docs/backend/rls-matrix.md` 한 행과 운영 메모를 수정한다.

```
# RLS-DOC-GD-002 — GentlyDay RLS 매트릭스의 ai_insights 판정 정정

## 요구사항
GentlyDay repo `docs/backend/rls-matrix.md` 의 `ai_insights` 행을 현재 설계 SoT 와 일치하도록
`PERMANENT_ONLY / 정책 ID B` 에서 `BLOCK_ALL / 정책 ID C` 로 수정한다. 해당 행의 근거 설명
(운영 메모 또는 §4.x) 도 `BLOCK_ALL` 유지 근거로 맞춘다. Supabase 에 직접 접근하지 않고
DDL 도 수정하지 않는다.

## 읽어야 할 파일 (현재 live 확인)
1. `CLAUDE.md`
2. `.claude/rules/workflow.md` — Low Risk 경량화 기준
3. `.claude/rules/evidence-and-reporting.md` — PLAN.md 3-section · REVIEW.md 3-section 형식
4. `.claude/rules/safety-and-secrets.md` — 시크릿 기록 금지
5. `docs/rules/legacy-cleanup-governance.md` — ops-layer task cleanup 규약
6. `docs/backend/rls-matrix.md` — 현재 매트릭스 (수정 대상)
7. `docs/setup/01_gd_supabase_ddl.sql` — 현재 테이블·정책 목록 (읽기 only, 수정 금지)
8. `.ai/reports/RLS-DOC-GD-001/` 산출물 — 1차 task 증거 (참조)
9. `.ai/tasks/INDEX.md` (있으면)

## 외부 참조 (external-prep)
없음. 본 task 는 repo 문서 내부 정정 only.

## scope
| 항목 | 포함 여부 |
|------|-----------|
| `docs/backend/rls-matrix.md` 매트릭스 표의 `ai_insights` 행 수정 (INSERT 컬럼 `PERMANENT_ONLY` → `BLOCK_ALL`, 정책 ID `B` → `C`) | 포함 |
| `docs/backend/rls-matrix.md` 운영 메모 또는 §4 섹션의 `ai_insights` 관련 근거 문구 정정 | 포함 |
| `ai_insights` 검증 절차 섹션이 존재하면 최종 `BLOCK_ALL` 결정과 정합되도록 단순화 | 포함 |
| `.ai/tasks/RLS-DOC-GD-002.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GD-002/EVIDENCE.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GD-002/PLAN.md` 생성 (3-section) | 포함 |
| `.ai/reports/RLS-DOC-GD-002/VERIFY.md` 생성 | 포함 |
| `.ai/reports/RLS-DOC-GD-002/REVIEW.md` 생성 (3-section) | 포함 |
| `docs/setup/01_gd_supabase_ddl.sql` 수정 | **제외** (STOP — DB 스키마) |
| 실제 Supabase SQL 실행 | **제외** (Coin 수동) |
| `app/` 하위 제품 코드 수정 | **제외** |
| 매트릭스 다른 행 수정 | **제외** (이 task 는 `ai_insights` 행 정정 only) |

## 분류
- Work Type: 문서형 (정정 drift)
- Reading Mode: 정책-계획 점검형
- Risk: Low
- DBMig: No (문서만)
- MoneyAuth: Auth 인접 (문서화는 허용, 실제 정책 반영은 scope 제외)
- Cleanup Assessment: N/A (ops-layer task — 제품 코드 미변경) → EVIDENCE.md 에 명시

## STOP 조건
1. `docs/setup/01_gd_supabase_ddl.sql` 를 Edit/Write 시도 감지 → 즉시 STOP
2. SQL 실행 명령 (psql, supabase CLI) 시도 → 즉시 STOP
3. `app/src/main/java/**` 수정 시도 → 즉시 STOP (경로 밖)
4. 시크릿 기록 시도 (JWT 샘플, 실제 user_id, service_role 키) → 즉시 STOP
5. `ai_insights` 외 다른 매트릭스 행 수정 시도 → 즉시 STOP (scope 확장)

## 수정 후 매트릭스 행 (정정 내용 — 블록 안 인라인)

`ai_insights` 행 1개만 아래 내용으로 교체한다.

| 테이블 | SELECT | INSERT | UPDATE | DELETE | 정책 ID |
|--------|--------|--------|--------|--------|---------|
| ai_insights | ALLOW_OWN | BLOCK_ALL | — | — | C |

## 수정 후 운영 메모 근거 (블록 안 인라인)

기존 "AI 인사이트: PERMANENT_ONLY ..." 등의 PERMANENT_ONLY 관련 문장을 아래 문구로 교체한다.

> - `ai_insights`: **BLOCK_ALL 유지** — 현재 DDL 에 INSERT 정책이 부재해 사실상 `service_role` 만 쓰기 가능한 상태 (BLOCK_ALL 과 동치). Edge Function + `service_role` 로 AI 결과를 직접 insert 하는 현재 구조와 정합. `PERMANENT_ONLY` 로 변경하면 익명↔영구 JWT 구분이 아니라 서버 내부 호출을 제한하게 되어 불필요한 복잡도 유발 → 현 상태 유지.

`ai_insights` 검증 절차 섹션이 존재하면 최종 판정이 `BLOCK_ALL` 임을 전제로 단순화한다
(익명 JWT 쓰기 테스트는 scope 밖으로 명시).

## Measurable Exit Criteria
- [ ] `ai_insights` 행 INSERT = BLOCK_ALL — `grep "^| ai_insights " docs/backend/rls-matrix.md | grep -c "BLOCK_ALL"` ≥ 1
- [ ] `ai_insights` 행 정책 ID = C — `grep "^| ai_insights " docs/backend/rls-matrix.md | grep -c "| C |"` = 1
- [ ] `ai_insights` 행 PERMANENT_ONLY 부재 — `grep "^| ai_insights " docs/backend/rls-matrix.md | grep -c "PERMANENT_ONLY"` = 0
- [ ] 운영 메모에 "BLOCK_ALL" 근거 문구 존재 — `grep -c "ai_insights.*BLOCK_ALL" docs/backend/rls-matrix.md` ≥ 1
- [ ] 기존 11 행 (ai_insights 제외) 그대로 유지 — `grep -c "^| \(users\|sleep_records\|sleep_stages\|routines\|routine_items\|routine_completions\|habits\|habit_logs\|weekly_reports\|ticket_balances\|ticket_transactions\) " docs/backend/rls-matrix.md` = 11
- [ ] `app/` 하위 변경 0 — `git status app/ | wc -l` = 0
- [ ] DDL 파일 변경 0 — `git diff --name-only | grep -c "01_gd_supabase_ddl.sql"` = 0

## verify 명령 (허용된 것만)
| 명령 | 기대 exit |
|------|----------|
| `git diff --name-only` | 0 |
| `test -f docs/backend/rls-matrix.md` | 0 |
| `grep "^| ai_insights " docs/backend/rls-matrix.md` | 0 |
| `grep "ai_insights.*BLOCK_ALL" docs/backend/rls-matrix.md` | 0 |

## 출력물 경로
- `docs/backend/rls-matrix.md` (편집)
- `.ai/tasks/RLS-DOC-GD-002.md` (신설)
- `.ai/reports/RLS-DOC-GD-002/EVIDENCE.md` (신설, Cleanup Assessment = N/A)
- `.ai/reports/RLS-DOC-GD-002/PLAN.md` (신설, 3-section 경량화)
- `.ai/reports/RLS-DOC-GD-002/VERIFY.md` (신설)
- `.ai/reports/RLS-DOC-GD-002/REVIEW.md` (신설, 3-section 경량화)

## 금지 명령
curl · wget · sudo · rm · git commit · git push · git reset · git clean · /tmp · $TMPDIR
```

---

## 계층 2-C. Play Integrity API 도입 CLI 프롬프트 (3 repo × self-contained)

### 2-C-0. Play Integrity 사전 준비 (Coin 수동 — CLI 진입 전)

아래 **선행 조건** 이 모두 완료되어야 CLI 프롬프트를 실행한다. 선행 없이 코드 구현 진입 시 각 repo 의 `.claude/rules/workflow.md` "외부 준비 항목 연기" 규칙에 따라 stub + `TODO(user-prep)` 처리해야 한다.

| 준비 항목 | 담당 | 위치 | 결과물 |
|----------|------|------|--------|
| Google Cloud Project ↔ Play Console 링크 | Coin | Play Console → App → Setup → Integrity API | Cloud Project Number |
| Play Integrity API 활성화 | Coin | https://console.cloud.google.com/apis/library/playintegrity.googleapis.com | "Enabled" 상태 |
| Service Account 생성 + `Play Integrity API User` 역할 부여 | Coin | console.cloud.google.com → IAM | Service Account email |
| Service Account JSON 키 발급 | Coin | IAM → Service Account → Keys | JSON 파일 (로컬 보관, **repo 에 커밋 금지**) |
| Supabase 환경변수 등록 | Coin | Supabase Dashboard → Project Settings → Edge Functions → Secrets | `PLAY_INTEGRITY_SA_JSON`, `PLAY_INTEGRITY_CLOUD_PROJECT_NUMBER`, `ANDROID_PACKAGE_NAME_<GB/GD/GT>` |
| Edge Function 배포 권한 확인 | Coin | 로컬 `supabase` CLI 로그인 상태 | CLI `supabase projects list` 정상 |

**CLI 진입 판정 규칙**
- 위 6개 항목 모두 완료 → CLI 프롬프트 실행 가능 (아래 2-C-1 · 2 · 3)
- 1개 이상 미완료 → CLI 프롬프트에 `EXTERNAL_PREP_PENDING` 플래그를 전달 → `FakeIntegrityProvider` + `TODO(user-prep)` 만 생성하고 실제 Play Integrity SDK 연동 코드는 stub 으로 남김

### 2-C-1. Play Integrity 도입 공통 설계 (3 repo 공통 참조)

아래 설계는 3 repo CLI 프롬프트가 공유하는 배경. 각 CLI 블록 안에도 필요한 핵심 상수를 인라인한다 (self-contained 원칙).

**클라이언트 계층 (Android Kotlin)**
- 신규 인터페이스: `IntegrityTokenProvider` (변동성 경계 = `platform SDK wrapping`)
- 구현체: `PlayIntegrityTokenProvider` (production) · `FakeIntegrityTokenProvider` (test)
- 호출 지점: 익명 → 영구 전환 시, 티켓 결제/차감 시, AI 호출 게이트 직전
- 반환: `Result<IntegrityToken, IntegrityError>` (typed error — sealed class)

**서버 계층 (Supabase Edge Function — TypeScript)**
- 신규 Function: `verify-integrity-token`
- 역할: Play Integrity API Decode 호출 → verdict 판정 → 성공 시 custom JWT claim 발급 또는 세션 플래그 설정
- verdict 필드: `appIntegrity.appRecognitionVerdict` (PLAY_RECOGNIZED 요구) · `deviceIntegrity.deviceRecognitionVerdict` (MEETS_DEVICE_INTEGRITY 요구 — 정책 판단)
- 실패 경로: RLS 정책에서 추가 클레임 부재 시 민감 연산(티켓 차감, AI 호출) 차단

**의존성 (libs.versions.toml 추가)**
```
[versions]
play-integrity = "1.4.0"  # 2026-04 기준 최신 안정

[libraries]
play-integrity = { group = "com.google.android.play", name = "integrity", version.ref = "play-integrity" }
```

**DependencyDecision 8항목** (CLI 프롬프트가 PLAN §2 에 기록 필수)
1. 공식·표준 지위: Google 공식 SDK · Android 플랫폼 표준 attestation
2. 유지보수 품질: 지속 업데이트 · 분기 릴리스
3. KMP·CMP 호환: Android-only (`platform-shell-only 범위`) · iOS 는 App Attest 별도 도입 필요 (별도 task)
4. transitive 비용: ~200KB AAR · Google Play Services Tasks 의존
5. 기존 기능 중복: 없음 (SafetyNet 후속, SafetyNet 은 2024 sunset)
6. 제거 난이도: 중간 — `IntegrityTokenProvider` 인터페이스로 격리되므로 교체 가능
7. 직접 구현 대비 우위: Google 의 device attestation 은 직접 구현 불가
8. UI 라이브러리 특별 정당화: N/A (UI 라이브러리 아님)

**테스트 심 (TestabilitySeams)**
- `FakeIntegrityTokenProvider` — `commonTest` 또는 JVM unit test 에서 실제 SDK 없이 실행
- 시나리오 stub: 성공 토큰 / 앱 인식 실패 / 장치 무결성 실패 / 네트워크 오류

### 2-C-1-A. A안 전용 Edge Function 게이트 설계

A안 하에서는 Edge Function 이 어뷰즈 방어의 핵심 선(線)이다. 각 AI 호출 함수(`recommend-meal` · `recommend-exercise` · `generate-checkin-response` · GD `generate-ai-insight` 등)는 아래 **4단 게이트** 를 초단에 수행한다.

**4단 게이트 순서**
1. **Auth 확인**: JWT 유효성 + `auth.uid()` 추출. 실패 → 401.
2. **Play Integrity 토큰 검증**: 클라이언트 body 의 `integrity_token` 을 Google Play Integrity API `decodeIntegrityToken` 으로 검증. `appRecognitionVerdict = PLAY_RECOGNIZED` 필수. 실패 → 403 (`INTEGRITY_FAILED`).
3. **사용자당 daily quota 체크**: 오늘 00:00 KST 이후 해당 `user_id` 의 해당 기능 호출 횟수 확인. 한도 초과 → 429 (`QUOTA_EXCEEDED`). **익명/영구 무관 동일 적용**.
4. **티켓 차감** (결제 기능인 경우): `ticket_balances` 에서 1 차감 시도. 잔액 부족 → 402 (`INSUFFICIENT_TICKETS`).

4단 모두 통과한 뒤에야 OpenAI/내부 LLM 호출. 실제 AI 응답은 `service_role` 로 RLS 우회하여 결과 테이블에 INSERT.

**quota 저장 테이블 설계 (신규 제안)**
```
CREATE TABLE ai_usage_counters (
  user_id UUID NOT NULL REFERENCES auth.users(id),
  feature_key TEXT NOT NULL,         -- 'recommend_meal' | 'recommend_exercise' | ...
  day_kst DATE NOT NULL,             -- KST 기준 일자
  call_count INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, feature_key, day_kst)
);
-- RLS: client 는 읽기 ALLOW_OWN, 쓰기는 service_role 만 (BLOCK_ALL)
```
테이블 신설은 DB migration 이라 **Coin 수동** 경로. Sub-task SERVER-001 에서 Edge Function 이 이 테이블을 UPSERT 한다.

**quota 기본값 (Coin 결정 필요, [UNKNOWN])**
| 기능 | 익명 daily | 영구 daily | 비고 |
|------|-----------|-----------|------|
| GB `generate-checkin-response` | [UNKNOWN] | [UNKNOWN] | 티켓 차감 병행 여부도 결정 대상 |
| GD `generate-ai-insight` | [UNKNOWN] | [UNKNOWN] | |
| GT `recommend-meal` | [UNKNOWN] | [UNKNOWN] | |
| GT `recommend-exercise` | [UNKNOWN] | [UNKNOWN] | |

숫자는 제품 결정. "A안 의도상 익명/영구 동일하되 티켓으로 유료 상향 가능" 기본 원칙만 명시. 숫자 확정 후 Sub-task SERVER-001 CLI 프롬프트에 인라인.

**IP/디바이스 단위 보조 방어 (선택)**
- 동일 `device_id` (Integrity 토큰에서 파생) 당 daily 신규 계정 생성 N회 제한
- 동일 IP 에서 익명 신규 계정 생성 burst 감지
- 구체 임계치는 Coin 결정 항목 ([UNKNOWN])

### 2-C-2. 판정 규모 요약 (Risk=Medium)

| 영역 | 파일 수 (예상) | LOC |
|------|--------------|-----|
| libs.versions.toml 수정 | 1 | 3 |
| `IntegrityTokenProvider` 인터페이스 + sealed error | 1 | 40 |
| `PlayIntegrityTokenProvider` 구현체 | 1 | 80 |
| `FakeIntegrityTokenProvider` 테스트용 | 1 (test) | 30 |
| DI 모듈 등록 (`di/AppModule.kt`) | 1 | 10 |
| Edge Function `verify-integrity-token` | 1 | 100 |
| Repository 게이트 포인트 (티켓/AI) | 2 | 40 |
| 단위 테스트 | 2 | 80 |
| **합계** | **10 파일** | **~383 LOC** |

Medium Risk 의 SoftBudget 는 단일 Screen+ViewModel+UiState 기준 120 LOC 이하다. 이 task 는 해당 기준을 초과 → **task 분할 필수**.

**분할 규칙** (CLI 프롬프트에 반영):
- Sub-task 1: libs.versions.toml + `IntegrityTokenProvider` 인터페이스 + `FakeIntegrityTokenProvider` (SoftBudget 준수)
- Sub-task 2: `PlayIntegrityTokenProvider` 구현체 + DI 등록
- Sub-task 3: Edge Function `verify-integrity-token` (별도 server 경로 — `app/` 밖이므로 별 task)
- Sub-task 4: Repository 게이트 포인트 주입 (티켓/AI 1개씩 분리)

아래 CLI 프롬프트는 **Sub-task 1 (인터페이스 + Fake + libs)** 만 포괄. 나머지 sub-task 는 Sub-task 1 VERIFY PASS 후 Coin 이 별도 프롬프트로 실행.

---

### CLI 프롬프트 INTEGRITY-GB-001 (Sub-task 1 — GentlyBreath)

```
# INTEGRITY-GB-001 — Play Integrity 인터페이스 + Fake + libs 추가 (Sub-task 1)

## 요구사항
익명 로그인 도입 후 티켓/AI 호출 게이트에 Play Integrity attestation 을 적용하기 위한
첫 단계로, 클라이언트 측 인터페이스 경계와 테스트 심을 먼저 구축한다.
실제 Google SDK 호출 구현체 (Sub-task 2) 와 서버 검증 (Sub-task 3) 는 본 task 범위 외.

## 읽어야 할 파일 (현재 live 확인)
1. `CLAUDE.md`
2. `.claude/rules/workflow.md` — Medium Risk 전체 10-section PLAN 요건 / 변동성 경계 원칙
3. `.claude/rules/evidence-and-reporting.md` — 10-section PLAN / 12-section REVIEW 형식
4. `.claude/rules/safety-and-secrets.md` — 시크릿 기록 금지
5. `docs/rules/routing-and-delegation.md` — Planner/Generator/Evaluator 경계
6. `docs/rules/legacy-cleanup-governance.md` — code-level task Cleanup Assessment 필수
7. `gradle/libs.versions.toml`
8. `app/src/main/java/com/example/gentlybreath/di/AppModule.kt` (있으면)
9. `app/src/main/java/**/data/remote/SupabaseClientFactory.kt` (또는 동등 파일)
10. `.ai/tasks/INDEX.md`

## 외부 참조 (external-prep, fetch 금지 — 주석 인용만)
- Play Integrity API (https://developer.android.com/google/play/integrity)
- SafetyNet → Integrity 마이그레이션 (https://developer.android.com/google/play/integrity/migrate)

## 선행 조건 판정 (EXTERNAL_PREP)
- Google Cloud Project + Service Account + Supabase Secrets 설정 완료 여부 = "EXTERNAL_PREP_COMPLETE" 또는 "EXTERNAL_PREP_PENDING"
- PENDING 이면: `IntegrityTokenProvider` 인터페이스만 생성 + `FakeIntegrityTokenProvider` 만 생성, DI 바인딩은 Fake 로 우선 유지, `TODO(user-prep)` 주석으로 Real 구현체 차후 교체 표시

## scope
| 항목 | 포함 |
|------|------|
| `gradle/libs.versions.toml` 에 `play-integrity` version + library 등록 | 포함 |
| `app/src/main/java/com/example/gentlybreath/data/integrity/IntegrityTokenProvider.kt` 신설 (인터페이스) | 포함 |
| `app/src/main/java/com/example/gentlybreath/data/integrity/IntegrityError.kt` 신설 (sealed class) | 포함 |
| `app/src/test/java/com/example/gentlybreath/data/integrity/FakeIntegrityTokenProvider.kt` 신설 | 포함 |
| `app/src/test/java/com/example/gentlybreath/data/integrity/FakeIntegrityTokenProviderTest.kt` 신설 | 포함 |
| DI 바인딩 (Fake → prod 교체는 Sub-task 2 의 몫, 본 task 는 Fake 만) | 포함 |
| `.ai/tasks/INTEGRITY-GB-001.md` + `.ai/reports/INTEGRITY-GB-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md` 생성 | 포함 |
| Real `PlayIntegrityTokenProvider` 구현 | **제외** (Sub-task 2) |
| Edge Function `verify-integrity-token` | **제외** (Sub-task 3) |
| Repository 게이트 포인트 주입 (티켓·AI) | **제외** (Sub-task 4) |
| DDL 수정 · Supabase 정책 변경 | **제외** (RLS-DOC-GB-001 및 Coin 수동) |
| `app.build.gradle.kts` 수정 | **제외** — libs.versions.toml 만 |

## 분류
- Work Type: 구현
- Reading Mode: 구현형
- Risk: Medium (Auth/Money 인접 경계 + libs.versions.toml 변경)
- DBMig: No
- MoneyAuth: Auth 인접 · 결제 게이트 의존성 (실제 Money 경로는 Sub-task 4 에서 게이트)
- SoftBudget (Medium Risk): 120 LOC 이하 — 본 task 는 인터페이스 40 + Fake 30 + Test 40 = ~110 LOC 예상 → 준수

## STOP 조건
1. `app/build.gradle.kts` 또는 제품 모듈 의존성 선언 파일 수정 → STOP (libs.versions.toml 만 허용)
2. 실제 Play Integrity SDK 호출 코드 작성 시도 → STOP (Sub-task 2)
3. `docs/setup/01_gb_supabase_ddl.sql` 수정 시도 → STOP
4. 시크릿 값 기록 시도 (Service Account JSON 내용, cloudProjectNumber 실제 값) → STOP
5. EXTERNAL_PREP_PENDING 인데 Real Provider 를 DI 에 바인딩 시도 → STOP

## 구현 설계

### 1. libs.versions.toml 패치 (최소 변경)
[versions] 섹션에 추가:
  play-integrity = "1.4.0"

[libraries] 섹션에 추가:
  play-integrity = { group = "com.google.android.play", name = "integrity", version.ref = "play-integrity" }

### 2. IntegrityTokenProvider.kt (인터페이스)
package com.example.gentlybreath.data.integrity

/**
 * Play Integrity token 획득 경계 (변동성 경계 = platform SDK wrapping).
 * production 구현체 = PlayIntegrityTokenProvider (Sub-task 2)
 * test 구현체 = FakeIntegrityTokenProvider
 */
interface IntegrityTokenProvider {
    /**
     * @param nonce 서버가 생성한 nonce (Base64). 서버-클라이언트 무결성 바인딩 용도.
     * @return 성공 시 Google 발급 token 문자열, 실패 시 IntegrityError
     */
    suspend fun requestToken(nonce: String): Result<String, IntegrityError>
}

(Kotlin 의 typed Result<T, E> 는 arrow-kt 의 Either 또는 자체 sealed class 중 하나를 사용.
현 repo 가 이미 채택한 패턴 확인 후 동일 방식 따름. 없으면 자체 sealed class:)

sealed interface IntegrityResult<out T> {
    data class Ok<T>(val value: T) : IntegrityResult<T>
    data class Err(val error: IntegrityError) : IntegrityResult<Nothing>
}

→ 위 확인 결과에 따라 `Result<String, IntegrityError>` 또는 `IntegrityResult<String>` 중 하나 선택.
   선택 근거는 PLAN §5 ErrorPolicy 에 기록.

### 3. IntegrityError.kt
package com.example.gentlybreath.data.integrity

sealed class IntegrityError {
    object ApiUnavailable : IntegrityError()
    object AppNotRecognized : IntegrityError()
    object DeviceIntegrityFailed : IntegrityError()
    data class Network(val cause: Throwable? = null) : IntegrityError()
    data class Unknown(val cause: Throwable? = null) : IntegrityError()
}

### 4. FakeIntegrityTokenProvider.kt (test source set)
package com.example.gentlybreath.data.integrity

class FakeIntegrityTokenProvider(
    private var nextResponse: Result<String, IntegrityError> =
        Result.success("fake-token-ok"),
) : IntegrityTokenProvider {
    override suspend fun requestToken(nonce: String): Result<String, IntegrityError> {
        lastNonce = nonce
        return nextResponse
    }
    var lastNonce: String? = null
        private set
    fun setResponse(response: Result<String, IntegrityError>) {
        nextResponse = response
    }
}

### 5. FakeIntegrityTokenProviderTest.kt
- 성공 케이스: setResponse(Ok("token")) → requestToken → Ok("token")
- 실패 케이스: setResponse(Err(AppNotRecognized)) → requestToken → Err
- nonce 보관 검증: lastNonce == 전달한 nonce

### 6. DI 바인딩 (본 task 에서는 FakeIntegrityTokenProvider 바인딩만)
EXTERNAL_PREP_PENDING 이면:
- di/AppModule.kt 에 `@Provides fun provideIntegrityTokenProvider(): IntegrityTokenProvider = FakeIntegrityTokenProvider()` 추가
- 주석으로 `// TODO(user-prep): Play Integrity Cloud Project 설정 완료 후 PlayIntegrityTokenProvider 로 교체 (Sub-task INTEGRITY-GB-002)` 명시

EXTERNAL_PREP_COMPLETE 이지만 본 task 는 Sub-task 1 이므로:
- 동일하게 FakeIntegrityTokenProvider 바인딩 + TODO 주석
- Sub-task 2 에서 교체

## 모델 분리 (Model Separation)
- IntegrityError = data layer sealed class (변환 경계 없음 — domain 쪽에서도 그대로 사용 가능하도록 경계 매핑 단순화)
- UiState · DomainModel 과 직접 연결 없음 (본 task 는 주입 경계만 마련)

## Measurable Exit Criteria
- [ ] `grep -n "play-integrity" gradle/libs.versions.toml` — 2 matches (versions + libraries)
- [ ] `test -f app/src/main/java/com/example/gentlybreath/data/integrity/IntegrityTokenProvider.kt`
- [ ] `test -f app/src/main/java/com/example/gentlybreath/data/integrity/IntegrityError.kt`
- [ ] `test -f app/src/test/java/com/example/gentlybreath/data/integrity/FakeIntegrityTokenProvider.kt`
- [ ] `test -f app/src/test/java/com/example/gentlybreath/data/integrity/FakeIntegrityTokenProviderTest.kt`
- [ ] `./gradlew :app:compileDebugKotlin` exit 0
- [ ] `./gradlew :app:testDebugUnitTest --tests "*FakeIntegrityTokenProviderTest"` exit 0
- [ ] 실제 Google Play Integrity SDK import 0건 — `grep -rn "com.google.android.play.core.integrity" app/src/main/ | wc -l` = 0 (Sub-task 2 대기)
- [ ] EVIDENCE.md Cleanup Assessment 섹션 존재

## verify 명령
| 명령 | 기대 exit |
|------|----------|
| `./gradlew :app:compileDebugKotlin` | 0 |
| `./gradlew :app:testDebugUnitTest --tests "*FakeIntegrityTokenProviderTest"` | 0 |
| `grep -c "play-integrity" gradle/libs.versions.toml` | 0 (stdout = 2) |

## PLAN.md 섹션 필수 (10-section, Medium Risk 전체)
- §1 ChangeBudget: FilesN=5, Risk=Medium, DBMig=No, MoneyAuth=Auth 인접
- §2 DependencyDecision: play-integrity 8항목 모두 기술 (위 2-C-1 참조)
- §3 ArchitectureImpact: 신규 인터페이스 = 변동성 경계 (platform SDK wrapping)
- §4 ModelBoundaryPlan: IntegrityError sealed class — data layer only (UiState 미영향)
- §5 ErrorPolicy: typed Result / IntegrityResult 선택 근거 명시
- §6 UIStateFlowPlan: N/A (UI 미변경)
- §7 TestabilitySeams: FakeIntegrityTokenProvider + FakeIntegrityTokenProviderTest 명시
- §8 VerificationPlan: `./gradlew :app:testDebugUnitTest --tests "*FakeIntegrityTokenProviderTest"`
- §9 RollbackStrategy: git revert <commit> — 파일 5개 신설 + libs.versions.toml 2줄 역적용
- §10 ExternalPrep / DeferredItems: EXTERNAL_PREP_PENDING 시 PlayIntegrityTokenProvider 연기 (Sub-task INTEGRITY-GB-002), `TODO(user-prep)` 위치 = di/AppModule.kt

## REVIEW.md 섹션 필수 (12-section, Medium Risk 전체)
§1~§12 모두 작성. §5 Model Separation 은 "UI 미영향, N/A" 명시. §13 Cleanup Governance 는 신설 파일만이므로 "제거 대상 없음" 명시.

## 출력물 경로
- `gradle/libs.versions.toml` (수정)
- `app/src/main/java/com/example/gentlybreath/data/integrity/IntegrityTokenProvider.kt` (신설)
- `app/src/main/java/com/example/gentlybreath/data/integrity/IntegrityError.kt` (신설)
- `app/src/test/java/com/example/gentlybreath/data/integrity/FakeIntegrityTokenProvider.kt` (신설)
- `app/src/test/java/com/example/gentlybreath/data/integrity/FakeIntegrityTokenProviderTest.kt` (신설)
- `app/src/main/java/com/example/gentlybreath/di/AppModule.kt` (수정 — FakeIntegrityTokenProvider 바인딩 추가)
- `.ai/tasks/INTEGRITY-GB-001.md`
- `.ai/reports/INTEGRITY-GB-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md`

## 금지 명령
curl · wget · sudo · rm · git commit · git push · git reset · git clean · /tmp · $TMPDIR
```

---

### CLI 프롬프트 INTEGRITY-GD-001 (Sub-task 1 — GentlyDay)

```
# INTEGRITY-GD-001 — Play Integrity 인터페이스 + Fake + libs 추가 (Sub-task 1)

(GB 프롬프트와 동일 구조. 경로 치환:
 - 패키지: com.example.gentlyday → 실제 repo 패키지 경로 확인 후 치환
 - Grep 대상: `com.google.android.play.core.integrity` 금지 확인
 - 나머지 섹션 구조·PLAN 10-section·REVIEW 12-section·SoftBudget Medium=120 동일)

## 읽어야 할 파일
1. `CLAUDE.md`
2~7. GB 프롬프트와 동일 규칙 파일
8. `gradle/libs.versions.toml`
9. `app/src/main/java/com/example/gentlyday/di/AppModule.kt` (있으면 — 실제 패키지 확인 필요)
10. `.ai/tasks/INDEX.md`

## scope · 분류 · STOP 조건 · 구현 설계 · 모델 분리
GB 프롬프트와 동일. 단 패키지 경로는 repo 실제 값 (`com.example.gentlyday` 가정 — 실제와 다르면 읽은 파일 경로 기준으로 치환).

## Measurable Exit Criteria
GB 와 동일. 단:
- `test -f app/src/main/java/com/example/gentlyday/data/integrity/IntegrityTokenProvider.kt`
- `test -f app/src/test/java/com/example/gentlyday/data/integrity/FakeIntegrityTokenProvider.kt`
- `grep -rn "com.google.android.play.core.integrity" app/src/main/` = 0

## verify 명령
| 명령 | 기대 exit |
|------|----------|
| `./gradlew :app:compileDebugKotlin` | 0 |
| `./gradlew :app:testDebugUnitTest --tests "*FakeIntegrityTokenProviderTest"` | 0 |
| `grep -c "play-integrity" gradle/libs.versions.toml` | 0 (stdout = 2) |

## PLAN.md / REVIEW.md
GB 와 동일 10-section / 12-section 구조. §2 DependencyDecision 8항목 전체 작성.

## 출력물 경로
- `gradle/libs.versions.toml`
- `app/src/main/java/com/example/gentlyday/data/integrity/IntegrityTokenProvider.kt`
- `app/src/main/java/com/example/gentlyday/data/integrity/IntegrityError.kt`
- `app/src/test/java/com/example/gentlyday/data/integrity/FakeIntegrityTokenProvider.kt`
- `app/src/test/java/com/example/gentlyday/data/integrity/FakeIntegrityTokenProviderTest.kt`
- `app/src/main/java/com/example/gentlyday/di/AppModule.kt` (수정)
- `.ai/tasks/INTEGRITY-GD-001.md`
- `.ai/reports/INTEGRITY-GD-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md`

## 금지 명령
curl · wget · sudo · rm · git commit · git push · git reset · git clean · /tmp · $TMPDIR
```

---

### CLI 프롬프트 INTEGRITY-GT-001 (Sub-task 1 — GentlyTable)

```
# INTEGRITY-GT-001 — Play Integrity 인터페이스 + Fake + libs 추가 (Sub-task 1)

(GB·GD 프롬프트와 동일 구조. 경로 치환:
 - 패키지: com.example.gentlytable — 실제 확인됨 (collect 로그 기반)
 - di/AppModule.kt 경로: app/src/main/java/com/example/gentlytable/di/AppModule.kt 확인됨
 - data/remote 경로: data/remote/SupabaseClientFactory.kt 확인됨)

## 읽어야 할 파일
1. `CLAUDE.md`
2. `.claude/rules/workflow.md`
3. `.claude/rules/evidence-and-reporting.md`
4. `.claude/rules/safety-and-secrets.md`
5. `docs/rules/routing-and-delegation.md`
6. `docs/rules/legacy-cleanup-governance.md`
7. `docs/rules/pencil-uiux-workflow.md` — 참고 (본 task 는 UI/UX trigger 아님 명시)
8. `gradle/libs.versions.toml`
9. `app/src/main/java/com/example/gentlytable/di/AppModule.kt`
10. `app/src/main/java/com/example/gentlytable/data/remote/SupabaseClientFactory.kt` — 참고 (Integrity 는 remote 계층 아님, data/integrity 로 분리)
11. `.ai/tasks/INDEX.md`

## scope · 분류 · STOP 조건 · 구현 설계
GB 프롬프트와 동일. 패키지만 `com.example.gentlytable` 로 치환.

## 추가 STOP 조건 (GT 전용)
- `.ai/uiux-sot/latest/**` 가 현재 Compose 변경을 요구하지 않는지 확인 — 본 task 는 UI 미변경이므로 trigger 아님. UI 경로 touch 감지 시 즉시 STOP.

## Measurable Exit Criteria
GB 와 동일. 단:
- `test -f app/src/main/java/com/example/gentlytable/data/integrity/IntegrityTokenProvider.kt`
- `test -f app/src/test/java/com/example/gentlytable/data/integrity/FakeIntegrityTokenProvider.kt`

## verify 명령
| 명령 | 기대 exit |
|------|----------|
| `./gradlew :app:compileDebugKotlin` | 0 |
| `./gradlew :app:testDebugUnitTest --tests "*FakeIntegrityTokenProviderTest"` | 0 |
| `grep -c "play-integrity" gradle/libs.versions.toml` | 0 (stdout = 2) |

## PLAN.md / REVIEW.md
동일 10-section / 12-section.

## 출력물 경로
- `gradle/libs.versions.toml`
- `app/src/main/java/com/example/gentlytable/data/integrity/IntegrityTokenProvider.kt`
- `app/src/main/java/com/example/gentlytable/data/integrity/IntegrityError.kt`
- `app/src/test/java/com/example/gentlytable/data/integrity/FakeIntegrityTokenProvider.kt`
- `app/src/test/java/com/example/gentlytable/data/integrity/FakeIntegrityTokenProviderTest.kt`
- `app/src/main/java/com/example/gentlytable/di/AppModule.kt`
- `.ai/tasks/INTEGRITY-GT-001.md`
- `.ai/reports/INTEGRITY-GT-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md`

## 금지 명령
curl · wget · sudo · rm · git commit · git push · git reset · git clean · /tmp · $TMPDIR
```

---

## 계층 3. 후속 Sub-task 개요 (참고 — 본 task 범위 외)

본 가이드의 CLI 프롬프트는 **Sub-task 1 (인터페이스 + Fake)** 만 다룬다. 전체 Play Integrity 도입은 아래 순서로 진행. **A안 하에서는 SERVER-001 이 실질 방어선**이므로 우선순위가 높다.

| Sub-task | 범위 | 선행 조건 | A안 중요도 |
|----------|------|----------|-----------|
| INTEGRITY-*-001 (본 가이드) | 인터페이스 + Fake + libs.versions.toml | 없음 (external-prep 미완 허용) | 뼈대 |
| INTEGRITY-*-002 | `PlayIntegrityTokenProvider` 실제 구현 + DI prod 전환 | EXTERNAL_PREP_COMPLETE (Cloud Project + Service Account + Supabase Secrets) | 필수 |
| INTEGRITY-QUOTA-DB-001 | `ai_usage_counters` 테이블 신설 DDL (Coin 수동 SQL) + repo 문서 반영 CLI | 설계 확정 (§2-C-1-A) | **필수 (A안 핵심)** |
| INTEGRITY-SERVER-001 | Edge Function 4단 게이트 (Auth / Integrity / quota / 티켓) 배포 | Sub-task 002 + QUOTA-DB-001 + quota 숫자 확정 | **필수 (A안 핵심)** |
| INTEGRITY-GATE-*-001 | Android Repository 에서 AI 호출 전 Integrity 토큰 첨부 | Sub-task SERVER-001 배포 | 필수 |
| INTEGRITY-GATE-*-002 | 티켓 결제 경로에 Integrity 토큰 첨부 | Sub-task GATE-001 VERIFY PASS | 필수 |

각 Sub-task 의 CLI 프롬프트는 해당 단계 진입 시 별도 작성.

> **A안 가정 유지 조건**: SERVER-001 과 QUOTA-DB-001 이 모두 배포 완료되기 전에는 "익명도 AI 허용" 결정이 **무방비 상태**가 된다. 순서 역전 금지 — 클라이언트 쪽에서 "익명도 AI 버튼 활성" UX 를 먼저 풀면 서버 방어 없이 비용 어뷰즈 창이 생긴다. 클라이언트 UX 해제는 SERVER-001 VERIFY PASS 이후.

---

## 계층 4. Coin 실행 체크리스트 (요약) — A안

**지금 바로 가능 (RLS 문서·정책 정합화)**:
1. `[Cowork]` 이 가이드 §1-4 (A안 결정 근거) · §2-A-3 매트릭스 검토. 특히 GT 추천 2종이 패턴 A 로 변경된 점 확인.
2. `[Supabase Dashboard]` SQL Editor 에서 §2-A-4 감사 쿼리 1~4 실행 → 현재 상태 스냅샷 로컬 보관.
3. `[Supabase Dashboard]` §2-A-5 실행 순서 2단계 — GT `meal_recommendations` · `exercise_recommendations` 의 INSERT 정책이 `is_anonymous` 조건을 포함하면 DROP 후 패턴 A 로 재생성 (단일 트랜잭션). 포함하지 않으면 변경 없음.
4. `[Supabase Dashboard]` §2-A-6 GB 보안 마이그레이션 실행 (`ai_logs` RLS 활성화 + `profile-images` 익명 업로드 차단 — A안 적용 범위 밖, 별도 근거).
5. `[CLI]` RLS-DOC-GB-001 / RLS-DOC-GD-001 / RLS-DOC-GT-001 프롬프트 실행 (3 repo 병렬 가능). GT 프롬프트는 이번 A안 반영본 사용.
6. `[CLI]` 기타 정정 task (RLS-DOC-GB-002 `ai_logs` 행 추가, RLS-DOC-GD-002 `ai_insights` 판정 정정) — 5 번이 DONE 이어야 진입.

**A안 핵심 방어선 구축 (외부 준비 후)**:
7. `[Google Cloud Console]` Play Integrity API 활성화 + Service Account 키 발급.
8. `[Play Console]` App ↔ Cloud Project 링크.
9. `[Supabase Dashboard]` Edge Functions Secrets 등록 (`PLAY_INTEGRITY_SA_JSON` · `PLAY_INTEGRITY_CLOUD_PROJECT_NUMBER` · `ANDROID_PACKAGE_NAME_<GB/GD/GT>`).
10. `[Coin 결정]` §2-C-1-A quota 기본값 확정 (기능별 익명/영구 daily 횟수, 티켓 차감 병행 여부). [UNKNOWN] 상태로는 SERVER-001 진입 불가.
11. `[Supabase Dashboard]` `ai_usage_counters` 테이블 신설 SQL 실행 (§2-C-1-A 스키마). 트랜잭션 단위.
12. `[CLI]` INTEGRITY-GB-001 / GD-001 / GT-001 (Sub-task 1 — 인터페이스 + Fake). 외부 준비 미완 상태에서도 실행 가능.
13. `[CLI]` INTEGRITY-*-002 (실제 SDK 구현). 7~9 완료 후.
14. `[CLI]` INTEGRITY-SERVER-001 (Edge Function 4단 게이트). 10~11 완료 후. **이게 배포돼야 A안 가정 성립**.
15. `[CLI]` INTEGRITY-GATE-*-001 / 002 (Repository 에서 토큰 첨부). 14 완료 후.
16. `[Product]` 클라이언트 UX 에서 "익명도 AI 사용 가능" UI 를 여는 것은 **15 VERIFY PASS 이후**.

**이 가이드에 포함되지 않은 것**:
- 실제 Supabase 정책 SQL 의 DDL 파일 수정 (DB migration 경로 — STOP)
- 실제 Play Integrity SDK 호출 구현 코드 (Sub-task 2 CLI 프롬프트는 별도 작성)
- Edge Function 4단 게이트 구현 코드 (Sub-task SERVER-001 CLI 프롬프트는 별도 작성)
- Repository 게이트 포인트 주입 (Sub-task GATE CLI 프롬프트는 별도 작성)
- quota 숫자 확정 (Coin 제품 결정)
- funnel 유인 대체안 (데이터 복구/장기 트렌드 등 — Coin 제품 결정)
