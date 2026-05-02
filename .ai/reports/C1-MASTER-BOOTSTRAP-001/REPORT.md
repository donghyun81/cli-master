# C1-MASTER-BOOTSTRAP-001 · claude-cli-master 신설 baseline

> 작성: 2026-05-02 · scope: master repo 신설 + cli infra + 보호 파일 baseline + .auto-memory + propagation-reports + scripts seed
> 상태: 본문 완료 · git initial commit 만 Coin 손 작업 1줄 분리 (sandbox mount 권한)

---

## 0. 거시 목적

부모 패키지 (`AndroidStudioProjects/`) 에 새 SoT repo (`claude-cli-master/`) 신설. 자식 repo (GB/GD/GT) 는 master 에서 단방향 propagation 받음. 본 cycle = SoT 신설 baseline 박음.

---

## 1. 의사결정 6 건 (사용자 채택)

| # | 결정 | 채택 |
|---|---|---|
| 1 | 정합 구조 | 옵션 A — 새 master repo `claude-cli-master/` |
| 2 | propagation 방향 | 단방향 master → GB/GD/GT |
| 3 | master git 처리 | git init (자식 repo 와 동일 패턴) |
| 4 | MD 파일 분할 깊이 | workflow.md 3분할 + evidence.md 2분할 + agents/active vs deferred (실행 = C2) |
| 5 | 자동화 범위 | 전체 자동화 (script 4종 + slash 1종 · 실행 = C3) |
| 6 | 진행 방식 | 4 sub-cycle 분할 (C1 → C2 → C3 → C4) |

---

## 2. 산출물 inventory

```
claude-cli-master/
├── CLAUDE.md                              # master SoT 헌법 (16 섹션)
├── .gitignore                             # macOS / IDE / local override 차단
├── .claude/
│   ├── settings.json                      # 권한 + hook 매핑 (3-repo 동일 baseline)
│   ├── agents/
│   │   ├── active/      (14 파일)         # ACTIVE 13 + domain-roles (placeholder 화)
│   │   └── deferred/    (11 파일)         # DEFERRED 11 (활성 시 mv)
│   ├── commands/        (7 파일)          # 슬래시 진입점
│   ├── hooks/           (7 파일)          # 5 byte-identical + GD v2 + GD-only 흡수
│   ├── rules/           (14 파일)         # 11 byte-identical + 3 best-version
│   └── skills/          (5 파일)          # 3 SKILL.md + routing-reference + task.md
├── docs/
│   ├── schemas/ui-spec.schema.json        # 보호 파일 1
│   └── design/pencil-sot-policy.md        # 보호 파일 2
├── .auto-memory/        (4 파일)
│   ├── protected-file-hashes.md           # baseline 4종 sha + cli infra 채택 근거
│   ├── propagation-status.md              # 3-repo 동기 매트릭스
│   ├── incident-log.md                    # 사고 기록 (C1 baseline drift 3건 박힘)
│   └── decision-log.md                    # 결정 7 건 + cycle 진척
├── .ai/reports/C1-MASTER-BOOTSTRAP-001/
│   └── REPORT.md                          # 본 보고서
├── propagation-reports/
│   └── README.md                          # 형식 명세 + cycle ID 규약
└── scripts/
    └── README.md                          # C3 신설 예정 4 script + 1 slash 명세
```

총 75 파일 (64 .claude + 2 docs + 4 .auto-memory + 1 CLAUDE.md + 1 .gitignore + 1 본 REPORT + 2 README seed).

---

## 3. 5 divergent 파일 best-version 채택 근거

| 파일 | 채택 출처 | 근거 |
|---|---|---|
| `agents/active/domain-roles.md` | GB → placeholder `<REPO>-only` | repo-neutral 재사용 / 자식 repo propagation 후 sed 으로 자동 정정 |
| `hooks/pencil-auto-save.sh` | **GD v2** | 자동화 우선 (GD 의 Save As filename 자동화 검증 patterns 정착) |
| `hooks/save-as-result-check.sh` | **GD-only 흡수** | v2 검증 도구 / master 가 통일 = 3-repo 모두 사용 가능 |
| `rules/deferred-domains.md` | **GT (UNKNOWN baseline)** | 자식 repo fresh state 정합 (GB ACTIVE drift 폐기) |
| `rules/routing-and-delegation.md` | **GB+GD ([DEFERRED] 명시)** | 명시 정합 의도 강함 |
| `rules/ui-ux-analysis.md` | **GT ("필수" 강화)** | Pencil → Compose 본 작업 정합 patterns |

---

## 4. 보호 파일 4 종 sha 검증 (PASS)

```
MATCH       master=bba7745ef7c4  source(GB)=bba7745ef7c4  docs/schemas/ui-spec.schema.json
MATCH       master=af8e7e26a782  source(GB)=af8e7e26a782  .claude/rules/pencil-uiux-workflow.md
MATCH       master=1f97ac1f1c7a  source(GB)=1f97ac1f1c7a  docs/design/pencil-sot-policy.md
MATCH       master=487d57a2759a  source(GB)=487d57a2759a  .claude/rules/uiux-sot-refresh.md
```

3-repo (GB/GD/GT) 도 모두 동일 sha 검증 PASS (CLI-GUIDE-001 보고서 §9.2 참조).

---

## 5. 자식 repo HEAD baseline (참조용)

| repo | HEAD sha | branch |
|---|---|---|
| GentlyBreath | 80bd867 | master |
| GentlyDay | 622102a | master |
| GentlyTable | d2c29f6 | master |

Memory 의 baseline (GD 3c198b0 / GT ea0f925) 보다 진척한 상태. 본 작업 무관 (자식 repo 의 별도 cycle 진행).

---

## 6. 사고 기록 (C1 중 발견 + incident-log.md 박음)

1. **GB drift** — `deferred-domains.md` 가 SteadyWell propagation 잔존으로 ACTIVE 표기 (CLAUDE.md "현재 미정의" 와 불일치). master 가 GT UNKNOWN baseline 채택 → C4 propagation 시 GB 통일.
2. **GT drift** — `routing-and-delegation.md` 가 `[DEFERRED]` 라벨 미부착 (GB/GD 와 불일치). master 가 GB+GD `[DEFERRED]` 명시 채택 → C4 propagation 시 GT 통일.
3. **정책 충돌** — 자식 repo 가 cli infra 직접 수정 가능 → master SoT 위반 위험. master CLAUDE.md §0/§3/§4 박음으로 mitigation.
4. **sandbox git index.lock 권한 한계** — `.git/index.lock` 제거 불가 → C1-5 git commit 만 Coin 손 작업 1줄 분리 (별 trail).

---

## 7. C1-5 별 trail (Coin 손 작업 1줄)

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
rm -f .git/index.lock && \
git commit -m "$(cat <<'COMMIT'
chore(master): C1-MASTER-BOOTSTRAP-001 claude-cli-master 신설 baseline

[Goal] claude-cli-master = cli infra + 보호 파일 SoT 신설 (단방향 propagation source)
[Diff] .claude/ 59 + docs/ 2 + .auto-memory/ 4 + CLAUDE.md + .gitignore + propagation-reports/scripts seed = 69 files
[Sha]  보호 파일 4종 (3-repo 동일 baseline 채택):
       bba7745e ui-spec.schema.json
       af8e7e26 pencil-uiux-workflow.md
       1f97ac1f pencil-sot-policy.md
       487d57a2 uiux-sot-refresh.md
[EC]   보호 파일 4종 sha = 3-repo 동일 PASS · 5 divergent 파일 best-version 채택
[Next] C2-RULES-RESTRUCTURE-001 진입 (workflow.md 3분할 + evidence.md 2분할)
[Refs] task: C1-MASTER-BOOTSTRAP-001 · 자식 repo HEAD: GB 80bd867 · GD 622102a · GT d2c29f6
COMMIT
)"
```

실행 후 `git log -1 --oneline` 확인 → 본 보고서 §10 갱신.

---

## 8. 다음 cycle (C2~C4) 진입 조건

### C2-RULES-RESTRUCTURE-001
- **scope**: master 의 `.claude/rules/workflow.md` 3 분할 (`workflow-core.md` / `cycle-discipline.md` / `pencil-automation.md`) + `.claude/rules/evidence-and-reporting.md` 2 분할 (`report-paths.md` / `report-formats.md`) + `.claude/agents/active` vs `deferred` 폴더 정착 (이미 C1 에서 분리 · C2 는 routing-and-delegation.md 의 참조 path 갱신 + DEFERRED rule pointer 4 종 정리)
- **진입 조건**: C1-5 git commit 완료 + master HEAD baseline 박힘
- **산출물**: 새 rules 16~17개 + 갱신된 routing-and-delegation.md + decision-log §C2 entry

### C3-AUTOMATION-SCRIPTS-001
- **scope**: 4 script (`propagate.sh` · `verify-sync.sh` · `report-gen.sh` · `activate-agent.sh`) + 1 slash command (`cycle-report.md`) 신설 + `propagation-reports/README.md` 의 형식 자동 생성 검증
- **진입 조건**: C2 마감 + master rules 새 구조 baseline 박힘
- **산출물**: 4 실행 가능 .sh + 1 slash + 자동화 검증 (실 실행 sample)

### C4-PROPAGATE-TO-CHILDREN-001
- **scope**: master → GB / GD / GT 단방향 propagation + cross-verify (모든 sha ✓ MATCH 확인) + 자식 repo 의 CLAUDE.md 갱신 (master 의존 명시 + 자식 repo cli infra 직접 수정 금지 박음)
- **진입 조건**: C3 마감 + script 4종 검증 PASS
- **산출물**: 3 자식 repo 의 sha 모두 master 일치 + `propagation-reports/C4-...-PROPAGATE/REPORT.md`

---

## 9. ROI 평가

| 항목 | C1 비용 | 효과 | break-even |
|---|---|---|---|
| master 신설 | 1 cycle | 정합 SoT + 추후 자식 repo 확장 단순 | C2 마감 시점 (cli infra 변경 1회 발생 시) |
| 5 divergent 정정 | 1 cycle 안에 흡수 | 3-repo 향후 모든 cli infra 변경의 mismatch 사고 0 | 즉시 |
| .auto-memory 신설 | 1 cycle 안에 흡수 | 매 cycle 의 사고 기록 자동 누적 + propagation status 명확 | 즉시 |
| C2~C4 예정 | 3 cycle | 자동화 완성 + 자식 repo 통일 | C4 마감 시점 (모든 향후 cli 변경의 cp 비용 0) |

---

## 10. 본 cycle 마감 신호

- ✓ `claude-cli-master/` 디렉터리 생성
- ✓ 53 byte-identical cli infra cp + 5 divergent best-version 채택 + 1 GD-only 흡수 = 59 .claude 파일
- ✓ 보호 파일 2 종 cp (rules 안 2 종은 cli infra 와 함께 cp)
- ✓ `CLAUDE.md` (master SoT) 작성
- ✓ `.auto-memory/` 4 파일 (protected-file-hashes / propagation-status / incident-log / decision-log)
- ✓ `propagation-reports/README.md` + `scripts/README.md` seed
- ✓ `.gitignore` 작성
- ✓ git init + 69 staged
- ⏳ git commit (C1-5 별 trail · Coin 손 작업 1줄)
- ✓ 본 REPORT.md (C1-6) 작성

C1-5 완료 후 C2 진입 권장.

---

`Sources:`
- [CLAUDE.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/CLAUDE.md)
- [.claude/settings.json](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/settings.json)
- [.auto-memory/protected-file-hashes.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.auto-memory/protected-file-hashes.md)
- [.auto-memory/propagation-status.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.auto-memory/propagation-status.md)
- [.auto-memory/decision-log.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.auto-memory/decision-log.md)
- [scripts/README.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/scripts/README.md)
- [propagation-reports/README.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/propagation-reports/README.md)
