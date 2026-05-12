# TODO — MASTER-CLEANUP-VOCAB-LAZY-BUNDLE-001

## Deferred (별 cycle)

- [ ] **CLI-VERSION-UNPIN-PROPAGATION-002** (TRAIL-1) — app-foundation 측 `.claude/rules/cycle-discipline.md` propagation 누락 정정 (현 sha `24be512066a2` ≠ master `732017a7cdd5`).
- [ ] **MASTER-RELEASE-CHECKLIST-TEMPLATE-002** (TRAIL-2) — 자식 4 측 `docs/templates/release-checklist.template.md` propagation 누락 정정 (4-repo MISS).
- [ ] **외부 cycle** — `.claude/hooks/baseline-snapshot.sh` + `.claude/settings.json` drift 영역 = 별 cycle 책임.
- [ ] **text-degeneration-prevention.md §5 화이트리스트 확장 후보** — 도메인 어휘 추가 영역 (foundation / 결정 / 신설 / 진입 / 검증 / sentry / firebase / bom) · M2/M3 false positive 잡음 영역 정리 (lazy · 우선순위 낮음).

## Open trails 측 영향 0

- `CLAUDE-CODE-LATEST-CHASE-001` (회귀 누적 영역) = 본 cycle 영향 X.
- `COWORK-PREP-BASELINE-MISMATCH` 동족 5회차 누적 → MASTER-COWORK-HANDOFF-BASELINE-AUTOVERIFY-HOOK-001 진입 영역 = 별 cycle.

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경 · cli infra + auto-memory + reports 영역 한정).
