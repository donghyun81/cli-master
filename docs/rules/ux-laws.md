# UX Laws — Claude CLI 자동 선별 적용 가이드

> **단일 목적**: Laws of UX (lawsofux.com · Jon Yablonski) 30 법칙 중 자식 repo 의 UI/UX 구현 task 진입 시 Claude CLI 가 **task 유형별로 자동 선별 적용**할 권장 법칙 + dark patterns / 다크 적용 위험으로 **비권장 또는 신중 분리** 항목 + 적용 매트릭스.
> **C7-UX-LAWS-INTEGRATION-001 신설** (자식 repo 의 모든 화면 / Form / 진행 task 의무 reading).
> **공식 근거**: [Laws of UX](https://lawsofux.com/) (Jon Yablonski) + 비판 (Hacker News + dark patterns 연구).
> **연관 파일**:
> - `code-principles.md` §4 reviewer 체크리스트 — 본 ux-laws 의 [E. UX Laws] 항목 자동 추가
> - `design-to-code-sync.md` Output Checklist P1-P9 — UI 구현 시 본 가이드 의무 인용
> - `ui-ux-analysis.md` — UX 변경 분석 시 본 가이드 적용
> - `.claude/agents/active/ux-auditor.md` — task 진입 시 본 가이드 자동 reading
> - `.claude/agents/active/reviewer.md` — REVIEW 작성 시 본 §B [UX Laws] 자동 적용
> SOT: `CLAUDE.md`

---

## 0. 적용 정책 (Claude CLI 자동 선별 흐름)

매 UI/UX 구현 task 진입 시 ux-auditor agent + reviewer agent 가:

```
1. task 유형 식별 (§5 매트릭스 참조)
2. 해당 task 유형에 매핑된 권장 법칙 list 추출
3. 비권장 (§3) 키워드 감지 시 STOP + Coin 명시 승인 의무
4. 권장 법칙 적용 산출 → PLAN.md / IMPL / REVIEW 의 12-section 안 §B [UX Laws] 추가
5. 각 법칙 적용 evidence (코드 인용 또는 SoT 인용) 추가
```

자식 repo 의 모든 새 화면 / Form / 진행 task 는 본 가이드의 **권장 22 + 신중 6 + 비권장 1 + dark patterns 분리 1** 매트릭스 따름.

---

## 1. 권장 22 법칙 (즉시 채택 · Claude CLI 자동 적용)

### A. 인지 부하 관리 (4 법칙)

#### A-1. Cognitive Load (인지 부하)
- **적용**: 한 화면당 정보 청크 ≤ 7 / 외재적 부하 (장식 / 중복 / 무관 콘텐츠) 제거
- **구현 코드 패턴**: `@Composable` 안 child 수 ≤ 7 그룹 / 불필요 `Box`/`Spacer` 제거
- **검증**: `verify-sync.sh` 후 reviewer 가 화면별 청크 수 평가

#### A-2. Working Memory (작업 기억)
- **적용**: 한 번에 4~7 청크 유지 + 화면 간 핵심 정보 자동 전이 (예: 선택 항목 비교 테이블 / 브레드크럼)
- **구현 코드 패턴**: ViewModel 의 UiState 가 화면 간 caller 정보 보존 / `SavedStateHandle` 활용
- **검증**: 화면 진입 시 사용자가 직전 정보를 다시 입력 의무 = FAIL

#### A-3. Selective Attention (선택적 주의)
- **적용**: 핵심 행동 / 정보 시각 강조 + Banner Blindness 회피 (광고와 같은 영역 / 스타일 X)
- **구현 코드 패턴**: 핵심 CTA = `FilledButton` / 보조 = `OutlinedButton` 또는 `TextButton` (Material3 위계)
- **검증**: 한 화면당 primary CTA = 1 (Von Restorff §A-7 정합)

#### A-4. Chunking (청킹) + Miller's Law
- **적용**: 콘텐츠를 시각적 그룹 + 명확한 계층으로 묶음 (≤ 7 청크 / 청크당 의미 1)
- **구현 코드 패턴**: `Card` / `Column` 그룹화 / `Divider` 또는 `Spacer` 로 구분
- **검증**: 한 list 당 7 항목 초과 = pagination / category 분할 의무

### B. 의사결정 효율 (3 법칙)

#### B-1. Choice Overload (선택 과부하)
- **적용**: 선택지 ≤ 5~7 / 추천 강조 + 검색·필터로 선제적 축소
- **구현 코드 패턴**: 동시 표시 옵션 ≤ 5 + `RadioButton` 보다 `DropdownMenu` (옵션 多) 또는 `BottomSheet` (선택 + 설명)
- **검증**: 옵션 8 개 초과 = 카테고리 분할 또는 검색 강제

#### B-2. Hick's Law (선택지 수 ↔ 의사결정 시간)
- **적용**: 응답 시간 critical 시 선택지 최소화 + 점진적 온보딩 + 추천 강조
- **구현 코드 패턴**: 첫 진입 시 핵심 1~2 행동만 노출 (Slack patterns) / 고급 기능 = `ExpandableSection`
- **양면 명시**: "추상화될 정도로 단순화 X" (자체 경고)

#### B-3. Mental Model (멘탈 모델) + Jakob's Law
- **적용**: Material Design 3 / iOS HIG 표준 patterns 우선 채택 (사용자 멘탈 모델 정렬)
- **구현 코드 패턴**: BottomNavigation / TopAppBar / FloatingActionButton 등 표준 컴포넌트 우선 사용
- **양면 명시**: "익숙함 우선 + 검증된 새 patterns 만 도입" (혁신 vs 익숙 균형)

### C. 피드백 + 반응 (2 법칙)

#### C-1. Doherty Threshold (< 400ms 응답)
- **적용**: 모든 사용자 input → < 400ms 시각 피드백 / 진행 표시 / 체감 성능 ↑ (skeleton screen / 낙관적 UI)
- **구현 코드 패턴**: `LaunchedEffect` 즉시 loading state / `CircularProgressIndicator` / `Shimmer` skeleton
- **신중 분리** (`§3 dark patterns`): "**의도적 지연 추가로 신뢰감 심기**" 부분은 **비권장** — 사용자 기만 가능 (실 처리 빠른데 늦춰 보이게)

#### C-2. Fitts's Law (터치 타겟 크기 + 거리)
- **적용**: 터치 타겟 ≥ 48dp (Material) 또는 44pt (iOS) / 간격 ≥ 8dp / 핵심 행동 = thumb-reach 안
- **구현 코드 패턴**: `Modifier.minimumInteractiveComponentSize()` + `Spacer(8.dp)` 의무
- **검증**: 터치 타겟 < 48dp 또는 간격 < 8dp = REVIEW FAIL

### D. 진행 동기 (2 법칙 · 신중)

#### D-1. Goal-Gradient Effect + Zeigarnik Effect (정직한 진행 표시)
- **적용**: multi-step Form / onboarding 시 정직한 진행 표시 (예: 3/5 단계)
- **구현 코드 패턴**: `LinearProgressIndicator(progress = currentStep / totalSteps)` + 각 step 명확히 명시
- **신중 분리** (`§3 dark patterns`): "**시작점에 인위적 진척 추가** (예: 0/10 대신 2/12)" 은 **비권장** — 사용자 동기 조작

### E. 정보 구조 (1 법칙)

#### E-1. Serial Position Effect (순서 위치 효과)
- **적용**: 핵심 행동 / 정보 = 시작 또는 끝에 배치 (중간 = 덜 기억됨)
- **구현 코드 패턴**: BottomNavigation 의 핵심 탭 = 양 끝 또는 중앙 (FAB) / list 의 핵심 = 첫/마지막

### F. 게슈탈트 5 원칙 (시각 그룹화 · 모두 채택)

| 법칙 | 구현 코드 패턴 |
|---|---|
| **F-1. Common Region** | `Card` / `Surface(border)` / `background` 로 그룹 명시 |
| **F-2. Proximity (근접)** | `Spacer` / `Padding` 으로 관련 ↔ 비관련 분리 (관련 ≤ 8dp / 비관련 ≥ 16dp) |
| **F-3. Prägnanz (간결)** | 복잡 도형 단순화 / icon = 표준 Material Icons 우선 |
| **F-4. Similarity (유사)** | 같은 기능 = 같은 색 / 형태 / 크기 (예: 모든 link = primary color) |
| **F-5. Uniform Connectedness (균일 연결)** | 비슷한 기능 그룹 = `Card` 또는 `border` 로 시각 연결 |

### G. 사용자 경험 패턴 (3 법칙 · 신중)

#### G-1. Aesthetic-Usability Effect (심미적 사용성 효과)
- **적용**: Material3 Theme / 일관된 typography / spacing token 사용
- **양면 명시**: "**미적 매력이 사용성 문제 가림**" (자체 경고) → **사용성 테스트 의무 동시 추가**. 시각만 우선 X.

#### G-2. Paradox of the Active User (능동적 사용자의 역설)
- **적용**: 매뉴얼 X / 인라인 도움말 + 툴팁 + 점진적 공개
- **구현 코드 패턴**: `TooltipBox` (Material3) / first-run `Snackbar` 안내 / `BottomSheet` 도움말

#### G-3. Peak-End Rule (피크-엔드 규칙)
- **적용**: 첫 진입 + 완료 모먼트 = 의도 강조 (긍정 일러스트 / 미묘한 애니메이션 / 친절한 copy)
- **구현 코드 패턴**: 첫 결제 완료 = `LottieAnimation` celebration / 회원가입 완료 = welcome screen
- **신중 분리** (`§3 dark patterns`): "**부정 사건 위장** (예: Uber 의 호출 후 취소율 ↓ 위해 대기 시간 인식 조작)" 은 **비권장** — 사용자 기만

### H. 시각 강조 (1 법칙 · 신중)

#### H-1. Von Restorff Effect (격리 효과)
- **적용**: 핵심 행동 / 정보 시각 강조 (색 / 크기 / 위치)
- **양면 명시**: 
  - **남용 금지** (광고로 오인 + 요소 경쟁)
  - **색상 only X** (color-blind / 저시력 배제 → 색 + 형태 + 텍스트 동시 사용)
  - **모션 신중** (모션 민감도 사용자 + `prefers-reduced-motion` 존중)

### I. 설계 원칙 (3 법칙)

#### I-1. Tesler's Law (복잡성 보존)
- **적용**: 디자인 / 개발 layer 가 내재 복잡성 흡수 → 사용자 부담 ↓ (smart defaults / 자동 검증)
- **구현 코드 패턴**: address 자동 완성 / 카테고리 자동 추천 / 형식 자동 변환 (예: 전화번호 자동 hyphen)

#### I-2. Postel's Law (받을 땐 관대 + 보낼 땐 보수)
- **적용**: Form 입력 = 다양한 형식 수용 (예: 전화번호 010-1234-5678 / 01012345678 / +82-10-... 모두 OK) + 명확한 피드백
- **구현 코드 패턴**: input 정규화 (validator + transformer) + 에러 메시지 명확

#### I-3. Occam's Razor + Pareto Principle (단순 + 80/20)
- **적용**: 같은 결과면 가정 / 기능 / 의존성 최소 / 80% 사용자가 쓰는 20% 기능에 노력 집중
- **연관**: `code-principles.md` §2 KISS + YAGNI 정합

### J. 시간 관리 (1 법칙 · 신중)

#### J-1. Parkinson's Law (작업 시간 부풀음)
- **적용**: Form autofill / 결제 자동 채우기 등 양심적 시간 절감
- **신중 분리** (`§3 dark patterns`): "**시간 제한 카운트다운**" (예: "5분 안에 완료 안 하면 가격 ↑") 은 **비권장** — 긴급성 조작

---

## 2. Flow (몰입 · 부분 채택)

#### Flow (몰입)
- **적용**: 도전 ↔ 사용자 기술 균형 + 마찰 제거 + 시스템 반응성 최적화 + 콘텐츠/기능 발견 가능성
- **구현 코드 패턴**: 점진적 난이도 / loading state 즉시 / search ≤ 200ms / 핵심 기능 first-tier 노출
- **양면 명시**: 너무 어려움 = 좌절 / 너무 쉬움 = 지루 → **사용자 리서치 의무**

---

## 3. 비권장 + 신중 분리 (5 항목 · dark patterns 회피)

### 3.1 Cognitive Bias (인지 편향) — **거의 비권장**
**비권장 사유**:
- **사전적 정의에 가까움 + 디자이너가 적용할 구체 행동 X** (Hacker News 비판 정합)
- 적용 시 위험: 사용자 편향 (확증 / 손실 회피 / sunk cost) 을 의도적 활용한 conversion 최적화 = dark patterns
- **채택 부분**: "자기 편향 인지" 만 (디자이너 reflection 용 · 사용자 조작 X)
- **거부 부분**: "사용자 편향 활용" 으로 결제 / 가입 유도 (dark patterns)

### 3.2 Doherty Threshold 의 "의도적 지연 추가" — **비권장**
**비권장 사유**:
- "신뢰감 심기 위해 실 처리 빠른데 의도적 지연" = 사용자 기만
- 예: AI 응답 즉시 반환 가능한데 progress bar 5초 보여 "신중하게 처리됐다" 인식 조작
- **채택 부분**: < 400ms 응답 + 진행 표시 + skeleton screen
- **거부 부분**: 의도적 지연으로 인지된 가치 ↑

### 3.3 Goal-Gradient Effect 의 "인위적 진척 추가" — **비권장**
**비권장 사유**:
- 시작점 명시됨 (예: 빈 stamp card 0/10 → 2/12 로 시작) = 사용자 동기 조작
- **채택 부분**: 정직한 진행 표시 (3/5 등 실제 step 수)
- **거부 부분**: 시작점 인위적 추가 / 진척률 부풀림

### 3.4 Peak-End Rule 의 "부정 사건 위장" — **비권장**
**비권장 사유**:
- Uber 호출 후 취소율 ↓ 위해 대기 시간 인식 조작 = 사용자 기만 + 취소권 침해
- **채택 부분**: 긍정 모먼트 강조 (완료 celebration / 첫 진입 welcome)
- **거부 부분**: 부정 사건 시간 인식 조작 / 취소 어렵게 함

### 3.5 Parkinson's Law 의 "시간 제한 카운트다운" — **비권장**
**비권장 사유**:
- "5분 안에 결제 안 하면 가격 ↑" / "재고 5개 남음" 시간 압박 = 긴급성 조작 (다크 패턴 카테고리 "Urgency")
- **채택 부분**: Form autofill / 자동 채우기 / 입력 시간 절감
- **거부 부분**: 카운트다운 타이머 / 가짜 재고 표시

### (참고) 추가 Dark Patterns 회피 (FTC 가이드 + EU DMA 정합)

본 ux-laws 외에도 다음 dark patterns 자식 repo 에서 **즉시 STOP**:
- **Roach Motel**: 가입 쉬움 + 탈퇴 어려움 → STOP
- **Confirmshaming**: "아니요, 저는 절약을 원하지 않습니다" 거부 옵션 → STOP
- **Disguised Ads**: 광고를 콘텐츠처럼 위장 → STOP (Selective Attention §A-3 정합)
- **Forced Continuity**: 무료 trial 자동 결제 + 알림 X → STOP
- **Hidden Costs**: 결제 마지막에 추가 fee 공개 → STOP

---

## 4. 채택 / 비권장 / 신중 매트릭스

| # | 법칙 | 분류 | 사유 |
|---|---|---|---|
| 1 | Aesthetic-Usability Effect | 신중 | 미적이 사용성 가림 위험 → 사용성 테스트 의무 |
| 2 | Cognitive Bias | **비권장 (대부분)** | 사전적 + 구체 행동 X + dark pattern 위험 |
| 3 | Cognitive Load | **권장** | 화면당 청크 ≤ 7 |
| 4 | Selective Attention | 신중 | banner blindness 회피 OK / 광고 위장 X |
| 5 | Working Memory | **권장** | recall 보다 recognition |
| 6 | Choice Overload | **권장** | 옵션 ≤ 5~7 |
| 7 | Hick's Law | **권장** | 양면 (단순화 ↔ 추상화) |
| 8 | Mental Model | 신중 | 익숙함 + 검증된 혁신 균형 |
| 9 | Doherty Threshold | 신중 | < 400ms OK / 의도적 지연 X |
| 10 | Fitts's Law | **권장** | ≥ 48dp / 간격 ≥ 8dp |
| 11 | Flow | 신중 | 사용자 리서치 의무 |
| 12 | Goal-Gradient | 신중 | 정직한 진행 OK / 인위적 추가 X |
| 13 | Zeigarnik | **권장** | 명확한 시그니파이어 |
| 14 | Chunking | **권장** | 시각 그룹 + 계층 |
| 15 | Miller's Law | **권장** | 7±2 ≠ 디자인 제약 핑계 |
| 16 | Serial Position | **권장** | 핵심 = 시작/끝 |
| 17 | Common Region | **권장** | Card / border |
| 18 | Proximity | **권장** | 8dp / 16dp |
| 19 | Prägnanz | **권장** | 단순 우선 |
| 20 | Similarity | **권장** | 같은 기능 = 같은 시각 |
| 21 | Uniform Connectedness | **권장** | Card 그룹화 |
| 22 | Jakob's Law | 신중 | Material/HIG 표준 + 변경 시 점진 도입 |
| 23 | Paradox of Active User | **권장** | 인라인 도움말 |
| 24 | Peak-End Rule | 신중 | 긍정 모먼트 OK / 부정 위장 X |
| 25 | Von Restorff | 신중 | 색 only X / 모션 reduced 존중 |
| 26 | Tesler's Law | **권장** | 사용자 부담 ↓ |
| 27 | Postel's Law | **권장** | 입력 관대 |
| 28 | Occam's Razor | **권장** | KISS 정합 |
| 29 | Pareto Principle | **권장** | 80/20 |
| 30 | Parkinson's Law | 신중 | autofill OK / 카운트다운 X |

**합계**: 권장 17 / 신중 12 / 비권장 1 (Cognitive Bias)

---

## 5. Task 유형별 자동 선별 적용 매트릭스

`ux-auditor` agent + `reviewer` agent 가 task 유형 식별 후 본 매트릭스 따라 해당 법칙만 자동 선별:

| task 유형 | 적용 법칙 (의무) | 추가 신중 검토 |
|---|---|---|
| **신규 화면 (UI)** | A-1~4 (인지 부하) + B-3 (Mental Model) + F-1~5 (Gestalt) + I-3 (Occam) | G-1 (Aesthetic) · H-1 (Von Restorff) |
| **Form (입력)** | A-2 (Working Memory) + B-1~2 (Choice/Hick) + C-2 (Fitts) + I-2 (Postel) + J-1 (autofill) | D-1 (정직 진행) |
| **multi-step Form / Onboarding** | D-1 (정직한 진행) + B-2 (Hick 점진) + G-2 (인라인 도움말) | G-3 (피크-엔드) |
| **결제 / 가입** | I-1 (Tesler) + I-2 (Postel) + G-3 (긍정 완료 모먼트) | **dark pattern 5종 STOP 검증 의무** |
| **list / 카탈로그** | A-4 (Chunking) + B-1 (Choice Overload) + E-1 (Serial Position) + F-2 (Proximity) | H-1 (Von Restorff 추천 강조) |
| **Navigation** | B-3 (Material 표준) + E-1 (양 끝 핵심) + F-4 (Similarity) | - |
| **버튼 / CTA** | A-3 (Selective Attention) + C-2 (Fitts ≥ 48dp) + H-1 (Von Restorff 1 primary) | F-4 (Similarity 위계) |
| **로딩 / 에러 / 빈 상태** | C-1 (Doherty < 400ms) + I-2 (Postel 명확 피드백) + G-2 (도움말) | - |
| **알림 / Snackbar / Toast** | A-3 (선택적 주의) + H-1 (시각 강조) | C-1 (시간 ≥ 4s 가독) |
| **검색 / 필터** | B-1 (선택지 좁힘 도구) + I-3 (Pareto) | - |

자식 repo task 진입 시 ux-auditor 가 `intake-router` 의 work type 식별 → 위 매트릭스 row 자동 선택 → 해당 법칙 PLAN.md / IMPL / REVIEW 에 인용 의무.

## 5.1 N/A 영역 (자동 분류 의무)

다음 7 영역 화면 / task 는 §5 매트릭스 적용 X · audit N/A 분류 의무.

| 영역 | 정의 | 예 |
|---|---|---|
| Auth-only | 로그인 / 회원가입 / 비밀번호 재설정 — UI 표시 외 도메인 | auth-screen |
| Backend-only | API / DB / 동기화 — 화면 변경 X | API endpoint 추가 cycle |
| Doc-only | 문서 변경 — UI 변경 X | README 갱신 |
| Dependency-decision | 라이브러리 선택 — UI 무관 | 차트 라이브러리 결정 |
| Build-CI-Tooling | gradle / 빌드 — UI 무관 | CI script 영역 |
| Refactor (UI 무관) | 구조 변경만 | data class 분리 |
| cli infra | .claude/ / docs/templates/ 영역 | rules / agents / hooks |

REVIEW.md §B [UX Laws] + §B Dark Patterns 회피 검증 시 N/A 분류 = "N/A (사유: <영역>)" 1 줄 형식 의무.

---

## 6. 검증 (PromptFit + REVIEW.md 12-section 안 §B [UX Laws])

reviewer agent 가 REVIEW.md 작성 시 본 섹션 자동 추가:

```markdown
## §B [UX Laws] 적용 검증

| 법칙 | 적용 코드 / SoT 인용 | PASS / FAIL / N/A |
|---|---|---|
| C-2 Fitts's Law | Modifier.minimumInteractiveComponentSize() + Spacer(8.dp) | PASS |
| F-2 Proximity | Card spacing 16.dp / inner 8.dp | PASS |
| ... | ... | ... |

## §B Dark Patterns 회피 검증

- Roach Motel: ✓ 탈퇴 = 가입 step 동일
- Confirmshaming: ✓ 거부 옵션 중립 wording
- ... (5 종)
```

위 §B 누락 시 REVIEW FAIL.

---

## 7. 본 룰의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 6-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).
> 신규 dark pattern 발견 시 §3 추가 + 자식 repo 의무 적용 (본 file 고유 조항).

---

## 8. 참고

- **공식 출처**: [Laws of UX (lawsofux.com)](https://lawsofux.com/) — Jon Yablonski
- **비판 + 보완**: Hacker News 토론 (법칙 충돌 + 맥락 판단 의무)
- **Dark Patterns 출처**: [deceptive.design](https://www.deceptive.design/) (Harry Brignull) + FTC + EU Digital Markets Act
- **Material Design 3**: [m3.material.io](https://m3.material.io/) (G-1 / B-3 표준)
- **Apple HIG**: [developer.apple.com/design/](https://developer.apple.com/design/human-interface-guidelines) (B-3 표준)
