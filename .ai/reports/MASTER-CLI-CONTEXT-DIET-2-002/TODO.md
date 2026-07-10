# TODO — MASTER-CLI-CONTEXT-DIET-2-002 (후속 · scope 외)

## 잔여 블로커: 없음 (DONE)

## Follow-up 후보 (별 cycle / 사용자 영역)

1. **T3 재검토 — skill-layer path-scoping 이관**: rule-layer `paths:` 는 미확인/회귀 risk 로 skip. 그러나 skill-layer `paths:` = **작동 확인**(5 skill scoped). pencil/supabase 관련 항목의 path-scoping 을 (rule 이 아닌) **skill frontmatter** 로 이관하는 것이 실효 경로. + rule-loading 기전 규명(frontmatter/@import 0 인데 49 전량 주입 → 어떤 mechanism 인지) = 별 조사 cycle.
2. **T7b — settings.local.json prune (bypass 확인 후)**: 부모 root 257 one-shot allow prune 은 **부모 root/user-global bypassPermissions 확인 후**에만 안전. 확인되면 archive 백업 + prune. 미확인 = 현행 보류 유지(re-prompt flow 파괴 risk).
3. **T7d — working-file-archiver daemon 재활성**: `com.coin.working-file-archiver` = loaded-but-inactive(status `-`) → cc-paste 103 backlog 원인. `launchctl load ~/Library/LaunchAgents/com.coin.working-file-archiver.plist` (= 사용자 영역 · git-lock-cleaner daemon 과 동반) → policy(mtime 7d) 기반 자동 sweep 복구. (cc-paste 는 최근 8일 working file = 지금 blanket-move 부적절.)
4. **§15 hot 14 > 10 — 9회차 cold 재이전 advisory**: `measure-gsm-cycle.sh` §15 hot check 가 새 cycle commit 감지 시 자동 surface. 이전(demote) = 수동 별 cycle (COLD-002 전례 · 무손실 verbatim).
5. **stale_pointer 3 식별**: measure-gsm auto-scan = 3 (§2 manual "0 genuine" 과 불일치 · 본 cycle 무관 pre-existing · mode-system 편집 0 기여). 3 건 식별 + genuine/의도적-deprecated-예시 분류 = 별 hygiene cycle.
6. **git-lock-cleaner daemon launchctl load**: verify-sync advisory 재발화(매 cycle). 사용자 영역.
7. **부모 root §4 billing UNVERIFIED**: 본 cycle 병기 완료(T1). master rule 측(kernel §2.4 · A6 등)은 001-T7 에서 이미 병기.
