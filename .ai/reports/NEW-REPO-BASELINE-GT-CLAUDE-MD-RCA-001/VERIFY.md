## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `shasum -a 256 GentlyTable/CLAUDE.md GentlyDay/CLAUDE.md GentlyBreath/CLAUDE.md` | 0 | PASS — 3 sha 모두 상이 (도메인 1 섹션 차이로 정상) |
| `wc -l GentlyTable/CLAUDE.md` | 0 | PASS — 323 line (310 ± 30 범위) |
| `head -1 GentlyTable/CLAUDE.md` | 0 | PASS — `# Claude Code 운영 헌법 (CLAUDE.md)` (자식 Nested title) |
| `grep -c "Gently Master" GentlyTable/CLAUDE.md` | 1 | PASS — 0 hit (master cp title 잔존 없음) |
| `grep -E "식단\|30 ?초\|티켓\|컨디션\|처방" GentlyTable/CLAUDE.md` | 0 | PASS — 16 hit (GT 도메인 keyword 인식) |

## Verification Summary

GT CLAUDE.md 재작성 결과 5 검증 모두 PASS. master cp title 잔존 없음, 자식 Nested pattern title 채택, 도메인 keyword 16 hit 로 GT 식단 도메인 인식 가능, line 수 323 (목표 310 ± 30 범위 안).

3 자식 sha 비교:
- GT  = `0bc5cec01bc8dcbfeb91c3b8192dbdc317920fb00e0790c0a9c18afc5971aba2` (신규 · 도메인 헌법 1 섹션 추가)
- GD  = `e64117d3cb00caedb89c60aef1a471a5448afabe4c3f2509b7c4532952e24757` (불변)
- GB  = `e260bd26a96b245e9ef5408d94fc8e46f416ddfc444d2b18f688ad1baed5ab18` (불변)

3 sha 상이는 정합 강제 §2 표 (CLAUDE.md 본문 도메인 섹션 = repo-specific 자유) 정합. master propagation 무관.

## UNKNOWN (검증 불가 항목)

없음. 5 명령 모두 실행 + exit code 정상.

## LOG

```
[LOG] 2026-05-09 KST
CMD: shasum -a 256 GentlyTable/CLAUDE.md GentlyDay/CLAUDE.md GentlyBreath/CLAUDE.md
EXIT: 0
STDOUT:
  0bc5cec01bc8dcbfeb91c3b8192dbdc317920fb00e0790c0a9c18afc5971aba2  GentlyTable/CLAUDE.md
  e64117d3cb00caedb89c60aef1a471a5448afabe4c3f2509b7c4532952e24757  GentlyDay/CLAUDE.md
  e260bd26a96b245e9ef5408d94fc8e46f416ddfc444d2b18f688ad1baed5ab18  GentlyBreath/CLAUDE.md

CMD: wc -l GentlyTable/CLAUDE.md
EXIT: 0
STDOUT: 323 GentlyTable/CLAUDE.md

CMD: head -1 GentlyTable/CLAUDE.md
EXIT: 0
STDOUT: # Claude Code 운영 헌법 (CLAUDE.md)

CMD: grep -c "Gently Master" GentlyTable/CLAUDE.md
EXIT: 1 (정상 — 0 hit = grep 의 표준 동작)
STDOUT: 0

CMD: grep -E "식단|30 ?초|티켓|컨디션|처방" GentlyTable/CLAUDE.md (count)
EXIT: 0
STDOUT: 16 (hit 수)
```
