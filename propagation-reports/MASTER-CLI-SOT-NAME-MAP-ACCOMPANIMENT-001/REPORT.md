# MASTER-CLI-SOT-NAME-MAP-ACCOMPANIMENT-001 — Propagation Report

> 자동 생성: 2026-07-03T12:52:52+0900 · master HEAD: e1d257d

---

## 1. Cycle 메타

- cycle ID: MASTER-CLI-SOT-NAME-MAP-ACCOMPANIMENT-001
- timestamp: 2026-07-03T12:52:52+0900
- master HEAD: e1d257d
- master commit msg:
  ```
  docs(rule): MASTER-CLI-SOT-NAME-MAP-ACCOMPANIMENT-001 line 79 GT 처방→동행 parity
  
  [Goal]   M5 cli-infra-ops — sot-code-name-map 화면명 stale-fix. GT 96f3fe4 Prescription→Accompaniment client rename 을 map 실코드 parity 로 정정. behavior 무변경 (doc only).
  [Diff]   .claude/rules/sot-code-name-map.md line 79 3 토큰 (1 ins/1 del): daily-prescription-screen→daily-accompaniment-screen · DailyPrescriptionScreen.kt→DailyAccompanimentScreen.kt · PrescriptionResultContent.kt→AccompanimentResultContent.kt. 카테고리/라우트 셀 무변경.
  [Sha]    (보호 불변) — 보호 5 file 무접촉 (edit-set ∩ 보호 = ∅ · sot-code-name-map = cli infra 권장 byte-identical). map content sha-256 fc0a5104→3aa71c62.
  [EC]     line 79 외 diff 0 · production code 0 LOC · wire literal (route prescription/table/EF/JSON) 무접촉 · 정정 근거 GT source Prescription .kt=0 · DailyAccompanimentScreen.kt+AccompanimentResultContent.kt 존재.
  [Next]   propagate.sh --targets all → 5 자식 byte-identical (3aa71c62) → verify-sync PASS.
  [Refs]   parent 16627f0 · MASTER-CLI-SOT-NAME-MAP-ACCOMPANIMENT-001 · 조율 GT-PEN-ACCOMPANIMENT-PARITY-001.
  
  Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
  
  ```

## 2. 자식 repo HEAD (propagation 직후)

| repo | HEAD | branch | dirty? |
|---|---|---|---|
| GentlyBreath | 74e665c | main | 118 files |
| GentlyDay | 30fb092 | main | 35 files |
| GentlyTable | bd44ecf | main | 48 files |

## 3. cross-verify 결과

`VERIFY.md` 첨부 참조.

## 4. 변경 파일 sha 비교

`DIFF.md` 첨부 참조.

## 5. 다음 단계

- 자식 repo 별 commit (master commit body 인용)
- `.auto-memory/propagation-status.md` 자동 갱신 확인
- 본 cycle 마감 시 master `CLAUDE.md` §15 표 추가

