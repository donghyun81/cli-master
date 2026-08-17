# stale-sweeps — 낡은 문면 정리 회차 기록

> 본 폴더 = `../../STALE-DEBT.md` 대장의 **정리 회차** 산출물 보관소.
> 규약 본문 = `../rules/stale-artifact-tracking.md` §5(trigger) + §6(산출).

## 파일명

`SWEEP-YYYYMMDD.md` (= 회차 1본 · 발행일 KST).

## 언제 회차를 여는가 (= rule §5)

셋 중 하나면 sweep cycle 1회 개설 — ⓐ 대장 **OPEN 10행** 누적 ⓑ **분기 1회** ⓒ **같은 좌표가 3 cycle 연속 재발**.

trigger 발동 = **개설 신호**이지 블로커가 아니다. 대장 등재 자체는 언제나 진행을 허용한다(rule §3).

## 회차 산출 필수 (= rule §6)

1. **분모** — 대장 전체 행 수 + 그중 OPEN 수. (분모 없는 처분율은 값이 아니다.)
2. **처분표** 3분류 — **고침** / **이력 판정**(= 고치지 않는다) / **이월**.
3. **자와 명령** — 무엇으로 쟀는지 재현 가능하게. 값 층 자로 적는다(= raw 행 수는 보존 주석을 분모에 넣는다).
4. **대장에서 행 삭제 0** — 해소는 대장 `status` 칸 갱신으로만.

## 두 가지 원칙

- ★**「고치지 않는다」도 처분이다.** 이력 판정 + 사유를 적으면 그 행은 종결된다. 미결로 눕혀 두지 않는다.
- ★**소급 정정 금지 영역**(= 발행 마감된 이력 산출물)의 처분은 **인용자용 주석 append 한 줄**까지다. 원문은 만지지 않는다.

## master 판 고유 (= 자매 `../../../Selfward/docs/stale-sweeps/README.md` 와 다른 유일한 축)

- 본 repo 는 **cli infra 단방향 propagation 의 source** 다. 회차가 `docs/rules/**` 또는 `.claude/rules/**` 를 만지면 그 회차는 **sweep 산출 1본 + `propagation-reports/<cycle-id>/REPORT.md` 1본 = 둘 다** 낸다 (= 부모 root `CLAUDE.md §5` 절차 산출물과 본 sweep 산출은 **별물**).
- **자식 repo 직접 수정 금지** — 자식 판 문면이 갈려 보여도 고침은 master 에서만. 자식 반영 = `scripts/propagate.sh` + `scripts/verify-sync.sh`.
