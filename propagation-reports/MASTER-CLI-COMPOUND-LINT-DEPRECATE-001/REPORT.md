# MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 — Propagation Report

> 자동 생성: 2026-06-10T21:34:13+0900 · master HEAD: bb9e742

---

## 1. Cycle 메타

- cycle ID: MASTER-CLI-COMPOUND-LINT-DEPRECATE-001
- timestamp: 2026-06-10T21:34:13+0900
- master HEAD: bb9e742
- master commit msg:
  ```
  chore(infra): MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 compound-lint 인용 전량 deprecate
  
  [Goal]   Pencil → Compose 파이프라인 검증 게이트 무결 — 존재한 적 없는 compound-lint.sh 인용 전량을 실존 검증 수단으로 재배선 (의무 보존 · 수단 교체 · 정보 손실 0)
  [Diff]   33 file (+153/-122) — Stage A 비보호 운영 live 25 + Stage B 보호 5 (7줄) + manifest + CLAUDE.md(§7 행/§14a/§15) + .ai/reports 2 신설
  [Sha]    보호 5 전수 갱신 (sha-256 8): ui-spec 8502c014 · uiux-sot-refresh e3b9891d · design-sot-policy 4c566615 · pencil-uiux-workflow 2ec100bf · pencil-sot-policy ae20a79c (git-sha1 = CLAUDE.md §14a · manifest = protected-file-hashes.md)
  [EC]     잔존 grep = deprecate 라벨분 + 역사 이력행 외 0 · 실행형 인용 live 0 · ui-spec JSON parse PASS · 처분 = 재배선 61 / 제거 17 / 라벨-보존 4 / 역사 무접촉 35 (전수 117 · -i) · verify-sync = 후속 audit commit REPORT 참조
  [Next]   6-repo propagation 29 file --targets all + verify-sync + propagation-reports REPORT + audit commit
  [Refs]   parent 59f5000 · MASTER-CLI-DEAD-REF-SWEEP-001 ② HOLD 회수 · MASTER-CLI-PROTECTED-STALE-PATH-FIX-001 (보호 체인 전례 · :27 폐기 연장 · F4 동족)
  
  Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>
  
  ```

## 2. 자식 repo HEAD (propagation 직후)

| repo | HEAD | branch | dirty? |
|---|---|---|---|
| GentlyBreath | 15893cb | main | 2 files |
| GentlyDay | c75f16c | main | 1 files |
| GentlyTable | 2f9a02b | main | 1 files |

## 3. cross-verify 결과

`VERIFY.md` 첨부 참조.

## 4. 변경 파일 sha 비교

`DIFF.md` 첨부 참조.

## 5. 다음 단계

- 자식 repo 별 commit (master commit body 인용)
- `.auto-memory/propagation-status.md` 자동 갱신 확인
- 본 cycle 마감 시 master `CLAUDE.md` §15 표 추가

