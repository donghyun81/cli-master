## Meta
| 항목 | 값 |
|---|---|
| TaskId | MASTER-GB-AUTH-ACTIVATE-001 |
| Created (KST) | 2026-05-11 |
| Status | PLAN |
| Risk | Low |
| DBMig | No |
| MoneyAuth | Yes (정책 영역 — Auth 도메인 활성화 · 제품 코드 미변경) |

## 원문 요구사항
GB Auth 도메인 활성화 (UNKNOWN → ACTIVE) — `deferred-domains.md` §4 패턴 3 (도메인 활성화 절차) 정합. GB Phase 2 Auth 진행 baseline (Supabase Auth 익명 부트스트랩 + EncryptedSessionStore) 의 master 측 매트릭스 반영. `auth-rules.md` SoT 재사용 (MASTER-AUTH-DOMAIN-ACTIVATE-001 신설본 그대로 · GB-applicable 검증).

## 분해된 문제 진술
1. **갱신 (매트릭스)**: master `.claude/rules/deferred-domains.md` §2 Auth 행 → GB 열 `UNKNOWN` → `ACTIVE` (GD 유지) + footnote 추가 (GB-specific Phase 2 baseline) + §6 history append.
2. **확인 (routing)**: master `.claude/rules/routing-and-delegation.md` 의 `auth-security-privacy` 매핑 = 이미 globally active (MASTER-AUTH-DOMAIN-ACTIVATE-001 2026-05-02 적용 후 [DEFERRED] 라벨 부재). 본 cycle 안 추가 수정 X · 사실 명시만.
3. **확인 (auth-rules)**: master `.claude/rules/auth-rules.md` READ-ONLY · GB-applicable 검증 (§1 Supabase 익명 부트스트랩 + §3 EncryptedSharedPreferences = GB-PHASE-2-AUTH 패러다임 match). 변경 X.
4. **propagation**: deferred-domains.md 만 4-repo (GB/GD/GT/FND) byte-identical 복사.
5. **drift cross-check**: incident-log.md L40 "GB SteadyWell propagation 잔존 drift" entry 본 cycle 마감 정합 명시 (C4 baseline 채택 후 활성화 완성).

## 성공 조건
- master `deferred-domains.md` §2 Auth 행 GB = ACTIVE 박힘 + footnote 추가됨 + §6 history append.
- master `routing-and-delegation.md` 변경 X (이미 globally active 검증 결과 명시).
- master `auth-rules.md` 변경 X (GB-applicable 검증 PASS).
- 4-repo (GB/GD/GT/FND) deferred-domains.md byte-identical (verify-sync 통과).
- 보호 파일 5종 sha 무변화.
- `.auto-memory/decision-log.md` 본 cycle entry append.
- `.auto-memory/protected-file-hashes.md` Recent updates 본 cycle 영역 외 (sha 변동 0) 명시.
- 5 commits (master 1 + 자식 4) 박힘 + 6-section body.

## Measurable Exit Criteria
- [ ] **EC1**: `grep "^| Auth" /Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/rules/deferred-domains.md | grep -c ACTIVE` ≥ 3 (master + GT + GB) — GD 만 UNKNOWN.
- [ ] **EC2**: `bash scripts/verify-sync.sh` exit 0 + DRIFT 0 + MISS 0.
- [ ] **EC3**: 보호 파일 5종 sha 본 cycle 진입 baseline 과 동일 (변동 0).
- [ ] **EC4**: 4-repo `deferred-domains.md` shasum 동일.
- [ ] **EC5**: 5 commit 모두 `git log -1 --format=%s` 가 prompt subject 형식 정합.

## 비기능 요구사항
- master ↔ 4-repo cli infra 단방향 propagation 정합 (`cycle-discipline.md` §3 §15 패턴 3).
- 보호 파일 5종 변경 X.
- 자식 repo 직접 수정 금지.
- 6-section body (`cycle-discipline.md` §7).

## 불확실성 (UNKNOWN)
- routing-and-delegation.md 의 `auth-security-privacy` 매핑 = 이미 globally active (MASTER-AUTH-DOMAIN-ACTIVATE-001 적용 후) — prompt 의무 vacuous · EVIDENCE.md §Key Findings 명시.
