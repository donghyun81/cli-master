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

## Last verify-sync

- timestamp: 2026-05-12T16:46:48+0900
- pass: 115
- drift: 1
- miss: 1
- exit: 1

### Drift 상세

- .claude/hooks/baseline-snapshot.sh  master=d41f25ffc281  GentlyBreath=✓  GentlyDay=✓  GentlyTable=✓  app-foundation=MISS
- .claude/settings.json  master=6919ac4ad00a  GentlyBreath=✓  GentlyDay=✓  GentlyTable=✓  app-foundation=f8bace35dbfa(✗)
