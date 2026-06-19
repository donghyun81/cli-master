# MASTER-SUPABASE-PROD-APPLY-RECIPE-001 — Propagation Report

> 자동 생성: 2026-06-19T15:37:16+0900 · master HEAD: f31b07b

---

## 1. Cycle 메타

- cycle ID: MASTER-SUPABASE-PROD-APPLY-RECIPE-001
- timestamp: 2026-06-19T15:37:16+0900
- master HEAD: f31b07b
- master commit msg:
  ```
  docs(rule): MASTER-SUPABASE-PROD-APPLY-RECIPE-001 prod-apply 승인-후-cli-push recipe 박제
  
  [Goal] cli-infra SoT 정합 — "prod 도달 불가 STOP"(daily_tips GT) 근본 해소: prod apply 경로를 supabase-handling.md 에 recipe 로 박제 (매 세션 재발명 차단). Pencil→Compose 파이프라인 외 cli-infra ops.
  [Diff] .claude/rules/supabase-handling.md (+40/-7): §3.1 확장(staging 자율→Coin 승인→cli prod push 8-step · db push prod 금지→Management API /database/query RO=false 단일 경로) + §10.5 정정(staging vs prod 토큰 2-tier) + §5 STOP prod write 게이트 정정 + §9 history.
  [Sha] 보호 5 file (불변) · edit-set ∩ 보호 = ∅ · supabase-handling.md(비보호) c71ba1738307 (이전 a084874d463b).
  [EC] secret grep 0 · 보호 5 sha drift 0 · production code 0 LOC · 6-repo propagate 대기.
  [Next] propagate.sh --targets all → 자식 staged commit → verify-sync.sh → REPORT + audit. push=Coin.
  [Refs] parent 5e75cb0 · contract cc-paste-MASTER-SUPABASE-PROD-APPLY-RECIPE-001.md §3 recipe · 선례 GT-USERS-FK-RESTORE-001 / GB·GD-PROD-APPLY-001.
  
  Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
  
  ```

## 2. 자식 repo HEAD (propagation 직후)

| repo | HEAD | branch | dirty? (path-limited 후 잔존 = pre-existing WIP) |
|---|---|---|---|
| app-foundation | d61a4c4 | main | 0 (clean) |
| GentlyBreath | 7a32f69 | main | 28 files (pre-existing WIP · 무접촉) |
| GentlyDay | 9185a90 | main | 6 files (pre-existing WIP · 무접촉) |
| GentlyTable | 811e8a4 | main | 12 files (pre-existing WIP · 무접촉) |
| gently-product-docs | 265dec1 | main | 0 (clean) |

> 자식 commit = path-limited (`git commit .claude/rules/supabase-handling.md`) → 각 repo 의 pre-existing WIP 무혼입.

## 3. cross-verify 결과

`VERIFY.md` 첨부 참조.

## 4. 변경 파일 sha 비교

`DIFF.md` 첨부 참조.

## 5. 다음 단계

- 자식 repo 별 commit (master commit body 인용) — ✓ 완료 (FND d61a4c4 · GB 7a32f69 · GD 9185a90 · GT 811e8a4 · PDOCS 265dec1)
- `.auto-memory/propagation-status.md` 자동 갱신 확인 — ✓ verify-sync 갱신
- 본 cycle 마감 시 master `CLAUDE.md` §15 표 추가 — (별 의제 · 본 cycle scope = supabase-handling.md 한정)

---

## 6. Cycle 본질 + deliverable 검증

- **본질**: 반복된 "prod 도달 불가 STOP"(daily_tips GT) = 정책/capability 문제 아님 · recipe 미박제가 원인. → `supabase-handling.md` 에 "staging 자율 → Coin 명시 승인 → cli prod push" recipe 박제 (§3.1) + staging/prod 토큰 2-tier 구분 (§10.5) + §5 STOP 정정. Mode M5 cli-infra-ops.
- **deliverable 검증**: `supabase-handling.md` = **6-repo byte-identical** (git-sha1 `c71ba1738307da2b7fae8c9e156075c04f28ff9c` · 이전 `a084874d463b`). verify-sync 159 PASS 에 포함 (drift/miss 목록 부재).
- **edit-set**: master `.claude/rules/supabase-handling.md` 단일 (+40/-7). production code / 도메인 / 스키마 / `.mcp.json` / 보호 5 file **0 LOC 무접촉**.
- **불변식 준수**: 보호 5 sha drift 0 (edit-set ∩ 보호 = ∅) · secret grep 0 · prod 토큰 평문 0 (slot 이름만 기록).

## 7. verify-sync 결과 분류 (159 PASS / 1 DRIFT / 5 MISS · 본 cycle 무관 분리)

| 항목 | 파일 | 본 cycle 관련? | 분류 |
|---|---|---|---|
| PASS 159 | (supabase-handling.md 포함) | ✓ deliverable | 6-repo byte-identical |
| **DRIFT 1** | `docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md` (GT `aca9ac624fb3` ≠ master `bd48a476ffb7`) | ✗ 무관 (미접촉) | **pre-existing committed 분기** (GT HEAD = GT working-tree sha · WIP 아님) · 비보호 docs · 2026-06-18 verify(drift 0) 이후 발생 · lazy mitigation (cycle-discipline §3) · 자율 해소 X |
| **MISS 5** | `docs/ops/production-cli-access-tokens.md` (master `33064f09f4e2` · 5 자식 MISS) | ✗ 무관 | **master-only 운영 runbook** (자체 선언 "6-repo propagation 대상 X") · prior cycle carry-forward · 자율 해소 X |

- 보호 5 file = 전수 PASS (drift/miss 목록 부재). **A2 / 불변식 6 PASS — STOP 미발동**.
- verify-sync exit FAIL = 위 pre-existing DRIFT 1 + MISS 5 起因 (본 cycle deliverable 무관).

## 8. 후속 (scope 외 · 자율 해소 X)

1. **`docs/ops/production-cli-access-tokens.md` db push 정합** — 본 runbook §5(:109)·§6(:123) = prod `supabase db push` 예시 잔존. 본 cycle 의 §3.1 불변식 3 (prod write = Management API 단일 경로 · db push prod 금지)과 **모순** (= GD-PROD-APPLY-001 prod DB pw slot 부재 실측 정합). master-only runbook 정정 = 별 cycle.
2. **GT `RLS_AND_PLAY_INTEGRITY_GUIDE.md` 분기 reconcile** — master↔GT committed 분기 (canonical 판정 + 재propagate) = 별 cycle.
3. **`docs/ops/` verify-sync MISS 분류** — master-only 의도 파일을 verify-sync 추적 set 에서 제외할지 (false-MISS) = 별 의제.
4. **git-lock-cleaner daemon load** — verify-sync C12 advisory (`launchctl load …com.coin.git-lock-cleaner.plist`) · non-blocking.

## 9. Negative Space Line

고려했으나 hot 제외 영역: docs/ops runbook db-push 정정 (scope 외 · 별 cycle) · GT RLS 분기 reconcile (scope 외) · §15 entry (master-only · 별 의제) · safety-and-secrets.md prod 토큰 tier 본문 보강 (현 §10.5 pointer 충분 판단).

