# Runtime Crash Mitigation Process Paradigm SoT

> **단일 목적**: 자식 repo (= GB / GD / GT) 측 Android runtime crash 발견 시점 cli session 측 mitigation process paradigm 영구 SoT. trigger 기반 paradigm default (= 매번 runtime verify 회피 default · runtime crash 발견 시점 진입 default · 외부 동기화 덜 된 영역 false positive 회피 default).
> **신설**: MASTER-CLI-RUNTIME-CRASH-MITIGATION-PROCESS-PARADIGM-001 (2026-05-22).
> **precedent**: `3REPO-RUNTIME-CRASH-DIAGNOSIS-001` (= H32 chat 마감 default · Sentry `SentryInitProvider` 자동 init 측 empty DSN crash 차단 default · `<meta-data android:name="io.sentry.auto-init" android:value="false" />` × 3 자식 byte-identical mitigation default).
> **연관 파일**:
> - `cycle-discipline.md` §5 v2 line 75 ([agent-commit: yes] 묵시 동의 paradigm default)
> - `cycle-discipline.md` §7 (commit body 6-section 표준 default)
> - `cycle-discipline.md` §24 (= 본 rule 측 pointer default)
> - `cross-repo-parallel-exec.md` §2 (= 영역 1 sub-agent 병렬 vs 영역 2 다중 cli session paradigm default)
> - `safety-and-secrets.md` (= production push X paradigm default · 시크릿 기록 금지 default)
> - `recommended-option-disk-verification.md` (= disk 측정 의무 paradigm default · 본 rule 정합)
> SOT: `CLAUDE.md`

---

## §1 본 paradigm 본질

### §1.1 trigger 기반 paradigm default

runtime verify 매 cycle 마감 시점 강제 X default · 외부 동기화 덜 된 영역 측 false positive 회피 default. 본 paradigm 진입 trigger:

| trigger | 본질 |
|---|---|
| 사용자 보고 default | cowork chat 측 사용자 본인 측 "3 자식 모두 crash" / "GB launch FAIL" 등 보고 default |
| cli session 측 의도 시점 verify default | 자식별 IMPL cycle 마감 시점 + 사용자 명시 의무 영역 + emulator runtime PASS 의무 영역 default |
| CI / nightly baseline drift | nightly baseline 측 runtime regression 감지 default (= 별 cycle 후보 default · 현 시점 lazy default) |

### §1.2 책임 분리 (= `cowork-project-instructions v14 §B-2` 정합)

| 영역 | 책임 |
|---|---|
| cowork chat | paste source umbrella 발행 default + paste-back 회수 + 사용자 본심 회수 default |
| **cli session** ⭐ | **ADB + emulator + Logcat 측 stack trace 수집 + root cause 측정 + 코드 정정 + emulator runtime verify default** |
| 사용자 본인 | terminal 진입 + paste 운반 + emulator manual 실행 (= cli session 자율 결정 default 단 fallback 영역) |

본 paradigm 핵심 = **runtime verify 영역 본질 = cli session 단일 default** · cowork chat 측 sandbox 측 영역 X default.

---

## §2 9-step mitigation process

precedent cycle (= `3REPO-RUNTIME-CRASH-DIAGNOSIS-001`) 측 실증 default. 본 9-step paradigm = 향후 동족 사고 진입 시 cli session 측 자율 따름 default.

| step | 본질 | 담당 |
|---|---|---|
| 1 | cowork chat 측 paste source umbrella 발행 default (= §0 baseline + 가설 우선순위 + §9 cli session 진입 prompt default) | cowork chat |
| 2 | 사용자 본인 측 terminal 진입 + paste default (= 단일 자식 cwd default 또는 부모 mount root default · cli session 자율 결정 default) | 사용자 |
| 3 | cli session 측 ADB + emulator + Logcat 측 stack trace 수집 default (= `adb logcat -c` clear + `adb shell monkey -p <package> -c LAUNCHER 1` launch + `adb logcat -d -b crash` 또는 `*:E` filter default) | **cli session** |
| 4 | 정확한 stack trace 본문 측정 default (= class + method + line + exception type default) | **cli session** |
| 5 | root cause 측정 default (= 가설 우선순위 verify default · 신 가설 발견 시 자율 default · disk 측정 명령 호출 의무 default · `recommended-option-disk-verification.md` §2.1 정합) | **cli session** |
| 6 | mitigation IMPL default (= production code 정정 default 또는 manifest 정정 default 또는 DI binding 정정 default · 단일 자식 우선 default 또는 3 자식 동족 default · cli session 자율 default) | **cli session** |
| 7 | **verify default (= 본 paradigm 핵심 영역 default)** (= compile + unit test + emulator runtime verify default · 한정 cycle 측 default · staging flavor 한정 default) | **cli session** |
| 8 | commit default (= [agent-commit: yes] 묵시 동의 paradigm default · `cycle-discipline.md` §5 v2 정합 default) | **cli session** |
| 9 | paste-back 본문 발행 default (= 6 섹션 default · root cause + mitigation 본질 명시 default · `cycle-discipline.md` §7 정합) | **cli session** → cowork chat |

---

## §3 verify 의무 본문

본 paradigm 핵심 의무 영역 default. 자식별 mitigation 마감 시점 다음 4 항목 모두 PASS 의무:

| # | command | PASS 조건 |
|---|---|---|
| 1 | `./gradlew :composeApp:assembleStagingDebug` (또는 자식별 module 영역 정합) | exit 0 default |
| 2 | `./gradlew :composeApp:installStagingDebug` | exit 0 default |
| 3 | `adb shell monkey -p com.gently.<domain>.staging -c android.intent.category.LAUNCHER 1` | `Events injected: 1` default |
| 4 | `adb logcat -d -b crash` | **FATAL 0 default** · 자식별 process namespace 측 crash 영역 부재 default |
| 5 | `adb shell ps -A \| grep gently` | 3 process 모두 alive default (= mitigation 영역 3 자식 동시 default 시) |

### §3.1 staging flavor 한정 의무

- production flavor / production push paradigm **회피 default** (= production data INSERT 영역 절대 X default · `safety-and-secrets.md` 정합)
- 본 paradigm 측 mitigation = staging flavor 단일 default · production verification = 별 cycle 분리 default (= 사용자 본심 회수 의무 default)

### §3.2 emulator 부재 시점 mitigation

- emulator 미실행 발견 시 = cli session 측 `adb devices` 측정 default · device 부재 발견 시 사용자 본인 측 emulator 실행 의뢰 default
- 사용자 본인 측 IDE 측 Run / `emulator @<avd>` 호출 default 또는 cli session 측 `emulator` Bash 명령 (= 자율 default)

---

## §4 cli session 자율 paradigm

본 paradigm 측 cli session 자율 결정 영역 default:

| 항목 | 자율 영역 |
|---|---|
| 진입 paradigm | 단일 자식 cwd default 또는 부모 mount root default · 자식별 paradigm 정합 default |
| emulator 실행 paradigm | cli session 측 `adb` 명령 호출 default 또는 사용자 본인 측 IDE Run default |
| Logcat 수집 paradigm | `adb logcat -d -b crash` default 또는 `-d -t N *:E` filter default 또는 `AndroidRuntime\|FATAL EXCEPTION` grep default · 자율 default |
| mitigation 영역 | 단일 자식 우선 default 또는 3 자식 동족 mitigation default 또는 자식별 별 cycle default · cli session 자율 default |
| cycle 분리 | 본 cycle 측 diagnosis + mitigation 통합 default 또는 diagnosis 단독 + mitigation 별 cycle default · cli session 자율 default |
| commit paradigm | 자식별 N commit default 또는 통합 commit default · cli session 자율 default · `cycle-discipline.md` §5 v2 자동 허용 카테고리 정합 default |
| cross-repo paradigm 선택 | 영역 1 (= sub-agent 병렬) default 또는 영역 2 (= 다중 cli session) default · `cross-repo-parallel-exec.md` §2.3 정합 default |

---

## §5 STOP 조건

| trigger | mitigation |
|---|---|
| 보호 5 file sha drift 발견 | 즉시 STOP + 사용자 회수 default (= `cycle-discipline.md` §10 정합) |
| production data INSERT / DELETE / UPDATE 영역 root cause 발견 | 즉시 STOP + 사용자 회수 default (= HIGH RISK 영역 default) |
| production flavor / production push 시도 | 즉시 STOP default (= staging flavor 한정 의무 default) |
| emulator 측 runtime verify 부재 마감 시점 (= step 7 skip 시도) | 즉시 STOP default (= 본 paradigm 핵심 의무 영역 default) |
| DB schema 변경 / migration 영역 root cause 발견 | 즉시 STOP + 사용자 회수 default (= deferred Data 도메인 default) |
| Auth / Billing 영역 root cause 발견 시점 production 영역 진입 시도 | 즉시 STOP + 사용자 회수 default (= `auth-rules.md` + `billing-rules.md` 정합) |
| 사용자 본심 분기 의제 본질 발견 (= mitigation paradigm 본질 결정 default · scope expansion default · 5-repo paradigm 영역 default) | AskUserQuestion 회수 default |

---

## §6 적용 영역

| 영역 | 적용 |
|---|---|
| 자식 repo (= GB / GD / GT) 측 Android runtime crash | 의무 default |
| app-foundation 측 Android runtime crash | 의무 default (= 자식 측 동족 paradigm 차용 default) |
| master cli infra cycle 측 runtime crash 영역 | 적용 X default (= cli infra rule 영역 = production code 무접촉 default) |
| iOS runtime crash | 적용 X default (= 본 paradigm 측 ADB / Android emulator 영역 한정 default · iOS 영역 = 별 paradigm cycle 후보 default) |
| 자식 측 단순 compile FAIL (= runtime 영역 X default) | 적용 X default (= 일반 IMPL cycle 정합 default) |

---

## §7 paste source umbrella authoring 영역

본 paradigm 진입 paste source 측 권장 구조 (= precedent `3REPO-RUNTIME-CRASH-DIAGNOSIS-001` 측 실증 default):

| section | 본질 |
|---|---|
| §0 Baseline | 5-repo HEAD sha + 보호 5 file sha + 직전 H<chat> 마감 default |
| §0.3 가설 우선순위 | disk 측정 결과 인용 default (= cowork chat 측 측정 결과 + cli session 측 재 verify 의무 default · `recommended-option-disk-verification.md` §3 정합) |
| §1 Cycle 본질 | outcome + cli session 자율 paradigm + 사용자 본심 정합 default |
| §2 Scope | 변경 영역 + 무접촉 영역 default |
| §4 변경 step | cli session 자율 step paradigm default |
| §5 §FREEDOM | cli session 자율 결정 영역 default |
| §6 STOP 조건 | 본 paradigm §5 정합 default |
| §7 paste-back 규약 | 6 섹션 default + cross-verify 의무 영역 default |
| §9 cli session 진입 prompt | 신 claude session 측 첫 turn paste default |

---

## §8 commit body 본문 (= `cycle-discipline.md` §7 정합)

자식별 mitigation commit body 6-section default:

```
[Goal]   runtime crash mitigation (= <root cause 본질 1줄>)
[Diff]   <변경 file 영역> (+<LOC> · <변경 본질>)
[Sha]    (불변) (= 보호 5 file 무접촉 default · staging flavor 한정 default)
[EC]     ./gradlew :composeApp:assembleStagingDebug PASS · installStagingDebug PASS · monkey 1 launch · adb logcat crash buffer FATAL 0 · process alive
[Next]   <후속 cycle trigger 1줄>
[Refs]   parent <8자 sha> · cycle <TaskId> · root cause + mitigation paradigm 영역
```

---

## §9 인접 paradigm 정합

| 인접 entry | 본질 |
|---|---|
| `cycle-discipline.md` §5 v2 line 75 | [agent-commit: yes] 묵시 동의 paradigm default · 본 paradigm 측 commit step 8 정합 default |
| `cycle-discipline.md` §7 | commit body 6-section 표준 default · 본 paradigm 측 step 8 정합 default |
| `cross-repo-parallel-exec.md` §2 | 영역 1 sub-agent fan-out vs 영역 2 다중 cli session paradigm default · 본 paradigm 측 3 자식 동족 진입 시점 정합 default |
| `safety-and-secrets.md` | production push X paradigm default · 시크릿 기록 금지 default · 본 paradigm 측 staging flavor 한정 의무 정합 default |
| `recommended-option-disk-verification.md` | disk 측정 의무 paradigm default · 본 paradigm 측 step 5 root cause 측정 + paste source authoring 영역 정합 default |
| `auth-rules.md` + `billing-rules.md` | HIGH RISK 도메인 진입 시점 STOP 조건 default · 본 paradigm 측 §5 STOP 조건 정합 default |

---

## §10 본 SoT 의 변경 정책

- cli infra 권장 byte-identical (= 5-repo · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable)
- 변경 시 master cycle 신설 + 5-repo propagation 의무 (= `cycle-discipline.md` §15 패턴 1 정합)
- 자식 repo 측 직접 수정 금지

---

## §11 명시 cycle 이력

- 2026-05-22 · `MASTER-CLI-RUNTIME-CRASH-MITIGATION-PROCESS-PARADIGM-001` · 본 SoT 신설 (= paradigm 본질 + 9-step process + verify 의무 본문 + cli session 자율 paradigm + STOP 조건 + 적용 영역 + paste source authoring 영역 + commit body 본문 + 인접 paradigm 정합 default) + `cycle-discipline.md` §24 pointer 추가 default + CLAUDE.md §15 entry append default + 5-repo byte-identical propagation default
- precedent: `3REPO-RUNTIME-CRASH-DIAGNOSIS-001` (2026-05-22 H32 마감 default · Sentry `SentryInitProvider` 자동 init 측 empty DSN crash 차단 default · `<meta-data android:name="io.sentry.auto-init" android:value="false" />` × 3 자식 byte-identical mitigation default · GB `616bec5` + GD `317e74a` + GT `664a092`)
