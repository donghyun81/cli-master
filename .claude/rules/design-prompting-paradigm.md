# Design Prompting Paradigm (Pencil 측 Effective Prompting)

> **단일 목적**: Pencil / 다른 design tool 측 AI agent 호출 시 효과적인 prompt 작성 paradigm. 공식 doc 4 원칙 + 본 패키지 적용 형식 통합.
> **신설**: MASTER-CLI-PENCIL-OPTIMIZATION-001 (2026-05-19).
> **공식 근거**: pencil.dev `/getting-started/ai-integration` "Effective Prompting" 섹션 (2026-04-03).
> **연관 파일**:
> - `pencil-uiux-workflow.md` §3 5-type IMPL — agent 측 design prompt 발행 시점 정합
> - `cycle-discipline.md` §7 commit body 6-항 — design cycle commit 측 prompt context 흡수 paradigm
> - `code-principles.md` — KISS + YAGNI 정합 (over-prompting 회피)
> SOT: `CLAUDE.md`

---

## 1. Be Specific — 측정 가능한 prompt 의무

design domain agent 호출 시 prompt 안 구체적 측정값 또는 명시적 결과 의무. 모호한 형용사 prompt 금지.

| 패턴 | 예 | 권장 / 차단 |
|---|---|---|
| 차단 | "Make it better" | ✗ — 측정 불가 |
| 차단 | "Add some style" | ✗ — 결과 정의 부재 |
| 차단 | "Fix the layout" | ✗ — 변경 범위 모호 |
| 권장 | "Increase the button padding to 16px and change color to blue" | ✓ — 측정값 + 결과 명시 |
| 권장 | "Add 8dp vertical spacing between list items" | ✓ — 단위 + 위치 명시 |
| 권장 | "Make the header background `#1A1A1A` and text `#FFFFFF`" | ✓ — hex 값 직접 명시 |

### 1.1 권장 measurable 카테고리

- spacing: `8dp` / `16px` / `24pt`
- color: hex `#1A1A1A` / Material token `surface.primary` / Pencil variable name
- typography: weight `semibold` / size `16sp` / line-height `1.5`
- size: `48dp` (Fitts ≥ 48dp 정합 · `ux-laws.md` §C-2) / `100%` width
- count: "4 navigation items" / "≤ 7 list items"

---

## 2. Provide Context — 결과 구성요소 명시

agent 측 추측 영역 최소화. 신규 component 측 모든 child + 모든 state 명시.

| 패턴 | 예 | 권장 / 차단 |
|---|---|---|
| 차단 | "Add a form" | ✗ — child / validation 모호 |
| 차단 | "Create a screen" | ✗ — 구성요소 부재 |
| 권장 | "Add a login form with email, password, remember-me checkbox, and submit button" | ✓ — 4 child 명시 |
| 권장 | "Create a settings screen with 3 sections: Account · Notifications · Privacy. Each section has a header + 2~3 toggle rows." | ✓ — 계층 + count 명시 |

### 2.1 권장 context 카테고리

- child component list (정확한 갯수 + 의미)
- 각 child 의 state variant (empty / loading / error / success)
- responsive breakpoint 영역 (mobile / tablet / desktop · 자식 repo 측 Compose 단일 = mobile portrait default)
- 접근성 marker (`contentDescription` / role / minimum touch target)

---

## 3. Reference Design Systems — 기존 자산 참조 의무

새 자산 신설보다 기존 자산 활용 우선. 본 패키지 안 `app-foundation/core/designsystem/` 측 Theme.kt 단일 source 정합.

### 3.1 공식 doc 측 권장 패턴

- "Use our existing button component"
- "Follow the spacing scale from our variables"
- "Match the style of the header component"

### 3.2 본 패키지 측 구체화

- "Use the `app-foundation/core/designsystem/.../Theme.kt` color palette — do not introduce new hex"
- "Apply the spacing scale defined in Pencil variables (4dp · 8dp · 16dp · 24dp · 32dp)"
- "Match the typography of `MaterialTheme.typography.titleMedium` / `bodyLarge` / `labelSmall`"
- "Reuse the existing `PrimaryButton` composable instead of inline `Button(...)`"

### 3.3 신규 자산 신설 진입 조건

위 reference 모두 unmatch 시점 = 신규 token / component 신설 검토. 절차:
1. agent prompt 안 "신규 token 또는 component 가 필요한 이유 설명" 의무
2. 신설 prompt = 별도 cycle 분리 (현 cycle 안 신설 X · 의도 분리)
3. design system 측 SoT 신규 entry → propagation cycle 진입

---

## 4. Iterative Design — 4 단계 점진 진입

한 prompt 안 모든 디테일 의무 X. 4 단계 점진 paradigm:

| 단계 | 본질 | 예 prompt |
|---|---|---|
| **1. Start broad** | layout 골격 | "Create a dashboard layout" |
| **2. Refine** | 주요 section 추가 | "Add a sidebar with navigation items" |
| **3. Detail** | state + interaction | "Style the nav items with hover and active states" |
| **4. Polish** | spacing + alignment | "Adjust all spacing to match an 8dp grid" |

각 단계 마감 후 시각 검증 (= §5) 후 다음 단계 진입. 한 prompt 안 4 단계 압축 시 agent 측 의도 추측 영역 증가 → 결과 품질 저하 + 회귀 비용 누적.

### 4.1 본 패키지 cycle 측 매핑

| 단계 | Phase 매핑 |
|---|---|
| 1 broad | Phase A (신규 screen Pencil canvas 신설) |
| 2 refine | Phase A 안 sub-step (component 추가) |
| 3 detail | Phase B-DETAIL (시각 정밀화) |
| 4 polish | Phase B-DETAIL 마감 + Phase C 진입 직전 |

---

## 5. Verification — 4 단계 검증 의무

AI 변경 후 의무 검증 4 step:

| step | 무엇 | 도구 |
|---|---|---|
| **1. Review visually** | canvas 측 시각 확인 | desktop app viewport 또는 `get_screenshot` PNG |
| **2. Check structure** | layers panel 측 계층 확인 | `get_editor_state` + `snapshot_layout(problemsOnly=true)` |
| **3. Test interactions** | 적용 영역 측 동작 | `mcp__pencil__batch_get` 또는 Compose preview |
| **4. Ask for screenshots** | 복잡 layout 측 검증 의무 | `get_screenshot` 또는 `export_nodes` PNG |

`design-to-code-sync.md` §4 Output Checklist P10 정합. screenshot disk 갱신 의무.

### 5.1 STOP 조건

- step 1~3 PASS 단 step 4 (screenshot) skip → REVIEW FAIL 위험. 복잡 layout (3+ section · 5+ child) 측 screenshot 의무.
- 검증 도중 unexpected state 발견 → 즉시 STOP + Coin 재확인 의뢰. 자동 재 prompt 금지.

---

## 6. cycle-discipline §7 commit body 정합

design domain cycle 안 commit body 6-항 ([Goal][Diff][Sha][EC][Next][Refs]) 측 prompt context 흡수 paradigm:

```
[Goal]   <단계> 측 <screen> design 의도 진입 (Iterative §4 단계 N)
[Diff]   <screen>.pen + <screen>.ui-spec.json + (해당 시) preview.png
[Sha]    .pen new-sha-8 · ui-spec lastSyncedDesignToolStateHash 정합
[EC]     verify §5 4-step PASS (visual + structure + interaction + screenshot)
[Next]   <다음 단계> 또는 Phase C 진입
[Refs]   parent · prompt 인용 (= "<measurable prompt>") · §5 verification 결과
```

prompt 본문 = commit body 안 직접 인용 (= reproducibility · 후속 cycle 측 context 회복 source).

---

## 7. Measurable example 의무 (prompt 발행 시점)

agent 측 prompt 발행 직전 self-check 3 항목:

| check | 통과 조건 |
|---|---|
| measurable values | 적어도 1 측정값 (hex / dp / sp / count) 명시 |
| named references | 적어도 1 기존 자산 인용 (Theme.kt / Pencil variable / existing component) |
| scope bounds | 변경 범위 명시 (해당 screen / 해당 component 명) |

3 항목 모두 통과 시점만 prompt 발행 가능. 1+ 부재 시 prompt 재작성 의무.

### 7.1 anti-pattern 검출

- "modernize the UI" → measurable 0 / scope 모호 → FAIL
- "make it look nicer" → measurable 0 / reference 0 → FAIL
- "follow Material Design" → reference 모호 (M2 / M3 / M3 expressive 미명시) → FAIL

---

## 8. §FREEDOM 영역 (design domain prompt authoring)

본 SoT 측 핵심 contract (= §1~§7) 외 영역은 cli session / Coin 본인 측 자율 결정. paste source `MASTER-CLI-PENCIL-OPTIMIZATION-001` §5 §FREEDOM.3 정합.

### 8.1 자율 영역

- prompt 안 어휘 선택 (영어 / 한국어 / 혼용)
- 4 단계 (broad → refine → detail → polish) 안 단계 별 boundary 결정
- reference 자산 선택 우선순위 (Theme.kt vs Pencil variable vs existing component)
- model 선택 (haiku / sonnet / opus · `pencil-cli-headless.md` §8 정합)

### 8.2 의무 영역 (자율 X)

- measurable values 1+ 명시 (§1)
- context (child + state) 명시 (§2)
- 신규 자산 신설 시점 = 별 cycle 분리 (§3.3)
- verification 4-step 완전 실행 (§5)
- commit body 6-항 prompt 인용 (§6)

---

## 9. 본 SoT 의 변경 정책

- cli infra 권장 byte-identical (6-repo · master + 5 자식)
- 변경 시 master cycle 신설 + 6-repo propagation (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## 10. 명시 cycle 이력

- 2026-05-19 · MASTER-CLI-PENCIL-OPTIMIZATION-001 · 본 SoT 신설 + 5-repo byte-identical propagation
