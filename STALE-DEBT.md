# STALE-DEBT — claude-cli-master (per-repo 낡은 문면 원장)

> 주석 · 기획/설계 SoT 문서 · rule/`CLAUDE.md`/상태문서 문면이 **실물과 갈린** 발견을 cycle 밖으로 보존한다 (= `docs/rules/stale-artifact-tracking.md`).
> **행 삭제 0** (additive) — 해소는 `status` 칸 갱신으로만. **등재하면 진행 허용**.
> **이력·박제 문면은 대상 밖** (rule §1) — 아래 §기각 표가 그 경계의 실사용 기록이다.
> 본 대장 개설 근거 = `MASTER-STALE-TRACKING-001` §11-1 ㉮ (「나머지 repo 는 **발견이 실제로 생길 때** 개설」) 의 집행. 회차 폴더(`docs/stale-sweeps/`)는 같은 논리로 **첫 sweep 시점에** 연다 (= 형식 = `../Selfward/docs/stale-sweeps/README.md`).

| 좌표 (file + 앵커 문자열 · 행 번호 금지) | 낡은 문면 → 실측 정본 | 등재 cycle/date | 위험 | 해소 경로 | status |
|---|---|---|---|---|---|
| `.auto-memory/propagation-status.md` 앵커 `domain-roles.md(구 .claude/agents/ → 현 \`.claude/rules/domain-roles.md\`)` | 「**현** `.claude/rules/domain-roles.md`」 = 현재형 주장 → 실측 = `docs/rules/domain-roles.md` (`.claude/rules/` 부재). rule 44종이 `docs/rules/` 로 이전(`MASTER-CLI-CONTEXT-DIET-2-003` T1)되며 무효화됐는데 **그 이전을 설명하는 문장 자체가 구 경로를 현재형으로 들고 있다**. | MASTER-STALE-TRACKING-001 / 2026-08-17 | 낮음 — 그 좌표를 따라가면 0 hit (= 「본문은 옮겼는데 이름표가 안 늙었다」 형 · `MEASURE-CROSSREPO-DOC-STALE-20260809` 가 명명한 shape). 단 해당 문장의 **취지**(= 구 수기 표가 소멸 참조를 누적시켰다)는 참이라 오도 폭이 좁다. | 미정 — 「현 X」 절만 `docs/rules/` 로 정정하거나, 문장 전체를 이력 배너 아래로 내림(= 그러면 대상 밖이 된다) | OPEN |

---

## 등재하지 않기로 판정한 후보 (= §1 경계가 갈라낸 것 · 기록 존치)

`scripts/verify-sync.sh` 가 매 실행 뱉는 **「상태문서 부재 참조」 경고 6건**을 전수 열어 층을 갈랐다 — **6 중 5 = 이력 층 ⟹ 대상 밖**, 1 만 위 표로.

| 후보 좌표 | 소속 층 (실측 heading) | 기각 사유 |
|---|---|---|
| `.auto-memory/protected-file-hashes.md` 앵커 `` `.claude/rules/code-principles.md` (151 줄) — Q1 답 `` | `## 신설 cli infra (C2.5)` | **cycle 신설 기록 절** = 그때 그 경로에 만들었다는 이력. 현재형 주장 아님. |
| 〃 앵커 `` `.claude/rules/design-to-code-sync.md` (103 줄) — Q2 답 `` | `## 신설 cli infra (C2.5)` | 동일 |
| 〃 앵커 `` `.claude/hooks/check-abbreviation.sh` `` (sha `c232e2c7…` 행) | `## GLOBAL-NO-ABBREV-POLICY-002 갱신 cli infra (2026-05-10)` | **날짜 박힌 cycle 절** 안 sha 기록 = 이력. 같은 file 의 `~~check-abbreviation.sh~~ (소멸)` 행이 제거 사실을 이미 명기(`MASTER-CLI-JUDGMENT-SHIFT-001`). |
| 〃 `.claude/rules/abbreviation-policy.md` | `~~...~~ (소멸)` 취소선 행 | 명시적 박제. 원문 = `.auto-memory/abbreviation-policy-COLD.md` verbatim. |
| 〃 `.claude/rules/workflow-core.md` | 이력 절 | 실물 = `docs/rules/workflow-core.md` (이전 완료) · 참조는 이전 이전 시점 기록. |

★**본 표가 곧 rule §7(hook 기각)의 실증이다.** 「등재를 자동화하자」의 가장 가까운 후보가 `verify-sync` 의 이 경고인데, 그 자는 **경로 문자열만 보고 층을 못 본다** — 그래서 6 중 5 를 잘못 올렸다. 자동 등재였다면 이력 5건이 대장에 박히고 rule §1 마지막 행이 첫 cycle에 깨졌을 것이다. 판정은 사람(모델) 몫으로 남긴다.
