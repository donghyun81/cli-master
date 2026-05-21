# Text Degeneration Prevention Policy

> **단일 목적**: autoregressive LLM 의 token-level degeneration (= 동일 어절 / 형태소 / n-gram 의 반복 강화) 을 출력 단계에서 감지·차단.
> **신설**: MASTER-DEGENERATION-PREVENTION-POLICY-001 (= ledger MASTER-T09 · 2026-05-12).
> **연관**:
> - `cycle-discipline.md` §15 패턴 1 (master cycle 신설 + 5-repo propagation)
> - `.claude/hooks/post-edit-degeneration-check.sh` (PostToolUse 자동 검사)
> - `code-principles.md` §4 reviewer 체크리스트 (작성 직전 mental scan 항목)
> SOT: `CLAUDE.md`

---

## 1. 왜 필요한가

autoregressive sampling 의 구조상, 직전 context 에서 빈번하게 등장한 token 은 다음 단계에서 확률이 강화된다 (positive feedback). 한 어절을 4~5 회 사용한 출력은 그다음 sampling 에서 또 같은 어절을 뽑을 확률이 더 커진다. 결과 = 한 형태소가 출력 전체를 점령하는 표현 빈곤화. 의미 정확도 손실 + 가독성 손실 + 다음 cycle 의 prompt context 오염.

실측 baseline (본 cycle 진입 시점 · 5-repo 안):

| 출처 | 형태소 cluster | 등장 횟수 |
|---|---|---|
| `architecture-foundation-link-policy.md` | "박음" | 110 |
| `architecture-foundation-link-policy.md` | "박은" | 61 |
| `decision-log.md` (이전 trail) | "박" 어근 | 37+ |
| master 2 commit body (TRAIL-7) | "박" 어근 | 100+ |

mitigation 의 방향 = 단일 어휘 차단이 아니라 메커니즘 차단. 즉 n-gram metric 기반 사후 검출 + paraphrase 의무 + session reset trigger 의 3 층 방어.

## 2. 핵심 원칙 — 메커니즘 차단, 단어 차단 X

**Anti-pattern: paraphrase 단어 매핑 list**

```text
# BAD — root cause 를 우회한다
"박음" → "스며듦" → "삽입" → ...  (1:1 치환만 한 결과)
"영역" → "scope" → "범위" → "영역"  (synonym 회전)
```

이유 = 한 형태소 cluster 를 다른 cluster 로 옮긴 효과뿐, sampling 회로의 positive feedback 자체는 그대로다. 새 cluster 에서 그 사고가 재발한다.

**올바른 mitigation**:
1. 문장 구조 다양화 (능동 / 수동 / 명사구 / 종속절 / 병렬절 교체)
2. 동일 의미를 다른 품사 / 구절 형태로 회전
3. 도메인 핵심 어휘만 그대로 유지 (= §5 화이트리스트)
4. n-gram metric 으로 사후 검출 + paraphrase 재시도

## 3. 3 metric 정의

다음 셋 중 하나라도 위반하면 degeneration 으로 분류한다.

| metric | 임계값 | 측정 방법 |
|---|---|---|
| **M1 — 한 문장 동일 token** | 같은 form 이 한 문장 안에서 **3 회 초과** | 마침표 / 줄바꿈 / 물음표 / 느낌표로 문장 분할 후 token count |
| **M2 — 한 문단 동일 token** | 같은 form 이 한 문단 안에서 **5 회 초과** | 빈 줄로 문단 분할 후 token count |
| **M3 — file 전체 z-score** | 한 token 의 빈도가 (평균 + 3·stddev) 초과 + 절대 5 회 이상 | 전체 token 분포 산출 후 z-score |

세 metric 모두 §5 화이트리스트 제외 후 적용. 도메인 핵심 어휘는 반복이 자연스러우므로 측정 대상에서 빠진다.

token 의 단위 = **whitespace + 구두점으로 분할된 어절**. 한국어 조사 stem 일치 (예: "의무" 와 "의무가") 검출은 본 cycle scope 외 (추후 별 cycle 보강 후보).

## 4. paraphrase 의무 (source 무관)

다음 어떤 출처에서도 어휘 / 표현을 그대로 누적 사용하지 않는다.

1. **사용자 prompt** — 사용자가 쓴 표현을 그대로 받아 쓰지 X. 의미만 보존, 표현은 새로 선택.
2. **handoff / `.auto-memory/*` entry** — 이전 cycle 의 표현 그대로 받아 쓰지 X.
3. **이전 cycle 의 결과물** (decision-log / incident-log / commit body / markdown SoT) — 인용 시 quote 부호 명시 + quote 외 본문은 다른 표현.
4. **이전 turn 의 자기 출력** — 한 turn 또는 직전 turn 의 표현을 그대로 반복 X.

paraphrase 시 동의어 1:1 치환만 하면 §2 의 anti-pattern 으로 빠진다. 문장 구조 자체를 함께 바꾼다.

## 5. 도메인 어휘 화이트리스트

다음 token 은 빈도 측정에서 제외 (반복 OK).

```
# domain SoT
repository, repo, master, cycle, commit, propagation, propagate,
file, sha, baseline, hook, agent, schema, cli, infra, build,
claude, code, anthropic, supabase, pencil, compose, kotlin,
verify, review, plan, evidence, todo, mode, compound, lint,
auth, billing, data, perf, api, sdk, db, sot, ssot,
json, http, https, url, uuid, sql, html, css, xml, yaml, toml,

# common Korean function words (조사 cluster 일부)
그리고, 또는, 그러나, 그래서, 즉, 따라서

# numeric noise excluded by token shape
```

추가 어휘 union = `abbreviation-policy.md` §3 allowed acronym list (hook §6 자동 인식 · 직전 `allowed-acronyms.md` 본문 흡수 default · MASTER-CLI-CLEANUP-7CYCLE-001).

## 6. 자동화 hook 연계

`.claude/hooks/post-edit-degeneration-check.sh`:

| 항목 | 값 |
|---|---|
| trigger | PostToolUse (matcher = `Edit\|Write`) |
| 대상 확장자 | `.md` `.txt` (정책 / 보고서 / decision-log / handoff — prose-bearing) |
| 제외 경로 | `build/` `.gradle/` `generated/` `.git/` `.ai/reports/` `node_modules/` `archive/` `propagation-reports/` |
| 측정 | §3 의 M1 + M2 + M3 동시 적용 |
| 출력 | stderr · 위반 token list + sample sentence (앞 80 char) |
| default mode | `warn` (exit 0 · stderr 경고만) |
| enforce mode | env `DEGEN_ENFORCE=enforce` (exit 2 차단) |
| self-test | `bash .claude/hooks/post-edit-degeneration-check.sh <path>` (positional argument fallback) |

settings.json PostToolUse 에 `Edit|Write` matcher 로 등록한다 (`post-policy-watch.sh` 와 동일 hook 묶음).

## 7. 작성 직전 mental scan (자기 점검 3 step)

산출물 (commit body / markdown SoT / `.auto-memory` entry / decision-log) 작성 직전 의무:

1. **scan A — sentence level**. 한 문장 안 동일 form 3+ 회 등장 여부? 발견 시 동의어 + 구조 함께 교체.
2. **scan B — paragraph level**. 한 문단 안 동일 form 5+ 회 등장 여부? 발견 시 문단 분할 또는 표현 분산.
3. **scan C — overall**. file 전체에서 도메인 외 한 token 이 20+ 회 등장? 발견 시 전체 rewrite.

scan 통과 후 출력 → PostToolUse hook (§6) 가 사후 재검증.

## 8. context oversaturation → session reset 권장

다음 신호 = degeneration 이 임계에 도달한 상태.

- 한 turn 출력에서 한 token 이 10+ 회 등장
- 연속 3 turn 동안 동일 phrase 가 hook warn 으로 잡힘
- 사용자가 직접 "/clear" 또는 "context reset" 을 요청

신호 발견 시 절차:
1. 진행 중 cycle 의 PLAN / EVIDENCE / TODO 의 path pointer 를 handoff.md (또는 `cycle-handoff.md`) 에 보존
2. 사용자에게 session reset 권장 (= 새 conversation 진입 후 handoff 기준 재개)
3. 새 conversation 첫 출력 = handoff path pointer 만 읽고 시작 (bulk read 금지)

## 9. 적용 영역

| 결과물 종류 | 적용 | hook 자동 |
|---|---|---|
| commit body (6 section · `cycle-discipline.md` §7) | 의 | ✗ (별 step) |
| `.claude/rules/**.md` | 의 | ✓ |
| `.claude/agents/**.md` | 의 | ✓ |
| `.auto-memory/decision-log.md` + `incident-log.md` entry | 의 | ✓ |
| `.ai/reports/<taskId>/{PLAN,EVIDENCE,VERIFY,REVIEW,TODO}.md` | 의 | ✗ (제외 경로 — task-local) |
| `docs/agent/**.md` | 의 | ✓ |
| `docs/release-readiness/PACKAGE-OVERVIEW.md` | 의 | ✓ |
| 도메인 source (`.kt` / `.swift` / `.ts` 등) | ✗ (= `abbreviation-policy.md` §1~§2 scope) | ✗ |

## 10. STOP 조건

- hook self-test 위반 (= 본 SoT 또는 hook script 자체가 §3 metric 위반)
- 신규 rule / decision-log entry 작성 시 hook 가 `enforce` mode 에서 차단
- 사용자가 직접 degeneration 신호를 지적 → 진행 중 출력 중단 + paraphrase 재시도

## 11. mitigation cycle 패턴

| 단계 | 절차 |
|---|---|
| 1. 감지 | hook warn 또는 사용자 지적 |
| 2. 분류 | M1 (sentence) / M2 (paragraph) / M3 (file-wide) 중 어느 metric |
| 3. 정정 | 동의어 + 구조 동시 교체 (§2 anti-pattern X) |
| 4. 재검증 | hook 재 실행 → exit 0 확인 |
| 5. 기록 | 한 줄 entry 를 `incident-log.md` append (반복 cluster + 출처) |

## 12. 본 SoT 의 변경 정책

- cli infra 권장 byte-identical (5-repo · master + 4 자식)
- 변경 시 master cycle 신설 + 5-repo propagation (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## 13. 명시 cycle 이력

- 2026-05-12 · MASTER-DEGENERATION-PREVENTION-POLICY-001 · 본 SoT 신설 + hook `post-edit-degeneration-check.sh` + settings.json PostToolUse 등록 + 5-repo propagation
