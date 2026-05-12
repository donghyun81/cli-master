## Requirements Source

- 사용자 cycle prompt `GENTLY-AGENT-BILLING-GUARDIAN-CLEANUP-001` 직 인용 (본 chat 진입 메시지)
- 핵심 변경 2 영역:
  - A. master `.claude/agents/active/billing-payments-guardian.md` stub → 표준 6 섹션 본문 (auth-security-privacy.md + intake-router.md 구조 차용) + frontmatter `name` 추가
  - B. 자식 3-repo `.claude/agents/deferred/billing-payments-guardian.md` 잔존본 rm
- Authority boundary: agent 본문 + frontmatter 만. SoT (billing-rules.md / routing-and-delegation.md / deferred-domains.md) 무접촉. 보호 5종 무접촉. 실 결제 도메인 코드 무접촉.

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | cli infra ops-layer (agent 본문 표준화 + cleanup pass) |
| Reading Mode | cli 운영 레이어형 |
| Requirement Source | 사용자 cycle prompt (직 인용 + STOP 8 조건 명시됨) |
| Info Gap | RESOLVABLE_IN_REPO (모든 reference + SoT 본 chat 진입 시 system-reminder 로 load) |
| STOP Risk | MoneyAuth=Yes (billing 도메인 보호 영역) · 코드 무접촉 · 본문만 변경 |
| Read-Only Fan-Out | N/A (단일 agent 본문 표준화 + cleanup) |
| Implementer Entry | Allowed (pre-EVIDENCE 계약 본 file 로 고정) |

## Pre-EVIDENCE Contract

- Read evidence: `billing-rules.md` (10 섹션 SoT · §1~§10) · `routing-and-delegation.md:55` active 매핑 · `deferred-domains.md` §2 매트릭스 (Billing ACTIVE×4) · `auth-security-privacy.md` L7-110 표준 구조 · `intake-router.md` L7-109 표준 구조
- Remaining gaps: 없음 (전체 reference + SoT 가 system-reminder 로 진입 직후 load)
- Chosen path: STEP 0~6 cycle 9-단계 표준 흐름 (workflow-core.md 정합) · master 본문 작성 → propagate.sh → 자식 cleanup → verify-sync
- Hold / Stop reasons: STOP 8 조건 (보호 5종 sha 변동 / billing-rules.md SoT 변경 / routing+deferred 본문 변경 / master 미작성 자식 직 수정 / propagate sha mismatch / MoneyAuth 실 결제 코드 영향 / cycle scope 부풀음 / 무관 WT dirty stage 흡수)
- Implement entry conditions: 4-repo baseline sha `fa6ea5a8…` MATCH PASS · 보호 5종 sha baseline MATCH PASS · scripts/propagate.sh + scripts/verify-sync.sh 존재 PASS

## Collect Results

### 매칭 파일/패턴

- `claude-cli-master/.claude/agents/active/billing-payments-guardian.md` (6 줄 stub · sha `fa6ea5a8…`) — 변경 대상 (master)
- `GentlyBreath/.claude/agents/active/billing-payments-guardian.md` (sha `fa6ea5a8…`) — propagation 대상
- `GentlyDay/.claude/agents/active/billing-payments-guardian.md` (sha `fa6ea5a8…`) — propagation 대상
- `GentlyTable/.claude/agents/active/billing-payments-guardian.md` (sha `fa6ea5a8…`) — propagation 대상
- `GentlyBreath/.claude/agents/deferred/billing-payments-guardian.md` (sha `fa6ea5a8…`) — rm 대상
- `GentlyDay/.claude/agents/deferred/billing-payments-guardian.md` (sha `fa6ea5a8…`) — rm 대상
- `GentlyTable/.claude/agents/deferred/billing-payments-guardian.md` (sha `fa6ea5a8…`) — rm 대상

### Reference 본문 구조 (read-only · 본문 작성 reference)

- `claude-cli-master/.claude/agents/active/auth-security-privacy.md` L7-110 = 표준 6+ 섹션 (Mission / Use when / Think like / Key questions / Decision authority / Must escalate when / Evidence 수집 방식 / Expected outputs) · 110 줄
- `claude-cli-master/.claude/agents/active/intake-router.md` L7-109 = 동일 구조 + Evidence to gather 분리 · 110 줄
- 본 cycle 본문 길이 권장 80~150 줄 (위 reference 정합)

### SoT cross-ref (본문 안 인용 의무)

- `billing-rules.md` SoT 10 섹션 (§1 Mock-first · §2 Edge Function 단일 진입점 · §3 시크릿 저장 · §4 BillingRepository 패턴 · §5 entitlement / 소비형 paradigm · §6 RevenueCat Phase 2 · §7 STOP trigger · §8 절대 금지 · §9 변경 정책 · §10 cycle 이력) — agent 본문 안 `Evidence to gather` 섹션에서 `.claude/rules/billing-rules.md` 1 줄 cross-ref 의무
- `routing-and-delegation.md:55` active 매핑 (`결제 플로우, entitlement 보호` → `billing-payments-guardian` → `.claude/agents/active/billing-payments-guardian.md`) — agent 본문 안 active 매핑 cross-ref 1 줄 의무

### 교차 권한 금지 (routing-and-delegation.md §Planner/Generator/Evaluator 경계 §3)

- Evaluator 는 고치지 않는다 — 본 agent = read-only Evaluator (deferred 시점 STOP trigger 발화) + ACTIVE 시점 SoT 인용 read-only 분석 역할. 본문 frontmatter `tools` = `Read, Glob, Grep` 의무.

### 0 Matches (부재 증거)

- master `.claude/agents/deferred/billing-payments-guardian.md` — 부재 (이미 MASTER-BILLING-DOMAIN-ACTIVATE-001 cycle 에서 mv 마감 · sha grep 결과 No such file)
- 본 cycle ID `.ai/reports/GENTLY-AGENT-BILLING-GUARDIAN-CLEANUP-001/` — 부재 (신규 cycle · mkdir 후 진입)

## Key Findings

### 사전 baseline 실측 결과

| 항목 | 실측값 | baseline expectation |
|---|---|---|
| 4-repo active billing-payments-guardian.md sha | `fa6ea5a803cf9407493055a242f18da8d42dc7c0e42fab4bedbfd62b1558b86e` (4-repo 동일) | `fa6ea5a8…` MATCH ✓ |
| 자식 3-repo deferred billing-payments-guardian.md sha | `fa6ea5a8…` (3-repo 동일) | MATCH ✓ |
| 보호 5종 sha (ui-spec.schema.json) | `f1edd39739d4c0192872002487c02bca6929f8bd6c14f85392552182ce2aa445` | `f1edd397…` MATCH ✓ |
| 보호 5종 sha (uiux-sot-refresh.md) | `ee377dc2ac32357f61fa1b2bfc39690ab530b65102e31062bff91ab6b8b260d3` | `ee377dc2…` MATCH ✓ |
| 보호 5종 sha (design-sot-policy.md) | `e5e3fe165ec3a826b2843f0e9791d4e6f07fb4c226bcc53639868787da49af03` | `e5e3fe16…` MATCH ✓ |
| 보호 5종 sha (pencil-uiux-workflow.md) | `7621013e7f2dc644f0d0028b0574e12949dc7462953b4d5465c8a1186d6f0c0f` | `7621013e…` MATCH ✓ |
| 보호 5종 sha (pencil-sot-policy.md) | `96de2f5d10a73af4aaa2608770f503dd3956304846c6db8a9b2cf2d05cba6559` | `96de2f5d…` MATCH ✓ |
| scripts/propagate.sh | exists (11354 byte) | OK ✓ |
| scripts/verify-sync.sh | exists (8656 byte) | OK ✓ |

### 4-repo HEAD 실측

- claude-cli-master HEAD: `412b621 chore: audit MASTER-CLEANUP-PROPAGATION-BUNDLE-001 (TRAIL-1+2+11 close)`
- GentlyBreath HEAD: `a98a29c chore: propagate release-checklist.template.md (TRAIL-2 close)`
- GentlyDay HEAD: `999e7a7 chore: propagate release-checklist.template.md (TRAIL-2 close)`
- GentlyTable HEAD: `c835367 chore: propagate release-checklist.template.md (TRAIL-2 close)`

### WT dirty 영역 (본 cycle 무관 · STOP 8 영역 · 명시 stage 의무)

- claude-cli-master M: `.ai/baseline-snapshot/latest.json` + `.auto-memory/propagation-status.md` + 2 untracked baseline-snapshot json (본 cycle 무관 — stage 흡수 X)
- GentlyBreath M: `docs/release-readiness/LAUNCH-STATUS.md` + 다수 untracked (.idea/ + cc-paste-* + .ai/baseline-snapshot 등 · 본 cycle 무관)
- GentlyDay 0 M + 다수 untracked (.idea/ + cc-paste-* + .ai/baseline-snapshot 등 · 본 cycle 무관)
- GentlyTable M: `docs/release-readiness/LAUNCH-STATUS.md` + 다수 untracked (.idea/ + cc-paste-* + docs/design/pencil-sot/daily-prescription/untitled.pen 등 · 본 cycle 무관)

→ commit 시 `git add <명시 path>` 만 사용 (`git add -A` / `git add .` 금지).

## Cleanup Assessment

ops-layer task (cli infra agent 본문 + cleanup pass) · 제품 코드 미변경.

자식 3-repo `.claude/agents/deferred/billing-payments-guardian.md` 잔존본 = cli infra 측 cleanup (code-level cleanup 아님 · legacy-cleanup-governance.md §code removal vs file deletion STOP 영역 외 · 별 propagation 흐름 안 명시된 cleanup pass).

- 즉시 제거: 3건 (자식 3-repo deferred 잔존본)
- deferred: 0건
- task-level STOP: 0건

코드 측 cleanup assessment: N/A (ops-layer task — 제품 코드 미변경)
