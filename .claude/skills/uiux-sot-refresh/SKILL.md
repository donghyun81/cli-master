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

## 무엇을 읽어야 하는가 (= 순번 강제 X · 판단 위임)

**필수 2** (= 이걸 안 읽으면 판정 자체가 안 선다):

1. `docs/rules/uiux-sot-refresh.md` — refresh trigger 분류(FULL / PARTIAL / DOC-ONLY) + "Authoritative Read Order" 토큰 규칙 (= 보호 rule · 본 skill 의 판정 SoT)
2. `.ai/uiux-sot/latest/manifest.md` — 현 baseline 이 무엇을 담고 있는지 (= 무엇이 갱신 대상인지 판정하는 기준선)

**분류 결과에 따라 여는 것** (= 전량 열기 금지 · 해당분만):

| 분류 | 추가로 여는 것 |
|---|---|
| DOC-ONLY | `.ai/uiux-sot/refresh/TRIGGERS.md` (분류 근거 기록용) |
| PARTIAL | 위 + 변경된 screen file + 그 화면의 route/state 진입점 |
| FULL | 위 + app routes / root composable / root state 전량 + iOS shell (해당 시) + `.ai/uiux-sot/semantic/README.md` |

> 구 판은 11 항 고정 순번을 강제했다 (`CLAUDE.md` → … → `lineage/seed_audit_reference.md`). 그 목록은 **FULL 기준**이라 DOC-ONLY 한 건에도 11 개를 다 열게 만들었고, `CLAUDE.md` 는 어차피 자동 주입이라 순번에 넣을 이유가 없었다. 분류가 먼저고 읽기 범위는 그 결과다 (= `CLAUDE.md §9` Context Hygiene · just-in-time).
> 계보 대조가 필요할 때만 `.ai/uiux-sot/lineage/seed_audit_reference.md`. 경로 토큰(`<APP_ROUTES>` 등) 해석 = 위 보호 rule 의 토큰 규칙.

## Guardrails

- `.ai/reports/` 는 task history only
- `.ai/reports/SW-UX-EMU-AUDIT-001/ux/**` 는 latest baseline이 아님
- semantic docs는 current runtime proof를 대체하지 않음
- `snapshots/` 같은 누적 이력 구조 금지
- verify 없이 종료 금지
- 보고 순서: `[EVIDENCE] -> [DIFF] -> [LOG]`
- auth / billing / money / DB migration / secret / unexpected system state 감지 시 `STOP`
