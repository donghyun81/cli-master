# STALE-DEBT — claude-cli-master (per-repo 낡은 문면 원장)

> 주석 · 기획/설계 SoT 문서 · rule/`CLAUDE.md`/상태문서 문면이 **실물과 갈린** 발견을 cycle 밖으로 보존한다 (= `docs/rules/stale-artifact-tracking.md`).
> **행 삭제 0** (additive) — 해소는 `status` 칸 갱신으로만. **등재하면 진행 허용**.
> **이력·박제 문면은 대상 밖** (rule §1) — 아래 §기각 표가 그 경계의 실사용 기록이다.
> 본 대장 개설 근거 = `MASTER-STALE-TRACKING-001` §11-1 ㉮ (「나머지 repo 는 **발견이 실제로 생길 때** 개설」) 의 집행. 회차 폴더(`docs/stale-sweeps/`)는 같은 논리로 **첫 sweep 시점에** 연다 (= 형식 = `../Selfward/docs/stale-sweeps/README.md`).

| 좌표 (file + 앵커 문자열 · 행 번호 금지) | 낡은 문면 → 실측 정본 | 등재 cycle/date | 위험 | 해소 경로 | status |
|---|---|---|---|---|---|
| `.auto-memory/propagation-status.md` 앵커 `domain-roles.md(구 .claude/agents/ → 현 \`.claude/rules/domain-roles.md\`)` | 「**현** `.claude/rules/domain-roles.md`」 = 현재형 주장 → 실측 = `docs/rules/domain-roles.md` (`.claude/rules/` 부재). rule 44종이 `docs/rules/` 로 이전(`MASTER-CLI-CONTEXT-DIET-2-003` T1)되며 무효화됐는데 **그 이전을 설명하는 문장 자체가 구 경로를 현재형으로 들고 있다**. | MASTER-STALE-TRACKING-001 / 2026-08-17 | 낮음 — 그 좌표를 따라가면 0 hit (= 「본문은 옮겼는데 이름표가 안 늙었다」 형 · `MEASURE-CROSSREPO-DOC-STALE-20260809` 가 명명한 shape). 단 해당 문장의 **취지**(= 구 수기 표가 소멸 참조를 누적시켰다)는 참이라 오도 폭이 좁다. | **해소** — `MASTER-STALE-SWEEP-001` 에서 「현 X」 절만 `docs/rules/domain-roles.md` 로 정정. 문장의 나머지(구 `.claude/agents/` 이력 절 + 그 문장의 취지)는 **무접촉**. ★소속 절 heading 재확인 = `## 수기 sha 매트릭스 폐기 (= Phase C · MASTER-CLI-POSTCYCLE-AUTOMATION-001 · 2026-06-01)` = **규범 절**(같은 file 의 이력 절은 `## <CYCLE-ID> 마감 (date)` 형태로 4 개 따로 있다 · `:22` `:30` `:64` `:78`) ⟹ **오등재 아님** | RESOLVED |
| `docs/rules/rule-routing-index.md` 앵커 `` `.claude/rules/` 48 rule 의 논리적 계층 `` 외 3 (`` `.claude/rules/` 는 평면 폴더다(subfolder 0) `` · `` find .claude/rules -type f -name '*.md' `` · `` 본 file = cli infra **권장 byte-identical** 영역(`.claude/rules/` ``) | **경로**가 `.claude/rules/` 단일이라 주장 → 실측 정본 = `docs/rules/` **43**(= 색인 자신 포함 · 디렉터리 0 · non-md 0) + `.claude/rules/` **6**. ★**계수 48/49 는 참이다** — 43 − 자기 1 + 6 = 48 · 43 + 6 = 49. `MASTER-CLI-CONTEXT-DIET-2-003` T1 로 rule 이 두 폴더로 갈릴 때 **경로만 안 따라왔다**(수는 따라왔다). | STALE-SWEEP-001 / 2026-08-17 | ★**측정 오도 실증** — 앵커 3 (`§D-5`) 은 이 색인이 **자기 검증용으로 적어 둔 명령**인데 그 명령의 현 출력이 **6**(적힌 기대 = 49)이다. 그 자를 믿고 「정합 검증」을 돌리면 `docs/rules/` **43 본이 사라진 것처럼 보인다**. | 본 회차에서 **경로 4 앵커 고침**(★계수 무접촉) + 4-repo propagate. 죽은 구 명령은 삭제하지 않고 `★[구 판 보존]` 1줄에 verbatim 존치(= 자가 왜 죽었는지가 다음 cycle 의 자다) | **RESOLVED** |
| `CLAUDE.md` §15 앵커 `MULTI-REPO-RENAME-TOWARD-001` entry 행 | §15 규약 = 각 entry **≤400B** ↔ 실측 **440B**(356 자 · `perl -CSD -Mutf8` + `use bytes`) | STALE-SWEEP-001 / 2026-08-17 | 낮음 — 상주 토큰 40B 초과 · **오도 0**(entry 내용 자체는 참) | ★**이력 판정 = 고치지 않는다.** §15 = 「최근 3 entry」 유지이고 현재 **3행 만석** ⟹ 다음 master cycle 의 entry 신설이 그 행을 **자동으로 COLD demote** 한다. 근거 실측(본 회차) = `cycle-discipline.md §15` 「hot 상한 규약」 = **마감 step 의무** · ②「3 초과분 = 그 자리에서 즉시 demote · advisory 대기 / 별 demote cycle 신설 **금지**」 · ④ COLD verbatim 실재 확인 = HARD. 지금 재작성하면 **버려질 작업**이고 상주 헌법을 근거 없이 한 번 더 만지는 것이다. ★**승계 의무 1**: 그 demote 시점에 440B 원문을 `.auto-memory/master-cycle-history-COLD.md` 에 **verbatim** 이월할 것 | **RESOLVED** |
| `docs/rules/rule-routing-index.md` §A 층 heading 앵커 `` L0 — 불변 (항상 적용 · 4 rule `` · `` L1 — 프로세스·워크플로우 (작업 시작 시 · 22 rule) `` · `` L2 — 프로그래밍 (code-level 행동 시 · 5 rule) `` | 소계 합 = 4+22+5+18 = **49** ↔ **실존 멤버 48**. 갈림의 정체 = ⓐ 표 **안** 「등록 해제」 **박제 2 행**(`text-degeneration-prevention.md`[L1] · `abbreviation-policy.md`[L2] — 실물 4 경로 전량 부재 실측 · 원문 = `.auto-memory/*-COLD.md` 존재)이 L1·L2 소계에 계수 **(+2)** ⓑ 표 **밖** prose 멤버 `.claude/rules/stop-canonical.md`(= 앵커 `L0 추가:` · 「본 집합 포함」 명시 · 실물 존재)가 L0 소계 4 에 **미계수 (−1)**. ★두 오차가 **부호 반대**라 합계만 우연히 49 로 상쇄된다 — md링크 실측은 4·21·4·18 = **47**, +stop-canonical 1 = **48** | STALE-SWEEP-001 / 2026-08-17 | ★**본 회차의 고침이 이 갈림을 비로소 살린다** — `§D-5` 를 「두 경로 합산 = 49」로 고친 뒤 그 자는 §A 멤버 수 = **48** 을 요구한다. 소계 heading 으로 세면 **49** → **1 갈림 false DRIFT**. 고치기 전에는 자가 죽어 있어(출력 6) 드러나지 않던 층이다 | **본 회차에서 고치지 않는다** (= 계수 무접촉 계약 · 소계 정정은 §A 표 자체의 판단이라 경로 sweep 의 scope 밖). 다음 **색인 갱신 cycle**(= §D 규약이 전문 정독을 요구하는 그 cycle)에서 ⓐ 박제 2 행을 소계 밖으로 뺄지 ⓑ `stop-canonical` 을 L0 소계에 넣을지 판정. ★박제 2 행 **삭제 금지**(rule §1 = 이력은 대상 밖) | **OPEN** |
| `scripts/verify-sync.sh` 앵커 `` ! -path 'docs/release-readiness/*' `` 직후 제외 목록 (+ 앵커 `` find .claude docs scripts/agent ``) | 전체 모드 집합 = `find .claude docs …` **전량**에서 제외 2(`docs/release-readiness/*` · `docs/agent/audits/*`)만 뺀다 → **`docs/stale-sweeps/*` 가 4-repo byte-identical 대상으로 오분류**된다. 실측 정본 = rule `stale-artifact-tracking.md §6` 「`<repo>/docs/stale-sweeps/SWEEP-YYYYMMDD.md`」 = **per-repo 산출물**(회차는 repo 마다 다르게 열린다). 자매 `STALE-DEBT.md` 는 repo root 라 `find` 범위 밖이어서 **우연히** 같은 오분류를 면했다 | STALE-SWEEP-001 / 2026-08-17 | ★**측정 오도 · 본 회차가 만든 것** — `verify-sync.sh` 실측 = **DRIFT 2 + MISS 4** 가 전부 `docs/stale-sweeps/` 이고(선재 = DRIFT 0 / MISS 6 = master-only 문서 2 × 자식 3), 그 경보를 믿고 「정합시키자」로 가면 **per-repo 회차 산출물을 4-repo 에 복제**하게 된다. ⟹ propagation cycle 의 exit 판정이 상시 FAIL 로 물든다 | **본 회차에서 고치지 않는다** — `scripts/**` = 본 cycle **무접촉 계약**(발주 §8). ★해소 방향은 이미 선례가 있다: `verify-sync.sh` 주석이 `docs/agent/audits/*` 제외를 「**자식 propagation 없음 · `docs/release-readiness` 격리 선례와 같은 결**」로 적어 뒀다 — **`docs/stale-sweeps/*` 만 그 목록에 안 들어갔다**. 별 master cycle 에서 제외 1줄 추가 | **OPEN** |

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

### MASTER-STALE-SWEEP-001 회차 기각 (2026-08-17 · ★위 5 행과 **분모가 다르다**)

분모 = 본 회차 신규 후보 **5** (= `verify-sync` 경고 축이 아니라 `rule-routing-index.md` 전수 census 축) → **3 등재**(위 표 · RESOLVED 2 + OPEN 1) · **2 기각**(아래).

| 후보 좌표 | 소속 층 (실측 heading) | 기각 사유 |
|---|---|---|
| `docs/rules/rule-routing-index.md` 앵커 `` 성능 도메인은 `.claude/rules/` 측 rule 이 없고 `` | §A L3 말미 주석 (**현행 층** · 이력 층 아님) | rule §2 판정 자 = 「이 문면을 믿고 행동하면 틀린 판단을 하는가」 → **아니오**. 실측 = perf rule 이 `docs/rules/` **0 hit** · `.claude/rules/` **0 hit**(두 폴더 전량 부재) + `.claude/agents/deferred/performance-reliability-engineer.md` **존재** ⟹ 라우팅 결론(= deferred agent) 이 **동일**하다. 경로 표기만 구 판이고 **행동이 안 갈린다**. ★**오래됐다는 것은 판정 근거가 아니다.** |
| `docs/rules/rule-routing-index.md` §E 앵커 `` 42 rule 이 4-repo byte-identical 이므로 `` | §E propagation 정책 (**현행 층**) | 실측 = `docs/rules/` **43 본 전량** 4-repo 대조 불일치 **0** · 부재 **0**(SW · FND · TPD) ⟹ **42 는 과소**다. 그러나 그 문장의 **결론**(「본 색인도 4-repo 에서 동일하게 유효 → `propagate.sh` 대상」)은 **참**이고 행동이 안 갈린다 ⟹ §2 로 대상 밖. ★본 회차가 바로 그 결론대로 propagate 했다는 점이 결론의 실증이다. |

★**본 회차에서 §2 가 실제로 문 자리는 여기가 아니라 「등재」 쪽이었다** — 발주 초안은 §A 소계 갈림을 「정본을 못 찾았다」로 **기각**했으나, 층을 갈라 세니 정본이 나왔다(= 박제 2 행 +2 · 표 밖 prose 멤버 −1). rule §2 는 「모르면 등재 금지」이지 「세지 말라」가 아니다 ⟹ **기각을 뒤집어 위 표에 OPEN 으로 등재**했다.
