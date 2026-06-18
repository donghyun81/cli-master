# Design SoT Refresh Rules (도구 무관)

> **단일 목적**: `.ai/uiux-sot/latest/` baseline refresh 의 도구 무관 일반 규칙 — Package Boundary / Trigger 분류 / Read Order / Output / Status / STOP.
> **C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 generic 화** (Q2 답 추가 · 95% 공통화 · Pencil 인용 → `<design-tool>` placeholder).
> **본 파일 = 보호 (강제 byte-identical)**.
> **연관 파일**:
> - `design-to-code-sync.md` — Design SoT → Code 단방향 sync 일반 패턴
> - `design-sot-policy.md` (보호) — dual-layer SoT 정책
> - 도구 바인딩: `pencil-uiux-workflow.md` (Pencil) / `figma-uiux-workflow.md` (향후)
> SOT: `CLAUDE.md`

> **파일명 변경 의무 (C2.5)**: 본 파일은 의미적으로 `design-sot-refresh.md` 이지만 Coin rm 권한 한계로 파일명은 `uiux-sot-refresh.md` 유지 (cycle-discipline 호환성). 의미 = design-sot-refresh.

---

## Package Boundary

- `.ai/reports/` 는 task report 전용 역할을 유지한다.
- UI/UX baseline companion SoT는 `.ai/uiux-sot/` 아래에 둔다.
- `semantic/` 은 해석층이고 `latest/` 는 evidence layer다.
- `latest/` 만 current baseline으로 취급한다.
- ~~`lineage/` 는 historical reference only다.~~ **(폐기 · MASTER-CLI-COMPOUND-LINT-DEPRECATE-001)** — :27 lineage 계약 조항 폐기(MASTER-CLI-PROTECTED-STALE-PATH-FIX-001)의 연장 (`.ai/uiux-sot/lineage/` 6-repo 전수 부재 · historical reference 추적 = git diff/commit 갈음).

## Seed Handling Policy

- seed PNG/XML/route/state를 `latest/` 로 복사해 baseline으로 삼지 않는다.
- ~~seed와 latest의 연결은 `.ai/uiux-sot/lineage/seed_audit_reference.md` 로만 유지한다.~~ **(폐기 · MASTER-CLI-PROTECTED-STALE-PATH-FIX-001)** — lineage 계약 조항 폐기 (`.ai/uiux-sot/lineage/` 6-repo 전수 부재 · 이행 0회). seed↔latest 연결 추적 = git diff/commit 갈음 (= Latest-Only Policy 정합).

## Latest-Only Policy

- refresh 시 기존 `latest/` 산출물은 새 기준선으로 교체한다.
- package 내부 snapshot/history 누적은 금지한다.
- baseline history는 git branch/commit diff로 추적한다.

## Refresh Trigger Classification

- `FULL`: navigation, shell, route, visible state 변경
- `PARTIAL`: copy, icon, layout, resource 변경
- `DOC-ONLY`: package 문서, manifest, workflow, rule, skill sync only

세부 경로 규칙은 `.ai/uiux-sot/refresh/TRIGGERS.md` 를 따른다.

### 즉시 의무 vs Deferred (design-debt) 분기 (신규성 × 출시 상태)

FULL/PARTIAL trigger 가 곧 "선행 .pen/latest refresh 의무"는 아니다. 분기:

| 변경 분류 | 즉시 의무 (선행/동반 refresh) | Deferred (design-debt 허용) |
|---|---|---|
| net-new visual (신규 화면 / navigation·route 구조 / net-new 시각 컴포넌트·시각 상태) | ✅ 출시 후 엄격 | ⚠ 미출시(user 0) 한정 · DESIGN-DEBT 등재 시 |
| reuse visual (기존 화면 + 기존 디자인시스템 컴포넌트 재사용 visible state 추가) | — | ✅ DESIGN-DEBT 등재 시 |
| PARTIAL (copy / icon / resource) | — | ✅ 경량 등재 |
| DOC-ONLY (순수 functional wiring · 무시각 · 문서/rule/manifest) | refresh 불요 | — |

- net-new visual = 새 시각 언어. 출시 후 = 선행 의무 / 미출시(user 0) = DESIGN-DEBT 등재 시 deferred 허용.
- deferred = "조용한 skip" 아님 → `DESIGN-DEBT.md` 등재 의무 (`design-to-code-sync.md` "Deferred Design Debt lane"). 미등재 deferred = REVIEW [Design SoT Sync] WARN.
- 출시 backstop: 출시 대상 화면의 DESIGN-DEBT 미해소(OPEN) = release 게이트 FAIL.

### Design SoT 경로 트리거 (도구 무관)

`<design-tool>` = pencil / figma / sketch 등. 자식 repo 의 도구 바인딩 파일에서 구체화.

- `docs/design/<design-tool>-sot/**/*.<visual-ext>` 수정 → **FULL** (원본 Visual SoT 변경) + `.ai/uiux-sot/latest/` refresh 필수
- `docs/design/<design-tool>-sot/**/*.ui-spec.json` 수정 → **FULL** (Structural SoT 변경 · lifecycle 전이 포함 가능) + `.ai/uiux-sot/latest/` refresh 필수
- `docs/design/<design-tool>-sot/**/*.ui-spec.json` 의 lifecycle 전이만 (active ↔ deprecated · frozen) → DOC-ONLY (논리 변경 · 파일 이동 무 · 운영 레이어 정합성 감사 대상)
- `docs/design/design-sot-policy.md` 수정 → DOC-ONLY (정책 문서만 · 운영 레이어 정합성 감사 대상)
- `docs/design/<design-tool>-dev-prompt.md` 수정 → FULL 또는 PARTIAL + `.ai/uiux-sot/latest/` refresh 필수
- `docs/design/<design-tool>-exports/**` 수정 → FULL + `.ai/uiux-sot/latest/` refresh 필수
- `docs/design/<design-tool>-exports/archive/**` 수정 → DOC-ONLY
- `docs/design/<design-tool>-sot/archive-pre-migration/**` 수정 → DOC-ONLY (디자인 도구 마이그레이션 아카이브)
- `.ai/uiux-sot/latest/**` 선행 갱신 없이 **그리고** DESIGN-DEBT.md 등재 없이 Compose / SwiftUI 의 visible-state(FULL) 변경 감지 → REVIEW [Design SoT Sync] **WARN** + DESIGN-DEBT 등재 의무. 출시 후 net-new visual = 선행 의무(미충족 → release 게이트 FAIL). 분기 = 위 "즉시 의무 vs Deferred" 표.

Design SoT trigger 감지 시 `.claude/rules/design-to-code-sync.md` 5-type 분류 + Output Checklist + 도구 바인딩 파일 (`pencil-uiux-workflow.md` 등) 의 구체 절차를 반드시 적용한다.

## Authoritative Read Order

> placeholder 토큰 표기. 각 토큰은 해당 repo 의 `scripts/repo-config.sh` 에서 export 된 변수로 매핑된다.
> 매핑 표와 사용법은 `.claude/commands/uiux-refresh.md` "Placeholder 토큰" 표 + `docs/agent/architecture/PROPAGATION_PARAMETERS.md` 참조.

0. UI 수정 의미를 해석할 때는 `.ai/uiux-sot/semantic/` 을 먼저 읽을 수 있다. 단, semantic layer는 runtime proof가 아니다.
1. `<APP_ROUTES>` ← `$REPO_APP_ROUTES`
2. `<APP_ROOT_COMPOSABLE>` ← `$REPO_APP_ROOT_COMPOSABLE`
3. `<APP_ROOT_STATE>` ← `$REPO_APP_ROOT_STATE`
4. relevant screen file
5. `<IOS_SHELL_VIEW>` ← `$REPO_IOS_SHELL_VIEW`, `<IOS_APP_CONTAINER>` ← `$REPO_IOS_APP_CONTAINER` (값이 비어 있으면 skip)

## Required Outputs

- screenshots PNG
- hierarchy XML
- route inventory
- screen state matrix
- manifest diff summary

runtime capture를 지금 만들 수 없으면:

- `latest/manifest.md`
- `latest/coverage_summary.md`
- `latest/route_inventory.md`
- `latest/screen_state_matrix.csv`
- `latest/README.md`

를 먼저 갱신하고 `status = BASELINE_PENDING_REFRESH` 를 유지한다.

## Status Vocabulary

- `RESOLVABLE_IN_REPO`
- `UNKNOWN`
- `BLOCKED`
- `STOP`

## Verify And Report

- 최소 1개 이상의 실제 명령을 실행한다.
- 보고 순서는 `[EVIDENCE] -> [DIFF] -> [LOG]` 다.
- recommended verify commands: `.ai/uiux-sot/refresh/VERIFY.md`

## STOP

- auth
- billing or money
- DB migration
- secret or PII exposure
- unexpected system state
