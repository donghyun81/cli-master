## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-AUTH-DOMAIN-ACTIVATE-001 |
| Mode | ops-layer (master cli infra 변경 + 3-repo propagation · `cycle-discipline.md` §15 패턴 3) |
| Workflow | Plan -> Implement -> Verify -> Review (lightweight 4 파일 · `cycle-discipline.md` §11) |
| Requirements Source | `.ai/tasks/MASTER-AUTH-DOMAIN-ACTIVATE-001.md` (원문 prompt: `~/AndroidStudioProjects/GentlyTable/.ai/prompts/MASTER-AUTH-DOMAIN-ACTIVATE-001.md`) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 4 (master 신설/수정) + 4 × 3 (자식 propagation) = 16 file ops |
| Modules | `gently-master/.claude/rules/` + `.claude/agents/` + 3 자식 repo `~/AndroidStudioProjects/{GentlyTable,GentlyDay,GentlyBreath}/.claude/` |
| Risk | Low (ops-layer 정책 박음 · 제품 코드 변경 X · 보호 파일 4종 변경 X) |
| DBMig | No |
| MoneyAuth | Yes (정책 영역 — 본 cycle 자체가 auth 도메인 활성화 cycle · 단 제품 코드 변경 X 정책 신설만) |

## 2~7. (Risk=Low 경량화 · `cycle-discipline.md` §11 + `workflow-core.md` Risk 매트릭스)

N/A — ops-layer task · 제품 코드 변경 X · libs/모델/UseCase/UI 모두 무관.

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| EC1 | `ls /Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/rules/auth-rules.md` exit 0 |
| EC1-2 | `grep -c "ACTIVE" /Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/rules/deferred-domains.md` ≥ 2 |
| EC1-3 | `grep "auth-security-privacy" /Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/rules/routing-and-delegation.md \| grep -v "DEFERRED\|deferred"` ≥ 1 |
| EC1-4 | `ls /Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/agents/active/auth-security-privacy.md` exit 0 |
| EC2 | `shasum -a 256 docs/schemas/ui-spec.schema.json .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/uiux-sot-refresh.md` 4 sha 본 cycle 진입 baseline 동일 (5aa52b23 · 6297080a · 96de2f5d · 1f871447) |
| EC3 | `for r in GentlyTable GentlyDay GentlyBreath; do shasum -a 256 ~/AndroidStudioProjects/$r/.claude/rules/auth-rules.md ~/AndroidStudioProjects/$r/.claude/rules/routing-and-delegation.md ~/AndroidStudioProjects/$r/.claude/agents/active/auth-security-privacy.md; done` 3 sha set byte-identical |
| EC4 | `grep -c "MASTER-AUTH-DOMAIN-ACTIVATE-001" ~/AndroidStudioProjects/GentlyTable/.ai/reports/GT-AUTH-PIVOT-001/REVIEW.md` ≥ 1 (close memo append) |

## 9. RollbackStrategy
ops-layer 변경 (제품 코드 X). 단일 commit 후 `git revert <sha>` 으로 즉시 복구 가능. 자식 repo propagation 도 동일 단일 commit 으로 원자성 보장 → 자식 별 git revert 추가 가능.

## 10. ExternalPrep / DeferredItems
- `scripts/activate-agent.sh` 의 `claude-cli-master` 하드코딩 → 본 cycle 은 `MASTER_DIR=$HOME/AndroidStudioProjects/gently-master bash scripts/activate-agent.sh activate auth-security-privacy` 로 우회. 별 trail `MASTER-DIR-REBIND-CLAUDE-CLI-MASTER-TO-GENTLY-MASTER-001` 박음 (사후 정정).
- `scripts/propagate.sh` 도 동일 default → MASTER_DIR override 으로 우회.
- OAuth Phase 2 / Supabase 서버 사이드 (RLS · edge function · vault) 변경 = 별 cycle 의무 (본 cycle 은 §1 익명 부트스트랩 paradigm 박음만).

## Plan

1. **path rebind 별 trail 박음** — `.auto-memory/decision-log.md` 에 `2026-05-02 MASTER-AUTH-DOMAIN-ACTIVATE-001 path rebind: claude-cli-master → gently-master` append (Coin 명시 승인 박음).
2. **§3-1 신설** — `gently-master/.claude/rules/auth-rules.md` 신설 (§1 익명 부트스트랩 / §2 identity 변동성 경계 / §3 토큰 저장 / §4 AuthRepository / §5 JSON backup / §6 OAuth Phase 2 / §7 STOP trigger / §8 절대 금지 / §9 변경 정책 / §10 박힌 cycle 이력 — prompt §3.1 verbatim).
3. **§3-2 수정** — `gently-master/.claude/rules/deferred-domains.md` §2 표 Auth 행 master + GT = ACTIVE (GD/GB UNKNOWN 유지) + 비고 박음 + §6 history append.
4. **§3-3 수정** — `gently-master/.claude/rules/routing-and-delegation.md` `auth-security-privacy` 라벨 `[DEFERRED]` 제거 + 경로 `active/` + DEFERRED 비활성 목록에서 제거.
5. **§3-4 mv + 본문 갱신** — `gently-master/.claude/agents/deferred/auth-security-privacy.md` 본문 read → `active/auth-security-privacy.md` 으로 Write (auth-rules.md SoT 참조 + STOP 권한 + GT-AUTH-PIVOT-001 박힌 패러다임 인용 박음). `MASTER_DIR=$HOME/AndroidStudioProjects/gently-master bash scripts/activate-agent.sh activate auth-security-privacy` 시도 후 실패 시 manual mv 박음. 이후 `deferred/auth-security-privacy.md` 의 내용은 빈 stub 또는 유지 (본 cycle 은 active/ 만 cp · `rm` 금지 · 자연스러운 정리 별 trail 박음).
6. **§4 propagation** — 4 파일 3-repo cp (deferred-domains.md 의 자식 표는 자식 별 GT=ACTIVE / GD=UNKNOWN / GB=UNKNOWN 박은 별 form 으로 박음). `MASTER_DIR=$HOME/AndroidStudioProjects/gently-master bash scripts/propagate.sh .claude/rules/auth-rules.md .claude/rules/routing-and-delegation.md .claude/agents/active/auth-security-privacy.md` (3 파일 byte-identical) + `deferred-domains.md` 는 manual cp + 자식 표 박음 (단 prompt §145 의 3 자식 활성화 상태 매트릭스 = master 표 박음 + 자식 repo 의 자식 열 별 박음 형태 — 단순화: master 표를 그대로 cp 박음 = master + GT 열 ACTIVE / GD + GB 열 UNKNOWN. 자식 repo 가 자기 표를 본 깐 patterns 박음 — 정합 OK).
7. **EC1~EC4 검증** — VerificationPlan 명령 실행 + 결과 VERIFY.md 박음.
8. **VERIFY.md / REVIEW.md / TODO.md 작성** — Risk=Low 3-section REVIEW (Requirements / Regression / Secrets).
9. **단일 commit 박음** — `feat(rules): MASTER-AUTH-DOMAIN-ACTIVATE-001 auth domain activation + 3-repo propagate` + 6-section body [Goal][Diff][Sha (불변)][EC][Next][Refs]. 각 자식 repo 도 동일 patterns 의 단일 commit (`feat(rules): MASTER-AUTH-DOMAIN-ACTIVATE-001 auth domain activation propagation` body 박음 + Refs master commit hash 인용).
10. **자기 검증** — `git log -1 --format=%s%n%b` 매 commit 직후 (master + 3 자식 = 4 commit).
11. **사후 정정** — `.auto-memory/decision-log.md` cycle close entry append + `cycle-handoff.md` baseline rolling rewrite + GT `~/AndroidStudioProjects/GentlyTable/.ai/reports/GT-AUTH-PIVOT-001/REVIEW.md` (또는 별 close 메모) 의 `## DeferredActivation` 4 항목 STOP 신호 close 박음 (`MASTER-AUTH-DOMAIN-ACTIVATE-001` 인용) + master CLAUDE.md §15 cycle 이력 표 append + `~/AndroidStudioProjects/gently-master/CLAUDE.md` §15 cycle 이력 표 append.

## Notes
- 본 cycle = `cycle-discipline.md` §15 패턴 3 (도메인 활성화 UNKNOWN → ACTIVE).
- 단일 commit 권장 (prompt §8 박힘) — sub-cycle 분할 안 함.
- `rm` 명령 금지 (`safety-and-secrets.md`) → `deferred/auth-security-privacy.md` 의 본문은 active/ 으로 cp 후 deferred/ 본문 빈 stub 으로 정리 검토 (별 trail · 본 cycle 은 active/ 신설만).
- Pencil MCP 본 작업 무관 (보호 파일 4종 변경 X) → Claude Code 2.1.114 pin 검증 생략 (cycle-discipline §13 의 본 작업 한정).
