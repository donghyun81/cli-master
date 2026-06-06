---
agent-commit: yes
---

# cc-paste-MASTER-PRELAUNCH3-SMALLFIX-001 — master 소형 정정 4건 + verify-sync MISS 처분 (M5)

## §0 baseline anchor (A1)
- repo: `/Users/yundonghyeon/AndroidStudioProjects/claude-cli-master`
- HEAD 박제: `3ab5e93` (2026-06-05 15:06 KST cowork 재측정)
- ⚠ 5REPO-PUSH-001 진행 중 — master 측 housekeeping commit 으로 HEAD 전진 가능 = 정상. 진입 첫 step = HEAD + dirty 재측정 의무.
- 기존 dirty 잔재 (incident-log M · archive paste ×2 · propagation-status M) = PUSH-001 영역 = 본 cycle 무접촉 (단 PUSH-001 이 먼저 마감했으면 dirty 0 기대).

## §1 cycle 본질
- **Mode: M5 cli-infra-ops** (production code 무접촉).
- 도메인 키워드 측정: Money 어휘 출현 = ①번 billing-rules.md **doc 문구 정정 한정** (결제 코드/EF/DB 무접촉 → STOP #1 비발동 · 단 §6 참조). Auth/Data/Backend/Perf = 해당 없음.
- 본질: EXEC2 side-finding 누적 소형 4건 + cowork verify-sync 실측 MISS 1건 처분.

## §2 scope
변경 (5건):
1. `.claude/rules/billing-rules.md` §5 (L54) — "GT 의 한입 티켓" → disk 진실 정정. 실측: `rest_tickets` 실 구현 = **GB** (GB `docs/setup/01_gb_supabase_ddl.sql` 외 5 file 실재 · GT = 해당 테이블 무). §5 주어/예시 = GB 정합 + 도메인 일반화 (3 자식 공통 rule 본질 유지).
2. `.claude/hooks/check-abbreviation.sh` — policy `abbreviation-policy.md` **§3.8 (L349 프레임워크/라이브러리 API 명 자동 포함)** 이 hook 측 미구현 → Play SDK 타입명 false-block ×2 실측. hook 에 §3.8 whitelist 반영.
3. "6-repo" 어휘 → 5-repo 통일. 실측 출현: (a) `.auto-memory/anchor-list-COLD.md` L39 A12 anchor 제목 (b) FND `core/CLAUDE.md` L4 "6-repo ecosystem" (c) `docs/release-readiness/PACKAGE-OVERVIEW.md` L68/L123 = 역사 기록 성격 → 처분 판단 cli 자율 (d) master `CLAUDE.md` §15 entry = history **불변·무접촉**.
4. `scripts/save-as-result-check.sh` L41-42 — `/Users/yundonghyeon/...` 절대경로 하드코딩 → `scripts/repo-config.sh` source 통합 (`PARENT_DIR` 활용).
5. `docs/agent/audits/TESTING-BACKFILL-AUDIT.md` — cowork verify-sync 직접 실행 실측 = PASS 160 / DRIFT 0 / **MISS 4** (본 file × 4 자식 부재). 처분 = propagate 또는 sync 매트릭스 제외 판단 + 집행.

무접촉: production code 전체 · 보호 강제 byte-identical 영역 (변경 대상 아님 — 단 manifest 직접 grep 재확인 의무) · master CLAUDE.md §15 기존 entry · 자식 repo 직접 수정 (propagation 경유만).

## §3 contract SoT (disk 측정 인용)
- check-abbreviation.sh = `.auto-memory/protected-file-hashes.md` 측 **advisory sha 기록 영역** (강제 5종 아님 · 실측 L77/L87) → 변경 시 advisory sha 갱신 정합.
- rule/hook/scripts 변경 = 항목별 propagation 의무 측정 (`bash scripts/propagate.sh <path> --targets all` + `verify-sync.sh`). verify-sync 실행 시 `PARENT_DIR` 기본값 = `$HOME/AndroidStudioProjects` (로컬 = 그대로 동작).
- FND `core/CLAUDE.md` L4 정정 = FND repo 측 1-line — **bash 한정 접촉** (sed/직접 편집 · 타 repo Read tool 금지) + FND 별도 commit.

## §4 변경 step — 보호 강제 file 무접촉 예정. manifest grep 재확인 후 강제 5종 접촉 발견 시 = STOP #5 절차.

## §5 §FREEDOM
구현 방식/순서/commit 분할/§3.8 whitelist 구현 형태/6-repo 어휘 처분 세부 (A12 anchor 제목 vs 본문 의미 보존 방식)/PACKAGE-OVERVIEW 역사 기록 처분/MISS 처분 (propagate vs 매트릭스 제외) = cli session 자율.

## §6 STOP (master `CLAUDE.md §5` 9항 + 본 cycle 특이)
- 보호 강제 5종 sha drift 발견 · scope expansion (소형 4+1건 외 발견 영역 = 보고만) · billing-rules 정정이 doc 넘어 코드/EF 영향 경로로 번질 징후 (STOP #1) · 비가역 (file 삭제 등).

## §7 paste-back 규약
- 항목별 결과 표 (commit sha + 변경 file + propagation 여부/결과) + verify-sync 최종 수치 (PASS/DRIFT/MISS) + advisory sha 갱신 여부.
- 말미 1줄: "고려했으나 hot 제외 영역: <...>" (없으면 "(없음)").

## §8 cli 자체 결정 권한
STOP 9항 외 전부 자율. 항목 간 의존 없음 — 순서 자유. 5REPO-PUSH-001 미마감 잔재 발견 시 = 본 cycle 과 분리 유지 (혼합 commit 금지).

## §9 진입 prompt
```
cd ~/AndroidStudioProjects/claude-cli-master && claude
첫 message: cc-paste-MASTER-PRELAUNCH3-SMALLFIX-001.md (repo root) 전문 정독 후 M5 cli-infra-ops 로 cycle 진입.
첫 step = HEAD/dirty 재측정 (박제 3ab5e93 · PUSH-001 전진 = 정상). 타 repo file = Read tool 금지 (bash 만).
```

## §10 Refs
`billing-rules.md` · `abbreviation-policy.md §3.8` · `scripts/repo-config.sh` · `.auto-memory/protected-file-hashes.md` · `anchor-list-COLD.md` · master `CLAUDE.md §15` FND-DOCSYNC entry (side-finding 출처).

## §11 발행 직전 재측정: 2026-06-05 15:06 KST · master `3ab5e93` · verify-sync 160/0/4 (MISS = TESTING-BACKFILL-AUDIT.md ×4) · cowork 직접 실행 실측.
