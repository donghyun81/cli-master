# TODO — MASTER-CLI-VERSION-PIN-DESTALE-001

## 잔여 블로커
- (없음)

## Follow-up (별 cycle 후보 · 본 cycle scope 외)
- [ ] propagate.sh `EXPECTED_BASELINE` heredoc (line 224-229) 측 stale sha-256 4종 → `.auto-memory/protected-file-hashes.md` 동적 reference 전환 (가칭 `MASTER-CLI-PROPAGATE-BASELINE-DYNAMIC-001`). 현재 WARN-only · 기능 영향 0 · manifest 는 이미 reconcile 됨.

## scope-out baseline 보존 (무접촉 확인)
- master `.ai/*` (nightly-baseline) + `.auto-memory/*` (incident-log · propagation-status) = pre-existing dirty baseline 보존 (§7.1 · 0 NEW dirty in scope-out).
- GentlyTable `.ai/baseline-snapshot/latest.json` = pre-existing dirty baseline 보존.
