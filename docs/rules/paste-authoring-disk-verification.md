# Paste Source Umbrella Authoring 측 Disk 실측 의무 — thin pointer

> **본문 단일 SoT** = [`.claude/skills/disk-verification/SKILL.md`](../../.claude/skills/disk-verification/SKILL.md) (= **2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 통합** · 구 `paste-source-authoring` skill → `disk-verification` 로 흡수 · authoring 측 의무 = 그 §2 책임 분리 + §4 의무 ⑤ · 사례/인접표/이력 = 그 `references/`).
>
> 본 file = thin pointer default (= `MASTER-CLI-SKILLS-MIGRATION-PHASE-1-001` 마감 default · 2026-05-26 default · L1-4 단일 SoT paradigm 정합 default · Anthropic Skills paradigm 정합 default · trigger 시점 lazy load default · token savings 정합 default).
>
> 통합 사유 = 구 2 skill 이 **서로를 순환 참조**했다 (`disk-verification §3` ↔ `paste-source-authoring §8`) — 같은 원칙의 cowork 측 / cli 측 두 적용면일 뿐이라 한 body 로 합치고 **책임 분리는 §2 단일 SoT 로 보존**했다 (= 구 `paste-source-authoring §12` 가 통합 후보에 붙였던 조건).
>
> 기존 pointer × N (= `cycle-discipline.md §26` + `CLAUDE.md §15` 등) = 본 file path 정합 default (= 무접촉 default · L1-4 단일 SoT paradigm 정합 default · SoT 위치만 rule body → skill body 이동 default · pointer × N file path 본질 보존 default).

---

## Migration 이력

- 2026-05-22 · `MASTER-CLI-PASTE-AUTHORING-DISK-VERIFICATION-PARADIGM-001` · 본 rule 신설 default (= 215 lines · 12 section default · trigger 기반 paradigm + 3 의무 영역 + paste-back verify 의무 본문 + cli session 자율 paradigm + STOP 조건 + 적용 영역 + 자기 정합 paradigm 본질 default)
- 2026-05-26 · `MASTER-CLI-SKILLS-MIGRATION-PHASE-1-001` · 본 rule body → `.claude/skills/paste-source-authoring/SKILL.md` 측 이동 default (= 옵션 A thin pointer paradigm 정합 default · 본문 본질 보존 default · 기존 pointer × N 무접촉 default · L1-4 단일 SoT paradigm 정합 default)
- 2026-07-26 · `MASTER-CLI-MEASUREMENT-DISCIPLINE-001` · 본 file 이 **원 정착처로 지정**됐으나 **thin 유지 판정** (= 본 file 은 본문 0 · 본문 SoT = 위 skill body 이고, 그 skill 은 본 cycle 무접촉 영역 default). 판정 근거 = 본 cycle 2 규칙이 **cowork authoring 전용이 아니라 cli 측정·집행에도 걸리는 층** → authoring skill body 가 아니라 `docs/rules/` 본문으로 착지. **정착 좌표**: ① **부재 판정 = 전수 트리에서만** (= subset 위 "없다" 무효 · 「판정 보류」 표기 · 위임 범위 명시 · 받은 부재 보고 회수 시 재측정 · 실측 **5회**) → [`code-principles.md` §2 「부재는 전수 트리에서만 판정한다」](./code-principles.md) (= 기존 「표면 속성으로 분류하지 않는다」의 ***부재* 축** · 그 절의 실측 3 사례와 같은 자리) ② **paste 발행 전 scope × 제외 교차 검사 + 집행자 대칭 의무** (= 문면×문면 + **문면×밴드/수치** · 실측 **3회**) → [`cycle-discipline.md` §31](./cycle-discipline.md). 본 file **본문 복제 0** (= 중복 박제 = 재drift 원인).
- 2026-07-29 · `MASTER-CLI-CONTEXT-DIET-3-001` · 본문 SoT file 이 `paste-source-authoring/SKILL.md` → **`disk-verification/SKILL.md` 로 통합 이동** (= 구 2 skill 순환 참조 해소 · 34,733 → 21,730B[본문 8,121 + references 13,609] · 본문 전량 보존 = 삭제 0 · skill 내 STOP 표의 canonical 3 항 재복제 제거 → `stop-canonical.md` pointer). 본 thin pointer = **thin 유지** (= 본문 복제 0 · pointer 대상만 갱신).
- 2026-07-26 · `MASTER-CLI-RULES-SETTLE-001` · 본 rule 소관 2 규칙이 **본문 SoT (= 위 skill body) 에 정착** — **§4.5 커밋 file 집합 대조 의무**(= D-6 · `git show --name-only <sha>` vs paste §2 scope 대조 · diff 기준 자기 점검이 커밋 오염을 못 잡는다) + **§4.6 수치 인용 = 산출 명령 + 환경 동반**(= A-5′ · aggregate 해시 = drift 검출기 · 형식 canonical = `reporting.md` §8.1). 본 thin pointer 는 **thin 유지**(= L1-4 단일 SoT paradigm 정합 · 본문 복제 0 · 정착 좌표만 본 이력에 기록).
- 2026-08-29 · `MASTER-ENGINEERING-BASELINE-001` · 본 rule 소관 영역(= 발주 authoring 측 **자기 검사**) 규칙이 **본문 SoT 에 정착** — 정착 좌표 = [`disk-verification/SKILL.md`](../../.claude/skills/disk-verification/SKILL.md) **§4 의무 ⑥ + ⑥ 세부**(= 신 발주 필수 요건 5칸[의존성 3축 · 예측 red 실행 · 문서·주석 · 부채 원장 번호 · 회귀 그물] + 판 경계 1줄 + **자기 정합 3 자** K-142 대상×절 교차표 / K-143 「다른 계약」 1열 빈칸 금지 / K-131 게이트 = 계약 축). 본 thin pointer 는 **thin 유지** · **본문 복제 0** (= 위 2026-07-26 행의 판정 계승 · 중복 박제 = 재drift 원인).
