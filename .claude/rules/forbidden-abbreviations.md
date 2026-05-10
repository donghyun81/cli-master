# Forbidden Abbreviations — Seed List SoT

> **단일 목적**: 구현 코드레벨에서 금지된 사용자 정의 축약 seed list + 자동화 regex 패턴 + 예시.
> **신설**: GLOBAL-NO-ABBREV-POLICY-001 (2026-05-10).
> **연관 파일**:
> - `no-abbreviation-policy.md` — 정책 본문 + 시행 절차
> - `allowed-acronyms.md` — 허용 표준 약어 (충돌 시 allowed 우선)
> - `.claude/hooks/check-abbreviation.sh` — 자동화 검증 hook (본 파일 참조)
> SOT: `CLAUDE.md`

---

## 1. Seed List (확장 가능)

### 1.1 UI / 이벤트 관련

| 금지 | 올바른 풀네임 예시 |
|---|---|
| `btn` | `button` |
| `vm` | `viewModel` |
| `vw` | `view` |
| `frag` | `fragment` |
| `act` | `activity` |
| `ctx` | `context` |

### 1.2 데이터 / 상태 관련

| 금지 | 올바른 풀네임 예시 |
|---|---|
| `msg` | `message` |
| `cfg` | `configuration` |
| `conf` | `configuration` |
| `opts` | `options` |
| `idx` | `index` |
| `cnt` | `count` |
| `num` | `number` |
| `val` *(변수명용)* | `value` |
| `str` *(변수명용)* | `text`, `name`, `description` (의미에 따라) |
| `obj` | `object`, `item`, `entity` (의미에 따라) |
| `arr` | `list`, `array`, `items` (의미에 따라) |
| `lst` | `list`, `items` |
| `dict` *(변수명용)* | `map`, `mapping`, `registry` (의미에 따라) |
| `attr` | `attribute` |
| `attrs` | `attributes` |
| `prop` | `property` |
| `props` | `properties` |
| `info` *(변수명용)* | 의미 있는 풀네임 사용 (예: `userDetails`, `connectionInfo` X → `connectionDetails`) |
| `tmp` | `temporary`, 또는 의미 있는 이름 |

### 1.3 입출력 / 네트워크 관련

| 금지 | 올바른 풀네임 예시 |
|---|---|
| `req` | `request` |
| `res` *(변수명용)* | `response`, `result` (의미에 따라) |
| `resp` | `response` |
| `usr` | `user` |
| `pwd` | `password` |

### 1.4 함수 / 프로세스 관련

| 금지 | 올바른 풀네임 예시 |
|---|---|
| `fn` *(변수명용)* | `function`, `action`, `handler` (의미에 따라) |
| `fnc` | `function` |
| `func` *(변수명용)* | `function` |
| `mgr` | `manager` |
| `svc` | `service` |
| `srv` | `server`, `service` |
| `ctrl` | `controller` |
| `hdlr` | `handler` |
| `hlpr` | `helper` |
| `calc` | `calculate`, `calculator` |
| `gen` *(변수명용)* | `generator`, `generate` (의미에 따라) |
| `proc` | `process`, `processor` |
| `exec` *(변수명용)* | `executor`, `execute` (의미에 따라) |
| `util` | `utility`, 또는 의미 있는 클래스/파일명 |
| `utils` | `utilities`, 또는 의미 있는 클래스/파일명 |
| `helper` *(클래스/파일명)* | 의미 있는 이름 (예: `DateFormatter`, `ImageLoader`) |

### 1.5 공통 패턴 관련

| 금지 | 올바른 풀네임 예시 |
|---|---|
| `err` | `error`, `exception`, `failure` |
| `ret` | `result`, `returnValue` |
| `args` *(변수명용)* | `arguments`, 또는 의미 있는 이름 |
| `params` *(변수명용)* | `parameters`, 또는 의미 있는 이름 |
| `prev` | `previous` |
| `curr` | `current` |
| `nxt` | `next` |
| `prv` | `previous` |
| `repo` *(변수명용)* | `repository` |
| `db` *(변수명용)* | `database` |
| `init` *(변수명용)* | `initialize`, `initializer`, 또는 의미 있는 이름 |

---

## 2. camelCase 매칭 규칙

금지 토큰은 식별자 구성 요소로 나타날 때도 적용된다.

### 2.1 매칭 패턴 (Python ERE 기준)

각 금지 토큰 `T` 에 대해 다음 3개 패턴 중 하나라도 매칭되면 hit:

```python
pattern = (
    # 패턴 1: 독립 식별자 (앞이 비-word, 뒤가 소문자/숫자/언더스코어가 아님)
    r'(?<![A-Za-z0-9_])' + token + r'(?![a-z0-9_])'
    + '|'
    # 패턴 2: camelCase 중간/후미 (앞이 소문자, 토큰 첫 글자 대문자)
    + r'(?<=[a-z])' + token_title_case + r'(?![a-z])'
)
```

### 2.2 매칭 예시

| 코드 예시 | 토큰 | 매칭 패턴 | 판정 |
|---|---|---|---|
| `val btn = ...` | `btn` | 패턴 1 (앞: 공백, 뒤: 공백) | HIT ✗ |
| `val btnClick = ...` | `btn` | 패턴 1 (앞: 공백, 뒤: 대문자 C) | HIT ✗ |
| `val userMsg = ...` | `msg` | 패턴 2 (앞: 소문자 r, Msg 대문자 시작) | HIT ✗ |
| `val errHandler = ...` | `err` | 패턴 1 (앞: 공백, 뒤: 대문자 H) | HIT ✗ |
| `val apiUrl = ...` | — | `api`, `url` 모두 forbidden-list 외 | PASS ✓ |
| `val buttonClickHandler` | — | 풀네임 — forbidden-list 미포함 | PASS ✓ |
| `class MessageService` | — | 풀네임 — forbidden-list 미포함 | PASS ✓ |

---

## 3. 제외 대상

다음은 자동화 hook 에서 검사 제외:

| 제외 대상 | 이유 |
|---|---|
| 언어 키워드 (`val`, `var`, `fun`, `init`, `fn`, `func` 등) | 언어 명세 → allowed (keyword context) |
| 표준 라이브러리 / 프레임워크 API 명 | 외부 명세 → allowed-acronyms.md 자동 포함 |
| 주석 (`//`, `#`, `*`, `/*`) | 주석은 코드 식별자 아님 |
| 비-코드 파일 (`.md`, `.json`, `.xml`, `.yaml`, `.toml`, `.properties`) | 코드 식별자 컨텍스트 아님 |
| 문자열 리터럴 내부 | 런타임 값, 식별자 아님 |

---

## 4. Seed 확장 절차

1. 신규 금지 토큰 발견 → 본 목록에 행 추가
2. master cycle 신설 (`GLOBAL-NO-ABBREV-SEEDADD-NNN`)
3. 4-repo propagation 의무
4. `check-abbreviation.sh` 의 `FORBIDDEN_CHECK` 세트 동기 업데이트 의무

---

## 5. 본 파일의 변경 정책

본 파일 = cli infra 권장 byte-identical.
변경 시 master cycle 신설 + 4-repo propagation 의무 (`cycle-discipline.md` §15 패턴 1).
