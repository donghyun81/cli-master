# Design → Code Sync Rules (도구 무관)

> **단일 목적**: Design SoT → Code 단방향 sync 의 **도구 무관 일반 패턴** — Phase 분류 / 5-type IMPL 흐름 / Output Checklist / STOP 조건 / Refresh Trigger 연계.
> **C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 신설** (Q2 답 추가).
> **도구 바인딩 분리**: 본 파일 = 70% 공통. 도구별 바인딩 = 별 파일:
> - Pencil 바인딩: `pencil-uiux-workflow.md` (도구 바인딩 30%)
> - Figma 바인딩: 향후 신설 시 `figma-uiux-workflow.md` patterns
> - Sketch / Adobe XD: 향후 신설 시 동일 patterns
>
> **연관 파일**:
> - `design-sot-policy.md` (보호 · dual-layer SoT 정책)
> - `uiux-sot-refresh.md` (보호 · refresh trigger 분류 · 의미 = design-sot-refresh)
> - `pencil-uiux-workflow.md` (Pencil 도구 바인딩 구체화)
> SOT: `CLAUDE.md`

---

## 1. SoT 계층 (Option B dual-layer)

모든 화면은 두 SoT 파일 유지:
- **Visual SoT** (`<screen>.<ext>`) — 디자인 도구의 캔버스 파일 (Pencil = .pen / Figma = .fig)
- **Structural SoT** (`<screen>.ui-spec.json`) — 구조 + 의미 + sync hash

두 SoT 가 sha 로 동기 (`lastSyncedDesignToolStateHash` 필드).

---

## 2. 프레임 층위 라벨 (도구 무관)

각 frame 의 lifecycle 라벨:
- `[CURRENT]` — 현 production reflect
- `[TARGET]` — 다음 cycle 목표
- `[LOCKED]` — Stage 3 검증 완료 + 변경 시 즉시 STOP
- `[ARCHIVED]` — 사용 안 함 + history 보존

---

## 3. Phase 분류 (5-type IMPL)

자식 repo 의 Compose / SwiftUI 등 코드 안에서 Design SoT 를 IMPL 할 때 5-type 분류:

| type | 정의 | 진입 조건 | 흐름 |
|---|---|---|---|
| **1. drift 정정** | SoT = 정답 / Code outdated | `verify-sync.sh` drift 발견 | SoT → Code 단방향 sync (Path 2-A 표준) |
| **2. SoT 신설** | 신규 화면 / SoT + Code 동시 신설 | 신규 feature cycle | SoT 먼저 + Code 후 (도구 바인딩 별 절차) |
| **3. Phase R (역공학)** | SoT 부분 부재 + Code + preview.png 로 [CURRENT] 역공학 | `.<design-tool-ext>` 부재 화면 진입 | 도구 바인딩 별 patterns + `design-sot-policy.md` §Phase R |
| **4. 초기 신설** | 빈 repo + 모든 화면 SoT 동시 신설 | 신규 자식 repo 신설 cycle | bulk SoT 신설 + Code stub |
| **5. 일괄 갱신** | 여러 화면 동시 변경 (예: 디자인 시스템 v2 도입) | 디자인 시스템 cycle | sub-batch 분할 + 진행도 가시화 |

---

## 4. Output Checklist P1~P9

모든 IMPL cycle 마감 시 본 9 체크 의무:

- **P1**: Visual SoT (`<screen>.<ext>`) 디스크 존재 + sha 갱신
- **P2**: Structural SoT (`<screen>.ui-spec.json`) 디스크 존재 + `lastSyncedDesignToolStateHash` = full 64자 sha
- **P3**: 두 SoT 의 sha 일치 (`verify-sync.sh` 자식 repo 안)
- **P4**: Code (Compose / SwiftUI 등) 빌드 PASS
- **P5**: preview.png 갱신 (Phase D 검증 자동화 · 도구 바인딩별 patterns)
- **P6**: lifecycle 라벨 정합 (`[CURRENT]` / `[TARGET]` / `[LOCKED]` / `[ARCHIVED]`)
- **P7**: cleanup pass (`legacy-cleanup-governance.md` 명시됨)
- **P8**: VERIFY.md exit code 기록
- **P9**: REVIEW.md PromptFit 평가 + INDEX.md 갱신
- **P10**: 시각 검증 자산 disk 갱신 — `get_screenshot` (PNG render) 또는 `export_nodes` (PNG / JPEG / WEBP / PDF) 호출 후 결과 file 의 sha 변동 확인 (preview.png paradigm 정합 · `MASTER-CLI-PENCIL-OPTIMIZATION-001` 안 추가)
- **P11**: deferred (code-first) 시 `DESIGN-DEBT.md` 등재 확인 (해당 시 · §10 Deferred Design Debt lane 정합 · 즉시 의무 type 은 N/A)

---

## 5. STOP 조건 (도구 무관)

- `[LOCKED]` 라벨 frame 변경 시도 → 즉시 STOP + Coin 명시 승인 의무
- 두 SoT 의 sha 불일치 + 어느 것이 정답인지 모호 → STOP + Phase 1 (drift 정정) 또는 Phase R (역공학) 결정 의무
- 디자인 도구 자동화 실패 + fallback 도 실패 → STOP + Coin GUI 손 작업 분리
- Code 빌드 깨짐 + SoT 변경이 원인 추정 → STOP + rollback 평가

---

## 6. DELETE / Lifecycle 절차

- `[ARCHIVED]` 전환 = SoT 파일 mv (`docs/design/<tool>-sot/archive/<yyyymmdd>/`) + ui-spec.json `lifecycle: archived`
- 완전 삭제 = Coin 명시 승인 + commit body `[Sha]` + propagation 의무

---

## 7. Refresh Trigger 연계

`uiux-sot-refresh.md` (보호 · 의미 = design-sot-refresh) 의 FULL / PARTIAL / DOC-ONLY 분류 따름.

---

## 8. 도구 바인딩 의무 (구체화)

본 rule = 도구 무관 패턴. 실 자동화 + 도구 호출은 별 파일에서 추가:

| 도구 | 바인딩 파일 | 자동화 hook |
|---|---|---|
| Pencil | `docs/rules/pencil-uiux-workflow.md` + `docs/rules/pencil-automation.md` | `.claude/hooks/pencil-auto-save.sh` (= auto trigger) + `scripts/save-as-result-check.sh` (= 수동 helper · MASTER-CLI-CLEANUP-7CYCLE-001 S4 이동 마감) |
| Figma | (향후 신설) `figma-uiux-workflow.md` + `figma-automation.md` | (향후) `figma-auto-export.sh` |
| Sketch | (향후) `sketch-uiux-workflow.md` | (향후) `sketch-auto-export.sh` |

신규 도구 도입 시:
1. 본 `design-to-code-sync.md` 의 5-type 분류 + Output Checklist 그대로 사용
2. 도구별 `<tool>-uiux-workflow.md` + `<tool>-automation.md` + `<tool>-auto-save.sh` 신설
3. master cycle 으로 신설 + propagation

---

## 9. Variables ↔ Code Sync paradigm (`MASTER-CLI-PENCIL-OPTIMIZATION-001`)

design 도구 측 variable / token 과 코드 측 theme / token 간 양방향 sync. pencil.dev 공식 doc (Variables + Design ↔ Code page · 2026-04-03) 명시 paradigm 본 §9 에 흡수.

### 9.1 design tool → code (token export 방향)

agent prompt 패턴 (도구 무관 일반형):
- "Update `<code-token-file>` with these `<design-tool>` variables"
- "Sync design tokens from `<design-tool>` to my code"
- "Export `<design-tool>` variables as `<code-format>` constants"

### 9.2 code → design tool (token import 방향)

agent prompt 패턴:
- "Create `<design-tool>` variables from my `<code-token-file>`"
- "Import design tokens from `<code-token-file>` into `<design-tool>`"

### 9.3 본 패키지 Compose 측 구체화

자식 repo (GB / GD / GT) 측 Compose theme 단일 source = `app-foundation/core/designsystem/.../Theme.kt`. Pencil variables ↔ Compose Theme 측 양방향 sync prompt 권장 형식:

- "Create Pencil variables from app-foundation/core/designsystem/.../Theme.kt"
- "Update Theme.kt with these Pencil variables (color palette · typography scale · spacing tokens)"
- "Sync design tokens between Pencil variables and Compose Theme — drift 검출 시 [CURRENT] 라벨 정합 의무"

### 9.4 sync 방향 결정 (drift 발생 시)

| drift 시점 | 정답 (SoT) | sync 방향 |
|---|---|---|
| Pencil 측 신규 variable 추가 | Pencil | design tool → Theme.kt |
| Theme.kt 측 신규 color 추가 (Compose 측 prototype 우선) | Theme.kt | Theme.kt → Pencil |
| 두 측 동시 충돌 | UNKNOWN | STOP → Coin 명시 결정 의뢰 |

Pencil 측 variable 변경 → Phase C type 5 (일괄 갱신) flow 진입. `mcp__pencil__set_variables` 호출 후 inherit 적용된 모든 screen 자동 반영.

### 9.5 Multi-axis paradigm (= `MASTER-CLI-PENCIL-OPTIMIZATION-002` 강화 본문)

Pencil 측 Theme = 단일 axis (= mode 단축) X · 다축 paradigm default. 본 §9.5 = 본 cycle 측 추가 강화 본문 (= H26 단계 1 마감 · pencil.dev `the-pen-format` "Themes" 흡수).

권장 baseline 3 axis:

| axis | 측정값 list | Compose 측 정합 source |
|---|---|---|
| `mode` | light / dark | `isSystemInDarkTheme()` + `LightColorScheme` / `DarkColorScheme` |
| `spacing` | compact / default / comfortable | `LocalGentlySpacing` CompositionLocal + 사용자 설정 |
| `device` | mobile / tablet / desktop | `WindowSizeClass.widthSizeClass` + `LocalConfiguration` |

Pencil document 측 `themes` field 본문:

```json
{
  "themes": {
    "mode": ["light", "dark"],
    "spacing": ["compact", "default", "comfortable"],
    "device": ["mobile", "tablet", "desktop"]
  }
}
```

variable 측 axis 별 cross-product value assignment 가능 (= `typography.body.fontSize` 측 `device + spacing` cross-product 정합 default · 본 §9.5 강화 영역). 본문 단일 SoT = `pencil-theme-multi-axis.md`.

### 9.6 Compose 측 multi-axis mapping paradigm

자식 repo (= GB / GD / GT) 측 Compose Theme 측 multi-axis 정합:

foundation `GentlyTheme` (= `app-foundation/core/designsystem/.../theme/GentlyTheme.kt`) 는 resolved 값을 **주입받는** no-default 시그니처 default (= 기본값 X · 주입 컴파일 강제 · 정체성 색·폰트 단일 source = 각 자식 default):

```kotlin
// foundation 실 시그니처 — colorScheme + typography no-default 주입
@Composable
fun GentlyTheme(
    colorScheme: ColorScheme,   // no-default · 주입 의무
    typography: Typography,      // no-default · 주입 의무
    content: @Composable () -> Unit,
) {
    MaterialTheme(
        colorScheme = colorScheme,
        typography = typography,
        content = content,
    )
}
```

multi-axis (= mode + spacing + device/window 축) 해소 = **caller(per-child 래퍼 `<Child>Theme.kt`) + CompositionLocal provider 측 paradigm** default (= 설계의도 · 현 시점 일부 미구현 영역). foundation `GentlyTheme` 는 내부 도출 X · resolved 값 주입받음 default. mode axis (= `darkMode → colorScheme`) 는 현 per-child 래퍼에서 해소 (= `pencil-theme-multi-axis.md §4.1` 정합) · spacing density (`spacingDensity`) + window size (`windowSize.widthSizeClass`) 축은 caller 가 resolve 후 `CompositionLocalProvider` 로 제공하는 설계의도 default:

```kotlin
// 설계의도(일부 미구현) — caller(per-child 래퍼) 측 multi-axis 해소 paradigm
@Composable
fun <Child>Theme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    spacingDensity: SpacingDensity = SpacingDensity.Default,   // 설계의도 축
    windowSize: WindowSizeClass,                                // 설계의도 축
    content: @Composable () -> Unit,
) {
    val spacing = when (spacingDensity) {
        SpacingDensity.Compact -> CompactSpacing
        SpacingDensity.Default -> DefaultSpacing
        SpacingDensity.Comfortable -> ComfortableSpacing
    }
    val typography = when (windowSize.widthSizeClass) {
        WindowWidthSizeClass.Compact -> MobileTypography
        WindowWidthSizeClass.Medium -> TabletTypography
        else -> DesktopTypography
    }
    CompositionLocalProvider(
        LocalGentlySpacing provides spacing,
        LocalDeviceClass provides windowSize.widthSizeClass.toDeviceClass(),
    ) {
        GentlyTheme(
            colorScheme = if (darkTheme) <Child>DarkColorScheme else <Child>LightColorScheme,
            typography = typography,
            content = content,
        )
    }
}
```

본 패키지 측 Theme 단일 source = `app-foundation/core/designsystem/.../Theme.kt`. 모든 자식 repo 측 본 Theme 측 propagation 의무 default (= cli infra 권장 byte-identical 영역 · `cycle-discipline.md` §3 정합).

### 9.7 multi-axis sync 측 권장 prompt 패턴

- "Update `<Theme.kt>` with all Pencil multi-axis variables (mode + spacing + device axis)"
- "Generate CompositionLocal + Provider Composable per Pencil theme axis"
- "Validate that all Pencil cross-axis variable combinations resolve in Compose runtime"

상세 prompt paradigm = `design-prompting-paradigm.md` §1~§3 (= measurable + context + reference) 정합 의무. multi-axis 단일 SoT = `pencil-theme-multi-axis.md`.

---

## 10. Deferred Design Debt lane (= code-first 허용 시 등재 의무)

> design SoT 갱신을 즉시 하지 않고 code-first 로 진행할 때 (= `uiux-sot-refresh.md` "즉시 의무 vs Deferred" 분기의 deferred 칸) 해당 화면의 시각 부채를 **per-repo 원장에 명시 등재**한다. deferred = "조용한 skip" 아님 · 등재 = 추적 + 출시 전 해소(backstop) 의 진입점.

### 10.1 원장 위치 + 형식

- 위치: 자식 repo root `DESIGN-DEBT.md` (per-repo · markdown · `ui-spec.schema.json` 무접촉 = status 는 원장 row 가 보유 · schema 필드 추가 X)
- INITIATIVES 연계: 해소 task = `docs/release-readiness/INITIATIVES.md` §3 출시 task 층의 동일 화면과 매핑 (= 출시 전 해소 추적)
- 권장 컬럼:

| 화면 | 변경 (visible state) | 등재 cycle/date | 분류 | 해소 task | status |
|---|---|---|---|---|---|
| `<screen>` | `<추가된 visible state 요약>` | `<cycle-id> / YYYY-MM-DD` | `net-new \| reuse` · `pre \| post-launch` | `<해소 cycle-id>` | `OPEN \| RESOLVED` |

### 10.2 등재 / 해소 / backstop 규칙

- **등재 의무**: deferred 허용 항목 (reuse visual / PARTIAL / 미출시 net-new) = 원장 row 추가 의무. 미등재 deferred = REVIEW [Design SoT Sync] WARN (`verification-and-review.md` §14 정합).
- **해소**: 해당 화면 `.pen` + `.ui-spec.json` refresh + dual-layer sha-sync (§4 P1~P3) → row status `RESOLVED` 또는 row 제거.
- **release backstop**: 출시 대상 화면의 OPEN row = release / production-push 게이트 **hard FAIL** (= `verification-and-review.md` §14 release 조항 · `rule-routing-index.md §C` 빌드-릴리즈형 M 정합). 출시 후 net-new visual 은 deferred 불가 (= 선행 의무).

### 10.3 본 lane 의 scope 경계

- per-repo `DESIGN-DEBT.md` 실 entry seeding = 본 lane 신설 cycle 밖 (= 자식별 부채 등재 = 후속 cycle · master = format/규칙 SoT 만 보유).
- 본 lane = code-first 허용의 추적 장치 · 정방향 원칙 (Design SoT → Code) 폐기 아님 (= `design-sot-policy.md` §3 정합).
