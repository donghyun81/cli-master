# TODO — MASTER-CLI-CONTEXT-DIET-2-003

## Deferred (follow-up · 본 cycle scope 외)
- **stale_pointer 3 (`docs/agent/solutions/README.md`)**: `routing-and-delegation.md`:251/268 + `domain-roles.md`:78 — 이동 대상 무관(README = 의도적 부재 file · domain-roles 는 "부재 file" 명시). 해소 = 내용 판단(teams-detail 대상 결정) = STOP#3 경계 → **defer**. 이동 후 `.claude/rules/` stale-scan scope 이탈 → measure-gsm 값 0 (moved file = docs/rules/ · 미scan). 별 cycle 판단.
- **pre-existing stale ref (deleted file)**: `.claude/rules/workflow.md`(현 `workflow-core.md`) + `.claude/rules/evidence-and-reporting.md`(현 `reporting.md`) — docs/agent/architecture/* + docs/backend + scripts/README 잔존. 이동 무관(삭제된 file 참조) · rename 매핑 = 내용 판단 → 별 cycle. 본 cycle subst_moved = 현존 44 basename 한정이라 무접촉(정상).
- **test-protected-file-hooks.sh #1/#2**: InstructionsLoaded hook 이 additionalContext 를 stdout 발행 → 테스트 `F1_EXIT=$(...; echo $?)` 가 stdout+exit 혼동 → assertion FAIL. path-independent(내가 미변경한 캡처 로직) · pre-existing. 기능 무결(real master drift 0 · #3/#4/#5 PASS). 테스트 하네스 캡처 수정 = 별 cycle.
- **manifest 비-active `.claude/rules/<moved>` 잔존 4**(descriptive/history 섹션 44/53/95+): active row 14/16/63 만 갱신 · history verbatim 보존. 정합.
- **measure-gsm ch_l0 정의**: 잔존 3 file(safety/anchor/cross-repo) 합 유지 · 잔존 5 전체(+table+footer) 반영 확대 = 지표 정의 변경 → 별 판단(무변경 default).
- **context-health / cycle-health / gsm-dashboard**: cli-infra 아닌 master-only metric doc — 자식 propagation X.

## Deferred (본 cycle 사고 → 후속)
- **프로브 B 신 세션 확증**: 다음 `claude` 진입 시 `/context` 또는 probe 로 `.claude/rules` 주입 = 5-kernel 감축 확인 (in-session 미확증 = 세션 시작 1회 로드 기전).
- **propagate.sh docs/ops exclude 부재**: `--all` 이 `docs/ops/production-cli-access-tokens.md`(문서화 master-only)를 자식에 유입 → 본 cycle 자식 surgical rm 복원. 근본 = propagate.sh find 에 `! -path 'docs/ops/*'` 추가(release-readiness/agent-audits 선례) = 별 cycle.
- **GD 동시 세션**: GD-PEN-BACKSTOP-001 도메인 커밋 2개 유입(cli-infra 무접촉 · e9494bc 무결) = 영역 2 다중 세션 정상 · 조율 불요.
- **.auto-memory 서술 stale-ref (non-blocking)**: verify-sync advisory 5(manifest 44/45 descriptive + cycle-history-log 100 + propagation-status 8 historical commentary) = 이력/서술 prose · verbatim 보존 default · 별 판단.

## 잔여 블로커
- 없음. §15 hot 15>10 = **S15-HOT-DEMOTE-005** advisory (measure-gsm Stop hook 자동 surface · 별 cycle).
