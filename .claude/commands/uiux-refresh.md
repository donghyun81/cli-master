---
description: UI/UX SoT baseline refresh 전용 진입점 — FULL/PARTIAL/DOC-ONLY trigger 분류 + .ai/uiux-sot/latest/ 갱신
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Edit
  - Write
---

# uiux-refresh

> Purpose: UI/UX evidence companion baseline(`.ai/uiux-sot/latest/`) 을 현재 live code 기준으로 FULL/PARTIAL/DOC-ONLY trigger 분류에 따라 갱신하는 **진입 커맨드**. 실제 실행 로직·trigger 분류·read order·verify 명령은 skill 과 rule 에 위임한다.

인자: `$ARGUMENTS` — `<trigger-type>` (FULL | PARTIAL | DOC-ONLY) + 선택 `<scope>`

예:
- `/uiux-refresh DOC-ONLY` — package 문서·manifest·route inventory 만 갱신
- `/uiux-refresh PARTIAL settings_screen` — copy/icon/layout 한정 갱신
- `/uiux-refresh FULL` — navigation/route/state authority 변경에 따른 전면 갱신

## Read Order (강제)

다음을 순서대로 read 한 뒤에만 실행한다. 어긋나면 STOP.

1. `CLAUDE.md` (특히 "UI/UX Evidence Companion SoT" 절)
2. `.claude/rules/uiux-sot-refresh.md` — trigger 분류, package boundary, read order, status vocabulary
3. `.claude/skills/uiux-sot-refresh/SKILL.md` — 실제 실행 절차, Placeholder 토큰 매핑, 산출물 목록, STOP 조건
4. `.ai/uiux-sot/refresh/TRIGGERS.md` — FULL/PARTIAL/DOC-ONLY 경계
5. `.ai/uiux-sot/refresh/VERIFY.md` — 권장 verify 명령표
6. `.ai/uiux-sot/latest/manifest.md` — 현재 baseline status

## 역할 분리

| 파일 | 책임 |
|---|---|
| 이 커맨드 (`.claude/commands/uiux-refresh.md`) | 진입점 + 인자 파싱 + read order 강제 |
| `.claude/rules/uiux-sot-refresh.md` | 불변 정책 (package boundary, latest-only, seed lineage, STOP 조건) |
| `.claude/skills/uiux-sot-refresh/SKILL.md` | 실행 절차 (trigger 분기, baseline 갱신, runtime capture, 산출물 생성) |
| `.ai/uiux-sot/refresh/TRIGGERS.md` | trigger 분류 표 |
| `.ai/uiux-sot/refresh/VERIFY.md` | 권장 verify 명령 |

## Verify (최소)

`.ai/uiux-sot/refresh/VERIFY.md` 의 권장 명령 1건 이상 실제 실행 + exit code 기록.
기본 후보:

- `find .ai/uiux-sot -maxdepth 4 -type f | sort`
- `rg -n "BASELINE_PENDING_REFRESH|CURRENT_BASELINE|latest-only|lineage" .ai/uiux-sot`
- `bash scripts/agent/compound-lint.sh <taskId>`
- `git diff --stat -- .ai/uiux-sot CLAUDE.md .claude`

표준 보고 순서: `[EVIDENCE] -> [DIFF] -> [LOG]`.

## STOP

상세 STOP 조건은 `.claude/skills/uiux-sot-refresh/SKILL.md` 와 `.claude/rules/uiux-sot-refresh.md` 를 따른다. 공통 요약:

- auth / billing / money / DB migration / secret / PII 영향
- 예상 외 시스템 상태
- skill 과 본 커맨드의 동작 불일치
- ChangeBudget 초과

## 참조

- 규칙: `.claude/rules/uiux-sot-refresh.md`
- 스킬: `.claude/skills/uiux-sot-refresh/SKILL.md`
- trigger 분류: `.ai/uiux-sot/refresh/TRIGGERS.md`
- 권장 verify: `.ai/uiux-sot/refresh/VERIFY.md`
- baseline package: `.ai/uiux-sot/latest/`
