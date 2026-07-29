# 패키지 출시 거시 현황 — 4-active + 3 동결 계승 원천

> **수기 갱신 SoT · 자동 생성 아님.** 사람이 직접 손보는 거시 출시 현황판. HEAD sha · 보호 파일 sha 처럼 자주 바뀌는 값은 여기에 박지 않고 live baseline 으로 가리킨다 (§1 · §2 의 pointer). 갱신 trigger = §6.
> **현행 박제 시점** = 2026-07-29 (`MASTER-CLI-CONTEXT-DIET-3-001` · T6/T7 재편 반영). 직전 = 2026-06-06 (`MASTER-PACKAGE-OVERVIEW-6REPO-001`) · 최초 hybrid refresh = 2026-06-02 (`MASTER-CLI-PACKAGE-OVERVIEW-HYBRID-REFRESH-001`).

> ## ⚠ 본 문서 편집 규칙 — 역사 층과 현행 층을 구분한다
>
> 본 문서는 **현행 형상 서술**과 **지나간 사실 서술**을 동시에 담는다. 이 둘은 **다르게 취급한다**:
>
> - **현행 층** (= §1 구성 · §2 · §4 · §7 등 "지금 어떤가") — 형상이 바뀌면 **갱신 대상**.
> - **역사 층** (= §3 구 원장 · 아래 §0.1 확장 이력 · 마감된 cycle 서술) — **지나간 시점의 사실**. 형상이 바뀌어도 **그대로 둔다**. `5-repo`·`6-repo`·`자식 3(GB/GD/GT)` 같은 표현이 역사 층에 있으면 그것은 stale 이 **아니라 사실 기록**이다.
>
> **근거 (실사고)**: 2026-07-29 `MASTER-CLI-STALE-SWEEP-4ACTIVE-001` 에서 topology 어휘 일괄 스윕이 본 문서의 **역사 서술까지 4-repo 로 덮어써** "2026-06-06 에 5→6-repo 로 확장됐다"는 참인 기록을 훼손했다 → 그 cycle 안에서 **wholesale revert** 로 복구. 일괄 치환 도구를 본 문서에 그대로 걸지 않는다 (= 층 판별 후 현행 층만).

---

## 0. 형상

### 0.1 현행 (= 2026-07-17 T6/T7 재편)

**4-active** (= cli infra byte-identical 형상 · master 단방향 propagation):

- `claude-cli-master` — cli infra + 보호 파일 + 거시 propagation 의 단일 진실 (master)
- `app-foundation` (FND) — 공유 KMP/CMP foundation (gradle 모듈 9 = `core:*` 8 + `shared:domain` 1) · 활성 도메인 자식의 import source · 모듈/소비 계약 상세 = `app-foundation/CLAUDE.md §0.2`
- `gently-product-docs` (PDOCS) — 공통 제품 기획·비전 문서 · 도메인 코드 X · 빌드 X · 출시 산출물 X
- `Selfward` (SW) — **활성 도메인 자식 단일** · 앱 「나에게로」 `com.gently.selfward` · **1 앱 N 도메인** (구 GB+GD+GT 3 도메인 흡수 계승)

**3 동결 계승 원천** (= 전파 대상 제거 · 원본 보존 · **쓰기 0**): `GentlyBreath` / `GentlyDay` / `GentlyTable`. repo 삭제 X · GitHub archive 보류(Coin 콘솔 몫) · cli session 은 read-only 인용만 (쓰기 필요 = STOP).

**제품/출시 판단 선행 정독** (pointer · 본문은 PDOCS 단일 SoT · 복제 금지): 비전 SoT(왜 만드나) `../../../gently-product-docs/docs/PRODUCT-VISION-SOT.md` → 원칙 SoT(충돌 판정 규칙) `../../../gently-product-docs/docs/PRODUCT-PRINCIPLES-SOT.md` → 전략 SoT(어떻게 이기나) `../../../gently-product-docs/docs/PRODUCT-STRATEGY-SOT.md`. 충돌 시 상위 우선. 분기 OKR(전략 하위 live 운영 층) = `../../../gently-product-docs/docs/OKR.md`.

### 0.2 확장 이력 (= **역사 층 · 갱신 대상 아님**)

| 시점 | 사건 | cycle |
|---|---|---|
| 2026-05-11 | `app-foundation` 신설 → propagation **4-repo → 5-repo** 확장 | `MASTER-APP-FOUNDATION-SCAFFOLD-001` |
| 2026-06-06 | `gently-product-docs` 신설 → propagation **5-repo → 6-repo** 확장 (빌드·도메인 코드 없음) | `MASTER-PRODUCT-DOCS-REPO-001` |
| 2026-07-17 | `Selfward` propagation 편입 (6번째 target) | `MASTER-SELFWARD-CLAUDE-PARITY-001` |
| 2026-07-17 | **GB/GD/GT 를 전파 대상에서 제거** → 형상 **6-repo → 4-active + 3 동결** · 3 도메인 = Selfward 흡수 계승 | `MASTER-T6-REPO-REALIGN-001` + `MASTER-T7-INSTRUCTIONS-REALIGN-001` |

위 행의 `4-repo`/`5-repo`/`6-repo` 표기는 **그 시점의 사실**이다. 현행 형상(§0.1)과 다르다고 고치지 않는다.

---

## 1. baseline + progress

### 1.1 repo HEAD — live baseline pointer (수기 박제 안 함)

현재 각 repo HEAD 는 본 문서에 적어 두지 않는다. 진입 시점 실측값을 아래에서 읽는다:

| 위치 | 담는 내용 | 재생성 |
|---|---|---|
| 세션 진입 hook `instructions-loaded-baseline-verify.sh` | 진입 즉시 **4-active** HEAD + 보호 sha 를 live 로 표면화 (가장 신선) | InstructionsLoaded 자동 |
| `.ai/baseline-snapshot/latest.json` | **4-active** HEAD + cycle-discipline sha + settings sha + 보호 sha · **동결 3 = HEAD 만 관찰 기록**(쓰기 0 위반 감지용 · parity 비교 대상 X) | `.claude/hooks/baseline-snapshot.sh` |
| `.ai/nightly-baseline/latest.md` | HEAD + 보호 sha 매트릭스 + cli infra drift 집계 (야간) | `bash scripts/nightly-baseline-report.sh` |

> 신선도 주의: snapshot = 세션 단위 / nightly = 하루 1회. 둘 다 intra-day lag 가능. 진입 직후 정확한 값이 필요하면 세션 hook 표면화 또는 `git rev-parse HEAD` 직접 측정이 가장 앞선다.
>
> **동결 3 을 parity 대상에서 뺀 이유** (2026-07-29 실측): 동결 3 의 `cycle-discipline.md` 는 T6 시점에 고정돼 있어 4-active 와 sha 가 다르다 → 비교하면 **영구 false DRIFT** 를 낳는다. 그래서 HEAD 만 관찰한다.

### 1.2 progress roadmap (수기 판단 영역)

**master — bootstrap 마감 → 정상 운영.** 초기 critical path (app-foundation 신설 → propagation 확장 → repo-config SoT → architecture-foundation link → release-checklist template) 는 2026-05-11~12 에 끝났다. 그 뒤 master 는 cli infra 를 다듬는 named cycle 을 이어 가는 정상 운영 단계다 (확장 이력 = §0.2). 진행 이력의 live 원장 = `CLAUDE.md §15` (최근 3 hot · **상한 규약**) + `.auto-memory/master-cycle-history-COLD.md` (전체 누적).

**자식 출시 현황.** 출시 진척은 그 repo 가 직접 보유한 `docs/release-readiness/INITIATIVES.md` 가 단일 진실이다. 본 문서는 그 수치를 복제하지 않는다 — 복제가 곧 staleness 재발원이기 때문이다.

| repo | 역할 | 출시 진척 단일 진실 |
|---|---|---|
| claude-cli-master | cli infra master | `CLAUDE.md §15` (master cycle 원장) |
| app-foundation | 공유 foundation | 별도 출시 도메인 없음 (import source) |
| gently-product-docs | 공통 제품 기획·비전 문서 | 출시 도메인 없음 · 본문 = PDOCS `docs/` 4 SoT |
| **Selfward** | **활성 도메인 자식 단일** (1 앱 N 도메인) | `Selfward/docs/release-readiness/INITIATIVES.md` |
| GentlyBreath / GentlyDay / GentlyTable | **동결 계승 원천** | 출시 진행 없음 (동결 · 쓰기 0) · 구 INITIATIVES = 이력 인용만 |

---

## 2. 보호 파일 — live baseline pointer (수기 sha 박제 안 함)

보호 파일은 **4-repo byte-identical 강제** 대상이다 (master 단일 source ↔ propagation target 3). 현재 sha 값은 본 문서에 박지 않고 아래를 가리킨다:

| 위치 | 담는 내용 |
|---|---|
| `.auto-memory/protected-file-hashes.md` | **보호 file sha-256 authoritative 기록 (= 건수 판정의 유일 기준)** + algorithm 분기 설명 (master-only) |
| `CLAUDE.md §14a` | 보호 file git-sha1 (40 char) cycle baseline |
| `.ai/nightly-baseline/latest.md §3` | repo × 보호 file 정합 매트릭스 + drift 집계 |
| `.ai/baseline-snapshot/latest.json` | 보호 file sha-256 (runtime enforce · 4-active) |

현행 보호 목록 (**5 종** · 건수는 manifest 실측이 기준 — 기억 단정 금지): `docs/schemas/ui-spec.schema.json` · `docs/rules/uiux-sot-refresh.md` · `docs/design/design-sot-policy.md` · `docs/rules/pencil-uiux-workflow.md` · `docs/design/pencil-sot-policy.md`.

drift 검증: `bash scripts/verify-sync.sh` (master → 자식 byte-identical 비교 · exit 1 = drift).

> algorithm 주의: manifest 와 snapshot = sha-256 (64 char) / `CLAUDE.md §14a` = git-sha1 (40 char). 같은 파일의 두 값을 직접 비교하지 않는다 (`protected-file-hashes.md §CONVENTION`).

---

## 3. master 측 구 task 원장 (= **역사 층 · 갱신 대상 아님**)

> 초기 bootstrap 원장(구 `MASTER-T01`~`MASTER-T09`)은 **2026-05-12 시점의** 거시 task 목록이었다. critical path(T01→T05)는 마감됐고 이후 master 작업은 named cli-infra cycle 로 전환됐다. 진행 중 작업의 live 원장 = `CLAUDE.md §15`. 아래는 구 원장의 마감 / 이관 정리다 (당시 disk 실측 기준 · **당시 표기 그대로 보존**).

| 구 ID | 항목 | 현 상태 |
|---|---|---|
| MASTER-T01 | app-foundation repo 신설 | ✓ 마감 (`MASTER-APP-FOUNDATION-SCAFFOLD-001` · 2026-05-11) |
| MASTER-T02 | propagate / verify-sync 5-repo 확장 | ✓ 마감 (동 cycle) |
| MASTER-T03 | release-checklist.template.md 신설 | ✓ 마감 — `docs/templates/release-checklist.template.md` 실재 |
| MASTER-T04 | 13 architecture → foundation link | ✓ 마감 (`MASTER-ARCHITECTURE-FOUNDATION-LINK-001`) |
| MASTER-T05 | repo-config.sh PROTECTED_FILES / CHILD_REPOS | ✓ 마감 (`MASTER-REPO-CONFIG-SOT-001`) |
| MASTER-T06 | baseline-mismatch mitigation hook | ✓ 흡수 — `baseline-snapshot.sh` + `instructions-loaded-baseline-verify.sh` 실재 + anchor A1(baseline drift detection) 정착 |
| MASTER-T07 | initiatives.template.md 신설 | ☐ 미신설 (P2 lazy) — 단 자식은 INITIATIVES.md 를 템플릿 없이 이미 직접 운영 중 |
| MASTER-T08 | foundation-fork.template.md (신규 앱 fork) | ☐ 미신설 (P2 lazy) — 미래 앱 신설 trigger 시 |
| MASTER-T09 | text degeneration mitigation 정책 + hook | ✓ 마감 (`MASTER-DEGENERATION-PREVENTION-POLICY-001`) → **2026-07-29 폐지** (`MASTER-CLI-JUDGMENT-SHIFT-001` · 구형 모델 전제 장치 → 판단 위임 · 원문 = `.auto-memory/text-degeneration-prevention-COLD.md`) |

이후 진행분(RULE-ARCH 4-phase · CONTEXT-OPT 4-phase · KTLINT-WARN-GATE · POSTCYCLE-AUTOMATION · TESTING-STRATEGY · GSM-MEASUREMENT · DEPENDENCY-DECISION · PRODUCT-DOCS-REPO · STRATEGY-ROUTING · T6/T7 재편 · CONTEXT-DIET 1~3 등)은 `CLAUDE.md §15` + cold 이력을 본다.

---

## 4. propagation matrix (자식 영향도 · 4-repo)

| 변경 영역 | 영향 repo | propagation 방식 |
|---|---|---|
| 보호 파일 sha 변동 | 4-active 전체 | `propagate.sh` byte-identical cp + `verify-sync.sh` |
| cli infra (`.claude/` + `docs/rules/` + scripts propagation 도구 등) | 권장 byte-identical (4-repo) | `propagate.sh` · drift 시 mitigation cycle |
| architecture 문서 | 자식 reading order | 자식 CLAUDE.md link 검증 |
| app-foundation feature 마감 | 자식 INITIATIVES 의존 task unblock | 자식 INITIATIVES §3 검증 |
| 자식 도메인 코드 | 자기 repo 한정 | propagation 없음 |
| 제품 비전·원칙·전략 SoT + OKR 본문 (`gently-product-docs/docs/`) | PDOCS 한정 | master 무관 (PDOCS 자체 보유 본문 · cli infra 아님 = propagation 대상 X) |
| `release-readiness/` (본 문서 · 자식 INITIATIVES) | repo-specific | propagation 대상 제외 (master-only / 자식-local) |
| **동결 3 (GB/GD/GT)** | — | **전파 대상 X · 쓰기 0** (= 계승 원천 원본 보존) |

> 단방향 원칙: cli infra 는 master 단일 source. 자식 직접 수정 금지 (`CLAUDE.md §3·§4`).

---

## 5. kill-switch 게이트

| 게이트 | 트리거 | 행동 |
|---|---|---|
| critical path 정체 ≥ 7 일 | master named cycle 또는 자식 P0 task 정체 | 별 cycle 신설 + 의존 재검토 |
| 보호 파일 drift | `verify-sync.sh` exit 1 | 즉시 mitigation cycle (자식 byte-identical 복구) |
| 자식 P0 progress 정체 (2 주간 0% 증가) | 자식 INITIATIVES §1 | scope 축소 또는 외부 의뢰 결정 cycle |
| 자식 cli infra drift | master 측 sha 불일치 (STOP #6 · `.claude/rules/stop-canonical.md`) | master 정정 cycle |
| **동결 3 쓰기 시도** | baseline-snapshot 의 동결 HEAD 관찰값 변동 | 즉시 STOP + Coin 회수 (= 쓰기 0 위반) |

> 구 게이트 "COWORK-PREP-BASELINE-MISMATCH ≥ 15회" 는 baseline 자동 표면화 hook(`instructions-loaded-baseline-verify.sh` + `baseline-snapshot.sh`)과 anchor A1 정착으로 해소됐다. 재발 시 hook enforce mode 승격으로 대응.

---

## 6. 갱신 trigger

| trigger | 행동 |
|---|---|
| 자식 cycle REVIEW PASS | 자식 INITIATIVES 갱신 (자식-local · `initiatives-sync` skill) — 본 문서는 자식 수치를 복제하지 않으므로 무변경 |
| 보호 파일 sha 변동 | `protected-file-hashes.md` + `CLAUDE.md §14a` resync + propagation cycle (§2 pointer 가 자동 추종) |
| app-foundation feature 마감 | 자식 INITIATIVES COMMON-SETUP 인용 검증 |
| master cycle 마감 | `CLAUDE.md §15` entry append (§1.2 는 §15 를 가리킴 — 본 문서 무변경) |
| **repo 형상 변경** (신설 / 동결 / 전파 대상 변동) | §0.1 현행 층 갱신 + **§0.2 에 이력 행 append** (= 구 형상 서술 덮어쓰기 금지) |
| 본 문서 framing / 구조 변경 | master cycle 신설 + 본 문서 직접 갱신 + 상단 박제 시점 갱신 |

---

## 7. 한계 / 모름

- foundation propagation 메커니즘 = cp byte-identical 로 확정. submodule / Maven publish 는 미채택. **FND 는 아무것도 publish 하지 않는다** — `com.gently.foundation:*` 좌표는 소비자 `settings.gradle.kts` 의 substitution 안에만 존재하는 가상 좌표다 (= FND 단독 빌드로는 소비 계약 회귀가 안 잡힌다 · `app-foundation/CLAUDE.md §0.2 G1`).
- iOS 빌드 활성화 시점 = 자식 결정. 현 baseline = Android staging flavor 단일.
- 출시 마감일 = 미명시 (사용자 영역) → critical path 정체 7 일 = kill-switch 트리거 (§5).
- app-foundation · gently-product-docs 는 별도 INITIATIVES 가 없다 (공유 infra / 문서 전용). 출시 도메인 보유 = **Selfward 단독**.
- 동결 3 의 GitHub archive 실행 여부 = Coin 콘솔 몫 (= 본 문서 추적 대상 X).
