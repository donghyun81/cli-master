# Code Principles Rules

> **단일 목적**: 모든 자식 repo (도메인 무관) 의 코드 작성 / 리뷰 시 적용되는 원칙 + 코드 리뷰 체크리스트.
> **C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 신설** (Q1 답 추가).
> **연관 파일**:
> - `workflow-core.md` §implement (TDD / 직접 구현 우선 / 외부 준비 연기)
> - `verification-and-review.md` §review (REVIEW.md 12-section)
> - `legacy-cleanup-governance.md` (cleanup pass)
> SOT: `CLAUDE.md`

---

## 0. 최상위 원칙 (= 본 file 전체의 상위 층 · §1 SOLID 는 이 원칙의 하위 적용이다)

> **출처**: 설계 SoT `DESIGN-SELFWARD-ARCH-REBUILD-001.md` §0.2(원칙 5) + §0.3(집행 형태) — **부모 mount root 소재**(= master 트리 밖 · 실측 `find ~/AndroidStudioProjects -maxdepth 3`). 본 §은 그 문면을 **master 어휘로 옮긴 것**이고 verbatim 복제가 아니다. 정착 = `MASTER-ENGINEERING-BASELINE-001`(2026-08-29).
> **왜 §1 앞인가**: 원칙이 SOLID 를 지배한다. SOLID 는 이 원칙을 코드 표면에 적용한 **하위 층**이고 그 역이 아니다 — 위에서부터 읽는 사람이 순서로 그 위계를 읽어야 한다.

### 0.1 원칙 5

1. **유지보수·최적화를 1급 요건으로 둔다.** ★**「지금 안 터진다」는 완료 조건이 아니다** — **최소 변경 · 최소 구현 · 「안 터지게만」도 완료 조건이 아니다.** 완료는 *다음 사람이 이 코드를 안전하게 바꿀 수 있는가*로 판정한다. 최적화 축(생명주기 · 메모리 · 재구성)을 요건 칸에 명시한다.
2. **추후 발생 가능한 문제를 설계 시점에 반영한다.** 「scope 밖」으로 미룰 때는 **코드 주석이 아니라 원장에 회부**한다 (= §0.3 · K-132). 주석에만 적힌 부채는 **census 를 돌려야만 발견된다**.
3. **구글식 엔지니어링 관행을 기준선으로 둔다** — 문서화 · 주석 · 코드 관리 · **의존성** · 유지보수 · **테스트** 를 **각 발주의 요건 칸으로 명시**한다 (= 필수 요건 6칸 · ★2026-08-29 `MASTER-TASK-PURPOSE-CONTRACT-001` 이 **⑹ 배경·목적**을 신설해 한 칸 늘었다 · 본문 SoT = [`disk-verification` skill](../../.claude/skills/disk-verification/SKILL.md) §4 ⑥).
4. **판을 쪼갤 때는 「작아서」가 아니라 「경계가 옳아서」 쪼갠다.** **범위 축소가 기본값이 아니다.**
5. **변경하는 구현부의 주석에 판단 근거 · 다음 사람이 볼 것을 남긴다** — 「왜 이렇게 됐나」가 코드에서 읽혀야 한다 (= [`code-style-guide.md`](./code-style-guide.md) §C **C-4**).

### 0.2 ★SRP 재정의 — 「하나의 변경 이유」에는 생존주기가 들어간다 (K-145)

§1 `S — Single Responsibility Principle` 의 「하나의 변경 이유」는 **역할**만 뜻하지 않는다. **생존주기**(= 무엇과 함께 태어나 함께 죽나)가 그 판정에 **포함**된다.

- ★**한 단위의 상태는 그 단위와 함께 태어나 함께 죽어야 한다.** 화면이 소유할 상태가 앱 전체를 살아 있으면 그것은 「기능이 많은 것」이 아니라 **SRP 위반**이다 — 변경 이유가 둘(화면 · 앱)이기 때문이다.
- **판정 축 2**: ⑴ **생존주기** — 무엇과 함께 태어나 함께 죽나 ⑵ **역할** — 변경 이유가 하나인가.
- ★**SRP 의 자가 *아닌* 것**: **파일 크기 · 파일 개수 · 시트/섹션 유무 · 함수 길이.** 신호일 수는 있어도 **판정이 아니다** — 큰 파일이 단일 책임일 수 있고, 잘게 쪼갠 파일이 생존주기를 뒤섞을 수 있다. 자를 크기로 바꾸면 **책임이 아니라 줄 수를 리팩터**하게 된다.
- **위반의 대표 형태** = 「화면에 표시할 데이터의 생명주기가 화면·위치 단위가 아니라 **앱 전체에서 생존**」 = 누수가 크고 버그 여지가 큰 구현. 구현 층 규약 = [`KOIN_DI_BASELINE.md` §4a](../agent/architecture/KOIN_DI_BASELINE.md) + [`app-implementation-guide.md` §1.6](../guides/app-implementation-guide.md).
- §1 `S` 항 본문은 **무접촉** — 본 §이 상위 층에서 규정하고 중복 서술하지 않는다.

### 0.3 집행 형태 — 원칙은 두 자리에서만 집행된다

원칙은 선언으로 집행되지 않는다. **발주서에서의 모양**과 **접수 검증의 자**, 그 둘로만 집행된다. (아래 표 = 설계 SoT §0.3 의 master 어휘 판)

| 원칙 | 발주서에서의 모양 | 접수 검증의 자 |
|---|---|---|
| 1 유지보수·최적화 1급 | 「유지보수 부채」 칸 = 이 판이 **남기는 것**(0 이면 「0」이라 적고 근거) + 최적화 축 명시 | 부채 칸 공란 = 미충족 · 「scope 밖」이 diff 에 있는데 원장 번호가 없으면 지적 대상 |
| 2 추후 문제 선반영 · 원장 회부 | 코드 주석의 「scope 밖 / 후속 / TODO」 는 **회부 번호(`#NN` / `<PREFIX>-TNNN`)를 동반** | `grep -n 'scope 밖\|TODO\|후속' <변경 file>` 의 각 hit 에 번호 동반 = 전량(자 = 행 단위 · 주석 한정) |
| 3 구글식 기준선 | **필수 요건 6칸**(의존성 · 테스트 · 문서·주석 · 유지보수 부채 · 회귀 그물 · ★**배경·목적**) = 발주서 필수 절 | 6칸 중 **1칸이라도 부재 = 발주 미완**(= 저작 층 게이트 · 발주서 반려) |
| 4 경계가 옳아서 쪼갠다 | **판 경계 1줄** = 이 판의 경계가 왜 여기인가 | 경계 문장 부재 = 반려 · 「작아서」가 이유이면 **판을 다시 잡는다** |
| 5 구현부 주석 = 판단 근거 | 변경부 KDoc/주석에 **① 선택지 ② 버린 이유 ③ 다음 사람이 볼 것** · 계수 = ChangeBudget 주석 축 별도 계상 | 변경 file 의 신설 주석에 「왜」 문장 0 = 회부(강제는 리뷰 층 · `code-style-guide.md` §C C-4) |

- **본문 SoT** (= 본 §은 원칙 층이고 본문을 복제하지 않는다): 「발주서에서의 모양」 = [`disk-verification` skill](../../.claude/skills/disk-verification/SKILL.md) §4 ⑥ + ⑥ 세부 · 「접수 검증의 자」 = [`verification-and-review.md` §0](./verification-and-review.md) · 판 개설 규율 = [`cycle-discipline.md` §32](./cycle-discipline.md).
- ★**K-132 — 「scope 밖 / 후속 / TODO」는 원장 회부 번호를 동반한다.** 번호 없는 주석 부채는 **아무도 회수하지 않는다**(주석은 대장이 아니다 — 검색 대상이 아니고 마감되지 않는다). 대장 = `DESIGN-DEBT.md` / `STALE-DEBT.md` / 회부 원장. 번호 없는 「나중에」 = **리뷰 지적 대상**.

---

## 1. SOLID 5 원칙

### S — Single Responsibility Principle
- 한 클래스 / 함수 / 모듈 = 하나의 변경 이유.
- 적용 예: ViewModel = UI state 만 / UseCase = business rule 만 / Repository = data source 추상화만.
- 위반 신호: 한 파일에 "AND" 로 연결된 책임 (예: "User 인증 + Profile 캐시 + Logging").

### O — Open / Closed Principle
- 확장에 열림 + 변경에 닫힘.
- 적용 예: 새 인증 방식 추가 시 기존 `AuthProvider` 수정 X / `OAuthAuthProvider` 신설.
- 위반 신호: enum 확장마다 모든 caller `when` 분기 갱신 의무.

### L — Liskov Substitution Principle
- 서브타입은 슈퍼타입 자리에서 동작 보장.
- 적용 예: `Repository<User>` 의 모든 구현이 `getById(id): User?` 의 null 반환 계약 준수.
- 위반 신호: 서브 클래스에서 `throw NotImplementedError()` / 슈퍼 메서드의 precondition 강화.

### I — Interface Segregation Principle
- 큰 인터페이스 1 개 < 작은 인터페이스 N 개.
- 적용 예: `UserRepository` 가 read-only 와 write 분리 → `UserReadRepository` + `UserWriteRepository`.
- 위반 신호: 구현 클래스 안에 사용 안 하는 메서드가 절반 이상.

### D — Dependency Inversion Principle
- 고수준 모듈 = 저수준 모듈에 의존 X. 양쪽 모두 추상에 의존.
- 적용 예: ViewModel → `interface AuthRepository` → `SupabaseAuthRepository impl`.
- 적용 의무: clock / dispatcher / identity / logger / uuid 인터페이스 주입 (`workflow-core.md` §implement Testability Seams 명시됨).

---

## 2. 보조 원칙 (DRY / KISS / YAGNI)

### DRY — Don't Repeat Yourself
- 동일 logic 2 곳 이상 = 1 곳으로 추출 평가.
- 단 **너무 이른 추상화 금지** (KISS 우선) — 3 곳 이상 발생 후 추출.
- 적용 예: 동일 Date 포맷 변환이 2 곳 → KISS 우선 / 3 곳 이상 → 헬퍼 추출.

### KISS — Keep It Simple, Stupid
- 직접 구현 우선 (`workflow-core.md` §implement 명시됨).
- 새 추상화 추가 전 직접 구현이 더 단순한지 평가.
- 적용 예: state machine 라이브러리 도입 전 sealed class + when 으로 충분한지 검토.

### YAGNI — You Aren't Gonna Need It
- "나중에 쓸 것" 으로 추가하지 않음.
- 적용 예: API stub 의 응답 형식을 미래 가정으로 확장 X / 실제 필요 시점에 추가.
- DEFERRED domain 정책 (`deferred-domains.md`) = YAGNI 의 큰 적용.

### 암묵 기본값 금지 — 누락은 컴파일 오류여야 한다

- 라이브러리 / 공용 모듈(foundation)은 **계약(interface) 과 구현(impl) 을 제공**할 뿐,
  **호출자를 대신해 기본 선택을 하지 않는다.** 선택은 소비하는 앱의 **조합 루트** 몫이다.
- 필수 협력자에 기본값(`= NoOpX` / `= MockX()`)을 두지 않는다 → **빠뜨리면 컴파일 오류**가 나야 한다.
- **★핵심 근거**: DI 검증 도구는 **구조적 존재**만 본다. Koin verify / Compiler Plugin 의 계약은
  *"structural dependency presence, **not semantic correctness**"* 다. **존재하지만 의미가 틀린
  바인딩은 어떤 도구도 잡지 못한다. 그래서 기본값을 없애는 것이 유일한 구조적 방어다.**
- 실측 사례:
  - **F1** — foundation 이 "production-safe NoOp 기본 bind" 를 제공 → 자식이 실 impl 등록을
    빠뜨려도 컴파일·기동 전부 성공 → production `EntitlementRepository` 가 **잔액 0 하드코딩 NoOp**
    으로 잔존 (`billing-rules.md §1.1` supersede 절).
  - **`core/designsystem` `GentlyTheme`** — **같은 계열의 반대 방향**. 기본값을 제거해
    `colorScheme` / `typography` 를 필수화하자 호출부 미갱신이 **컴파일 오류로 즉시 드러났다**.
    "기본값 제거 = 누락이 보인다" 의 실증.
- 공식 근거: Google 수동 DI 가이드 — **컨테이너 + 생성자 주입**. 컨테이너는 **`object` 싱글턴이 아니라**
  앱이 수명을 소유하는 인스턴스여야 교체·테스트가 가능하다.
- **deviation**: 기본값이 **의미상 유일 정답**이고 틀린 선택이 성립하지 않을 때만(예: 순수 포맷 옵션).
  협력자 · 정책 · I/O 경계 · 결제/권한 경계에는 **적용 금지**.

### 표면 속성으로 분류하지 않는다 — 불변식을 잰다

- **이름 · 경로 · 도구의 존재**는 **분류 근거가 아니다.** 무엇인지 판정하려면 **그것이 만족하는
  불변식**(무엇을 하는가 · 무엇에 의존하는가 · 무엇이 그것을 소유하는가)을 **직접 measure** 한다.
- 표면 속성은 **가설**이고, 측정은 **판정**이다. 가설을 판정으로 승격시키는 순간 사고가 난다 —
  특히 **폐기 · 이관 · 소유 판정 · "불가능" 선언** 처럼 **되돌리기 비싼** 결정에서.
- **실측 사례 3 (전부 같은 형태 · 표면을 보고 분류했다)**:
  - **`probe.ts` 파일명 오분류** — 이름이 "probe"(임시 탐침)처럼 보인다는 이유로 폐기 후보에 올랐다.
    실제로는 **유일한 Money probe** 였다 (= 폐기 직전에 회수).
  - **`docs/rules` 경로 오판** — 경로가 자식 repo 안에 있다는 이유로 "자식 소유"로 판정할 뻔했다.
    실제 불변식 = **4-repo byte-identical + 자기 선언 + `propagate.sh` 전파 경로** = **master 소유**
    (= 자식에서 고쳤으면 4-repo drift · `MASTER-CLI-RULES-SETTLE-001` §C 소유 판정 3 기준의 유래).
  - **`supabase functions logs` 부재** — 서브커맨드가 **없다**는 사실에서 "**콘솔만 가능**"을 도출했다.
    도구의 부재는 **경로의 부재가 아니다** — 실제 경로는 Management API `logs.all` 로 실재했다
    (= `supabase-handling.md` §2.10).
- **판정 절차**: filename find 1차 → **container 내부 content grep 2차 의무** → 둘 다 부재일 때만
  STOP/UNKNOWN (= `cycle-discipline.md` §17 BASELINE 실측 표준 · `anchor-list.md` A7 정합).

### 부재는 전수 트리에서만 판정한다 — subset 위의 "없다" 는 무효

- **"없다" 는 탐색 범위에 대한 진술이지 대상에 대한 진술이 아니다.** 부재 판정의 유효 범위는
  **잰 트리의 크기**를 넘지 못한다. **subset**(staged 사본 · 단일 repo cwd glob · 부분 grep ·
  디렉터리 목록) 위에서 내린 부재 판정은 **무효**다 — 없는 게 아니라 **안 본 것**이다.
- **탐색 범위 밖 = 「부재」가 아니라 「판정 보류」**로 표기한다. 둘을 같은 칸에 적는 순간 다음 사람은
  **재측정 없이** 그 부재를 인용한다 (= 위 「표면 속성」 축과 같은 사고 · 가설의 판정 승격).
- **부재를 보고할 때는 어느 트리에서 무슨 명령으로 쟀는지 병기한다** — `reporting.md` §8.1
  (수치 = 산출 명령 + 환경 동반)과 **한 쌍**이다. 명령·범위 없는 부재 = **재현 불가 = 근거 아님**.
- **위임 시 범위를 명시한다**: 하위 세션 · 감사관에게 **부분 사본을 주면 그 사본이 곧 세계가 된다.**
  **인용 대상까지 범위에 넣거나**, 프롬프트에 *"범위 밖 = 판정 보류(부재 아님)"* 를 못 박는다.
- **받은 부재 보고는 회수 시 재측정한다.** 보고자가 정직하게 "보류"라 써도 **안 쓴 것이 섞인다**
  — 위임자가 범위를 안 줬으면 **보고자는 자기 범위가 부분인 줄 모른다.**
- **실측 사례 2 (= 위 3 사례의 *부재* 축 · 둘 다 "안 본 것"을 "없는 것"으로 읽었다)**:
  - **staged subset 28 file 감사 위임** — 부분 사본만 받은 감사관이 **"죽은 경로" 13건**을 보고했다.
    실 disk 재측정 결과 **13/13 실존 = 전량 오탐** — 살아 있는 UI 게이트 6 경로를 "무효"로 보고할
    뻔했다 (= `AUDIT-SELFWARD-SOT-COHERENCE-LEDGER-20260726.md` · 위임 범위 미명시가 유일 원인).
  - **repo 내부 glob 부재 판정** — `GROUND-TRUTH-*.md` 를 repo 안에서만 찾고 "없음"으로 판정해
    3 항목 처분이 `pointer` → `discard` 로 뒤집혔다. 실제로는 **부모 mount root 에 실존**했다.
    ★**결론은 살아남았다**(그 file 은 4-repo 어디에도 tracked 가 아니라 애초에 pointer 부적격) —
    그러나 **근거가 틀린 채로 맞은 것**이라 다음엔 안 맞는다. **맞은 결론은 규칙의 알리바이가 아니다.**

---

## 3. 라이브러리 사용 최소화 (의존성 정책)

코드 원칙 관점에서 의존성은 최소화한다 (= §2 DRY/KISS/YAGNI + 직접 구현 우선 정합). 구체 판정 절차의 canonical 은 별 file 이 소유하며 본 §은 코드 원칙 맥락에서 가리킨다.

### 신규 의존성 도입 의무 (DependencyDecision 8 항목)

`libs.versions.toml` 신규 항목 = PLAN `## 2. DependencyDecision` 8 항목(①~⑧) 필수. 8항 본문 + 평가 기준의 canonical = `docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md`. 직전 본 §의 Android 빌드/보안 축 고유 차원(라이센스 호환성 · CVE history · APK/Bundle size · ProGuard/R8 keep rule · 제거 절차 · 직접 구현 LOC 비교)은 grow-only merge 로 canonical 의 ②④⑥⑦ 하위 기준에 흡수됨 (= 정보 소실 0). PLAN.md 형식 = `reporting.md §5`.

### UI 라이브러리 억제 default

UI 라이브러리 억제 강도(직접 구현 우선 default · 외부 UI 라이브러리 도입 금지 default · Coin 명시 승인 필수 · Material3 누락 컴포넌트 = Compose-Foundation 래퍼 우선)의 canonical = `docs/rules/ui-ux-analysis.md` §UI 라이브러리 억제 기본값 (= UI vs 인프라 판별 + per-category 포함). 코드 리뷰 시 본 강도를 적용한다.

---

## 4. 코드 리뷰 체크리스트 (reviewer.md 자동 참조)

reviewer agent 가 REVIEW.md 12-section 작성 시 본 체크리스트 적용 의무:

### A. 기능 정확성
- [ ] PLAN.md 의 ChangeBudget 범위 안에서 변경됐나?
- [ ] verifier 의 Exit Criteria PASS 했나?
- [ ] STOP 트리거 (DBMig / MoneyAuth) 위반 X?
- [ ] **폐기 / 이관 / 소유 / "불가능" 판정이 이름·경로·도구 존재 같은 표면 속성이 아니라 measure 한 불변식에 근거하나** (= §2 표면 속성 분류 금지)?

### B. SOLID + 보조 원칙
- [ ] **SRP**: 변경 클래스 / 함수 = 단일 책임 유지?
- [ ] **OCP**: 새 case 추가 시 기존 caller 영향 최소?
- [ ] **DIP**: 구현 클래스 직접 인용 X · 인터페이스 주입?
- [ ] **DRY**: 같은 logic 3 곳 이상 X (3 곳 이상이면 추출 의무)?
- [ ] **KISS**: 새 추상화 가 직접 구현보다 단순한 근거 있나?
- [ ] **YAGNI**: 가정한 미래 사용 case 가 현재 PLAN 안에 있나?

### C. 아키텍쳐 정합
- [ ] DTO · Entity · DomainModel · UiState 혼용 X?
- [ ] ViewModel → UI 단방향 (UI state mutation X)?
- [ ] shared/domain → framework import X (layer-checker 자동 검증)?
- [ ] 신규 Koin 모듈 = `app/` 또는 `shared/app` 안만?
- [ ] 필수 협력자에 암묵 기본값(`= NoOpX` / `= MockX()`) 없나 — 누락이 **컴파일 오류**로 드러나나?
- [ ] 조합 루트가 seam 실체를 **한 곳에서 명시**하나 (module 후행 등록 override 의존 X)?

### D. 의존성
- [ ] 신규 의존성 = DependencyDecision 8 항목 모두 작성?
- [ ] 라이브러리 대체 = 직접 구현 비교 LOC 기록?
- [ ] APK size 영향 측정 (예: BundleAnalyzer)?

### E. 테스트
- [ ] 신규 UseCase / Coordinator = `FakeXxx` 기반 테스트 함께 / 먼저?
- [ ] 테스트 심 (clock / dispatcher / identity / logger / uuid) 인터페이스 주입?
- [ ] verifier 의 Exit Criteria 가 실행 가능 명령 (0 command 금지)?

### F. 안전성
- [ ] 시크릿 / PII 하드코딩 X (`safety-and-secrets.md` 명시됨)?
- [ ] HTTP X · HTTPS only?
- [ ] 비가역 변경 (파일 삭제 / 스키마 변경) = Coin 명시 승인?

### G. cleanup
- [ ] EVIDENCE.md `## Cleanup Assessment` 섹션 작성됐나?
- [ ] 미사용 import / dead code / 중복 포맷터 제거?
- [ ] Deferred Cleanup 항목 = TODO.md 에 lazy 명시됨?

### H. UX Laws (`docs/rules/ux-laws.md` 자동 참조 의무 · UI/UX task 한정)
- [ ] task 유형 식별 → §5 매트릭스 row 추출됐나?
- [ ] 매트릭스 row 의 권장 법칙 모두 PLAN.md / IMPL / REVIEW §B [UX Laws] 인용됐나?
- [ ] §3 비권장 5 항목 (의도적 지연 / 인위적 진척 / 부정 위장 / 카운트다운 / Cognitive Bias 활용) 위반 X?
- [ ] Dark Patterns 5 종 (Roach Motel / Confirmshaming / Disguised Ads / Forced Continuity / Hidden Costs) 위반 X?
- [ ] 게슈탈트 5 (F-1~5) + Fitts (≥ 48dp) + Doherty (< 400ms) + Choice Overload (≤ 7) 명시 검증?

---

## 5. 위반 시 처리

### REVIEW 결과 분류

| 분류 | 조건 | 처리 |
|---|---|---|
| **PASS** | A~G 모두 ✓ | DONE 마감 |
| **PARTIAL** | 1~3 항목 ✗ + 본 작업 직접 영향 X | TODO.md 에 lazy 추가 + DONE |
| **FAIL** | 4 항목 이상 ✗ 또는 본 작업 직접 영향 1+ | replan (change-planner 재호출) |

### SOLID 위반 mitigation 패턴

- **SRP 위반**: 큰 클래스 → 책임별 분리 (`UserRepository` → `UserReadRepository` + `UserWriteRepository`)
- **OCP 위반**: enum 확장마다 caller 갱신 → strategy pattern 도입 평가
- **DIP 위반**: 구현 직접 인용 → 인터페이스 추출 + Koin 주입

---

## 6. 본 rule 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 4-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## 7. 명시 cycle 이력

> 판정 = **실질 개정 있음** (= 2026-08-30 `MASTER-RULE-HISTORY-SECTION-001` 소급 판정 · 축 = `rule-footer-common.md` 「실질 개정 ↔ 기계 치환」 · 판정표 29 행 = 그 판 REPORT). 소급 범위 = **판정 근거 한정**(= 무한 소급 금지 · 전 계보 열거 아님) · **기계 치환 commit 미등재**(= 축 자기 적용).

- 2026-05-02 · `C1-MASTER-BOOTSTRAP-001` · 본 rule 신설 (= 158 행 · `ff65723`).
- 2026-08-30 · `MASTER-RULE-HISTORY-SECTION-001` · **본 절 신설** (= 위 판정의 착지 · `rule-footer-common.md:10` 등재 의무 소급 이행 · 본문 절 무접촉).
