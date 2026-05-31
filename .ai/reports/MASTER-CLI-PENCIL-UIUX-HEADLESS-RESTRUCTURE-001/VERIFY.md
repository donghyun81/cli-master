# VERIFY — MASTER-CLI-PENCIL-UIUX-HEADLESS-RESTRUCTURE-001

## Verify Commands
| 명령 | Exit | 결과 |
|---|---|---|
| `grep -c '2\.1\.114' pencil-uiux-workflow.md` | — | 0 (× 5-repo · stale pin 제거) |
| `grep -ciE 'headless.*기본\|기본.*headless\|primary'` | — | 6 (≥1 · primary-path 선언 도입) |
| `grep -nE '^## ' pencil-uiux-workflow.md` | — | §1·§2·§2.5(신)·§3·§4·§5·§6·§7·§8·§9 (= 삭제/대이동 0) |
| `grep -cE '^### Type [1-5]:'` | — | 5 (= Type 1~5 step 무변경) |
| `grep -c '12 official'` | — | 1 (= 도구 list 무추가) |
| coherence (live vs manifest vs §14a) | — | live git-sha1 9d47624a == §14a · live sha-256 e6a4a2a1 == manifest == §14a note (PASS) |
| `bash scripts/propagate.sh pencil-uiux-workflow.md` | 0 | ok=4 fail=0 · **WARN noise 0** |
| `bash scripts/verify-sync.sh` | 0 | PASS 154 / DRIFT 0 / MISS 0 |

## Verification Summary
- 보호 file pencil-uiux-workflow.md: §2.5 경로 위계 선언 신설 + §9 framing 승격 + §9.1 표 headless-default + §3 cross-ref + L23/L93 stale pin 정정.
- Type 1~5 절차 step 무변경 · 도구 list 무추가 · 섹션 삭제/대이동 0.
- 양쪽 sha layer resync 정합: sha-256 d64481370d→e6a4a2a1 (manifest) · git-sha1 2ee16ae4→9d47624a (§14a) · live==manifest==§14a coherence PASS.
- 5-repo byte-identical (git-sha1 9d47624a) · verify-sync PASS 154/0/0.
- 다른 보호 4 file sha 변동 0 (= 무접촉).
- propagate WARN noise 0 (= Cycle 1.5 동적 baseline + manifest resync 정합).
- production code touch 0 LOC.

## UNKNOWN
- (없음)

## LOG
```
[LOG] 2026-05-31 KST
CMD: bash scripts/propagate.sh .claude/rules/pencil-uiux-workflow.md
EXIT: 0
STDOUT: ok=4 fail=0 · '보호 파일 baseline 변경 감지' 발화 0
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS 154 / DRIFT 0 / MISS 0
```

## 알려진 scope-out (무접촉)
- `.ai/baseline-snapshot/latest.json` 측 pencil sha = Cycle 5 D-area 후보 (자동 재생성 영역 · 본 cycle scope-out).
- verify-sync git-lock daemon 미활성 WARN = 환경 noise.
