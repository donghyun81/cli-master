# Propagation Status — master ↔ 3 자식 repo 동기 현황

> `verify-sync.sh` (C3) 가 매 cycle 자동 갱신.
> 본 표는 master HEAD 대비 자식 repo 의 cli infra + 보호 파일 sha 일치 여부.

## 수기 sha 매트릭스 폐기 (= Phase C · MASTER-CLI-POSTCYCLE-AUTOMATION-001 · 2026-06-01)

> **본질**: 직전 수기 sha 표 (= 자식 repo 등록 5-02 baseline HEAD + 보호 5종 매트릭스 + cli infra 핵심 매트릭스) = 영구 stale 원인. propagation 마다 수기 갱신 의무 누락 → 소멸 file 참조 누적: 직전 표 안 workflow.md(현 `workflow-core.md`) · evidence-and-reporting.md(현 `reporting.md` 통합) · domain-roles.md(구 .claude/agents/ → 현 `.claude/rules/domain-roles.md`) · pencil-uiux-workflow.md 7621013e(현 e6a4a2a1...) · save-as-result-check.sh(scripts/ 이동) 등.
> **정정**: 수기 매트릭스 → 본 file 하단 `## Auto-generated (verify-sync ...)` 영역으로 전환 = `verify-sync.sh` 가 매 실행 시 live sha (보호 5 + 핵심 cli infra) 재생성 + 자동 footer (`## Last verify-sync`). 두 자동 영역 = **단일 진실** · 수기 편집 금지. 부재 참조 발생 시 verify-sync 가 stderr WARN 발화 (= drift 재발 감지).
> **현 정합 상태** = 하단 자동 매트릭스 (live) 정독. master HEAD + 보호 5종 sha 표면화 = `.ai/baseline-snapshot/latest.json` (InstructionsLoaded hook always-fresh) + `CLAUDE.md §14a` (git-sha1) + `.auto-memory/protected-file-hashes.md` (sha-256 manifest) 정합.

## 동작 명령 (C3 신설 후 사용)

```bash
cd claude-cli-master
bash scripts/verify-sync.sh           # 본 표 자동 갱신
bash scripts/propagate.sh <file> --targets GB,GD,GT
bash scripts/propagate.sh --all       # 전 cli infra 일괄
```


## C4-PROPAGATE-TO-CHILDREN-001 마감 (2026-05-02)

- verify-sync.sh 실측 PASS: 109 파일 모두 ✓ MATCH (3 자식 × 109 = 327 파일 cp 완료)
- 자식 ui-spec.json 44 파일 마이그레이션 (lastSyncedPencilStateHash → lastSyncedDesignToolStateHash alias + designTool: pencil 신설)
- 자식 CLAUDE.md 의 첫 5줄 Nested 패턴 박음 (3 자식 모두)
- master 의 deprecated rules / Pencil 명명 alias 모두 자식 적용
- exit 0 PASS

## C4-VERIFY-001 광역 점검 (2026-05-02 · sandbox 마감 · point-in-time audit)

> ⚠ **정정 (Phase C · 2026-06-01)**: 아래 "Coin rm 대기" 항목 (deprecated rules 24 + flat agents 75 + sandbox testfile 3) = 이후 cycle 에서 모두 해소. deprecated rules (workflow.md / evidence-and-reporting.md / auth-security-privacy.md / backend-and-api.md / data-and-migrations.md / performance-reliability.md) = C2-RULES-RESTRUCTURE-001 등 통합 cycle 에서 삭제 마감 (= 현재 부재 · 상단 "수기 매트릭스 폐기" note 정합). 본 block = 2026-05-02 시점 sandbox audit 기록 (= 현 상태 X).

- sha 정합 (verify-sync) = PASS 109 / DRIFT 0 / MISS 0 ✓
- C11 hook drift 6 (pre-tool-use.sh + session-start.sh × 3 자식) → sandbox cp 즉시 정정 → 재실측 PASS 회복
- deprecated rules pointer 4-way 잔존 (2026-05-02 시점) = 6 종 × (master + 3 자식) = 24 → 이후 삭제 마감 (현재 부재)
- 자식 flat agents 중복 (2026-05-02 시점) = `agents/active/`+`agents/deferred/` 구조 × 3 자식 = 75 → 이후 정리 마감
- 자식 sandbox testfile `.ai/.sandbox-write-test` × 3 (2026-05-02 시점) → 이후 정리 마감
- orphan 광역 검사 (`docs/setup/`, `scripts/repo-config.sh`, `MANAGED_AGENTS_READINESS.md` 등) = 모두 정상 repo-specific
- 가이드 위치: `.ai/reports/C4-VERIFY-001/REPORT.md` §4























## MASTER-CLEANUP-PROPAGATION-BUNDLE-001 마감 (2026-05-12)

- 본 묶음 cycle = TRAIL-1 (CLI-VERSION-UNPIN-PROPAGATION-002) + TRAIL-2 (MASTER-RELEASE-CHECKLIST-TEMPLATE-002) + TRAIL-11 (CLAUDE-CODE-LATEST-CHASE-POLICY-CLARIFY-001 측 app-foundation 누락) 3 trail close.
- cycle-discipline.md: 5-repo byte-identical 회복 = sha-16 `5726cb44c5f4d53d` (5/5 PASS · master HEAD blob 측 cp 단방향 정합)
- release-checklist.template.md: 5-repo byte-identical 신설 = sha-16 `bd112d5457409e7a` (5/5 PASS · master HEAD blob 측 cp 단방향 정합)
- commit 5건:
  - app-foundation `a68186d3f37aed1155e654b3e35356daeeba0d10` (2 file 묶음)
  - GentlyBreath `a98a29c17d39d6e87c03891f1c7362912d768a73` (release-checklist 단일)
  - GentlyDay `999e7a795d046d58ae997463d0fdeb78fb6752bb` (release-checklist 단일)
  - GentlyTable `c83536739224359c4b5b866112e2411de3700d80` (release-checklist 단일)
  - master audit commit (= 본 entry 흡수 commit · 산출물 + memory 갱신 후)
- 보호 5 sha 변동 0 (5b84cd9e4bc36165/d3a0b57390bd0414/e580b6d7ca9a88ae/3a703b30553e0d09/b27fbe16edb68821 그대로)
- 잔존 영역 (= 별 trail 처리 후보) = app-foundation 측 .claude/settings.json (sha mismatch) + .claude/hooks/baseline-snapshot.sh (부재). 본 cycle scope 외 · 별 cycle 영역.

## MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001 마감 (2026-05-19)

- 본 cycle = `MASTER-CLI-FULL-PARADIGM-AUDIT-001` F1 finding mitigation default (= `.claude/hooks/baseline-snapshot.sh` 측 v6 5-repo paradigm 정합 X 영역).
- baseline-snapshot.sh: 5-repo byte-identical 회복 = sha `18fb59c80f64e520c84b0720cfb133276b54752e` (5/5 PASS · master HEAD blob 측 cp 단방향 정합 · 직전 sha `839ac890721c62c24c6edcd24f4dcf2f09962710`).
- 본문 정정 영역:
  - line 3 목적 본문 = "7-repo (claude-cli-master + Gently 3 + Proto 3)" → "5-repo (claude-cli-master + app-foundation + Gently 3)"
  - REPOS 배열 = 7 entry (claude-cli-master + Gently 3 + ProtoGently 3) → 5 entry (claude-cli-master + app-foundation + GentlyBreath + GentlyDay + GentlyTable · ProtoGently 3 제거 + app-foundation 추가)
  - line 116 자식 list (= drift detection grep 영역) = `GentlyBreath GentlyDay GentlyTable` → `app-foundation GentlyBreath GentlyDay GentlyTable` (= 4 자식 cover)
  - 신설 paradigm row append (= 본 cycle entry `MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001` 2026-05-19)
- commit 5 건:
  - master `a020cba` (= feat · parent `2c7dc02`)
  - app-foundation `7a9316d`
  - GentlyBreath `232d3e8`
  - GentlyDay `d40cb9e`
  - GentlyTable `82153a3`
  - master audit commit (= 본 entry 흡수 commit · 후속 step)
- hook self-test = PASS (= exit 0 · latest.json 안 5-repo entry 정합 ✓ + Proto* entry 부재 ✓).
- 보호 5 sha 변동 0 (= drift 0 의무 정합 ✓ · `5b84cd9e4bc36165` + `20c72ae66b513bdc` + `b27fbe16edb68821` + `d3a0b57390bd0414` + `e580b6d7ca9a88ae` 그대로).
- propagation report 3 file 자동 생성 = `propagation-reports/MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001/{REPORT,DIFF,VERIFY}.md`.
- 직전 잔존 영역 close: `MASTER-CLEANUP-PROPAGATION-BUNDLE-001` 측 "app-foundation 측 .claude/hooks/baseline-snapshot.sh (부재)" 영역 = 본 cycle 측 app-foundation 측 file 도입 + 5-repo byte-identical 정합 default 마감 (= 자연 close · 별 mitigation trail 진입 X).
- 잔존 영역 (= 별 cycle 후보 · 본 cycle scope 외 default):
  - `scripts/propagate.sh` + `scripts/verify-sync.sh` 측 `TARGET_REPOS` default = `"GentlyBreath GentlyDay GentlyTable"` (= 3 자식 only · app-foundation 부재 · 동일 v6 paradigm drift). 본 cycle 측 `--targets FND,GB,GD,GT` 명시 사용 default · 별 cycle 후보 `MASTER-CLI-PROPAGATE-VERIFY-SYNC-V6-MITIGATION-001` 패턴.
  - verify-sync.sh 측 pre-existing scope 외 DRIFT: gradlew + gradlew.bat (= app-foundation 측 sha ≠ master · 본 cycle 무관) + 1 doc MISS (= `docs/baseline/cowork-project-instructions-§20-redline-20260517.md` 측 4 자식 모두 MISS).


























































## Auto-generated (verify-sync · live · 직접 편집 금지)

> 본 영역 = `verify-sync.sh` 매 실행 시 live sha 재생성. 수기 편집 금지 (= 영구 stale 차단).
> targets: app-foundation toward-product-docs Selfward

### 보호 5 + 핵심 cli infra sha 매트릭스 (live)

| 파일 | master sha (12) | app-foundation | toward-product-docs | Selfward |
|---|---|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `8502c01428fb` | ✓ | ✓ | ✓ |
| `docs/rules/pencil-uiux-workflow.md` | `202d3f4f29c0` | ✓ | ✓ | ✓ |
| `docs/design/pencil-sot-policy.md` | `2bfc81c538b2` | ✓ | ✓ | ✓ |
| `docs/rules/uiux-sot-refresh.md` | `31c0da56aeec` | ✓ | ✓ | ✓ |
| `docs/design/design-sot-policy.md` | `92a5e99804ff` | ✓ | ✓ | ✓ |
| `.claude/settings.json` | `fdaf79e0dfe0` | ✓ | ✓ | ✓ |
| `docs/rules/workflow-core.md` | `fc61294804c4` | ✓ | ✓ | ✓ |
| `docs/rules/cycle-discipline.md` | `e5f547153109` | ✓ | ✓ | ✓ |
| `docs/rules/pencil-automation.md` | `a2506a34d797` | ✓ | ✓ | ✓ |
| `docs/rules/reporting.md` | `75b20064bbef` | ✓ | ✓ | ✓ |
| `docs/rules/routing-and-delegation.md` | `a3ea9b7d87cd` | ✓ | ✓ | ✓ |
| `docs/rules/deferred-domains.md` | `9952cb6074c6` | ✓ | ✓ | ✓ |
| `docs/rules/code-principles.md` | `d5f48e60bda0` | ✓ | ✓ | ✓ |
| `docs/rules/design-to-code-sync.md` | `81a52a9bc694` | ✓ | ✓ | ✓ |
| `docs/rules/ux-laws.md` | `76247cd98ac4` | ✓ | ✓ | ✓ |
| `docs/agent/architecture/COMMON_ARCHITECTURE.md` | `e857074ad1d9` | ✓ | ✓ | ✓ |
| `docs/agent/architecture/TDD_WORKFLOW.md` | `209f9aa3f69c` | ✓ | ✓ | ✓ |
| `docs/agent/architecture/MODEL_SEPARATION.md` | `d6262ba37923` | ✓ | ✓ | ✓ |
| `docs/agent/architecture/SSOT_PRINCIPLES.md` | `826e19561023` | ✓ | ✓ | ✓ |
| `docs/agent/process/COMMIT_CONVENTION.md` | `e2e8c636d82a` | ✓ | ✓ | ✓ |
| `scripts/agent/frontmatter-grep.sh` | `a387a4dc26dc` | ✓ | ✓ | ✓ |
| `.editorconfig` | `e6eb4cfe06a8` | ✓ | ✓ | ✓ |
| `.mcp.json` | `52b16685b740` | ✓ | ✓ | ✓ |

## Last verify-sync

- timestamp: 2026-08-17T17:10:22+0900
- pass: 162
- drift: 0
- miss: 6
- exit: 1

### Drift 상세

- docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md  master=0944b3147b66  app-foundation=MISS  toward-product-docs=MISS  Selfward=MISS
- docs/ops/production-cli-access-tokens.md  master=3b0e8131fb67  app-foundation=MISS  toward-product-docs=MISS  Selfward=MISS
