# Stale Artifact Tracking — 낡은 문면의 발견·등재·sweep

> **단일 목적**: 주석 / 기획·설계 SoT 문서 / rule·`CLAUDE.md`·hook 문면이 **실물과 갈렸을 때**, 그 발견을 cycle 밖으로 보존한다. 발견 = cycle 안 **의무** · 보관 = repo 단위 **대장**(`STALE-DEBT.md`) · 정리 = 별 **sweep 회차**.
> **자매 rule** = [`legacy-cleanup-governance.md`](./legacy-cleanup-governance.md) — 그쪽은 **코드(심볼)를 지우는** governance, 본 rule 은 **문면이 거짓이 된 것을 잃지 않는** governance. 적용 범위는 §1 에서 정확히 상보다.
> **신설**: `MASTER-STALE-TRACKING-001` (2026-08-17 · Coin 직접 지시). 신설 근거 = [`cycle-discipline.md`](./cycle-discipline.md) §2 「**예외 (L1-1)**: 사용자 본심 외화 영역 = 신 rule 허용 (본인 명시 결정 + paste umbrella §3 contract 측 본심 인용 의무).」 — 같은 §2 첫 bullet 「기존 룰 도메인에 안 속하면 신설하지 않는다」의 유일한 escape 이다.
> **계기 (실물)**: `Selfward/supabase/functions/story/handler.ts` 의 주석이 재료 상한을 「60」이라 적는데 같은 파일 `SELECTED_LOG_CAP = 10` 이 정본이었다. 그 주석을 근거로 **범위 확대 ⟹ STOP 분기**가 세워졌고, 재보니 **주석만 낡은 것**이었다. 판정 영향은 0이었으나 **한 cycle 의 설계 판단이 낡은 문면 위에 얹혔다.**
> SOT: `CLAUDE.md`

---

## §1. 적용 범위 (= `legacy-cleanup-governance` 와 상보)

| 대상 | 본 rule |
|---|---|
| **주석 · KDoc · docstring** 이 코드/실측과 갈림 | **항상 적용** |
| **기획 · 설계 SoT 문서**가 현행 구현과 갈림 | **항상 적용** |
| **rule · `CLAUDE.md` · hook · 지침 문면**이 실물과 갈림 | **항상 적용** |
| 미사용 **코드 / 심볼** 제거 | **적용 안 함** → [`legacy-cleanup-governance.md`](./legacy-cleanup-governance.md) |
| **이력 · 박제 문면** (additive-ledger 보존분) | ★**적용 안 함 — 이력은 낡는 게 맞다** |

★**마지막 행이 본 rule 의 가장 중요한 경계다.** 「낡음」과 「이력」을 가르지 못하면 이 rule 은 **보존 규약을 파괴하는 기계**가 된다. 이력 판별 신호(실측 관용) = `★[구 판 보존]` · `[제거 · <cycle-id>]` · `supersede` / `구 판 =` 배너 · `.ai/reports/**` · `propagation-reports/**` · `.auto-memory/*-COLD.md` · `archive/**` · 버전 banner(`v17.7 정정 본질` 등) 안의 서술. **같은 파일 안에서도 현행 층은 대상이고 이력 층은 대상이 아니다** — 층으로 가른다.

★**단 하나의 갈래**: 이력 산출물이 **시간이 지나 낡은 것** = 대상 밖(위 행). 이력 산출물이 **발행 시점부터 자기 안에서 갈린 것**(= 같은 문서의 표와 산문이 다른 수를 말함 등) = **대상**. 후자는 「낡아서」가 아니라 「그때부터 거짓이어서」 인용자를 오도한다. ⟹ 처분은 **소급 정정 금지**가 그대로 걸리므로 **인용자용 주석 append 한 줄**에 한정한다 (= 원문 무접촉 · additive-ledger 보존).

> 상보 실측 (2026-08-17 · `legacy-cleanup-governance.md` 201행 전문 대조): 그 rule 안 「주석」 0 · 「문면」 0 · 「stale」 0 · 「낡」 0 hit. 「Drift」 유일 1 hit = 그 rule 「적용 범위」 표의 **「문서형 task (DocSync, Drift Audit) → 적용 안 함」** = 명시적 제외. §Deferred Cleanup · §제거 우선 대상 · §제거 금지 또는 task-level STOP · §EVIDENCE.md 기록 규약 = 전량 **코드 심볼·경로** 축. ⟹ 겹침 0.

## §2. 판정 자

**「이 문면을 믿고 행동하면 틀린 판단을 하는가」** — 예면 대상, 아니면 대상 아님.

- 「오래됐다」는 판정 근거가 **아니다**. 날짜·버전이 낡아도 행동이 안 갈리면 대상 밖이다.
- 「N hit」는 판정이 아니라 **열어볼 신호**다. 문면을 열지 않은 등재 금지.
- 실측 정본을 못 찾으면 등재하지 말고 **UNKNOWN 으로 남긴다**(= 정본 없는 「낡음」 주장은 그 자체가 낡은 문면의 새 생산).

## §3. 발견 의무 (= 워크플로우 편입 지점 3 · cowork · cli 공통)

| 단계 | 의무 |
|---|---|
| **요청 확인** (scope 확정) | 읽은 SoT 문서가 실물과 갈리면 **즉시 1행 등재** |
| **조사** (census · 측정) | 자 · 수치 · 경로가 문면과 갈리면 **즉시 1행 등재** |
| **구현 / 처리** | 만진 파일의 주석이 변경 후 거짓이 되면 **즉시 1행 등재** (그 자리에서 고쳐도 등재) |

- ★**등재는 판정이 아니다.** 처분을 미뤄도 되고, 그 cycle 범위 밖이면 **소급 정정 금지**가 그대로 적용된다. 의무는 **「발견을 잃지 않는 것」 하나**다.
- ★**등재하면 진행 허용** — 본 rule 은 **cycle 을 멈추지 않는다** (= `DESIGN-DEBT.md` deferred lane 관용 이식). 블로킹 게이트 신설 X · hook 신설 X (§7).

## §4. 등재 형식 (= `<repo>/STALE-DEBT.md` 1행)

| 칸 | 내용 |
|---|---|
| 좌표 | `file` + **앵커 문자열**. ★**행 번호 금지** (= 행은 움직인다) |
| 낡은 문면 → 실측 정본 | 무엇이 거짓이고 무엇이 참인지 · 정본은 **`file` + 심볼/문자열**로 |
| 등재 cycle/date | 발견 cycle-id + 발견일 |
| 위험 | 측정 오도 여부 (= 그 문면을 믿고 무엇이 갈렸나 · 「낮음」도 값) |
| 해소 경로 | 처분 방향 또는 해소 task (= 미정도 값) |
| status | `OPEN` / `RESOLVED` |

칸 구성 = 자매 대장 `DESIGN-DEBT.md` 와 **동형**(= 대상 / 내용 / 등재 cycle·date / 분류 / 해소 task / status). 자매 대장이 서로 다른 형태를 갖는 것이 더 나쁘다.

## §5. sweep trigger

셋 중 **하나**면 sweep cycle 1회 개설:

- ⓐ 대장 **미해소(OPEN) 10행** 누적
- ⓑ **분기 1회**
- ⓒ ★**같은 좌표가 3 cycle 연속 재발** (= [`rule-routing-index.md`](./rule-routing-index.md) §C amend loop 의 「동일 anchor N(기본 3) cycle 연속 deviation」 정량 trigger 관용 이식)

★trigger 발동 = **sweep 개설 신호**이지 블로커가 아니다 (= §3 「등재하면 진행 허용」 불변). 상시 red 가 해로운 것은 blocking gate 일 때고, 본 trigger 는 일정 신호다.
★대장이 길어질 때의 읽기 자 = **OPEN 우선** (= `RESOLVED` 행은 삭제하지 않고 아래로 눕는다 · `DESIGN-DEBT.md` 선례 동형).

## §6. sweep 산출 (= `<repo>/docs/stale-sweeps/SWEEP-YYYYMMDD.md` 1본)

필수 = ⑴ **분모**(대장 행 수 · OPEN 수) ⑵ **처분표** 3분류(고침 / **이력 판정** / 이월) ⑶ **자와 명령**(재현 가능하게) ⑷ 대장에서 **행 삭제 0** — 해소는 `status` 칸 갱신으로만.

★**「고치지 않는다」도 처분이다** (= 이력 판정 · 사유를 적으면 종결).

## §7. hook 를 만들지 않는 이유 (= 명시적 기각)

등재 의무를 사람 판단에 맡기면 안 지켜질 수 있다 — 그럼에도 hook 은 답이 아니다:

- 발견의 본질이 **의미 판정**(§2)이라 shell 이 대신할 수 없다. hook 이 잡을 수 있는 것은 「숫자가 안 맞는다」뿐인데, 그 자는 **이력 층까지 함께 잡아** §1 마지막 행을 정면으로 깬다.
- `MASTER-CLI-JUDGMENT-SHIFT-001` (2026-07-29) 이 hook 17→14 로 줄이며 명명·출력 품질을 **모델 판단으로 위임**한 방향과 충돌한다.
- 본 rule 은 `docs/rules/`(콜드)에 있어 **상주 주입 토큰 +0** 이다. hook 신설은 그 성과를 되돌린다.

⟹ hook 신설·변경이 답이라고 판단되면 그것은 **별 cycle 이고 Coin 회부**다 (= 본 rule 안에서 하지 않는다).

## §8. 본 rule 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 4-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지).
> **위치 계약**: 본 rule 본문은 `docs/rules/`(= 콜드 · Reading Mode Read 가 유일 로드 경로)에만 둔다. `.claude/rules/`(= 자동 주입층) 이전 = **상주 토큰 증가** ⟹ 별 cycle + 본심 회수.

## §9. cycle 이력

- 2026-08-17 · `MASTER-STALE-TRACKING-001` · 본 rule 신설 (= Coin 직접 지시 · `cycle-discipline.md §2` L1-1 예외). 동반 = `rule-routing-index.md` §A L1 1행 등재 + `rule-routing-table.md` Reading Mode 1·5 행 동기 + `legacy-cleanup-governance.md` 자매 pointer 1줄 + `workflow-core.md` 단계 흐름 1행 + `Selfward/STALE-DEBT.md` 대장 신설 + `Selfward/docs/stale-sweeps/README.md` 회차 규약 신설. 선행 1회성 감사 = 부모 root `MEASURE-CROSSREPO-DOC-STALE-20260809.md`(→ 집행 = `archive/2026-08/cc-paste-MASTER-DOCS-STALE-SWEEP-002.md`) — 본 rule 이 그 **1회성 감사를 상설화**한다.
