# C7-UX-LAWS-INTEGRATION-001 · Laws of UX 자동 적용 + Dark Patterns 회피

> 작성: 2026-05-02 · scope: master 의 .claude/rules/ux-laws.md 신설 + agents/code-principles/app-guide 인용 갱신
> 공식 근거: Laws of UX (Jon Yablonski) + Dark Patterns (Harry Brignull / FTC / EU DMA)

---

## 0. 거시 목적

자식 repo 의 모든 UI/UX 구현 task 진입 시 Claude CLI 가 **task 유형별로 Laws of UX 권장 법칙을 자동 선별 적용** + **dark patterns 위험 분리** + **Coin 의 매번 결정 없이 일관 적용**.

---

## 1. 분류 결과 — 권장 17 + 신중 12 + 비권장 1

### 권장 17 (즉시 채택 · 매 task 의무 적용)

A-1 Cognitive Load · A-2 Working Memory · A-4 Chunking · A-4 Miller's Law ·
B-1 Choice Overload · B-2 Hick's Law ·
C-2 Fitts's Law ·
D-1 Zeigarnik (정직 신호 한정) ·
E-1 Serial Position ·
F-1 Common Region · F-2 Proximity · F-3 Prägnanz · F-4 Similarity · F-5 Uniform Connectedness ·
G-2 Paradox of Active User ·
I-1 Tesler's Law · I-2 Postel's Law · I-3 Occam's Razor + Pareto

### 신중 12 (양면 박음 · 위험 분리 의무)

A-3 Selective Attention (banner blindness 회피 OK / 광고 위장 X)
B-3 Mental Model + Jakob's Law (익숙함 + 검증된 혁신 균형)
C-1 Doherty Threshold (< 400ms OK / **의도적 지연 X**)
D-1 Goal-Gradient (정직 진행 OK / **인위적 시작점 박음 X**)
G-1 Aesthetic-Usability Effect (사용성 테스트 의무)
G-3 Peak-End Rule (긍정 모먼트 OK / **부정 위장 X**)
H-1 Von Restorff (색 only X / 모션 reduced 존중)
J-1 Parkinson's Law (autofill OK / **카운트다운 X**)
Flow (사용자 리서치 의무)

### 비권장 1

**Cognitive Bias (사용자 편향 활용)** — 사전적 정의 + 디자이너 적용 가능 구체 행동 X + 활용 시 dark pattern 위험.
- 채택 부분: "디자이너 자기 편향 인지" 만 (reflection 용)
- 거부 부분: 사용자 편향 활용 conversion 최적화

---

## 2. 비권장 5 항목 사유 (사용자 답변 박힘)

| # | 비권장 항목 | dark pattern 분류 | 사유 |
|---|---|---|---|
| 1 | **Cognitive Bias 활용** | Manipulative | 사전적 + 구체 행동 X + 사용자 편향 의도적 활용 = 조작 |
| 2 | **Doherty 의도적 지연** | Trick Wording | 실 처리 빠른데 의도적 지연으로 "신중하게 처리" 인식 조작 |
| 3 | **Goal-Gradient 인위적 진척** | False Progress | 시작점 0/10 대신 2/12 박힘 = 동기 조작 |
| 4 | **Peak-End 부정 위장** | Misdirection | Uber 호출 후 취소율 ↓ 위해 대기 시간 인식 조작 = 취소권 침해 |
| 5 | **Parkinson 카운트다운** | Urgency / Scarcity | "5분 안에 결제 안 하면 가격 ↑" / "재고 5개 남음" = 긴급성 조작 |

### 추가 dark patterns 회피 5 종 (FTC 2022 가이드 + EU DMA 2024 정합)

- **Roach Motel** — 가입 쉬움 + 탈퇴 어려움
- **Confirmshaming** — "아니요, 저는 절약을 원하지 않습니다" 거부 옵션
- **Disguised Ads** — 광고를 콘텐츠처럼 위장
- **Forced Continuity** — 무료 trial 자동 결제 + 알림 X
- **Hidden Costs** — 결제 마지막에 추가 fee 공개

→ 자식 repo 의 결제 / 가입 task 진입 시 **자동 STOP 검증 의무**.

---

## 3. 자동 선별 적용 흐름 (Claude CLI)

```
사용자: /fulfill-requirement "스플래시 화면 추가"
    ↓
intake-router → work type = "신규 화면 (UI)"
    ↓
ux-auditor agent 자동 호출 (description 박힘)
    ├── .claude/rules/ux-laws.md 자동 reading
    ├── §5 매트릭스 row "신규 화면" 추출
    └── 적용 법칙: A-1~4 (인지 부하) + B-3 (Mental Model) + F-1~5 (Gestalt) + I-3 (Occam)
    ↓
change-planner → PLAN.md 안 §B [UX Laws] 자동 인용
    ↓
ui-implementer → IMPL 시 위 법칙 의무 적용 (Modifier.minimumInteractiveComponentSize 등)
    ↓
verifier → 1+ 명령 실행 (build / test / pixel diff)
    ↓
reviewer → REVIEW.md 12-section + §B [UX Laws] 적용 검증 + Dark Patterns 5 종 STOP 검증
    ├── §B 누락 = REVIEW FAIL
    ├── Dark Pattern 위반 = REVIEW FAIL
    └── 모두 PASS = DONE
```

---

## 4. Task 유형별 적용 매트릭스 (요약)

| task | 의무 법칙 | dark pattern 검증 |
|---|---|---|
| 신규 화면 | 인지 부하 4 + Mental Model + Gestalt 5 + Occam | - |
| Form | Working Memory + Choice/Hick + Fitts + Postel + Parkinson autofill | - |
| multi-step / Onboarding | 정직 진행 + Hick 점진 + 인라인 도움말 | Goal-Gradient 인위적 박음 X |
| **결제 / 가입** | Tesler + Postel + 긍정 완료 모먼트 | **Dark Pattern 5종 STOP 의무** |
| list / 카탈로그 | Chunking + Choice Overload + Serial Position + Proximity | - |
| Navigation | Material 표준 + 양 끝 핵심 + Similarity | - |
| 버튼 / CTA | Selective Attention + Fitts ≥ 48dp + Von Restorff 1 primary | - |
| 로딩 / 에러 / 빈 상태 | Doherty < 400ms + Postel 명확 피드백 + 도움말 | 의도적 지연 X |
| 알림 | 선택적 주의 + 시각 강조 | - |
| 검색 / 필터 | 선택지 좁힘 + Pareto | - |

---

## 5. 산출물 inventory (C7)

| 파일 | 변경 | 줄 수 |
|---|---|---|
| `.claude/rules/ux-laws.md` | ★ 신설 | 306 |
| `.claude/agents/active/ux-auditor.md` | ~ description 갱신 (ux-laws auto reading) | - |
| `.claude/agents/active/reviewer.md` | ~ description 갱신 (§B + Dark Pattern 검증) | - |
| `.claude/rules/code-principles.md` | ~ §4 H 추가 (UX Laws 체크리스트) | +6 |
| `docs/guides/app-implementation-guide.md` | ~ §4.5 신설 | +25 |
| `scripts/verify-sync.sh` | ~ CORE_CLI 에 ux-laws.md 추가 | +1 |
| `.auto-memory/decision-log.md` | ~ C7 entry append | - |
| `CLAUDE.md` | ~ §15 cycle 진행 이력 표 C7 추가 | +1 |
| `.ai/reports/C7-UX-LAWS-INTEGRATION-001/REPORT.md` | ★ 신설 본 파일 | - |

---

## 6. 검증 (실측 PASS)

- bash -n verify-sync.sh PASS
- ux-auditor + reviewer agent description 박음 검증 PASS
- code-principles §4 H + app-implementation §4.5 인용 박음 검증 PASS
- verify-sync --quick = 24 파일 검증 (확장 박음)

---

## 7. ROI

| 항목 | 비용 | 효과 |
|---|---|---|
| ux-laws.md 신설 | 1 cycle | 매 UI/UX task 마다 Coin 결정 없이 자동 적용 / 일관성 |
| 비권장 5 + Dark Pattern 5 분리 | 1 cycle 안 흡수 | 윤리적 디자인 (사용자 권리 침해 차단) + FTC/EU DMA 정합 |
| reviewer 자동 §B 의무 | 영구 | 매 REVIEW 마다 UX 검증 (누락 = FAIL) |

---

## 8. Coin 손 작업 1줄

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "$(cat <<'COMMIT'
feat(master): C7-UX-LAWS-INTEGRATION-001 Laws of UX 자동 적용 + Dark Patterns 회피

[Goal] Claude CLI 가 자식 repo 의 UI/UX task 진입 시 task 유형별로 Laws of UX 권장 법칙 자동 선별 적용 + dark patterns 자동 STOP
[Diff] +1 cli infra (.claude/rules/ux-laws.md 306줄) ~2 agents (ux-auditor + reviewer description 강화) ~1 rule (code-principles §4 H) ~1 가이드 (app-implementation §4.5) ~1 script (verify-sync CORE_CLI)
[Sha]  보호 5종 sha 변동 0 (C2.5 baseline 보존)
[EC]   ux-auditor + reviewer 가 ux-laws.md 자동 reading + §5 매트릭스 자동 선별 + §B [UX Laws] / Dark Pattern 검증 의무 박음
[Next] C4 propagation 시 자식 repo 의무 적용
[Refs] task: C7-UX-LAWS-INTEGRATION-001 · 공식: Laws of UX (Yablonski) + Dark Patterns (Brignull) + FTC + EU DMA · parent: <C6 commit hash>
COMMIT
)"
```

---

`Sources:`
- [Laws of UX - Jon Yablonski](https://lawsofux.com/)
- [Deceptive Design (Dark Patterns) - Harry Brignull](https://www.deceptive.design/)
- [FTC Dark Patterns Report 2022](https://www.ftc.gov/reports/bringing-dark-patterns-light)
- [Material Design 3](https://m3.material.io/)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)
- [.claude/rules/ux-laws.md (신설)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/rules/ux-laws.md)
- [.claude/agents/active/ux-auditor.md (갱신)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/agents/active/ux-auditor.md)
- [.claude/agents/active/reviewer.md (갱신)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/agents/active/reviewer.md)
- [.claude/rules/code-principles.md (§4 H)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/.claude/rules/code-principles.md)
- [docs/guides/app-implementation-guide.md (§4.5)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/docs/guides/app-implementation-guide.md)
