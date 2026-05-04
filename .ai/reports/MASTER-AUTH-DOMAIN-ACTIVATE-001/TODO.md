# TODO — MASTER-AUTH-DOMAIN-ACTIVATE-001

## Deferred (별 cycle · post-correction)

- [ ] `scripts/activate-agent.sh` + `scripts/propagate.sh` hardcoded `claude-cli-master` → `gently-master` 영구 정정 (현 cycle 은 MASTER_DIR env override 로 우회 박음 · 별 trail `MASTER-DIR-REBIND-CLAUDE-CLI-MASTER-TO-GENTLY-MASTER-001`)
- [ ] `propagate.sh` WARN "보호 파일 baseline 변경 감지" false positive RCA + 정정 (보호 파일 4종 실측 무변경 confirm 한 cycle 에서 WARN 발화 patterns)
- [ ] GD 측 Auth 도메인 활성화 (UNKNOWN → ACTIVE) — `deferred-domains.md` §4 절차 + `auth-rules.md` SoT 채택
- [ ] GB 측 Auth 도메인 활성화 (UNKNOWN → ACTIVE) — `deferred-domains.md` §4 절차 + `auth-rules.md` SoT 채택
- [ ] OAuth Phase 2 (Google / Kakao) 별 trail (자연 trigger = 사용자 요청 시 진입)

## Follow-up (post-correction step 11)

- [x] `decision-log.md` close entry append (cycle 마감 박음 · `MASTER-DIR-REBIND` trail close) — 2026-05-03 박힘
- [~] `cycle-handoff.md` baseline rolling rewrite — 파일 부재 (master 미신설). 별 trail (lazy · 신설 cycle 시점에 도입)
- [x] GT 측 `.ai/reports/GT-AUTH-PIVOT-001/REVIEW.md` close memo append (master cycle 박음 인용 · 자식 close 신호) — 2026-05-03 박힘
- [x] `gently-master/CLAUDE.md` §15 cycle 표 append (MASTER-AUTH-DOMAIN-ACTIVATE-001 row) — 2026-05-03 박힘
- [~] `GentlyTable/CLAUDE.md` §15 또는 동등 위치에 cycle 박음 — N/A: GT CLAUDE.md 는 §15 cycle 표 부재 (자식 = master Nested 패턴 · master CLAUDE.md §15 가 SoT). 자식 측 인지는 GT REVIEW.md close memo + master `deferred-domains.md` §2/§6 (3-repo propagation 박힘) 으로 충족.
