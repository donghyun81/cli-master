# UI/UX Analysis Rules

> ui-ux 도메인 관련 분석·구현 규칙.
> 역할: `ux-auditor` (분석), `ui-implementer` (구현)

---

## 수집 대상 (UI/UX)

```
docs/app_overview.ko.md           # 앱 개요 + UX 정책
docs/multiplatform-reboot-package/40_UI_UX_DIRECTION_CMP.md
docs/multiplatform-implementation/30_UI_UX_DIRECTION.md
feature/**/res/values/strings.xml # 화면 문구
app/src/main/res/values/strings.xml
app/src/main/java/**/*Screen*.kt  # 화면 컴포저블
app/src/main/java/**/*ViewModel*.kt
```

## UI/UX Evidence Companion Refresh Candidate

- current baseline companion root: `.ai/uiux-sot/latest/`
- UI touched-file이 `.claude/rules/uiux-sot-refresh.md` 의 trigger 경로와 매칭되면 `FULL` / `PARTIAL` / `DOC-ONLY` refresh candidate로 분류한다.
- current live code inventory를 먼저 다시 읽고, runtime capture가 없으면 `BASELINE_PENDING_REFRESH` 상태로 manifest/coverage/route/matrix만 갱신한다.
- history는 package snapshot이 아니라 git diff로 확인한다.

---

## ux-auditor 역할 (read-only)

앱 개요 문서와 실제 화면/플로우의 불일치를 수집한다.

### 분석 항목
1. 앱 개요 문서의 사용자 여정과 실제 화면 매핑
2. 문서에 명시된 UX 원칙(예: "진단 아닌 관찰") 준수 여부
3. 온보딩 플로우 완전성
4. 에러 상태/빈 상태 처리 여부
5. 접근성 마커 존재 여부

### 출력
- `.ai/reports/<taskId>/EVIDENCE.md` 에 불일치 목록 + 근거(파일:라인) 추가
- 발견사항 없으면 "0 issues found" 기록

---

## ui-implementer 역할 (write 허용)

화면/상태/UI 로직 변경을 최소 수정 원칙으로 구현한다.

### 구현 원칙
- Jetpack Compose 사용 (기존 코드 패턴 우선)
- ViewModel에 UI 로직, 화면은 상태 소비만
- 하나의 화면 = 하나의 Composable (최상위)
- Preview 어노테이션 추가 권장
- `UiState` 는 domain/data 모델과 분리된 불변 data class 로 정의한다
- ViewModel → UI 단방향 흐름 유지 (UI가 상태를 직접 변경하지 않음)
- `UiState` 와 `DomainModel` 은 동일 객체로 사용하지 않는다 — ViewModel 에서 변환한다

### SoftBudget
`.claude/rules/workflow-core.md` 의 SoftBudget 기준을 따른다.

### 금지
- 제품 기능 로직을 UI 레이어에 배치
- 하드코딩 문자열 (strings.xml 사용)
- 해상도 하드코딩 (dp/sp 사용)

---

## UI/UX 변경 순서 — Pencil SoT → Compose

모든 UI/UX 변경은 `.claude/rules/pencil-uiux-workflow.md` 규칙 + `docs/design/pencil-sot-policy.md` 정책을 따른다. 요약:
1. `docs/design/pencil-dev-prompt.md` 갱신 (docs-change-communicator) — `[CURRENT]/[TARGET]/[LOCKED]` 라벨 필수
2. `docs/design/pencil-sot/<screen>.pen` 편집 (Pencil MCP CLI 또는 Coin 수동 GUI fallback)
3. `docs/design/pencil-exports/<screen>/` export (pencil-vars-before/after.json + preview.png)
4. `.ai/uiux-sot/latest/<screen>/` refresh (GT 필수)
5. ui-implementer 가 SoT 우선순위 (`pencil-sot-policy.md` §1) 대로 Compose 구현
6. Compose 측 hex/sp/dp 하드코딩은 `ui/theme/` 외부에서 금지 (리뷰 블로커)

`.pen` 부재 화면은 Phase R (Pencil SoT Recovery) 완료까지 Compose 수정 금지. 예외 경로: `pencil-sot-policy.md` §3.

상세:
- `.claude/rules/pencil-uiux-workflow.md` (고정 순서)
- `docs/design/pencil-sot-policy.md` (SoT 계층 · 프레임 층위 · 역공학 예외)

---

## UI 라이브러리 억제 기본값

새 UI 라이브러리는 **기본적으로 억제**한다. 다음 기준을 모두 충족할 때만 도입한다:

1. **KMP/CMP 호환**: common artifact 또는 platform-shell-only 범위 명시
2. **DependencyDecision 섹션 작성**: PLAN `## 2. DependencyDecision` 에 8개 항목 기술 필수 (`.claude/rules/workflow-core.md` (DependencyDecision) 참조)
3. **기존 Compose 기능으로 불가**: 직접 구현 대비 비용·안전 측면에서 명확히 우위
4. **UiState 분리 유지**: 새 UI 라이브러리 도입 후에도 UiState 는 domain/data 모델과 분리 상태 유지

특히 보수적 기본값 적용 대상:
- **차트/그래프 라이브러리**: Compose Canvas 직접 구현이 기본. 라이브러리는 DependencyDecision 필수
- **애니메이션 라이브러리**: Compose Animation API 기본. 외부 라이브러리는 DependencyDecision 필수
- **커스텀 UI 컴포넌트 라이브러리**: 기존 Material3 + Compose 기본. 도입 전 직접 구현 먼저 평가

UiState 정책:
- `UiState` 는 UI 전용 불변 data class다. 네트워크 DTO · DB Entity · DomainModel 과 혼용 금지
- UI 상태 소유권 감사: ux-auditor 는 UiState 가 domain 모델과 분리되어 있는지, ViewModel → UI 단방향 흐름이 유지되는지 확인한다

---

## KMP/CMP 전환 중 주의사항

본 레포는 현재 KMP/CMP 미도입 상태이며, 아래 가이드는 향후 도입 시 활성화된다.
UI 변경 시:
- `docs/multiplatform-reboot-package/40_UI_UX_DIRECTION_CMP.md` 방향과 정합성 확인
- Android-only 코드 수정 시 → 향후 CMP 전환 시 영향 범위를 TODO.md에 기록
- Compose Multiplatform 전환 예정 영역은 최소 변경 원칙 강화

KMP/CMP 도입 시 SteadyWell SoT에서 관련 섹션(KMP/CMP 호환 게이트, 전환 주의사항 등)을 재propagation한다.
