# MASTER-LIFECYCLE-4ACTIVE-REALIGN-001 — Propagation Report

> 자동 생성: 2026-08-15T15:46:47+0900 · master HEAD: bfb8f9c

---

## 1. Cycle 메타

- cycle ID: MASTER-LIFECYCLE-4ACTIVE-REALIGN-001
- timestamp: 2026-08-15T15:46:47+0900
- master HEAD: bfb8f9c
- master commit msg:
  ```
  MASTER-LIFECYCLE-4ACTIVE-REALIGN-001: archiver 계 4-active 정합 (일수 SoT 단일화 + REPORT.md 인정 + plist 조용 skip 해소)
  
  R2 §7 확정 5항. Coin 결정 = 일수 「7」. docs+script · production 0 LOC · 보호 5 sha 무접촉.
  
  결함 4 (전부 disk 실측):
  1. working-file-lifecycle.md §3 「archive 위치 5」 가 동결 3 (GentlyBreath /
     GentlyDay / GentlyTable) 을 열거해 2026-07-17 T6 재편(4-active + 3 동결)을
     반영하지 못했다. launchd plist 실물은 이미 부모root+master+FND+PDOCS+SW =
     즉 rule 만 늙어 「쓰기 0」 인 동결 3 을 archive 대상으로 지시하고 있었다.
  2. reporting.md :18 이 mtime 「14일」 = docs/rules/ 안 유일 잔존 stale.
     script 상수는 7 이라 문면이 script 를 2배로 잘못 인용.
  3. 조기-archive 매칭이 REVIEW.md 만 조회. master cycle 산출물은 REPORT.md 뿐
     (master CLAUDE.md §11) 이라 master-cycle working file 의 PASS trigger 가
     사문화 = mtime 7일 fallback 만 남아 cc-paste 가 최대 7일 잔존 (F3 15일 잔존의 근인).
  4. plist 가 [ -x ] && run 이라 script 부재 repo 를 조용히 skip. FND/PDOCS 실배포
     부재가 로그에 한 줄도 안 남았다.
  
  변경 5:
  - docs/rules/reporting.md    14일 -> 7일 + 일수 SoT pointer(script 상수 정본)
  - docs/rules/working-file-lifecycle.md
      §3 위치 = plist 실물 5 경로와 문자열 정합 (동결 3 제거 · 정정 고지 병기)
      §1 패턴 열거 = 「script sweep_candidates() 정본 · 본 절 발췌」 pointer 형
        (구 판 5 종 -> 실측 root 9 종 + .ai/prompts) + is_excluded 2 종 반영
      §2 머리 = 일수 SoT 문단 · §4 trigger 종류 + REPORT.md PASS · §5(b) 갱신
  - scripts/working-file-archiver.sh
      REPORT_BASENAMES="REVIEW.md REPORT.md" 도입 · repo-local + sibling 양 경로 적용
      MATCH_BASENAME 로 INDEX trigger 칸에 실제 매칭 file 명 기록
      ★넓힌 것은 인정 file 집합 1 개뿐 — task ID 요건(-z 조기 return)과 PASS 판정
        함수(review_says_pass) 는 무접촉 = 마감 판정의 그 외 요건 불변
  - scripts/com.coin.working-file-archiver.plist
      [ -x ] && run  ->  if/else + echo "archiver skip: $r" 1>&2 (부재 가시화)
  - CLAUDE.md §15 entry 1 행 (397B ≤ 400B) + 상한 3 초과분 즉시 COLD demote
      (MASTER-CLI-SLOT-SPEC-AND-COMMIT-FENCE-001 -> COLD 표 말미 verbatim ·
       exact-string 대조 PASS · 14 회차 note + count 151->152 동기)
  
  게이트: G1 grep '14일' docs/rules/ = 0 hit · G2 pointer 2/2 + script :15 = 7 무변 ·
  G3 rule §3 <-> plist 5/5 문자열 일치 · G6 skip 분기 stderr 실측 3 줄 ·
  G7 실 report 데이터 대조 = REPORT.md-only cycle 3/3 MATCH via REPORT.md ·
     REVIEW.md 우선순위 무변 · 빈 task_id NOMATCH(task-ID 요건 유지 증명) ·
     report 부재 NOMATCH. plutil -lint OK · bash -n OK.
  
  선재 dirty 1 행 흡수 0 (file 단위 명시 pathspec · 디렉터리 pathspec 0).
  
  Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>
  
  ```

## 2. 자식 repo HEAD (propagation 직후)

| repo | HEAD | branch | dirty? |
|---|---|---|---|
| app-foundation | b6f34eb | main | 2 files |
| gently-product-docs | 7d80476 | main | 1 files |
| Selfward | fe58e08 | main | 2 files |

## 3. cross-verify 결과

`VERIFY.md` 첨부 참조.

## 4. 변경 파일 sha 비교

`DIFF.md` 첨부 참조.

## 5. 다음 단계

- 자식 repo 별 commit (master commit body 인용)
- `.auto-memory/propagation-status.md` 자동 갱신 확인
- 본 cycle 마감 시 master `CLAUDE.md` §15 표 추가

