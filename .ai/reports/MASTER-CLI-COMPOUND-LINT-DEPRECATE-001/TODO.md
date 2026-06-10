# TODO — MASTER-CLI-COMPOUND-LINT-DEPRECATE-001

## 잔여 블로커
(없음)

## 후속 (scope 외 · 별 cycle 후보)
- [ ] PROPAGATION_PARAMETERS.md 측 repo-config identity 인터페이스 광역 stale — 본 cycle 실측: master/GB `scripts/repo-config.sh` 에 `REPO_NAME`/`REPO_PREFIX`/`REPO_APP_PKG`/`REPO_DOMAIN_PKG` 미export · PDOCS repo-config 부재 · 문서 전반 `scripts/agent/repo-config.sh` 경로 표기 vs 실위치 `scripts/` 불일치 (DEAD-REF-SWEEP ⑨ surface stale 잔여 동족)
- [ ] layer-checker.md §Evidence to gather 의 `. scripts/agent/repo-config.sh` 경로 stale (실위치 = `scripts/repo-config.sh` · uiux-sot-refresh:61 정정 전례 동형)
- [ ] pencil-uiux-workflow.md:11 `pencil-sot-binding.md` (보호) 명칭 잔존 — 실 file = `pencil-sot-policy.md` (의미 = pencil-sot-binding · terminology §1.2 정합) · 보호 접촉이므로 별 cycle
- [ ] O7 "5-repo" 어휘 sweep (기존 후속 유지)
- [ ] COMPOUND.md artifact 존치 재평가 — 산출물 규약(7-file 스키마)에 잔존 · 생산 수단이 deprecate 됐으므로 artifact 정의 자체의 후퇴(또는 종합 검증 결과 보고서로의 공식 재정의) 검토
- [ ] `.ai/baseline-snapshot/latest.json` 보호 sha-256 = 본 cycle 신 sha 와 불일치 상태 (nightly baseline-snapshot 재생성 시 자동 정합 — runtime layer 자동 갱신 영역 · 미갱신 지속 시 수동 1회)

## scope 외 기존 dirty (무접촉 보존 · §7.1 paste-back dirty baseline)
- GB: `.ai/reports/GB-VISION-MOTIVATION-001/TODO.md` (M) + `package-lock.json` (??)
- GD: `supabase/.temp/cli-latest` (M)
- GT: `supabase/.temp/cli-latest` (M)
