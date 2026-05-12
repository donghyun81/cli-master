## GATESv2

| Field | Value |
|---|---|
| TaskId | GENTLY-AGENT-METADATA-3FIX-001 |
| Mode | cli infra ops-layer (3 agent file frontmatter + 본문 교차권한 + path drift) |
| Workflow | Collect -> Plan -> Implement -> Master single commit -> Propagate -> Verify -> Review |
| Requirements Source | 사용자 cycle prompt (본 turn 진입 메시지) |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 3 변경 (master 단일 commit) + 3 propagation (자식 3-repo 각 1 commit) = 6 commit |
| Modules | `.claude/agents/active/` (code-simplifier + layer-checker + domain-roles) |
| Risk | Low (ops-layer · 본문 + frontmatter 영역 · 실 코드 무접촉) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A (의존성 변경 없음 · libs.versions.toml 무접촉)

## 3. ArchitectureImpact

N/A (신규 인터페이스 / 추상화 없음 · agent metadata + 본문 정정 만)

## 4. ModelBoundaryPlan

N/A (모델 레이어 무접촉)

## 5. ErrorPolicy

N/A (UseCase / Repository 신규 작성 없음)

## 6. UIStateFlowPlan

N/A (UI 무접촉)

## 7. TestabilitySeams

N/A (테스트 변경 없음 · 본 cycle 검증 = sha cross-verify + frontmatter parse + grep + verify-sync.sh)

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | (1) `shasum -a 256` 4-repo 3 file sha 동일성 · (2) `python3 -c "import yaml..."` 또는 `head -n N <file>` frontmatter `---` 영역 파싱 · (3) `grep -nE` domain-roles path 정합 grep · (4) `bash scripts/verify-sync.sh --skip-daemon-check` exit 0 또는 영향 영역 DRIFT 만 |

## 9. RollbackStrategy

- 롤백 가능 지점: 각 commit (master 1 + 자식 3 = 4 commit). `git revert <sha>` 가능.
- 롤백 조건: STOP 8 조건 발동 또는 verify-sync FAIL (본 cycle 영향 영역).
- 복구 경로: `git revert <commit-sha>` (master + 자식 3-repo 각각) — 모든 변경 가역.

## 10. ExternalPrep / DeferredItems

N/A (외부 의존 없음)

---

## Plan (단계별 작업 목록)

### STEP 2 — master 3 file Edit

#### β-1: code-simplifier.md frontmatter

```yaml
---
name: code-simplifier
description: 구현 완료 후 cleanup pass 전용. 미사용 import, 데드 코드, 네이밍 일관성 검사. cleanup-governance 규칙 준수.
tools: Read, Glob, Grep, Edit
---
```

- Generator bucket 정합 (`routing-and-delegation.md §구현 전문가 표` — write 허용 영역).
- 권장 tools = `Read, Glob, Grep, Edit` (cleanup pass 측 line/block 제거 의무 영역 정합 · code-simplifier.md L20 "whole-file deletion 금지 (Edit tool 라인 제거만 허용)" 정합).
- 본문 무변경 (frontmatter `tools:` 1 line 추가 만).

#### β-2 + γ: layer-checker.md frontmatter + 본문 교차권한 단락

frontmatter:

```yaml
---
name: layer-checker
description: shared/domain → framework import 위반 및 app→shared 단방향 흐름 검증. read-only.
tools: Read, Glob, Grep, Bash
---
```

- Evaluator bucket 정합 (`routing-and-delegation.md §검증 보조` — read-only 영역).
- 권장 tools = `Read, Glob, Grep, Bash` (`rg` / `grep` shell 명령 직접 실행 의무 영역 정합 · 본문 L33-39 "검사 명령" `rg` 직접 호출 영역 + verifier.md `tools: Read, Glob, Grep, Bash` 표준 정합).

본문 안 교차권한 단락 추가 (현재 L59-64 "## 제약" 영역 + L65 종료 영역 사이 신설):

```markdown
## 교차권한 금지 (Evaluator 경계)

본 agent = Evaluator bucket (read-only 검증/판정 역할). `routing-and-delegation.md §Planner/Generator/Evaluator 경계` 5 규칙 중 **#3 "Evaluator 는 고치지 않는다"** 정합:

- layer 위반 발견 시 직접 코드 수정 X.
- FAIL / PARTIAL 판정 + 구체적 수정 방향 제시 (file:line + import 내용 + 수정 방향) 의무.
- 후속 처리 = change-planner 루프 escalate (system-architect 영역 의뢰 또는 ui-implementer / server-implementer 호출 결정).
- Skeptic Evaluator Tuning 영역 (weakest-evidence-first · CONFIRMED 기준 · counter-example 요구 등 5 규칙) = `.claude/agents/active/reviewer.md` "Skeptic Evaluator Tuning" 섹션 SoT. 본 agent 본문 영역 = layer 검증 영역 만 (Skeptic 본문 복제 X · cross-ref 단일 줄 정합).
```

위치 = 현재 L59-64 "## 제약" 직후 + L65 (EOF) 직전 신설 영역.

#### ε: domain-roles.md L15-55 path 정정

총 21 path 영역 정정 (EVIDENCE.md 안 매핑 표 정합):
- 코어 6 (L15-20) → 모두 `active/` prefix 추가
- 도메인 분석 8 (L26-33) → ux-auditor + auth-security-privacy = `active/` · 나머지 6 = `deferred/`
- 문서 거버넌스 2 (L39-40) → 모두 `active/`
- 구현 4 (L46-49) → server-implementer = `deferred/` · 나머지 3 = `active/`
- 검증 보조 1 (L55) → `active/`

본문 wording 영역 변경 X (path 영역만).

### STEP 3 — master single commit

- subject: `chore(agent): GENTLY-AGENT-METADATA-3FIX-001 code-simplifier + layer-checker frontmatter tools + 교차권한 본문 + domain-roles path drift`
- body 6 섹션 (cycle-discipline §7):
  - `[Goal]` cli infra agent metadata 정합 3 사고 단일 cycle 묶음 mitigation (β L3-4 + γ L3-5 HIGH + ε L3-7)
  - `[Diff]` 3 file 변경 — code-simplifier.md (frontmatter tools 1 line) + layer-checker.md (frontmatter tools 1 line + 본문 교차권한 단락 ~10 줄) + domain-roles.md (L15-55 path 21 영역 정정)
  - `[Sha]` 보호 5종 불변 · 3 file new sha 8자 prefix 명시
  - `[EC]` 본문 wording 영역 변경 0 (routing/reviewer/billing SoT 무접촉) · 보호 5종 sha 변동 0 · 4-repo 사전 baseline 정합
  - `[Next]` propagate.sh 3 file → 자식 3-repo → verify-sync.sh PASS
  - `[Refs]` parent `d2eb521` · task `GENTLY-AGENT-METADATA-3FIX-001`

### STEP 4 — propagation 자식 3-repo

1. `bash scripts/propagate.sh .claude/agents/active/code-simplifier.md .claude/agents/active/layer-checker.md .claude/agents/active/domain-roles.md --targets GB,GD,GT` (master root cwd)
2. 4-repo 3 file sha cross-verify
3. 자식 3-repo 각각 `git add` (명시 path 만) + single commit:
   - subject: `chore(agent): GENTLY-AGENT-METADATA-3FIX-001 propagate 3 agent`
   - body 6 섹션 (cycle-discipline §7)

### STEP 5 — VERIFY.md

1. 4-repo 3 file sha 동일성 (= `shasum -a 256` × 12)
2. frontmatter parse 정합:
   - `python3 -c "import sys; ..."` 또는 `head -n 6 <file> | grep -E '^(name|description|tools):'` → 3 키 모두 존재 확인
   - frontmatter `---` 영역 정합 (개행 + `---` 영역)
3. domain-roles.md path 정합 grep:
   - `grep -nE '\.claude/agents/(active|deferred)/[a-z-]+\.md' <file>` → 21 hit 의무
   - `grep -nE '\.claude/agents/[a-z-]+\.md' <file>` (active/deferred prefix 없는 영역) → L78 + L86 path template 영역 (instruction wording · scope 외) 이외 0 hit 의무
4. 보호 5종 sha 변동 0 재 측정
5. `bash scripts/verify-sync.sh --skip-daemon-check` exit code + 영향 영역 DRIFT 만 분류

### STEP 6 — REVIEW.md 12-section + decision-log

1. REVIEW.md 12-section + PromptFitScore
2. Verdict 판정 (PASS / PARTIAL · 본 cycle 영향 영역 외 DRIFT 시 PARTIAL 정합)
3. 본문 작성 영역의 routing §5#3 명시 정합 + Skeptic SoT cross-ref 1 줄 정합 검증
4. `.auto-memory/decision-log.md` 1 entry append
5. Coin 회수 보고 6 항목

---

## 진입 baseline (STEP 0 EVIDENCE.md 정합)

- 4-repo HEAD: `d2eb521 / 0256fa8 / d9e6e5e / 2ce2e09` MATCH prompt BASELINE 100%
- 4-repo 3 file sha: `1b98596e / 34f42c7f / 86e8b6a7` byte-identical MATCH
- 보호 5종 sha baseline `f1edd397 / 7621013e / 96de2f5d / ee377dc2 / e5e3fe16` MATCH
- scripts/propagate.sh + scripts/verify-sync.sh 존재 PASS

## Notes

- 본 cycle 모든 stage 는 `git add <명시 path>` (`git add -A` / `git add .` 금지) — STOP 8 영역 정합.
- master + 자식 3-repo 측 baseline-snapshot.sh / latest.json 자동 갱신 영역 = 본 cycle 무관 (session-start hook 자동 산출) — stage 흡수 X.
- propagate.sh 측 `.auto-memory/propagation-status.md` 자동 갱신 영역 = master audit commit 측 함께 stage 가능 (= 직전 cycle 패턴 정합).
- domain-roles.md L78 `.claude/agents/<role-name>.md` + L86-87 frontmatter `name:` template 영역 = instruction wording (실제 agent path 아님) · 본 cycle scope 외 (= ε scope = L15-55 path 영역만).
- routing-and-delegation.md 본문 무접촉 (= STOP 2 정합) · reviewer.md "Skeptic Evaluator Tuning" 영역 무접촉 (= STOP 3 정합 · cross-ref 1 줄만 layer-checker 본문 안 명시).
