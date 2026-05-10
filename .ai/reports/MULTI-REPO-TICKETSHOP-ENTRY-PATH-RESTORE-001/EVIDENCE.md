## Requirements Source

`MULTI-REPO-TICKETSHOP-ENTRY-PATH-RESTORE-001` — Cycle 1 (`MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001`) F3 + F12 mitigation. Coin verbatim 채택: option (a) 통합 cycle, 작업 1 (F3 GB) → 작업 2 (F12 GT) → 작업 3 (Billing init graceful fallback) 순차.

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | UI 변경 (mitigation) |
| Reading Mode | UI-UX형 |
| Requirement Source | Coin verbatim (option (a) 채택) |
| Info Gap | RESOLVABLE_IN_REPO |
| STOP Risk | Billing 도메인 STOP 경계 (BillingManager.kt 본질 변경 X) |
| Read-Only Fan-Out | ux-auditor (자동 reading) · billing-payments-guardian (Billing init 진단 영역) |
| Implementer Entry | Allowed |

## Pre-EVIDENCE Contract

- Read evidence: GB SettingsScreen.kt:293 empty TODO onClick · GB MainScaffold.kt SettingsScreen 직접 invocation · GB Destinations.TICKET_PURCHASE 존재 · GT SettingsScreen.kt:186-192 SectionCard(BillingSection) wrapper · GT MainScaffold (간접) → SettingsScreen · GT RootRoutes.TICKET_SHOP 존재 · GT BillingViewModel.connectAndLoad startConnection() Boolean return · GT BillingSection state-driven UI
- Remaining gaps: 없음 (`RESOLVABLE_IN_REPO` 100%)
- Chosen path: 작업 1 → 2 → 3 순차 + STOP 경계 강제 (BillingManager.kt 무변경)
- Hold / Stop reasons: 없음
- Implement entry conditions: 빌드 PASS + STOP 경계 보존

## Collect Results

### 매칭 파일/패턴

- `GentlyBreath/app/src/main/java/com/example/gentlybreath/presentation/profile/SettingsScreen.kt:293` — 기존 empty TODO `onClick = { /* TODO(user-prep)... */ }` (F3 mitigation 대상)
- `GentlyBreath/app/src/main/java/com/example/gentlybreath/presentation/main/MainScaffold.kt:111-119` — Destinations.SETTINGS composable + Destinations.TICKET_PURCHASE composable 존재
- `GentlyBreath/app/src/main/java/com/example/gentlybreath/presentation/navigation/Destinations.kt:18` — `const val TICKET_PURCHASE = "ticket_purchase"` 존재
- `GentlyTable/app/src/main/java/com/example/gentlytable/presentation/settings/SettingsScreen.kt:186-192` — SectionCard(BillingSection 직접 래핑) (F12 mitigation 대상)
- `GentlyTable/app/src/main/java/com/example/gentlytable/presentation/settings/SettingsScreen.kt:174-182` — NavCard 미러 reference (AI section)
- `GentlyTable/app/src/main/java/com/example/gentlytable/presentation/main/RootNavGraph.kt:64-77` — MainScaffold composable invocation (4 callbacks)
- `GentlyTable/app/src/main/java/com/example/gentlytable/presentation/main/RootNavGraph.kt:99-101` — `composable(RootRoutes.TICKET_SHOP) { TicketShopRoute() }` 존재
- `GentlyTable/app/src/main/java/com/example/gentlytable/presentation/main/MainScaffold.kt:86-92` — SettingsScreen 간접 invocation
- `GentlyTable/app/src/main/java/com/example/gentlytable/presentation/billing/BillingViewModel.kt:42-53` — `connectAndLoad()` startConnection Boolean → 진단 추가 site
- `GentlyTable/app/src/main/java/com/example/gentlytable/presentation/billing/BillingSection.kt:53-72` — `state.products.forEach` graceful fallback site

### 0 Matches (부재 증거)

- 없음

## Key Findings

- F3 GB: SettingsScreen → MainScaffold → Destinations.TICKET_PURCHASE 와이어 path 단순 (직접 invocation)
- F12 GT: RootNavGraph → MainScaffold → SettingsScreen 와이어 path (3-hop) — MainScaffold 가 SettingsScreen 의 caller 인 indirection 처리 의무
- 작업 3: BillingViewModel `startConnection()` Boolean return → responseCode 직접 노출 X · `Log.w(TAG, ...)` 진단으로 충분 · graceful fallback = `state.connected == false && state.products.isEmpty()` 조건에 "Coming soon" 표시

## Cleanup Assessment

### 발견된 후보

| 위치 | 설명 | 판정 |
|---|---|---|
| `GentlyTable/.../settings/SettingsScreen.kt:43` | `import com.example.gentlytable.presentation.billing.BillingSection` (F12 후 미사용) | 즉시 제거 (직접 인접 + 명백 미사용) |

### 점검 명령

`grep -n "BillingSection" /Users/yundonghyeon/.../settings/SettingsScreen.kt` — 0 matches (after cleanup)

### 판정 요약

- 즉시 제거: 1건 (BillingSection import · F12 후 dead import)
- deferred: 0건
- task-level STOP: 0건
