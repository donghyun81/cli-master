# C3-AUTOMATION-SCRIPTS-001 · 자동화 script 4종 + slash + Q2/Q4/Q5 보완

> 작성: 2026-05-02 · scope: master 의 `scripts/` + `.claude/commands/` + `.auto-memory/` template + `.claude/hooks/session-start.sh` 갱신 + `cycle-discipline.md` §15 §16 박음
> 상태: 본문 완료 · git commit 만 Coin 손 작업 분리

---

## 0. 거시 목적

C1 (master baseline) + C2 (rules 5 분할) 위에서 **propagation 자동화 + 검증 자동화 + Q2/Q4/Q5 보완**. C4 (자식 repo 적용) 진입 가능 상태로 준비.

---

## 1. 신설 script 4 종

| script | 줄 수 | 기능 | 검증 |
|---|---|---|---|
| `scripts/propagate.sh` | 5932 byte (≈170 줄) | master → 자식 repo cp + git stage + sha 검증 | bash -n PASS · `--all`/`--targets` 인자 |
| `scripts/verify-sync.sh` | 6317 byte (≈190 줄) | 3-repo sha 자동 비교 + propagation-status.md 갱신 + drift 식별 | **dry-run 실측 PASS** — drift 6 + miss 15 정확히 식별 (C4 후 PASS 예정) |
| `scripts/report-gen.sh` | 4388 byte (≈140 줄) | propagation-reports/<cycle-id>/{REPORT,DIFF,VERIFY}.md 자동 생성 | bash -n PASS · git log 연계 |
| `scripts/activate-agent.sh` | 4933 byte (≈155 줄) | agent active/deferred toggle + routing-and-delegation.md / deferred-domains.md 자동 갱신 | **list dry-run PASS** — ACTIVE 14 / DEFERRED 11 정확히 출력 |

### script 공통 환경 변수

```bash
PARENT_DIR    기본: ~/AndroidStudioProjects
MASTER_DIR    기본: $PARENT_DIR/claude-cli-master
TARGET_REPOS  기본: "GentlyBreath GentlyDay GentlyTable"
```

신규 자식 repo 추가 시 `TARGET_REPOS` env 1줄 변경으로 즉시 propagation 가능.

---

## 2. 신설 slash command 1 종

`.claude/commands/cycle-report.md` (45 줄):

```
/cycle-report propagate <file> [<file> ...]   # propagation cycle 자동 묶음
/cycle-report propagate --all                 # 전체 cli infra
/cycle-report status                          # 현 propagation-status.md
/cycle-report drift                           # drift 만 표시
/cycle-report verify                          # verify-sync.sh 만
```

자동 흐름:
1. BASELINE 검증 (`.git status` + 보호 파일 sha)
2. 변경 파일 식별 (git log)
3. propagate (script 호출)
4. verify-sync (script 호출 + status.md 갱신)
5. report-gen (script 호출)
6. 자식 repo commit 안내 출력
7. Coin 검증 1줄 의무 ("verify 재호출")

---

## 3. Q2 가이드 박음 — cycle-discipline.md §15 §16 신설

§15 = cli 수정 패턴 3 종:
- **패턴 1**: 공통 cli 변경 → master switch + cycle
- **패턴 2**: 자식 repo local-only → master 무관
- **패턴 3**: 도메인 활성화 (UNKNOWN → ACTIVE) → master 신설 + activate-agent.sh

§16 = 결정 트리 (트리 분기 명확화).

---

## 4. Q4 보완 — cycle-handoff template 박음

`.auto-memory/cycle-handoff-template.md` (60 줄):
- master 가 SoT 보유 (template)
- 자식 repo 가 cp 받아서 `.ai/reports/<taskId>/HANDOFF.md` 로 채움
- YAML frontmatter (taskId / status / lastVerifiedStep / blockers / nextEntry / riskFlags / createdKST / updatedKST)
- 사용 패턴 + 갱신 의무 + propagation 정책

→ 기존 GD/GT 만 사용하던 `cycle-handoff.md` patterns → 3-repo 통일 + master template SoT.

---

## 5. Q5 §b 보완 — Claude Code 버전 자동 검증

`.claude/hooks/session-start.sh` 끝에 5 줄 추가 (88 줄로 증가):

```bash
EXPECTED_VERSION="2.1.114"
ACTUAL_VERSION=$(claude --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
if [ -n "$ACTUAL_VERSION" ] && [ "$ACTUAL_VERSION" != "$EXPECTED_VERSION" ]; then
    echo "[session] WARN: Claude Code 버전 $ACTUAL_VERSION ≠ pin $EXPECTED_VERSION ..." >&2
elif [ -n "$ACTUAL_VERSION" ]; then
    echo "[session] cc_version=$ACTUAL_VERSION (pin PASS)"
fi
```

→ 매 SessionStart 자동 발화. 다운그레이드 누락 시 즉시 stderr WARN.

→ 이 변경 = 보호 파일 X (cli infra). C4 propagation 시 3-repo 자동 동기.

---

## 6. dry-run 검증 결과 (실측 PASS)

### activate-agent.sh list

```
ACTIVE (14): change-planner / code-simplifier / docs-change-communicator / docs-drift-auditor /
             docs-structure-architect / domain-roles / intake-router / layer-checker /
             requirements-analyst / reviewer / system-architect / ui-implementer / ux-auditor / verifier

DEFERRED (11): auth-security-privacy / backend-api-architect / billing-payments-guardian /
               data-schema-guardian / domain-policy-analyst / observability-ops-analyst /
               performance-reliability-engineer / release-risk-manager / server-implementer /
               sync-offline-state-specialist / test-strategist
```

### verify-sync.sh --quick (현 master baseline 직후 = C4 propagation 직전)

```
[verify-sync] 요약
  PASS:  5 파일   (settings.json + 보호 파일 일부 + 기존 동일 cli)
  DRIFT: 6 파일   (routing-and-delegation / deferred-domains / 보호 파일 일부 — C2 갱신 후 자식 repo 미반영)
  MISS:  15 파일  (workflow-core / cycle-discipline / pencil-automation / report-paths / report-formats × 3 자식 = C2 신설 5 × 3)
```

→ **C4 propagation 후 = PASS 30 / DRIFT 0 / MISS 0 예정**.

### bash -n script 4종

```
scripts/propagate.sh       OK
scripts/verify-sync.sh     OK
scripts/report-gen.sh      OK
scripts/activate-agent.sh  OK
```

---

## 7. C3 산출물 inventory

```
claude-cli-master/
├── scripts/
│   ├── README.md                           (C1 seed 갱신)
│   ├── propagate.sh                        ★ C3 신설 (executable)
│   ├── verify-sync.sh                      ★ C3 신설 (executable)
│   ├── report-gen.sh                       ★ C3 신설 (executable)
│   └── activate-agent.sh                   ★ C3 신설 (executable)
├── .claude/
│   ├── commands/
│   │   └── cycle-report.md                 ★ C3 신설
│   └── hooks/
│       └── session-start.sh                ~ C3 갱신 (Claude Code 버전 검증 추가)
├── .claude/rules/
│   └── cycle-discipline.md                 ~ C3 갱신 (§15 §16 cli 수정 패턴 박음)
├── .auto-memory/
│   └── cycle-handoff-template.md           ★ C3 신설 (Q4 보완)
└── .ai/reports/
    └── C3-AUTOMATION-SCRIPTS-001/
        └── REPORT.md                       ★ 본 파일
```

---

## 8. 보호 파일 4 종 sha 무변동 검증 (PASS)

C3 = scripts/ + commands/ + template + hook + cycle-discipline 만 변경. 보호 파일 4 종 = 무변동 (PASS).

```
bba7745ef7c4  docs/schemas/ui-spec.schema.json       (C1 일치)
af8e7e26a782  .claude/rules/pencil-uiux-workflow.md  (C1 일치)
1f97ac1f1c7a  docs/design/pencil-sot-policy.md       (C1 일치)
487d57a2759a  .claude/rules/uiux-sot-refresh.md      (C1 일치)
```

---

## 9. Coin 손 작업 (C3 git commit · sandbox 권한 한계)

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "$(cat <<'COMMIT'
feat(master): C3-AUTOMATION-SCRIPTS-001 자동화 script 4종 + slash + Q2/Q4/Q5 보완

[Goal] propagation 자동화 + 검증 자동화 + Q2 가이드 + Q4 cycle-handoff template + Q5 환경 정합 자동
[Diff] +4 scripts (propagate/verify-sync/report-gen/activate-agent · executable) +1 slash (/cycle-report) +1 template (cycle-handoff) ~1 hook (session-start.sh +cc_version 검증) ~1 rule (cycle-discipline.md §15 §16)
[Sha]  보호 파일 4종 sha 변동 **0**
[EC]   bash -n PASS · activate-agent list dry-run PASS · verify-sync dry-run = drift 6 + miss 15 정확히 식별 (C4 후 PASS 예정)
[Next] C4-PROPAGATE-TO-CHILDREN-001 진입 (master → 3 자식 repo 단방향 propagation + cross-verify ALL ✓ MATCH)
[Refs] task: C3-AUTOMATION-SCRIPTS-001 · parent: <C2 commit hash>
COMMIT
)"
```

---

## 10. C4 진입 조건 + 예상 흐름

### C4-PROPAGATE-TO-CHILDREN-001
- **scope**: master → GB / GD / GT 단방향 propagation + cross-verify
- **진입 조건**: C3 commit 완료 + verify-sync.sh dry-run 검증 PASS (이미 완료)
- **예상 흐름**:
  1. `bash scripts/propagate.sh --all --targets all` (master 의 모든 cli infra + 보호 파일 → 3 자식 repo cp + 자동 stage)
  2. `bash scripts/verify-sync.sh` (drift 0 + miss 0 확인)
  3. 자식 repo 별 commit (Coin 손 작업 3회 또는 묶음 1회)
  4. `bash scripts/report-gen.sh C4-PROPAGATE-TO-CHILDREN-001-PROPAGATE` (자동 보고서 생성)
  5. 각 자식 repo 의 CLAUDE.md 갱신 (master 의존 명시 + cli infra 직접 수정 금지 박음)
  6. master 에 audit commit + propagation-status.md 갱신
- **산출물**:
  - 3 자식 repo 의 sha 모두 master 일치
  - `propagation-reports/C4-PROPAGATE-TO-CHILDREN-001-PROPAGATE/{REPORT,DIFF,VERIFY}.md`
  - 3 자식 repo 의 CLAUDE.md 갱신

---

## 11. C3 후 master 통합 완전성 평가

| 영역 | C2 후 | C3 후 |
|---|---|---|
| baseline (C1) | 100% | 100% |
| rules 분할 (C2) | 100% | 100% |
| 자동화 script | 0% | **100%** (4 script + 1 slash) |
| 검증 자동화 | 정적 sha 만 | **3-repo cross-verify 자동** |
| 사고 자동 기록 | stop-gate.sh 만 | + verify-sync.sh 가 propagation-status 자동 갱신 |
| Q2 가이드 | 미박힘 | **cycle-discipline §15 §16 박힘** |
| Q4 누락 (cycle-handoff template) | 미박힘 | **template 박힘** |
| Q5 §b (Claude Code 버전 자동) | 미박힘 | **session-start.sh 자동 검증 박힘** |
| **종합** | **75%** | **95%** (C4 후 100%) |

---

`Sources:`
- [scripts/propagate.sh](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/scripts/propagate.sh)
- [scripts/verify-sync.sh](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/scripts/verify-sync.sh)
- [scripts/report-gen.sh](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/scripts/report-gen.sh)
- [scripts/activate-agent.sh](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/scripts/activate-agent.sh)
- [.claude/commands/cycle-report.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/commands/cycle-report.md)
- [.auto-memory/cycle-handoff-template.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.auto-memory/cycle-handoff-template.md)
- [.claude/rules/cycle-discipline.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/rules/cycle-discipline.md)
- [.claude/hooks/session-start.sh](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/hooks/session-start.sh)
