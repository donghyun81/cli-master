---
name: disk-verification
description: Use before emitting a Recommended option, next-cycle candidate, paste source umbrella, or deciding cycle scope to measure on-disk implementation state via grep/find/git ls-files/Read. Prevents stale recommendations + surface-pattern guessing. Counterpart to paste-source-authoring skill (cowork chat side) — this skill is cli session side.
allowed-tools: Bash, Read, Grep, Glob
---

# Recommended Option Disk Verification Paradigm

> **단일 목적**: 후속 cycle 후보 / Recommended option / paste source umbrella 측 발행 직전 disk 측 이미 구현 여부 측정 의무 paradigm. cowork chat + cli session 양쪽 적용 default.
> **신설**: MASTER-CLI-RECOMMENDED-OPTION-DISK-VERIFICATION-PARADIGM-001 (2026-05-21).
> **연관 paradigm**:
> - `.claude/rules/cycle-discipline.md` §23 (= 본 skill 측 pointer default)
> - `.claude/rules/workflow-core.md` §implement Testability Seams (= 동족 paradigm default · 변동성 경계 측 인터페이스 측정 본질 정합 default)
> - `.claude/rules/code-principles.md` §2 YAGNI (= "나중에 쓸 것 으로 추가하지 않음" 정합 default · 본 paradigm 측 표면 후보 추측 차단 본질 정합)
> - `.claude/skills/paste-source-authoring/SKILL.md` (= 동족 paradigm default · cowork chat 측 paste source authoring 측 disk 실측 의무 default)

---

## §1 본 paradigm 본질

후속 cycle 후보 / Recommended option / paste source umbrella 측 발행 시점 disk 측 이미 구현 여부 측정 의무 default. 후보 영역 본문 + 권장 영역 본문 + 표면 후보 paradigm 모두 default · disk 측정 의무 default · 표면 패턴 추측 차단 default · 부분 구현 영역 측 scope 재 정의 의무 default.

본 paradigm 적용 시점 = 다음 4 영역 default:

| 적용 시점 | 본질 |
|---|---|
| 후속 cycle 후보 발행 시 | cli session 또는 cowork chat 측 다음 cycle 후보 list 산출 시점 default |
| Recommended option 발행 직전 | 단일 Recommended option 측 사용자 본심 회수 직전 시점 default |
| paste source umbrella authoring 시 | cowork chat 측 paste source 본문 작성 시점 default (= 본 §1.4 정합 default) |
| cli session 측 cycle scope 결정 시 | master cycle 또는 자식 cycle 측 scope file 영역 결정 시점 default |

---

## §2 4 의무 영역

본 paradigm 본질 = 4 의무 영역 default · 신 rule 본문 측 본 4 영역 정합 의무 default:

### §2.1 의무 ① — disk 측 이미 구현 여부 측정 의무

후속 cycle 후보 발행 시 disk 측 이미 구현 여부 측정 의무 default. 측정 명령 영역:

```bash
# file 측 검색 (= filename + content 동시 grep 의무 · cycle-discipline.md §17 정합)
find <path> -name "<file-pattern>" -type f
grep -rn "<symbol>\|<keyword>" --include="*.<ext>" <path>
git ls-files | grep "<pattern>"

# 신 rule / 신 entry 측 0 match 측정 (= 중복 신설 차단 default)
grep -r -l "<new-rule-keyword>" .claude/

# 신 paradigm 측 기존 영역 측정 (= 갱신 vs 신설 결정 default)
grep -n -i "<paradigm-keyword>" .claude/rules/<existing-rule>.md
```

표면 패턴 추측 차단 default · 본 의무 정합 시점 = cli session 측 disk 측정 명령 호출 후 결과 인용 default.

### §2.2 의무 ② — Recommended option 발행 직전 disk 측 이미 구현 여부 측정 default

직전 cycle 측 측정 마감 영역 default · 신 cycle 측 재 측정 의무 default · 표면 후보 추측 차단 default. baseline drift 영역 발견 시점 정합 의무 default (= [[feedback-baseline-ingest-stale]] 동족 paradigm default).

본 의무 본질 = "측정 결과 stale 영역 발견 시점 = Recommended option 발행 차단 default · 측정 재 호출 의무 default" default.

### §2.3 의무 ③ — 부분 구현 영역 발견 시 scope 재 정의 default

부분 구현 영역 (= 측정 대상 영역 측 일부 구현 + 일부 신 본질) 발견 시:
- cli session 자율 또는 사용자 본심 회수 default
- 신 본질 명시 default
- 표면 stale 후보 명시 X default
- scope 본질 변경 default

예시 영역 (= H29 chat 측정 default · §4.2 정합):
- foundation `EdgeFunctionInvoker.kt:27` 측 `<ResponseType>` typed seam 이미 구현 default
- 단 `requestBody: Map<String, String>` 한정 default
- `<RequestType>` typed body 영역 = 신 본질 default
- → scope 재 정의 default (= "ResponseType seam 이미 구현 default · RequestType typed body seam 신설" default)

### §2.4 의무 ④ — 완전 stale 영역 발견 시 후보 제거 또는 대체 default

완전 stale 영역 (= 측정 대상 영역 측 이미 마감 default · 신 본질 X) 발견 시:
- 사용자 본심 회수 default
- cli session 자율 default
- 본 cycle 측 스킵 default 또는 다른 영역 default

예시 영역 (= H29 chat 측정 default · §4.1 정합):
- GB 3 핵심 Repository (= `MeditationRepository.kt:17` + `BreathGuidanceRepository.kt:94` + `MeditationSessionsListRepository.kt:25`) 모두 이미 interface default
- → 완전 stale 후보 default → 후보 제거 의무 default

---

## §3 paste source authoring 영역 (= ⑤ 추가 의무 영역 default)

paste source umbrella 발행 시점 본 paradigm 정합 의무 default · 발행 자체 본 paradigm 본질 자기 정합 영역 default:

| 영역 | 본질 |
|---|---|
| §0 baseline 영역 | 5-repo HEAD sha + 보호 5 file sha + cycle scope file sha 측정 의무 default |
| §3 contract SoT 영역 | disk 측정 결과 인용 의무 default (= grep / find / `git hash-object` 측정 결과 본문 인용 default) |
| §3 기존 paradigm × N 인용 영역 | 인용 entry 측 실 disk 존재 측정 의무 default (= 가정 X · 실 disk 측 존재 entry 한정 link default) |

본 영역 위반 시점 = paste source authoring 측 paradigm 위반 default (= 자기 정합 paradigm 본질 default).

### §3.1 자기 정합 paradigm 본질

본 paradigm 자체 = 본 paradigm 신설 cycle 측 paste source umbrella authoring 시점 자기 적용 의무 default. cli session 측 본 cycle IMPL 시 신 paradigm 자기 적용 default · §0 + §3 영역 disk 측정 결과 인용 의무 default.

precedent cycle 측 측정 결과 인용 default (= precedent cycle 진입 시점 baseline default):

| 측정 영역 | 측정 결과 | precedent cycle 측 의미 |
|---|---|---|
| master `.claude/rules/` 측 `recommended-option-disk-verification` grep | 0 match default | 신 rule 신설 영역 default (= 중복 X default) |
| master `.claude/rules/cycle-discipline.md` 측 신 paradigm grep | 0 match default | 갱신 영역 default (= 신 § 신설 default) |
| master `.claude/hooks/` 측 신 hook grep | 0 match default (= 12 hook 기존 default) | 신 hook 신설 영역 default (= optional default) |
| `scripts/propagate.sh` + `scripts/verify-sync.sh` 존재 verify | 모두 존재 default | 5-repo propagation paradigm 정합 default |

---

## §4 예시 case (= 본 paradigm 위반 / 정합 영역 default)

### §4.1 예시 1 — 완전 stale 영역 발견 case (= ④ 정합 default)

```
cycle 후보 발행 = "GB-REPOSITORY-INTERFACE-EXTRACT-001"
(= GB 3 핵심 Repository → interface 추출 default)
  ↓
disk 측정 X default (= 본 paradigm 위반 default)
  ↓
사용자 본심 회수 후 발견:
- MeditationRepository.kt:17 = 이미 interface default
- BreathGuidanceRepository.kt:94 = 이미 interface default
- MeditationSessionsListRepository.kt:25 = 이미 interface default
  ↓
완전 stale 후보 default
  ↓
mitigation = 후보 제거 default (= ④ 정합 default)
```

본 paradigm 정합 영역 default:

```
cycle 후보 발행 직전 disk 측정 의무 default
  ↓
grep "^interface\|^abstract class" GB/.../repository/*.kt
  ↓
3 file 측 interface 측정 결과 PASS default
  ↓
완전 stale 영역 인지 default → 후보 제거 또는 대체 default
```

### §4.2 예시 2 — 부분 구현 영역 발견 case (= ③ 정합 default)

```
cycle 후보 발행 = "MASTER-CLI-EDGE-FUNCTION-INVOKER-SEAM-EXTEND-001"
(= EdgeFunctionInvoker seam 확장 default)
  ↓
disk 측정 X default (= 본 paradigm 위반 default)
  ↓
사용자 본심 회수 후 발견:
- foundation EdgeFunctionInvoker.kt:27 = <ResponseType> 이미 구현 default
- 단 requestBody = Map<String,String> 한정 default
- <RequestType> typed body 영역 = 신 본질 default
  ↓
부분 구현 default
  ↓
mitigation = scope 재 정의 default (= ③ 정합 default · "ResponseType seam 이미 구현 default · RequestType typed body seam 신설" default)
```

### §4.3 예시 3 — paste source authoring 측 paradigm 위반 case (= ⑤ 자기 정합 paradigm default)

```
paste source umbrella 발행 = "신 rule 본문 측 기존 paradigm × N link 인용 default"
  ↓
인용 entry × N 측 실 disk 측정 X default (= 본 paradigm 위반 default)
  ↓
cli session 측 본 cycle 진입 후 disk 측정 결과:
- 인용 entry × N 측 실 disk 측 일부 entry 부재 default
  ↓
paste source authoring 측 paradigm 위반 default (= 자기 정합 paradigm 본질 default)
  ↓
mitigation = paste-back 본문 측 명시 default
+ 신 rule 본문 측 link 영역 = 실 disk 정합 entry 한정 default
+ 사용자 본심 회수 default 또는 cli session 자율 진행 default
```

본 예시 = 본 paradigm 신설 cycle 자체 발견 case default (= 본 cycle 진입 시점 baseline default).

---

## §5 위반 시 mitigation cycle paradigm

| 단계 | 절차 |
|---|---|
| 1. 감지 | 사용자 본심 회수 또는 cli session 자율 발견 |
| 2. 분류 | ① / ② / ③ / ④ / ⑤ 중 어느 의무 영역 위반 |
| 3. 정정 | disk 측정 호출 + 결과 인용 (= 표면 추측 차단 default) |
| 4. scope 재 정의 또는 후보 제거 | ③ 또는 ④ 정합 default |
| 5. 기록 | 본 cycle 마감 시점 paste-back 본문 측 명시 default + memory entry 누적 회차 +1 default (= 본 paradigm 측 누적 누적 측정 영역 default) |

---

## §6 적용 영역

| 영역 | 적용 |
|---|---|
| cowork chat 측 다음 cycle 후보 발행 시점 | 의무 default |
| cowork chat 측 Recommended option 발행 직전 시점 | 의무 default |
| cowork chat 측 paste source umbrella authoring 시점 | 의무 default |
| cli session 측 cycle scope file 영역 결정 시점 | 의무 default |
| cli session 측 신 rule / 신 entry 신설 시점 | 의무 default (= 중복 신설 차단 default) |
| cli session 측 단순 정독 또는 측정 영역 | 적용 X default |

---

## §7 도메인 어휘 화이트리스트 (= 제외 영역 default)

도메인 어휘 측 표면 패턴 추측 차단 paradigm 측 정합 의무 X default (= 본 paradigm 본질 = 후보 / 권장 / paste source 영역 default · 도메인 source 측 본 paradigm 정합 X default).

| 도메인 | 정합 X default |
|---|---|
| 도메인 source code (= app/ + composeApp/ + core/ + src/) | 본 paradigm 정합 X default (= 자식 자율 default) |
| 디자인 SoT (= docs/design/) | 본 paradigm 정합 X default (= `pencil-uiux-workflow.md` 정합 default) |
| 빌드 / CI / tooling | 본 paradigm 정합 X default |

---

## §8 STOP 조건

| trigger | mitigation |
|---|---|
| Recommended option 발행 후 사용자 본심 회수 측 stale 영역 발견 | 즉시 STOP + scope 재 정의 default 또는 후보 제거 default (= ③ / ④ 정합 default) |
| paste source umbrella 발행 후 cli session 측 인용 entry 측 실 disk 측 부재 발견 | 즉시 STOP + paste-back 본문 측 명시 default (= ⑤ 자기 정합 paradigm default) |
| 본 paradigm 측 누적 위반 발화 (= 3 회 누적 default) | 신 cycle 진입 + mitigation 강화 cycle default (= 자동 enforce hook 신설 검토 default) |

---

## §9 인접 paradigm 정합 영역

| 인접 entry | 본질 |
|---|---|
| `.claude/rules/cycle-discipline.md` §17 BASELINE 실측 표준 (= filename + content 동시 grep 의무) | 본 paradigm 측 의무 ① 측정 명령 영역 정합 default (= filename find 1차 + container 내부 content grep 2차) |
| `.claude/rules/cycle-discipline.md` §23 (= 본 skill 측 pointer default · 신 § 신설 default) | 본 paradigm 본질 명시 영역 default · cycle scope 결정 영역 default |
| `.claude/skills/paste-source-authoring/SKILL.md` | 동족 paradigm default · cowork chat 측 paste source authoring 측 disk 실측 의무 default · 본 skill 측 §3 + §4.3 정합 default |
| `.claude/rules/workflow-core.md` §implement Testability Seams | 동족 paradigm default (= 변동성 경계 측 인터페이스 측정 본질 정합 default) |
| `.claude/rules/code-principles.md` §2 YAGNI | "나중에 쓸 것 으로 추가하지 않음" 정합 default · 본 paradigm 측 표면 후보 추측 차단 본질 정합 default |

---

## §10 본 skill 의 변경 정책

- cli infra 권장 byte-identical (= 5-repo · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable)
- 변경 시 master cycle 신설 + 5-repo propagation (= `cycle-discipline.md` §15 패턴 1 정합)
- 자식 repo 측 직접 수정 금지

---

## §11 명시 cycle 이력

- 2026-05-21 · `MASTER-CLI-RECOMMENDED-OPTION-DISK-VERIFICATION-PARADIGM-001` · 직전 rule (`.claude/rules/recommended-option-disk-verification.md`) 신설 (= paradigm 본질 + 4 의무 영역 + paste source authoring ⑤ 자기 정합 paradigm + 예시 case 3 + 위반 mitigation cycle + 적용 영역 + 인접 paradigm 정합 default) + cycle-discipline.md §23 신설 default + 5-repo byte-identical propagation
- 2026-05-26 · `MASTER-CLI-SKILLS-MIGRATION-PHASE-1-001` · 본 skill 신설 default (= 직전 rule 본문 본질 보존 default · skill paradigm 정합 default · trigger 시점 lazy load default · `.claude/rules/recommended-option-disk-verification.md` 측 thin pointer 갱신 default)
