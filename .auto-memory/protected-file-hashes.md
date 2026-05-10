# Protected File Hashes — claude-cli-master baseline

> master 가 4 보호 파일 + 신규 도구 무관 1 보호 파일 + cli infra 의 SoT.
> 자식 repo (GB/GD/GT) 의 모든 sha 는 본 master sha 와 byte-identical 강제.
> drift 감지 = `verify-sync.sh` 가 자동 발화 + propagation cycle trigger.

## 보호 파일 5 종 (강제 byte-identical · master HEAD baseline · C2.5 갱신)

| 파일 | 분류 | sha-256 | 변동 |
|---|---|---|---|
| `docs/schemas/ui-spec.schema.json` | 도구 무관 (v0.3 generic 화) | `f1edd39739d4c0192872002487c02bca6929f8bd6c14f85392552182ce2aa445` | **MASTER-DOC-CITATION-FIX-001 갱신** (2026-05-04 · description 도구 generic 어휘 3곳 정정 · 필드명 alias 보존) |
| `.claude/rules/uiux-sot-refresh.md` | 도구 무관 (95% generic) | `ee377dc2ac32357f61fa1b2bfc39690ab530b65102e31062bff91ab6b8b260d3` | **MASTER-PROTECTED-BASELINE-RESYNC-001 갱신** (2026-05-03 · 후속 cycle 으로 baseline 정합) |
| `docs/design/design-sot-policy.md` | 도구 무관 (75% 공통 추출) | `e5e3fe165ec3a826b2843f0e9791d4e6f07fb4c226bcc53639868787da49af03` | **MASTER-PROTECTED-BASELINE-RESYNC-001 갱신** (2026-05-03 · 후속 cycle 으로 baseline 정합) |
| `.claude/rules/pencil-uiux-workflow.md` | Pencil 도구 바인딩 (30% 잔존) | `7621013e7f2dc644f0d0028b0574e12949dc7462953b4d5465c8a1186d6f0c0f` | **MASTER-PROTECTED-BASELINE-RESYNC-001 갱신** (2026-05-03 · 후속 cycle 으로 baseline 정합) |
| `docs/design/pencil-sot-policy.md` | Pencil 도구 바인딩 (의미 = pencil-sot-binding) | `96de2f5d10a73af4aaa2608770f503dd3956304846c6db8a9b2cf2d05cba6559` | **MASTER-PROTECTED-BASELINE-RESYNC-001 갱신** (2026-05-03 · MATCH 재확인) |

> **참고**: `design-sot-policy.md` 신설 sha = `e5e3fe165ec3...` (C2.5 마감 박음).

## 신설 cli infra (C2.5)

- `.claude/rules/code-principles.md` (151 줄) — Q1 답: SOLID 5 + DRY/KISS/YAGNI + 코드 리뷰 체크리스트 + reviewer 자동 참조
- `.claude/rules/design-to-code-sync.md` (103 줄) — Q2 답: pencil-uiux-workflow.md 의 70% 공통 추출 (도구 무관)
- `docs/design/design-sot-policy.md` (153 줄) — Q2 답: pencil-sot-policy.md 의 75% 공통 추출 (보호 신설)

## C2.5 분리 결과 — 도구 무관 vs Pencil 전용 매트릭스

| 영역 | 도구 무관 (공통) | Pencil 전용 (도구 바인딩) |
|---|---|---|
| Design SoT 정책 | `design-sot-policy.md` (보호 · §1~§8) | `pencil-sot-policy.md` (보호 · 의미 = `pencil-sot-binding.md`) — Pencil MCP tools / Path B fallback / 도구 한정 STOP |
| Design → Code sync | `design-to-code-sync.md` — 5-type IMPL / Output Checklist P1-P9 / STOP | `pencil-uiux-workflow.md` (보호) — Pencil 도구 호출 patterns / macOS 자동화 / Cmd+S / Save As 모달 |
| SoT refresh | `uiux-sot-refresh.md` (보호 · 95% generic) | (도구별 trigger 키워드는 본 파일 안 generic placeholder) |
| 자동화 hook | (도구 무관 hook 없음) | `pencil-auto-save.sh` (v2) + `save-as-result-check.sh` (Pencil 의존) |
| 자동화 rule | (도구 무관 rule 없음) | `pencil-automation.md` (Pencil .pen 자동화) |
| schema | `ui-spec.schema.json` (보호 v0.3 · designTool enum + 도구 무관 필드명) | (구 Pencil 명명 필드는 v0.3 alias 로 유지 + deprecated 예고) |

## verification

```bash
# master baseline 일관성 검증 (run from claude-cli-master/)
for f in docs/schemas/ui-spec.schema.json .claude/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md; do
  shasum -a 256 "$f" | awk '{print $1}'
done
# 위 5 sha 가 본 표와 일치 = master baseline PASS

# 3-repo 동기 검증
bash scripts/verify-sync.sh
```

## GLOBAL-NO-ABBREV-POLICY-001 신설 cli infra (2026-05-10)

| 파일 | sha-256 (full) | 비고 |
|---|---|---|
| `.claude/rules/no-abbreviation-policy.md` | `dc5432f6f6110ba9bf654b8031befe07f03a8ce466c0de3d102cc30415e45403` | no-abbreviation 정책 SoT |
| `.claude/rules/allowed-acronyms.md` | `83b092e21f07a418385470bbefce8ab5bb468f4c39751c6c457bf0e97c4da716` | 허용 표준 약어 SoT |
| `.claude/rules/forbidden-abbreviations.md` | `82519940f655d114c88184429f7efc934a0844785f4f17145b29b581162e153a` | 금지 약어 seed list SoT |
| `.claude/hooks/check-abbreviation.sh` | `98d0a023a90fe2d614fde796056896087c5c7fc39ea5ded445d314b2f2f37a23` | PreToolUse Edit|Write hook |
| `.claude/settings.json` | `c777a494d5e70ddb95958a8761ab03affd81827763bed0249d7685552b61d9f9` | settings (PreToolUse 갱신) |

4-repo byte-identical: master 77ca613 · GB 628245f · GD 3a5b4ca · GT f4501d5
보호 파일 5종 sha 변동: 0 (cli infra 권장 파일 5종만 신설)

## GLOBAL-NO-ABBREV-POLICY-002 갱신 cli infra (2026-05-10)

| 파일 | sha-256 (full) | 변경 내용 |
|---|---|---|
| `.claude/hooks/check-abbreviation.sh` | `c232e2c7961bd9eeb1f5756337184e61c8a5469d29db872eaa84296f8d20c9ab` | Sub B: import line skip + generated path skip / Sub C: NO_ABBREV_ENFORCE default warn→enforce |
| `.claude/rules/no-abbreviation-policy.md` | `b42cc3df424134768f70a966a6c0f8ff1951eb138a418d0e00ca9a8e82d4fa7f` | §3 hook 제외 대상 표 신설 / §5.1 mode default enforce / §5.2 self-test 7 fixtures |

4-repo byte-identical: master 7a25854 · GB 2c83a4e · GD 8ad3e7d · GT 8647a4d
보호 파일 5종 sha 변동: 0 (cli infra 권장 파일만 갱신)

## Recent updates

- 2026-05-10 · MASTER-BILLING-DOMAIN-ACTIVATE-001 · Billing 도메인 4-repo 활성화 (UNKNOWN×4 → ACTIVE×4) · `billing-rules.md` SoT 신설 + `billing-payments-guardian` agent deferred/ → active/ + STEP-1 drift mitigation (master sot-code-name-map.md ← GT 흡수 · 새 sha `7f2f4e61c635d6f425232c4c5f0d5b7caed9a8da3036efcff6c67de9676068d2`) · 4-repo byte-identical (verify-sync 112/0/0) · 보호 파일 5종 sha 변동 0.
- 2026-05-05 · MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001 · cli infra ux-laws.md sha 변동 80aa2915... → 0f63f399... (322 line / §5.1 N/A 영역 7 신설) · 4-repo byte-identical · 보호 파일 5 종 sha 변동 0 · master 3c48df5 / GB a8d985e / GD dd4d6f0 / GT 25d2358.
- 2026-05-05 · MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001 Phase 1 정합 검증 · 보호 파일 5 종 + cli infra 6 종 4-repo byte-identical 재확인 (drift 0). prompt BASELINE 의 `design-sot-policy.md` 위치 가정 (`.claude/rules/`) 정정 → 실제 `docs/design/`. 보호 파일 sha 변동 0.
- 2026-05-04 · MASTER-DOC-CITATION-FIX-001 · ui-spec.schema.json description 의 Pencil 잔존 어휘 3곳 (`L129/191/210`) → 디자인 도구 generic 정정. 필드명 alias (`lastSyncedPencilStateHash` 등 v0.3 alias) 와 도구 바인딩 파일 인용 (`pencil-sot-binding.md`) 은 보존. 4-repo byte-identical propagation 동시.
- 2026-05-03 · MASTER-PROTECTED-BASELINE-RESYNC-001 · 보호 파일 5종 sha **MATCH 확정** + ui-spec.schema.json enum 에 "0.3" 추가 (description 은 변동 없음). 자식 ui-spec.json schemaVersion 마이그레이션은 별 cycle 분리.
- 2026-05-02 · C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 · 보호 파일 4종 sha **모두 갱신** (도구 무관 vs Pencil 전용 분리). 신설 보호 파일 1종 (`design-sot-policy.md`). 신설 cli infra 2종 (`code-principles.md` / `design-to-code-sync.md`).
- 2026-05-02 · C2-RULES-RESTRUCTURE-001 · 5 파일 신설 + 6 파일 deprecated + 5 파일 cross-reference 갱신. 보호 파일 4종 sha 변동 0.
- 2026-05-02 · C1-MASTER-BOOTSTRAP-001 · master baseline 신설.

## C6 신설/흡수 (2026-05-02)

### 흡수 6 파일 (3-repo byte-identical)
- `.ai/promptfit/PLAYBOOK.md` (PromptFit 평가 가이드)
- `.ai/uiux-sot/refresh/TRIGGERS.md` (refresh trigger patterns)
- `.ai/uiux-sot/refresh/VERIFY.md` (refresh 검증 명령)
- `.ai/uiux-sot/refresh/WORKFLOW.md` (refresh workflow)
- `.github/pull_request_template.md` (PR template)
- `docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md` (Supabase RLS + Play Integrity)

### 신설 9 파일 (master 신규 SoT)
- `docs/guides/app-implementation-guide.md` (204 줄 · Claude CLI 진입 1차 가이드)
- `docs/templates/api-spec.template.md`
- `docs/templates/data-model.template.md`
- `docs/templates/screen-flow.template.md`
- `docs/templates/ai-prompt-guide.template.md`
- `docs/templates/billing.template.md`
- `docs/templates/setup-guide.template.md`
- `docs/templates/pencil-dev-prompt.template.md`
- `.auto-memory/child-claude-md-header.template.md` (Nested CLAUDE.md 패턴)

보호 파일 5종 sha = C2.5 baseline 보존 (변동 0).
