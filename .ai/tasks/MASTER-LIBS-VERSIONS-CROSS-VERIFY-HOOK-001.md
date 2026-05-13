## Meta
| 항목 | 값 |
|---|---|
| TaskId | MASTER-LIBS-VERSIONS-CROSS-VERIFY-HOOK-001 |
| Created (KST) | 2026-05-13 |
| Status | DONE |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 원문 요구사항
2026-05-13 chat 안 baseline ingest stale 사고 4 회차 누적 본질 mitigation. `[versions]` ↔ `[libraries]` artifact 명 ↔ source `.kt` import 3-source 정합 cross-verify hook + rule 신설 + 5-repo propagate. handoff v8 §B-4 + baseline_ingest_stale_pattern.md memory 정합.

## 분해된 문제 진술
- 사고 #2 (`[versions] supabase = 2.6.1` ↔ `auth-kt`) + 사고 #3 (3.3.0 ↔ Kotlin 2.0.21 transitive) 모두 = `[versions]` 단독 변경 후 정합 자동 검증 부재 → compile 단계에 가서야 발견.
- mitigation 방향 = post-edit hook (PostToolUse Edit|Write matcher) 안 3-source cross-verify + warn-default + enforce mode 옵션 + rule SoT 신설.

## 성공 조건
1. `.claude/rules/libs-versions-cross-verify.md` 신설 (정책 SoT · R1 supabase naming 매핑 + R2 Kotlin 호환 매트릭스 + R3 신규 rule 추가 절차).
2. `.claude/hooks/libs-versions-cross-verify.sh` 신설 (executable · python3 inline · warn default + enforce 옵션 + self-test).
3. `.claude/settings.json` PostToolUse Edit|Write matcher 묶음 안 hook 등록.
4. self-test PASS (= foundation 측 toml `supabase = 3.0.2 + auth-kt + auth.* imports` mismatch 0 · mismatch fixture 측 R1a+R1b violation 정상 검출).
5. 5-repo propagate PASS (master + 4 자식 byte-identical · ok=12 fail=0).
6. 보호 5 sha + foundation HEAD = baseline 일치 (자식 4-repo 측 propagation cp 만 진전).
7. 산출물 4 file + decision-log entry + master 단일 commit.

## Measurable Exit Criteria
- [ ] `ls .claude/rules/libs-versions-cross-verify.md .claude/hooks/libs-versions-cross-verify.sh` — 2 file 모두 존재
- [ ] `python3 -c "import json; json.load(open('.claude/settings.json'))"` — valid JSON
- [ ] `bash .claude/hooks/libs-versions-cross-verify.sh /Users/yundonghyeon/AndroidStudioProjects/app-foundation/gradle/libs.versions.toml` — exit 0 (mismatch 0)
- [ ] `bash scripts/propagate.sh ... --targets all` — ok=12 fail=0
- [ ] `for f in <보호 5>; do git hash-object $f; done` — baseline sha 5종 모두 일치

## 비기능 요구사항
- macOS bash 3.x 호환 (`#!/usr/bin/env bash` + python3 inline · `declare -A` 사용 X).
- false positive 회피 (= trigger 조건 = libs.versions.toml 또는 `src/**/*.kt` 만 · 그 외 skip).
- self-test 안 stdin/positional 양 fallback (= text-degeneration-prevention hook patterns 동일).

## 불확실성 (UNKNOWN)
- R2 (Kotlin ↔ supabase 호환 매트릭스) = 향후 정확한 baseline 갱신 의무 (현 시점 baseline = 본 chat 측 사고 baseline 인용 + jan-tennert/supabase-kt release notes 외부 검증).
- 자식 3-repo 측 `libs.versions.toml` 안 supabase 영역 미발견 시점 검증 = 별 cycle (자식 측 의존 위치 audit).
