# cli-master 역할 정합 감사 + 분리 헌장 (Scope Audit & Separation Charter)

> **본질** = `claude-cli-master`가 자기 역할(CLI/agent 운영 도구)에 안 맞게 안고 있는 것들(제품/앱 표준)을 전수 감사하고, **필요할 때 기계적으로 분리**할 수 있게 남기는 청사진.
> **결정** = 2026-07-13 KST · Coin 본심 회수. 방향 = **역할 기준 분리**(웹 트리거 아님). cli-master = "CLI/agent가 어떻게 동작하는가(도구 설정)"만. **"제품이 무엇이고 어떻게 구현·설계·출시되는가"는 이 repo 소관 아님.**
> **상태** = 감사 완료(disk 실측 2026-07-13 · device_bash find). 물리 분리 = **필요 시**(트리거 = §4 · Coin 결정). 본 문서 = 그때의 실행 지도.
> **작성** = cowork(기획·감사) · 본 파일 = cli-master `docs/architecture/` 소속 durable 문서(메모리 아님).

---

## §0. 분류 원칙 (단일 test)

각 항목에 이 질문 하나:

> **"이건 CLI/agent가 *동작하는 방식*(도구 층)인가, 아니면 *제품이 무엇이고 어떻게 만들어·설계·출시되는가*(제품 표준 층)인가?"**

- **STAY** = 도구 층. cli-master의 진짜 역할. 개발 *도구*가 바뀔 때만 변함(제품 무관).
- **GO** = 제품 표준 층. 분리 후보. 제품 *표면/도메인*이 바뀔 때 변함.
- **경계** = 판단 필요(내용 검토 후 확정).

---

## §1. 핵심 발견 — 현재 conflation

cli-master는 두 층을 한 repo에 섞고 있고, **자기 §0 charter조차 제품 표준을 "cli infra"로 잘못 편입**하고 있다.

1. **charter 오분류**: master `CLAUDE.md` §0 책임①이 "cli infra SoT = `.claude/` + **`docs/schemas/`** + **`docs/design/pencil-sot-policy.md`**"라고 선언 — 뒤 둘은 제품-디자인 표준인데 "cli infra"로 묶임.
2. **★가장 강한 증거 — 보호 파일 5종이 전부 제품-디자인**: byte-identical 최상위 보호(§2 정합 강제 1등급) = `docs/schemas/ui-spec.schema.json` · `docs/rules/pencil-uiux-workflow.md` · `docs/design/pencil-sot-policy.md` · `docs/rules/uiux-sot-refresh.md` · `docs/design/design-sot-policy.md`. **다섯 개 모두 Pencil/UI 설계 거버넌스** = CLI 도구가 아님. 즉 이 repo가 "가장 신성하게" 지키는 층이 실은 제품-디자인 표준.
3. **docs/rules 44개 중 ~55%가 제품/도메인** (§2 표). "규칙"이라는 한 폴더에 CLI 운영 규칙과 제품 코드/디자인/도메인 규칙이 뒤섞임.
4. **`docs/guides/app-implementation-guide.md`** = 문자 그대로 "앱을 어떻게 구현하는가" — 사용자 지적의 정곡(이 repo가 알 필요 없는 것).

결론: **`.claude/` + `scripts/` + CLI-workflow 규칙**만 진짜 cli-master 역할이고, `docs/`의 다수(templates·schemas·design·backend·guides·architecture·release-readiness + docs/rules의 절반)는 제품 표준 = 분리 대상.

---

## §2. 전수 분류 표 (disk 실측 2026-07-13)

### ✅ STAY — CLI/agent 도구 인프라 (cli-master 진짜 역할)

| 영역 | 내용 | 판정 근거 |
|---|---|---|
| `.claude/` 전체 (71 file) | agents(25)·commands(8)·hooks(17)·rules(5 kernel)·skills(20)·settings.json | Claude Code가 읽고 실행하는 **메커니즘**. ★단, 내용이 제품-도메인인 것은 §2-경계 |
| `scripts/` (24) | propagate·verify-sync·activate-agent·report-gen·git-lock/safe·archiver·baseline-report·restore·repo-config 등 | propagation·repo-ops·git-안전 **도구** |
| `CLAUDE.md` | master 운영 SoT | 운영 헌법 · ★단 §0 charter는 재정의 필요(§3) |
| `.claude/rules/` 5 kernel | safety-and-secrets·anchor-list·cross-repo-parallel-exec·rule-routing-table·rule-footer-common | CLI L0 kernel(안전·앵커·크로스레포·라우팅) |
| `docs/rules/` 중 CLI-workflow (18) | routing-and-delegation·cycle-discipline·mode-system·workflow-core·workflow-policy·reporting·verification-and-review·working-file-lifecycle·rule-routing-index·cross-repo-parallel-exec-detail·paste-authoring-disk-verification·recommended-option-disk-verification·gsm-measurement·automation-policy·plugin-policy·abbreviation-policy·libs-versions-cross-verify·text-degeneration-prevention | CLI/agent가 *어떻게 일하는가* |
| `docs/agent/process/` (4) | COMMIT_CONVENTION·DOC_GOVERNANCE_WORKFLOW·DOC_TASK_TYPES·REPO_FIRST_INTAKE_WORKFLOW | dev/문서 workflow (★COMMIT_CONVENTION 경계) |
| `docs/agent/architecture/PROPAGATION_PARAMETERS.md` | propagation 파라미터 | 도구 설정 |
| repo config | `.editorconfig`·`.gitattributes`·`.gitignore`·`.mcp.json`·`propagation-reports/` | repo/도구 설정·산출 |

### 🚚 GO — 제품/앱 표준 (분리 후보)

| 영역 | 내용 | 판정 근거 |
|---|---|---|
| `docs/templates/` 전체 (10) | api-spec·billing·data-model·screen-flow·**release-checklist**·plan-10-section·review-12-section·setup-guide·ai-prompt-guide·pencil-dev-prompt | 제품/앱 **저작 양식** |
| `docs/schemas/ui-spec.schema.json` | UI 설계 계약 | 제품 UI 계약 · ★보호 5 |
| `docs/design/` (2) | design-sot-policy·pencil-sot-policy | 제품 디자인 거버넌스 · ★보호 5 |
| `docs/backend/` (1) | RLS_AND_PLAY_INTEGRITY_GUIDE | 제품 백엔드/보안 |
| `docs/guides/` (1) | **app-implementation-guide** | "앱을 어떻게 구현하는가"(정곡) |
| `docs/architecture/external-dep-abstraction.md` + `docs/agent/architecture/` (13) | COMMON_ARCHITECTURE·KMP_CMP_LAYER_DIRECTION·KOIN_DI_BASELINE·COMPOSE_STABILITY·ERROR_RESULT_POLICY·MODEL_SEPARATION·SSOT_PRINCIPLES·TDD_WORKFLOW·TESTABILITY_SEAMS·TESTING_STRATEGY·DEPENDENCY_DECISION_CHECKLIST·LEGACY_CLEANUP_GOVERNANCE·ADR_TEMPLATE | 소프트웨어 **아키텍처 표준**(제품이 어떻게 지어지는가) |
| `docs/rules/` 중 제품-도메인 (24) | pencil-*(8: automation·cli-headless·component-paradigm·mcp-tools-reference·pen-format-schema·theme-multi-axis·**uiux-workflow**★·visual-primitives)·code-style-guide·code-principles·auth-rules·billing-rules·supabase-handling·design-prompting-paradigm·design-to-code-sync·domain-roles·deferred-domains·ui-ux-analysis·ux-laws·**uiux-sot-refresh**★·sot-code-name-map·architecture-foundation-link-policy·legacy-cleanup-governance·runtime-crash-mitigation-process | 제품 코드/디자인/도메인 규칙 (★=보호 5) |
| `docs/release-readiness/PACKAGE-OVERVIEW.md` | 출시 현황 | 제품 출시 상태 |
| `docs/agent/audits/`·`docs/agent/solutions/PROMPTFIT_RUBRIC.md`·`docs/baseline/` | 감사·rubric·cowork redline | 제품/프로세스 산출(일부 archive 후보) |
| `docs/ops/production-cli-access-tokens.md` | prod secret runbook | 제품 운영 · ★**민감(secret)** · 현재 verify-sync MISS-5(master-only 의도적 6-repo 제외) — 분리 시 secret 취급·접근권 재설계 의무 |

### ⚠ 경계 — 내용 검토 후 확정

| 항목 | 쟁점 |
|---|---|
| `.claude/agents/` 도메인-특화 | billing-payments-guardian·auth-security-privacy·backend-api-architect·data-schema-guardian·domain-policy-analyst·server-implementer·release-risk-manager 등 = **메커니즘은 STAY**(agent 기능)이나 **내용이 앱-도메인 지식이면** genericize(재사용 역할) 또는 GO tier 참조로 분리 |
| `.claude/skills/` + `scripts/` + `hooks/` 중 pencil-* | pencil(디자인 도구) 자동화 = 도구지만 **제품-디자인 종속** — 도구 층에 남기되 pencil 표준(GO)과의 의존 방향 명시 |
| `docs/rules/initiatives-auto-sync`·`terminology` | 전자 = 도구지만 대상이 출시 INITIATIVES(제품) · 후자 = CLI 용어 vs 제품 도메인 용어 혼재 |
| `docs/agent/process/COMMIT_CONVENTION`·`docs/agent/solutions/PROMPTFIT_RUBRIC`·`agent/architecture/ADR_TEMPLATE` | dev-workflow(STAY) vs 공유 eng 표준(GO) 경계 |
| top-level `gradle.properties` | cli-master에 gradle 파일 = 용도 확인(vestigial 여부) |

**요약 수치**: STAY ≈ `.claude/`(71) + scripts(24) + CLI-workflow rules(18) + process(4) + config. GO ≈ templates(10) + schemas(1) + design(2) + backend(1) + guides(1) + architecture(14) + 제품-도메인 rules(24) + release-readiness(1) + ops/baseline/audits. ★보호 5종 = **전부 GO(제품-디자인)**.

---

## §3. 목표 구조 (분리 후)

- **Repo A `claude-cli-master`**(rename 검토: `gently-cli-infra`) = **순수 CLI/agent 도구**. `.claude/` + scripts + kernel/CLI-workflow rules + process + propagation 도구. 제품 무관 → 다른 패키지(SteadyWell·웹 등)에 그대로 재사용.
- **Repo B 신설 `gently-standards`**(또는 `app-standards`) = **제품/앱 표준**. templates·schemas·design·backend·guides·architecture·domain rules·보호 5. 내부 tier:
  - **보편**(플랫폼 무관): api-spec·data-model·billing·아키텍처·code-style·code-principles·auth·supabase.
  - **플랫폼**(모바일): release-checklist·ASO·권한·store · **웹 추가 시 웹 tier 신설**(웹 release-checklist ≠ 모바일).
- **app-foundation(코드 repo)엔 넣지 않음** — KMP/CMP *코드* repo에 프로세스/표준 문서 = 냄새.
- **charter 재작성**: master `CLAUDE.md` §0 책임①에서 `docs/schemas`·`docs/design` 제거 → Repo B 소속. cli-master 역할 = "CLI/agent 도구 SoT + propagation" 순수화.
- **보호 5종 이동**: 전부 Repo B로 · propagation 대상·byte-identical 규칙을 Repo B가 승계.

---

## §4. 분리 실행 절차 (필요 시 · Coin 결정)

**트리거**(아무 때나 Coin 결정 · 아래는 자연 지점):
- 신규 앱 패키지 추가(도구 재사용 필요 표면화) · 웹 등 플랫폼 분화(보편 vs 플랫폼 표준 실 divergence) · 또는 단순 정합 의지.

**단계**:
1. Repo B 생성 + GO 세트 **git-history 보존 이동**(`git mv`/filter-repo 또는 cp+삭제 + 이력 주석).
2. `scripts/propagate.sh`·`verify-sync.sh` targets·경로 **재지정**(보호 5 + 이동분 = Repo B 기준).
3. **참조 갱신**(★가장 큰 작업 = coupling): 부모 `CLAUDE.md §3.1/§3.2` reading order · 자식 배너 reading order · `docs/rules/rule-routing-index.md`(docs/ 경로 인용) · 핸드오프·memory·cc-paste의 `master docs/...` 인용 전수 grep → 일괄 치환.
4. `CLAUDE.md §0`·§2 정합 강제 3등급 표 재작성(보호 5·cli infra 정의 = 도구만).
5. `verify-sync` 전수 PASS 확인 + REPORT.
6. app-foundation 아키텍처 문서(`docs/agent/architecture/`가 자식에 propagate되는 구조)와의 정합 재점검.

**지금 준비(공짜 · 물리 이동 없이)**:
- master `CLAUDE.md §0`에 tier 선언 1줄 + 본 헌장 링크 → 이후 이동이 rewrite 아닌 **기계적 이동**이 됨.
- 신규 문서 배치 시 STAY/GO tier 의식(도구 문서는 `.claude/`·process, 제품 표준은 templates/design/architecture로) → coupling 심화 방지.

**위험**:
- 참조 coupling(`master docs/...` 경로가 핸드오프·memory·rule 곳곳 인용) = 이동 전 전수 grep 필수.
- 보호 5 이동 = byte-identical 강제 대상 변경 → 자식 drift 오탐 방지 위해 propagation 파라미터 동시 갱신.
- ops secret runbook 이동 = 접근권/노출 재설계(민감).

---

## §5. 감사 provenance

- disk 실측 = 2026-07-13 KST · `device_bash find claude-cli-master`(archive/.git/propagation-reports 제외) · read-only.
- 파일 수: `.claude/` 71(agents 25·commands 8·hooks 17·rules 5·skills 20+) · `docs/rules/` 44 · `docs/templates/` 10 · `docs/agent/architecture/` 14 · scripts 24.
- 보호 5종 = 전부 제품-디자인(ui-spec.schema·pencil-uiux-workflow·pencil-sot-policy·uiux-sot-refresh·design-sot-policy) 확인.
- `.claude/rules`(5) ≠ `docs/rules`(44) = 둘 다 실디렉토리(symlink 아님) — kernel은 `.claude`, 전 corpus는 `docs/rules`.
- 근거 = 본 감사 + master `CLAUDE.md §0/§2` charter 대조.
