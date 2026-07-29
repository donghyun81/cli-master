# Architecture Foundation Link Policy

> **단일 목적**: 13 architecture 문서 (`docs/agent/architecture/**`) 의 코드 path 인용 영역 → `app-foundation` 의 실제 file 측 markdown link 의무 + relative path baseline + 예외 영역 + 추가 architecture 신설 시 자동 적용 patterns 정의.
> **신설**: MASTER-ARCHITECTURE-FOUNDATION-LINK-001 (= ledger MASTER-T04 마감 · 2026-05-12).
> **연관 파일**:
> - `cycle-discipline.md` §15 패턴 1 (master cycle 신설 + 4-repo propagation 의무)
> - `cycle-discipline.md` §3 (3-repo byte-identical 강제 범위 vs cli infra 권장 byte-identical)
> - `docs/agent/architecture/COMMON_ARCHITECTURE.md` §1 (운영 레이어 vs 제품 레이어 경계)
> SOT: `CLAUDE.md`

---

## 1. 적용 범위

| 대상 | 적용 여부 |
|---|---|
| `docs/agent/architecture/**.md` (13 file) | **의무** |
| `docs/agent/process/**.md` | 적용 X (= 워크플로 영역) |
| `docs/agent/solutions/**.md` | 적용 X (= 솔루션 영역) |
| `.claude/rules/**.md` | 적용 X (= 정책 본문 영역) |
| `CLAUDE.md` | 적용 X (= 최상위 헌법) |
| `.ai/reports/**.md` | 적용 X (= task 별 산출물) |

---

## 2. 참조 표기 patterns

### 2.1 첫 등장 시 표기 추가

architecture file 측 코드 path 인용 영역 측:
- **첫 등장 시** → markdown link 추가 의무.
- **후속 등장 시** → 표기 생략 (= verbose 회피).

### 2.2 표기 형식

```markdown
`<path>` ([app-foundation/<path>/](../../../../app-foundation/<path>/))
```

예:
- `` `shared/domain` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/)) ``
- `` `shared/data` ([app-foundation/shared/data/](../../../../app-foundation/shared/data/)) ``
- `` `shared/feature-state` ([app-foundation/shared/feature-state/](../../../../app-foundation/shared/feature-state/)) ``

### 2.3 relative path baseline

4-repo 측 file 위치 = `<repo>/docs/agent/architecture/<FILE>.md` (= 4-repo 동일 path).
→ `app-foundation/` 측 실제 영역 기준 relative path = **`../../../../app-foundation/<path>`** (= 4 step 상위).

4-repo 모두 동일 표기 (= byte-identical 정합):
- claude-cli-master + GB + GD + GT + app-foundation + gently-product-docs 모두 `../../../../app-foundation/<path>` 채택.
- foundation 측 자기 참조 영역 = 동일 (= 위치 `app-foundation/docs/agent/architecture/<FILE>.md` → `../../../../app-foundation/<path>/` 해석 결과 = `AndroidStudioProjects/app-foundation/<path>/` = correct ✓).

---

## 3. 표기 대상 path (= app-foundation 측 실재 path 만)

본 cycle 시점 (2026-05-12) baseline:

| path | app-foundation 측 존재 | 표기 |
|---|---|---|
| `shared/domain` | ✓ (`shared/domain/`) | **적용** |
| `shared/data` | ✓ (`shared/data/`) | **적용** |
| `shared/feature-state` | ✓ (`shared/feature-state/`) | **적용** |
| `shared/app` | X (부재) | **생략** (= 미신설 단계) |
| `core/analytics` | ✓ | 가능 (= 13 architecture 측 인용 영역 X · 향후 추가 시점 갱신) |
| `core/billing` | ✓ | (위 동) |
| `core/di` | ✓ | (위 동) |
| `core/feature-flag` | ✓ | (위 동) |
| `core/network` | ✓ | (위 동) |
| `core/notification` | ✓ | (위 동) |
| `core/observability` | ✓ | (위 동) |
| `core/supabase` | ✓ | (위 동) |
| `composeApp/` | 빈 디렉터리 | **생략** |
| `iosApp/` | 빈 디렉터리 | **생략** |
| `app/` | X (= 자식 영역 · foundation 측 X) | **생략** |
| `feature/`, `gradle/`, `platform/` | X (= 부재) | **생략** |

---

## 4. 예외 영역 (= 표기 생략 의무)

### 4.1 code block 내부

```markdown
```kotlin
// shared/domain     ← code block 내부 = 생략 (= markdown rendering X)
sealed interface Result<out T, out E>
```
```

근거 = code block 내부 markdown link = rendering 결과 X (= raw 출력).

### 4.2 foundation 측 부재 path

- `shared/app` = foundation 측 부재 = 생략 의무 (= §C C4 정합 · 가상 참조 X).
- 향후 foundation 측 신설 시점 = 본 policy 갱신 + 13 architecture file 측 표기 추가 (= 별 cycle).

### 4.3 자식 영역

- `app/` = 자식 repo (= GB / GD / GT) 측 영역 + foundation 측 X = 생략.
- 자식 측 참조 = repo-specific 영역 (= 본 policy scope 외 · 자식 자체 결정).

---

## 5. 추가 architecture 신설 시 자동 적용

### 5.1 신규 architecture file 추가 시점

- 신규 `docs/agent/architecture/<NEW>.md` 추가 시 = 본 policy §2.1 의무 적용 (= 첫 등장 시 표기).
- 신규 코드 path 인용 영역 = §3 baseline 표 기준 = 대상 영역 판정.

### 5.2 foundation 측 신규 path 추가 시점

- foundation 측 신규 path 추가 시 (예: `shared/app` 신설) = 본 §3 표 갱신 의무 + 13 architecture file 측 새 path 표기 추가 의무 (= 별 cycle).

---

## 6. 변경 정책

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 4-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## 7. 명시 cycle 이력

- 2026-05-12 · MASTER-ARCHITECTURE-FOUNDATION-LINK-001 · 본 file 신설 + 13 architecture 측 참조 추가 (7 file × 1~3 항목 = 약 12 reference) + 5-repo propagation.
- 2026-05-12 · MASTER-CLEANUP-VOCAB-LAZY-BUNDLE-001 (TRAIL-4) · 본 file 본문 paraphrase (degeneration mitigation · text-degeneration-prevention.md n-gram metric 통과) · 표기 의미 정합 보존 (= 의무 변경 X) · 5-repo byte-identical 재 propagation.
