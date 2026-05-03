# REVIEW — MASTER-AUTH-DOMAIN-ACTIVATE-001

## Technical Review

> **Risk = Low + ops-layer (lightweight 4-file)**: §1 Requirements Coverage + §2 Regression Risk + §11 Secrets Safety 의무. 나머지 N/A.

### 1. Requirements Coverage

- [x] §3-1 master 측 `auth-rules.md` 신설 — 10 섹션 (§1~§10) 박힘 [CONFIRMED · `.claude/rules/auth-rules.md` 디스크 존재]
- [x] §3-2 `deferred-domains.md` §2 Auth 행 ACTIVE + 1 footnote + §6 history 신설 [CONFIRMED · grep "ACTIVE" 매치]
- [x] §3-3 `routing-and-delegation.md` 의 `auth-security-privacy` 에서 [DEFERRED] 라벨 제거 + 활성 매핑 (`active/auth-security-privacy.md`) [CONFIRMED · grep 매치]
- [x] §3-4 agent mv (`deferred/auth-security-privacy.md` → `active/auth-security-privacy.md`) + 본문 SoT 인용 (`auth-rules.md`) 갱신 [CONFIRMED · activate-agent.sh 자동]
- [x] §3-5 3-repo propagation (4 files × 3 repos = 12 ok / fail 0) + 자식 deferred 정리 (3/3 git rm) [CONFIRMED · propagate.sh + git rm 출력]
- [x] EC1-EC3 PASS (verify-sync 104/0/0) [CONFIRMED · VERIFY.md LOG]
- [x] Path rebind decision 박음 (`decision-log.md`) [CONFIRMED · 2026-05-02 entry]
- [x] Coin 추가 의뢰 (GD/GB 경로 실측) 박음 [CONFIRMED · ls -d ~/AndroidStudioProjects/Gently* 3 매치]

### 2. Regression Risk

- 변경 영향 범위: cli infra (rules / agents) + 1 신규 rule SoT. 자식 repo product code 무변경.
- 회귀 위험 없음: ops-layer task. 빌드 / 테스트 영향 0 (Compose 코드 미건드림).
- 보호 파일 4종 sha 무변경 검증 (PLAN baseline = 5aa52b23 / 6297080a / 96de2f5d / 1f871447 그대로).
- propagate.sh WARN false positive (보호 파일 실측 무변경 confirm) — 별 trail post-correction lazy.

### 3-10. N/A

(Risk = Low · ops-layer · DependencyDecision / ArchitectureImpact / ModelBoundary / ErrorPolicy / UIStateFlow / TestabilitySeams / DocSync 모두 해당 사항 무.)

### 11. Secrets Safety

- 시크릿 / API key / 토큰 값 본 cycle 4 신규/갱신 파일에 박힌 흔적 0
- `auth-rules.md` 의 §3 토큰 저장 의무 = `EncryptedSharedPreferences` 사용 의무 박음 (변수명만 · 값 X)
- HTTP 금지 + plaintext 토큰 SharedPreferences 금지 박음 (`safety-and-secrets.md` 정합)

### 12-13. N/A (ops-layer task)

## Findings

- master 측 `gently-master` baseline 으로 통일 (path rebind cycle 중간 박음). 사고 1 mitigation (claude-cli-master 경로 부재) — `decision-log.md` 박힌 Decision 1.
- propagate.sh / activate-agent.sh 의 `MASTER_DIR=$HOME/AndroidStudioProjects/gently-master` env override 박음 (script 자체 hardcoded `claude-cli-master` 미정정 · TODO post-correction lazy).

## Verdict

**PASS**

## Remaining Risks

- propagate.sh WARN ("보호 파일 baseline 변경 감지") false positive 박힘 — 별 trail post-correction lazy (script 측 baseline 비교 logic 점검 의무).
- `scripts/activate-agent.sh` + `scripts/propagate.sh` hardcoded `claude-cli-master` 경로 미정정 — TODO.md 박음.
- 자식 repo (GD / GB) 측 Auth 도메인 활성화 = 별 cycle (`.claude/rules/deferred-domains.md` §4 절차 따름).
