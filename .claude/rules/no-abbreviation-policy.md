# No-Abbreviation Policy

> **단일 목적**: 4-repo 패키지 (claude-cli-master + GentlyBreath + GentlyDay + GentlyTable) 의
> 구현 코드레벨에서 사용자 정의 축약 변수/함수/클래스/파일/패키지명 금지 정책.
> **신설**: GLOBAL-NO-ABBREV-POLICY-001 (2026-05-10).
> **연관 파일**:
> - `allowed-acronyms.md` — 허용 표준 약어 SoT
> - `forbidden-abbreviations.md` — 금지 사용자 정의 축약 seed list + regex 패턴
> - `.claude/hooks/check-abbreviation.sh` — PreToolUse 자동화 검증 hook
> SOT: `CLAUDE.md`

---

## 1. 적용 범위

| 대상 | 적용 여부 |
|---|---|
| 사용자 정의 변수명 | **금지** |
| 사용자 정의 함수명 | **금지** |
| 사용자 정의 클래스명 | **금지** |
| 사용자 정의 파일명 | **금지** |
| 사용자 정의 패키지명 | **금지** |
| 표준 라이브러리 / 프레임워크 API 명 | **허용** (외부 명세 따름) |
| 언어 키워드 (`val`, `var`, `fun`, `init`, `fn`, `func` 등) | **허용** (언어 명세 따름) |
| 산업 표준 약어 (allowed-acronyms.md 등재) | **허용** |

---

## 2. 금지 대상 정의

**사용자 정의 축약** = 의미를 임의로 단축한 식별자 (업계 비표준).

```
금지 예:
  val btn = ...              → val button = ... 로 작성 의무
  fun calcResult() {}        → fun calculateResult() {} 로 작성 의무
  class MsgHandler {}        → class MessageHandler {} 로 작성 의무
  var errCode = ...          → var errorCode = ... 로 작성 의무
  fun getUserCfg() {}        → fun getUserConfiguration() {} 로 작성 의무
```

---

## 3. 허용 예외 (allowed-list)

`allowed-acronyms.md` 에 등재된 표준 약어는 식별자 구성 요소로 사용 가능.

```
허용 예:
  val apiClient = ...        ← API = 허용 표준 약어
  fun fetchJsonData() {}     ← JSON = 허용 표준 약어
  class HttpRequestBuilder   ← HTTP = 허용 표준 약어
  val userId: UUID           ← UUID, ID = 허용 표준 약어
  class DatabaseHelper       ← DBHelper 는 프레임워크 명세 패턴
```

충돌 규칙: allowed-list ∩ forbidden-list = ∅ (충돌 시 allowed 우선).

### 자동화 hook 제외 대상 (check-abbreviation.sh)

hook 이 자동으로 검사를 건너뛰는 라인/경로:

| 제외 대상 | 이유 |
|---|---|
| 주석 라인 (`//`, `#`, `*`, `/*`, `<!--`, `*/` 로 시작) | 코드 식별자 아님 |
| `import ` 로 시작하는 라인 | 패키지 경로 구성 요소가 금지 토큰과 매칭 (예: `import androidx.compose.ui.res.stringResource` 의 `.res.`) — false positive 제거 |
| `build/`, `.gradle/`, `generated/` 경로 | 자동 생성 파일 — 사용자 정의 식별자 아님 |

---

## 4. 매칭 규칙 (camelCase 부분 매칭 포함)

금지 토큰은 식별자 안에서 camelCase 구성 요소로 나타날 때도 적용됨.

| 패턴 | 예시 | 판정 |
|---|---|---|
| 독립 식별자 | `val btn` | 금지 ✗ |
| camelCase 접두 | `val btnClick` | 금지 ✗ (`btn` 포함) |
| camelCase 중간/후미 | `val userMsg` | 금지 ✗ (`Msg` = `msg`) |
| camelCase 중간 | `val errHandler` | 금지 ✗ (`err` 포함) |
| 풀네임 | `val buttonClick` | 허용 ✓ |
| 허용 약어 포함 | `val apiUrl` | 허용 ✓ (`api` = API 표준) |

---

## 5. 검증 절차 (자동화 hook)

`.claude/hooks/check-abbreviation.sh` 가 PreToolUse (Edit / Write) 에서 자동 실행.

### 5.1 모드 (env var: `NO_ABBREV_ENFORCE`)

| 모드 | 기본값 | 동작 |
|---|---|---|
| `warn` | (비기본) | forbidden 패턴 감지 시 stderr 경고만 출력, 도구 사용 허용 |
| `enforce` | **기본 (GLOBAL-NO-ABBREV-POLICY-002 이후)** | forbidden 패턴 감지 시 도구 사용 차단 (exit 2) |

승격 완료: GLOBAL-NO-ABBREV-POLICY-002 에서 `enforce` 를 기본값으로 전환 (GT ctx→mealContextEntry 정정 완료 + import/generated path false positive 수정 완료).

### 5.2 자가 진단 (hook self-test)

```bash
# 7 픽스처 enforce 모드 자가 진단 (GLOBAL-NO-ABBREV-POLICY-002 기준)
# fixture 1: forbidden 변수 → enforce block (exit 2)
# fixture 2: 허용 약어 → pass (exit 0)
# fixture 3: 풀네임 → pass (exit 0)
# fixture 4: import 라인 res → pass (exit 0)  [Sub B: import skip]
# fixture 5: generated path → pass (exit 0)    [Sub B: path skip]
# fixture 6: enforce block (exit 2)            [Sub C: default enforce]
# fixture 7: clean code → pass (exit 0)        [Sub C: no false positive]
```

---

## 6. 신규 표준 약어 추가 (예외 신청)

1. `.claude/rules/allowed-acronyms.md` 에 PR 형식으로 추가 제안
2. 산업 표준 증빙 필요 (RFC / 공식 사양 / 언어 공식 문서 인용)
3. master repo cycle 신설 + 4-repo propagation 의무
4. `allowed-acronyms.md` 변경 = cli infra 변경 → master 단방향 정책 적용

---

## 7. 위반 시 mitigation

| 단계 | 설명 |
|---|---|
| 신규 코드 작성 시 | hook 자동 감지 → warn or block |
| 기존 코드 정정 시 | Cycle 2~4 전용 cycle — 한 repo 당 한 cycle (변수/클래스/파일 단계 분리) |
| PR / REVIEW 시 | reviewer agent 코드 리뷰 체크리스트 §B 에서 확인 |
| 즉각 정정 불가 시 | `// TODO(no-abbrev): 풀네임으로 교체 예정` 주석 마커 의무 |

---

## 8. Cycle 2~4 전용 scope (본 정책과 별도 cycle)

| Cycle | 대상 repo | 단계 |
|---|---|---|
| Cycle 2 | GentlyBreath | src/ 도메인 코드 내 forbidden 변수/함수/클래스명 일괄 정정 |
| Cycle 3 | GentlyDay | 동일 |
| Cycle 4 | GentlyTable + enforce 모드 승격 | 동일 + `NO_ABBREV_ENFORCE=enforce` |

---

## 9. 본 파일의 변경 정책

본 파일 = cli infra 권장 byte-identical.
변경 시 master cycle 신설 + 4-repo propagation 의무 (`cycle-discipline.md` §15 패턴 1).
