---
정리위치: archive/
정리trigger: 본 task REVIEW.md PASS 또는 mtime 7일 경과
정리주체: cowork 자율 (또는 사용자 직접)
---

# PLAN — MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001

## GATESv2

| Field | Value |
|---|---|
| TaskId | MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001 |
| Mode | runtime audit (read-only · ops-layer) |
| Workflow | Collect → Plan → (no Implement) → Verify → Review |
| Requirements Source | chat 진입 prompt + `.claude/rules/ux-laws.md` |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 0 (제품 / cli infra 변경 X) — audit 산출물만 |
| Modules | `.ai/reports/MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001/` |
| Risk | Low (read-only) |
| DBMig | No |
| MoneyAuth | No (결제 다이얼로그 진입 직전 정지 의무 — 검출 시 STOP) |

## 2. DependencyDecision

N/A (libs.versions.toml 변경 없음)

## 3. ArchitectureImpact

N/A (코드 변경 없음)

## 4. ModelBoundaryPlan

N/A

## 5. ErrorPolicy

N/A

## 6. UIStateFlowPlan

N/A

## 7. TestabilitySeams

N/A

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | (1) `./gradlew :app:assembleDebug` 3-repo (2) `adb install -r <apk>` 3-repo (3) `adb shell am start -W <pkg>/<launcher>` cold launch (4) `adb exec-out screencap -p` × 46 (5) `adb shell uiautomator dump` × 46 (6) `grep -oE 'text="[^"]*"' <xml>` text 인용 |

> Risk = Low audit task — §1 GATESv2 / §2 ChangeBudget / §9 VerificationPlan + 작업 목록만 필수. 나머지 N/A.

## 9. RollbackStrategy

`git revert <commit>` 또는 `rm -rf .ai/reports/MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001/` (audit 산출물 한정 · 자식 repo 코드 영향 0). 비가역 변경 없음.

## 10. ExternalPrep / DeferredItems

- chat A R3-HANDOFF (Pencil 1.1.56+ release trigger) — out of scope
- chat D TODO 2 (GB paywall · GD TicketScreen) — placeholder 인용만
- GD anon auth 초기화 실패 → 메인 5 화면 진입 BLOCKED — mitigation 별 cycle (UI 변경 X · 서버 / 인증 도메인)
- GB TICKET_PURCHASE / GT TICKET_SHOP `clickable=false` affordance 단절 — mitigation 별 cycle

## Plan

1. **STEP A** — APK build + install (3 repo) ✓
2. **STEP B** — 화면 sequence 자동화 + capture (light + dark) ✓
3. **STEP C** — ux-laws §5 매트릭스 row 적용 + §3 비권장 5 + Dark Patterns 5 detection ✓
4. **STEP D** — SoT (`sot-code-name-map.md`) ↔ runtime cross-verify ✓
5. **STEP E** — EVIDENCE / PLAN / VERIFY / REVIEW / matrix-results.csv 산출 ✓

## Notes

- 본 cycle = read-only audit. F3 / F7 / F8 / F12 mitigation = 별 cycle.
- 자식 repo 코드 / cli infra 모두 미변경.
