# MULTI-REPO-SOT-CODE-NAME-MAP-001 — REVIEW

## 결과
- 매핑 SoT 신설: `claude-cli-master/.claude/rules/sot-code-name-map.md`
- 4-repo cli infra byte-identical 의무 충족 (sha `1e2a2ed1b055`)
- 3-repo (GB / GD / GT) 매핑 표 + 5 카테고리 분류 + 패턴 집계 + STOP 조건 + 갱신 trigger 수록

## 진입 baseline (STEP 0)
- 보호 5 + cli infra 6 (4-repo byte-identical): drift 0 / absent 0 / total 10 ✓
- 3-repo SoT inventory: GB 27 / GD 25 / GT 25
- 3-repo 코드 inventory (`*Screen*.kt`): GB 10 / GD 8 / GT 14

## Coin 결정
1. 매핑 SoT 위치: (a) master 통합 SoT
2. TODO 미확정 row 5 처리: (1) Cowork 코드 진입 분석

## 5 미확정 row 분석 결과
- GB auth-screen → SoT only (`AnonymousAuthBootstrap` 자동 익명 인증, UI X)
- GB upgrade-account-screen → SoT only (코드 미구현)
- GD habit-tracking-screen → RoutineScreen.kt (route 명 잔재, SoT 정정/deprecated 검토)
- GD routine-item-add-screen → RoutineScreen 일부 (별 라우트 X)
- GT ai-disclaimer-screen → AIDetailScreen.kt (settings/sub, `AiDisclaimerDetailCard` 컴포넌트 포함)

## 추가 발견 (코드 only)
- GB ProfileSetupScreen.kt → SoT 미존재 (auth-screen 분리 후보)
- GB TicketPurchaseScreen.kt → SoT 미존재 (ticket-shop 변형 후보)
- GD TicketScreen.kt → chat A 의존 (ticketshop SoT 결정)
- GT DietDetailScreen.kt → SoT 미존재 (settings/sub diet)

## chat A 의존 row (1 회 갱신 의무)
- GB paywall-screen — chat A 마감 후 paywall 처리 결정 인용
- GD TicketScreen — chat A 마감 후 GD ticketshop 결정 a/b/c 인용

## propagation 검증
- master sha `1e2a2ed1b055` ↔ GB / GD / GT cp 결과 4-repo byte-identical OK

## 다음 cycle 후보
- chat A 마감 후 paywall + GD TicketScreen row 갱신 (별 turn)
- GD habit-tracking-screen SoT 정정 vs RoutineScreen 통합 인정 결정
- GT DietDetailScreen SoT 신설 결정
- 자동화 hook 신설 (design-to-code-sync 통합)

## 사고 / 별 trail
- 없음 (clean cycle)

## commit 권장 (Coin 시점)
- master + 3-repo 동일 commit (cli infra propagation 표준 패턴)
- subject: `chore(cli-infra): add sot-code-name-map.md (3-repo SoT-Code 매핑)`
