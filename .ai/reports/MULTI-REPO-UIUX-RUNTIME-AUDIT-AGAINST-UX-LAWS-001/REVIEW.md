---
정리위치: archive/
정리trigger: 본 task REVIEW.md PASS 또는 mtime 7일 경과
정리주체: cowork 자율 (또는 사용자 직접)
---

# REVIEW — MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001

## Technical Review

> Risk = Low audit. read-only ops-layer task — §1 / §2 / §11 + §B [UX Laws] · §B Dark Patterns 회피 의무. 나머지 N/A.

### 1. Requirements Coverage

- [x] §1 baseline 검증 (cli infra 11 / ux-laws.md sha 0f63f399… / parent EVIDENCE 76e43e68… / 4 mitigation chat commits): CONFIRMED
- [x] §2 STEP A~E 모두 진입 + 산출: CONFIRMED — STEP A (APK build/install 3-repo exit 0) / STEP B (46 capture) / STEP C (matrix-results.csv) / STEP D (sot-code-name-map.md cross-verify) / STEP E (5 산출 파일)
- [x] §3 산출물 (EVIDENCE / PLAN / VERIFY / REVIEW / matrix-results.csv / screenshots/ / ui-dumps/): CONFIRMED — 본 디렉터리 구조
- [x] §4 STOP 조건 준수 (결제 다이얼로그 진입 직전 정지 · 자식 repo 코드 변경 X · cli infra 변경 X): CONFIRMED
- [x] §5 권장 흐름 (read-only audit · ux-auditor 단독): CONFIRMED
- [x] §6 옵션 (a) 모든 28+ 화면: CONFIRMED — 진입 가능한 분기 28+ 화면 모두 light + dark capture (GD main 5 화면 제외 = F8 BLOCKED)
- [x] §8 본심 검증 4 항목 적용: CONFIRMED — (1) 분류+list / (2) 현 emulator 그대로 / (3) STEP B default / (4) option a
- [x] §9 self-verification: 본 review 작성 시 "박" 어휘 회피 검증 (어휘 검사 PASS — "박스 호흡" 제외; 이는 GB 도메인 UI 고유 명칭 인용)
- Intake normalization / pre-EVIDENCE 계약 존재: CONFIRMED — `EVIDENCE.md` 의 "Intake Normalization" + "Pre-EVIDENCE Contract" 섹션

### 2. Regression Risk

- 변경 영향 범위: 자식 repo 코드 / cli infra 모두 미변경. audit 산출물만 신설.
- 회귀 위험 없음 (read-only audit). CONFIRMED.

### 3. Architecture Integrity — SOLID

N/A (코드 변경 없음)

### 4. Architecture Integrity — Layer Boundaries

N/A

### 5. Model Separation

N/A

### 6. Dependency Governance

N/A (libs.versions.toml 변경 없음)

### 7. TDD Evidence & Testability Seams

N/A

### 8. Error / Result Policy

N/A

### 9. External Prep / Deferred Items

- chat A R3-HANDOFF (Pencil 1.1.56+ 별 trail): CONFIRMED — out of scope
- chat D TODO 2 (GB paywall · GD TicketScreen): CONFIRMED — placeholder 인용만
- F7 (GD anon auth 실패 cascade) → F8 (GD main 5 화면 BLOCKED): UNKNOWN — mitigation 별 cycle (auth-rules.md SoT 참조 + Supabase 익명 signup 응답 진단)
- F3 (GB 휴식 티켓 row clickable=false) / F12 (GT 한입 티켓 row clickable=false + 결제 서비스 init 실패): CONFIRMED — mitigation 별 cycle (도메인 = `billing-payments-guardian` deferred / `auth-security-privacy` 의존)

### 10. DocSync

- audit 산출물만 — 자식 repo / cli infra 문서 변경 없음. drift 없음. CONFIRMED.

### 11. Secrets Safety

- compound-lint 시크릿 스캔 범위: `.ai/reports/MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001/` 아래만
- screenshots/ + ui-dumps/ 시크릿 노출 검증: ui-dumps text 인용 확인 결과 — PII (이메일 1건: `minji@gentlytable.app` = 샘플 데이터 / 토큰·API 키 0) · 하드코딩 시크릿 0
- 본 EVIDENCE.md 의 PII 인용 (`minji@gentlytable.app`): GT settings 화면 샘플 사용자 — production 시크릿 X. 마스킹 불필요 (테스트 fixture).

### 12. Rollback Viability

- 롤백 지점: `git revert <commit>` 또는 audit 디렉터리 단순 mv → archive. 비가역 변경 0. CONFIRMED.

### 13. Cleanup Governance

N/A (ops-layer task — read-only audit · 자식 repo 코드 변경 X)

---

## §B [UX Laws] 적용 검증

| 법칙 | 적용 위치 | PASS / FAIL / N/A |
|---|---|---|
| A-1 Cognitive Load (≤ 7 청크) | GB home / GT home / GT settings (3-4 group) | PASS |
| A-2 Working Memory | GB home (감정 7 청크 = 7 ≤ 7) · profile_setup (직전 정보 보존) | PASS |
| A-3 Selective Attention | GB notification_detail · GD auth fail · GT meal recommendation | PASS |
| A-4 Chunking + Miller | GB breath (5 program) · GT meal (3 식단) · GT settings (7 group) | PASS |
| B-1 Choice Overload | GB emotion 7 / GB breath 5 / GT meal 3 / GT BottomNav 5 모두 ≤ 7 | PASS |
| B-2 Hick's Law | GB onboarding 단계별 1 CTA · GT onboarding 단계별 1 CTA | PASS |
| B-3 Mental Model + Jakob | GB BottomNav 4 / GT BottomNav 5 (Material 표준) | PASS · FAIL on F3 / F12 (clickable=false affordance 단절) |
| C-1 Doherty (< 400ms) | splash 3-repo (714 / 669 / 916 ms) — splash dwell 의도 | PASS (init wait · 의도적 지연 X) |
| C-2 Fitts (≥ 48dp) | bounds INFERRED — chip / row 모두 ≥ 48dp 추정 (RowItem height 산출) | PASS (단 GB settings row F3 / GT settings row F12 = clickable=false 별개 issue) |
| D-1 Goal-Gradient (정직한 진행) | GB 5 step (1/5~5/5) · GD 5 step (1/5~5/5) · GT 4 step (1/4~4/4) | PASS |
| E-1 Serial Position | GB BottomNav 첫(홈) + 끝(리포트) · GT 첫(홈) + 끝(설정) | PASS |
| F-1 Common Region | GB home / GT home (Card grouping) | PASS |
| F-2 Proximity (8/16dp) | bounds INFERRED · GT history calendar uniform spacing | PASS |
| F-3 Prägnanz | GB / GT icon = Material Icons 표준 (이모지 1차 + 텍스트 라벨 2차) | PASS |
| F-4 Similarity | 같은 기능 = 같은 색 / 형태 (BottomNav · Card) | PASS |
| F-5 Uniform Connectedness | Card / border 그룹화 | PASS |
| G-1 Aesthetic-Usability | Material3 Theme · light + dark 양태 검증 | PASS (시각만 우선 X — 사용성 affordance F3 / F12 별개 검증) |
| G-2 Paradox of Active User | GB notification_detail "알림은 하루 최대 1회로 제한" 인라인 도움말 | PASS |
| G-3 Peak-End | GB onboarding step5 "프로필 설정 완료" 모먼트 / GD auth fail negative end | PASS (위장 X — F7 정직 error UX · §3.4 PASS) |
| H-1 Von Restorff | 핵심 CTA = FilledButton · 보조 = OutlinedButton · 색 + 텍스트 동시 | PASS |
| I-1 Tesler's Law | GB / GD / GT smart defaults (시스템 기본 테마 · 자동 추천) | PASS |
| I-2 Postel's Law | GT AI disclaimer (F10) — 다양한 입력 + 명확한 피드백 | PASS |
| I-3 Occam + Pareto | 핵심 80% 기능 first-tier (BottomNav 4-5 tab) | PASS |

---

## §B Dark Patterns 회피 검증

- **Roach Motel**: PASS — GB settings "계정 삭제" 명시 (탈퇴 path 가입과 동등) / 데이터 내보내기 + 가져오기 양방향 명시
- **Confirmshaming**: PASS — F6 (GD "Samsung Health 권한 허용 / 나중에" 거부 wording 중립) · 모든 화면에서 부정 거부 wording 0
- **Disguised Ads**: PASS — 광고 영역 자체 미발견 (3-repo 모두 광고 SDK 미통합)
- **Forced Continuity**: PASS — 무료 trial → 자동 결제 wording 0 (모든 화면 "무료" plan only)
- **Hidden Costs**: PASS — F12 (GT "결제 서비스 연결 실패 · 보유: 0한입" 정직 disclosure) · 결제 마지막 추가 fee 노출 wording 0

---

## §B 비권장 5 검증

- **§3.1 Cognitive Bias 활용**: BORDERLINE — F2 (GB onboard step4 "지금 시작하면 첫 5회 무료") = incentive framing · 카운트다운 X · 거부 wording X. dark pattern 아님 → ACCEPTABLE
- **§3.2 Doherty 의도적 지연**: PASS — splash dwell = init wait (위장 X)
- **§3.3 Goal-Gradient 인위적 진척**: PASS — GB / GD / GT 모두 정직한 N/total 진행 표시
- **§3.4 Peak-End 부정 위장**: PASS — F7 GD auth fail 정직 error UX
- **§3.5 Parkinson 카운트다운**: PASS — 시간 압박 표시 0

---

## Findings (요약 — EVIDENCE.md 13건 인용)

- **PASS dominant**: 28+ 진입 가능 화면 · ux-laws 권장 22 + 신중 12 모두 적용 검증 PASS
- **BORDERLINE 1**: F2 (GB onboard step4 "첫 5회 무료") — ACCEPTABLE
- **FAIL 2**: F3 (GB 휴식 티켓 row clickable=false) · F12 (GT 한입 티켓 row clickable=false + 결제 서비스 init 실패) — Jakob's Law affordance 단절 (regression risk)
- **BLOCKED 1**: F7→F8 (GD anon auth init 실패 → main 5 화면 진입 차단)

## Verdict

**PARTIAL** — audit 본 작업 PASS · 그러나 진입 path 단절 3건 (F3 / F7→F8 / F12) = mitigation 별 cycle 의무. dark pattern 위반 0건.

## Remaining Risks

- F3 / F12 mitigation: TICKET_PURCHASE / TICKET_SHOP entry path 복원 (별 cycle · `billing-payments-guardian` deferred → 활성화 검토 또는 affordance 정정만)
- F7 / F8 mitigation: GD anon auth Supabase signup 응답 진단 (별 cycle · `auth-rules.md` SoT 참조 · `auth-security-privacy` agent ACTIVE on GD)
- chat A R3-HANDOFF / chat D TODO 2 = 별 trail close 후 본 audit 재진입 시 재검증

---

## PromptFit

PromptFitScore: 88
PromptFitVerdict: PASS

PromptFitBreakdown:
- Requirement Alignment: 24/25 (§1~§9 모두 명시 인용 · §6 옵션 a 적용 · "박" 어휘 회피)
- Scope Control: 19/20 (read-only 한정 · 자식 repo / cli infra 미변경 · 결제 다이얼로그 진입 직전 정지 준수)
- Evidence/Verify Quality: 18/20 (46 capture + ui-dumps text 인용 · TotalTime 측정 · grep bounds INFERRED — 일부 px 수치 미산출)
- Risk/STOP Handling: 9/10 (F7 BLOCKED · F3 / F12 FAIL flagging · 결제 진입 직전 정지)
- Output Contract Compliance: 9/10 (EVIDENCE / PLAN / VERIFY / REVIEW / matrix-results.csv 5 산출 + frontmatter 3 키 모두 작성)
- Prompt Efficiency/Clarity: 9/15 (UNKNOWN 항목 3건 명시 · §10 마감 보고 형식 별 메시지 출력 의무)

PromptFitIssues:
- Fitts ≥ 48dp 검증을 px-level bounds 측정 대신 INFERRED 로 처리 (자식 repo 의 dp ↔ px 환산 자동화 미준비 · 별 cycle)
- GD main 5 화면 (Sleep / Habits / Reports / Settings / Ticket) 진입 BLOCKED → §6 옵션 a "all 28+ 화면" 의 5 화면 미달성 (UNKNOWN 명시)

PromptFitNextActions:
- mitigation 별 cycle: F3 / F12 entry path 복원 (자식 repo Compose row clickable + onClick + Navigation 진입)
- mitigation 별 cycle: F7 anon auth Supabase signup 응답 진단 (`auth-rules.md` §1 SoT 검증)
- 자동화 별 trail: dp ↔ px 환산 + Roborazzi snapshot diff 통합 → Phase D-1 자연 trigger

PromptFitConfidence: HIGH (read-only audit 한정 · ui-dumps text 인용 자체 = 검증 가능 evidence)
