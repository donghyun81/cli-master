# Decision Log — claude-cli-master

> master cycle 별 의사결정 누적. 각 entry = 1 cycle 1 결정 묶음.

## 2026-05-02 · C1-MASTER-BOOTSTRAP-001 (마감)

### 결정 1. 정합 구조
- **선택**: 옵션 A (새 master repo `claude-cli-master/`)
- **대안**: B (GD master 지정) · C (`.claude-shared/`) · D (별 git + submodule)
- **근거**: SoT 명확 + 도메인 작업과 정합 책임 분리 + 추후 자식 repo 확장 단순

### 결정 2. propagation 방향
- **선택**: 단방향 master → GB/GD/GT
- **근거**: source-of-truth 명확 + 자식 repo cli infra 직접 수정 차단

### 결정 3. master git 처리
- **선택**: git init (자식 repo 와 동일 패턴)
- **근거**: 정합 commit 추적 + master HEAD baseline 보호

### 결정 4. MD 파일 분할 깊이
- **선택**: workflow.md 3 분할 + evidence.md 2 분할 + agents/active vs deferred 폴더 분리
- **실행 시점**: C2 (별도 cycle)
- **근거**: 진입 1차 가이드 더 짧게 + 단일 목적 파일

### 결정 5. 자동화 범위
- **선택**: 전체 자동화 (script 4종 + slash 1종)
- **실행 시점**: C3 (별도 cycle)
- **목록**: `propagate.sh` · `verify-sync.sh` · `report-gen.sh` · `activate-agent.sh` + `/cycle-report` slash
- **근거**: Coin = scope + 검증 / agent = 실행 + cross-verify + 보고 자동

### 결정 6. 진행 방식
- **선택**: 4 sub-cycle 분할 (C1 → C2 → C3 → C4)
- **근거**: 매 cycle 검증 후 다음 진입 + 사고 대응 비용 ↓

### 결정 7. 5 divergent 파일 best-version 채택
- `domain-roles.md` → GB + placeholder 화 (`<REPO>-only`)
- `pencil-auto-save.sh` → **GD v2** (자동화 우선)
- `save-as-result-check.sh` → **GD-only 흡수** (master 가 통일)
- `deferred-domains.md` → **GT (UNKNOWN baseline)** (자식 fresh state 정합)
- `routing-and-delegation.md` → **GB+GD ([DEFERRED] 명시)** (정합 의도)
- `ui-ux-analysis.md` → **GT ("필수" 강화)** (Pencil → Compose 본 작업 정합)

### C1 산출물 요약

- `claude-cli-master/` 신설
- `.claude/` 59 파일 (active 14 + deferred 11 + commands 7 + hooks 7 + rules 14 + skills 5 + settings.json 1)
- `docs/schemas/ui-spec.schema.json` + `docs/design/pencil-sot-policy.md` 보호 파일 cp
- `CLAUDE.md` (master SoT 헌법)
- `.auto-memory/` 4 파일 (protected-file-hashes / propagation-status / incident-log / decision-log)
- `propagation-reports/` + `scripts/` seed (C3 에서 채울 예정)
- git init + initial commit (C1-5 단계)

### 다음 cycle 진입 조건

- C2 진입 = master 의 cli infra 가 안정 baseline (현 상태) 일 때 진행
- C2 마감 = rules 분할 완료 + 새 구조 자식 repo propagation 준비
- C3 마감 = 자동화 script 4종 + slash 1종 검증 PASS
- C4 마감 = master → 3 자식 repo cross-verify ALL ✓ MATCH

---

## 2026-05-02 · C2-RULES-RESTRUCTURE-001 (마감)

### 결정 1. DEFERRED pointer rule 4 종 처리
- **선택**: 옵션 A — 삭제 + `deferred-domains.md` 에 통합
- **대안**: B (유지 + DEFERRED 명시 강화) · C (단일 `deferred-rules.md` 로 통합 · `deferred-domains.md` 와 분리)
- **근거**: 4 파일 (각 3 줄) = pointer-only · 단일 목적 분리 안 됨. 통합이 진입 비용 ↓.

### 결정 2. workflow.md 분할 경계
- **선택**: 옵션 1 — core / cycle-discipline / pencil-automation 3 분할
- **대안**: 2 (core / cycle-discipline 만) · 3 (분할 없이 ToC 강화)
- **근거**: Pencil 자동화 = 단일 목적 + 분리 시 진입 비용 ↓. 5 분할 (workflow 3 + evidence 2) 이 진입 1차 가이드 단순화에 가장 효과적.

### C2 산출물 요약

- 신설 5 rules (workflow-core / cycle-discipline / pencil-automation / report-paths / report-formats)
- deprecated 6 rules (workflow / evidence-and-reporting + 4 DEFERRED pointer · sandbox rm 권한 한계로 pointer-only 변환)
- 갱신 5 rules (routing-and-delegation / legacy-cleanup-governance / ui-ux-analysis / verification-and-review / deferred-domains)
- CLAUDE.md 갱신 (rule path + §15 C2 entry)
- .auto-memory/protected-file-hashes.md 갱신 (보호 파일 4종 sha 무변동)

### Coin 손 작업 (C2 sandbox 권한 한계)

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
rm .claude/rules/workflow.md \
   .claude/rules/evidence-and-reporting.md \
   .claude/rules/auth-security-privacy.md \
   .claude/rules/backend-and-api.md \
   .claude/rules/data-and-migrations.md \
   .claude/rules/performance-reliability.md && \
git add -A && \
git commit -m "$(cat <<'COMMIT'
chore(master): C2-RULES-RESTRUCTURE-001 rules 5 분할 + 6 deprecated rm

[Goal] cli infra rules 단일 목적 분리 (workflow→3 / evidence→2) + DEFERRED pointer 4 통합 (deferred-domains.md)
[Diff] +5 신설 (.claude/rules/{workflow-core,cycle-discipline,pencil-automation,report-paths,report-formats}.md) -6 deprecated (workflow.md + evidence-and-reporting.md + 4 DEFERRED pointer) ~5 갱신 (routing/legacy/ui-ux/verification/deferred-domains)
[Sha]  보호 파일 4종 sha 변동 **0**
[EC]   rule path cross-reference 정정 PASS · 잔존 인용 0 (보호 파일 자기 인용 + deprecated pointer 자체 제외)
[Next] C3-AUTOMATION-SCRIPTS-001 진입 (4 script + 1 slash 신설)
[Refs] task: C2-RULES-RESTRUCTURE-001 · parent: <C1 commit hash>
COMMIT
)"
```

### 다음 cycle 진입 조건

- C3 진입 = C2 commit 완료 + master rules 새 구조 baseline 박힘
- C4 진입 = C3 마감 + script 4종 검증 PASS

---

## 2026-05-02 · C3-AUTOMATION-SCRIPTS-001 (마감)

### C3 산출물 요약

- 신설 4 script (propagate.sh / verify-sync.sh / report-gen.sh / activate-agent.sh · 모두 executable + bash -n PASS)
- 신설 1 slash command (.claude/commands/cycle-report.md)
- 신설 1 template (.auto-memory/cycle-handoff-template.md · Q4 누락 보완)
- 갱신 1 hook (.claude/hooks/session-start.sh · Claude Code 버전 자동 검증 + Q5 §b)
- 갱신 1 rule (.claude/rules/cycle-discipline.md · §15 §16 cli 수정 패턴 3 종 박음 · Q2 가이드)
- 신설 본 보고서 (.ai/reports/C3-AUTOMATION-SCRIPTS-001/REPORT.md)

### 검증 (실측 PASS)

- bash -n script 4종 PASS
- activate-agent.sh list dry-run = ACTIVE 14 / DEFERRED 11 정확히 출력
- verify-sync.sh --quick dry-run = drift 6 + miss 15 정확히 식별 (C4 propagation 후 PASS 30 / drift 0 / miss 0 예정)

### Coin 손 작업 1줄

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "feat(master): C3-AUTOMATION-SCRIPTS-001 자동화 script 4종 + slash + Q2/Q4/Q5 보완"
```

### 다음 cycle 진입 조건

- C4 진입 = C3 commit 완료 + 자식 repo HEAD clean 또는 대기 cycle 마감
- C4 마감 = master → 3 자식 repo cross-verify ALL ✓ MATCH (verify-sync.sh exit 0)

---

## 2026-05-02 · C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 (마감)

### 결정 1. SOLID + DRY/KISS/YAGNI 박을 위치
- **선택**: 신규 `code-principles.md` 룰 신설
- **근거**: 단일 목적 파일 + reviewer 자동 참조 명확

### 결정 2. "gently 전용" 4 항목 분리 처리
- **선택**: C2.5 안에서 4 항목 모두 분리
- **분리 결과**:
  - `pencil-uiux-workflow.md` (보호) → 70% 공통 → `design-to-code-sync.md` (cli infra 신설) + 30% Pencil 잔존
  - `uiux-sot-refresh.md` (보호) → 95% generic 화 (Pencil 인용 → `<design-tool>` placeholder)
  - `pencil-sot-policy.md` (보호) → 75% 공통 → `design-sot-policy.md` (보호 신설) + 25% Pencil 바인딩 잔존
  - `ui-spec.schema.json` (보호) → designTool enum + lastSyncedDesignToolStateHash generic 필드 신설 (구 Pencil 명명 = alias)

### C2.5 산출물 요약

- 신설 2 cli infra rules (code-principles.md / design-to-code-sync.md)
- 신설 1 보호 파일 (docs/design/design-sot-policy.md)
- 갱신 4 보호 파일 sha (pencil-uiux-workflow / uiux-sot-refresh / pencil-sot-policy / ui-spec.schema.json)
- protected-file-hashes.md 새 baseline 5 보호 파일
- decision-log + REPORT.md (C2.5)

### 보호 파일 4 종 sha (C2.5 마감 baseline)

```
5aa52b23124681bf  ui-spec.schema.json (v0.3)
1f87144705380a26  uiux-sot-refresh.md (95% generic)
6297080aa4342977  pencil-uiux-workflow.md (30% Pencil 바인딩)
96de2f5d10a73af4  pencil-sot-policy.md (의미 = pencil-sot-binding · 25% Pencil)
+ design-sot-policy.md (신설 · 첫 commit 후 sha 박음)
```

### Coin 손 작업 (C2.5 sandbox 권한 한계)

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
# Pencil-specific 파일명 변경 의무 (의미와 일치)
git mv docs/design/pencil-sot-policy.md docs/design/pencil-sot-binding.md && \
git add -A && \
git commit -m "$(cat <<'COMMIT'
feat(master): C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 도구 무관 분리 + SOLID

[Goal] cli infra 의 도구 무관 vs Pencil 전용 분리 + SOLID/DRY/KISS/YAGNI 코드 리뷰 체크리스트 박음
[Diff] +2 cli infra rules (code-principles.md + design-to-code-sync.md) +1 보호 (design-sot-policy.md) ~4 보호 sha 갱신 (ui-spec.schema.json v0.3 / uiux-sot-refresh 95% generic / pencil-uiux-workflow 30% 도구 / pencil-sot-policy → pencil-sot-binding 25% 도구) ~ protected-file-hashes baseline
[Sha]  보호 파일 4종 sha 모두 변경:
       5aa52b23 ui-spec.schema.json (v0.3 designTool enum)
       1f871447 uiux-sot-refresh.md (95% generic)
       6297080a pencil-uiux-workflow.md (30% Pencil)
       96de2f5d pencil-sot-binding.md (rename + 25% Pencil)
[EC]   JSON valid · 5 보호 파일 sha 박음 · 도구 무관 vs 도구 전용 매트릭스 박음
[Next] C3 (이미 마감) → C4 propagation 시 자식 repo 의 ui-spec.json 마이그레이션 의무 (lastSyncedPencilStateHash → lastSyncedDesignToolStateHash)
[Refs] task: C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 · parent: <C3 commit hash>
COMMIT
)"
```

### 다음 cycle 진입 조건

- C4 진입 = C2.5 commit 완료 + 5 보호 파일 sha baseline 박음
- C4 추가 의무 = 자식 repo 의 ui-spec.json 마이그레이션 (lastSyncedPencilStateHash → lastSyncedDesignToolStateHash · alias 호환)

---

## 2026-05-02 · C5-EXTRA-COMMON-ABSORB-AND-RENAME-001 (마감)

### 결정 1. Part A 흡수 범위
- **선택**: 옵션 1 — 24 추가 공통 파일 모두 흡수
- **흡수 결과**:
  - docs/agent/architecture/ 13 파일 (모두 3-repo 동일 sha)
  - docs/agent/process/ 4 파일 (모두 3-repo 동일 sha)
  - docs/agent/solutions/PROMPTFIT_RUBRIC.md (3-repo 동일)
  - scripts/agent/frontmatter-grep.sh (3-repo 동일)
  - root: .editorconfig + .mcp.json + gradle.properties + gradlew + gradlew.bat (5 파일 모두 3-repo 동일)

### 결정 2. master repo 이름
- **선택**: 옵션 A — `claude-cli-master/`
- **대안**: B (android-compose-cli-base) · C (multi-repo-cli-sot) · D (gently-master 유지)
- **근거**: Claude Code CLI 운영 SoT 명시 + 도메인/도구 무관 + 확장 가능

### C5 산출물 요약

- 흡수 24 파일 (architecture 13 + process 4 + solutions 1 + scripts 1 + root 5 · 모두 sha 일치 검증 PASS)
- master 안 모든 "gently-master" 인용 → "claude-cli-master" 갱신 (21 파일 · 잔존 0)
- scripts/verify-sync.sh + propagate.sh 의 find 명령 확장 (scripts/agent + root 5 포함)
- scripts/verify-sync.sh CORE_CLI 배열 확장 (architecture 4 + process 1 + scripts 1 + root 3 추가)

### 검증 (실측 PASS)

- verify-sync.sh --quick = 23 파일 검증 박힘 (확장 전 12 → 확장 후 23)
- 24 흡수 파일 = 자식 repo 와 모두 sha 일치 (PASS 10 / 자식 동일 13 / MISS = master 신설 cli infra 가 자식 미반영 정상)
- bash -n script 4종 PASS

### 보호 파일 5 종 sha (C2.5 baseline 그대로 · 변동 0)

```
5aa52b231246  ui-spec.schema.json (v0.3)
1f87144705380  uiux-sot-refresh.md (95% generic)
e5e3fe165ec3  design-sot-policy.md
6297080aa434  pencil-uiux-workflow.md (Pencil 30%)
96de2f5d10a7  pencil-sot-policy.md (Pencil 25% · 의미 = pencil-sot-binding)
```

### Coin 손 작업 (C5 sandbox 권한 한계 · rename + commit)

```bash
# 1. master repo rename (디렉터리 mv · 사전 인용 모두 갱신됨)
cd ~/AndroidStudioProjects && \
mv gently-master claude-cli-master

# 2. C2.5 의 Pencil-specific 파일명 변경 (이전 cycle 의 lazy 항목 묶음 처리)
cd claude-cli-master && \
git mv docs/design/pencil-sot-policy.md docs/design/pencil-sot-binding.md

# 3. C2 의 deprecated 6 rules rm (이전 cycle 의 lazy 항목 묶음 처리)
rm .claude/rules/workflow.md \
   .claude/rules/evidence-and-reporting.md \
   .claude/rules/auth-security-privacy.md \
   .claude/rules/backend-and-api.md \
   .claude/rules/data-and-migrations.md \
   .claude/rules/performance-reliability.md

# 4. 묶음 commit
git add -A && \
git commit -m "$(cat <<'COMMIT'
feat(master): C5-EXTRA-COMMON-ABSORB-AND-RENAME-001 24 추가 공통 흡수 + rename

[Goal] master 의 통합 완전성 ↑ + gently-master → claude-cli-master rename
[Diff] +24 흡수 (architecture 13 + process 4 + solutions/PROMPTFIT_RUBRIC + scripts/frontmatter-grep + root 5) ~21 파일 인용 갱신 (gently → claude-cli) ~2 scripts (verify-sync + propagate find/CORE_CLI 확장) + rename gently-master → claude-cli-master + C2 deprecated 6 rm + C2.5 mv
[Sha]  보호 파일 5종 sha 변동 0 (C2.5 baseline 보존)
[EC]   verify-sync --quick = 23 파일 검증 박힘 · 잔존 gently-master 인용 0 · 24 흡수 파일 자식 sha 일치 PASS
[Next] C4-PROPAGATE-TO-CHILDREN-001 (master → 3 자식 repo 단방향 propagation + cross-verify ALL ✓ MATCH)
[Refs] task: C5-EXTRA-COMMON-ABSORB-AND-RENAME-001 · parent: <C2.5 commit hash>
COMMIT
)"
```

### 다음 cycle 진입 조건

- C4 진입 = C5 commit + rename 완료
- C4 마감 = master → 3 자식 repo cross-verify ALL ✓ MATCH (24 흡수 파일 = 자식과 동일 sha 라 propagation 의미 = 자식의 master 의존 박음 + 새 cli infra 만 cp)

---

## 2026-05-02 · C6-COMMON-DOCS-AND-TEMPLATES-001 (마감)

### 결정 1. C6 scope
- **선택**: 옵션 1 (전체 · 6 흡수 + 가이드 1 + 템플릿 7 + Nested CLAUDE.md 패턴)
- **근거**: 신규 자식 repo 신설 시 즉시 사용 가능 + 기존 자식 도메인 문서 형식 통일 + 공식 권장 patterns 적용

### 결정 2. Nested CLAUDE.md 적용 범위
- **선택**: 옵션 1 (자식 CLAUDE.md 상단 5~10 줄 master 인용 추가)
- **근거**: Anthropic Claude Code 공식 권장 (Nested CLAUDE.md auto load) + Coin 진입 비용 ↓ + 기존 자식 본문 보존

### C6 산출물 요약

- 흡수 6 파일 (Part A · 3-repo 동일 sha)
- 신설 9 파일 (가이드 1 + 템플릿 7 + Nested header template 1)
- scripts/verify-sync + propagate find 확장 (.ai/promptfit + .ai/uiux-sot/refresh + .github 추가)
- protected-file-hashes + decision-log + REPORT.md
- CLAUDE.md §15 C6 entry

### Coin 손 작업 1줄

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "feat(master): C6-COMMON-DOCS-AND-TEMPLATES-001 통합 가이드 + 템플릿 + Nested 패턴"
```

### 다음 cycle 진입 조건

- C4 진입 = C6 commit + master 의 통합 완전성 100%
- C4 추가 의무: 자식 repo CLAUDE.md 의 첫 5~10 줄 Nested 패턴 박음 (template cp + 기존 본문 보존)

---

## 2026-05-02 · C7-UX-LAWS-INTEGRATION-001 (마감)

### 결정 1. UX Laws 30 법칙 채택 / 비권장 분류
- **선택**: 권장 17 + 신중 12 + 비권장 1 (Cognitive Bias)
- **근거**: dark patterns 위험 분리 (의도적 지연 / 인위적 진척 / 부정 위장 / 카운트다운 / Cognitive Bias 활용)

### 결정 2. 자동 선별 흐름
- **선택**: §5 task 유형별 매트릭스 → ux-auditor + reviewer agent 자동 적용
- **근거**: 매 task 마다 30 법칙 모두 검토 비효율 → task 유형 식별 후 해당 row 만 자동 적용

### C7 산출물 요약

- 신설 1 cli infra rule: `.claude/rules/ux-laws.md` (306 줄 · 채택 매트릭스 + dark patterns 회피 + task 유형별 적용)
- 갱신 2 agents: `ux-auditor.md` + `reviewer.md` description 강화 (ux-laws 자동 reading 의무)
- 갱신 1 rule: `code-principles.md` §4 H (UX Laws 체크리스트)
- 갱신 1 가이드: `app-implementation-guide.md` §4.5 신설
- 갱신 1 script: `verify-sync.sh` CORE_CLI 에 ux-laws.md 추가

### 비권장 5 항목 (사용자 답변 박힘)

| # | 비권장 | 사유 |
|---|---|---|
| 1 | Cognitive Bias 활용 | 사전적 + 구체 행동 X + dark pattern 위험 |
| 2 | Doherty 의도적 지연 | 사용자 기만 (실 빠른데 늦게 보이게) |
| 3 | Goal-Gradient 인위적 진척 | 시작점 박음 동기 조작 |
| 4 | Peak-End 부정 위장 | 취소 인식 조작 / 권리 침해 |
| 5 | Parkinson 카운트다운 | 긴급성 조작 |

### 추가 dark patterns 회피 5 종 (FTC/EU DMA 정합)

Roach Motel / Confirmshaming / Disguised Ads / Forced Continuity / Hidden Costs

### Coin 손 작업 1줄

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "feat(master): C7-UX-LAWS-INTEGRATION-001 Laws of UX 17 권장 + 12 신중 + 1 비권장 + Dark Patterns 5 회피"
```

### 다음 cycle 진입 조건

- C4 propagation = master cli infra 변경 (ux-laws + 4 갱신) 자식 repo 적용 의무
- ux-laws.md 변경 시 master cycle 신설 (자식 직접 수정 금지)

---

## 2026-05-02 · C8-GIT-LOCK-AUTOMITIGATION-001 (마감)

### 결정 1. stale .git/index.lock 자동 정리 위치
- **선택**: pre-tool-use.sh (git command 감지) + session-start.sh (세션 시작) 묶음
- **대안**: A. wrapper script (Coin 명시 호출) · B. session-start만 · C. pre-tool-use만
- **근거**:
  - A 거부: Coin 명시 호출 = 자동화 약함 (사용자 요청 = 매번 처리 안 함)
  - B 단독 거부: 세션 시작 후 새로 발생 lock 처리 X
  - C 단독 거부: 세션 시작 시 즉시 정리 안 됨
  - **묶음 채택**: 두 hook 모두 박아 99% case 자동 mitigation

### 결정 2. stale 마진 (race condition 회피)
- **pre-tool-use.sh**: 30초 (반응성 우선 · 정상 git op 는 30s 안에 거의 끝남)
- **session-start.sh**: 5분 (300s · 안전 마진 · long-running git op 보호)
- **근거**: race condition (정상 진행 중 git op 와 lock rm 충돌) 회피 + 너무 길면 사용자 답답함

### C8 산출물 요약

- 갱신 1 hook: `.claude/hooks/pre-tool-use.sh` (git command 감지 + stale > 30s 자동 rm)
- 갱신 1 hook: `.claude/hooks/session-start.sh` (exit 0 위치 정정 + stale > 5분 자동 rm)
- incident-log + decision-log + CLAUDE.md §15 + REPORT.md

### 추가 정정 (C3 dead code 사고)

C3 에서 박힌 `session-start.sh` 의 Claude Code 버전 검증 코드가 `exit 0` 뒤에 있어서 **dead code 였음** (실 작동 안 함). C8 에서 동시 정정.

### Coin 손 작업 1줄

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "fix(master): C8-GIT-LOCK-AUTOMITIGATION-001 stale .git/index.lock 자동 정리 + C3 dead code 정정"
```

### 다음 cycle 진입 조건

- C4 propagation 시 자식 repo 의무 적용 (자식 repo 의 git lock 사고도 즉시 자동 mitigation)

---

## 2026-05-02 · C9-GIT-LOCK-PID-VERIFY-001 (마감)

### 결정 1. mitigation 강화 방식
- **선택**: PID 기반 검증 + standalone wrapper + mtime 마진 단축 (3 layer 묶음)
- **대안**: A. mtime 마진 더 단축만 / B. cron 데몬 / C. wrapper 만
- **근거**:
  - A 단독 거부: race condition 위험 ↑ (정상 git op 와 충돌)
  - B 거부: 무거움 + crontab 설치 의무 + 환경 의존
  - C 단독 거부: Coin 이 wrapper 호출 의무 = 자동화 약함
  - **3 layer 묶음**: PID 검증 = 정상 op 100% 보호 + Coin 환경 = alias 1 줄로 자동 + hook = Claude Code 환경 자동

### 결정 2. PID 검증 patterns
- lock 안 첫 20 char read → 숫자만이면 PID
- `ps -p $PID` 살아있음 = 보호 / 죽음 = 즉시 rm
- PID 박힘 X 또는 형식 X = 빈 파일 또는 손상 → mtime 보조

### C9 산출물 요약

- 신설 1 script: `scripts/git-safe.sh` (standalone wrapper · Coin alias 권장)
- 갱신 1 hook: `.claude/hooks/pre-tool-use.sh` (PID 검증 + mtime 5s)
- 갱신 1 hook: `.claude/hooks/session-start.sh` (PID 검증 + mtime 30s)
- 갱신 1 doc: `scripts/README.md` §5 git-safe.sh 명세 + alias 권장
- incident-log + decision-log + CLAUDE.md §15 + REPORT.md

### Coin 손 작업 (C9 commit + alias 박음)

```bash
# 1. ~/.zshrc 에 alias 박음 (Coin 환경 자동 mitigation)
echo "alias git='bash ~/AndroidStudioProjects/claude-cli-master/scripts/git-safe.sh'" >> ~/.zshrc
source ~/.zshrc

# 2. 검증 (현 lock 정리)
git status   # 자동 정리 작동 확인

# 3. master commit
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "fix(master): C9-GIT-LOCK-PID-VERIFY-001 PID 기반 검증 + git-safe.sh wrapper + 마진 단축"
```

### 다음 cycle 진입 조건

- C4 propagation 시 자식 자동 적용
- alias 박은 후 Coin 환경 git lock 사고 0 (검증 의무)

---

## 2026-05-02 · C10-LAUNCHD-DAEMON-001 (마감)

### 결정 1. 환경 무관 mitigation 방식
- **선택**: macOS launchd 백그라운드 데몬 (5초마다 PID 검증 + stale rm)
- **대안**: A. cron · B. fswatch + osascript · C. 사용자 환경 마다 alias 박음 (각 IDE / 터미널 / Cowork)
- **근거**:
  - A 거부: cron 은 분 단위 최소 (5초 X)
  - B 거부: fswatch 의존 + 무거움
  - C 거부: 환경 마다 alias 박음 의무 = Coin 손 작업 N 회 + Cowork 같은 환경은 alias 박음 X
  - **launchd 채택**: macOS 표준 + StartInterval 5s + low priority (Nice 10) + 모든 환경 cover

### 결정 2. install patterns
- **선택**: `scripts/install-git-lock-daemon.sh` 1회 호출 = `~/Library/LaunchAgents/com.coin.git-lock-cleaner.plist` 신설 + launchctl load + 활성 검증
- **근거**: Coin 손 작업 1회로 영구 박힘

### C10 산출물 요약

- 신설 1 script: `scripts/git-lock-daemon.sh` (5초마다 launchd 가 호출)
- 신설 1 plist: `scripts/com.coin.git-lock-cleaner.plist` (launchd 등록 template)
- 신설 1 install script: `scripts/install-git-lock-daemon.sh` (Coin 1회 호출)
- 갱신 1 doc: `scripts/README.md` §6 박음 + 이전 mitigation 와 관계 매트릭스
- incident-log + decision-log + CLAUDE.md §15 + REPORT.md

### Coin 손 작업 (C10 install + 현 lock 정리 + commit)

```bash
# Step 1: 현 stale lock 정리 (sandbox 권한 한계로 즉시 손 작업 의무)
rm -f ~/AndroidStudioProjects/gently-master/.git/index.lock

# Step 2: launchd 데몬 install (1회 · 영구 mitigation)
bash ~/AndroidStudioProjects/claude-cli-master/scripts/install-git-lock-daemon.sh
# 검증: launchctl list | grep git-lock-cleaner → com.coin.git-lock-cleaner 출력

# Step 3: master commit
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "fix(master): C10-LAUNCHD-DAEMON-001 launchd 데몬 박음 (환경 무관 영구 mitigation)"
```

### 다음 cycle 진입 조건

- C4 propagation 시 자식 자동 적용 (단 daemon 은 master 의 path 박힘)
- daemon install 후 = git lock 사고 99.99% 자동 mitigation (5초 안 자동 정리)

---

## 2026-05-02 · C4-PROPAGATE-TO-CHILDREN-001 (마감)

### C4 산출물 요약

- master → 3 자식 cp 327 파일 (109 × 3 · 에러 0)
- 자식 ui-spec.json 마이그레이션 44 파일 (alias + designTool)
- 자식 CLAUDE.md Nested 박음 (3 자식)
- propagation-status.md 갱신 (보호 5종 ALL ✓ MATCH)
- propagation-reports/C4-...-PROPAGATE/REPORT.md 신설
- master .ai/reports/C4-... REPORT.md 신설

### 검증 (실측 PASS)

- verify-sync.sh exit 0
- 109 파일 PASS / drift 0 / miss 0
- ui-spec.json sample alias match True

### Coin 손 작업 (sandbox 한계 → macOS 의무)

상세: `propagation-reports/C4-PROPAGATE-TO-CHILDREN-001-PROPAGATE/REPORT.md` §5

요약:
1. 자식 stale lock rm (3 회) — sandbox rm 권한 X
2. launchd 데몬 install (1회 · C10 영구) — 이후 lock 사고 0
3. 자식 git add + commit (3 회 묶음 가능)
4. master audit commit

### 다음 cycle 진입 조건

- C4 commit 마감 후 = master ↔ 자식 단방향 정합 100% 박힘
- 자식 repo 의 본 작업 cycle (Pencil → Compose 등) 진행 가능 = master cli infra 자동 적용

---

## 2026-05-02 · C11-LOCK-WIDE-COVERAGE-001 (마감)

### RCA
C10 박힌 daemon + C8/C9 hook/wrapper = `.git/index.lock` 만 처리. 단 git 의 lock 종류:
- `index.lock` — index (staging) 갱신
- `HEAD.lock` — HEAD ref 갱신 (commit / branch 변경)
- `packed-refs.lock` — packed-refs 갱신
- `config.lock` — git config 변경
- `refs/heads/<branch>.lock` — branch ref 갱신
- `refs/tags/<tag>.lock` — tag ref 갱신
- `refs/remotes/<remote>/<branch>.lock` — remote ref 갱신

→ GT commit = HEAD ref 갱신 = HEAD.lock 박힘 + sandbox crash + stale 잔존 = commit 차단.

### 결정 1. 광역 검사 patterns
- **선택**: 4 layer 모두 (daemon + pre-tool-use + session-start + git-safe) `.git/**/*.lock` 광역
- **근거**: 한 종류만 처리 = 다른 lock 발생 시 같은 사고 반복 → 모든 lock 종류 동일 PID 검증 + stale rm patterns 적용

### C11 산출물 요약

- 강화 4 파일:
  - `scripts/git-lock-daemon.sh` (광역 · index + HEAD + packed-refs + config + refs/**/*.lock + misc)
  - `.claude/hooks/pre-tool-use.sh` (광역 · git command 감지 시)
  - `.claude/hooks/session-start.sh` (광역 · 세션 시작 시)
  - `scripts/git-safe.sh` (광역 · wrapper 호출 시)
- incident-log + decision-log + CLAUDE.md §15 + REPORT.md

### Coin 손 작업 (즉시 사고 해결 + commit)

```bash
# Step 0: 모든 stale lock 광역 정리 (즉시 사고 해결)
rm -f ~/AndroidStudioProjects/*/.git/index.lock
rm -f ~/AndroidStudioProjects/*/.git/HEAD.lock
rm -f ~/AndroidStudioProjects/*/.git/packed-refs.lock
rm -f ~/AndroidStudioProjects/*/.git/config.lock
find ~/AndroidStudioProjects/*/.git/refs -name "*.lock" -type f -delete 2>/dev/null

# Step 1: GT commit 재시도 (HEAD.lock 정리됨)
cd ~/AndroidStudioProjects/GentlyTable && git commit -m "..."

# Step 2: launchd 데몬 재 install (C11 강화 적용)
bash ~/AndroidStudioProjects/claude-cli-master/scripts/install-git-lock-daemon.sh
# (재 install 시 기존 unload + 새 daemon load · plist 변경 X · script 만 업데이트)
```

### 다음 cycle 진입 조건

- C11 commit 후 = 모든 git lock 종류 자동 mitigation 박힘
- 자식 repo propagation 시 자동 적용 (`scripts/git-lock-daemon.sh` 는 master 안 daemon 이라 자식 repo 도 cover)

---

## 2026-05-02 · C4-VERIFY-001 (sandbox 마감 · Coin 손 작업 대기)

### 트리거

Coin 요청 — "C4 propagation 제대로? 빠진 내용? 중복/잔존?"

### 점검 결과 (5 영역)

| # | 영역 | 결과 |
|---|---|---|
| ① sha 정합 | verify-sync 109 / 0 / 0 | ✓ PASS |
| ② C11 hook drift | master vs 자식 hook 6 파일 (3-repo × 2 hook) | ✗ DRIFT → sandbox cp 즉시 정정 |
| ③ deprecated rules | C2 분할 후 pointer 6 종 × 4-way | ✗ 24 잔존 (Coin rm) |
| ④ flat agents 중복 | 자식 `agents/*.md` 25 vs `active/`+`deferred/` 25 | ✗ 75 중복 (Coin rm) |
| ⑤ sandbox testfile | 자식 `.ai/.sandbox-write-test` × 3 | ✗ 3 잔존 (Coin rm) |

### 결정 1. C11 hook propagation 누락 → sandbox cp 즉시 정정

- **실측**: master `pre-tool-use.sh` + `session-start.sh` 갱신 후 자식 propagate 누락 = drift 6 파일
- **정정**: sandbox `cp` 권한 가능 → 즉시 master sha 채택 후 cp
- **재실측**: PASS 109 / 0 / 0 회복

### 결정 2. deprecated + flat + testfile = Coin 손 작업 1 paste 묶음

- **선택**: 102 파일 일괄 rm + master 1 commit + 자식 3 commit (paste 1 회)
- **대안**: cycle 별 분리 (3 cycle) — 거부 (Coin 의 손 작업 비용 ↑)
- **근거**: sandbox `rm` 권한 한계 = 모두 같은 근본 원인 → 묶음 처리 ROI 최대

### 결정 3. 자동화 후속 (옵션 A `--prune` 보류)

- **현재**: `propagate.sh` 가 master 부재 파일을 자식에서도 자동 rm 안 함 (cp 일방향만)
- **고려**: `--prune` 모드 신설 검토 (cycle 우선순위 낮음 — 본 사고 1 paste 로 마감)
- **본 작업 본류 진입 우선**: 자식 도메인 cycle (Pencil → Compose) 시작 후 사고 재발 시 박는 방향

### C4-VERIFY 산출물

- `.ai/reports/C4-VERIFY-001/REPORT.md` (점검 + Coin 손 작업 1 paste + 옵션 후속)
- decision-log + incident-log + CLAUDE.md §15 갱신 (Coin 손 작업 후 = baseline 정정)

### 다음 cycle 진입 조건

- Coin 손 작업 1 paste (rm 102 + commit 4) → 다음 chat 진입 시 baseline = master rules 13 / 자식 rules 13 / 자식 flat agents 0 / verify-sync iter 103
- baseline 정정 후 = 자식 도메인 cycle (Pencil → Compose 본 작업) 진입 가능

---

## 2026-05-02 · C14+C13+C15-INFRA-MITIGATION-001 (sandbox 마감 · Coin paste 대기)

### 트리거

C13-VERIFY-FULL 의 발견된 gap 3 종 (.gitignore propagation 누락 + daemon 미활성 자동 진단 부재 + propagate prune 모드 부재) 묶음 처리. Coin 본 의도 = "한꺼번에 요청해도 될 것 같은데" → 묶음 1 cycle.

### 결정 1. 묶음 진입 (3 → 1 cycle)

- **선택**: 1 cycle 묶음 (1 paste · master 4 commit + 자식 3 × 1 commit)
- **대안**: 분리 3 cycle (12 commit + 3 paste · overhead 20 분 ↑)
- **근거**: 의존성 직선 + 충돌 영역 X (propagate.sh 의 find base vs flag/함수 분리) + 200 메시지 임계 안 넘음

### 결정 2. C14 정책 변경 — `.gitignore` byte-identical X

- **사전 검증 발견**: 자식 .gitignore = Android Studio build/gradle 패턴 보유 → master 단순 cp = 자식 빌드 차단
- **변경**: master .gitignore 자체는 propagate X. 별 patch script 가 cli infra patterns 만 자식에 보장 (idempotent · marker block)
- **신설**: `scripts/ensure-child-gitignore-patches.sh` (--verify / --target / patch 자동) + propagate.sh 자동 호출

### 결정 3. C15 안전 정책 — whitelist `.claude/` 만

- **사전 검증 발견**: 초안 (전 cli infra base path orphan 검사) = 자식 도메인 (DDL / .pen / repo-config / readiness) 311 파일 false positive → `--apply` 시 도메인 전체 날아감
- **변경**: default = `.claude/` 만 prune 후보. 자식 도메인 영역 = 자율 = 절대 prune 안 함
- **확장**: `--include <path>` flag = 별 cycle 검토 (C16 후보)

### 결정 4. dry-run vs apply 분리

- **선택**: `--prune` (dry-run · default · 안전) + `--apply` (실제 rm · 명시 의무)
- **근거**: 사고 시 revert 어려움 → opt-in 패턴

### 산출물 (3 cycle 묶음)

- 신설: `scripts/ensure-child-gitignore-patches.sh`
- 수정: `scripts/propagate.sh` (--prune + --apply flag + ensure-child-gitignore 자동 호출)
- 수정: `scripts/verify-sync.sh` (daemon 자동 진단 30 줄 + --skip-daemon-check flag)
- 자식 3 `.gitignore` patch (marker block)
- `.ai/reports/C14-C13-C15-INFRA-MITIGATION-001/REPORT.md`
- decision-log + incident-log + CLAUDE.md §15 갱신

### 다음 cycle 진입 조건

- Coin 1 paste (master 4 commit + 자식 3 × 1 commit + 검증 3 회) → 다음 chat 진입 시 baseline 정정
- 자식 도메인 본 작업 진입 가능 (C1~C15 master 정비 마감)

---

## 2026-05-02 · MASTER-AUTH-DOMAIN-ACTIVATE-001 (마감 · 2026-05-03 KST close)

### 결정 1. master path rebind: `claude-cli-master` → `gently-master`

- **선택**: 옵션 1 — prompt 의 모든 `~/AndroidStudioProjects/claude-cli-master/` 경로를 `~/AndroidStudioProjects/gently-master/` 로 치환 + 본 cycle 진행
- **대안**: 옵션 2 (master rename `gently-master` → `claude-cli-master` 후 prompt 그대로) · 옵션 3 (cycle 보류 + path 정합 별 cycle 신설)
- **근거**:
  - 실측 baseline (`ls -d ~/AndroidStudioProjects/Gently*` + `cat ~/AndroidStudioProjects/gently-master/CLAUDE.md`) = master 디렉터리 = `gently-master`. C5-EXTRA-COMMON-ABSORB-AND-RENAME-001 의 rename 결정 (claude-cli-master 채택) 이 file system 에 미반영 (decision 박힘 + 디렉터리 mv 미실행).
  - 옵션 2 = `mv gently-master claude-cli-master` 의무 = 자식 repo 의 모든 인용 경로 갱신 + git 상태 / IDE / Cowork 환경 영향 大. 본 cycle scope 외.
  - 옵션 3 = 본 cycle (Auth 도메인 활성화) 보류 = GT-AUTH-PIVOT-001 박힌 패러다임의 master 박음 지연.
  - 옵션 1 = path 치환만 (16 file ops 안 cycle scope 내 흡수). Coin 명시 승인 박음.
- **Coin 명시 승인**: 2026-05-02 chat — "1번 권장 confirm. prompt 의 모든 claude-cli-master 경로를 gently-master 로 치환 + decision-log 에 ... append + cycle 진행."

### 별 trail 신규
- `MASTER-DIR-REBIND-CLAUDE-CLI-MASTER-TO-GENTLY-MASTER-001` — `scripts/activate-agent.sh` + `scripts/propagate.sh` 의 `claude-cli-master` 하드코딩 default → 본 cycle 은 `MASTER_DIR=$HOME/AndroidStudioProjects/gently-master` env override 우회. 사후 정정 (script default 정합 + C5 rename 의 file system 적용 또는 default 변경) = 별 cycle 의무.

### 다음 cycle 진입 조건 (본 cycle 안)
- §3-1 ~ §3-4 (auth-rules.md 신설 + deferred-domains.md 갱신 + routing-and-delegation.md 갱신 + auth-security-privacy.md mv) → 4-file 3-repo propagation → EC1~EC4 검증 → 4 commit (master + 3 자식) → close memo

### close 박음 (2026-05-03 KST)
- master commit `3a8ca0d` · GT `6438e9e` · GD `8939085` · GB `6443c81`
- EC1~EC4 모두 PASS (verify-sync.sh 104/0/0 byte-identical · 보호 파일 4종 sha 무변경 baseline 그대로)
- Auth 도메인 master + GT 활성화 박힘 (`deferred-domains.md` §2 매트릭스 박음). GD/GB 자체 활성화 = 별 cycle (자연 trigger · lazy)
- 별 trail `MASTER-DIR-REBIND-CLAUDE-CLI-MASTER-TO-GENTLY-MASTER-001` = open (script hardcoded 정정 별 cycle)
- 2026-05-05 · MASTER-CLI-TERMINOLOGY-DEFINE-001 (PASS) · CLAUDE.md 머리 quote block prepend (terminology 5 항) · 4-repo byte-identical · § 번호 미부여 · 보호 파일 sha 변동 0 · 다른 cycle 병행 진행 · v4-resume 분할 진입 흡수.
- 2026-05-05 · MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001 Phase 1 마감 (Cowork 진행) · 보호 파일 5 종 + cli infra 6 종 4-repo byte-identical OK · drift 0 · 위반 0 · borderline 4 (splash dwell × 2 + onboarding wording + Forced Continuity) · anti-pattern 4 PASS (Roach Motel + Confirmshaming + Disguised Ads + Hidden Costs) · N/A 분류 8 화면 (GB 1 + GD 6 + GT 1) · 산출물 = `.ai/reports/MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001/EVIDENCE.md` (263 line · 9 섹션 · sha `20838bb7...`) + scripts/ · Phase 2 진입 권장 = (최우선) 결제·가입 깊이 (Forced Continuity disclosure + GT Billing TODO 정합).
- 2026-05-05 · MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001 (PASS) · ux-laws.md §5.1 N/A 영역 7 신설 (Auth-only/Backend-only/Doc-only/Dependency-decision/Build-CI-Tooling/Refactor/cli-infra) · sha 80aa2915→0f63f399 (306→322 line / +16) · 4-repo byte-identical propagation (master 3c48df5 / GB a8d985e / GD dd4d6f0 / GT 25d2358) · 누락 3 cycle REVIEW.md §B [UX Laws] + §B Dark Patterns N/A retro-add (GD-AUTH-ANON-IMPL-001 Auth-only / GD-CHART-LIB-DEPENDENCY-DECISION-001 Dependency-decision / GT-AUTH-PIVOT-001 Auth-only) · 산출물 = .ai/reports/MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001/ · plumbing 우회 (master sandbox lock 차단 우회 write-tree→commit-tree→update-ref) + Coin macOS commit (GD/GT lock 잔재 영향).

2026-05-05 | MULTI-REPO-BILLING-MODEL-RECONCILE-001 | scope=3-repo | GB(8ee777d) TicketShopScreen+ticket-shop SoT 정리 (SUBS dead code) + paywall→onboarding-pledge rename / GT(3b5d38f) SubscriptionState 제거 + wording 정정 / GD(e24e972) ticketshop SoT 신설 (.ui-spec.json · .pen 다음 cycle) | Coin 결정 8 건 (sub-cycle 진입 + GB TicketShop 처리 + paywall LOCKED + ticket-shop SoT 제거 + wording default + EVIDENCE.md baseline update + memory 갱신 + sub-cycle D .pen 분리) | baseline 정정 3 건 (SUBS hardcoded dead code · schema enum 미허용 · EVIDENCE.md sha drift) | 보호 10 file drift 0 + BillingManager + billing.md 무변동 ✓

2026-05-05 | MULTI-REPO-BILLING-MODEL-RECONCILE-001 Phase 8 (cowork R3 흡수) | scope=GD + master | Coin turn 12 결정 ('내가 하지 않게 처리') | cowork 측 .pen format = JSON 영역 발견 → cowork 직접 작성 흡수 ✓ (GD c868a1c · ticketshop-screen.{pen,preview.light.png,preview.dark.png,ui-spec.json} · 4 file / +306 / -11 · sha 42b9a13b 정합) | R3-HANDOFF status BLOCKED → PARTIAL_HANDOFF (Pencil 영역 정밀 정합 영역만 잔존 · trigger Pencil 1.1.56+ release) | 사고 영역 (5) ENVIRONMENT-DEPENDENCY-CHECK-MISS-001 보강 영역 학습

2026-05-05 | MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001 (PARTIAL · audit 본 작업 PASS) | scope=3-repo runtime emulator audit (Pixel_9_Pro · ko-KR strings.xml · light+dark) | 활성 28+ 화면 capture 46 PNG/XML + matrix-results.csv 70 row | Findings 13 (PASS 9 / FAIL 2 [F3 GB SettingsScreen.kt:313 + F12 GT SettingsScreen 한입 티켓 충전 entry path 단절] / BORDERLINE 1 [F2 GB onboard step4 Loss-Aversion incentive ACCEPTABLE] / BLOCKED 1 [F7→F8 GD anon auth Supabase signup 응답 X → main 5 화면 진입 차단]) | Dark Patterns 5 + §3 비권장 5 모두 PASS | SoT-runtime cross-verify: GB TicketPurchaseScreen 코드 only DRIFT (chat D placeholder 영역 정합 의무) | 산출물 = .ai/reports/MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001/ (EVIDENCE 135 / PLAN 82 / VERIFY 67 / REVIEW 172 line) + screenshots/ + ui-dumps/ + scripts/cap.sh | mitigation 별 cycle 2 후보 (TICKETSHOP-ENTRY-PATH-RESTORE-001 + GD-ANON-AUTH-SIGNUP-DIAGNOSE-001) | audit read-only ✓ (4-repo HEAD 신규 commit 0)

2026-05-06 | MULTI-REPO-TICKETSHOP-ENTRY-PATH-RESTORE-001 (PASS · 통합 cycle option a) | scope=GB+GT mitigation (Cycle 2 audit FAIL 2건 + Billing init 진단) | 작업 1 F3 GB SettingsScreen empty TODO onClick → onNavigateToTicketPurchase 콜백 wire (SettingsScreen + MainScaffold 2 file / +5 -1 · GB fc5f02e) | 작업 2 F12 GT SettingsScreen SectionCard(BillingSection) wrapper → NavCard pattern (AI section 정합 mirror) + onOpenTicketShop 3-hop wire (RootNavGraph→MainScaffold→SettingsScreen 5 file) | 작업 3 Billing init graceful — BillingViewModel Log.w 진단 seam (TAG companion) + BillingSection "결제 서비스 준비 중입니다 (Coming soon)" fallback (loading X · connected X · products empty 조건) — BillingManager.kt INAPP/consumeAsync/startConnection 본질 무변경 ✓ (STOP 경계 보존) (GT 553c40b · 5 file / +20 -5) | EC ./gradlew assembleDebug both PASS exit 0 (GB 1m 53s · GT 1m 52s) | 산출물 = claude-cli-master/.ai/reports/MULTI-REPO-TICKETSHOP-ENTRY-PATH-RESTORE-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md (12-section + §B [UX Laws] Navigation matrix B-3/E-1/F-4 + Dark Patterns 5종 PASS + PromptFit 92/100) | Coin verbatim option a 채택 (sequential 3 작업 · BillingManager 본질 변경 X · 보호/cli 6 sha 변경 X · 실 결제 dialog 진입 X) | lazy follow-up = (선택) runtime cap.sh 재실행 + BillingClient runtime startConnection 실 fire 검증 (Google Play 외부 prep)

2026-05-05 | GD-ANON-AUTH-SIGNUP-DIAGNOSE-001 (PARTIAL · 진단 본 작업 PASS · CLI 정정 영역 0) | scope=GD anon auth 진단 / read-only audit | 부모 cycle MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001 Findings F7 + F8 mitigation 진단 cycle | RCA = ~/AndroidStudioProjects/GentlyDay/local.properties 파일 부재 → app/build.gradle.kts:36-49 localOrStub() fallback → BuildConfig.SUPABASE_URL=https://placeholder.supabase.co + SUPABASE_ANON_KEY=placeholder-anon-key → SupabaseProvider:19-20 placeholder host 호출 → AnonymousAuthBootstrap.kt:32-44 1차+1회 retry fail → DomainError.Network → step5 "로그인이 필요합니다" wording → F7 → F8 main 5 화면 BLOCKED cascade | 코드 정합 검증 5 file (AnonymousAuthBootstrap + SupabaseAuthClientImpl + AuthRepositoryImpl + SupabaseProvider + build.gradle) = auth-rules.md §1-4 paradigm 100% 정합 / 코드 정정 영역 0 | mitigation = 순수 Coin prep 영역 (Supabase 대시보드 5 step → 별 cycle GD-ANON-AUTH-RUNTIME-RECHECK-001 trigger 조건) | 산출물 = .ai/reports/GD-ANON-AUTH-SIGNUP-DIAGNOSE-001/ (EVIDENCE 7639B / PLAN 4951B / VERIFY 3293B / REVIEW 6802B) | Verdict=PARTIAL · PromptFitScore 92/100 · ux-laws N/A (Auth-only §5.1) · STOP 5 조건 모두 미진입 (Supabase 변경 0 / 코드 변경 0 / local.properties write 0 / auth-rules.md §1 SoT 변경 0 / 보호 5 sha 변동 0)

2026-05-10 | MULTI-REPO-EDGEFN-VAULT-KEY-RENAME-001 (PASS · 3-repo Edge Function env var 명명 통일) | scope=GB+GD+GT 자식 3-repo Supabase Edge Function 안 ANTHROPIC_API_KEY → CLAUDE_API_KEY rename + master parent reports | commit 4 (master 95f9f56 / GB 64de5a5 / GD f55ca9c / GT 783cd15) | 결정 본질 = 3-repo 동시 propagation 안전한 ops-layer 변경 (Deno.env.get 키 이름 + 폴백 메시지 + README · Vault 등록 변경 X) | EC = grep ANTHROPIC=0 / grep CLAUDE=8 hit · 3 자식 self-verify PASS · 사고 영역 0 / 보호 6 file sha 변동 0 (f1edd397/ee377dc2/e5e3fe16/7621013e/96de2f5d/5be3d237 그대로) | 산출물 = .ai/reports/MULTI-REPO-EDGEFN-VAULT-KEY-RENAME-001/{EVIDENCE,PLAN,VERIFY,REVIEW}.md (Risk=Low / DBMig=No / MoneyAuth=No · 3-section REVIEW · Verdict=PASS) | 다음 cycle trigger = Coin direct prep (Vault registration + Edge Function deploy) 별 영역 (cycle 외)

2026-05-10 | MULTI-REPO-CLAUDEMD-DOMAIN-CONTEXT-FILL-001 (PASS · GB+GD CLAUDE.md 제품 컨텍스트 Phase 1 baseline 채움) | scope=GB+GD CLAUDE.md line 230+235 stub 정정 (GT pattern 정합 · 도메인 본질 wording 미포함) | GB CLAUDE.md sha 2053b6ba (Edge Function 5: check-quota/claude-proxy/verify-ad-reward/verify-integrity/verify-purchase + DDL 7 table + RLS 19 policy + AdMob SSV) | GD CLAUDE.md sha 09f90af6 (Edge Function 1 ai_insights + DDL 12 table + RLS 49 policy) | 보호 5 file sha 변동 0 (f1edd397/ee377dc2/e5e3fe16/7621013e/96de2f5d 그대로) · 4-repo byte-identical · verify-sync.sh 106/0/0 PASS exit 0 | 도메인 본질 wording (호흡 / 마음챙김 등) Coin reserve 영역 · 본 cycle scope 외 (CLI 추정 금지) | Risk=Low · DBMig=No · MoneyAuth=No · cleanup=N/A (ops-layer · 제품 코드 미변경)

2026-05-10 | MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001 (PASS · terminology.md 신설 + 4-repo byte-identical propagation) | scope=master .claude/rules/terminology.md 신설 + CLAUDE.md L3 cross-ref 1줄 추가 + 자식 3 propagation | master commit cc64d75 (parent 3e7201b) / GB 3b8d5a5 / GD 83cb55b / GT 09aa454 | 신설 file sha-256 (16자 prefix) = 1eb1ad8625cc97fa — 4-repo 동일 | 결정 본질 = SoT/SOT/SSOT 표기 혼용 268건 진입 마찰 해소 · legacy 정정 X (D 옵션 합리화) · cli infra 신규 rule file 형식 신설 | EC = propagate ok=3 fail=0 / verify-sync PASS 111/0/0 / 보호 파일 5종 SHA 변동 0 (f1edd397/ee377dc2/e5e3fe16/7621013e/96de2f5d 그대로) | STOP 조건 전건 미발생 | 산출물 = .ai/reports/MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001/{PLAN,VERIFY,REVIEW}.md | Risk=Low · DBMig=No · MoneyAuth=No · cleanup=N/A (ops-layer) · PromptFitScore=96/100 · Verdict=PASS
