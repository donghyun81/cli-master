# Dependency Decision Checklist — 8개 항목

> **목적**: `libs.versions.toml` 에 새 항목을 추가하기 전에 반드시 통과해야 할 8개 판정 항목.
> **강제 메커니즘**: reviewer 측 `git diff --name-only` 실측 — libs.versions.toml 변경 감지 (구 `compound-lint.sh` 8c 게이트 = deprecated · 도구 부재 · MASTER-CLI-COMPOUND-LINT-DEPRECATE-001). PLAN.md 텍스트 누락 시 REVIEW FAIL.

---

## 1. 8개 항목

| # | 항목 | 평가 기준 |
|---|---|---|
| ① | 공식·표준 지위 | 공식 첫번째 후보인가, 사실상 표준인가, 사용처가 검증된 라이브러리인가 |
| ② | 유지보수 품질 | 최근 12개월 내 활동, 이슈 응답, 보안 패치 빈도 · 보안 취약점 history (CVE) · 라이센스 호환성 (배포·legal 적합성) |
| ③ | KMP·CMP 호환 | common artifact 가 있는가, 또는 platform-shell-only 로 제한 가능한가 |
| ④ | transitive 비용 | 추가되는 간접 의존성 수 · APK / Bundle / Framework 사이즈 영향 · ProGuard / R8 keep rule (빌드 통합 비용) |
| ⑤ | 기존 기능 중복 여부 | repo 내 이미 충족 가능한 기능과 중복되지 않는가 |
| ⑥ | 제거 난이도 | 향후 교체·삭제 비용 (얼마나 많은 코드가 침투되는가) · 제거 절차 (cleanup 후보 시점) |
| ⑦ | 직접 구현 대비 우위 | 직접 구현보다 라이브러리가 더 저렴하고 안전한 명확한 근거 (LOC + 유지비 정량 비교) |
| ⑧ | UI 라이브러리 특별 정당화 | UI 라이브러리의 경우 KMP 호환 + Compose 기본 기능으로 불가하다는 증거 (상세 억제 정책 canonical = `.claude/rules/ui-ux-analysis.md` §UI 라이브러리 억제 기본값) |

> **흡수 차원** (= MASTER-CLI-DEPENDENCY-DECISION-RECONCILE-001 · grow-only merge): 위 ②④⑥⑦ 하위 기준 = 직전 `code-principles.md` 의 고유 Android 빌드/보안 축(라이센스 호환성 · CVE history · APK/Bundle size · ProGuard/R8 keep rule · 제거 절차 · 직접 구현 LOC 비교)을 흡수한 결과. **8 first-class 항은 불변** — PLAN.md 스키마(`reporting.md §5`) + REVIEW Dependency Governance 게이트(구 compound-lint 게이트 = deprecated)가 모두 8항을 기준으로 하므로 항 수를 늘리지 않고 하위 기준으로 흡수한다.

---

## 2. PLAN.md 작성 형식

```markdown
## 2. DependencyDecision

| 항목 | 값 |
|---|---|
| Library | io.insert-koin:koin-core:3.5.6 |
| ①공식·표준 지위 | KMP 환경에서 가장 널리 사용되는 DI 프레임워크. 공식 KMP 지원 |
| ②유지보수 품질 | 매월 활발한 commit, 보안 이슈 평균 응답 1주 |
| ③KMP·CMP 호환 | common artifact 제공, iOS native 환경에서 검증됨 |
| ④transitive 비용 | kotlin-stdlib 외 추가 transitive 없음 |
| ⑤기존 기능 중복 여부 | 현재 수동 DI container 가 thin bridge — 전면 대체 |
| ⑥제거 난이도 | 모듈 정의 파일에 격리되어 제거 시 수정 범위 명확 |
| ⑦직접 구현 대비 우위 | KMP 환경 ViewModel scoping을 직접 구현하는 비용보다 라이브러리가 안전 |
| ⑧UI 라이브러리 특별 정당화 | N/A (DI 라이브러리) |
```

`N/A` 도 명시. 항목 누락 또는 빈 값은 REVIEW FAIL.

---

## 3. UI 라이브러리 특별 정책 (canonical = ui-ux-analysis)

UI 라이브러리 억제 정책의 **canonical** = `.claude/rules/ui-ux-analysis.md` §UI 라이브러리 억제 기본값. 강도(직접 구현 우선 default · 외부 UI 라이브러리 도입 금지 default · 사용자 명시 승인 필수) + per-category 보수 기본값(차트 / 애니메이션 / 컴포넌트 / 이미지 / Markdown) + UI vs 인프라 판별 테스트 = 본 canonical 단일 소유.

본 §1 의 ⑧ "UI 라이브러리 특별 정당화" 는 **게이트 항으로 유지**(= PLAN.md 작성 시 필수 기술 항목)하되, 어떤 카테고리를 어떤 강도로 억제하는지의 상세는 위 canonical 을 따른다.

---

## 4. 라이브러리 변경 감지

reviewer 가 `git diff --name-only` 실측으로 `libs.versions.toml` 변경을 감지한다 (구 `compound-lint.sh` 자동 감지 = deprecated · 도구 부재):
- 변경 있음 → PLAN.md `## 2. DependencyDecision` 섹션에 8개 항목 모두 존재해야 함
- 8개 항목 중 하나라도 누락 또는 빈 값 → REVIEW FAIL
- 변경 없음 → PLAN.md 에 `N/A` 명시 (섹션 자체는 유지)

PLAN.md 텍스트 참조 또는 EVIDENCE.md 텍스트 기반 판정은 사용하지 않는다 — git status 가 단일 기준.

---

## 5. 직접 구현 우선 원칙과의 관계

- 새 라이브러리 추가 전에 직접 구현이 더 단순한지 먼저 평가
- 추상화는 변동성 경계에서만 (network, DB, file system, time, identity, billing, feature flags, platform SDK wrapping)
- SoftBudget 초과 예상 시 라이브러리 추가가 아니라 task 분할 우선

---

## 6. 관련 문서

- `KOIN_DI_BASELINE.md` — Koin 의존성 추가 시 ⑧ 항목 N/A 적용
- `.claude/rules/workflow-core.md` §신규 의존성 승인 — PLAN `## 2. DependencyDecision` 위치 + REVIEW FAIL 게이트 (구 compound-lint 8c = deprecated · 8항 본문 canonical = 본 file)
- `.claude/rules/code-principles.md` §신규 의존성 도입 의무 — 코드 원칙 맥락 (라이브러리 사용 최소화 · 8항 본문 canonical = 본 file)
- `.claude/rules/ui-ux-analysis.md` §UI 라이브러리 억제 기본값 — UI 억제 강도 + per-category canonical (본 §3 가 가리킴)
