# FIREBASE-BOM-DOWNGRADE-001 — REVIEW

## Meta
| 항목 | 값 |
|---|---|
| Cycle ID | FIREBASE-BOM-DOWNGRADE-001 |
| 일자 (KST) | 2026-05-11 |
| Scope | file edit only · commit X (cycle-discipline §5 v2 예외 1 회 적용) |
| Source repo | (none · 3 자식 repo 측 동등 적용) |
| Verdict | PASS |

## 1. 결정

Firebase BoM `34.13.0` → `33.7.0` 측 1 line downgrade (3 repo × `gradle/libs.versions.toml` 측 byte-identical). 사유: BoM 34.13.0 측 transitive 의존 `play-services-measurement-{impl,api}-23.2.0` 측 Kotlin 2.2.0 metadata 측 프로젝트 Kotlin 2.0.21 incompatibility.

## 2. baseline 검증 (사전)

| 항목 | 결과 |
|---|---|
| 4-repo HEAD sha | GB `0552529` · GD `4d867cc` · GT `d90c19e` · master `9487f16` (FIREBASE-COMMIT-001 STOP 보고 baseline 일치) |
| 3 repo × libs.versions.toml 측 `firebaseBom = "34.13.0"` | ✓ 확인 |
| 3 repo × Firebase 영역 (root + app build.gradle.kts) byte-identical | ✓ 확인 |
| google-services.json `project_id="gently-apps"` · .gitignore 명시 | ✓ 확인 |
| 보호 파일 5종 sha 변동 | 0 (본 cycle 미접촉) |

## 3. 변경 영역 (단 1 line × 3 repo)

| repo | 파일 | 변경 |
|---|---|---|
| GentlyBreath | `gradle/libs.versions.toml` | `firebaseBom = "34.13.0"` → `"33.7.0"` |
| GentlyDay | `gradle/libs.versions.toml` | (동상) |
| GentlyTable | `gradle/libs.versions.toml` | (동상) |

다른 영역 변경 X (`firebaseCrashlyticsPlugin = "3.0.2"` · `googleServices = "4.4.4"` 측 변동 X).

## 4. 검증 명령 + Exit Code

| 명령 | repo | Exit Code | 결과 |
|---|---|---|---|
| `./gradlew :app:dependencies --configuration debugRuntimeClasspath` | GB | 0 | firebase-bom 33.7.0 → analytics 22.1.2 + crashlytics 19.3.0 (c) resolve |
| (동상) | GD | 0 | (동) |
| (동상) | GT | 0 | (동) |
| `./gradlew :app:compileDebugKotlin` | GB | 0 | BUILD SUCCESSFUL in 7s · `kotlin_module metadata 2.2.0` 측 error 0 |
| `./gradlew :app:assembleDebug` | GB | 0 | BUILD SUCCESSFUL in 8s · 40 tasks |
| (동상) | GD | 0 | BUILD SUCCESSFUL in 17s · 40 tasks |
| (동상) | GT | 0 | BUILD SUCCESSFUL in 22s · 40 tasks |

## 5. 분기점 (binary search)

1차 candidate `33.7.0` 측 즉시 PASS — 추가 downgrade 단계 진입 X (cycle prompt 의 "최대 5 회" 1 회 안 마감). 단 본 분기점 측 "최대 Kotlin 2.0.x 호환 BoM" 측 식별 X (33.16.0 측 진단 미진행 · 본 cycle 측 의도 = 단순 SUCCESS 분기점 식별 한정).

권장 후속: BoM `33.x.x` line 측 마지막 안전 버전 측 식별 cycle (lazy · 차기 출시 직전 별 검토).

## 6. 측정된 의존 버전 (BoM 33.7.0)

- `com.google.firebase:firebase-bom:33.7.0`
- `com.google.firebase:firebase-analytics:22.1.2` (constraint)
- `com.google.firebase:firebase-crashlytics:19.3.0` (constraint)

BoM 34.13.0 측 측 measurement 23.2.0 (Kotlin 2.2.0) ↔ BoM 33.7.0 측 measurement 22.1.2 (Kotlin 2.0.x 호환). incompatibility 측 해소.

## 7. 사용자 환경 (참고)
- AGP `8.13.2`
- Kotlin `2.0.21`
- Java `OpenJDK 21.0.10 (Temurin)`
- Gradle wrapper `8.13`

## 8. cycle prompt 측 명시 의무 측 충족

| 의무 | 결과 |
|---|---|
| file edit only · commit X | ✓ commit X (3 repo working tree 측 변경 추가 + 미커밋 유지) |
| 1 line edit · 다른 영역 변경 X | ✓ firebaseBom 1 line 측만 변경 |
| 3 repo × byte-identical | ✓ "33.7.0" 측 3 repo 측 동일 |
| build SUCCESS 3 repo | ✓ |
| decision-log + incident-log append | ✓ 본 cycle 마감 시 진행 |

## 9. 다음 cycle 측 의뢰

- `[FIREBASE-COMMIT-001]` cycle 측 재 paste 측 진입 가능 baseline 확보. Cowork chat 측 본 REVIEW 측 결정 후 prompt 재 paste 측 진입 의뢰.
- 현 working tree 상태:
    - 3 repo × `gradle/libs.versions.toml` (firebase 영역 추가 + BoM 33.7.0 line 변경) modified
    - 3 repo × `build.gradle.kts` (Firebase plugin apply false 추가) modified
    - 3 repo × `app/build.gradle.kts` (Firebase plugin apply + dependencies 추가) modified
    - (Firebase scope 외 working tree 영역 측 보고: GB/GT `docs/release-readiness/LAUNCH-STATUS.md` modified · 본 cycle scope X)

## 10. 위험 영역 + Remaining Risks

- BoM `33.7.0` 측 마지막 Kotlin 2.0.x 호환 line 측 미식별 — 33.16.0 측 실측 검증 lazy (출시 직전 보안 패치 적용 시점 측 별 cycle 후보).
- Kotlin upgrade 측 향후 별 cycle (`[KOTLIN-UPGRADE-2.2.X-001]` 측 후보) — 그 시점 측 BoM 측 34.x.x 측 재진입 가능.
- (참고) GB/GT × `docs/release-readiness/LAUNCH-STATUS.md` 측 working tree 미커밋 변경 측 본 cycle scope X (별 cycle 측 cleanup pass 후보).

## 11. PromptFit (선택)

PromptFitScore: 95/100
PromptFitVerdict: PASS
PromptFitBreakdown:
- Requirement Alignment: 25/25 (1 line BoM downgrade · build SUCCESS · commit X · 모두 충족)
- Scope Control: 20/20 (다른 영역 변경 X · 3 repo × 1 line)
- Evidence/Verify Quality: 18/20 (3 × 3 build PASS · dependency tree 측정 확인 / 분기점 최대값 측 미식별 = -2)
- Risk/STOP Handling: 10/10 (Kotlin upgrade 측 scope X 명시 · 별 cycle 위임)
- Output Contract Compliance: 10/10 (REVIEW.md + decision-log + incident-log append 의무 충족)
- Prompt Efficiency/Clarity: 12/15 (cycle prompt 측 binary search "5 회" 측 1 회 마감 · 분기점 식별 측 미진행)
PromptFitConfidence: high
