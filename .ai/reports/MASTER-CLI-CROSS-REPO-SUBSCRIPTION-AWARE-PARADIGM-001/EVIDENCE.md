# EVIDENCE — MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001

## Requirements Source

- 원문 paste source: `/Users/yundonghyeon/AndroidStudioProjects/cc-paste-MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001.md`
- Requirement chain 충족 여부: PASS (= paste source §0~§11 정합 default · §0 baseline anchor + §1 cycle 본질 + §2 scope + §3 contract SoT + §4 §FREEDOM + §5 ChangeBudget + §6 STOP + §7 paste-back 규약 + §8 cli session 자체 결정 권한 + §9 entry prompt + §10 Refs + §11 정리 paradigm)
- Authority boundary: cli infra master + 4 자식 propagation 영역 + 부모 mount root CLAUDE.md (= 단방향 정합 default · 직전 cycle MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001 정합)

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | cli infra 영역 (= ops-layer · 정정 강화 · 0 production touch · paradigm 본문 강화) |
| Reading Mode | CLI 운영 레이어형 (= `workflow-core.md` Intake Normalization 정합) |
| Requirement Source | paste source 단일 SoT (= §0~§11 정합) |
| Info Gap | RESOLVABLE_IN_REPO (= 모든 영역 master + 4 자식 + 부모 mount root 측 측정 가능 default) |
| STOP Risk | LOW (= cli infra paradigm 정정 강화 영역 default · 보호 file 영역 무접촉 의무) |
| Read-Only Fan-Out | N/A (= 본 cycle 측 sub-agent fan-out 없음 default · cli session 자체 결정 default) |
| Implementer Entry | Allowed (= pre-EVIDENCE 계약 본 EVIDENCE 본문 정합 default) |

## Pre-EVIDENCE Contract

- Read evidence: paste source §0~§11 + 직전 cycle 측 본 cli session 측 신설한 cross-repo-parallel-exec.md 본문 (= 197 line · §1~§8) + 직전 cycle 측 본 cli session 측 신설한 부모 mount root CLAUDE.md 본문 (= 123 line · §1~§8) + master CLAUDE.md §15 entry (= 직전 cycle entry 정합)
- Remaining gaps: §FREEDOM 영역 결정 의제 (= 신 sub-section 위치 + 본문 LOC + 호출 agent + commit 시점 + propagation 시점) → cli session 자체 결정 default · 본 EVIDENCE 측 결정 본문 인용
- Chosen path: cli infra paradigm 정정 강화 영역 default (= §2.2 expansion + §2.4 신설 + §3.4 신설 + 부모 mount root §4 expansion) + 5-repo byte-identical propagation default
- Hold / Stop reasons: 본 cycle 측 STOP 조건 5 영역 미해당 default (= paste source §6 정합 · 본 EVIDENCE §"STOP 검증" 참조)
- Implement entry conditions: baseline 실측 PASS + 보호 5 file sha drift 0 + dirty 영역 본 cycle scope 외 default 정합 + §FREEDOM 영역 결정 default

## Baseline 실측 결과 (= cycle 진입 시점)

### 5-repo HEAD sha (= paste source §0 정합)

| repo | full path | HEAD sha (실측) | paste source §0 sha | 정합 |
|---|---|---|---|---|
| claude-cli-master | `~/AndroidStudioProjects/claude-cli-master` | `e1cef8c15150c4ffe92241ed9c61e47af3bf7b85` | `e1cef8c1...` | ✓ |
| app-foundation | `~/AndroidStudioProjects/app-foundation` | `15a58f1e0421338bd6293170bf4fcc5f75010613` | `15a58f1e...` | ✓ |
| GentlyBreath | `~/AndroidStudioProjects/GentlyBreath` | `efa4b211aaed3c3ea2014c0f30a7574f62f1342c` | `efa4b211...` | ✓ |
| GentlyDay | `~/AndroidStudioProjects/GentlyDay` | `d70f2c5e8fb6101e3d06523084a83ce4cabdd1dc` | `d70f2c5e...` | ✓ |
| GentlyTable | `~/AndroidStudioProjects/GentlyTable` | `a29c09bb42c315aa9357499dffd388d4c48e2e91` | `a29c09bb...` | ✓ |

### 본 cycle scope file 진입 baseline sha (= paste source §0 정합)

- `.claude/rules/cross-repo-parallel-exec.md` = `c4651d6aa9466ad83ba0e00776e5f4a4606212d2` × 5-repo byte-identical ✓ (= 직전 cycle 신설 결과)
- 부모 mount root `CLAUDE.md` = `183ad618afc30940a46c90ba67b4b5b251274021ad0a912f7b2ff5341625b426` (sha-256 · git repo X · `shasum -a 256` 측정) ✓ (= 직전 cycle 신설 결과)

### 보호 5 file sha (= drift 0 의무 default)

| file | 실측 sha (= 5-repo byte-identical) | paste source §0 sha | 정합 |
|---|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `5b84cd9e4bc361652d6d0e561d8846eed3400d00` | `5b84cd9e...` | ✓ |
| `.claude/rules/pencil-uiux-workflow.md` | `20c72ae66b513bdc991a377f73688c23d1154bcc` | `20c72ae6...` | ✓ |
| `docs/design/pencil-sot-policy.md` | `b27fbe16edb688218d7e57dd9a66d0f2a31ef300` | `b27fbe16...` | ✓ |
| `.claude/rules/uiux-sot-refresh.md` | `d3a0b57390bd0414cc89283a571dd6ecb8cb1562` | `d3a0b573...` | ✓ |
| `docs/design/design-sot-policy.md` | `e580b6d7ca9a88aef67c03f4bb39360993ab996f` | `e580b6d7...` | ✓ |

= 보호 5 file sha drift 0 의무 default 정합 PASS ✓

### 본 cycle scope 외 dirty 영역 (= pre-existing baseline preservation 정합)

| repo | dirty file | 본 cycle scope |
|---|---|---|
| master | `.ai/nightly-baseline/2026-05-14.md` (M) + `.ai/nightly-baseline/2026-05-15.md ~ 2026-05-19.md` (??) | 외 (= nightly baseline 영역 · 직전 cycle 동일 영역 default) |
| app-foundation | `cc-paste-FND-SHARED-KMP-MODULE-ACTIVATE-001.md` (??) | 외 |
| GB | 다수 .ai/reports + .idea + cc-paste + composeResources/login/splash/ui + supabase/.temp (??) | 외 |
| GD | 다수 .ai/reports + .idea + cc-paste + composeResources/login/splash/ui + supabase/.temp (??) | 외 |
| GT | 다수 .ai/reports + .idea + cc-paste + supabase/.temp + docs/design/pencil-sot/daily-prescription/untitled.pen (??) | 외 |

= `§7.1 paste-back dirty baseline 패러다임` 정합 default (= pre-existing scope-외 dirty 보존 + 0 NEW dirty 검증 의무)

## §FREEDOM 영역 결정 본문

| 영역 | 결정 | 근거 |
|---|---|---|
| (A) Subscription-aware paradigm sub-section 위치 | **§2.4** (= §2 paradigm 분기 본문 안 신 sub-section default) | billing 측 paradigm 선택 영역 정합 default (= §2.1 영역 1 + §2.2 영역 2 + §2.3 paradigm 선택 본심 뒤 §2.4 billing-aware 본문 default · paradigm 분기 영역 통합 default) |
| (B) 영역 2 paradigm 본문 강화 위치 | **§2.2 영역 본문 정정** (= 기존 sub-section 본문 expansion default) | 본문 내부 expansion default · 사용자 본인 측 의무 영역 표 + 자식 cli infra 자동 정합 + subscription pool 정합 + trade-off 영역 본문 추가 default |
| (C) sub-agent 7× token cost warning sub-section 위치 | **§3.4** (= §3 자식별 cwd 분리 paradigm 영역 내 신 sub-section default) | 영역 1 sub-agent fan-out 측 실제 token 비용 영향 영역 default · §3 자식별 cwd 분리 paradigm 영역 본문 영역 default |
| (D) 부모 mount root CLAUDE.md §4 정정 위치 | **§4 본문 정정 강화** (= 기존 §4 본문 expansion default) | 영역 1 / 영역 2 / 영역 3 분기 표 + subscription-aware paradigm 본문 + 사용자 본심 영역 + 영역 2 진입 paradigm 본문 추가 default |

## Collect Results

### 매칭 파일/패턴

- paste source 본문 단일 SoT (= 363 line · §0~§11 본문 정합)
- 직전 cycle 측 본 cli session 측 신설한 `cross-repo-parallel-exec.md` 본문 (= 197 line · §1~§8 · 본 cycle 정정 강화 대상)
- 직전 cycle 측 본 cli session 측 신설한 부모 mount root `CLAUDE.md` (= 123 line · §1~§8 · 본 cycle §4 정정 강화 대상)
- master `CLAUDE.md` §15 entry (= 직전 cycle entry 정합 · 본 cycle entry append 위치)
- `scripts/propagate.sh` (= 본 cycle propagation 측 자체 실행 paradigm · 4 자식 default)
- `scripts/repo-config.sh` (= `TARGET_REPOS` 단일 SoT · default = "GentlyBreath GentlyDay GentlyTable app-foundation")

### 0 Matches (= 부재 증거)

- 본 cycle 측 신 file 신설 영역 X default (= paste source §2.2 정합 · 본 cycle = 정정 강화 영역 default)

## Key Findings

1. **5-repo HEAD sha + 보호 5 file sha drift 0 정합 PASS** (= paste source §0 baseline 정합 default)
2. **본 cycle 정정 강화 file × 5-repo byte-identical PASS** (= propagation 직후 측정 결과 정합 default):
   - `cross-repo-parallel-exec.md` = `fa83265571a269e8053eadeb0d47ba2bbaf4a36f` × 5-repo (= 진입 `c4651d6a` → 신 sha · 정정 강화 결과)
3. **부모 mount root CLAUDE.md sha-256** = `44030bbe8ab8abdf95cb59478a94a892dd1ef05cc114963632020910b13e4bc1` (= 진입 `183ad618...` → 신 sha · §4 정정 강화 결과 · git repo X default · `shasum -a 256` 측정)
4. **§FREEDOM 영역 결정**:
   - §2.4 Subscription-aware paradigm = 신설 default
   - §2.2 영역 2 paradigm = 본문 강화 default
   - §3.4 Sub-agent token cost warning = 신설 default
   - 부모 mount root CLAUDE.md §4 = 본문 정정 강화 default
5. **verify-sync.sh 측 drift 3 + miss 4 = 본 cycle scope 외 영역** (= 직전 cycle 동일 영역 default):
   - `intake-router.md` drift @ foundation (= 직전 cycle 측 발견 default · 별 cycle 분리)
   - `gradlew` + `gradlew.bat` drift @ foundation (= foundation 측 build script 영역 · 본 cycle scope 외)
   - `docs/baseline/cowork-project-instructions-§20-redline-20260517.md` miss × 4 자식 (= master 단일 file · 본 cycle scope 외)
6. **production code touch 0 LOC verify**:
   - 본 cycle 측 변경 영역 = cli infra (`.claude/rules/cross-repo-parallel-exec.md`) + 부모 mount root `CLAUDE.md` §4 + master `CLAUDE.md` §15 + `.ai/reports/` 단일 default
   - production code (= app/ + composeApp/ + core/ + domain/ + shared/) 무접촉 의무 정합 PASS ✓

## STOP 검증 (= paste source §6 정합)

| # | trigger | 본 cycle 측정 결과 |
|---|---|---|
| 1 | 보호 5 file sha drift 발견 | **PASS** (= 5-repo byte-identical 정합 default · drift 0) |
| 2 | 비가역 변경 징후 | **PASS** (= file 정정 강화 + sub-section 신설 default · 비가역 변경 X) |
| 3 | HIGH RISK 도메인 진입 (DB / Money / Auth) | **PASS** (= cli infra paradigm 영역 default · 미해당) |
| 4 | 사용자 본심 분기 의제 본질 발견 | **PASS** (= §FREEDOM 영역 결정 cli session 자율 default · 본심 분기 의제 발견 X) |
| 5 | production code touch 징후 | **PASS** (= 0 LOC touch 의무 default · production code 무접촉) |

## Cleanup Assessment

N/A (= ops-layer task · 제품 코드 미변경)
