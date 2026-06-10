# EVIDENCE — MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001

## §0 Baseline (라이브 재측정 · 진입 시점 = paste §0 표와 전수 일치)

| repo | HEAD | dirty |
|---|---|---|
| claude-cli-master | `d6d3989` | clean |
| app-foundation | `319b7d2` | clean |
| GentlyBreath | `15893cb` | 기존 2 (`.ai/reports/.../TODO.md` M + `package-lock.json` ??) — 무접촉 |
| GentlyDay | `c75f16c` | 기존 1 (`supabase/.temp/cli-latest`) — 무접촉 |
| GentlyTable | `2f9a02b` | 기존 1 (동일) — 무접촉 |
| gently-product-docs | `9465146` | clean |

보호 5 sha-256(8) 진입 = 마감 동일: `8502c014` ui-spec · `e3b9891d` uiux-sot-refresh · `4c566615` design-sot-policy · `2ec100bf` pencil-uiux-workflow · `ae20a79c` pencil-sot-policy.

## 집계 기준 (§8 명시 의무 · 81/107 류 reconcile 재발 방지)

- 패턴 = literal `5-repo` · case-insensitive (`grep -i`) · **행 단위** 집계. 변형 표기 `5 repo` / `five-repo` = 실측 0.
- live 영역 = master `.claude/{rules,agents,skills,hooks,commands}` + `scripts/*.sh` + master `CLAUDE.md` + 부모 root `CLAUDE.md`. (commands = 실측 0)
- 역사 영역(무접촉) = `.ai/**` 379 · `.auto-memory/**` 92 · `propagation-reports/**` 34 · `archive/**` 10 · 각 file "명시 cycle 이력" §행 · CLAUDE.md §15 · rule-routing-index §F.
- scope-외(표면화만) = master `docs/**` 15행.

## 진입 실측 → 처분 집계 (live 영역 219행 = master 217 + 부모 2)

| 처분 | 행 | 내용 |
|---|---|---|
| **live 정정** | **157** | 5-repo→6-repo 의미 단위 정정 (rules 32 file + agents 1 + skills 9 + hooks 2 + scripts 2 + CLAUDE.md 3행 + 부모 1행). "master + 4 자식"→"master + 5 자식" · 전체 열거 +`gently-product-docs` 동반 |
| **역사 박제 보존** | **46** | 각 rule/skill/agent "명시 cycle 이력" 행 + CLAUDE.md §15 2 + rule-routing-index §F 4 + baseline-snapshot.sh 갱신이력·결함역사 2 — 그 시점 사실 |
| **STOP ③ 실태-정합 보존** | **8** | `instructions-loaded-baseline-verify.sh` 7 (REPOS 하드코딩 5 — PDOCS 미계측 · 어휘=실태) + `pencil-pending-sweep.sh` 1 (scan 대상 실제 5) — 6-repo 계측 확장 = 별 cycle 후보 |
| **키워드 병기 보존** | **4** | trigger 키워드 list 행에 `"6-repo"` 추가 + `"5-repo"` 보존 (cross-repo-parallel-exec §6.1 · routing-and-delegation · cross-repo-orchestrator · 부모 §4 기존 병기) |
| **모호 보존** | **4** | rule-routing-index §E "본 cycle(RULE-ARCH-PHASE1)" 서술 · code-style-guide §E "본 cycle(PHASE2)" 서술 (둘 다 그 시점 cycle 자기 서술) · text-degeneration §1 실측 baseline 표 서두 · domain-roles reconcile 기록 |
| **보호 표면화** | **0** | 보호 5 file 내 "5-repo" 실측 0건 — 보호 체인 발동 사유 없음 |

검산: 157 + 46 + 8 + 4 + 4 = 219 ✓. 마감 잔존 62 = 46+8+4+4.

## 치환 메커니즘 (blanket sed 금지 준수)

`apply_sweep.py` (본 디렉터리) = (file × 행번호 × old/new 치환쌍) 건별 판정 표 + 2-phase(전수 내용 단언 → 일괄 적용). 단언 실패 1건이라도 = 전체 미적용. 적용 = 51 file · 179 pair + 후속 1 (cross-repo-parallel-exec:73 누락분 동일 방식). 동결 task-ID / paradigm-ID 문자열 = 행 단위 분류상 전부 이력행 → 무접촉.

## scope ② 비보호 소형 잔여 3

1. `design-to-code-sync.md` :12/:87 — `design-sot-refresh.md` → `uiux-sot-refresh.md` (의미 = design-sot-refresh 병기 · 보호 pencil-uiux-workflow:9 정정 선례 동형). 잔존 grep = 의미 병기 2건만.
2. `layer-checker.md` :10/:49/:52/:60 — `scripts/agent/repo-config.sh` → `scripts/repo-config.sh` (disk 실측: master + 4 자식 `scripts/repo-config.sh` 실재 · `scripts/agent/` = frontmatter-grep.sh 단독 · PDOCS = repo-config 부재이나 layer-checker 비대상 도메인).
3. 동일 유형: `check-layer/SKILL.md` :15/:21/:24/:32 동일 경로 정정 ×4. 잔여 `scripts/agent/` 인용 = post-policy-watch glob(실재 경로) + measure-gsm 죽은-인용 라벨(의도적) + propagate.sh 자식 자율영역 열거(실재) = 전부 비-오기.

## 동반 enumeration 정정 (의미 단위 · 비-"5-repo" 행)

- master CLAUDE.md §3: `[--targets GB,GD,GT]` → `[--targets FND,GB,GD,GT|all]` (propagate.sh 실지원 shorthand 4종 + all=5 자식 실측 정합).
- propagate.sh usage :5/:6: `[--targets GB,GD,GT|all]` → `[--targets GB,GD,GT,FND|all]` (case문 실지원 정합 · PDOCS = 전체명/all 경유 — 로직 무접촉).
- architecture-foundation-link-policy :51: 열거 +`gently-product-docs` (PDOCS `docs/agent/architecture/` 13 docs 실재 실측).
- supabase-handling §10.1 열거 +`gently-product-docs` (PDOCS `.mcp.json` master와 sha 동일 실측 `b0e3550b`).

## 판정 근거 disk 실측 (A5 · 6-repo 정정 가능 여부)

- `repo-config.sh` `TARGET_REPOS` 기본 = 5 자식(gently-product-docs 포함) → propagate/verify-sync/nightly = 6-repo 실커버 → 라벨 정정 타당.
- `nightly-baseline-report.sh` = `REPOS_ALL="claude-cli-master $TARGET_REPOS"` 동적 → 6-repo 실측 → 라벨 6행 정정.
- `baseline-snapshot.sh` REPOS = PDOCS literal 포함(DEAD-REF-SWEEP ①) → 주석 4행 정정.
- `instructions-loaded-baseline-verify.sh` REPOS = 5 하드코딩(PDOCS 무) → 어휘가 실태와 정합 → 보존 (정정하면 거짓 라벨).

## scope-외 잔존 표면화 (docs/** 15행 · 무접촉)

- `docs/agent/architecture/TESTING_STRATEGY.md` :246/:247 변경정책 + :253 이력 (3)
- `docs/architecture/external-dep-abstraction.md` :5/:96/:97 live + :104 이력 (4)
- `docs/release-readiness/PACKAGE-OVERVIEW.md` :23/:24/:33/:74/:130 (master-only · :23-24 = "5-repo(빌드·코드 repo)" 한정 표기 — instructions hook 실태와는 정합 · latest.json은 현재 6-repo로 어긋남) (5)
- `docs/agent/audits/TESTING-BACKFILL-AUDIT.md` :6 (master-only audit) (1)
- `docs/baseline/cowork-project-instructions-§20-redline-20260517.md` :46/:50 (A/B body 동결 영역 — paste §2 무접촉 명시) (2)

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경)
