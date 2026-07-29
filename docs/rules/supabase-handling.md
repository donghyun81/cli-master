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
- `supabase functions logs <name>` — tail (자동화 가능) — ⚠ **supersede: 본 서브커맨드 부재 실측(v2.98.2) · 현행 경로 = §2.10 Management API `logs.all`** (구 서술 = 이력 보존)
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

### §2.10 Edge Function 로그 조회 = Management API `logs.all` (**단일 경로** · 콘솔은 fallback · 2026-07-26 신설)

> **★`supabase functions logs` 서브커맨드는 존재하지 않는다** (실측 = CLI `v2.98.2` · `supabase functions --help` available = `delete` / `deploy` / `download` / `list` / `new` / `serve` **6종**). 그러나 **도구의 부재 ≠ 경로의 부재** — EF 로그는 Management API 로 **cli 자동 조회 가능**하다 (= `code-principles.md` §2 표면 속성 분류 금지 실측 사례 3).

- **경로**: Management API **`logs.all`** endpoint. §3.1 Phase 3 의 `/database/query` 와 **동일 PAT** 를 쓴다 (= 별도 자격 증명 불요 · staging = env inject 토큰 · prod = inline 캡처 토큰 · §10.5 2-tier 정합).
- **조회 대상 테이블 3종**: `function_logs` (= EF 런타임 `console.*` 출력) · `function_edge_logs` (= 요청/응답 edge 계층) · `edge_logs` (= 전역 edge).
- **콘솔(Dashboard Logs UI) = fallback** — 시각 비교 / 차트 한정. **"콘솔만 가능"은 오단정**이다.
- **정정 이력 (supersede · 원문 삭제 0)** — 아래 3 곳의 `supabase functions logs` 서술은 **본 §2.10 으로 supersede** 된다 (구 서술 = 이력 보존 · 현재형 규정 아님):
  - `§2.1` — *"`supabase functions logs <name>` — tail (자동화 가능)"*
  - `§4.4` — *"`supabase functions logs --tail` 자동화 가능 (§2.1 정합)"*
  - `§10.3` 표 — *"EF log tail (= streaming) | **supabase CLI** (`supabase functions logs --tail`)"* → **Management API `logs.all`**
- 실측 근거: 서브커맨드 부재를 확인한 cowork 이 **"콘솔만 가능"으로 오단정** → EF 진단이 한 cycle 지연됐다. 실재하는 경로를 **도구 이름으로 판정**한 사고.

---

## §3 권장 검토 영역 (CLI 자동 가능 + 첫 적용 시 사용자 확인 의무)

비가역성 / 영향 범위 / Dashboard 우월성 측면에서 첫 적용 시 사용자 명시 승인 후 진행.

### §3.1 Production apply — "승인-후-cli-push" recipe (`db push` 금지 · Management API 단일 경로)

> **본질**: prod DDL/RLS/EF 적용 = **"staging 자율 → Coin 명시 승인 → cli prod push"** 단일 표준 recipe. cli 는 GB/GD/GT prod 에 이미 적용해 온 경로(Management API + prod Keychain 토큰 + 명시 승인)를 박제 → 매 세션 재발명 + 토큰 캡처 단계 누락 시 "prod 도달 불가 STOP"(예: daily_tips GT) 재발 차단. **정책/capability 문제 아님** — recipe 미박제가 원인.
> **검증 선례**: GT-USERS-FK-RESTORE-001 (`_ops/prod-apply.ts` · Management API · parity 14/14 · prod history 12→13 · "사용자 명시 승인 후") · GB·GD-PROD-APPLY-001 (EF prod deploy · GD 측 prod DB pw slot 부재 실측).

#### Phase 1 — staging (cli 자율)
- env `SUPABASE_ACCESS_TOKEN_<self>` = staging org 토큰 (`~/bin/claude-wrap.sh` inject 기존 · §10.5 staging tier). 마이그 멱등 적용 + 수렴 verify + `functions deploy` + e2e → 보고.

#### Phase 2 — 승인 게이트 (Coin 명시 "prod OK")
- staging 검증 PASS 보고 후 Coin 명시 **"prod OK"** 수신 전까지 **prod 무접촉**. 승인 없는 prod = §5 STOP (master `CLAUDE.md` §5 STOP #1 정합).

#### Phase 3 — prod (승인 후 cli push · 8 step)
1. **prod 토큰 inline 캡처**: `security find-generic-password -s supabase-g<self>-prod-token -a "$USER" -w` (subshell `$()` only · echo 0 · 즉시 unset · env 영구 적재 X · 평문 file/commit 0 · `safety-and-secrets.md` 정합 · §10.5 prod tier).
2. **prod ref 가시 확인**: `GET /v1/projects` (prod 토큰) → `<self>` prod ref 가시 확인. 부재 = STOP (= env 토큰 = staging org → prod Keychain slot 로드 필요).
3. **PHASE A — 측정 (read-only)**: Management API `/database/query` (`read_only=true`) 로 prod 라이브 shape/RLS 측정 → 기대치 대조. 상이 = STOP.
4. **apply (atomic)**: Management API `/database/query` (`read_only=false`) direct-apply. ★`supabase db push` 금지 (prod DB pw slot 부재 + live ≠ migrations) · `curl` 아님 (Deno fetch / MCP).
5. **schema_migrations INSERT**: `version` + `name` · `ON CONFLICT DO NOTHING` (history 정합).
6. **PHASE B — 수렴 verify**: 마이그 history N→N+1 수렴 확인.
7. **EF deploy**: `supabase functions deploy <name> --project-ref <prod-ref>` (prod 토큰) — DDL/RLS 성공 後.
8. **smoke + 보고**: parity · prod history N→N+1 · EF version · secret 0 출력.

#### 불변식
1. staging = cli 자율 · prod = **Coin 명시 승인 후에만** (승인 없는 prod = §5 STOP).
2. prod 토큰 = **inline 캡처 · ephemeral · env 미적재** (= 상시 prod 권한 회피 · prod opt-in 유지) · 평문 0.
3. prod write = Management API `/database/query` `read_only=false` **단일 경로** (`db push` / `psql` / `migration list --linked` 차단 = prod DB pw slot 부재).
4. PHASE A 기대치 상이 / 파괴적 변경 필요 / 승인 미수신 / prod 토큰 부재 = STOP.

> prod ref 표 + 토큰 연결 절차 = master-only 운영 runbook (`docs/ops/production-cli-access-tokens.md` · 4-repo propagation 대상 X). 본 recipe 는 ref 를 step 2 (`GET /v1/projects`) 로 런타임 발견 → 하드코딩 X (= 4-repo byte-identical 보존).

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
- `supabase functions logs --tail` 자동화 가능 (§2.1 정합) — 단 시각 비교 / 차트 = Dashboard 우월 — ⚠ **supersede: 서브커맨드 부재 · 현행 = §2.10 Management API `logs.all`** (콘솔 = fallback · 구 서술 이력 보존)

---

## §5 STOP 조건 (CLI 자동 진입 금지 신호)

- §4 영역 키워드 감지 시 사용자 확인 의무
- `safety-and-secrets.md` 안 `curl` / `wget` deny 정합 어긋남 (admin API curl 강제 시도 차단 · `supabase` CLI 또는 SDK 우선)
- `service_role` key 파일 안 평문 작성 시도 (env 주입 의무 · `safety-and-secrets.md` 시크릿 기록 금지 정합)
- production write (= §3.1 Phase 3 · Management API `/database/query` `read_only=false`) 측 Coin 명시 승인 부재 / prod 토큰 부재 / PHASE A 기대치 상이 (= `supabase db push` prod 금지 · prod DB pw slot 부재 = §3.1 불변식 3)
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
mcp / Supabase MCP / mcp__supabase-*
Keychain / security find-generic-password / security add-generic-password
SUPABASE_ACCESS_TOKEN / SUPABASE_ACCESS_TOKEN_GB / SUPABASE_ACCESS_TOKEN_GD / SUPABASE_ACCESS_TOKEN_GT
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

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 4-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## §9 명시 cycle 이력

- 2026-05-16 · CLI-INFRA-SUPABASE-HANDLING-001 · 본 rule 신설 + intake-router supabase 분기 1 섹션 추가 + 4-repo propagation (= master + GB + GD + GT · 본 시점 app-foundation §9 scope 외 default · 본 cycle baseline)
- 2026-05-18 · MASTER-CLI-SUPABASE-COMPREHENSIVE-001 · §10 신설 (= MCP server 호출 paradigm + supabase CLI 통합 paradigm + 자식별 3 instance + Keychain wrap reference + read-only baseline + `cli_...` token 폐기) + §6 키워드 trigger list append + 5-repo byte-identical propagation (= master + app-foundation + GB + GD + GT)
- 2026-07-26 · MASTER-CLI-RULES-SETTLE-001 · **§2.10 신설** (= A-4 · EF 로그 = Management API **`logs.all`** 단일 경로 · `/database/query` 와 **동일 PAT** · `function_logs`/`function_edge_logs`/`edge_logs` · 콘솔 = fallback) + **§2.1 · §4.4 · §10.3 3곳 supersede 표식**(= `supabase functions logs` **서브커맨드 부재 실측** CLI v2.98.2 · 구 서술 **무삭제 이력 보존** · 근거 = 부재를 "콘솔만 가능"으로 오단정 = **도구 부재 ≠ 경로 부재**) + **§11 AI 응답 계약 신설**(= §11.1 JSON 계약 verbatim 인용 시 **낫표 「」 명시** = C-1 · F2 주 원인 = 프롬프트 자신의 verbatim 지시가 raw `"` 유도 → 조기 종료 / §11.2 절단 감지 = **`stop_reason` 1차 · `outputTokens>=maxTokens` 폴백 전용 · OR 금지** = C-2 정정본 · SDK 0.30.0 실취득 23/23 · 초안의 대리-신호-규칙화 = 표면 속성 분류 금지와 정면 충돌 / §11.3 절단·정규화는 **파싱 후 필드에** = C-3 · `MAX_OUTPUT_CHARS 5000` 선절단 → 초과 시 **100% 파싱 실패** / §11.4 외부 응답 실패 경로 **진단 로그 + 마스킹 의무** = A-3 · 발췌 = 모델 출력 한정). **소유 판정 3 기준 실측 PASS**(4-repo byte-identical `f567cff5a52e` · 자기 선언 §8 · `propagate.sh:99` scan set). §1·§3·§5·§6·§7·§10 본문 무접촉. 4-repo byte-identical propagation.
- 2026-06-19 · MASTER-SUPABASE-PROD-APPLY-RECIPE-001 · §3.1 확장 (Production apply = "staging 자율 → Coin 명시 승인 → cli prod push" 8-step recipe · `db push` prod 금지 → Management API `/database/query` `read_only=false` 단일 경로 · 검증 선례 GT-USERS-FK-RESTORE-001 / GB·GD-PROD-APPLY-001) + §10.5 정정 (staging 토큰 `supabase-g{b,d,t}-token` env inject vs prod 토큰 `supabase-g{b,d,t}-prod-token` inline 캡처·env 미적재 2-tier 구분 + prod DB pw slot 부재) + §5 STOP prod write 승인/토큰/PHASE A 게이트 정정 · 반복된 "prod 도달 불가 STOP"(daily_tips GT) 근본 해소 · production code 무접촉 · 6-repo byte-identical propagation

---

## §10 MCP server 호출 paradigm (= MASTER-CLI-SUPABASE-COMPREHENSIVE-001)

> **신설**: 2026-05-18 · `MASTER-CLI-SUPABASE-COMPREHENSIVE-001` · MCP server 호출 paradigm + supabase CLI 통합 paradigm 본문.
> **본질**: §2 CLI 자동 paradigm (= `supabase` CLI 직접 호출) 외 MCP layer 측 도구 호출 paradigm 병행 추가.

### §10.1 MCP server 등록 + 호출 paradigm

`.mcp.json` 측 등록 영역 (= 4-repo byte-identical · `claude-cli-master` + `app-foundation` + `gently-product-docs` + `Selfward`):

| server | project_ref | 자식 도메인 |
|---|---|---|
| `supabase-gb` | `vpmkruzpcpbfpqgpcihp` | 호흡 (GentlyBreath) |
| `supabase-gd` | `davlfkmebzdzolmaznlk` | 일상 (GentlyDay) |
| `supabase-gt` | `jzypsbpdjrxnzodkkfhs` | 식단 (GentlyTable) |

호출 namespace = `mcp__supabase-{gb,gd,gt}__*` (= 자식 도메인 분리). 주요 tool 영역 = `list_tables` / `list_extensions` / `list_migrations` / `execute_sql` (= read-only SELECT) / `get_advisors` / `get_logs` / `list_edge_functions`.

### §10.2 supabase CLI 호출 paradigm 분기

기존 §2 본문 (= CLI 자동 처리 영역) 본문 본질 무접촉. 신 paradigm = wrap script (= `~/bin/claude-wrap.sh`) 측 `SUPABASE_ACCESS_TOKEN_{GB,GD,GT}` env var inject 통합. 자식별 진입 시점 (= 사용자 본인 terminal 또는 cli session 내부):

```bash
SUPABASE_ACCESS_TOKEN="$SUPABASE_ACCESS_TOKEN_GB" supabase functions list --project-ref vpmkruzpcpbfpqgpcihp
# 또는 ~/.zshrc alias paradigm:
supabase-gb projects list   # alias supabase-gb='SUPABASE_ACCESS_TOKEN="$SUPABASE_ACCESS_TOKEN_GB" supabase'
```

### §10.3 분기 결정 표 (= MCP server vs supabase CLI 진입)

| task 영역 | 권장 paradigm | 근거 |
|---|---|---|
| DB schema / extension / migration 조회 | **MCP server** (`mcp__supabase-<자식>__list_*`) | read-only · cli session 직접 호출 |
| read-only SQL (= SELECT) | **MCP server** (`execute_sql`) | read-only baseline 정합 |
| Edge Function deploy / new / delete | **supabase CLI** (`supabase functions deploy` 등) | write paradigm 영역 · §2.1 정합 |
| migration 신설 / apply | **supabase CLI** (`supabase migration new` / `supabase db push`) | write paradigm · §2.3 정합 |
| EF log tail (= streaming) | **supabase CLI** (`supabase functions logs --tail`) — ⚠ **supersede → Management API `logs.all`** (= §2.10 · 서브커맨드 부재 실측) | 실시간 streaming · MCP layer X (= 구 근거 · 이력 보존) |
| performance / security advisor | **MCP server** (`get_advisors`) | MCP 단일 진입점 |
| Vault secret 등록 | **§3.4 정합** (= 사용자 명시 승인 의무) | (= 기존 paradigm 정합) |

### §10.4 read-only baseline (= phased 1 차)

본 cycle 측 baseline = **read-only paradigm 단일** (= `.mcp.json` URL 측 `read_only=true` 의무).

write paradigm 확장 영역 (= `apply_migration` / write SQL 호출) = 별 cycle `MASTER-CLI-MCP-SUPABASE-WRITE-ACTIVATE-001` 분리 default. 본 cycle scope 측 write paradigm 시도 = STOP (= §5 STOP 조건 정합).

### §10.5 Keychain wrap script paradigm (= staging 토큰 vs prod 토큰 2-tier 구분)

token 보관 + 추출 영역 = macOS Keychain · `security find-generic-password` 추출. **2-tier 구분 의무** (= staging 상시 inject vs prod opt-in 캡처 · 혼용 금지):

| tier | Keychain slot | 적재 방식 | org | 사용 |
|---|---|---|---|---|
| **staging** | `supabase-g{b,d,t}-token` (3 slot) | `~/bin/claude-wrap.sh` → env `SUPABASE_ACCESS_TOKEN_<self>` **상시 inject** | staging org | §2 CLI 자동 + §10.2 (cli 자율) |
| **prod** | `supabase-g{b,d,t}-prod-token` (3 slot · **별 slot** · 2026-06-02 등록) | **inline 캡처만** (subshell `$()` · env 미적재 · 즉시 unset) | prod org (GB `bfdt…` · GD/GT `xhcug…` · staging org 와 별개) | §3.1 Phase 3 (Coin 승인 후 한정) |

- prod 토큰 = staging 토큰과 **별 slot** · **env 영구 적재 X** (= 상시 prod 권한 회피 · prod opt-in 유지). staging env 토큰으로 prod ref 불가시 = prod Keychain slot 로드 필요 (§3.1 Phase 3 step 2).
- prod DB password Keychain slot = **부재** → `supabase db push` / `migration list --linked` / `psql` 측 prod 직접 접근 차단 → Management API `/database/query` 가 **prod write 단일 경로** (§3.1 불변식 3).

본문 SoT = [`safety-and-secrets.md` §macOS Keychain 측 secret 보관 paradigm](../../.claude/rules/safety-and-secrets.md). token 평문 commit / file 기록 차단 의무 (= 기존 §"시크릿 기록 금지 규칙" 정합).

### §10.6 자식별 3 instance paradigm

4-repo byte-identical propagation (= master `.mcp.json` 본문 = 4-repo 동일 · 3 server 모두 등록). 자식 cwd 측 cli session 진입 시점 = 3 server 모두 진입 가능 default · 단 호출 namespace 측 자식 도메인 정합 의무 (= GB repo 측 `mcp__supabase-gb__*` 호출 default).

### §10.7 기존 `cli_...` token 폐기 paradigm

본 cycle 진입 baseline = `supabase login` 측 자동 발행 token (= `cli_yundonghyeon@<host>_<timestamp>` 패턴). 본 cycle paradigm = **신 PAT 대체** (= 사용자 Dashboard 발행 + Keychain 등록 + wrap script inject).

폐기 procedure (= 사용자 manual 진입 의무):
1. cli session 측 Step 10 검증 PASS 확인 (= `claude /mcp` 3 server connect + tool 호출 PASS)
2. `https://supabase.com/dashboard/account/tokens` 진입
3. `cli_...` row 측 Revoke
4. 폐기 후 = wrap script 측 inject paradigm 측 자동 인증 default

cli session 측 직접 폐기 시도 = STOP (= §5 정합 · 사용자 manual 의무).

---

## §11 AI 응답 계약 (Edge Function 측 · 2026-07-26 신설 · MASTER-CLI-RULES-SETTLE-001)

> **본 § = EF 안에서 모델(AI) 응답을 받아 파싱/검증하는 경로의 계약 SoT.** 소유 판정 = **master** (3 기준 실측 PASS: 4-repo byte-identical `f567cff5a52e` · 자기 선언 §8 → `rule-footer-common.md` · `propagate.sh:99` scan set `docs` 포함). 클라이언트 SDK 측 = §1 표 정합 (본 rule scope 외).

### §11.1 JSON 출력 계약에서 verbatim 인용을 지시할 때 = **JSON-안전 인용부호 명시** (C-1)

- 모델에게 **JSON 을 출력하게 하면서 동시에 원문 verbatim 인용을 지시**하면, 모델은 인용에 **raw `"`** 를 쓴다 → **JSON 문자열 조기 종료** → 파싱 실패.
- ⟹ 인용부호를 **낫표 「」로 명시**한다 (또는 이스케이프 규칙을 프롬프트에 **명문화**). "적절히 인용하라"는 지시는 계약이 아니다.
- ★**프롬프트 자신이 사고를 유도한다**: **F2 의 주 원인**은 모델의 실수가 아니라 **프롬프트의 verbatim 지시**였다. 출력 형식(JSON)과 내용 지시(verbatim)가 **서로 모순**될 때, 그 모순을 해소하는 책임은 **프롬프트 쪽**에 있다.

### §11.2 절단 감지 = **`stop_reason` 이 1차** · `outputTokens` 는 **폴백 전용** (C-2 · ★정정본)

- **1차 = `stop_reason`** (= 직접 신호). 모델이 **왜 멈췄는지**를 스스로 말한 값.
- **폴백 = `outputTokens >= maxTokens`** (= 대리 신호) — **`stop_reason` 취득에 실패했을 때만** 쓴다.
- **★OR 금지**: `stop_reason` 을 **취득했는데 값이 `max_tokens` 가 아니면 = 정상 종료로 믿는다.** 두 신호를 OR 로 묶으면 **정상 종료를 절단으로 오판**한다(상한 근처에서 정확히 끝난 응답 = 정상).
- **로그에 `maxTokens` 동봉**: "상한 대비 얼마나 썼는지"를 **재현 가능**하게 남긴다 (= §11.4 진단 로그 정합).
- ★**본 항이 정정본인 이유**: 초안은 **대리 신호(`outputTokens`)를 규칙으로 적으려 했다** — 관측 가능한 표면 수치로 내부 상태를 단정하는 형태이며 `code-principles.md` §2 **표면 속성 분류 금지와 정면 충돌**한다. SDK `0.30.0` 에서 `stop_reason` **실취득 확인**(배포 후 **23/23**) → 직접 신호가 1차로 확정.

### §11.3 길이 절단·정규화는 **파싱 후 추출된 필드에** (C-3)

- 절단(truncate) / 정규화는 **JSON 파싱이 끝난 뒤 추출된 필드**에 적용한다.
- **파싱 전 절단 금지** — 원문을 먼저 자르면 **JSON 구조 자체가 깨진다**.
- 실측 근거: `MAX_OUTPUT_CHARS 5000` **선절단** → 상한 초과 응답이 **100% 파싱 실패**했다 (= 길이 초과가 곧 전손). 자르는 위치 하나가 부분 성공을 전손으로 바꾼다.

### §11.4 외부 응답 검증 실패 경로 = **진단 가능 로그 의무** (A-3 · EF 측 정착)

- 검증/파싱 실패 분기는 **① 분기 식별자**(어느 검증에서 떨어졌나) + **② 원문 발췌(상한 명시)** + **③ 에러 메시지** 를 남긴다.
- **마스킹 의무**: 발췌 = **모델 출력 한정** · **사용자 원문 · 키 · 토큰 = 제외** (= `safety-and-secrets.md` §시크릿 기록 금지 정합 · **로그도 파일이다**).
- 조회 경로 = **§2.10 Management API `logs.all`** (`function_logs` / `function_edge_logs` / `edge_logs`).
- 실측 근거: **A1 로그 1개**가 F2 의 미지를 **한 cycle 안에** 닫았다. 그 전까지는 재현 자체가 불가능했다 (= `verification-and-review.md` §외부 응답 검증 실패 경로 정합).
