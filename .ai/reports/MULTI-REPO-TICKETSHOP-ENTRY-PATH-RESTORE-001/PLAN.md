## GATESv2

| Field | Value |
|---|---|
| TaskId | MULTI-REPO-TICKETSHOP-ENTRY-PATH-RESTORE-001 |
| Mode | UI mitigation (F3 + F12 + Billing init graceful) |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | Coin verbatim option (a) 채택 |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 7 (GB 2 + GT 5) |
| Modules | GB `app/src/main` · GT `app/src/main` |
| Risk | Medium (UI 와이어 + Billing init 진단) |
| DBMig | No |
| MoneyAuth | No (BillingManager.kt 본질 무변경 · STOP 경계 보존) |

## 2. DependencyDecision

N/A (libs.versions.toml 변경 없음).

## 3. ArchitectureImpact

- 새 인터페이스/추상화: N/A
- 변동성 경계 유형: N/A (기존 Compose 표준 컴포넌트 + ViewModel 단방향)
- 레이어 누수 위험: 없음
- shared-first 경계 영향: N/A (KMP 미도입)

## 4. ModelBoundaryPlan

- DTO 변경: N/A
- Entity 변경: N/A
- DomainModel 변경: N/A
- UiState 변경: N/A (기존 BillingUiState 그대로 + 기존 SettingsUiState 그대로)
- 경계 매핑 추가/변경: N/A
- I2 import 방향 영향: 없음

## 5. ErrorPolicy

- typed Result 사용 여부: N/A (기존 BillingUiState.errorMessage 활용)
- 오류 모델: N/A
- 기존 코드 교체 범위: 없음 (Log.w 진단만 add)

## 6. UIStateFlowPlan

- UiState 변경: 없음 (기존 fields 활용)
- ViewModel 단방향 흐름 유지: PASS (Log.w 진단 추가 · UI 흐름 무변경)
- SharedUiState<T> 변형 사용: N/A

## 7. TestabilitySeams

- 테스트 파일: N/A (기존 동작 보존 · 신규 동작 X)
- FakeXxx 사용: N/A
- 심 주입 대상: N/A (Log.w 직접 호출 · android.util.Log 는 testability seam 후보 lazy)
- 심 연기 시 명시적 사유: Log 진단은 best-effort observability + 기존 BillingViewModel 패턴 정합

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | `cd GentlyBreath && ./gradlew assembleDebug` + `cd GentlyTable && ./gradlew assembleDebug` |

## 9. RollbackStrategy

- 롤백 가능 지점: GB HEAD commit + GT HEAD commit 각각 `git revert <sha>`
- 롤백 조건: 빌드 깨짐 또는 nav 사고 발견 시
- 복구 경로: revert 후 PLAN 재작성 + Coin 재승인

## 10. ExternalPrep / DeferredItems

- 연기 항목: BillingManager.kt INAPP/consumeAsync/startConnection 본질 변경 (별 cycle · Coin 명시 승인 의무)
- user-prep 선행 조건: Google Play Billing 테스트 환경 + Supabase Edge Function VerifyPurchaseUseCase 외부 prep
- stub/TODO(user-prep) 위치: BillingViewModel `Log.w` 진단 자체가 lazy diagnostic stub

## Plan

1. 작업 1 (F3 GB): SettingsScreen.kt 에 `onNavigateToTicketPurchase: () -> Unit` 파라미터 추가 + `SettingsContent` 까지 thread + line 293 empty TODO `onClick = onNavigateToTicketPurchase` 교체. MainScaffold.kt 에서 `Destinations.TICKET_PURCHASE` navigate 콜백 wire.
2. 작업 2 (F12 GT): SettingsScreen.kt 에 `onOpenTicketShop: () -> Unit` 추가 + SettingsContent thread + 186-192 SectionCard(BillingSection) → NavCard 패턴 (icon "💳", title `settings_section_subscription`, subtitle `"보유: ${state.ticketCount}한입"`, onClick = onOpenTicketShop). MainScaffold.kt + RootNavGraph.kt 통과 wire (`RootRoutes.TICKET_SHOP`).
3. 작업 3 (Billing init 진단): BillingViewModel.kt `connectAndLoad()` 에 `Log.w(TAG, "startConnection failed - billing service unavailable")` 추가 (BillingManager.kt 무변경). BillingSection.kt 에 `state.connected == false && state.products.isEmpty()` graceful "Coming soon" fallback Text 추가.
4. cleanup: GT SettingsScreen.kt `BillingSection` import 제거 (F12 후 dead import).
5. verify: GB + GT 양쪽 `./gradlew assembleDebug` exit 0 확인.
6. commit: GB + GT 각각 selective stage (app/src/main/** 한정 · 무관 변경 제외).

## Notes

- STOP 경계 (재명시): BillingManager.kt INAPP/consumeAsync/startConnection 본질 = 변경 X. 보호 파일 5종 + cli infra 6종 sha = 변경 X. F3/F12/Billing-init-graceful 외 영역 정정 = STOP. 실 결제 dialog 진입 = STOP.
- 무관 변경 (decision-log.md / incident-log.md / Phase4_PartA_Audit_Summary.md 삭제) = 본 cycle 미스코프 (별 cycle 처리).
