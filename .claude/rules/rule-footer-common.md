# Rule 공통 변경 정책 (footer canonical)

> 본 file = **rule file 공통** "변경 정책" 문구의 단일 canonical — 적용 범위 = `docs/rules/**` + `.claude/rules/**` (= MASTER-CLI-CONTEXT-DIET-2-001 T6 · 각 rule 꼬리 = 본 file 1줄 pointer · 파일 고유 cycle 이력 = 각 rule 잔존).
> **MASTER-DOC-MANIFEST-SWEEP-001 정정** (2026-08-29 · 구 표기 = `.claude/rules/**` 단독 · 실측 소비처 **23** = `docs/rules/` **20** + `.claude/rules/` **3**[`stop-canonical` · `cross-repo-parallel-exec` · `rule-routing-table`] + `docs/agent` 0 + `docs/design` 0 · 자 = `grep -rl 'rule-footer-common' docs/rules .claude/rules docs/agent docs/design | grep -v 'rule-footer-common.md' | wc -l` · 2026-08-29 실측 · ★`grep -v` 는 **본 file 자신**을 뺀다 — 본 정정이 위 자를 문면에 적어 넣은 순간 **canonical 이 자기 자를 물게 됐다**(자기 인용 0 → 1) · 자기 제외 없이 재면 **24**). ★구 표기는 **DIET-2-003 이 44 rule 을 `docs/rules/` 로 옮길 때 따라오지 않은 문면**이다 — 소비처의 87% 가 범위 밖으로 읽혔다.

- **cli infra 권장 byte-identical** (= 4-repo · master + app-foundation + toward-product-docs + Selfward · 보호 5종 아님 — 보호 5종 = 각 file 자체 보호 절차 우선 · `cycle-discipline.md` §10).
- **변경 시 master cycle 신설 + 4-repo propagation** (= `cycle-discipline.md` §15 패턴 1 · `scripts/propagate.sh` + `scripts/verify-sync.sh` exit 0).
- **동결 3 (GB/GD/GT) = 전파 대상 X · 쓰기 0** (= 2026-07-17 T6 재편 · 계승 원천 원본 보존 · read-only 인용만 · master `CLAUDE.md` §1.3).
- **자식 repo 직접 수정 금지** (= 단방향 정합 · master `CLAUDE.md` §3~§4 · drift = master 정정 cycle).
- **이력 절 등재 의무** — rule file 의 **절을 신설·개정하는 cycle** 은 그 file 의 「명시 cycle 이력」 절에 entry 를 추가한다 (= master `CLAUDE.md §16-1`[= `CLAUDE.md §15` **표 한정**] 의 rule file 판). ★**다른 cycle 을 인용만 하는 헤더는 대상 아님** — 헤더에 cycle ID 가 있다 ≠ 그 cycle 이 그 절을 만들었다 · 자는 **귀속**과 **인용**을 못 가른다(= `verification-and-review.md` §0.3 K-133). 신설 = 2026-08-29 `MASTER-DOC-MANIFEST-SWEEP-001` · 근거(실측) = 등재 의무 문면 **전수 0**(자 = `grep -rlE '이력 절 등재 의무|이력 등재 의무|이력 append|cycle entry 추가' docs .claude CLAUDE.md scripts --include='*.md'` = `CLAUDE.md §16-1` 단독 hit · 그 §은 `CLAUDE.md §15` **표에만** 의무를 진다) · 양성대조 = 「명시 cycle 이력」 절 **보유** file **15**(자 = `grep -rl '명시 cycle 이력' docs/rules .claude/rules CLAUDE.md | grep -v 'rule-footer-common.md' | wc -l` · ★`grep -v` 이유 = 위와 동형 — **본 bullet 이 대상 절 이름을 적어 넣어** 자기 제외 없이 재면 **16** · 본 file 은 절 **보유**가 아니라 **의무 서술** · 넓힌 트리[`docs` + `.claude` + `.auto-memory` + `scripts`] = **29**) ⟹ 있던 것은 **규약이 아니라 관례**였다(= 진성 헤더 20 중 등재 17).
  - ★**「신설·개정」 판정선** (= 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-003` · Coin 결정 #192): **「헤딩 증감 > 0」 OR 「순증 ≥ 5 행」** 이면 등재 대상이다. **자** = 그 file 한정 `git show --numstat <sha> -- <path>`(순증 = 추가 − 삭제) × 그 file diff 의 `^[+-]#\{1,\} `(= **깊이 무관** · 상한 없는 수량자 · 이유 = 아래 `08104e9`). ★**둘은 OR 이지 AND 가 아니다** — 어느 한쪽만 넘어도 등재다.
  - ★**헤더 증감은 충분조건이지 필요조건이 아니다.** 헤더 ± 0 인데 등재된 선례 **2** = `b3a8857` · `3551bf5` (= 둘 다 `reporting.md` · 자 = `git show --format= <sha> -- '*rules/reporting.md' | grep -c '^[+-]#\{1,\} '` = **0** · 그럼에도 절 내용이 바뀌었다). **헤더만 재면 본문 개정을 통째로 놓친다.**
  - **경계 실측** (= 2026-08-30 재현 · 단위 = 행 · 분모 = 각 commit 이 만진 **그 rule file**):

    | commit | file | numstat | 순증 | 헤더±(깊이 무관) | 판정 |
    |---|---|---|---|---|---|
    | `bfb8f9c` · `a47f61d` | `reporting.md` | 1/1 | **0** | 0 | 미등재 |
    | `558af38` | `reporting.md` | 2/2 | **0** | 0 | 미등재 |
    | `bb9e742` | `reporting.md` | 4/4 | **0** | 0 | 미등재 |
    | `9e28613` | `reporting.md` | 7/1 | **+6** | 1 | **등재** |
    | `cf063a8` | `reporting.md` | 9/208 | **−199** | 32 | **등재**(헤더 축이 잡는다) |
    | ★`08104e9` | `pencil-mcp-tools-reference.md` | 67/0 | **+67** | **0**(깊이 1~3) / **6**(깊이 무관) | **등재** — ★**깊이를 제한한 자로는 못 잡는다** |

  - ★**판정선 「5」의 근거 정정** (= 본 판 실측 · 발주 §9-④ 회부): 발주는 경계를 「**4/4 ↔ 7/1** 사이 = 4 와 7 사이 어디든 근거가 같다」로 적었으나, 그것은 **추가 행(gross)** 칸을 읽은 것이고 **판정선의 축은 순증(net)** 이다. 순증으로 재면 미등재 4 건 = **전부 0** · 등재 최소 = **+6** ⟹ 실측이 지지하는 구간은 **[1, 6]** 이지 (4, 7) 이 아니다. **5 는 그 구간 안이라 값은 살아남지만, 값을 정당화한 자가 틀렸다.** 값 변경 = Coin 결정 사항이라 **유지**하고 구간만 정정한다 (= 「자를 썼다는 것은 옳은 자라는 증거가 아니다」 · `MASTER-MEASURE-DISCIPLINE-001` 정합).
  - ★**rename 은 대상 아님** — 경로 이동에 딸린 content churn 은 절 개정이 아니다. 실측 = `de37a6e`(`R097 {.claude => docs}/rules/reporting.md` · 3/3 · 자 = `git show --name-status -M`). ★**`-M` 없이 재면 rename 이 「삭제 + 신설」로 보여 등재 대상으로 오판된다.**

---

## 명시 cycle 이력

> ★**본 절 신설 = 본 file 이 자기 의무의 대상이라는 판정** (= 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-003` · 발주 §9-⑥ 이 「내가 판정하지 않았다」로 넘긴 항). **판정 = 대상이다.** 근거 ⑴ 본 file 경로 = `.claude/rules/` = 위 `:3` 이 선언한 적용 범위 **안** ⑵ 본 판이 `:10` bullet 을 **개정**했고 위 판정선의 두 축을 **자기가 넘는다** ⑶ 의무 문면에 **자기 예외 조항이 없다**. ★**반대 근거로 쓸 뻔한 것** = `:4` 의 「본 file 은 절 **보유**가 아니라 **의무 서술**」 — 그러나 그 문장은 **양성대조 계수에서 자기를 뺀 이유**를 적은 것이지 **의무에서 면제**한다는 뜻이 아니다. ★**의무를 쓴 file 이 자기를 면제하면, 그 의무는 자기 자신을 반례로 갖는다** — 이 트랙이 고치려는 바로 그 형태다(= `MASTER-DOC-MANIFEST-SWEEP-001` 「문면이 자기를 틀리게 적으면 다음 사람의 분모가 된다」).

- 2026-08-30 · `MASTER-DOC-MANIFEST-SWEEP-003` · **`:10` 「이력 절 등재 의무」 bullet 개정** (= 「신설·개정」 **판정선** 명문화 = 「헤딩 증감 > 0」 OR 「순증 ≥ 5 행」[Coin 결정 #192] + ★**헤더 증감 = 충분조건이지 필요조건 아님**[h±0 등재 선례 2 = `b3a8857`·`3551bf5`] + **경계 실측표 7 commit** + ★**판정선 「5」의 근거 정정**[발주가 읽은 gross 칸 (4,7) → 실측 순증 축 **[1,6]** · 값 유지 · 구간 정정 · Coin 회부] + ★**rename 제외**[`de37a6e` `R097` · `-M` 없이 재면 오판]) + **본 절 신설**(= 위 판정 근거 3). 근거(실측 2026-08-30) = 판정선 문면 **전수 0**(자 = `grep -c '신설·개정' <본 file>` = **1** = 의무 문장 자신뿐 · 하한 서술 0) ⟹ **판마다 자가 갈렸다**(= `08104e9` 를 T2 는 67/0 으로, T3 는 헤더 0 으로 재서 **같은 file 에서 두 자가 반대 판정**). §1~§9 bullet **무접촉**.
