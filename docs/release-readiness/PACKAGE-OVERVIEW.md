# 패키지 출시 거시 현황 — 6-repo (master + app-foundation + 자식 3 + product-docs)

> **수기 갱신 SoT · 자동 생성 아님.** 본 문서는 사람이 직접 손보는 거시 출시 현황판이다. 박제 시점 = 2026-06-02 (`MASTER-CLI-PACKAGE-OVERVIEW-HYBRID-REFRESH-001`) · 6-repo 정합 2026-06-06 (`MASTER-PACKAGE-OVERVIEW-6REPO-001`). HEAD sha · 보호 파일 sha 처럼 자주 바뀌는 값은 여기에 박지 않고 live baseline 으로 가리킨다 (§1 · §2 의 pointer). 본 문서 갱신 trigger = §6.
>
> **구성 (6-repo)**:
> - `claude-cli-master` — cli infra + 보호 파일 + 거시 propagation 의 단일 진실 (master)
> - `app-foundation` — 공유 KMP/CMP foundation (`shared/*` + `core/*`) · 2026-05-11 신설 마감 · 자식 3 의 import source
> - `GentlyBreath` / `GentlyDay` / `GentlyTable` — 도메인 자식 (호흡 / 일상 / 식단)
> - `gently-product-docs` — 공통 제품 기획·비전 문서 (`docs/PRODUCT-VISION-SOT.md` + `docs/PRODUCT-PRINCIPLES-SOT.md` + `docs/PRODUCT-STRATEGY-SOT.md` = 자식 3 공통 상위 헌법 위계 · `docs/OKR.md` = live 분기 운영 층) · 도메인 코드 X · 빌드 X · 출시 산출물 X · master 단방향 cli infra propagation 대상 (2026-06-06 신설 · `MASTER-PRODUCT-DOCS-REPO-001`)
>
> **제품/출시 판단 선행 정독** (pointer · 본문은 PDOCS 단일 SoT · 복제 금지): 비전 SoT(왜 만드나) `../../../gently-product-docs/docs/PRODUCT-VISION-SOT.md` → 원칙 SoT(충돌 판정 규칙) `../../../gently-product-docs/docs/PRODUCT-PRINCIPLES-SOT.md` → 전략 SoT(어떻게 이기나) `../../../gently-product-docs/docs/PRODUCT-STRATEGY-SOT.md`. 충돌 시 상위 우선. 분기 OKR(전략 하위 live 운영 층) = `../../../gently-product-docs/docs/OKR.md`.

---

## 1. baseline + progress

### 1.1 repo HEAD — live baseline pointer (수기 박제 안 함)

현재 각 repo HEAD 는 본 문서에 적어 두지 않는다. 진입 시점 실측값을 아래에서 읽는다:

| 위치 | 담는 내용 | 재생성 |
|---|---|---|
| 세션 진입 hook `instructions-loaded-baseline-verify.sh` | 진입 즉시 5-repo(빌드·코드 repo) HEAD + 보호 5 sha 를 live 로 표면화 (가장 신선) | InstructionsLoaded 자동 |
| `.ai/baseline-snapshot/latest.json` | 5-repo(빌드·코드 repo) HEAD + cycle-discipline sha + settings sha + 보호 5 sha (세션마다 재생성) | `.claude/hooks/baseline-snapshot.sh` |
| `.ai/nightly-baseline/latest.md` | 6-repo HEAD + 보호 5 sha 매트릭스 + cli infra drift 집계 (야간 cron) | `bash scripts/nightly-baseline-report.sh` |

> 신선도 주의: snapshot = 세션 단위 / nightly = 하루 1회. 둘 다 intra-day lag 가능하다. 진입 직후 정확한 값이 필요하면 세션 hook 표면화 또는 `git rev-parse HEAD` 직접 측정이 가장 앞선다.
>
> repo 범위 주의: per-session 표면화(진입 hook + snapshot)는 빌드·코드 repo 5종(master + app-foundation + 자식 3)만 HEAD 를 surface 한다. `gently-product-docs`(빌드·도메인 코드 X · 제품 문서 전용)는 nightly(6-repo) + `verify-sync.sh`(6-repo)가 cli infra/보호 sha drift 를 커버한다.

### 1.2 progress roadmap (수기 판단 영역)

**master — bootstrap 마감 → 정상 운영.** 초기 critical path (app-foundation 신설 → propagation 5-repo 확장 → repo-config SoT → architecture-foundation link → release-checklist template) 는 2026-05-11~12 에 끝났다. 그 뒤로 master 는 cli infra 를 다듬는 named cycle 을 이어 가는 정상 운영 단계다. 그 named cycle 중 하나로 2026-06-06 제품 비전·전략 문서 전용 repo `gently-product-docs` 가 신설돼 propagation 대상이 5→6-repo 로 확장됐다 (`MASTER-PRODUCT-DOCS-REPO-001` · 빌드·도메인 코드 없음). 진행 이력의 live 원장 = `CLAUDE.md §15` (최근분 hot) + `.auto-memory/master-cycle-history-COLD.md` (전체 누적).

**자식 출시 현황.** 각 자식의 출시 진척은 그 repo 가 직접 보유한 `docs/release-readiness/INITIATIVES.md` 가 단일 진실이다. 본 master 문서는 그 수치를 복제하지 않는다 — 복제가 곧 staleness 재발원이기 때문이다.

| repo | 역할 | 출시 진척 단일 진실 |
|---|---|---|
| claude-cli-master | cli infra master | `CLAUDE.md §15` (master cycle 원장) |
| app-foundation | 공유 foundation | 별도 출시 도메인 없음 (자식 import source) |
| GentlyBreath | 호흡 도메인 | `GentlyBreath/docs/release-readiness/INITIATIVES.md` |
| GentlyDay | 일상 도메인 | `GentlyDay/docs/release-readiness/INITIATIVES.md` |
| GentlyTable | 식단 도메인 | `GentlyTable/docs/release-readiness/INITIATIVES.md` |
| gently-product-docs | 공통 제품 기획·비전 문서 | 출시 도메인 없음 · 본문 = `gently-product-docs/docs/PRODUCT-VISION-SOT.md` + `PRODUCT-PRINCIPLES-SOT.md` + `PRODUCT-STRATEGY-SOT.md` + `OKR.md` |

---

## 2. 보호 파일 5 종 — live baseline pointer (수기 sha 박제 안 함)

보호 파일 5 종은 6-repo byte-identical 강제 대상이다 (master 단일 source ↔ 5 propagation target · `verify-sync.sh` 가 gently-product-docs 포함 enumeration). 현재 sha 값은 본 문서에 박지 않고 아래를 가리킨다:

| 위치 | 담는 내용 |
|---|---|
| `.auto-memory/protected-file-hashes.md` | 보호 5종 sha-256 authoritative 기록 (master-only) + algorithm 분기 설명 |
| `CLAUDE.md §14a` | 보호 5종 git-sha1 (40 char) cycle baseline |
| `.ai/nightly-baseline/latest.md §3` | 6-repo × 보호 5종 정합 매트릭스 + drift 집계 |
| `.ai/baseline-snapshot/latest.json` | 보호 5종 sha-256 (runtime enforce · 빌드·코드 repo 5종) |

보호 5종 목록: `docs/schemas/ui-spec.schema.json` · `docs/rules/uiux-sot-refresh.md` · `docs/design/design-sot-policy.md` · `docs/rules/pencil-uiux-workflow.md` · `docs/design/pencil-sot-policy.md`.

drift 검증: `bash scripts/verify-sync.sh` (master → 자식 byte-identical 비교 · exit 1 = drift).

> algorithm 주의: manifest 와 snapshot = sha-256 (64 char) / `CLAUDE.md §14a` = git-sha1 (40 char). 같은 파일의 두 값을 직접 비교하지 않는다 (`protected-file-hashes.md §CONVENTION`).

---

## 3. master 측 task

> 초기 bootstrap 원장(구 `MASTER-T01`~`MASTER-T09`)은 2026-05-12 시점의 거시 task 목록이었다. critical path(T01→T05)는 마감됐고 이후 master 작업은 named cli-infra cycle 로 전환됐다. 진행 중 작업의 live 원장 = `CLAUDE.md §15`. 아래는 구 원장의 마감 / 이관 정리다 (disk 실측 기준).

| 구 ID | 항목 | 현 상태 |
|---|---|---|
| MASTER-T01 | app-foundation repo 신설 | ✓ 마감 (`MASTER-APP-FOUNDATION-SCAFFOLD-001` · 2026-05-11) |
| MASTER-T02 | propagate / verify-sync 5-repo 확장 | ✓ 마감 (동 cycle) |
| MASTER-T03 | release-checklist.template.md 신설 | ✓ 마감 — `docs/templates/release-checklist.template.md` 실재 |
| MASTER-T04 | 13 architecture → foundation link | ✓ 마감 (`MASTER-ARCHITECTURE-FOUNDATION-LINK-001`) |
| MASTER-T05 | repo-config.sh PROTECTED_FILES / CHILD_REPOS | ✓ 마감 (`MASTER-REPO-CONFIG-SOT-001`) |
| MASTER-T06 | baseline-mismatch mitigation hook | ✓ 흡수 — `baseline-snapshot.sh` + `instructions-loaded-baseline-verify.sh` 실재 + anchor A1(baseline drift detection) 정착 |
| MASTER-T07 | initiatives.template.md 신설 | ☐ 미신설 (P2 lazy) — 단 자식 3 은 INITIATIVES.md 를 템플릿 없이 이미 직접 운영 중 |
| MASTER-T08 | foundation-fork.template.md (신규 앱 fork) | ☐ 미신설 (P2 lazy) — 미래 앱 신설 trigger 시 |
| MASTER-T09 | text degeneration mitigation 정책 + hook | ✓ 마감 (`MASTER-DEGENERATION-PREVENTION-POLICY-001`) |

이후 진행분(RULE-ARCH 4-phase · CONTEXT-OPT 4-phase · KTLINT-WARN-GATE · POSTCYCLE-AUTOMATION · TESTING-STRATEGY · GSM-MEASUREMENT · DEPENDENCY-DECISION · PRODUCT-DOCS-REPO(6-repo 확장) · STRATEGY-ROUTING 등)은 `CLAUDE.md §15` + cold 이력을 본다.

---

## 4. propagation matrix (자식 영향도 · 6-repo)

| 변경 영역 | 영향 repo | propagation 방식 |
|---|---|---|
| 보호 파일 5종 sha 변동 | 6-repo 전체 | `propagate.sh` byte-identical cp + `verify-sync.sh` |
| cli infra (`.claude/` + scripts propagation 도구 등) | 권장 byte-identical (6-repo) | `propagate.sh` · drift 시 mitigation cycle |
| 13 architecture 문서 | 자식 reading order | 자식 CLAUDE.md link 검증 |
| app-foundation feature 마감 | 자식 INITIATIVES 의존 task unblock | 자식 INITIATIVES §3 검증 |
| 자식 도메인 코드 | 자기 repo 한정 | propagation 없음 |
| 제품 비전·원칙·전략 SoT + OKR 본문 (`gently-product-docs/docs/`) | gently-product-docs 한정 | master 무관 (PDOCS 자체 보유 본문 · cli infra 아님 = propagation 대상 X) |
| `release-readiness/` (본 문서 · 자식 INITIATIVES) | repo-specific | propagation 대상 제외 (master-only / 자식-local) |

> 단방향 원칙: cli infra 는 master 단일 source. 자식 직접 수정 금지 (`CLAUDE.md §3·§4`).

---

## 5. kill-switch 게이트

| 게이트 | 트리거 | 행동 |
|---|---|---|
| critical path 정체 ≥ 7 일 | master named cycle 또는 자식 P0 task 정체 | 별 cycle 신설 + 의존 재검토 |
| 보호 파일 drift | `verify-sync.sh` exit 1 | 즉시 mitigation cycle (자식 byte-identical 복구) |
| 자식 P0 progress 정체 (2 주간 0% 증가) | 자식 INITIATIVES §1 | scope 축소 또는 외부 의뢰 결정 cycle |
| 자식 cli infra drift | master 측 sha 불일치 (`CLAUDE.md §5` STOP #6) | master 정정 cycle |

> 구 게이트 "COWORK-PREP-BASELINE-MISMATCH ≥ 15회" 는 baseline 자동 표면화 hook(`instructions-loaded-baseline-verify.sh` + `baseline-snapshot.sh`)과 anchor A1 정착으로 해소됐다. 재발 시 hook enforce mode 승격으로 대응.

---

## 6. 갱신 trigger

| trigger | 행동 |
|---|---|
| 자식 cycle REVIEW PASS | 자식 INITIATIVES 갱신 (자식-local · `initiatives-auto-sync` skill) — 본 master 문서는 자식 수치를 복제하지 않으므로 무변경 |
| 보호 파일 sha 변동 | `protected-file-hashes.md` + `CLAUDE.md §14a` resync + propagation cycle (§2 pointer 가 자동 추종) |
| app-foundation feature 마감 | 자식 INITIATIVES COMMON-SETUP 인용 검증 |
| master cycle 마감 | `CLAUDE.md §15` entry append (§3 은 §15 를 가리킴 — 본 문서 무변경) |
| 본 문서 framing / 구조 변경 | master cycle 신설 + 본 문서 직접 갱신 + 상단 박제 시점 갱신 |

---

## 7. 한계 / 모름

- foundation propagation 메커니즘 = cp byte-identical 로 확정 (app-foundation 신설 + propagate.sh 5-repo 확장 마감). submodule / Maven publish 는 미채택.
- iOS 빌드 활성화 시점 = 자식 결정 (foundation `iosApp/` scaffold 후). 현 baseline = Android staging flavor 단일.
- 출시 마감일 = 미명시 (사용자 영역) → critical path 정체 7 일 = kill-switch 트리거 (§5).
- 자식 도메인 task ID `<repo>-T<NN>` = Cowork 추천 명명. 사용자 변경 시 일괄 치환 cycle.
- app-foundation 은 별도 INITIATIVES 가 없다 (공유 infra · 자식 import source 역할). 출시 도메인은 자식 3 만 보유.
