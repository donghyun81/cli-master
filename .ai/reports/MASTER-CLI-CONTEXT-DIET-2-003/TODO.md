# TODO — MASTER-CLI-CONTEXT-DIET-2-003

## Deferred (follow-up · 본 cycle scope 외)
- **stale_pointer 3 (`docs/agent/solutions/README.md`)**: `routing-and-delegation.md`:251/268 + `domain-roles.md`:78 — 이동 대상 무관(README = 의도적 부재 file · domain-roles 는 "부재 file" 명시). 해소 = 내용 판단(teams-detail 대상 결정) = STOP#3 경계 → **defer**. 이동 후 `.claude/rules/` stale-scan scope 이탈 → measure-gsm 값 0 (moved file = docs/rules/ · 미scan). 별 cycle 판단.
- **pre-existing stale ref (deleted file)**: `.claude/rules/workflow.md`(현 `workflow-core.md`) + `.claude/rules/evidence-and-reporting.md`(현 `reporting.md`) — docs/agent/architecture/* + docs/backend + scripts/README 잔존. 이동 무관(삭제된 file 참조) · rename 매핑 = 내용 판단 → 별 cycle. 본 cycle subst_moved = 현존 44 basename 한정이라 무접촉(정상).
- **test-protected-file-hooks.sh #1/#2**: InstructionsLoaded hook 이 additionalContext 를 stdout 발행 → 테스트 `F1_EXIT=$(...; echo $?)` 가 stdout+exit 혼동 → assertion FAIL. path-independent(내가 미변경한 캡처 로직) · pre-existing. 기능 무결(real master drift 0 · #3/#4/#5 PASS). 테스트 하네스 캡처 수정 = 별 cycle.
- **manifest 비-active `.claude/rules/<moved>` 잔존 4**(descriptive/history 섹션 44/53/95+): active row 14/16/63 만 갱신 · history verbatim 보존. 정합.
- **measure-gsm ch_l0 정의**: 잔존 3 file(safety/anchor/cross-repo) 합 유지 · 잔존 5 전체(+table+footer) 반영 확대 = 지표 정의 변경 → 별 판단(무변경 default).
- **context-health / cycle-health / gsm-dashboard**: cli-infra 아닌 master-only metric doc — 자식 propagation X.

## 잔여 블로커
- 없음 (T4 propagation + verify-sync 마감 후 DONE).
