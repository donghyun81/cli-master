## Meta
| 항목 | 값 |
|---|---|
| TaskId | MASTER-AUTH-DOMAIN-ACTIVATE-001 |
| Created (KST) | 2026-05-03 00:00 |
| Status | PLAN |
| Risk | Low |
| DBMig | No |
| MoneyAuth | Yes (정책 영역 — auth governance rule 신설 · 제품 코드 변경 X) |

## 원문 요구사항
출처: `~/AndroidStudioProjects/GentlyTable/.ai/prompts/MASTER-AUTH-DOMAIN-ACTIVATE-001.md` (cowork 작성 · 2026-05-02).

GT-AUTH-PIVOT-001 cycle (2026-05-02 마감 · GT commit ae5e04d) 박힌 auth 패러다임을 master 측 정책 파일에 코드화 + `auth-security-privacy` 도메인 활성화 (UNKNOWN → ACTIVE) + 3-repo (GT/GD/GB) propagation. `deferred-domains.md` §4 활성화 절차 정합.

진입 path rebind 박음 (Coin 명시 승인 · 2026-05-02): prompt 의 모든 `claude-cli-master` 경로 = `gently-master` 로 치환. `.auto-memory/decision-log.md` 사후 정정 의무.

## 분해된 문제 진술
1. **신설**: master `.claude/rules/auth-rules.md` (GT-AUTH-PIVOT-001 박힌 패러다임 § 1-10 코드화).
2. **갱신 (표)**: master `.claude/rules/deferred-domains.md` §2 표 → Auth 행 master + GT 열 `UNKNOWN` → `ACTIVE` (GD/GB 유지) + §6 변경 이력 append.
3. **갱신 (라벨)**: master `.claude/rules/routing-and-delegation.md` → `auth-security-privacy` 행 `[DEFERRED]` 라벨 제거 + 경로 `deferred/` → `active/` + DEFERRED 비활성 목록에서 제거.
4. **mv (agent)**: `.claude/agents/deferred/auth-security-privacy.md` → `.claude/agents/active/auth-security-privacy.md` + 본문 갱신 (auth-rules.md SoT 참조).
5. **propagation**: 4 파일 모두 3-repo (GT/GD/GB) byte-identical 복사. 단 `deferred-domains.md` §2 표는 자식 repo 별 도메인 활성화 상태 (GT=ACTIVE / GD=UNKNOWN / GB=UNKNOWN) 박음 — master 표는 master 만 ACTIVE 박음 (자식 repo 표는 자식 repo 의 자식 열 ACTIVE 박는 form 으로 별 파일).

## 성공 조건
- master `.claude/rules/auth-rules.md` 신설 + § 1-10 모두 박힘.
- master `.claude/rules/deferred-domains.md` §2 Auth 행 master + GT = ACTIVE / GD + GB = UNKNOWN 박힘 + §6 history append.
- master `.claude/rules/routing-and-delegation.md` `auth-security-privacy` 라벨 `[DEFERRED]` 제거 + 경로 `active/` + DEFERRED 비활성 목록 제거.
- `.claude/agents/active/auth-security-privacy.md` 박힘 (mv) + 본문 auth-rules.md SoT 참조 박힘.
- 3-repo (GT/GD/GB) 의 4 파일 모두 byte-identical (deferred-domains.md 의 자식 열 차이 박은 patterns 검토).
- 보호 파일 4종 sha 무변화.
- GT-AUTH-PIVOT-001 측 `## DeferredActivation` 4 항목 STOP 신호 close 메모 박힘.
- 단일 commit (`feat(rules): MASTER-AUTH-DOMAIN-ACTIVATE-001 ...`) 박힘 + 6-section body.

## Measurable Exit Criteria
- [ ] **EC1**: `ls /Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/rules/auth-rules.md` exit 0 + `grep -c "ACTIVE" /Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/rules/deferred-domains.md` ≥ 2 (master + GT) + `grep "auth-security-privacy" /Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/rules/routing-and-delegation.md | grep -v DEFERRED` 1 line 이상 + `ls /Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/agents/active/auth-security-privacy.md` exit 0
- [ ] **EC2**: `shasum -a 256 docs/schemas/ui-spec.schema.json .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/uiux-sot-refresh.md` 4 sha 본 cycle 진입 baseline 과 동일
- [ ] **EC3**: `for r in GentlyTable GentlyDay GentlyBreath; do shasum -a 256 ~/AndroidStudioProjects/$r/.claude/rules/auth-rules.md ~/AndroidStudioProjects/$r/.claude/rules/routing-and-delegation.md ~/AndroidStudioProjects/$r/.claude/agents/active/auth-security-privacy.md; done` 3 sha set 동일 (auth-rules.md / routing-and-delegation.md / agent file). `deferred-domains.md` 는 자식 열 차이 검토.
- [ ] **EC4**: GT `~/AndroidStudioProjects/GentlyTable/.ai/reports/GT-AUTH-PIVOT-001/REVIEW.md` (또는 별 close 메모) 에 `## DeferredActivation` close 박음 (`MASTER-AUTH-DOMAIN-ACTIVATE-001` 인용)

## 비기능 요구사항
- master ↔ 3-repo cli infra 단방향 propagation 정합 (`cycle-discipline.md` §3 §15 패턴 1).
- 보호 파일 4종 변경 X (본 cycle 은 신설 + 비보호 파일만).
- 자식 repo 직접 수정 금지 (master cycle 으로 신설 → propagation).
- 단일 commit + 6-section body (`cycle-discipline.md` §6~9).

## 불확실성 (UNKNOWN)
- `scripts/activate-agent.sh` 가 `MASTER_DIR=$HOME/AndroidStudioProjects/claude-cli-master` 하드코딩 박힘 → 본 cycle 은 MASTER_DIR override 또는 수동 mv (Edit + Write) 으로 우회. `claude-cli-master` → `gently-master` 환경 정합 cycle 별 trail 박음 (사후 정정).
- `scripts/propagate.sh --all` 존재 / 동작 확인 필요 — 부재 시 수동 cp + sha verify 으로 fallback.
