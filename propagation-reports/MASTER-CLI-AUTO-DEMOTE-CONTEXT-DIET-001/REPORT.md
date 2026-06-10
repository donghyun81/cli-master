# MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001 — Propagation Report

> 자동 생성: 2026-06-10T17:16:37+0900 · master HEAD: 1b07470

---

## 1. Cycle 메타

- cycle ID: MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001
- timestamp: 2026-06-10T17:16:37+0900
- master HEAD: 1b07470
- master commit msg:
  ```
  chore(infra): MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001 context auto-demote + diet
  
  [Goal]   항상로드 context 죽은 무게 회수 + 재증식 자동 감시 + 재발 gate (audit-P2 D1+D3 · 운영 SoT 정비)
  [Diff]   CLAUDE.md(§15 hot 14→6 · -9 row +1 entry · 32,531→25,514cp) · master-cycle-history-COLD.md(94→103 verbatim) · measure-gsm-cycle.sh(+§15 hot check) · cycle-discipline.md(§23~§29 pointer 후퇴 + §22.2 gate · 43,819→36,866cp) · context-health-metrics.md(§2/§4/§6)
  [Sha]    (불변 · 보호 5 무접촉)
  [EC]     hook self-test PASS(fixture 14행 발화 · 실 6행 무발화 · exit 0) · cold verbatim 9+/9- symmetric · 구 sub-§ 참조 sweep 1건(§23.2→§23 흡수 명시) · production 0 LOC
  [Next]   propagate cycle-discipline.md + measure-gsm-cycle.sh ×5 + 자식 4 CLAUDE.md 직접 정정
  [Refs]   parent c9754f5 · MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001 · COLD-002/GSM-CONTEXT-HEALTH-ABSORB-001 전례
  
  Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>
  
  ```

## 2. 자식 repo HEAD (propagation 직후)

| repo | HEAD | branch | dirty? |
|---|---|---|---|
| GentlyBreath | d7942ea | main | 2 files |
| GentlyDay | d11cf7d | main | 1 files |
| GentlyTable | 052b91e | main | 1 files |

## 3. cross-verify 결과

`VERIFY.md` 첨부 참조.

## 4. 변경 파일 sha 비교

`DIFF.md` 첨부 참조.

## 5. 다음 단계

- 자식 repo 별 commit (master commit body 인용)
- `.auto-memory/propagation-status.md` 자동 갱신 확인
- 본 cycle 마감 시 master `CLAUDE.md` §15 표 추가

