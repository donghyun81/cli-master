# Allowed Acronyms — Standard Abbreviation SoT

> **단일 목적**: 식별자 구성 요소로 허용되는 표준 약어의 단일 진실 소스 (SoT).
> 이 목록에 포함된 약어는 `no-abbreviation-policy.md` 의 금지 범위에서 제외된다.
> **신설**: GLOBAL-NO-ABBREV-POLICY-001 (2026-05-10).
> **연관 파일**:
> - `no-abbreviation-policy.md` — 정책 본문 + 충돌 규칙
> - `forbidden-abbreviations.md` — 금지 사용자 정의 축약 seed list
> - `.claude/hooks/check-abbreviation.sh` — 자동화 검증 hook
> SOT: `CLAUDE.md`

---

## 충돌 규칙

- allowed-list ∩ forbidden-list = ∅ (충돌 시 allowed 우선)
- 신규 약어 추가 = 산업 표준 증빙 필요 + master cycle PR 의무

---

## 1. 네트워크 / 웹 / 데이터 형식

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

---

## 2. 식별자 / 보안 / 암호화

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| UUID | Universally Unique Identifier | RFC 4122 |
| ID | Identifier | 업계 표준 |
| MD5 | Message Digest 5 | RFC 1321 |
| SHA | Secure Hash Algorithm | FIPS 180-4 |
| AES | Advanced Encryption Standard | FIPS 197 |
| RSA | Rivest–Shamir–Adleman | 업계 표준 |

---

## 3. 인터페이스 / 사용자 경험

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| UI | User Interface | 업계 표준 |
| UX | User Experience | 업계 표준 |

---

## 4. 데이터 / 인프라

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| DB | Database | 업계 표준 |
| SQL | Structured Query Language | ISO/IEC 9075 |
| SDK | Software Development Kit | 업계 표준 |
| CLI | Command Line Interface | 업계 표준 |

---

## 5. 시스템 / 하드웨어

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| IO | Input/Output | 업계 표준 |
| CPU | Central Processing Unit | 업계 표준 |
| RAM | Random Access Memory | 업계 표준 |
| GPU | Graphics Processing Unit | 업계 표준 |
| OS | Operating System | 업계 표준 |
| FS | File System | 업계 표준 |

---

## 6. AI / ML / 도메인 표준

| 약어 | 풀네임 | 표준 출처 |
|---|---|---|
| MCP | Model Context Protocol | Anthropic 공식 |
| LLM | Large Language Model | 업계 표준 |
| AI | Artificial Intelligence | 업계 표준 |
| ML | Machine Learning | 업계 표준 |
| NLP | Natural Language Processing | 업계 표준 |

---

## 7. 프레임워크 / 라이브러리 API 명 (자동 포함)

아래 패턴은 외부 명세를 따르므로 allowed-list 자동 포함:

| 패턴 | 예시 | 근거 |
|---|---|---|
| Android Framework 클래스명 | `HttpURLConnection`, `DBHelper`, `ViewModel` | Android SDK 공식 |
| Jetpack Compose 패턴 | `LazyColumn`, `TopAppBar` | Jetpack 공식 |
| 언어 키워드 + 표준 라이브러리 | Kotlin `val`, `var`, `fun`, `init` | Kotlin 언어 명세 |
| Java 표준 라이브러리 클래스명 | `StringBuilder`, `BufferedReader` | JDK 공식 |
| 3rd-party 라이브러리 공개 API 명 | Supabase, Koin, Room 등 공개 API | 각 라이브러리 공식 |

---

## 8. 신규 약어 추가 절차

1. `allowed-acronyms.md` 에 새 행 추가 (표 형식 유지)
2. **산업 표준 증빙** 필수: RFC / W3C / ISO / 공식 플랫폼 문서 링크
3. master repo cycle 신설 (`GLOBAL-NO-ABBREV-ACRONYM-ADD-NNN`)
4. 4-repo propagation (`scripts/propagate.sh --targets all`)
5. `verify-sync.sh` PASS 확인
6. CLAUDE.md §15 표에 cycle entry 추가

---

## 9. 본 파일의 변경 정책

본 파일 = cli infra 권장 byte-identical.
변경 시 master cycle 신설 + 4-repo propagation 의무 (`cycle-discipline.md` §15 패턴 1).
