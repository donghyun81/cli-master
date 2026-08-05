# MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001 — Propagation Report

> 자동 생성: 2026-08-05T16:02:10+0900 · master HEAD: 49eadde

---

## 1. Cycle 메타

- cycle ID: MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001
- timestamp: 2026-08-05T16:02:10+0900
- master HEAD: 49eadde
- master commit msg:
  ```
  docs(rules): MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001 — auth-rules email-first 재정의 (R-BN 집행) + §15 entry 1·demote 1
  
  auth-rules.md 의 「익명 부트스트랩 = default」 서술이 활성 자식(SW) 실체와 발산 ⟹ 본 cycle 이 회수.
  근거 계보 = DECISION-SELFWARD-EMAIL-FIRST-SIGNUP-20260804(익명 폐지 확정) → FND-OTP-GATEWAY-001/-002
  (FND 표면 착지) → SELFWARD-P2PRIME-EMAIL-FIRST-001(SW 재배선 완결).
  
  문면 삭제 0 — 삭제가 아니라 스코프 라벨 + 신설 § 로 현행 default 를 세우는 형태:
  - :1 제목 + :3 단일 목적 = email-first 반영 (활성 자식 = Selfward)
  - §1 익명 부트스트랩 = 「default · 30 초 UX 정합」 라벨 회수 → 동결 3 계보 + FND
    AnonymousAuthBootstrap 존치 표면 한정으로 재스코프 (SW 신규 배선 금지 라벨)
  - §1b 신설 (활성 default) — signInWith(OTP){createUser=true} → verifyEmailOtp(OtpType.Email.EMAIL)
    · gateway email-first op 5 + EmailOtpAuthenticator op 6 · AAB 와 Mutex 비공유 = 동시 배선 금지
    · 세션 부재 = 실패 착지(익명 fallback 0) · signOut = SignOutScope.LOCAL + clearSession 사후 불변식
    · 수신 주소 변경 = uid 불변 가드
  - §4 signOut 재정의 (구 문면 = 동결 계보 한정 라벨로 보존) · §5.2 userId 어휘 이관
  - §6 OAuth = 「익명 user 마이그레이션」 전제 사망 → email-first 계정 OAuth link 로 이관
  - §7 STOP 무변 (본 전환도 그 STOP 을 통과 · 해제 문서 = FND-OTP-GATEWAY-001 paste · §10 박제)
  
  §1b 사실 주장 = FND disk 실측 대조 (anchor A5):
    SupabaseAuthSessionGateway.kt:53 createUser=true · :70 OtpType.Email.EMAIL
    · :99 signOut(SignOutScope.LOCAL) → :103 clearSession()
    EmailOtpAuthenticator.kt:44 / AnonymousAuthBootstrap.kt:33 = 각자 private Mutex (분리 확증)
    EmailOtpAuthenticator :146-151 uid 불변 가드 (부재 ≠ 다름 구분)
  
  CLAUDE.md §15 = entry 1 append (399B ≤ 400B) + 상한 3 초과분 demote 1
    (MASTER-CLI-CONTEXT-DIET-3-001 → master-cycle-history-COLD.md verbatim · exact-string 실재 확인
     hot 0 / cold 1 · lineage 149→150 + 12 회차 성격 note · 재수록 2 와 구분 명시)
  
  보호 5 무접촉 · rule-footer-common 무접촉(sha 무변) · docs/rules 밖 0 · 동결 3 쓰기 0.
  타 rule 파일 「익명」 서술 = 편집 금지 · 좌표 보고만 (scope 확장 = STOP · 별 cycle 회부).
  
  Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>
  
  ```

## 2. 자식 repo HEAD (propagation 직후)

| repo | HEAD | branch | dirty? |
|---|---|---|---|
| app-foundation | 35d70a9 | main | 2 files |
| gently-product-docs | 3b67040 | main | 1 files |
| Selfward | 58a05bc | main | 70 files |

## 3. cross-verify 결과

`VERIFY.md` 첨부 참조.

## 4. 변경 파일 sha 비교

`DIFF.md` 첨부 참조.

## 5. 다음 단계

- 자식 repo 별 commit (master commit body 인용)
- `.auto-memory/propagation-status.md` 자동 갱신 확인
- 본 cycle 마감 시 master `CLAUDE.md` §15 표 추가

