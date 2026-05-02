---
name: uiux-sot-refresh
description: Use to refresh .ai/uiux-sot/latest/ baseline (FULL/PARTIAL/DOC-ONLY) when UI touched files match refresh triggers.
---

# Skill: uiux-sot-refresh

## Usage

```
/uiux-sot-refresh <UI/UX baseline refresh requirement>
```

또는 자연어로:

```
"현재 UI 기준으로 latest baseline을 다시 갱신해줘"
"seed audit는 lineage only로 두고 latest-only UI evidence package를 refresh해줘"
"UI 변경 후 baseline manifest와 route inventory를 다시 맞춰줘"
```

## What This Skill Does

이 스킬은 `.ai/uiux-sot/` 아래 latest-only UI/UX evidence companion package를 current live code 기준으로 갱신한다.

- current live code 우선
- semantic layer는 interpretation-only
- seed audit lineage only
- `latest/` 1개만 유지
- history는 git diff 사용
- runtime capture 불가 시 `BASELINE_PENDING_REFRESH` 유지

## Required Read Order

1. `CLAUDE.md`
2. `.claude/rules/uiux-sot-refresh.md`
3. `.ai/uiux-sot/semantic/README.md`
4. `.ai/uiux-sot/latest/manifest.md`
5. `.ai/uiux-sot/refresh/TRIGGERS.md`
6. `<APP_ROUTES>`
7. `<APP_ROOT_COMPOSABLE>`
8. `<APP_ROOT_STATE>`
9. relevant screen files
10. iOS shell files if needed
11. `.ai/uiux-sot/lineage/seed_audit_reference.md`

> Placeholder resolution: `<APP_ROUTES>` / `<APP_ROOT_COMPOSABLE>` / `<APP_ROOT_STATE>` 는 `.claude/rules/uiux-sot-refresh.md` "Authoritative Read Order" 의 토큰 규칙을 따른다.

## Guardrails

- `.ai/reports/` 는 task history only
- `.ai/reports/SW-UX-EMU-AUDIT-001/ux/**` 는 latest baseline이 아님
- semantic docs는 current runtime proof를 대체하지 않음
- `snapshots/` 같은 누적 이력 구조 금지
- verify 없이 종료 금지
- 보고 순서: `[EVIDENCE] -> [DIFF] -> [LOG]`
- auth / billing / money / DB migration / secret / unexpected system state 감지 시 `STOP`
