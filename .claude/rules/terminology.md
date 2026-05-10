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
| 5 | 도구 바인딩 | 디자인 도구의 구체 절차 | `docs/design/pencil-sot-policy.md` (의미 = pencil-sot-binding) + `.claude/rules/pencil-uiux-workflow.md` |
| 6 | refresh baseline | 런타임 → SoT 비교 기준의 현재 baseline | `.claude/rules/uiux-sot-refresh.md` + `.ai/uiux-sot/latest/` |
| 7 | 화면명 매핑 | SoT 화면명 ↔ Compose 코드 화면명 매핑 | `.claude/rules/sot-code-name-map.md` |
| 8 | 도메인 정책 SSoT (분산) | 각 도메인 정책의 단일 출처 | `auth-rules.md` (인증) · `allowed-acronyms.md` (허용 약어) · `working-file-lifecycle.md` (working file) · `cycle-discipline.md` (cycle) · `verification-and-review.md` (검증) · `routing-and-delegation.md` (agent) · `ux-laws.md` (UX) · `data-model.md` / `api-spec.md` / `billing.md` (자식 도메인) |

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
4. 4-repo propagation (`scripts/propagate.sh .claude/rules/terminology.md --targets all`)
5. `verify-sync.sh` PASS 확인

---

## 3. 본 file 의 변경 정책

본 file = cli infra 권장 byte-identical (4-repo).
변경 시 master cycle 신설 + 4-repo propagation 의무 (`cycle-discipline.md` §15 패턴 1).
