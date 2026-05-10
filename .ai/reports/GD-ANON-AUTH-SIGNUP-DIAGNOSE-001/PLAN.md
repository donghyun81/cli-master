# PLAN — GD-ANON-AUTH-SIGNUP-DIAGNOSE-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | GD-ANON-AUTH-SIGNUP-DIAGNOSE-001 |
| Mode | audit / 진단 보고 / read-only |
| Workflow | Collect -> Plan -> (Coin prep · 별 cycle) -> Verify -> Review |
| Requirements Source | 부모 cycle MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001 Findings F7 + F8 |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 4 (EVIDENCE.md / PLAN.md / VERIFY.md / REVIEW.md · master `.ai/reports/` 전용) |
| Modules | claude-cli-master/.ai/reports/ 한정 |
| Risk | Low |
| DBMig | No |
| MoneyAuth | Yes (Auth 도메인 진단 한정 · 코드 변경 0 · Supabase project 변경 X) |

## 2. DependencyDecision
N/A (libs.versions.toml 변경 X · audit 보고서만)

## 3. ArchitectureImpact
N/A (코드 변경 0)

## 4. ModelBoundaryPlan
N/A (코드 변경 0)

## 5. ErrorPolicy
N/A (코드 변경 0)

## 6. UIStateFlowPlan
N/A (코드 변경 0)

## 7. TestabilitySeams
N/A (테스트 변경 0)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `ls -la ~/AndroidStudioProjects/GentlyDay/local.properties` (= 부재 재검증) + `find ~/AndroidStudioProjects/GentlyDay/app/src/main/java -iname "*Auth*"` (= 코드 영역 5 파일 인용) + `grep -E "SUPABASE_URL\|SUPABASE_ANON_KEY" ~/AndroidStudioProjects/GentlyDay/app/build.gradle.kts` (= placeholder fallback 영역 인용) |

## 9. RollbackStrategy
- 보고서 4 파일 = `.ai/reports/GD-ANON-AUTH-SIGNUP-DIAGNOSE-001/` 안에만 존재 → `git rm -r` 또는 `mv` 영역 단순 (revert 가능)
- 코드 영역 변경 0 → rollback 무관

## 10. ExternalPrep / DeferredItems

### Coin prep 영역 (사용자 직접 의무)

| # | 영역 | 위치 | 의존 |
|---|---|---|---|
| 1 | Supabase dashboard 접속 + project 결정 | https://supabase.com/dashboard | Coin 측 직접 |
| 2 | GD project 신설 또는 GT/GB 기존 project 공용 결정 | (Coin 정책 영역) | 1 후 |
| 3 | Anonymous Sign-In provider 활성 | Supabase dashboard → Authentication → Providers → Anonymous → Enable | 2 후 |
| 4 | project URL + anon key 발급 | Supabase dashboard → Settings → API | 3 후 |
| 5 | `~/AndroidStudioProjects/GentlyDay/local.properties` 작성 | local 영역 | 4 후 |

`local.properties` 형식 (Coin 측 작성):
```
SUPABASE_URL=https://<project>.supabase.co
SUPABASE_ANON_KEY=<anon-key>
```

> 본 작성 = Coin 직접 영역. CLI 측 진입 X (STOP 조건 1 정합).
> `.gitignore` 안 `local.properties` 영역 인지 의무 (시크릿 commit 회피 — `safety-and-secrets.md` 정합).

### 별 cycle 분리

#### `GD-ANON-AUTH-RUNTIME-RECHECK-001` (다음 cycle 후보)

진입 조건 (Coin prep 5 마감):
- `local.properties` 안 SUPABASE_URL + SUPABASE_ANON_KEY 주입 마감
- Supabase dashboard 안 Anonymous provider 활성 마감
- emulator-5554 ready 영역

본 작업:
1. `./gradlew assembleDebug` (또는 `installDebug`) 재 빌드
2. emulator-5554 안 GD 앱 재 launch
3. onboarding 진입 + step5 anon auth 영역 검증 (logcat tag `com.example.gentlyday` 인용)
4. main 5 화면 (Sleep / Habits / Reports / Settings / Ticket) 진입 검증
5. 부모 runtime audit Findings F7 + F8 mitigation 마감 검증
6. 산출물 = `.ai/reports/GD-ANON-AUTH-RUNTIME-RECHECK-001/` (EVIDENCE / PLAN / VERIFY / REVIEW)
7. 부모 runtime audit memory `multi_repo_uiux_runtime_audit.md` F7 + F8 영역 mitigation 영역 갱신

진입 시 STOP 경계 (재명시):
- Supabase project URL / anon key 변경 X
- AnonymousAuthBootstrap / 코드 영역 변경 X (정합 ✓)
- auth-rules.md §1 SoT 변경 X
- 보호 파일 5 종 sha 변동 X

## Plan

### 본 cycle 단계 (audit / read-only)
1. 보고서 디렉터리 신설 — `.ai/reports/GD-ANON-AUTH-SIGNUP-DIAGNOSE-001/`
2. EVIDENCE.md 작성 — 본질 영역 + 영향 흐름 + 코드 정합 cross-verify + scope 외 영역 명시
3. PLAN.md 작성 — Coin prep 5 영역 + 별 cycle 분리 정의
4. VERIFY.md 작성 — audit 명령 흔적 + exit code 인용
5. REVIEW.md 작성 — Verdict PARTIAL (진단 본 작업 PASS · CLI 정정 영역 0 · Coin prep 잔존)
6. master `.auto-memory/decision-log.md` entry append
7. 부모 runtime audit memory 갱신 = Cowork 측 별 turn 처리 (CLI scope 외 명시)

### 본 cycle 단계 (commit 영역)
- 본 cycle = audit / read-only / 코드 변경 0 → master commit 1 회 권장 (`docs(report): GD-ANON-AUTH-SIGNUP-DIAGNOSE-001 진단 보고 마감`)
- 보호 파일 sha 변동 0 → `[Sha]` 섹션 = "(불변)"
- agent commit 한시 허가 정책 v2 정합 (audit 류 자동 허용)
- 단 본 cycle 안 commit 진입 = Coin 결정 의뢰 후 (별 turn 가능)

## Notes

- 본 cycle = lightweight 4 파일 (EVIDENCE / PLAN / VERIFY / REVIEW) — `cycle-discipline.md` §11 정합
- 사고 영역 누적 X (본 cycle = 부모 runtime audit Findings 정합 후속)
- ux-laws.md §5.1 N/A 분류 = Auth-only 영역 (UI 변경 0 · audit / read-only)
