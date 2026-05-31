# TODO — MASTER-CLI-PROPAGATE-BASELINE-DYNAMIC-001

## 잔여 블로커
- (없음)

## Follow-up (별 cycle 후보 · 본 cycle scope 외)
- [ ] Cycle 5 (D-area): `.ai/baseline-snapshot/latest.json` 측 pencil-uiux-workflow.md sha `f1825013...` stale → 현 `d64481370d...` resync (umbrella §2.50 명시 · 본 cycle scope-out).
- [ ] (선행 의무) Cycle 2 PROTECTED: MASTER-CLI-PENCIL-UIUX-HEADLESS-RESTRUCTURE — 본 cycle 이 선행 완료 → Cycle 2 측 propagate.sh 무접촉 진입 가능.

## scope-out baseline 보존 (무접촉 확인)
- master `.ai/*` (nightly-baseline) + `.auto-memory/*` (incident-log · propagation-status) = pre-existing dirty baseline 보존 (§7.1 · 0 NEW dirty in scope-out).
- GentlyTable `.ai/baseline-snapshot/latest.json` = pre-existing dirty baseline 보존.
