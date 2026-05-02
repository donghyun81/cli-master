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
| `docs/schemas/ui-spec.schema.json` (v0.3) | `5aa52b23` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `.claude/rules/uiux-sot-refresh.md` (95% generic) | `1f871447` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `docs/design/design-sot-policy.md` (신설) | `e5e3fe16` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
| `.claude/rules/pencil-uiux-workflow.md` (Pencil 30%) | `6297080a` | ✓ MATCH | ✓ MATCH | ✓ MATCH |
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

## 현 정합 상태 요약 (C1 baseline 직후)

- **보호 파일 4 종** = 3-repo 모두 PASS (변동 없음)
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
