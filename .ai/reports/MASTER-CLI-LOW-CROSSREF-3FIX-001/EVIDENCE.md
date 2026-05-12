## Requirements Source

- 사용자 cycle prompt `MASTER-CLI-LOW-CROSSREF-3FIX-001` 직 인용 (본 turn 진입 메시지)
- 3 LOW 사고 단일 cycle 묶음 mitigation:
  - L2-#3: cycle-discipline §3 본문 안 cli infra 권장 byte-identical 영역 명시 X (= "다른 룰 파일은 repo-specific 가능" 단순 명시 영역 · CLAUDE.md §2 cli infra "53 + α" 영역 정합 정의 추가 의무)
  - L3-1: verification-and-review L46 (= prompt 측 명시 L48) "§5 Model Separation 추가 필수" 영역 — 어느 file 안 §5 인지 명시 X
  - L3-8: routing-and-delegation L126 Evaluator 표 안 "read-only 분석 11 종 (ux-auditor, backend-api-architect 등)" — backend-api-architect [DEFERRED] 표기 X · 분석 전문가 표 [DEFERRED] 패턴 정합 정정 의무
- false positive 2 영역 (cycle prompt 안 명시):
  - L3-2: code-principles L158 `cycle-discipline.md §3 §15 패턴 1` = file + § 명시 정합 ✓ (false positive)
  - L3-9: reviewer.md description `ux-laws.md §6 §B [UX Laws]` 명시 정합 ✓ (false positive)
- Authority boundary: 3 file 본문 안 cross-ref 영역만 (1 단락 추가 + L46 정정 + L126 표기 추가). 본문 본질 영역 (보호 5종 list / §5 Model Separation 본질 / Evaluator 표 본질) 무접촉.

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | cli infra ops-layer (3 rule file cross-ref 정합 · LOW 잔존 사고 묶음 mitigation) |
| Reading Mode | cli 운영 레이어형 |
| Requirement Source | 사용자 cycle prompt (직 인용 + STOP 9 조건 명시됨 + BASELINE 정합) |
| Info Gap | RESOLVABLE_IN_REPO (reference 영역 모두 disk 측 read 마감 · workflow-core 모델 분리 영역 실측 정합) |
| STOP Risk | Low (보호 5종 sha 변동 X · 본문 본질 영역 변경 X · cross-ref 영역만) |
| Read-Only Fan-Out | N/A (단일 cycle · 3 file 영역만) |
| Implementer Entry | Allowed (pre-EVIDENCE 계약 본 file 로 고정) |

## Pre-EVIDENCE Contract

- Read evidence:
  - cycle-discipline.md L40-49 §3 영역 (보호 5종 list + L49 "다른 룰 파일은 repo-specific 가능" 단락)
  - verification-and-review.md L46 (= prompt 측 명시 L48 · file 측 baseline = L46) "§5 Model Separation 추가 필수" 영역
  - routing-and-delegation.md L126 Evaluator 표 영역 + L40-58 §분석 전문가 표 [DEFERRED] 패턴
  - workflow-core.md L241 "### 모델 분리 (Model Separation)" 영역 (= §5 영역 실측 정합)
  - code-principles.md L137 "## 5. 위반 시 처리" 영역 (= §5 영역 측 Model Separation 영역 X 검증)
- Remaining gaps: 없음 (§5 영역 실측 결과 = `workflow-core.md "### 모델 분리 (Model Separation)"` 정합 · STOP 8 미발동)
- Chosen path: STEP 0~6 workflow-core 9 단계 정합 · master 단일 commit (3 file) → propagate.sh → 자식 3-repo single commit each → verify-sync
- Hold / Stop reasons: STOP 9 조건 (보호 5종 sha 변동 / §3 보호 list 영역 변경 / L46 §5 본질 변경 / L126 Evaluator 표 본질 변경 / scope 외 file 변경 / propagate mismatch / cycle scope 부풀음 / workflow-core 실측 X 추정 wording / 무관 WT dirty stage 흡수)
- Implement entry conditions: 4-repo HEAD = `fdbd726/5e3370e/e24ae2a/7a5a099` MATCH ✓ · 본 cycle 3 영역 file sha (`5ba63684 / b107f7c9 / 059d80d8`) MATCH 4-repo byte-identical ✓ · 보호 5종 sha baseline MATCH ✓ · §5 영역 실측 정합 (STOP 8 미발동) ✓

## Collect Results

### 매칭 파일/패턴 (변경 대상 3 file)

- `claude-cli-master/.claude/rules/cycle-discipline.md` sha `5ba63684731cd8da…` (4-repo byte-identical) — L2-#3: §3 L40-49 영역 (보호 5종 list + L49 단순 명시) 안 cli infra 권장 byte-identical 영역 단락 추가
- `claude-cli-master/.claude/rules/verification-and-review.md` sha `b107f7c98b735c5e…` (4-repo byte-identical) — L3-1: L46 "§5 Model Separation 추가 필수" 영역 안 file 명시 추가 (`workflow-core.md "### 모델 분리 (Model Separation)" §implement` 정합)
- `claude-cli-master/.claude/rules/routing-and-delegation.md` sha `059d80d8434a1d2b…` (4-repo byte-identical) — L3-8: L126 Evaluator 표 안 `backend-api-architect` 옆 `[DEFERRED]` 표기 추가

### Reference 본문 영역 (read-only · 본문 작성 reference)

#### §5 영역 실측 (L3-1 정정 영역 매핑 의무 · STOP 8 정합)

**workflow-core.md L241 "### 모델 분리 (Model Separation)"**:
- §implement 안 영역 (= L184 "### 직접 구현 우선 원칙" + L190 "### Risk 기반 산출물 경량화" 등 §implement 영역 안 row)
- L194 "Risk 기반 산출물 경량화" 표 안 같은 wording (= "UI 레이어 변경(Screen/ViewModel/UiState 신규·수정) 포함 시 §5 Model Separation 추가 필수") = verification-and-review L46 영역 mirror baseline
- L250 "PLAN `## 4. ModelBoundaryPlan` 섹션에 모델 분리 영향을 명시한다."

→ verification-and-review L46 측 §5 영역 = **workflow-core.md "### 모델 분리 (Model Separation)"** 영역 정합 (= §implement 안 영역).

**code-principles.md L137 "## 5. 위반 시 처리"** = §5 영역 측 Model Separation 영역 X (= 위반 시 mitigation 패턴 영역). → code-principles.md §5 = L3-1 영역 정정 매핑 영역 X.

#### routing-and-delegation §분석 전문가 표 [DEFERRED] 패턴 (L3-8 정정 영역 reference)

L40-58 §분석 전문가 표 영역 = `[DEFERRED]` 표기 패턴 = "필요한 전문 판단" cell 안 `[DEFERRED]` prefix:

```
| [DEFERRED] API 계약 안전성, Breaking change | backend-api-architect | `.claude/agents/deferred/backend-api-architect.md` |
| [DEFERRED] 데이터 보존, 마이그레이션 위험 | data-schema-guardian | `.claude/agents/deferred/data-schema-guardian.md` |
| [DEFERRED] ANR/메모리/Rate limit 위험 | performance-reliability-engineer | `.claude/agents/deferred/performance-reliability-engineer.md` |
| [DEFERRED] 테스트 커버리지 공백, 회귀 위험 | test-strategist | `.claude/agents/deferred/test-strategist.md` |
| [DEFERRED] 관측성, 로그 안전, 크래시 추적 | observability-ops-analyst | `.claude/agents/deferred/observability-ops-analyst.md` |
| [DEFERRED] 배포 위험, 롤백 전략 | release-risk-manager | `.claude/agents/deferred/release-risk-manager.md` |
| [DEFERRED] 비즈니스 정책, 불변 원칙 충돌 | domain-policy-analyst | `.claude/agents/deferred/domain-policy-analyst.md` |
| [DEFERRED] 오프라인/동기화/충돌 해결 | sync-offline-state-specialist | `.claude/agents/deferred/sync-offline-state-specialist.md` |
```

→ L126 Evaluator 표 안 `read-only 분석 11 종 (ux-auditor, backend-api-architect 등)` 영역 = backend-api-architect 옆 `[DEFERRED]` 표기 추가 영역 정합.

#### CLAUDE.md §2 cli infra 영역 (L2-#3 정정 영역 reference)

CLAUDE.md §2 정합성 강제 3 등급 표 = cli infra (권장) "53 + α — `.claude/` 전체 + `.claude/settings.json` 등 · 권장 byte-identical · lazy 가능 · 다음 cycle 영향 시 mitigation" 영역. → cycle-discipline §3 측 cli infra 단락 추가 영역 = CLAUDE.md §2 영역 정합 정합.

### 0 Matches (부재 증거)

- master cycle-discipline.md §3 본문 안 cli infra 권장 byte-identical 영역 명시 단락 = 부재 (= L2-#3 사고 영역 정합)
- master verification-and-review.md L46 안 §5 영역 file 명시 = 부재 (= L3-1 사고 영역 정합 · §5 영역 측 file 명시 X)
- master routing-and-delegation.md L126 안 backend-api-architect [DEFERRED] 표기 = 부재 (= L3-8 사고 영역 정합)

## Key Findings

### 사전 baseline 실측 결과

| 항목 | 실측값 | baseline expectation |
|---|---|---|
| 4-repo HEAD | `fdbd726/5e3370e/e24ae2a/7a5a099` | prompt BASELINE 정합 100% ✓ |
| cycle-discipline.md sha (4-repo) | `5ba63684731cd8da…` | byte-identical MATCH ✓ |
| verification-and-review.md sha (4-repo) | `b107f7c98b735c5e…` | byte-identical MATCH ✓ |
| routing-and-delegation.md sha (4-repo) | `059d80d8434a1d2b…` | byte-identical MATCH ✓ |
| 보호 5종 sha | `f1edd397/ee377dc2/e5e3fe16/7621013e/96de2f5d` | baseline MATCH ✓ |
| §5 영역 실측 (L3-1 정정) | `workflow-core.md "### 모델 분리 (Model Separation)"` L241 정합 | STOP 8 정합 ✓ |
| §분석 전문가 표 [DEFERRED] 패턴 (L3-8 정정) | "필요한 전문 판단" cell 안 `[DEFERRED]` prefix | 패턴 정합 ✓ |

### Cleanup Assessment

ops-layer task (cli infra rules cross-ref 정합) · 제품 코드 무접촉.

본 cycle scope = §3 cli infra 단락 추가 + L46 §5 file 명시 정정 + L126 [DEFERRED] 표기 추가 만. legacy-cleanup-governance.md §code-level cleanup 영역 외.

코드 측 cleanup assessment: N/A (ops-layer task — 제품 코드 미변경)
