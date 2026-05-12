# Architecture Foundation Link Policy

> **단일 목적**: 13 architecture 문서 (`docs/agent/architecture/**`) 측 코드 path 인용 박은 영역 → `app-foundation` 측 실제 file 측 markdown link 박음 표기 의무 + relative path baseline + 예외 영역 + 추가 architecture 신설 시 자동 적용 박은 patterns.
> **신설**: MASTER-ARCHITECTURE-FOUNDATION-LINK-001 (= ledger MASTER-T04 마감 박음 · 2026-05-12).
> **연관 파일**:
> - `cycle-discipline.md` §15 패턴 1 (master cycle 신설 + 4-repo propagation 의무)
> - `cycle-discipline.md` §3 (3-repo byte-identical 강제 범위 vs cli infra 권장 byte-identical)
> - `docs/agent/architecture/COMMON_ARCHITECTURE.md` §1 (운영 레이어 vs 제품 레이어 경계)
> SOT: `CLAUDE.md`

---

## 1. 적용 범위

| 대상 | 적용 여부 |
|---|---|
| `docs/agent/architecture/**.md` (13 file 박음) | **의무** |
| `docs/agent/process/**.md` | 적용 X (= 워크플로 영역 박음) |
| `docs/agent/solutions/**.md` | 적용 X (= 솔루션 영역 박음) |
| `.claude/rules/**.md` | 적용 X (= 정책 본문 박음) |
| `CLAUDE.md` | 적용 X (= 최상위 헌법 박음) |
| `.ai/reports/**.md` | 적용 X (= task 별 산출 박은 영역) |

---

## 2. link 박음 patterns 박음

### 2.1 첫 등장 시 link 박음

architecture file 측 코드 path 인용 박은 영역 측:
- **첫 등장 시** → markdown link 추가 박음 의무.
- **후속 등장 시** → link 박음 X 박음 (= verbose 박음 회피).

### 2.2 표기 형식 박음

```markdown
`<path>` ([app-foundation/<path>/](../../../../app-foundation/<path>/))
```

예:
- `` `shared/domain` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/)) ``
- `` `shared/data` ([app-foundation/shared/data/](../../../../app-foundation/shared/data/)) ``
- `` `shared/feature-state` ([app-foundation/shared/feature-state/](../../../../app-foundation/shared/feature-state/)) ``

### 2.3 relative path baseline 박음

5-repo 측 file 위치 박음 = `<repo>/docs/agent/architecture/<FILE>.md` (= 동일 박은 영역).
→ `app-foundation/` 측 박은 영역 박음 relative path = **`../../../../app-foundation/<path>`** (= 4 step 박음).

5-repo 모두 동일 path 박음 (= byte-identical 정합 박은 영역 박음):
- claude-cli-master + GB + GD + GT + app-foundation = 모두 `../../../../app-foundation/<path>` 박음.
- foundation 측 자기 측 link 박은 영역 = 동일 path 박음 (= `app-foundation/docs/agent/architecture/<FILE>.md` 박음 → `../../../../app-foundation/<path>/` 박음 = `AndroidStudioProjects/app-foundation/<path>/` 박은 영역 = correct 박음 ✓).

---

## 3. link 박을 path 박은 영역 박음 (= app-foundation 측 실제 박힌 path 박음만)

본 cycle 박은 시점 (2026-05-12) 박은 baseline 박음:

| path | app-foundation 측 박힌 영역 | link 박음 |
|---|---|---|
| `shared/domain` | ✓ (`shared/domain/`) | **link 박음** |
| `shared/data` | ✓ (`shared/data/`) | **link 박음** |
| `shared/feature-state` | ✓ (`shared/feature-state/`) | **link 박음** |
| `shared/app` | X (부재) | **link X 박음** (= 미신설 박음) |
| `core/analytics` | ✓ | link 박음 가능 (= 13 architecture 측 인용 박은 영역 박음 X 박은 baseline · 향후 추가 시 갱신) |
| `core/billing` | ✓ | (위 동) |
| `core/di` | ✓ | (위 동) |
| `core/feature-flag` | ✓ | (위 동) |
| `core/network` | ✓ | (위 동) |
| `core/notification` | ✓ | (위 동) |
| `core/observability` | ✓ | (위 동) |
| `core/supabase` | ✓ | (위 동) |
| `composeApp/` | 빈 디렉터리 박음 | **link X 박음** |
| `iosApp/` | 빈 디렉터리 박음 | **link X 박음** |
| `app/` | X (= 자식 측 박은 영역 박음 · foundation 측 X) | **link X 박음** |
| `feature/`, `gradle/`, `platform/` | X (= 부재) | **link X 박음** |

---

## 4. 예외 영역 박음 (= link 박음 X 박음 의무)

### 4.1 code block 안 박음

```markdown
```kotlin
// shared/domain     ← code block 안 박음 = link 박음 X 박음 (= markdown rendering 박음 X)
sealed interface Result<out T, out E>
```
```

근거 = code block 안 markdown link 박음 = rendering 박음 X 박음 (= raw 박은 영역 박음).

### 4.2 foundation 측 부재 path 박음

- `shared/app` 측 박음 = foundation 측 부재 박음 = link 박음 X 박음 의무 (= §C C4 정합 박은 영역 · 가상 link X 박음).
- 향후 foundation 측 신설 시 = 본 policy 갱신 박음 + 13 architecture file 측 link 박음 (= 별 cycle 박음).

### 4.3 자식 측 박은 영역 박음

- `app/` 측 박은 영역 박음 = 자식 측 박은 영역 박음 (= GB / GD / GT 측 박은 영역) + foundation 측 X = link 박음 X 박음.
- 자식 측 link 박음 = repo-specific 박은 영역 박음 (= 본 policy scope X · 자식 measurement 박음).

---

## 5. 추가 architecture 신설 시 자동 적용 박음

### 5.1 신규 architecture file 추가 박음 박은 시점 박음

- 신규 `docs/agent/architecture/<NEW>.md` 추가 박은 시점 박음 = 본 policy §2.1 첫 등장 시 link 박음 patterns 박음 의무 박음.
- 신규 코드 path 인용 박은 영역 박은 박은 박음 = §3 박은 baseline 박은 박은 = link 박을 영역 박은 영역 박음 박은 의무 박은 박은 박은 박음.

### 5.2 foundation 측 신규 path 박음 박은 시점 박음

- foundation 측 신규 path 박음 박은 시점 박음 (예: `shared/app` 신설 박음 박은 박은 박음) 박은 시점 박은 박은 박음 = 본 §3 박은 표 박은 박음 박은 갱신 박은 의무 박음 + 13 architecture file 측 새 path 측 link 박음 박음 박은 의무 박음 박음 (= 별 cycle 박은 박은 박음).

---

## 6. 변경 정책 박은 박음

- 본 file = cli infra 권장 byte-identical (= 5-repo 박은 영역 박음 · 보호 5 sha 박은 영역 X).
- 변경 박은 박은 박음 = master cycle 신설 박음 + 5-repo propagation 박은 의무 박음 (`cycle-discipline.md` §15 패턴 1 박은 정합 박음).
- 자식 repo 측 직접 수정 박은 박은 박음 X (= cli infra 단방향 정합 박음 · CLAUDE.md §3 박은 정합 박음).

---

## 7. 명시 박은 cycle 이력

- 2026-05-12 · MASTER-ARCHITECTURE-FOUNDATION-LINK-001 · 본 file 신설 박음 + 13 architecture file 측 link 박은 영역 박음 (7 file × 1~3 link 박음 = 약 12 link 박음) + 5-repo propagation 박음.
