# EVIDENCE — MULTI-REPO-EDGEFN-VAULT-KEY-RENAME-001

## Requirements Source
- 원문: 3 자식 repo (GB/GD/GT) 의 Edge Function source + README + setup files 안 env var `ANTHROPIC_API_KEY` → `CLAUDE_API_KEY` 명명 통일.
- Authority: Coin 명시 권한 (A/B/C 자율 위임).
- Scope: rename only · 본질 변경 X · 보호 6 file 변동 X · Android 빌드 무관.
- Out-of-scope: Vault registration / Edge Function deploy / `supabase secrets set` 실행 (Coin direct).

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | refactor (rename) — 3-repo propagation |
| Reading Mode | task 재개-후속형 |
| Requirement Source | Coin 직접 prompt |
| Info Gap | RESOLVABLE_IN_REPO |
| STOP Risk | 보호 6 file SHA 변동 시 STOP (감지 X) |
| Read-Only Fan-Out | grep ANTHROPIC_API_KEY · grep CLAUDE_API_KEY · shasum 6 baseline |
| Implementer Entry | Allowed (Low risk · Coin 명시 승인) |

## Pre-EVIDENCE Contract
- Read evidence: GB/GD/GT 의 `supabase/functions/**/*.ts` + `**/README.md` + `docs/setup/03_edge_functions/README.md` 안 `ANTHROPIC_API_KEY` 참조.
- Remaining gaps: 없음 (rename only · 의미 보존).
- Chosen path: 3 자식 repo 각자 child cycle commit (cycle-discipline §6 v2 + §7 6-section) + master parent reports.
- Hold/Stop reasons: 없음.
- Implement entry conditions: Coin 명시 승인 명시됨 + scope 보호 6 file 변동 X.

## Collect Results

### 매칭 파일 (sibling 3 commit 산출)

#### GB (commit 64de5a5)
- `supabase/functions/claude-proxy/index.ts` — line 20, 61 (2 hit)

#### GD (commit f55ca9c)
- `supabase/functions/ai_insights/claude_client.ts` — line 17, 19 (2 hit)
- `supabase/functions/ai_insights/README.md` — line 12, 22 (×2), 38 (3 hit · 4 occurrences)

#### GT (commit 783cd15)
- `docs/setup/03_edge_functions/README.md` — line 13, 65, 128, 147 (4 hit)
- `supabase/functions/ai_insights/claude_client.ts` — 사전 정합 (GT-PHASE-2-001 cycle 에서 이미 `CLAUDE_API_KEY` 채택됨, 4 hit baseline 유지)

### 0 Matches (부재 증거 · post-rename)
- 3-repo 안 `ANTHROPIC_API_KEY` 잔존 = 0 (rename 마감 검증).

## Key Findings
1. 3 repo 의 변경 영역이 모두 Edge Function + 설명 README 한정 — Android Compose 빌드 영향 X.
2. 보호 6 file SHA prefix (ui-spec.schema.json: f1edd397 / uiux-sot-refresh.md: ee377dc2 / design-sot-policy.md: e5e3fe16 / pencil-uiux-workflow.md: 7621013e / pencil-sot-policy.md: 96de2f5d / auth-rules.md: 5be3d237) 모두 변동 0 — propagation 의무 발화 X.
3. GT 의 claude_client.ts 는 이전 cycle (GT-PHASE-2-001) 에서 이미 `CLAUDE_API_KEY` 로 정합되어 있어 본 cycle 에서는 README 4 hit 만 처리.

## Cleanup Assessment

### 발견된 후보
| 위치 | 설명 | 판정 |
|---|---|---|
| (없음) | 3 repo 모두 rename only · 미사용 코드 / dead branch X | 즉시 제거: 0 |

### 점검 명령
```
grep -rn "ANTHROPIC_API_KEY" /Users/yundonghyeon/AndroidStudioProjects/{GentlyBreath,GentlyDay,GentlyTable}
grep -rn "CLAUDE_API_KEY" /Users/yundonghyeon/AndroidStudioProjects/{GentlyBreath,GentlyDay,GentlyTable}
```

### 판정 요약
- 즉시 제거: 0 건
- deferred: 0 건
- task-level STOP: 0 건
