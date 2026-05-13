# External Dependency Abstraction — paradigm SoT

> **단일 목적**: 외부 SDK / library 의존 영역 측 추상화 paradigm 영구 SoT.
> **신설 cycle**: MASTER-DOCS-ARCHITECTURE-EXTERNAL-DEP-ABSTRACTION-001 (2026-05-13).
> **propagate 등급**: P1 권장 byte-identical (= cli infra 동족 영역 · 5-repo).
> **prerequisite 영역**: 자식 3-repo `#7-γ GB/GD/GT-MIGRATE-FACADE-001` 별 cycle 진입 baseline.

---

## 1. A2 paradigm (= "최소 노출" paradigm)

### 1.1 본질

외부 SDK dep scope 분류 = consumer 직접 인용 의무 영역 한정 `api` · 나머지 `implementation` 유지.

### 1.2 적용 예 (= H1-γ FND-PUBLISH-API-SCOPE-001-A2-FIX 마감 시점)

| scope | dep | 사유 |
|---|---|---|
| `api` (3 dep) | `supabase-bom` | transitive version 결정 영역 |
| `api` | `supabase-auth` | consumer 측 `SupabaseClient` + auth Session type 직접 인용 의무 |
| `api` | `kotlinx-coroutines-core` | `Flow<String?>` + suspend type public interface 노출 |
| `implementation` (5 dep) | `postgrest-kt` | consumer 인용 X 영역 (= facade 통한 우회) |
| `implementation` | `realtime-kt` | 동족 |
| `implementation` | `storage-kt` | 동족 |
| `implementation` | `functions-kt` | 동족 |
| `implementation` | `kotlinx-serialization-json` | consumer 측 own DTO 자체 dep 등록 영역 |

### 1.3 본심

public surface 최소화. consumer 측 외부 SDK type 인지 영역 한정.

### 1.4 ROI

- (a) library 교체 가능 (= dep 측 격리 영역)
- (b) consumer 측 paradigm 통합 (= 자식 3-repo 균질 baseline)
- (c) compile 시간 단축 (= classpath 측 transitive 영역 축소)

---

## 2. facade paradigm (= 외부 library 추상화 paradigm)

### 2.1 본질

외부 SDK type → 도메인 interface (= 포트) 통해 consumer 인용. consumer 측 외부 SDK type 직접 인용 X 의무.

### 2.2 구조

| layer | 의무 |
|---|---|
| foundation 측 | 외부 SDK 직접 dep + facade interface (= 포트) 정의 + impl 영역 |
| consumer 측 (자식 repo) | facade interface 만 인용 · 외부 SDK type 직접 인용 X 의무 |

### 2.3 ROI

- (a) library 교체 가능 (= 외부 SDK 영역 격리)
- (b) test fake 가능 (= interface Fake 영역 · `FakeSecureTokenStore` 패턴 정합)
- (c) consumer paradigm 통합 (= 자식 3-repo 균질 정착)

### 2.4 본심

외부 library = 도메인 invariant 분리 영역. consumer = 도메인 interface 만 의식.

---

## 3. paradigm 강화 trigger (= 3 trigger · paradigm 위배 자동 감지 baseline)

### 3.1 dep 광범위 trigger

외부 library dep scope = `api` 광범위 (= public surface 측 외부 type 노출 광범위) = paradigm 위배 가능 영역.

**근거 사고**: H1-γ FND-PUBLISH-API-SCOPE-001 fb3be81 (= cli session 자체 결정 = api 8 dep 광범위 vs A2 본심 = 3 dep 한정 mismatch).

### 3.2 외부 SDK 직접 인용 trigger

consumer 측 외부 SDK type 직접 인용 (= facade 바이패스) paradigm 위배 영역.

**근거 사고**: H1-γ GT-MIGRATE-SUPABASE-FOUNDATION-001 STOP 5 영역 (= GT app 측 `SupabaseClient` transitive type access 의무 영역 발견).

### 3.3 facade 바이패스 trigger

facade interface 정의 영역 안 외부 SDK type 노출 (= "포트" 측 외부 type 누설). interface 측 외부 type 인용 영역 = paradigm 위배 영역.

---

## 4. 자식 3-repo paradigm 비균질 영역 (= 본 cycle 시점 baseline)

- GT = SDK 직접 인용 영역 잔존 (= H1-γ GT-MIGRATE STOP 5 영역 발견)
- GB / GD = 자체 facade paradigm 정합 영역 (= H1-γ 본 chat 측정 정합 ✓)
- migrate 영역 = `#7-γ GB/GD/GT-MIGRATE-FACADE-001` 별 cycle 마감 후 자연 균질 영역 진입

---

## 5. 본 SoT 의 변경 정책

- propagate 등급 = P1 권장 byte-identical (= cli infra 동족 5-repo)
- 변경 시 master cycle 신설 + 5-repo propagation 의무 (`cycle-discipline.md` §15 패턴 1 정합)
- 보호 file 등록 검토 = 별 cycle 영역 (= 본 cycle 시점 P1 권장 등급 한정)

---

## 6. 명시 cycle 이력

- 2026-05-13 · MASTER-DOCS-ARCHITECTURE-EXTERNAL-DEP-ABSTRACTION-001 · 본 SoT 신설 + 5-repo propagation
