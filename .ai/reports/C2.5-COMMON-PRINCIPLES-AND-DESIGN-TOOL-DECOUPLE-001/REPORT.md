# C2.5 · COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE — Q1 + Q2 답

> 작성: 2026-05-02 · scope: master 의 SOLID 원칙 박음 + 도구 무관 vs Pencil 전용 분리

---

## 0. 거시 목적

Q1 (SOLID + 코드 리뷰 체크리스트 박음) + Q2 ("gently 전용" 6 항목 중 4 항목 분리) → master 가 Pencil 외 도구 + 다른 도메인 앱 신설 대비 완성.

---

## 1. Q1 답 — SOLID 박음

### 신설 `code-principles.md` (151 줄)

| 섹션 | 내용 |
|---|---|
| §1 SOLID 5 원칙 | SRP / OCP / LSP / ISP / DIP 각 정의 + 적용 예 + 위반 신호 |
| §2 보조 원칙 | DRY (3 곳 이상 시 추출) + KISS (직접 구현 우선) + YAGNI (외부 준비 연기) |
| §3 라이브러리 사용 최소화 | DependencyDecision 8 항목 + UI 라이브러리 억제 default |
| §4 코드 리뷰 체크리스트 | A 기능 정확성 / B SOLID + 보조 / C 아키텍쳐 정합 / D 의존성 / E 테스트 / F 안전성 / G cleanup |
| §5 위반 시 처리 | PASS / PARTIAL / FAIL 분류 + SOLID mitigation patterns |
| §6 변경 정책 | cli infra 권장 byte-identical |

reviewer agent (`.claude/agents/active/reviewer.md`) 가 REVIEW.md 작성 시 본 §4 체크리스트 자동 참조.

---

## 2. Q2 답 — 6 항목 재분류 결과

| 원래 분류 | C2.5 결과 |
|---|---|
| `pencil-uiux-workflow.md` (보호 · 446 줄) | **2 분할**: `design-to-code-sync.md` (cli infra 신설 · 70% 공통 · 103 줄) + `pencil-uiux-workflow.md` (보호 갱신 · 30% Pencil 도구 바인딩 · 112 줄) |
| `uiux-sot-refresh.md` (보호 · 98 줄) | **95% generic 화** (108 줄 · Pencil 인용 → `<design-tool>` placeholder · 본문 거의 그대로 유지) |
| `pencil-automation.md` | **유지** (gently 전용 명확 · 90% Pencil 도구 의존) |
| `pencil-auto-save.sh` + `save-as-result-check.sh` | **유지** (100% Pencil 도구 의존) |
| `pencil-sot-policy.md` (보호 · 129 줄) | **2 분할**: `design-sot-policy.md` (보호 신설 · 75% 공통 · 153 줄) + `pencil-sot-policy.md` (보호 갱신 · 의미 = pencil-sot-binding · 25% Pencil 바인딩 · 91 줄) — Coin git mv → `pencil-sot-binding.md` |
| `ui-spec.schema.json` (보호) | **generic 화 v0.3**: `designTool` enum (`pencil` / `figma` / `sketch` / `adobe-xd`) + `lastSyncedDesignToolStateHash` 신규 필드 + `lastSyncedPencilStateHash` deprecated alias |

### 분리 결과 — 도구 무관 vs Pencil 전용 매트릭스

| 영역 | 도구 무관 (master 가 SoT 보유) | Pencil 전용 (도구 바인딩) |
|---|---|---|
| Design SoT 정책 | `design-sot-policy.md` (보호 · §1~§8) | `pencil-sot-policy.md` (보호 · 의미 = `pencil-sot-binding.md`) |
| Design → Code sync | `design-to-code-sync.md` | `pencil-uiux-workflow.md` (보호) |
| SoT refresh | `uiux-sot-refresh.md` (보호 · 95% generic) | (도구별 trigger 키워드 = generic placeholder) |
| 자동화 hook | (도구 무관 hook 없음) | `pencil-auto-save.sh` v2 + `save-as-result-check.sh` |
| 자동화 rule | (도구 무관 rule 없음) | `pencil-automation.md` |
| schema | `ui-spec.schema.json` v0.3 (도구 무관 필드명) | (구 Pencil 명명 = v0.3 alias 유지 + deprecated 예고) |

### Figma / Sketch 도입 patterns (향후)

신규 도구 도입 시:
1. `<tool>-uiux-workflow.md` (보호) — `pencil-uiux-workflow.md` 와 동일 구조
2. `<tool>-automation.md` — `pencil-automation.md` 와 동일 구조
3. `<tool>-auto-save.sh` (hook) — `pencil-auto-save.sh` 와 동일 패턴
4. `<tool>-sot-binding.md` (보호) — `pencil-sot-binding.md` 와 동일 구조
5. `ui-spec.schema.json` 의 `designTool` enum 에 추가
6. `design-sot-policy.md` + `design-to-code-sync.md` + `uiux-sot-refresh.md` = 그대로 재사용

---

## 3. 보호 파일 sha 변경 (5 종 baseline 갱신)

| 파일 | sha (8자) | 분류 |
|---|---|---|
| `ui-spec.schema.json` | `5aa52b23` | 도구 무관 v0.3 |
| `uiux-sot-refresh.md` | `1f871447` | 도구 무관 95% generic |
| `design-sot-policy.md` (신설) | `(commit 후 박음)` | 도구 무관 |
| `pencil-uiux-workflow.md` | `6297080a` | Pencil 도구 바인딩 |
| `pencil-sot-policy.md` (의미 = pencil-sot-binding) | `96de2f5d` | Pencil 도구 바인딩 |

→ C4 propagation 시 자식 repo 도 새 sha 받음. 추가 의무: 자식 repo 의 `ui-spec.json` 마이그레이션 (`lastSyncedPencilStateHash` → `lastSyncedDesignToolStateHash` · alias 호환).

---

## 4. 산출물 inventory (C2.5)

| 파일 | 변경 | 줄 수 |
|---|---|---|
| `.claude/rules/code-principles.md` | ★ 신설 (Q1) | 151 |
| `.claude/rules/design-to-code-sync.md` | ★ 신설 (Q2) | 103 |
| `.claude/rules/pencil-uiux-workflow.md` | ~ 갱신 (도구 바인딩 30%) | 112 (446 → 112) |
| `.claude/rules/uiux-sot-refresh.md` | ~ 갱신 (95% generic) | 108 (98 → 108) |
| `docs/design/design-sot-policy.md` | ★ 신설 (보호) | 153 |
| `docs/design/pencil-sot-policy.md` | ~ 갱신 (도구 바인딩 25%) | 91 (129 → 91) |
| `docs/schemas/ui-spec.schema.json` | ~ generic v0.3 | (8970 → ~9300 byte) |
| `.auto-memory/protected-file-hashes.md` | ~ 새 baseline 5 보호 | - |
| `.auto-memory/decision-log.md` | + C2.5 entry append | - |
| `.ai/reports/C2.5-.../REPORT.md` | ★ 신설 본 파일 | - |

---

## 5. Coin 손 작업 (C2.5 sandbox 권한 한계)

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
# Pencil-specific 파일명 변경 (의미 정합)
git mv docs/design/pencil-sot-policy.md docs/design/pencil-sot-binding.md && \
git add -A && \
git commit -m "$(cat <<'COMMIT'
feat(master): C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 도구 무관 분리 + SOLID

[Goal] cli infra 의 도구 무관 vs Pencil 전용 분리 + SOLID/DRY/KISS/YAGNI 코드 리뷰 체크리스트 박음
[Diff] +2 cli infra (code-principles + design-to-code-sync) +1 보호 (design-sot-policy) ~4 보호 sha 갱신 (ui-spec.schema v0.3 / uiux-sot-refresh 95% generic / pencil-uiux-workflow 30% / pencil-sot-binding 25%) + protected-file-hashes baseline
[Sha]  5aa52b23 / 1f871447 / 6297080a / 96de2f5d (4 보호 갱신) + design-sot-policy (신설)
[EC]   JSON valid · 5 보호 sha 박음 · 도구 무관 vs 도구 전용 매트릭스 박음
[Next] C4 propagation + 자식 repo 의 ui-spec.json 마이그레이션 (lastSyncedPencilStateHash → lastSyncedDesignToolStateHash alias)
[Refs] task: C2.5-... · parent: <C3 commit hash>
COMMIT
)"
```

---

## 6. C4 진입 추가 의무

C4 propagation 시 다음 자동 처리 의무:

1. master → 3 자식 repo 단방향 cp (모든 cli infra + 5 보호 파일)
2. 자식 repo 의 기존 ui-spec.json 자동 마이그레이션 (script 신설):
   - `lastSyncedPencilStateHash` → `lastSyncedDesignToolStateHash` (값 그대로 + alias 유지)
   - `designTool: "pencil"` 필드 추가 (default)
3. cross-verify (verify-sync.sh) → 모든 sha ✓ MATCH
4. 자식 repo 별 commit + master audit commit
5. propagation-status.md 자동 갱신
