# Propagation Status — master ↔ 3 자식 repo 동기 현황

> `verify-sync.sh` (C3) 가 매 cycle 자동 갱신.
> 본 표는 master HEAD 대비 자식 repo 의 cli infra + 보호 파일 sha 일치 여부.

## 자식 repo 등록 표 (placeholder · CLAUDE.md §1 참조)

| repo | 절대 경로 | git HEAD (참조 시점) |
|---|---|---|
| GB | `<PARENT>/GentlyBreath` | `80bd867` (2026-05-02 baseline) |
| GD | `<PARENT>/GentlyDay` | `622102a` (2026-05-02 baseline) |
| GT | `<PARENT>/GentlyTable` | `d2c29f6` (2026-05-02 baseline) |

## 보호 파일 5 종 sha 동기 매트릭스 (C4 후 baseline · ALL ✓ MATCH)

| 파일 | master sha (8자) | GB sync | GD sync | GT sync |
|---|---|---|---|---|
| `docs/schemas/ui-spec.schema.json` (v0.3) | `0a82b895` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `.claude/rules/uiux-sot-refresh.md` (95% generic) | `ee377dc2` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `docs/design/design-sot-policy.md` (신설) | `e5e3fe16` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `.claude/rules/pencil-uiux-workflow.md` (Pencil 30%) | `7621013e` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `docs/design/pencil-sot-policy.md` (Pencil 25%) | `96de2f5d` | ✓ MATCH | ✓ MATCH | ✓ MATCH |

## cli infra 핵심 sha 매트릭스 (master baseline)

| 파일 | master sha (8자) | GB sync | GD sync | GT sync |
|---|---|---|---|---|
| `.claude/rules/workflow.md` | `3fba9c7a` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `.claude/rules/evidence-and-reporting.md` | `de63b997` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `.claude/rules/legacy-cleanup-governance.md` | `9d8de37e` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `.claude/settings.json` | `60e79766` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `.claude/rules/routing-and-delegation.md` | `9ad9b820` (GB+GD) | ✓ MATCH | ✓ MATCH | **✗ DRIFT** (GT = `053cae73`) |
| `.claude/rules/ui-ux-analysis.md` | `79abdcfa` (GT) | **✗ DRIFT** (GB/GD = `fdc8cbe5`) | **✗ DRIFT** | ✓ MATCH |
| `.claude/rules/deferred-domains.md` | `08bd9d7f` (GT) | **✗ DRIFT** (GB = `4a9944de`) | **✗ DRIFT** (GD = `351e6fe7`) | ✓ MATCH |
| `.claude/agents/domain-roles.md` | `(neutral · placeholder)` | DRIFT 의도 | DRIFT 의도 | DRIFT 의도 |
| `.claude/hooks/pencil-auto-save.sh` | `21ac3e85` (GD v2) | **✗ DRIFT** (GB v1 = `fc09cb97`) | ✓ MATCH | **✗ DRIFT** (GT v1 = `fc09cb97`) |
| `.claude/hooks/save-as-result-check.sh` | `105f978b` (GD only) | **✗ MISS** (GB 부재) | ✓ MATCH | **✗ MISS** (GT 부재) |

## MASTER-PROTECTED-BASELINE-RESYNC-001 갱신 (2026-05-03)

- 2026-05-03 · MASTER-PROTECTED-BASELINE-RESYNC-001 · 5종 baseline sha 갱신 + ui-spec.schema.json enum 0.3 추가 + 4-repo propagation MATCH 재확인.

## 현 정합 상태 요약 (C1 baseline 직후)

- **보호 파일 5 종** = 3-repo 모두 PASS (변동 없음)
- **cli infra** = 6 파일 drift (master 가 GD/GT 의 best-version 채택 후 GB 와 일부 drift)
- **propagation 의무** = C4 cycle 에서 master → 3-repo 단방향 cp 로 모두 일치 예정

## C4 propagation 후 expected status

C4 마감 후 본 표의 모든 sync 컬럼이 ✓ MATCH 로 통일.

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

## C4-VERIFY-001 광역 점검 (2026-05-02 · sandbox 마감)

- sha 정합 (verify-sync) = PASS 109 / DRIFT 0 / MISS 0 ✓
- C11 hook drift 6 (pre-tool-use.sh + session-start.sh × 3 자식) → sandbox cp 즉시 정정 → 재실측 PASS 회복
- deprecated rules pointer 4-way 잔존: workflow.md / evidence-and-reporting.md / auth-security-privacy.md / backend-and-api.md / data-and-migrations.md / performance-reliability.md = 6 종 × (master + 3 자식) = 24 (Coin rm 대기)
- 자식 flat agents 중복: `agents/*.md` 25 = `agents/active/`+`agents/deferred/` 25 (이름·내용 byte-identical) × 3 자식 = 75 (Coin rm 대기)
- 자식 sandbox testfile: `.ai/.sandbox-write-test` × 3 (Coin rm 대기)
- orphan 광역 검사 (`docs/setup/`, `scripts/agent/repo-config.sh`, `MANAGED_AGENTS_READINESS.md` 등) = 모두 정상 repo-specific
- Coin 손 작업 1 paste 후 expected: PASS 103 / DRIFT 0 / MISS 0 (master rules 13 · 자식 rules 13 · 자식 flat agents 0)
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















































## Last verify-sync

- timestamp: 2026-05-31T02:09:11+0900
- pass: 154
- drift: 0
- miss: 0
- exit: 0
