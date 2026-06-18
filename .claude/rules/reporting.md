# Reporting — Unified SoT (산출물 경로 + 형식 + 근거 기준 + Subagent Return Contract)

> **단일 목적**: 산출물 경로 규약 + stdout 출력 순서 + Task 문서 (`.ai/tasks/<taskId>.md`) 형식 + EVIDENCE.md / PLAN.md (10-section 정규 스키마) / VERIFY.md / REVIEW.md (12-section 정규 스키마) / 근거 기록 기준 / Subagent Return Contract / 제외 경로 통합 SoT.
> **신설**: MASTER-CLI-CLEANUP-7CYCLE-001 (2026-05-21) · 직전 2 file (`report-paths.md` + `report-formats.md`) 본문 통합 default.
> **연관 파일**:
> - `cycle-discipline.md` §11 — 보고서 lightweight 옵션 (4 파일 vs 7 파일)
> - `verification-and-review.md` — /verify 와 /review 세부 규칙
> - `legacy-cleanup-governance.md` — Cleanup Assessment 섹션 의무
> - `workflow-core.md` — 단계 흐름 (intake / collect / plan / implement / verify / review)
> SOT: `CLAUDE.md`

---

## §1 산출물 경로 규약

모든 산출물의 형식, 경로, 기록 기준을 정의한다.

> **연관 영역 — working file lifecycle**: 본 §1 산출물 외 cycle 진행 시 working file (= `cycle-prompt-*.md` + `cc-paste-*.md` + `*-addendum-*.md` + `.bak` + `.ai/prompts/*.md` 등) 측 lifecycle + archive paradigm 단일 SoT = [`working-file-lifecycle.md`](./working-file-lifecycle.md) (= frontmatter 3 키 + 5 위치 archive + INDEX.md 5-column 형식 + REVIEW.md PASS 또는 mtime 14일 fallback trigger).

| 파일 | 경로 | 특성 |
|---|---|---|
| Task 문서 | `.ai/tasks/<taskId>.md` | 불변 (원문 요구사항 + 메타) |
| Task 인덱스 | `.ai/tasks/INDEX.md` | 항상 최신 유지 |
| MODE | `.ai/reports/<taskId>/MODE.md` | 첫 단계에서 생성 |
| EVIDENCE | `.ai/reports/<taskId>/EVIDENCE.md` | 수집 근거 전체 |
| PLAN | `.ai/reports/<taskId>/PLAN.md` | ChangeBudget + 작업 계획 |
| VERIFY | `.ai/reports/<taskId>/VERIFY.md` | 검증 명령 + 결과 |
| REVIEW | `.ai/reports/<taskId>/REVIEW.md` | 최종 판정 |
| COMPOUND | `.ai/reports/<taskId>/COMPOUND.md` | 종합 검증 결과 (구 compound-lint = deprecated) |
| TODO | `.ai/reports/<taskId>/TODO.md` | 후속 작업 목록 |

---

## §2 stdout 출력 순서

항상 다음 순서를 따른다:

```
[EVIDENCE] 수집 근거 요약
[DIFF]     변경 내역 (파일:라인)
[LOG]      검증 명령과 exit code
```

---

## §3 Task 문서 (`.ai/tasks/<taskId>.md`) 형식

```markdown
## Meta
| 항목 | 값 |
|---|---|
| TaskId | <PREFIX>-<DOMAIN>-NNN |
| Created (KST) | YYYY-MM-DD HH:MM |
| Status | COLLECT / PLAN / IMPLEMENT / VERIFY / REVIEW / DONE / STOP / BLOCKED |
| Risk | Low / Medium / High |
| DBMig | Yes / No |
| MoneyAuth | Yes / No |

## 원문 요구사항
[사용자 원문 그대로]

## 분해된 문제 진술
[requirements-analyst 결과]

## 성공 조건
[measurable success criteria]

## Measurable Exit Criteria
_자연어 성공 조건과 1:1 대응. 실행 가능한 검증 명령이나 grep 패턴으로 기술._
- [ ] `<검증 명령 또는 grep 패턴>` — <기대 결과>

## 비기능 요구사항
[non-functional requirements]

## 불확실성 (UNKNOWN)
[근거 없는 항목 + 확인 위치]
```

---

## §4 EVIDENCE.md 형식

```markdown
## Requirements Source
- 원문 요구사항 (또는 .ai/tasks/<taskId>.md 참조)
- Requirement chain 충족 여부
- Authority boundary

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | ... |
| Reading Mode | ... |
| Requirement Source | ... |
| Info Gap | RESOLVABLE_IN_REPO / UNKNOWN / BLOCKED |
| STOP Risk | ... |
| Read-Only Fan-Out | ... |
| Implementer Entry | Allowed / Blocked / N/A |

## Pre-EVIDENCE Contract
- Read evidence: ...
- Remaining gaps: ...
- Chosen path: ...
- Hold / Stop reasons: ...
- Implement entry conditions: ...

## Collect Results
### 매칭 파일/패턴
- file:line — 내용 요약

### 0 Matches (부재 증거)
- 검색했으나 없는 항목 목록

## Key Findings
[수집 결과 요약]

## Cleanup Assessment
_code-level task에서 필수. 제품 코드 미변경 ops-layer task는 `N/A (ops-layer task)` 명시._
_이 섹션이 없으면 stop-gate가 차단한다. 조사형·문서형 task는 적용 안 함(선택)._

### 발견된 후보
| 위치 | 설명 | 판정 |
|---|---|---|
| file:line | 설명 | 제거 예정 / TODO(deferred) / task-level STOP |

### 점검 명령
`rg -n "심볼명" --include="*.kt" .` — N matches

### 판정 요약
- 즉시 제거: 0건
- deferred: 0건
- task-level STOP: 0건
```

---

## §5 PLAN.md 형식 (10-section 정규 스키마)

> 각 섹션은 이름이 있는 독립 관심사다. 해당하지 않으면 `N/A` 명시 — 섹션 삭제 금지.

```markdown
## GATESv2
| Field | Value |
|---|---|
| TaskId | ... |
| Mode | ... |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | .ai/tasks/<taskId>.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | N |
| Modules | ... |
| Risk | Low / Medium / High |
| DBMig | Yes / No |
| MoneyAuth | Yes / No |

## 2. DependencyDecision
_libs.versions.toml 변경이 없으면 `N/A` 명시. 변경이 있으면 라이브러리별 8개 항목 모두 기술._

| 항목 | 값 |
|---|---|
| Library | N/A |
| ①공식·표준 지위 | N/A |
| ②유지보수 품질 | N/A |
| ③KMP·CMP 호환 | N/A |
| ④transitive 비용 | N/A |
| ⑤기존 기능 중복 여부 | N/A |
| ⑥제거 난이도 | N/A |
| ⑦직접 구현 대비 우위 | N/A |
| ⑧UI 라이브러리 특별 정당화 | N/A |

## 3. ArchitectureImpact
_새 인터페이스·추상화 없으면 `N/A` 명시._

- 새 인터페이스/추상화: N/A
- 변동성 경계 유형: N/A
- 레이어 누수 위험: N/A
- shared-first 경계 영향: N/A

## 4. ModelBoundaryPlan
_모델 레이어 분리 변경 없으면 `N/A` 명시._

- DTO 변경: N/A
- Entity 변경: N/A
- DomainModel 변경: N/A
- UiState 변경: N/A
- 경계 매핑 추가/변경 (Repository·UseCase·ViewModel 위치): N/A
- I2 import 방향 영향: N/A

## 5. ErrorPolicy
_새 UseCase·Repository 작성 없으면 `N/A` 명시._

- typed Result 사용 여부: N/A
- 오류 모델 (sealed class/interface 명): N/A
- 기존 코드 교체 범위: N/A (전면 교체는 범위 초과 — 별도 task)

## 6. UIStateFlowPlan
_UI 또는 ViewModel 변경 없으면 `N/A` 명시._

- UiState 변경: N/A
- ViewModel 단방향 흐름 유지: N/A
- SharedUiState<T> 변형 사용: N/A

## 7. TestabilitySeams
_테스트 변경 없으면 `N/A` 명시. 있으면 새 테스트 파일명과 FakeXxx 여부 필수 명시._

- 테스트 파일: N/A
- FakeXxx 사용: N/A
- 심 주입 대상 (clock·dispatcher·identity·logger·uuid): N/A
- 심 연기 시 명시적 사유: N/A

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `./gradlew test` (예시 — 실행 가능 명령만 기입) |

> **Risk 기반 경량화**: Low Risk task는 §1 GATESv2, §2 ChangeBudget, §9 VerificationPlan + 작업 목록만 필수. 나머지 N/A. Medium 이상은 전체 10-section 필수.

## 9. RollbackStrategy
_문서 전용 변경: "git revert <commit>으로 즉시 복구 가능" 명시._
_제품 코드 변경: 아래 항목 모두 기술 필수 (N/A 불허)._

- 롤백 가능 지점: N/A
- 롤백 조건 (언제 실행하는가): N/A
- 복구 경로 (롤백 후 다음 단계): N/A

## 10. ExternalPrep / DeferredItems
_외부 의존 연기 항목 없으면 `N/A` 명시._

- 연기 항목: N/A
- user-prep 선행 조건: N/A
- stub/TODO(user-prep) 위치: N/A

## Plan

1. ...
2. ...

## Notes
```

---

## §6 VERIFY.md 형식

```markdown
## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `<command>` | 0 | PASS |

## Verification Summary
[결과 요약]

## UNKNOWN (검증 불가 항목)
[사유 + 위치]

## LOG
```
[LOG] YYYY-MM-DD HH:MM KST
CMD: <실행 명령>
EXIT: 0
STDOUT: [핵심 출력]
```
```

> **명령 흔적 필수**: 백틱 래핑 명령(테이블) 또는 `CMD:` 패턴(LOG) 이 1개 이상 있어야 한다.
> UNKNOWN 사유만 있는 VERIFY.md 는 미통과 — reviewer 판정 FAIL (구 compound-lint 3b 검사 = deprecated · 도구 부재).

---

## §7 REVIEW.md 형식 (12-section 정규 스키마)

> 각 섹션은 이름이 있는 독립 판정 영역이다. 해당 없으면 "N/A" 명시.

```markdown
## Technical Review

> **Risk 기반 경량화**: Low Risk task는 §1 Requirements Coverage, §2 Regression Risk, §11 Secrets Safety만 필수. **UI 레이어 변경(Screen/ViewModel/UiState 신규·수정) 포함 시 §5 Model Separation + §14 Design SoT Sync 추가 필수.** 나머지 N/A. Medium 이상은 전체 12-section 필수.

### 1. Requirements Coverage
- [ ] 요구사항 성공조건 충족: <근거 (CONFIRMED/INFERRED/UNKNOWN)>
- [ ] 성공 조건 항목별 대조: <확인>
- [ ] Intake normalization / pre-EVIDENCE 계약 존재: <확인 / N/A>

### 2. Regression Risk
- 변경 영향 범위: <확인>
- 회귀 위험 없음: <근거>

### 3. Architecture Integrity — SOLID
- SOLID 영향: <없음 / 단일 책임 위반 여부 / 과도한 추상화 여부>
- DTO·Entity·DomainModel·UiState 분리 유지: <확인>
- 오류 모델 선택 근거 명시: <N/A / 확인>

### 4. Architecture Integrity — Layer Boundaries
- 아키텍처 경계 준수: <확인>
- I2 불변 원칙 (domain→data import 금지): <N/A / 확인>
- 경계 매핑 위치 (Repository·UseCase·ViewModel 에서만): <N/A / 확인>

### 5. Model Separation
- UiState 가 DomainModel 과 분리됨: <N/A / 확인>
- UI 단방향 흐름 유지: <N/A / 확인>
- 경계 매핑 변환 위치: <N/A / 확인>

### 6. Dependency Governance
- libs.versions.toml 변경: <Yes/No>
- DependencyDecision 8개 항목 기술 여부: <N/A / PASS>
- 신규 의존성 승인: <N/A / PASS / FAIL>

### 7. TDD Evidence & Testability Seams
- FakeXxx 테스트 존재 또는 N/A 사유: <확인>
- StateFlow 테스트: <N/A / 존재>
- 심 기반 테스트 (clock·dispatcher·identity·logger·uuid): <N/A / 존재 / 연기 사유>

### 8. Error / Result Policy
- typed Result 사용 여부: <N/A / Yes>
- sealed 오류 모델: <N/A / 확인>
- 기존 코드 전면 교체 없음: <확인>

### 9. External Prep / Deferred Items
- user-prep TODO 또는 stub 처리: <N/A / 확인>
- 외부 의존으로 인한 UI 불변 상태 침해 없음: <확인>

### 10. DocSync
- 문서-구현 드리프트 없음: <확인>

### 11. Secrets Safety
- 시크릿 노출 없음: <시크릿 grep 결과> (스캔 범위: `.ai/reports/<taskId>/` 아래만 — product code 전체 스캔 아님 · 패턴 SoT = `safety-and-secrets.md` §시크릿 스캔 패턴)

### 12. Rollback Viability
- 롤백 지점 실행 가능성: <확인>
- 비가역 변경 없음: <확인>

### 13. Cleanup Governance
_code-level task에만 적용. ops-layer·조사형·문서형 task는 N/A 명시._
- Cleanup assessment 흔적 (EVIDENCE.md `## Cleanup Assessment` 섹션): <N/A / 확인 / 누락>
- 제거 판단 근거 충분성: <N/A / CONFIRMED / INFERRED / UNKNOWN>
- 핵심 경로 후보 task-level STOP 처리: <N/A / 없음 / 확인>
- code removal vs file deletion 구분 준수: <N/A / 확인>

### 14. Design SoT Sync
_UI visible-state(FULL) 변경 포함 task에만 적용. UI 무변경·ops-layer·문서형 task는 N/A 명시._
- 변경 화면 `.pen` + `.ui-spec.json` 선행/동반 refresh: <N/A / 확인 / 누락>
- 누락 시 `DESIGN-DEBT.md` 등재 (deferred lane): <N/A / 등재 / 미등재(WARN)>
- 출시 후 net-new visual 선행 의무 충족: <N/A / 확인 / 위반(release FAIL)>

## Findings
[근거 기반 판정. 근거 없으면 UNKNOWN.]

## Verdict
PASS / FAIL / PARTIAL

## Remaining Risks
[향후 주의사항 — 이유와 함께 명시]

---

## PromptFit

PromptFitScore:
PromptFitVerdict:
PromptFitBreakdown:
- Requirement Alignment: /25
- Scope Control: /20
- Evidence/Verify Quality: /20
- Risk/STOP Handling: /10
- Output Contract Compliance: /10
- Prompt Efficiency/Clarity: /15
PromptFitIssues:
-
PromptFitNextActions:
-
PromptFitConfidence:
```

---

## §8 근거 기록 기준

| 신뢰도 | 표기 | 조건 |
|---|---|---|
| CONFIRMED | `[CONFIRMED]` | 파일:라인 등 직접 증거 있음 |
| INFERRED | `[INFERRED]` | 간접 근거로 추론 (근거 명시) |
| UNKNOWN | `[UNKNOWN]` | 레포 내 근거 없음 (확인 위치 명시) |
| RESOLVABLE_IN_REPO | `[RESOLVABLE_IN_REPO]` | 아직 안 읽었거나 검색 범위를 좁히면 repo 안에서 확인 가능 |
| BLOCKED | `[BLOCKED]` | 권한/환경/누락 도구/승인 부족 때문에 진행 불가 |

---

## §9 Subagent Return Contract

상위 agent (intake-router / change-planner / verifier / reviewer) 가 하위 subagent 를 호출해
그 결과를 자신의 컨텍스트로 다시 흡수할 때는 아래 계약을 따른다. 하위 agent 가 긴 raw output
을 그대로 돌려주면 상위 agent 의 context window 가 금방 고갈되고, 장기 실행 task 일수록 이
비용이 누적된다.

### §9.1 크기 상한

- 단일 subagent return 은 **≤ 4,000 token 요약** 을 목표로 한다 (Claude Code subagent output window 실측 기준 — 2k는 정보 손실, 8k는 상위 agent context 압박).
- 4k 를 초과할 것으로 예상되면 subagent 는 **full detail 을 파일(path pointer)** 로 남기고
  return 에는 path 와 핵심 hook 만 포함한다.
- 긴 코드/로그 인용은 path pointer 가 기본이다 (`file:line-range` 또는
  `.ai/reports/<taskId>/<name>.md`). 원문 복붙은 금지.

### §9.2 필수 return 섹션

subagent 가 상위 agent 에게 돌려주는 최소 요약은 아래 5 개 섹션을 포함한다:

1. **Verdict** — PASS / FAIL / PARTIAL / UNKNOWN / N/A 중 하나.
2. **Top Findings** — 최대 5 개 bullet. 각 bullet 은 1 문장 + file:line 또는 path pointer.
3. **Counter-example 시도** — "이 결론이 깨질 수 있는 조건은 무엇인가" 를 1 줄로 서술.
   PASS 선언 시 특히 필수.
4. **Recommended Next Step** — 상위 agent 가 즉시 수행할 수 있는 구체 지시 1 개.
   "검토 필요" 수준은 금지. 예: "change-planner 재호출" / "VERIFY 명령 추가 실행" /
   "해당 없음 (DONE)".
5. **Pointers** — 더 읽을 파일 경로 목록. 상위 agent 가 필요할 때만 open 하도록 lazy loading
   을 유도한다.
6. **Trace Pointer** (선택) — `.ai/traces/<taskId>.jsonl` 경로. 상위 agent 가 도구 호출 이력을 확인할 때 사용.

### §9.3 escape 경로 (하한 미달 / 상한 초과)

- **정보 부족**: 판정에 필요한 근거가 없으면 `Verdict: UNKNOWN` + `Recommended Next Step`
   에 "보강 필요: <무엇>" 기록. 추측으로 PASS/FAIL 을 쓰지 않는다.
- **4k 초과**: subagent 가 자체적으로 detail 을 `.ai/reports/<taskId>/<sub>.md` 에 분리
   저장하고 return 은 4k 이하 요약 + 해당 파일 pointer. 상위 agent 는 필요할 때만 그 파일을
   연다.
- **Generator 가 Evaluator 를 겸하지 않기**: implementer 가 return 으로 "문제 없음" 을
   선언해도 상위 agent 는 별도 Evaluator (verifier/reviewer) 의 독립 return 을 받을 때까지
   PASS 로 간주하지 않는다.

### §9.4 상위 agent 흡수 규칙

- return 의 **Verdict 와 Top Findings 만** 상위 context 에 즉시 올린다.
- Pointers 는 필요할 때만 열어 context 에 올린다 (just-in-time).
- counter-example 섹션이 비어 있으면 Evaluator return 으로 간주하지 않는다.
- 4k 요약을 신뢰할 수 없다고 판단되면 동일 subagent 를 재호출하지 말고 다른 관점의
  Evaluator 를 호출한다 (self-cite 루프 방지).

관련: `.claude/rules/routing-and-delegation.md` "Planner / Generator / Evaluator 경계",
`.claude/agents/active/reviewer.md` "Skeptic Evaluator Tuning".

---

## §10 제외 경로 (collect 시)

다음 경로는 collect에서 제외한다:
- `build/`, `**/build/`
- `.gradle/`, `**/.gradle/`
- `generated/`, `**/generated/`
- `.git/`
- `app/build/`
- `captures/`

---

## §11 본 SoT 의 변경 정책

- cli infra 권장 byte-identical (= 6-repo · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable + gently-product-docs · 보호 5 file 외)
- 변경 시 master cycle 신설 + 6-repo propagation (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## §12 명시 cycle 이력

- (직전) C2-RULES-RESTRUCTURE-001 (2026-05-02) · `evidence-and-reporting.md` (438 line) → `report-paths.md` (line 1~70) + `report-formats.md` (line 71~end) 분리 신설
- 2026-05-21 · MASTER-CLI-CLEANUP-7CYCLE-001 · 본 file 신설 (= `report-paths.md` + `report-formats.md` 2 file 본문 통합 default · 본질 변경 X · 단일 SoT 정합 default) + 2 file 삭제 + 9 file 인용 갱신 + 5-repo byte-identical propagation
- 2026-05-22 · MASTER-CLI-CYCLE-2A-ANCHOR-LIST-HOT-INSTALL-001 · §13 Negative Space Line append default (= anchor list paradigm 정합 default)

---

## §13 Negative Space Line (= 2026-05-22 신설 default · `MASTER-CLI-CYCLE-2A-ANCHOR-LIST-HOT-INSTALL-001`)

매 cycle 보고 끝 1 줄 "고려했으나 hot 제외 영역: <영역 default>" 의무 default. 본 line = anchor list 진화 signal default (= 사용자 본심 정합 default). 비어 있는 영역 = "(없음)" 명시 default. 발행 영역 = REVIEW.md 본문 끝 + paste-back 본문 끝 default. 본문 단일 SoT = [`anchor-list.md §4`](./anchor-list.md) (= 10 anchor hot default · P0 6 + P1 4 default).
