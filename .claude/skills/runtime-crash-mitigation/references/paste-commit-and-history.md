# runtime-crash-mitigation — paste 구조 · commit body · 인접표 · 이력

> 본 file = [`../SKILL.md`](../SKILL.md) 분할물 (= 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` · **verbatim 이전 · 삭제 0**).
> 크래시 포착·완화 판정엔 필요 없고, paste 발행/commit 작성 시점에만 여는 층.

---

## §7 paste source umbrella authoring 영역

본 paradigm 진입 paste source 측 권장 구조 (= precedent `3REPO-RUNTIME-CRASH-DIAGNOSIS-001` 측 실증 default):

| section | 본질 |
|---|---|
| §0 Baseline | 4-active HEAD sha + 보호 5 file sha + 직전 H<chat> 마감 default |
| §0.3 가설 우선순위 | disk 측정 결과 인용 default (= cowork chat 측 측정 결과 + cli session 측 재 verify 의무 default · `.claude/skills/disk-verification/SKILL.md` §3 정합) |
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
| `docs/rules/cycle-discipline.md` §5 v2 line 75 | [agent-commit: yes] 묵시 동의 paradigm default · 본 paradigm 측 commit step 8 정합 default |
| `docs/rules/cycle-discipline.md` §7 | commit body 6-section 표준 default · 본 paradigm 측 step 8 정합 default |
| `.claude/rules/cross-repo-parallel-exec.md` §2 | 영역 1 sub-agent fan-out vs 영역 2 다중 cli session paradigm default · 본 paradigm 측 3 자식 동족 진입 시점 정합 default |
| `.claude/rules/safety-and-secrets.md` | production push X paradigm default · 시크릿 기록 금지 default · 본 paradigm 측 staging flavor 한정 의무 정합 default |
| `.claude/skills/disk-verification/SKILL.md` | disk 측정 의무 paradigm default · 본 paradigm 측 step 5 root cause 측정 + paste source authoring 영역 정합 default |
| `docs/rules/auth-rules.md` + `docs/rules/billing-rules.md` | HIGH RISK 도메인 진입 시점 STOP 조건 default · 본 paradigm 측 §5 STOP 조건 정합 default |

---

---

## §11 명시 cycle 이력

- 2026-05-22 · `MASTER-CLI-RUNTIME-CRASH-MITIGATION-PROCESS-PARADIGM-001` · 직전 rule (`docs/rules/runtime-crash-mitigation-process.md`) 신설 (= paradigm 본질 + 9-step process + verify 의무 본문 + cli session 자율 paradigm + STOP 조건 + 적용 영역 + paste source authoring 영역 + commit body 본문 + 인접 paradigm 정합 default) + `cycle-discipline.md` §24 pointer 추가 default + CLAUDE.md §15 entry append default + 5-repo byte-identical propagation default
- 2026-05-26 · `MASTER-CLI-SKILLS-MIGRATION-PHASE-1-001` · 본 skill 신설 default (= 직전 rule 본문 본질 보존 default · skill paradigm 정합 default · trigger 시점 lazy load default · `docs/rules/runtime-crash-mitigation-process.md` 측 thin pointer 갱신 default)
- 2026-05-27 · `MASTER-CLI-NATIVE-RUN-VERIFY-SANDBOX-INTEGRATION-001` · §3.3 신설 default (= Anthropic v2.1.145+ native bundled skill `/run` + `/verify` + `/run-skill-generator` 통합 + `/sandbox` isolation mention default · staging flavor 한정 + production push X 의무 강화 default · 본문 본질 보존 default · 추가 영역 한정 default) + 5-repo byte-identical propagation default
- precedent: `3REPO-RUNTIME-CRASH-DIAGNOSIS-001` (2026-05-22 H32 마감 default · Sentry `SentryInitProvider` 자동 init 측 empty DSN crash 차단 default · `<meta-data android:name="io.sentry.auto-init" android:value="false" />` × 3 자식 byte-identical mitigation default · GB `616bec5` + GD `317e74a` + GT `664a092`)
