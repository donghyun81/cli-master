# Abbreviation Policy — Unified SoT

> **단일 목적**: 6-repo 패키지 (claude-cli-master + app-foundation + GentlyBreath + GentlyDay + GentlyTable + gently-product-docs) 의 구현 코드레벨에서 사용자 정의 축약 변수/함수/클래스/파일/패키지명 금지 정책 + 금지 seed list + 허용 표준 약어 list 통합 SoT.
> **신설**: MASTER-CLI-CLEANUP-7CYCLE-001 (2026-05-21) · 직전 3 file (`no-abbreviation-policy.md` + `forbidden-abbreviations.md` + `allowed-acronyms.md`) 본문 통합 default (= GLOBAL-NO-ABBREV-POLICY-001 + 002 baseline 흡수).
> **연관 파일**:
> - `.claude/hooks/check-abbreviation.sh` — PreToolUse 자동화 검증 hook (본 file 단일 SoT 인용)
> **context 상시 로드 불요 (T4)**: 본 file = Reading Mode 의무 로드(L2) 제외 — enforcement SoT = `check-abbreviation.sh` hook (`enforce` mode · 위반 시 hook stderr 노출 · MASTER-CLI-CONTEXT-DIET-2-001). 정독 = seed/약어 추가 cycle 한정.
> SOT: `CLAUDE.md`

---

## §1 정책 본문 + 시행 절차

### §1.1 적용 범위

| 대상 | 적용 여부 |
|---|---|
| 사용자 정의 변수명 | **금지** |
| 사용자 정의 함수명 | **금지** |
| 사용자 정의 클래스명 | **금지** |
| 사용자 정의 파일명 | **금지** |
| 사용자 정의 패키지명 | **금지** |
| 표준 라이브러리 / 프레임워크 API 명 | **허용** (외부 명세 따름) |
| 언어 키워드 (`val`, `var`, `fun`, `init`, `fn`, `func` 등) | **허용** (언어 명세 따름) |
| 산업 표준 약어 (§3 등재) | **허용** |

### §1.2 금지 대상 정의

**사용자 정의 축약** = 의미를 임의로 단축한 식별자 (업계 비표준).

```
금지 예:
  val btn = ...              → val button = ... 로 작성 의무
  fun calcResult() {}        → fun calculateResult() {} 로 작성 의무
  class MsgHandler {}        → class MessageHandler {} 로 작성 의무
  var errCode = ...          → var errorCode = ... 로 작성 의무
  fun getUserCfg() {}        → fun getUserConfiguration() {} 로 작성 의무
```

### §1.3 허용 예외 (= §3 allowed-list)

§3 에 등재된 표준 약어는 식별자 구성 요소로 사용 가능.

```
허용 예:
  val apiClient = ...        ← API = 허용 표준 약어
  fun fetchJsonData() {}     ← JSON = 허용 표준 약어
  class HttpRequestBuilder   ← HTTP = 허용 표준 약어
  val userId: UUID           ← UUID, ID = 허용 표준 약어
  class DatabaseHelper       ← DBHelper 는 프레임워크 명세 패턴
```

충돌 규칙: allowed-list ∩ forbidden-list = ∅ (충돌 시 allowed 우선).

#### §1.3.1 자동화 hook 제외 대상 (= `check-abbreviation.sh` 정합)

hook 이 자동으로 검사를 건너뛰는 라인/경로:

| 제외 대상 | 이유 |
|---|---|
| 주석 라인 (`//`, `#`, `*`, `/*`, `<!--`, `*/` 로 시작) | 코드 식별자 아님 |
| `import ` 로 시작하는 라인 | 패키지 경로 구성 요소가 금지 토큰과 매칭 (예: `import androidx.compose.ui.res.stringResource` 의 `.res.`) — false positive 제거 |
| `build/`, `.gradle/`, `generated/` 경로 | 자동 생성 파일 — 사용자 정의 식별자 아님 |

### §1.4 매칭 규칙 (camelCase 부분 매칭 포함)

금지 토큰은 식별자 안에서 camelCase 구성 요소로 나타날 때도 적용됨.

| 패턴 | 예시 | 판정 |
|---|---|---|
| 독립 식별자 | `val btn` | 금지 ✗ |
| camelCase 접두 | `val btnClick` | 금지 ✗ (`btn` 포함) |
| camelCase 중간/후미 | `val userMsg` | 금지 ✗ (`Msg` = `msg`) |
| camelCase 중간 | `val errHandler` | 금지 ✗ (`err` 포함) |
| 풀네임 | `val buttonClick` | 허용 ✓ |
| 허용 약어 포함 | `val apiUrl` | 허용 ✓ (`api` = API 표준) |

### §1.5 검증 절차 (= 자동화 hook)

`.claude/hooks/check-abbreviation.sh` 가 PreToolUse (Edit / Write) 에서 자동 실행.

#### §1.5.1 모드 (env var: `NO_ABBREV_ENFORCE`)

| 모드 | 기본값 | 동작 |
|---|---|---|
| `warn` | (비기본) | forbidden 패턴 감지 시 stderr 경고만 출력, 도구 사용 허용 |
| `enforce` | **기본 (GLOBAL-NO-ABBREV-POLICY-002 이후)** | forbidden 패턴 감지 시 도구 사용 차단 (exit 2) |

승격 완료: GLOBAL-NO-ABBREV-POLICY-002 에서 `enforce` 를 기본값으로 전환 (GT ctx→mealContextEntry 정정 완료 + import/generated path false positive 수정 완료).

#### §1.5.2 자가 진단 (hook self-test)

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

### §1.6 신규 표준 약어 추가 (= 예외 신청)

1. 본 file §3 에 PR 형식으로 추가 제안
2. 산업 표준 증빙 필요 (RFC / 공식 사양 / 언어 공식 문서 인용)
3. master repo cycle 신설 + 6-repo propagation 의무
4. 본 file 변경 = cli infra 변경 → master 단방향 정책 적용

### §1.7 위반 시 mitigation

| 단계 | 설명 |
|---|---|
| 신규 코드 작성 시 | hook 자동 감지 → warn or block |
| 기존 코드 정정 시 | Cycle 2~4 전용 cycle — 한 repo 당 한 cycle (변수/클래스/파일 단계 분리) |
| PR / REVIEW 시 | reviewer agent 코드 리뷰 체크리스트 §B 에서 확인 |
| 즉각 정정 불가 시 | `// TODO(no-abbrev): 풀네임으로 교체 예정` 주석 마커 의무 |

### §1.8 Cycle 2~4 전용 scope (= 본 정책과 별도 cycle)

| Cycle | 대상 repo | 단계 |
|---|---|---|
| Cycle 2 | GentlyBreath | src/ 도메인 코드 내 forbidden 변수/함수/클래스명 일괄 정정 |
| Cycle 3 | GentlyDay | 동일 |
| Cycle 4 | GentlyTable + enforce 모드 승격 | 동일 + `NO_ABBREV_ENFORCE=enforce` |

---

## §2 금지 사용자 정의 축약 seed list + regex

### §2.1 Seed List (= 5 카테고리 · 확장 가능)

#### §2.1.1 UI / 이벤트 관련

| 금지 | 올바른 풀네임 예시 |
|---|---|
| `btn` | `button` |
| `vm` | `viewModel` |
| `vw` | `view` |
| `frag` | `fragment` |
| `act` | `activity` |
| `ctx` | `context` |

#### §2.1.2 데이터 / 상태 관련

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

#### §2.1.3 입출력 / 네트워크 관련

| 금지 | 올바른 풀네임 예시 |
|---|---|
| `req` | `request` |
| `res` *(변수명용)* | `response`, `result` (의미에 따라) |
| `resp` | `response` |
| `usr` | `user` |
| `pwd` | `password` |

#### §2.1.4 함수 / 프로세스 관련

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

#### §2.1.5 공통 패턴 관련

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

### §2.2 camelCase 매칭 규칙

금지 토큰은 식별자 구성 요소로 나타날 때도 적용된다.

#### §2.2.1 매칭 패턴 (Python ERE 기준)

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

#### §2.2.2 매칭 예시

| 코드 예시 | 토큰 | 매칭 패턴 | 판정 |
|---|---|---|---|
| `val btn = ...` | `btn` | 패턴 1 (앞: 공백, 뒤: 공백) | HIT ✗ |
| `val btnClick = ...` | `btn` | 패턴 1 (앞: 공백, 뒤: 대문자 C) | HIT ✗ |
| `val userMsg = ...` | `msg` | 패턴 2 (앞: 소문자 r, Msg 대문자 시작) | HIT ✗ |
| `val errHandler = ...` | `err` | 패턴 1 (앞: 공백, 뒤: 대문자 H) | HIT ✗ |
| `val apiUrl = ...` | — | `api`, `url` 모두 forbidden-list 외 | PASS ✓ |
| `val buttonClickHandler` | — | 풀네임 — forbidden-list 미포함 | PASS ✓ |
| `class MessageService` | — | 풀네임 — forbidden-list 미포함 | PASS ✓ |

### §2.3 제외 대상 (= 자동화 hook 적용)

다음은 자동화 hook 에서 검사 제외:

| 제외 대상 | 이유 |
|---|---|
| 언어 키워드 (`val`, `var`, `fun`, `init`, `fn`, `func` 등) | 언어 명세 → allowed (keyword context) |
| 표준 라이브러리 / 프레임워크 API 명 | 외부 명세 → §3 allowed-list 자동 포함 |
| 주석 (`//`, `#`, `*`, `/*`) | 주석은 코드 식별자 아님 |
| 비-코드 파일 (`.md`, `.json`, `.xml`, `.yaml`, `.toml`, `.properties`) | 코드 식별자 컨텍스트 아님 |
| 문자열 리터럴 내부 | 런타임 값, 식별자 아님 |

### §2.4 Seed 확장 절차

1. 신규 금지 토큰 발견 → §2.1 목록에 행 추가
2. master cycle 신설 (`GLOBAL-NO-ABBREV-SEEDADD-NNN`)
3. 6-repo propagation 의무
4. `check-abbreviation.sh` 의 `FORBIDDEN_CHECK` 세트 동기 업데이트 의무

---

## §3 허용 표준 약어 list (= allowed-list)

### §3.1 충돌 규칙

- allowed-list ∩ forbidden-list = ∅ (충돌 시 allowed 우선)
- 신규 약어 추가 = 산업 표준 증빙 필요 + master cycle PR 의무

### §3.2 네트워크 / 웹 / 데이터 형식

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| URL | Uniform Resource Locator | RFC 3986 |
| URI | Uniform Resource Identifier | RFC 3986 |
| HTTP | Hypertext Transfer Protocol | RFC 7230 |
| HTTPS | HTTP Secure | RFC 2818 |
| API | Application Programming Interface | 업계 표준 |
| JSON | JavaScript Object Notation | RFC 8259 |
| XML | Extensible Markup Language | W3C |
| HTML | Hypertext Markup Language | W3C |
| CSS | Cascading Style Sheets | W3C |
| JS | JavaScript | ECMA-262 |
| TS | TypeScript | Microsoft/ECMA |
| REST | Representational State Transfer | 업계 표준 |
| gRPC | gRPC Remote Procedure Call | Google/CNCF |
| MIME | Multipurpose Internet Mail Extensions | RFC 2045 |
| CDN | Content Delivery Network | 업계 표준 |
| DNS | Domain Name System | RFC 1034 |
| IP | Internet Protocol | RFC 791 |
| TCP | Transmission Control Protocol | RFC 793 |
| UDP | User Datagram Protocol | RFC 768 |
| SSL | Secure Sockets Layer | 업계 표준 (deprecated, TLS로 대체) |
| TLS | Transport Layer Security | RFC 8446 |
| OAuth | Open Authorization | RFC 6749 |
| JWT | JSON Web Token | RFC 7519 |

### §3.3 식별자 / 보안 / 암호화

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| UUID | Universally Unique Identifier | RFC 4122 |
| ID | Identifier | 업계 표준 |
| MD5 | Message Digest 5 | RFC 1321 |
| SHA | Secure Hash Algorithm | FIPS 180-4 |
| AES | Advanced Encryption Standard | FIPS 197 |
| RSA | Rivest–Shamir–Adleman | 업계 표준 |

### §3.4 인터페이스 / 사용자 경험

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| UI | User Interface | 업계 표준 |
| UX | User Experience | 업계 표준 |

### §3.5 데이터 / 인프라

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| DB | Database | 업계 표준 |
| SQL | Structured Query Language | ISO/IEC 9075 |
| SDK | Software Development Kit | 업계 표준 |
| CLI | Command Line Interface | 업계 표준 |

### §3.6 시스템 / 하드웨어

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| IO | Input/Output | 업계 표준 |
| CPU | Central Processing Unit | 업계 표준 |
| RAM | Random Access Memory | 업계 표준 |
| GPU | Graphics Processing Unit | 업계 표준 |
| OS | Operating System | 업계 표준 |
| FS | File System | 업계 표준 |

### §3.7 AI / ML / 도메인 표준

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| MCP | Model Context Protocol | Anthropic 공식 |
| LLM | Large Language Model | 업계 표준 |
| AI | Artificial Intelligence | 업계 표준 |
| ML | Machine Learning | 업계 표준 |
| NLP | Natural Language Processing | 업계 표준 |

### §3.8 프레임워크 / 라이브러리 API 명 (자동 포함)

아래 패턴은 외부 명세를 따르므로 allowed-list 자동 포함:

| 패턴 | 예시 | 근거 |
|---|---|---|
| Android Framework 클래스명 | `HttpURLConnection`, `DBHelper`, `ViewModel` | Android SDK 공식 |
| Jetpack Compose 패턴 | `LazyColumn`, `TopAppBar` | Jetpack 공식 |
| 언어 키워드 + 표준 라이브러리 | Kotlin `val`, `var`, `fun`, `init` | Kotlin 언어 명세 |
| Java 표준 라이브러리 클래스명 | `StringBuilder`, `BufferedReader` | JDK 공식 |
| 3rd-party 라이브러리 공개 API 명 | Supabase, Koin, Room 등 공개 API | 각 라이브러리 공식 |

### §3.9 신규 약어 추가 절차

1. 본 §3 에 새 행 추가 (표 형식 유지)
2. **산업 표준 증빙** 필수: RFC / W3C / ISO / 공식 플랫폼 문서 링크
3. master repo cycle 신설 (`GLOBAL-NO-ABBREV-ACRONYM-ADD-NNN`)
4. 6-repo propagation (`scripts/propagate.sh --targets all`)
5. `verify-sync.sh` PASS 확인
6. CLAUDE.md §15 표에 cycle entry 추가

---

## §4 hook 정합

본 file = `.claude/hooks/check-abbreviation.sh` 단일 SoT 인용 영역 default:

- §1 정책 본문 = hook 측 BLOCK_MSG 측 Policy 인용 source default
- §2 금지 seed list = hook 측 `FORBIDDEN_CHECK` Python set 측 source default
- §3 허용 list = hook 측 화이트리스트 union (= `post-edit-degeneration-check.sh` 측 자동 인식) source default

hook 본문 변경 시 본 file 갱신 의무 default (= cli infra 단방향 정합 영역 정합).

---

## §5 본 file 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](./rule-footer-common.md) (= 6-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## §6 명시 cycle 이력

- 2026-05-10 · GLOBAL-NO-ABBREV-POLICY-001 · 직전 3 file 신설 (`no-abbreviation-policy.md` + `forbidden-abbreviations.md` + `allowed-acronyms.md`) + PreToolUse hook `check-abbreviation.sh` + settings.json 등록 (`NO_ABBREV_ENFORCE=warn` 기본 baseline)
- 2026-05-10 · GLOBAL-NO-ABBREV-POLICY-002 · Sub A (= GT DailyPrescriptionScreen.kt ctx→mealContextEntry 4 occurrences) + Sub B (= check-abbreviation.sh import line skip + generated path skip · false positive 제거) + Sub C (= NO_ABBREV_ENFORCE default warn→enforce 승격 + §1.5.1 mode default 갱신)
- 2026-05-21 · MASTER-CLI-CLEANUP-7CYCLE-001 · 본 file 신설 (= 직전 3 file 본문 통합 default · 본질 변경 X · 단일 SoT 정합 default) + 3 file 삭제 + `check-abbreviation.sh` 인용 갱신 + `post-edit-degeneration-check.sh` 인용 갱신 + `text-degeneration-prevention.md` 인용 갱신 + `terminology.md` 인용 갱신 + 5-repo byte-identical propagation
