# TODO — MASTER-LIBS-VERSIONS-CROSS-VERIFY-HOOK-001 잔여 + 별 trail

## 본 cycle 안 완료
- [x] `.claude/rules/libs-versions-cross-verify.md` 신설 (정책 SoT · 11 섹션 · R1 supabase + R2 Kotlin + R3 절차).
- [x] `.claude/hooks/libs-versions-cross-verify.sh` 신설 (executable · bash + python3 inline · trigger filter + 3-source parse).
- [x] `.claude/settings.json` PostToolUse Edit|Write 묶음 안 hook entry 1 추가.
- [x] self-test PASS (master self + foundation toml + mismatch fixture R1a+R1b 검출 + enforce mode exit 2).
- [x] 5-repo propagate (ok=12 fail=0 · master + 4 자식 byte-identical).
- [x] 자식 4-repo 측 propagation commit (GB ee9ed88 · GD a65570d · GT edc5aab · foundation 11af2a1).
- [x] 보호 5 sha + foundation HEAD baseline 일치 재 측정.
- [x] master 산출물 4 file (PLAN + EVIDENCE + REVIEW + TODO) + task file + decision-log entry + master 단일 commit.

## Deferred (별 cycle 진입 의무)

### N1-β 확장 — baseline ingest 전반 hook
- [ ] `MASTER-BASELINE-INGEST-AUTOVERIFY-HOOK-001` — master HEAD + cli infra 9 file + 보호 5 sha 흡수 정합 hook (= 본 cycle = libs.versions 영역 단독 · 전반 확장 별 cycle).

### R2 hard enforce 영역
- [ ] `MASTER-LIBS-VERSIONS-CROSS-VERIFY-HOOK-002` — R2 (Kotlin ↔ supabase 호환 매트릭스) hard enforce 승격 + baseline 실측 추가 (현 시점 warn-only · lazy default).

### 자식 측 audit
- [ ] `MASTER-CHILD-LIBS-VERSIONS-AUDIT-001` — 자식 3-repo (GB/GD/GT) 측 `libs.versions.toml` 안 supabase 영역 위치 측정 (= 본 chat baseline 인용 영역 = 자식 측 의존 미발견 baseline).

### 누적 별 trail
- [ ] handoff v7 §C #1 `CLI-INFRA-RULE-DEFAULT-LOCK-001` — 외부 cli session paste 대기 영역 (진행 상태 측정 의무).
- [ ] `CLI-PASTE-TEMPLATE-HASH-OBJECT-001` — paste-back template 측 hash-object direct 인용 의무 (9 회차 누적).
- [ ] `FND-PLATFORM-IMPL-SECURE-TOKEN-001` — foundation 측 platform shell (androidMain EncryptedSharedPreferences + iosMain Keychain).
- [ ] 자식 3-repo migrate cycle 3 (GB / GD / GT → foundation supabase wrapper 인용).

## 미해결 risk (REVIEW Remaining Risks 동기)
- [ ] verify-sync 잔존 DRIFT 2 (gradlew + gradlew.bat · app-foundation 측 단독) = FND-GRADLE-BASELINE-001 측 KMP wrapper 정정 영역 = 본 cycle scope 외 · 별 cycle 진입 시점 정정.
- [ ] hook self-test fixture (`/tmp/libsvcv-fix1/`) = OS 측 자연 cleanup · 본 cycle 측 cleanup 영역 외 (`rm` 차단 deny list 정합).
- [ ] R2 (Kotlin 호환 매트릭스) baseline 정확도 = release notes 외부 검증 영역 (향후 별 cycle 보강).
