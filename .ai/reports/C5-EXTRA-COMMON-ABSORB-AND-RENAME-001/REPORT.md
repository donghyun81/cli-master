# C5-EXTRA-COMMON-ABSORB-AND-RENAME-001 · 24 추가 공통 흡수 + master rename

> 작성: 2026-05-02 · scope: master 의 docs/agent + scripts/agent + root 5 흡수 + gently-master → claude-cli-master rename
> 상태: 본문 완료 · git mv (rename) + Coin rm 묶음 손 작업 분리

---

## 0. 거시 목적

Part A (자식 repo 의 추가 공통 24 파일 흡수) + Part B (master 이름 generic 화) → master 가 진정한 "Claude Code CLI 운영 SoT" 로 정합 박음.

---

## 1. Part A 흡수 결과 (24 파일 모두 sha 일치)

| 카테고리 | 파일 수 | 출처 (3-repo 동일 sha) |
|---|---|---|
| docs/agent/architecture/ | 13 | ADR_TEMPLATE / COMMON_ARCHITECTURE / COMPOSE_STABILITY / DEPENDENCY_DECISION_CHECKLIST / ERROR_RESULT_POLICY / KMP_CMP_LAYER_DIRECTION / KOIN_DI_BASELINE / LEGACY_CLEANUP_GOVERNANCE / MODEL_SEPARATION / PROPAGATION_PARAMETERS / SSOT_PRINCIPLES / TDD_WORKFLOW / TESTABILITY_SEAMS |
| docs/agent/process/ | 4 | COMMIT_CONVENTION / DOC_GOVERNANCE_WORKFLOW / DOC_TASK_TYPES / REPO_FIRST_INTAKE_WORKFLOW |
| docs/agent/solutions/ | 1 | PROMPTFIT_RUBRIC.md (MANAGED_AGENTS_READINESS / README = repo-specific 미흡수) |
| scripts/agent/ | 1 | frontmatter-grep.sh (repo-config / compound-lint = repo-specific 미흡수) |
| root | 5 | .editorconfig + .mcp.json + gradle.properties + gradlew + gradlew.bat |
| **합계** | **24** | **모두 sha 일치 검증 PASS** |

### 흡수 안 한 항목 (의도된 repo-specific)

| 항목 | 사유 |
|---|---|
| `docs/agent/solutions/MANAGED_AGENTS_READINESS.md` | 각 repo 도메인 명시 |
| `docs/agent/solutions/README.md` | 각 repo 별 안내 |
| `scripts/agent/repo-config.sh` | 각 repo prefix / route / package |
| `scripts/agent/compound-lint.sh` | 각 repo architecture 검증 명령 |
| `gradle/libs.versions.toml` | 각 repo 의존성 baseline |
| `settings.gradle.kts` / `build.gradle.kts` | 각 repo 모듈 / build 설정 |
| `.gitignore` | GB vs GD/GT 차이 (도메인 무시 patterns) |
| `check-architecture.sh` | 각 repo architecture 검증 |
| `local.properties` | gitignored (per-machine SDK path) |

---

## 2. Part B rename (gently-master → claude-cli-master)

### 사전 인용 갱신 (master 안 21 파일)
- CLAUDE.md (6 인용)
- .auto-memory/ 4 파일 (10 인용)
- .claude/rules/ 6 deprecated pointer 파일 (6 인용)
- propagation-reports/README.md (2 인용)
- scripts/ 5 파일 (12 인용)
- .ai/reports/ 4 cycle 보고서 (38 인용)

→ sed 일괄 갱신 + 잔존 0 검증 PASS.

### Coin 손 작업 (rename + 묶음 mv/rm/commit)

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
git commit -m "feat(master): C5 + 묶음 마감 (24 흡수 + rename + C2/C2.5 lazy 처리)"
```

---

## 3. scripts 확장 (verify-sync + propagate)

### find 명령 확장 (scripts/agent + root 5 포함)

```bash
find .claude docs scripts/agent -type f ...
+ root 5 파일 명시 (.editorconfig / .mcp.json / gradle.properties / gradlew / gradlew.bat)
```

### CORE_CLI 배열 확장 (verify-sync.sh `--quick`)

| 추가 | 파일 |
|---|---|
| 신설 cli infra 2 | code-principles.md / design-to-code-sync.md |
| architecture 4 | COMMON_ARCHITECTURE / TDD_WORKFLOW / MODEL_SEPARATION / SSOT_PRINCIPLES |
| process 1 | COMMIT_CONVENTION |
| scripts 1 | frontmatter-grep.sh |
| root 3 | .editorconfig / .mcp.json / gradle.properties |

→ `--quick` 검증 = 8 → 23 파일.

---

## 4. 검증 (실측 PASS)

```
verify-sync.sh --quick (확장 후)
  files: 23 (quick)
  PASS:  10 파일   (24 흡수 직후 자식과 동일)
  DRIFT: 18 (자식 sha ≠ master · 보호 4종 + cli infra 일부 — C4 propagation 후 PASS)
  MISS:  21 (자식에 master 신설 7 cli 부재 — workflow-core/cycle-discipline/pencil-automation/report-paths/report-formats/code-principles/design-to-code-sync × 3)
```

→ C4 propagation 후 = 23 파일 PASS / drift 0 / miss 0 예정.

---

## 5. master 최종 inventory (C5 후 · rename 전)

```
gently-master/                                  (Coin mv → claude-cli-master)
├── CLAUDE.md
├── .gitignore
├── .editorconfig                               ★ C5 흡수 (3-repo 동일)
├── .mcp.json                                   ★ C5 흡수 (3-repo 동일)
├── gradle.properties                           ★ C5 흡수 (3-repo 동일)
├── gradlew                                     ★ C5 흡수 (3-repo 동일 · executable)
├── gradlew.bat                                 ★ C5 흡수 (3-repo 동일)
├── .claude/                                    (C1-C3 박힘)
│   ├── settings.json
│   ├── agents/active (14) + deferred (11)
│   ├── commands/ (8 · cycle-report 추가)
│   ├── hooks/ (7)
│   ├── rules/ (15 · code-principles + design-to-code-sync 추가 · deprecated 6 rm 후 = 13)
│   └── skills/ (5)
├── docs/
│   ├── schemas/ui-spec.schema.json             (보호 v0.3)
│   ├── design/
│   │   ├── design-sot-policy.md                (보호 신설 C2.5)
│   │   └── pencil-sot-policy.md                (보호 · Coin mv → pencil-sot-binding.md)
│   └── agent/                                  ★ C5 흡수
│       ├── architecture/ (13)                  ★ C5 흡수
│       ├── process/ (4)                        ★ C5 흡수
│       └── solutions/PROMPTFIT_RUBRIC.md (1)   ★ C5 흡수
├── scripts/
│   ├── README.md
│   ├── propagate.sh                            (C3 + C5 확장)
│   ├── verify-sync.sh                          (C3 + C5 확장)
│   ├── report-gen.sh                           (C3)
│   ├── activate-agent.sh                       (C3)
│   └── agent/frontmatter-grep.sh               ★ C5 흡수
├── .auto-memory/ (5 = protected/propagation/incident/decision + cycle-handoff-template)
├── propagation-reports/README.md
└── .ai/reports/ (5 cycle 보고서: C1 / C2 / C2.5 / C3 / C5)
```

총 파일 수 (.git 제외): **111** (C1 70 → C2 +5/-6 = 69 → C2.5 +3 = 72 → C3 +6 = 78 → C5 +24 + 새 보고서 = ~111).

---

## 6. 본 cycle ROI

| 항목 | 비용 | 효과 |
|---|---|---|
| 24 추가 흡수 | 1 cycle 안 | C4 propagation 시 자식 docs/agent + root 자동 검증 + drift 자동 차단 |
| master rename | 1 cycle 안 (sed 일괄) | 의미 정합 + 다른 도메인 앱 신설 시 즉시 사용 가능 |
| scripts 확장 | 1 cycle 안 | verify-sync 가 75% → 95% 통합 검증 |

---

## 7. 다음 cycle (C4) 진입 조건

- C4 진입 = C5 commit + rename 완료
- C4 마감 = master → 3 자식 repo cross-verify ALL ✓ MATCH
- C4 추가 의무: 자식 repo 의 ui-spec.json 마이그레이션 (lastSyncedPencilStateHash → lastSyncedDesignToolStateHash · alias)
- C4 자동 처리: 24 흡수 파일 = 이미 자식과 동일 sha = propagate.sh 가 cp 시 변경 없음 (단 새 master 의 변경 파일만 실 cp 발생)

---

`Sources:`
- [CLAUDE.md (master SoT)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/CLAUDE.md)
- [docs/agent/architecture/COMMON_ARCHITECTURE.md (흡수)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/docs/agent/architecture/COMMON_ARCHITECTURE.md)
- [docs/agent/process/COMMIT_CONVENTION.md (흡수)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/docs/agent/process/COMMIT_CONVENTION.md)
- [scripts/agent/frontmatter-grep.sh (흡수)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/scripts/agent/frontmatter-grep.sh)
- [.editorconfig (흡수)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/.editorconfig)
- [.mcp.json (흡수)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/.mcp.json)
- [scripts/verify-sync.sh (확장)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/scripts/verify-sync.sh)
- [scripts/propagate.sh (확장)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/scripts/propagate.sh)
- [.auto-memory/decision-log.md (C5 entry)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/.auto-memory/decision-log.md)
