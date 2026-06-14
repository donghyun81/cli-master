# MASTER-CLI-PENCIL-SCHEMA-UPDATE-001 — Propagation Report

> 수기 생성: 2026-06-15T00:54:45+0900 · master HEAD: 3c2ac9b · Mode M5 cli-infra-ops

---

## 1. Cycle 메타

- cycle ID: MASTER-CLI-PENCIL-SCHEMA-UPDATE-001
- timestamp: 2026-06-15T00:54:45+0900 (KST)
- master HEAD (rule commit): `3c2ac9b`
- scope: **Option 1 "최소 정직"** — `.pen` format version label `"2.11"` → `"2.13"` + §1.1a structural-delta 유예 배너. body (§2 13 union + §2.2~§2.8 + §4 + §5) = **2.11-shape 유지 PENDING**.
- 변경 파일: `.claude/rules/pencil-pen-format-schema.md` 단일 (비보호 cli infra rule · 6-repo byte-identical).
- master commit msg:
  ```
  docs(rule): MASTER-CLI-PENCIL-SCHEMA-UPDATE-001 .pen version 2.11→2.13 라벨 + structural delta 배너
  ```

## 2. STEP 0 — live 측정 근거 (authoritative)

- 측정 도구: Pencil MCP `get_editor_state(include_schema: true)` · active editor `GentlyTable/docs/design/pencil-sot/report-screen/report-screen.pen` (5종 v2.13 중 1).
- 반환 schema `Document { version: "2.13" }` 확인 → disk `.pen` 5종 auto-migration 정합.
- **판정: structural (minor bump 아님)** — 2026-05-31 RECOLOR-GENERATOR-001 (2.10→2.11 minor) 선례와 대비.

### 측정된 2.11 → 2.13 structural delta (8건)

| # | 영역 | 2.11 (본 body) | 2.13 (live) |
|---|---|---|---|
| 1 | Entity union | `line` 포함 | `line` 제거 |
| 2 | Entity union | `icon_font`/`IconFont` (`iconFontName`·`iconFontFamily`) | `icon`/`Icon` rename (`icon`·`library`) |
| 3 | Entity union | (부재) | `script`/`Script` 신규 (scriptUri·inputs·clip) |
| 4 | Variable | `Variable = string` · raw 값 | typed 선언 `{type; value}` |
| 5 | Stroke | `stroke?: Stroke` (nested) | flatten `stroke?: Fills` + strokeWidth/Linecap/Linejoin/Alignment |
| 6 | Fill | color/gradient/image/mesh_gradient | `shader` fill 추가 |
| 7 | Text | `TextContent = StringOrVariable \| TextStyle[]` | `StringOrVariable` (array drop) |
| 8 | Group | Layout + width/height 보유 | Layout + width/height 상실 |

(minor) `Path.viewBox?` 추가 · `Entity` CanHaveRotation inline. union count 13 유지 (−line −icon_font +icon +script).

## 3. propagation 결과

- `bash scripts/propagate.sh .claude/rules/pencil-pen-format-schema.md --targets all`
- targets = GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs (5) + master = **6-repo byte-identical**.
- 결과: **ok=5 fail=0** · `--prune` 미사용 · .gitignore 신규 patch 0.

## 4. 6-repo HEAD + sha (직접 `shasum -a 256` 대조 = authoritative)

| repo | HEAD (commit) | pencil-pen-format-schema.md sha-256 (12) |
|---|---|---|
| claude-cli-master | `3c2ac9b` | `01b79fd7ccf1` |
| GentlyBreath | `1c9353b` | `01b79fd7ccf1` |
| GentlyDay | `7fc0337` | `01b79fd7ccf1` |
| GentlyTable | `1e8d211` | `01b79fd7ccf1` |
| app-foundation | `af3869f` | `01b79fd7ccf1` |
| gently-product-docs | `3534130` | `01b79fd7ccf1` |

> 6-repo 전부 sha-256 `01b79fd7ccf1e2be67ac0119833a80efe51b78d95252fc6a78e1b9969a8054a3` 동일. master pre-edit baseline = `4de39ff2…`.
> 자식 commit body = master `3c2ac9b` 인용 · 각 path-limited (그 1 file만 · 자식 기존 WIP 무혼입).

## 5. cross-verify (`verify-sync.sh`)

- `bash scripts/verify-sync.sh` → **PASS: 160 파일 · DRIFT: 0 · MISS: 0** · exit 0.
- `pencil-pen-format-schema.md` = find-scan 검증 (160 file 집합 포함) · protected-5 manifest 매트릭스 행 X = 정상 (비보호 cli infra rule).
- `.auto-memory/propagation-status.md` 재생성 → 6-repo 매트릭스 (gently-product-docs 컬럼) 복구. ⚠ 진입 시 working-tree에 잔존하던 6/13 회귀분(5-repo 후퇴)은 rule commit 전 `git checkout HEAD --`로 폐기 후 verify-sync 재생성분으로 교체 (회귀분 미커밋).

## 6. 보호 / 무접촉 검증

- 보호 5 file (`ui-spec.schema.json` · `pencil-uiux-workflow.md` · `pencil-sot-policy.md` · `uiux-sot-refresh.md` · `design-sot-policy.md`) = **sha 무변동** (edit-set ∩ 보호 = ∅). `ui-spec.schema.json` `.pen`-version ref = 0 (companion schema · format 독립) → structural에도 무접촉 확정.
- production `.kt` / 자식 도메인 코드 = **0 LOC**.
- body §2~§5 = 2.11-shape 유지 (`Line`·`icon_font` 잔존 = Option 1 준수). 8-delta body rewrite + 형제 Pencil rule 4종(`pencil-visual-primitives.md`·`pencil-mcp-tools-reference.md`·`pencil-component-paradigm.md`·`pencil-theme-multi-axis.md`) = **별 follow-up cycle (002) defer** — 본 cycle 침범 0.

## 7. 자식 repo dirty (report 시점 · 전부 scope-외 WIP · 본 cycle 신규 0)

| repo | HEAD | dirty | 비고 |
|---|---|---|---|
| GentlyBreath | `1c9353b` | 21 | 진입 baseline WIP (incident-log/TODO/supabase-temp/scratch) · 본 cycle 무접촉 |
| GentlyDay | `7fc0337` | 20 | ⚠ child-commit 직후 1 → 20 증가 = 다른 활성 session WIP (cross-session) · 내 commit `7fc0337` intact |
| GentlyTable | `1e8d211` | 1 | supabase/.temp/cli-latest |
| app-foundation | `af3869f` | 0 | — |
| gently-product-docs | `3534130` | 0 | — |

> 본 cycle 모든 commit = path-limited (`pencil-pen-format-schema.md` 1 file) → **자식 기존/cross-session WIP 무혼입 · 신규 dirty 0**.

## 8. 사고 / follow-up

- **stale index.lock × 2 (6/13 크래시 잔해)**: master `.git/index.lock` (6/13 16:00) + app-foundation `.git/index.lock` (6/13 14:13) — 둘 다 0-byte·~34h·무프로세스 = 확정 stale. commit/`git add` 차단. Coin이 수동 제거(rm) 후 재개.
- **근본원인**: `verify-sync.sh` 경고 — launchd daemon `com.coin.git-lock-cleaner` **미활성** (plist 존재·load 안 됨). 이 daemon이 죽어 stale lock 자동 정리 안 됨. **follow-up**: `launchctl load ~/Library/LaunchAgents/com.coin.git-lock-cleaner.plist` (환경 조치 · Coin 판단).

## 9. 마감 상태

- 6-repo byte-identical PASS · verify-sync 160/0/0 · 보호 무변동 · production 0 LOC.
- 남은 단계: master `CLAUDE.md` §15 entry + audit commit (본 REPORT + 재생성 propagation-status.md).
- push (6-repo) = Coin · cowork 최종 disk cross-verify PASS 후.
