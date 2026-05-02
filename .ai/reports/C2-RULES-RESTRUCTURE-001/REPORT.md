# C2-RULES-RESTRUCTURE-001 · rules 5 분할 + 6 deprecated + cross-reference 정정

> 작성: 2026-05-02 · scope: master 의 `.claude/rules/` + `CLAUDE.md` + `.auto-memory/`
> 상태: 본문 완료 · master rm 6 + git commit 만 Coin 손 작업 분리 (sandbox 권한 한계)

---

## 0. 거시 목적

C1 의 master baseline 위에서 cli infra rules 를 **단일 목적 파일** 로 재분류. 진입 1차 가이드의 읽기 비용 ↓.

---

## 1. 신설 5 파일

| 파일 | 줄 수 | 단일 목적 |
|---|---|---|
| `workflow-core.md` | 350 | 단계 흐름 + Context Reset + Intake + /collect + /plan + implement + /verify + /review + COMPOUND/TODO + 완료 조건 |
| `cycle-discipline.md` | 286 | Cycle Discipline §1~11 (거시 목표 / 정합 강제 / repo 규약 / commit 표준 / 자기 검증 / 보호 파일 변경 의무) + §13 (환경 정합) + §14 (Phase C IMPL 흐름) + §14a (Cowork ↔ CLI 동기화) |
| `pencil-automation.md` | 64 | Pencil .pen 저장 자동화 (신규/기존 분기 + agent 직접 호출 patterns) |
| `report-paths.md` | 79 | 산출물 경로 규약 + stdout 출력 순서 + Task 문서 형식 (Meta / 원문 / 분해된 문제 / 성공 조건 / EC / 비기능 / UNKNOWN) |
| `report-formats.md` | 380 | EVIDENCE / PLAN (10-section) / VERIFY / REVIEW (12-section) + 근거 기록 기준 + Subagent Return Contract + 제외 경로 |

---

## 2. deprecated 6 파일 (sandbox rm 권한 한계 → pointer-only 변환)

| 파일 | 분할/통합 위치 | rm 의무 |
|---|---|---|
| `workflow.md` (662 줄) | → `workflow-core.md` + `cycle-discipline.md` + `pencil-automation.md` | Coin 손 작업 |
| `evidence-and-reporting.md` (438 줄) | → `report-paths.md` + `report-formats.md` | Coin 손 작업 |
| `auth-security-privacy.md` (3 줄) | → `deferred-domains.md` §1 통합 | Coin 손 작업 |
| `backend-and-api.md` (3 줄) | → `deferred-domains.md` §1 통합 | Coin 손 작업 |
| `data-and-migrations.md` (3 줄) | → `deferred-domains.md` §1 통합 | Coin 손 작업 |
| `performance-reliability.md` (3 줄) | → `deferred-domains.md` §1 통합 | Coin 손 작업 |

각 파일에 deprecation note + 새 위치 매핑 표 + Coin rm 명령 박힘.

---

## 3. cross-reference 정정 5 파일

| 파일 | 변경 내용 |
|---|---|
| `routing-and-delegation.md` | agent path → `.claude/agents/active/<name>.md` 또는 `.claude/agents/deferred/<name>.md` (24 행) + "역할 정의: `.claude/agents/{active,deferred}/`" + 새 agent 추가 절차 갱신 |
| `legacy-cleanup-governance.md` | `workflow.md` → `workflow-core.md` + `cycle-discipline.md` 인용 / `evidence-and-reporting.md` → `report-formats.md` 인용 |
| `ui-ux-analysis.md` | `workflow.md` SoftBudget → `workflow-core.md` SoftBudget / DependencyDecision 인용 갱신 |
| `verification-and-review.md` | 관련 파일 인용 갱신 (`workflow.md` → `workflow-core.md` + `cycle-discipline.md` / `evidence-and-reporting.md` → `report-formats.md`) |
| `deferred-domains.md` | **본 cycle 핵심**: 4 pointer rule 통합 + Billing 신설 + 5 영역 통합 STOP + 활성화 trigger 키워드 표 신설 + 3-repo 매트릭스 신설 + 도메인 활성화 절차 6 단계 박음 |

---

## 4. CLAUDE.md 갱신

- §2: "(workflow.md §Cycle Discipline §3 박힘)" → "(`cycle-discipline.md` §3 박힘)"
- §6 / §10 / §11: rule path 인용 갱신 (workflow.md → 3 분할 / evidence.md → 2 분할)
- §15: C2 cycle entry 추가 ("rules 5 분할 + DEFERRED 4 통합 + agents/active·deferred 폴더 routing 갱신")
- §15 후속: "다음 cycle 후보" 에서 C2 행 제거 (마감 처리)
- Sources 섹션: workflow.md 링크 → workflow-core.md + cycle-discipline.md

---

## 5. .auto-memory 갱신

- `protected-file-hashes.md`: cli infra 변동 박음 (5 신설 / 6 deprecated / 5 갱신) + 보호 파일 4종 sha **변동 0** 명시
- `decision-log.md`: C2 결정 2 건 + 산출물 요약 + Coin 손 작업 명령 + 다음 cycle 진입 조건 append
- `propagation-status.md`: 변동 X (C4 propagation 후 갱신 예정)
- `incident-log.md`: 변동 X (C2 사고 0)

---

## 6. 보호 파일 4 종 sha 무변동 검증 (PASS)

```
bba7745ef7c4  docs/schemas/ui-spec.schema.json       (C1 일치)
af8e7e26a782  .claude/rules/pencil-uiux-workflow.md  (C1 일치)
1f97ac1f1c7a  docs/design/pencil-sot-policy.md       (C1 일치)
487d57a2759a  .claude/rules/uiux-sot-refresh.md      (C1 일치)
```

C2 = cli infra rules 만 변경. 보호 파일 4 종 = byte-identical 보존.

---

## 7. 잔존 인용 검증 (PASS)

```bash
cd claude-cli-master && grep -rn 'workflow\.md\|evidence-and-reporting\.md' .claude/rules/ \
  | grep -v '^.claude/rules/workflow\.md\|^.claude/rules/evidence-and-reporting\.md\|^.claude/rules/pencil-uiux-workflow\.md\|workflow-core\|pencil-automation\|report-paths\|report-formats'
```

→ 출력 비어 있음 (보호 파일 + deprecated pointer 자기 인용 외 잔존 0).

> **단 보호 파일 `pencil-uiux-workflow.md` 안의 `workflow.md §12 / §6 §7 / §13 / §14` 인용은 의도 보존** (보호 파일 = sha 변경 금지). deprecated `workflow.md` pointer 가 redirect 역할 담당.

---

## 8. Coin 손 작업 (C2 sandbox 권한 한계)

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

---

## 9. 마감 후 rules inventory (예정 = 13 파일)

```
.claude/rules/
├── cycle-discipline.md          (286)  신설 C2
├── deferred-domains.md          (93)   강화 C2
├── legacy-cleanup-governance.md (201)  갱신 C2
├── pencil-automation.md         (64)   신설 C2
├── pencil-uiux-workflow.md      (446)  보호 (변동 X)
├── report-formats.md            (380)  신설 C2
├── report-paths.md              (79)   신설 C2
├── routing-and-delegation.md    (239)  갱신 C2 (path)
├── safety-and-secrets.md        (140)  변동 X
├── ui-ux-analysis.md            (115)  갱신 C2
├── uiux-sot-refresh.md          (98)   보호 (변동 X)
├── verification-and-review.md   (132)  갱신 C2
└── workflow-core.md             (350)  신설 C2
```

기존 14 → 13 (4 deprecated rm + 5 신설 = +1 / 6 deprecated rm + 5 신설 = -1).

---

## 10. 다음 cycle 진입 조건

### C3-AUTOMATION-SCRIPTS-001
- **scope**: `scripts/propagate.sh` + `verify-sync.sh` + `report-gen.sh` + `activate-agent.sh` + `.claude/commands/cycle-report.md` 신설 + 실 실행 검증 sample
- **진입 조건**: C2 Coin rm + commit 완료
- **산출물**: 4 실행 가능 .sh + 1 slash + 자동화 검증

### C4-PROPAGATE-TO-CHILDREN-001
- **scope**: master → GB / GD / GT 단방향 propagation + cross-verify (모든 sha ✓ MATCH 확인) + 자식 repo 의 CLAUDE.md 갱신 (master 의존 명시 + cli infra 직접 수정 금지 박음) + 본 C2 의 rules 새 구조도 자식 repo 에 적용
- **진입 조건**: C3 마감 + script 4종 검증 PASS
- **산출물**: 3 자식 repo 의 sha 모두 master 일치 + `propagation-reports/C4-...-PROPAGATE/REPORT.md`

---

`Sources:`
- [CLAUDE.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/CLAUDE.md)
- [.claude/rules/workflow-core.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/rules/workflow-core.md)
- [.claude/rules/cycle-discipline.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/rules/cycle-discipline.md)
- [.claude/rules/pencil-automation.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/rules/pencil-automation.md)
- [.claude/rules/report-paths.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/rules/report-paths.md)
- [.claude/rules/report-formats.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/rules/report-formats.md)
- [.claude/rules/deferred-domains.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/rules/deferred-domains.md)
- [.auto-memory/protected-file-hashes.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.auto-memory/protected-file-hashes.md)
- [.auto-memory/decision-log.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.auto-memory/decision-log.md)
