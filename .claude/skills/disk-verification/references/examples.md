# disk-verification — 예시 case + 자기 정합 사례

> 본 file = [`../SKILL.md`](../SKILL.md) §8 분할물. 판정 자체엔 매번 필요하지 않다 (= 사례 층).
> 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 분할 · 구 `disk-verification §4` + `paste-source-authoring §4.3`·`§8` verbatim 이전 (= 삭제 0).

---

## §1 예시 1 — 완전 stale 영역 발견 (= 의무 ④)

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

정합 영역:

```
cycle 후보 발행 직전 disk 측정 의무 default
  ↓
grep "^interface\|^abstract class" GB/.../repository/*.kt
  ↓
3 file 측 interface 측정 결과 PASS default
  ↓
완전 stale 영역 인지 default → 후보 제거 또는 대체 default
```

## §2 예시 2 — 부분 구현 영역 발견 (= 의무 ③)

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

## §3 예시 3 — paste source authoring 위반 (= 의무 ⑤ 자기 정합)

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

본 예시 = paradigm 신설 cycle 자체 발견 case default.

---

## §4 자기 정합 사례 (= precedent cycle 측 실 측정 결과)

### §4.1 `MASTER-CLI-RECOMMENDED-OPTION-DISK-VERIFICATION-PARADIGM-001` 진입 baseline

| 측정 영역 | 측정 결과 | cycle 측 의미 |
|---|---|---|
| master `.claude/rules/` 측 `recommended-option-disk-verification` grep | 0 match default | 신 rule 신설 영역 default (= 중복 X default) |
| master `docs/rules/cycle-discipline.md` 측 신 paradigm grep | 0 match default | 갱신 영역 default (= 신 § 신설 default) |
| master `.claude/hooks/` 측 신 hook grep | 0 match default (= 12 hook 기존 default) | 신 hook 신설 영역 default (= optional default) |
| `scripts/propagate.sh` + `scripts/verify-sync.sh` 존재 verify | 모두 존재 default | 4-repo propagation paradigm 정합 default |

### §4.2 `MASTER-CLI-PASTE-AUTHORING-DISK-VERIFICATION-PARADIGM-001` 측 paste umbrella 자체

그 cycle 의 `cc-paste-MASTER-CLI-PASTE-AUTHORING-DISK-VERIFICATION-PARADIGM-001.md` 자체가 3 의무 영역 사례 default:

- **§0.4 disk 측정 결과 인용 default** (= `paste-authoring-disk-verification` keyword grep `0 match` + `.claude/rules/` 측 기존 rule 수 `37 file` + `recommended-option-disk-verification.md` 존재 verify ✓ + `initiatives-auto-sync.md` 존재 verify ✓ + `cycle-discipline.md` 측 §26 영역 grep `0 match` + `scripts/propagate.sh` + `scripts/verify-sync.sh` 존재 verify ✓ default)
- **§2.1 file path 모두 disk verify default** (= `docs/rules/paste-authoring-disk-verification.md` 0 match grep verify ✓ + `docs/rules/cycle-discipline.md` 존재 verify ✓ + `CLAUDE.md` 존재 verify ✓ default)
- **§3 contract SoT byte-identical quote default** (= `initiatives-auto-sync.md` 12 section 인용 + `cycle-discipline.md §25` line 672~698 인용 + `recommended-option-disk-verification.md` §3 line 84~108 인용 default)

### §4.3 paste-back verify 본문 형식 (= cli 측 `[EC]` 권장 본문)

```
[EC]   <기존 verify 본문> · paste source 측 명시 file × N disk 측정 결과 정합 verify ✓ (= scope file × N 측 실 disk 존재 default 또는 cli session 자율 scope 재 정의 마감 default) · §3 contract SoT 측 인용 entry × N byte-identical quote verify ✓
[Diff] <기존 변경 file list> · disk 측정 결과 정합 영역 default
```

---

## §5 trigger baseline 사고 (= 본 paradigm 이 생긴 이유)

H36 chat 측 `3REPO-CRITICAL-PATH-PROGRESS-001` cycle GB scope 재 정의 사고 default (= paste source umbrella 측 `BreathSessionRepository.kt` + `BreathSessionDao.kt` 명시 default · 실 disk 부재 default ⚠ · 실 disk = `MeditationSessionsListRepository.kt` 정합 default · cli session 측 자율 scope 재 정의 마감 default · 본 사고 재발 risk 회피 default).

## §6 위반 시 mitigation cycle 절차

| 단계 | 절차 |
|---|---|
| 1. 감지 | 사용자 본심 회수 또는 cli session 자율 발견 |
| 2. 분류 | ① / ② / ③ / ④ / ⑤ 중 어느 의무 영역 위반 |
| 3. 정정 | disk 측정 호출 + 결과 인용 (= 표면 추측 차단 default) |
| 4. scope 재 정의 또는 후보 제거 | ③ 또는 ④ 정합 default |
| 5. 기록 | 본 cycle 마감 시점 paste-back 본문 측 명시 default + memory entry 누적 회차 +1 default |
