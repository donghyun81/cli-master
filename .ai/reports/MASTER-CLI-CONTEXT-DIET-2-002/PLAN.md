# PLAN — MASTER-CLI-CONTEXT-DIET-2-002

> Mode **M5 cli-infra-ops** · production 0 LOC · Money/Auth/DB/EF 무접촉 · agent-commit: yes.
> 선행 = MASTER-CLI-CONTEXT-DIET-2-001 (PASS · HEAD `f4e66ba`). baseline 재측정 = live (paste `8ece849` = 001 마감 전 authored · §10 = cli 라이브 재측정 유일 기준).

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 9 (parent CLAUDE.md[git-X] + master CLAUDE.md + 자식4 CLAUDE.md + mode-system.md + measure-gsm-cycle.sh + context-health-metrics.md) + audit(§15/propagation-status/REPORT) |
| Modules | cli infra (rule/hook/헌법 문서) + auto-memory |
| Risk | Low (doc/rule/hook · 의미 보존 · 안전 조항 손실 0) |
| DBMig | No |
| MoneyAuth | No |
| production LOC | 0 |
| 보호 5 ∩ edit-set | ∅ (STOP#5 무관) |

## 2. Task 결정 (T1~T7)

- **T1 진입 재정독 강등** ✅ — 부모 root §3.1/§3.2 reading order + 자식4 배너: "master 전문 정독" → "§5 STOP(9항) + §2 정합 강제 3등급 발췌 · 그 외 pointer · guide 2종 = 작업 시". master §9 = 정독 범위 canonical 명시. 안전 조항(STOP 9·보호 5·단방향 propagation) = 발췌 보존(손실 0). 부모 §4 billing split = UNVERIFIED 병기(001 후속③).
- **T2 Compact instructions** ✅ — master §9 + 자식4 §9 pointer 하단: auto-compact 보존 = ①cycle-id ②Mode ③branch ④미완 step ⑤다음 행동 ⑥STOP 상태 (compaction 시점 in-context · 재정독 재발 방지 · `cycle-discipline §12`).
- **T3 paths: 경로 스코핑** ⏭️ SKIP+보고 (STOP#3 = non-STOP) — 근거: ① rule-layer `paths:` 지원 미확인(web 조회 = 헌법 §4 금지 · subagent spawn = 242K 초과 blocked) ② 실측: skill-layer `paths:` = **작동 확인**(5 skill[pencil-recolor/pen-save/cli·initiatives-sync·paste-source-authoring] = context 부재 시 미로드 · frontmatter 없는 skill = 로드) → pencil path-scoping 은 이미 skill 층에 존재 ③ `pencil-uiux-workflow.md` = 보호 file → "pencil 8 rule" 중 1 = 편집 시 STOP#5 ④ rules = frontmatter 0 + @-import 0 인데 49 전량 주입 = rule-loading 기전 미확인 · `paths:` 부여 시 rule 로드 회귀 risk(STOP#3).
- **T4 모델/effort 계층 표** ✅ — mode-system.md §3.3 신설: 기계적 cycle=Sonnet+low 권장 · 설계/Money/Auth/DB/비가역=Opus+high 고정(하향=STOP) · 일반 IMPL=자율 · Haiku=보류 · 장세션 opusplan 회피.
- **T5 계측 확장** ✅ — measure-gsm-cycle.sh context-health: `ctx_실측(/context)` + `model_effort_전환수` 2 manual 열 신설(printf/surface/comment 동기) · context-health-metrics.md §3.1 header/separator 12-col + §6. 신 hook X · 신 hot anchor X.
- **T6 MCP 실측 게이트** ✅ record (STOP 무관) — MCP tool defs = **deferred**(SessionStart: "schemas NOT loaded") · base context ~242,708 tok(subagent 초과 error 실측)에 MCP schema 미포함 · 실점유 ≈0 → `.mcp.json` 무접촉. `.mcp.json` disk = 929 byte(config only).
- **T7 부산물 정리** ✅ measure+conservative-hold (전부 evidence-backed):
  - (a) trace `.ai/traces/*.jsonl` = **소비 有**(reporting.md §9.2 Trace Pointer + cross-repo-orchestrator + gitignore) → 존치.
  - (b) settings.local.json(부모 root · 257 one-shot allow) = **prune 보류** — 부모 root settings.json 부재 + user-global bypass 부재 → 부모 root 세션 = default(prompt) mode → allow live risk → STOP#2 "prune flow 파괴" + 의심 시 보수.
  - (c) propagation-reports = **skip** — git-tracked(91 file) + §15/COLD `REPORT.md` pointer 참조 → 이동 = dead-pointer.
  - (d) 루트 cc-paste(103) = **conservative hold** — mtime 전량 07-03~07-10(최근 8일 · 14 = 오늘) = **"구" 아님**(cowork premise vs disk mismatch · A1) · lifecycle mtime-7d trigger ≈0 · daemon(working-file-archiver) inactive · 활성 multi-session risk → daemon 재활성 권장(launchctl = 사용자 영역).

## 3. VerificationPlan

- content-parity: 자식4 CLAUDE.md byte-identical diff = 0.
- 보호 5 git-sha1 drift = 0.
- hook self-test: `GSM_CONTEXT_HEALTH_FORCE=1` exit 0 + 12-col printf.
- propagate ok=5/0 (mode-system + measure-gsm) → 6-repo byte-identical(unique sha 1).
- verify-sync.sh exit 0.
- secret grep 0 · production 0 LOC.

## 4. RollbackStrategy

문서/rule/hook — git revert (master content + audit commit) + 자식 path-limited commit revert. parent root CLAUDE.md = git-X → 직접 되돌림(sha 기록 보존). 파일 삭제 0(T7 hold) → 되돌릴 삭제 없음.

N/A: DependencyDecision · ArchitectureImpact · ModelBoundaryPlan · ErrorPolicy · UIStateFlowPlan · TestabilitySeams · ExternalPrep.
