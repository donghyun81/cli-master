## Requirements Source

- 사용자 cycle prompt `GENTLY-AGENT-METADATA-3FIX-001` 직 인용 (본 turn 진입 메시지)
- 3 사고 단일 cycle 묶음 mitigation:
  - β (L3-4): code-simplifier + layer-checker frontmatter `tools:` 필드 미명시
  - γ (L3-5 HIGH): layer-checker 본문 안 교차권한 금지 5 규칙 #3 명시 X (Evaluator 규격 정합 X)
  - ε (L3-7): domain-roles.md L15~55 안 agent path 표기 `.claude/agents/<name>.md` (실제 `active/` 또는 `deferred/` prefix 누락)
- Authority boundary: 3 file frontmatter + layer-checker 본문 교차권한 단락 + domain-roles path 영역. 본문 wording (domain-roles) + routing/billing/auth/deferred SoT 본문 무접촉.

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | cli infra ops-layer (3 agent file frontmatter + path drift 정정) |
| Reading Mode | cli 운영 레이어형 |
| Requirement Source | 사용자 cycle prompt (직 인용 + STOP 8 조건 명시됨 + BASELINE 정합) |
| Info Gap | RESOLVABLE_IN_REPO (reference 영역 모두 disk 측 read 마감) |
| STOP Risk | Low (보호 5종 변경 X · routing/reviewer/verifier SoT 변경 X · billing-rules 무접촉) |
| Read-Only Fan-Out | N/A (단일 cycle · 3 file 영역만) |
| Implementer Entry | Allowed (pre-EVIDENCE 계약 본 file 로 고정) |

## Pre-EVIDENCE Contract

- Read evidence: code-simplifier.md (51 줄 stub · frontmatter `tools:` 부재) · layer-checker.md (65 줄 본문 + frontmatter `tools:` 부재 + 교차권한 본문 부재) · domain-roles.md (101 줄 navigation index · L15-55 path drift) · reviewer.md L77-103 "Skeptic Evaluator Tuning" (γ wording reference) · verifier.md L1-5 frontmatter (γ 구조 reference · `tools: Read, Glob, Grep, Bash` 표준) · routing-and-delegation.md §Planner/Generator/Evaluator 5 규칙 #3 (γ 핵심 인용 영역)
- Remaining gaps: 없음 (전체 reference disk read 마감 + 3 target file 사전 baseline sha 캡처 완료)
- Chosen path: STEP 0~6 workflow-core 9 단계 정합 · master single commit (3 file) → propagate.sh (3 file 묶음) → 자식 3-repo single commit each → verify-sync
- Hold / Stop reasons: STOP 8 조건 (보호 5종 sha 변동 / routing 본문 변경 / reviewer Skeptic 영역 복제 / domain-roles wording 변경 / 본 cycle scope 외 agent 변경 / propagate cross-verify mismatch / cycle scope 부풀음 / 무관 WT dirty stage 흡수)
- Implement entry conditions: 4-repo HEAD = `d2eb521/0256fa8/d9e6e5e/2ce2e09` MATCH ✓ · 보호 5종 sha baseline MATCH ✓ · 3 target file 4-repo byte-identical (`1b98596e/34f42c7f/86e8b6a7`) MATCH ✓

## Collect Results

### 매칭 파일/패턴 (변경 대상 3 file)

- `claude-cli-master/.claude/agents/active/code-simplifier.md` (51 줄 · sha `1b98596e1fb0f6e5…`) — β: frontmatter `tools:` 필드 추가 (Generator bucket · Read, Glob, Grep, Edit 권장)
- `claude-cli-master/.claude/agents/active/layer-checker.md` (65 줄 · sha `34f42c7f2eb7f396…`) — β: frontmatter `tools:` 필드 추가 (Evaluator bucket · Read, Glob, Grep, Bash 권장) + γ: 본문 교차권한 단락 추가 (routing §5#3 인용 + reviewer.md Skeptic cross-ref 1 줄)
- `claude-cli-master/.claude/agents/active/domain-roles.md` (101 줄 · sha `86e8b6a75b484e53…`) — ε: L15-55 path 영역 `active/` 또는 `deferred/` prefix 추가

### Reference 본문 영역 (read-only · 본문 작성 reference)

- `claude-cli-master/.claude/agents/active/reviewer.md` L77-103 "Skeptic Evaluator Tuning" = γ 영역 wording 패턴 reference + cross-ref 대상 SoT (= layer-checker 본문 안 1 줄 cross-ref 의무)
- `claude-cli-master/.claude/agents/active/verifier.md` L1-5 frontmatter `tools: Read, Glob, Grep, Bash` = β 영역 (layer-checker) Evaluator bucket + Bash 포함 표준 reference
- `claude-cli-master/.claude/rules/routing-and-delegation.md` §Planner/Generator/Evaluator 경계 5 규칙 (system-reminder load 영역 정합) · 규칙 #3 "Evaluator 는 고치지 않는다 — verifier/reviewer/read-only 분석 역할은 직접 코드를 수정하지 않는다. FAIL/PARTIAL 판정 + 구체적 수정 방향 제시 후 change-planner 루프로 돌려보낸다." (γ 본문 안 핵심 인용 영역)
- `claude-cli-master/.claude/agents/active/billing-payments-guardian.md` (134 줄 · 직전 cycle GENTLY-AGENT-BILLING-GUARDIAN-CLEANUP-001 마감 영역) = 표준 6+ 섹션 active agent 본문 reference (= 본 cycle scope 외 · cross-ref X)

### 0 Matches (부재 증거)

- master + 자식 3-repo `.claude/agents/active/code-simplifier.md` 안 frontmatter `tools:` 필드 = 부재 (= β 사고 영역 정합)
- master + 자식 3-repo `.claude/agents/active/layer-checker.md` 안 frontmatter `tools:` 필드 = 부재 (= β 사고 영역 정합)
- master + 자식 3-repo `.claude/agents/active/layer-checker.md` 본문 안 "Evaluator 는 고치지 않는다" 또는 routing §5#3 인용 영역 = 부재 (= γ 사고 영역 정합)
- master + 자식 3-repo `.claude/agents/active/domain-roles.md` L15-55 안 `.claude/agents/active/` 또는 `.claude/agents/deferred/` prefix path = 부재 (= ε 사고 영역 정합)

### ε 영역 분류 매핑 (domain-roles.md L15-55 path drift 정정)

active/ 디렉터리 16 files vs deferred/ 디렉터리 9 files 실측 (= ls 결과) 정합 분류:

**코어 6 (L15-20) → 모두 `active/`**:
| L | role | 분류 | 정정 path |
|---|---|---|---|
| L15 | intake-router | active | `.claude/agents/active/intake-router.md` |
| L16 | requirements-analyst | active | `.claude/agents/active/requirements-analyst.md` |
| L17 | system-architect | active | `.claude/agents/active/system-architect.md` |
| L18 | change-planner | active | `.claude/agents/active/change-planner.md` |
| L19 | verifier | active | `.claude/agents/active/verifier.md` |
| L20 | reviewer | active | `.claude/agents/active/reviewer.md` |

**도메인 분석 8 (L26-33) → 혼합 분류**:
| L | role | 분류 | 정정 path |
|---|---|---|---|
| L26 | ux-auditor | active | `.claude/agents/active/ux-auditor.md` |
| L27 | backend-api-architect | deferred | `.claude/agents/deferred/backend-api-architect.md` |
| L28 | data-schema-guardian | deferred | `.claude/agents/deferred/data-schema-guardian.md` |
| L29 | auth-security-privacy | active | `.claude/agents/active/auth-security-privacy.md` |
| L30 | performance-reliability-engineer | deferred | `.claude/agents/deferred/performance-reliability-engineer.md` |
| L31 | test-strategist | deferred | `.claude/agents/deferred/test-strategist.md` |
| L32 | observability-ops-analyst | deferred | `.claude/agents/deferred/observability-ops-analyst.md` |
| L33 | release-risk-manager | deferred | `.claude/agents/deferred/release-risk-manager.md` |

**문서 거버넌스 2 (L39-40) → 모두 active**:
| L | role | 분류 | 정정 path |
|---|---|---|---|
| L39 | docs-drift-auditor | active | `.claude/agents/active/docs-drift-auditor.md` |
| L40 | docs-structure-architect | active | `.claude/agents/active/docs-structure-architect.md` |

**구현 4 (L46-49) → 혼합 분류**:
| L | role | 분류 | 정정 path |
|---|---|---|---|
| L46 | ui-implementer | active | `.claude/agents/active/ui-implementer.md` |
| L47 | server-implementer | deferred | `.claude/agents/deferred/server-implementer.md` |
| L48 | docs-change-communicator | active | `.claude/agents/active/docs-change-communicator.md` |
| L49 | code-simplifier | active | `.claude/agents/active/code-simplifier.md` |

**검증 보조 1 (L55) → active**:
| L | role | 분류 | 정정 path |
|---|---|---|---|
| L55 | layer-checker | active | `.claude/agents/active/layer-checker.md` |

총 21 path 영역 정정 (코어 6 + 도메인 8 + 문서 2 + 구현 4 + 검증 1).

### L83-100 "역할 파일 필수 섹션" template 안 path 영역 (점검 의무)

L86 `name: <role-name>` · L87 `description:` · L88 `tools: [Read, Glob, Grep]` 영역 = template 자체 영역 (실제 agent path 아님) → 본 cycle scope 외 (= ε scope = L15-55 path 영역만 명시). L78 `.claude/agents/<role-name>.md` 영역 = template 자체 영역 (instruction wording) → 본 cycle scope 외.

## Key Findings

### 사전 baseline 실측 결과

| 항목 | 실측값 | baseline expectation |
|---|---|---|
| 4-repo HEAD | `d2eb521/0256fa8/d9e6e5e/2ce2e09` | prompt BASELINE 정합 100% ✓ |
| 4-repo code-simplifier.md sha | `1b98596e1fb0f6e5…` (4-repo 동일) | byte-identical ✓ |
| 4-repo layer-checker.md sha | `34f42c7f2eb7f396…` (4-repo 동일) | byte-identical ✓ |
| 4-repo domain-roles.md sha | `86e8b6a75b484e53…` (4-repo 동일) | byte-identical ✓ |
| 보호 5종 sha | `f1edd397/ee377dc2/e5e3fe16/7621013e/96de2f5d` | baseline MATCH ✓ |
| active/ 16 files | ls 실측 정합 | β + γ + ε 분류 baseline ✓ |
| deferred/ 9 files | ls 실측 정합 | ε 분류 baseline ✓ |

### Cleanup Assessment

ops-layer task (cli infra agent frontmatter + 본문 + path drift) · 제품 코드 무접촉.

본 cycle scope = frontmatter `tools:` 추가 + layer-checker 본문 교차권한 단락 추가 + domain-roles path 영역 정정 만. legacy-cleanup-governance.md §code-level cleanup 영역 외 (cli infra cleanup 영역).

코드 측 cleanup assessment: N/A (ops-layer task — 제품 코드 미변경)
