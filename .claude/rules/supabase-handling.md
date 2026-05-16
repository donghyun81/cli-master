# Supabase Handling Rules

> **단일 목적**: Supabase 도메인 (Edge Function / migration / RLS / Vault / psql / DB push 등) 요청 진입 시 CLI 자동 처리 가능 영역과 Dashboard 한정 영역 분기 + STOP gate 정의.
> **신설**: CLI-INFRA-SUPABASE-HANDLING-001 (2026-05-16).
> **연관 파일**:
> - `safety-and-secrets.md` — curl/wget deny + 시크릿 기록 금지 정책
> - `billing-rules.md` §2 — Edge Function 단일 진입점 (verify-purchase) + §3 Vault 시크릿 저장
> - `auth-rules.md` §1 — GoTrue REST 익명 부트스트랩
> - `deferred-domains.md` §1 STOP trigger (Backend / API) + §5 trigger 키워드
> - `routing-and-delegation.md` — auth-security-privacy + billing-payments-guardian + server-implementer 매핑
> - `cycle-discipline.md` §15 패턴 1 (master cycle 신설 + 4-repo propagation)
> SOT: `CLAUDE.md`

---

## §1 적용 범위

본 rule = CLI 세션이 supabase 도메인 작업 요청 받았을 때 자동 처리 가능 영역과 사용자 확인 의무 영역의 분기 SoT.

| 대상 | 처리 분류 |
|---|---|
| `supabase functions ...` / `supabase secrets ...` / `supabase migration ...` / `supabase db diff` / `supabase gen types ...` / `supabase storage ...` / `supabase link` | §2 CLI 자동 |
| `psql` 임의 SQL (read 우선) | §2 CLI 자동 |
| `supabase/migrations/*.sql` / `supabase/functions/**/*.ts` / `supabase/seed.sql` 직접 edit | §2 CLI 자동 |
| production `supabase db push` / RLS policy 첫 적용 / admin API / Vault 첫 등록 | §3 권장 검토 (사용자 확인 의무) |
| DB backup·restore / billing / API key rotation / 실시간 시각 모니터링 | §4 Dashboard 한정 (STOP) |
| 클라이언트 SDK (supabase-js / supabase-kt) 호출 코드 | 본 rule scope 외 (`auth-rules.md` / `billing-rules.md` 분담) |

---

## §2 CLI 자동 처리 영역 (default)

다음 명령은 사용자 별도 확인 없이 CLI 세션이 직접 실행한다. 비가역성 낮음 + Dashboard 우월성 없음 + Supabase CLI 표준 명령어 영역.

### §2.1 Edge Function lifecycle
- `supabase functions new <name>` — 신규 EF scaffold
- `supabase functions deploy <name>` — staging deploy
- `supabase functions delete <name>` — EF 제거
- `supabase functions serve` — 로컬 서빙
- `supabase functions logs <name>` — tail (자동화 가능)
- repo 안 `supabase/functions/<name>/index.ts` 직접 Edit / Write

### §2.2 Edge Function 환경변수
- `supabase secrets set KEY=VALUE` — EF env 주입 (Vault 와 별개 영역)
- `supabase secrets list`
- `supabase secrets unset KEY`

### §2.3 Migration (git tracked SQL)
- `supabase migration new <name>` — 신규 `.sql` scaffold
- `supabase migration list` — 적용 / 미적용 분리 확인
- `supabase/migrations/<timestamp>_<name>.sql` 직접 Edit / Write

### §2.4 DB schema 동기화
- `supabase db dump --linked --schema-only` — 원격 schema → 로컬 baseline
- `supabase db diff` — 로컬 ↔ 원격 차이 산출
- `supabase db push --linked` — **staging 한정** (production = §3.1 권장 검토)

### §2.5 TypeScript 타입 자동 생성
- `supabase gen types typescript --linked > supabase/functions/_shared/types.ts`

### §2.6 Storage 파일
- `supabase storage cp / ls / mv / rm` (bucket 단위 파일 조작)

### §2.7 임의 SQL (read 우선)
- `psql "$DATABASE_URL" -c "SELECT ..."` — read-only 권장
- write SQL = §3 권장 검토 (비가역 영향 평가 후)

### §2.8 Seed
- `supabase/seed.sql` 직접 Edit
- `supabase db reset` — **local 한정** (remote 시도 = §5 STOP)
- remote seed 재적용 = `psql "$DATABASE_URL" -f supabase/seed.sql` (사용자 확인 후 실행)

### §2.9 Project link (1 회 prereq)
- `supabase link --project-ref <ref>` — repo ↔ project 바인딩

---

## §3 권장 검토 영역 (CLI 자동 가능 + 첫 적용 시 사용자 확인 의무)

비가역성 / 영향 범위 / Dashboard 우월성 측면에서 첫 적용 시 사용자 명시 승인 후 진행.

### §3.1 Production `supabase db push --linked`
- 비가역 schema 변경 포함 가능 (column drop / type 변경 등)
- 2단계 권장 흐름: staging push → 검증 PASS → production push
- 사용자 "production push OK" 명시 의무

### §3.2 RLS policy migration
- 첫 적용 시 Dashboard 시각 검증 후 migration `.sql` 정착 권장
- 권한 / row 접근 오류 = 사용자 발견 어려움 (클라이언트 에러로만 노출)
- 적용 후 `psql` 안 anon role / authenticated role 별 `SELECT ... FROM <table>` 검증 의무

### §3.3 Admin API (auth 사용자 관리)
- `auth.admin.deleteUser()` / `auth.admin.updateUserById()` 등 = service_role key 필요
- `safety-and-secrets.md` 안 `curl` / `wget` deny 와 정합 어긋남 (admin API curl 강제 불가)
- CLI 우선 경로: `supabase functions invoke` 통해 EF 내부에서 admin API 호출 (service_role key = EF env 주입)
- 또는 supabase-js / supabase-kt SDK 안 `auth.admin` 사용 (코드 path)

### §3.4 Vault 시크릿 SQL 등록 (`vault.create_secret`)
- SQL 등록 가능: `SELECT vault.create_secret('value', 'name', 'description')`
- Dashboard UI 우월 (시크릿 노출 위험 줄임)
- 첫 등록 시 Dashboard 권장 · rotation / 갱신 = SQL 또는 Dashboard 자유

---

## §4 Dashboard 한정 영역 (CLI 자동 진입 STOP 의무)

다음은 CLI 자동 진입 금지. 사용자 확인 없이 직접 실행 X.

### §4.1 DB backup / restore
- Supabase 자동 PITR (Point-in-Time Recovery) + daily snapshot = Dashboard 단일 진입점
- `pg_dump` 수동 백업 가능하나 production restore = Dashboard 의무

### §4.2 Billing / project settings
- 구독 plan 변경 / 사용량 모니터링 / project 일시 정지 / 삭제
- API key rotation (anon / service_role 키 재발급)
- region / instance size 변경

### §4.3 Vault 시크릿 첫 등록
- SQL 가능하나 Dashboard 우월 (시크릿 노출 위험 회피 · §3.4 정합)

### §4.4 실시간 시각 모니터링
- Dashboard Logs / Reports UI 시각 추적
- `supabase functions logs --tail` 자동화 가능 (§2.1 정합) — 단 시각 비교 / 차트 = Dashboard 우월

---

## §5 STOP 조건 (CLI 자동 진입 금지 신호)

- §4 영역 키워드 감지 시 사용자 확인 의무
- `safety-and-secrets.md` 안 `curl` / `wget` deny 정합 어긋남 (admin API curl 강제 시도 차단 · `supabase` CLI 또는 SDK 우선)
- `service_role` key 파일 안 평문 작성 시도 (env 주입 의무 · `safety-and-secrets.md` 시크릿 기록 금지 정합)
- production `supabase db push` 사용자 명시 승인 부재
- production `supabase db reset` 시도 (비가역 · local 한정 의무)
- `vault.create_secret` 첫 등록 사용자 확인 부재 (§4.3 정합)

---

## §6 키워드 trigger list (intake-router 분기 신호)

본 키워드 감지 시 본 rule reading 의무 + §2 / §3 / §4 분류 + §5 STOP 검증.

```
supabase / Supabase
edge function / EF / supabase functions
migration / supabase migration / supabase/migrations/*.sql
RLS / policy / row level security
Vault / vault.create_secret
psql / $DATABASE_URL
supabase db / supabase db push / supabase db reset / supabase db dump / supabase db diff
auth admin / auth.admin
supabase secrets
supabase gen types
supabase storage
supabase link
service_role / anon key
```

---

## §7 인접 SoT 정합

| 항목 | 인접 rule | 정합 영역 |
|---|---|---|
| Edge Function 단일 진입점 (영수증 검증) | `billing-rules.md` §2 | EF = client → server 단일 게이트 · 클라이언트 직접 Google Play Developer API 호출 금지 |
| Vault 시크릿 저장 (Service Account JSON) | `billing-rules.md` §3 | Vault 우선 · EF env 주입 |
| GoTrue REST 익명 부트스트랩 | `auth-rules.md` §1 | `POST /auth/v1/signup` body `{}` = 클라이언트 SDK 영역 (admin API 영역 외) |
| service_role key 노출 금지 | `safety-and-secrets.md` (시크릿 기록 금지) | 평문 작성 금지 · EF env 주입 |
| Backend / API STOP trigger | `deferred-domains.md` §1 #3 | Supabase Edge Function = Backend 도메인 STOP trigger |

---

## §8 본 rule 의 변경 정책

- cli infra 권장 byte-identical (4-repo · master + GentlyBreath + GentlyDay + GentlyTable)
- 변경 시 master cycle 신설 + 4-repo propagation 의무 (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## §9 명시 cycle 이력

- 2026-05-16 · CLI-INFRA-SUPABASE-HANDLING-001 · 본 rule 신설 + intake-router supabase 분기 1 섹션 추가 + 4-repo propagation
