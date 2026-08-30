# Terminology — 일반 어휘 사전 (cli infra)

> **단일 목적**: 본 패키지 안 자주 등장하는 어휘 중 표기 혼용으로 진입자 혼동 가능한 어휘의 단일 진실 사전.
> **신설**: MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001 (2026-05-10).
> **분담**:
> - CLAUDE.md L3 "용어 사전" 섹션 = CLI / cli infra / CLI 환경 / *-CLI-NNN / Cowork ↔ CLI 동기화 (top-level reading entry · 항상 보임)
> - 본 file = 그 외 일반 어휘 (rule file 형식 · 깊이 있는 정의 · 향후 누적)
> SOT: `CLAUDE.md`

---

## 1. SoT (Source of Truth)

### 1.1 동의어

다음 표기 모두 **동의어** (= Single Source of Truth · 단일 진실 출처):

| 표기 | 본 패키지 빈도 (2026-05-10 실측) | 비고 |
|---|---|---|
| `SoT` ★ | 206 | **본 패키지 표준 표기** (camelCase) |
| `SOT` | 40 | file 머리 `> SOT: CLAUDE.md` 위주 — 의미 동일 |
| `SSOT` | 6 | `SSOT_PRINCIPLES.md` file 명/제목 한정 — 의미 동일 |
| `SSoT` | 0 | 본 패키지 미사용 |
| `Source of Truth` | 9 | full form |
| `Single Source of Truth` | 7 | full form (강조형) |

**신규 작성 표준**: `SoT` (camelCase). file 명/제목 한정으로 `SSOT` 허용 (예: `SSOT_PRINCIPLES.md`). legacy 표기는 그대로 (정정 cycle 비용 vs 가치 평가 결과 = 신규만 표준 적용 · D 옵션).

### 1.2 차이는 도메인 instance 차이뿐 (8 도메인)

본 패키지 안 SoT 표현 = 모두 SSoT 패러다임의 instance. 차이는 "**어느 도메인의 단일 진실인가**" 의 도메인 차이일 뿐.

| # | 도메인 | 무엇이 단일 진실인가 | 대표 file |
|---|---|---|---|
| 1 | 메타 헌법 | "어디가 SoT 인가" 의 권한 ranking 자체 | `docs/agent/architecture/SSOT_PRINCIPLES.md` |
| 2 | 운영 헌법 | repo 별 Claude Code 운영 규칙 | `CLAUDE.md` (master + 자식) — file 머리 `> SOT: CLAUDE.md` 의 다수 back-reference |
| 3 | 디자인 일반 정책 | 화면 디자인 5 계층 우선순위 + lifecycle | `docs/design/design-sot-policy.md` (도구 무관 75%) |
| 4 | 디자인 화면 단일 출처 (실데이터) | 화면 1 개의 구조/시각 정답 | 1a `<screen>.ui-spec.json` + 1b `<screen>.<ext>` |
| 5 | 도구 바인딩 | 디자인 도구의 구체 절차 | `docs/design/pencil-sot-policy.md` (의미 = pencil-sot-binding) + `docs/rules/pencil-uiux-workflow.md` |
| 6 | refresh baseline | 런타임 → SoT 비교 기준의 현재 baseline | `docs/rules/uiux-sot-refresh.md` + `.ai/uiux-sot/latest/` |
| 7 | 화면명 매핑 | SoT 화면명 ↔ Compose 코드 화면명 매핑 | **현행 SoT 부재** (= 2026-08-23 `MASTER-AIDOC-RELEASE-REALIGN-001` 은퇴 · 구 판 = 동결 3(GB/GD/GT) 전용 표 · 활성 자식 Selfward 섹션 0 이라 읽히면 죽은 매핑을 줬다). 은퇴 직전 원문 = `.auto-memory/sot-code-name-map-COLD.md` verbatim (master only). Selfward 판 재수립 = 화면 census 선행 별 판 |
| 8 | 도메인 정책 SSoT (분산) | 각 도메인 정책의 단일 출처 | `auth-rules.md` (인증) · `code-style-guide.md` §C 「명명·관용」 (식별자 명명 · 2026-07-29 `MASTER-CLI-JUDGMENT-SHIFT-001` 이관 — 구 `abbreviation-policy.md` 금지 seed/허용 약어 = `.auto-memory/abbreviation-policy-COLD.md` verbatim) · `working-file-lifecycle.md` (working file) · `cycle-discipline.md` (cycle) · `verification-and-review.md` (검증) · `routing-and-delegation.md` (agent) · `ux-laws.md` (UX) · `data-model.md` / `api-spec.md` / `billing.md` (자식 도메인) |

### 1.3 SoT 아님 (반대 케이스 · 명시 부정)

다음은 SoT 와 헷갈리기 쉽지만 **SoT 아님** 명시 박힘 (`design-sot-policy.md`):
- 검수 PNG (`<screen>.preview.{light,dark}.png`) — P6 pixel-diff 비교용
- 런타임 캡처 (`.ai/uiux-sot/latest/<screen>/*.png`) — 회귀 비교용
- 토큰 export · vars — 재원은 다른 file

### 1.4 진입자 빠른 참조

- "여기서 SoT 가 뭐야?" → 위 §1.2 표의 도메인 매칭 후 대표 file 진입
- "왜 표기가 다 달라?" → §1.1 동의어 표 — 모두 같은 의미 · 신규 작성은 `SoT` 표준
- "어느 SoT 가 우선?" → `SSOT_PRINCIPLES.md` 의 권한 계층

---

## 2. 향후 어휘 추가 절차

1. 본 file 안 새 섹션 (`## N. <어휘>`) 추가
2. 동의어 + 빈도 (실측) + 본 패키지 표준 표기 + 도메인 instance 분류 명시
3. master cycle 신설 (`MASTER-CLI-TERMINOLOGY-<TOPIC>-DEFINE-NNN`)
4. 4-repo propagation (`scripts/propagate.sh docs/rules/terminology.md --targets all`)
5. `verify-sync.sh` PASS 확인

---

## 3. 본 file 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 4-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## 4. 박음 / 박제

> **신설**: 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-002` (= ㉡ #159 N3 · 위 §2 절차 준수).
> ★**판정 = 두 낱말은 동의어가 아니다.** 통합하지 않고 **둘 다 정의**한다. 근거 = §4.2.

### 4.1 빈도 (= 2026-08-30 실측 · 자 = `grep -rn <낱말> <경로> | wc -l` · 단위 = **행**)

| 낱말 | `.ai/tasks/` | `docs/rules/` | `.claude/` | 계 |
|---|---|---|---|---|
| 박음 | 29 | 0 | 1 | 30 |
| 박은 | 13 | 0 | 0 | 13 |
| 박는 | 1 | 1 | 0 | 2 |
| 박제 | 0 | 15 | 2 | 17 |
| 박아 | 0 | 2 | 0 | 2 |
| 박혀 | 0 | 0 | 3 | 3 |

- ★**계수 주의** (= `verification-and-review.md` §0.3 정합): 「박음」 계열 고유 행 **30** 중 **22 행이 `.ai/tasks/MASTER-ARCHITECTURE-FOUNDATION-LINK-001.md` 한 file** 이고, 그 file `:23` **한 행에만 10 출현**이다(= 문면 퇴행 · 「박은 … 박음 … 박은」 반복). ⟹ **행 계수가 실사용 빈도를 과대 표시**한다. 고유 file = **3**. 단위를 안 적으면 30 을 「30 곳에서 쓴다」로 읽는다.
- ★**분포 자체가 뜻 차이의 방증**이다 — 박음 계열은 `.ai/tasks/`(= 집행 기록)에, 박제는 `docs/rules/`(= 규약)에 산다. **교집합이 사실상 0** 이다.

### 4.2 뜻 (= 판정 · 갈림 축 = 「낡았을 때 고쳐야 하는가」)

| 낱말 | 뜻 | 축 | 낡으면 |
|---|---|---|---|
| **박다** (박음 · 박은 · 박는 · 박힘 · 박혀) | **한 자리에 고정해 넣다** — 값 · 경로 · 결정을 특정 위치에 하드코딩/명기한다 | **위치** | ★**결함** (= 고쳐야 한다) |
| **박제** | **그 시점 상태를 그대로 보존하다** — census · raw output · 관례를 스냅숏으로 남긴다 | **시점** | ★**정상** (= 낡는 게 맞다) |

- ★**판정 근거 = 낡음의 취급이 정반대다.** [`stale-artifact-tracking.md`](./stale-artifact-tracking.md) `:19` 는 「**이력 · 박제 문면**(additive-ledger 보존분)」을 stale 추적 **「적용 안 함 — 이력은 낡는 게 맞다」**로 **명시 분류**한다. 반대로 박음/박힘은 낡으면 그 자체가 결함이다 — 실측 = `scripts/activate-agent.sh` 의 `MASTER_DIR=…claude-cli-master` **하드코딩 박힘**(= 경로 drift) · `.pen` 에 foundation Neutral 이 **박혀** 있는 gray-trap(= 자식 brand 미반영). ⟹ ★**두 낱말을 같은 뜻으로 쓰면 「고쳐야 할 낡음」과 「고치면 안 되는 낡음」의 분기가 사라진다.** 이것이 통합하지 않는 이유다.
- **본 패키지 표준 표기**: 위치 고정 = **「박음」**(명사형) · **「박힘」**(피동) / 시점 보존 = **「박제」**. ★**서로 바꿔 쓰지 않는다.**
- **도메인 instance 분류** (= §1.2 형식): **박음** = 집행 기록 축(`.ai/tasks/` · Task 문서의 값 고정) + 코드 축(리터럴 하드코딩) · **박제** = 규약 축(`docs/rules/` · census / 관례 / raw output 보존).
- ★**`.ai/tasks/` 30 행은 본 판이 고치지 않는다** — 사전이 먼저다. 특히 위 퇴행 1 행은 **어휘 문제가 아니라 퇴행 문제**라 축이 다르다(= 별 판).

### 4.3 절차 잔여 (= §2 5 단계 대조)

**1 · 2 · 3 = 본 판 이행** · **4(4-repo propagation) · 5(`verify-sync.sh` PASS) = 미이행** (= propagation 실행 = Coin 소관 · 본 판 scope 밖). ⟹ 본 절은 **master 판만 현행**이며 자식 3(FND · PDOCS · SW)은 **다음 propagation cycle** 에서 정합한다. ★**미이행을 빈칸으로 두지 않는다**(= 빈칸은 「안 봤다」와 구별 불가).

---

## 5. 명시 cycle 이력

> **소급 경계** = 본 절 신설 시점 기준 **본 판**부터. 그 앞(= `MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001` 본 file 신설 · `MASTER-AIDOC-RELEASE-REALIGN-001` §1.2 7행 은퇴 · `MASTER-CLI-JUDGMENT-SHIFT-001` §1.2 8행 이관 등)은 **회부** — 등재 의무는 **2026-08-29** 에 생겼다(= `rule-footer-common.md:10`).

- 2026-08-30 · `MASTER-DOC-MANIFEST-SWEEP-002` · **`## 4. 박음 / 박제` 절 신설** (= §2 절차 1·2·3 이행 · ★판정 = **동의어 아님** · 갈림 축 = 「낡았을 때 고쳐야 하는가」 · 빈도 실측 표 + 계수 과대 표시 주의 병기) + **본 이력 절 신설** (= `rule-footer-common.md:10` 자기 적용 — 본 판이 이 file 에 절을 **신설**하므로 등재 의무가 **본 판 자신에게** 걸린다). 4-repo propagation = **별 판**(Coin 소관 · §4.3).
