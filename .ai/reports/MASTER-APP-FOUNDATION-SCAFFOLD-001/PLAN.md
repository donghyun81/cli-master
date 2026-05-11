# PLAN — MASTER-APP-FOUNDATION-SCAFFOLD-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-APP-FOUNDATION-SCAFFOLD-001 |
| Mode | ops-layer |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | 사용자 cycle prompt (2026-05-11 KST 진입) |
| Risk | Medium (multi-repo · git init 신규 + propagation 정책 5→6 확장 · 보호 파일 sha 변동 X 의무) |
| DBMig | No |
| MoneyAuth | No |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | ~150+ (app-foundation 신규 skeleton ~120 + master 6 갱신 + master 신규 reports 4) |
| Modules | app-foundation (신규) + claude-cli-master (갱신) |
| Risk | Medium |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision
_libs.versions.toml SSOT 신설 — 외부 의존 baseline 박음 (각 항목 별 wire 는 P1 별 cycle 영역)._

| 항목 | 값 |
|---|---|
| Library | (SSOT baseline 박음 · 실제 wire 는 자식 cycle 진입 시) |
| ①공식·표준 지위 | Kotlin 2.0.21 (JetBrains) / Compose BoM 2024.09 (Google) / Koin 4.0.0 (InsertKoinIO) / Ktor (JetBrains) / Supabase Kotlin (supabase-community) / Play Billing 6 (Google) / Crashlytics 18 (Firebase) / Sentry 7 (Sentry) / kotlinx-serialization (JetBrains) / WorkManager 2.9 (AndroidX) / Coil 2 (Coil-KT) — 모두 공식·사실상 표준 |
| ②유지보수 품질 | 모두 최근 6 개월 active release · 광범위 채택 |
| ③KMP·CMP 호환 | common artifact: Kotlin/Compose/Koin/Ktor/Supabase/kotlinx-serialization · platform-shell-only: Play Billing (Android) / WorkManager (Android) / Coil (Android) · iOS 측은 별 cycle 결정 |
| ④transitive 비용 | BoM 사용으로 version 정합 · 본 cycle = 선언만 (wire X) |
| ⑤기존 기능 중복 여부 | 신규 repo 신설 — 중복 X |
| ⑥제거 난이도 | 항목별 단독 제거 가능 (SSOT 안 행 삭제 + propagation) |
| ⑦직접 구현 대비 우위 | Supabase / Billing / Crashlytics = SDK 의무 (외부 서비스 binding) · Koin/Ktor/Coil = 직접 구현 비용 ↑↑ |
| ⑧UI 라이브러리 특별 정당화 | Compose BoM = KMP/CMP 표준 · 외부 UI 라이브러리 X (Material3 + Compose 기본만) |

## 3. ArchitectureImpact
- 새 인터페이스/추상화: app-foundation 의 module 구조 baseline 박음 (shared/domain · shared/data · shared/feature-state · core/ 8 영역 · composeApp / iosApp scaffold)
- 변동성 경계 유형: network (Ktor + Supabase) / DB (Supabase Postgres) / billing (Play Billing) / identity (Supabase Auth) / observability (Crashlytics + Sentry) — 본 cycle = 디렉터리만 신설 · wire 는 자식 cycle 영역
- 레이어 누수 위험: shared/domain → shared/data import 차단 (I2 불변 원칙 정합 · `code-principles.md` §1 DIP 정합)
- shared-first 경계 영향: app-foundation `shared/` = 자식 repo `app/` 의 fork 영역 (자식 propagation 메커니즘 = MASTER-T01 진입 후 별 결정)

## 4. ModelBoundaryPlan
_본 cycle = scaffold (구조만) · DTO/Entity/DomainModel/UiState 실제 신설 X. 자식 wire 시 분리 강제 (`code-principles.md` §4 정합)._

- DTO 변경: N/A (scaffold only)
- Entity 변경: N/A
- DomainModel 변경: N/A
- UiState 변경: N/A
- 경계 매핑 추가/변경: N/A
- I2 import 방향 영향: shared/domain → shared/data 차단 (Gradle module 의존 baseline 박음)

## 5. ErrorPolicy
_본 cycle = scaffold only · 새 UseCase / Repository 신설 X._

- typed Result 사용 여부: N/A
- 오류 모델: N/A
- 기존 코드 교체 범위: N/A

## 6. UIStateFlowPlan
_본 cycle = scaffold only · UI 신설 X._

- UiState 변경: N/A
- ViewModel 단방향 흐름 유지: N/A
- SharedUiState<T> 변형 사용: N/A

## 7. TestabilitySeams
_본 cycle = scaffold only · 테스트 신설 X (자식 cycle 영역)._

- 테스트 파일: N/A
- FakeXxx 사용: N/A
- 심 주입 대상 (clock·dispatcher·identity·logger·uuid): N/A (인터페이스만 baseline 박음 · 실 wire 자식 cycle)
- 심 연기 시 명시적 사유: scaffold cycle (외부 의존 SDK wire 별 cycle)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `cd /Users/yundonghyeon/AndroidStudioProjects/app-foundation && git log --oneline -1` · `cd $MASTER && bash scripts/verify-sync.sh` · `git -C $MASTER hash-object docs/schemas/ui-spec.schema.json .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md` · `cd $MASTER && git diff --stat HEAD~1 HEAD` |

## 9. RollbackStrategy
- 롤백 가능 지점: master HEAD 직전 commit `adda16f` + app-foundation 미신설 상태
- 롤백 조건 (언제): 보호 5 sha 변동 감지 / verify-sync 회귀 (이전 PASS 112 ≠ 새 PASS) / app-foundation git init 사고
- 복구 경로: master `git reset --hard adda16f` (Coin 직접 승인 의무 · agent 자동 금지) + `rm -rf /Users/yundonghyeon/AndroidStudioProjects/app-foundation`

## 10. ExternalPrep / DeferredItems
- 연기 항목: app-foundation feature wire (Supabase / Billing / Koin / Ktor SDK 본 구현) = 자식 cycle 진입 시 별 cycle
- user-prep 선행 조건: app-foundation 의 Supabase project URL / key = user-prep (현 cycle scope X)
- stub/TODO(user-prep) 위치: app-foundation `core/supabase/README.md` (TODO marker)

## 회수 1 mitigation 흡수 결정 (CLI 자체 판단)

흡수 = YES. 근거:
- 본 cycle 이 verify-sync.sh + propagate.sh 동일 영역 동시 변경 (5→6 repo 확장)
- release-readiness/* 영역 exclude 정책 = repo-specific 영역 (master 측 SoT 만) → propagation 검증 false positive 차단 의무 자연 동시 mitigation 적합
- 별 cycle 분리 = 의제 분산 비용 (동일 파일 2 cycle 수정) > 동시 흡수 비용
- 결과 = 이전 cycle (MULTI-REPO-RELEASE-LEDGER-INIT-001 PASS 조건부) 의 회수 1 자동 close

회수 2 흡수 = NO (propagation-status.md M 본 cycle 무관 dirty · stage 금지 의무 준수).

## Plan (단계별 작업 list)

1. **app-foundation skeleton 신설**:
   1.1. `mkdir -p /Users/yundonghyeon/AndroidStudioProjects/app-foundation/{shared/{domain,data,feature-state},composeApp,iosApp,core/{di,supabase,billing,observability,analytics,feature-flag,notification,network},gradle,docs/{release-readiness,how-to-fork,propagation},.claude,.ai/{tasks,reports}}`
   1.2. `gradle/libs.versions.toml` SSOT 신설 (Kotlin 2.0.21 / Compose BoM 2024.09 / Koin 4.0.0 / Ktor 3.0.x / Supabase Kotlin 2.6.x / Play Billing 6.x / Crashlytics 18.6.x / Sentry 7.x / kotlinx-serialization 1.7.x / WorkManager 2.9.x / Coil 2.7.x)
   1.3. `.gitignore` (KMP/CMP 표준 + .DS_Store + build/ + .idea/)
   1.4. `README.md` (foundation 단일 목적 + 사용 절차)
   1.5. `CLAUDE.md` (master CLAUDE.md reading order 인용 + foundation 단일 목적)
   1.6. cli infra cp from master: `.claude/rules/` 전체 + `.claude/agents/` + `.claude/hooks/` + `.claude/commands/` + `.claude/skills/` + `.claude/settings.json` (settings.local.json 제외) + `docs/agent/` + `docs/schemas/` + `docs/design/` + `scripts/agent/` + `.editorconfig` + `.mcp.json` (보호 5 cp)
   1.7. master `docs/release-readiness/COMMON-SETUP-SSOT-DRAFT.md` 를 `app-foundation/docs/release-readiness/COMMON-SETUP-SSOT.md` 로 이전 (DRAFT 접미사 제거)
   1.8. git init + first commit

2. **master 측 갱신**:
   2.1. `scripts/propagate.sh` + `scripts/verify-sync.sh` TARGET_REPOS 확장 (5→6 repo) + release-readiness/* exclude 동시 박음
   2.2. master `docs/release-readiness/COMMON-SETUP-SSOT-DRAFT.md` 삭제 (이전 후)
   2.3. `docs/release-readiness/PACKAGE-OVERVIEW.md` §1 app-foundation 행 HEAD sha 갱신 (미신설 → 새 sha 12자) + §3 MASTER-T01 ☐ → ✓ + sha 12자 + 본심 1 줄
   2.4. `.auto-memory/decision-log.md` append 1 entry (본 cycle)
   2.5. `.auto-memory/protected-file-hashes.md` append 1 entry (보호 5 sha 변동 0 확인 baseline)

3. **stage 격리 (의무)**:
   - 본 cycle 무관 dirty 미stage = `.auto-memory/propagation-status.md M` + 자식 3 `gradlew.bat M` + `cc-paste-*.md` untracked + `.ai/reports/MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001/` untracked
   - 본 cycle 직접 영역 dirty stage = `.auto-memory/decision-log.md M` (이전 cycle entry · 회수 1 마감으로 함께 commit) + `.auto-memory/incident-log.md M` (이전 cycle entry · 회수 1 마감으로 함께 commit)

4. **verify-sync.sh 검증**:
   - 본 cycle 갱신 후 verify-sync.sh 실행 → release-readiness/* exclude 적용 후 PASS 확인 (exit 0 또는 6 자동 exclude)
   - 보호 5 sha (`git hash-object`) 변동 X 확인

5. **2 commit (정확한 subject)**:
   - app-foundation: `feat(scaffold): MASTER-APP-FOUNDATION-SCAFFOLD-001 initial scaffold + cli infra + libs.versions.toml SSOT`
   - master: `chore(ops): MASTER-APP-FOUNDATION-SCAFFOLD-001 expand propagation 5→6 repo + move COMMON-SETUP-SSOT + PACKAGE-OVERVIEW §3 MASTER-T01 ✓`

6. **report 4 file**: PLAN.md (본) + EVIDENCE.md + VERIFY.md + REVIEW.md (Verdict=PASS)

## Notes

- propagation 메커니즘: 본 cycle = `cp` (1순위 default). submodule / Maven publish = 별 cycle 의제 (CLI 자체 판단 영역).
- app-foundation 의 cli infra propagation 동작 = master → app-foundation 단방향 (자식 3 와 동일 정책). app-foundation 은 도메인 코드 없음 = 보호 5 cp 만 의무 + 권장 cli infra 도 cp.
- 회수 2 (propagation-status.md self-update 부산물) = 본 cycle 흡수 X. 이전 cycle 의 lazy mitigation 영역 (도구 정책 변경 별 cycle 후보).
