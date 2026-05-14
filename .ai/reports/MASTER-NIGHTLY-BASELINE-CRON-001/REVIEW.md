# REVIEW — MASTER-NIGHTLY-BASELINE-CRON-001

## Technical Review

> Risk = Low (ops-layer · 단일 repo · 보호 파일 무접촉 · 자식 repo read-only · 비가역 변경 X)
> Risk 기반 경량화 적용: §1 Requirements / §2 Regression / §11 Secrets · UI 변경 X 이므로 §5 Model Separation 추가 의무 X.

### 1. Requirements Coverage

- [x] 산출물 = bash 측정 + claude -p 1 회 종합 + markdown 리포트 → `.ai/nightly-baseline/<date>.md` + `latest.md` [CONFIRMED — `bash scripts/nightly-baseline-report.sh` 2 차 호출 PASS · 6369 byte markdown 생성]
- [x] 위치 = `claude-cli-master/scripts/` 안 야간 잡 + plist + install [CONFIRMED — `scripts/nightly-baseline-report.sh` + `scripts/com.coin.nightly-baseline-report.plist` + `scripts/install-nightly-baseline-report.sh`]
- [x] 스케줄 = launchd 매일 04:00 KST [CONFIRMED — plist `StartCalendarInterval Hour=4 Minute=0`]
- [x] 리포트 = Markdown → `.ai/nightly-baseline/` (기존 `.ai/baseline-snapshot/` 의 JSON 과 분리) [CONFIRMED — 신규 dir]
- [x] 리포트 본문 = 보호 파일 N-repo 정합 + cli infra drift + 진행 중 cycle 미완 항목 + 부모 패키지 본 작업 정의 + repo 도메인 명단 + 측정 timestamp(KST) [CONFIRMED — 2 차 출력 latest.md head 검증]
- [x] install ≠ activation 사고 패턴 mitigation = self-test 1 회 강제 실행 + 출력 file 생성 검증 + READ-ONLY 무변동 검증 [CONFIRMED — VERIFY.md 4 검증 명령 모두 PASS]
- [x] READ-ONLY 의무 = 보호 파일 5종 × 5-repo sha 변동 0 + 자식 4 repo git status PRE = POST [CONFIRMED — diff 0]
- [x] claude -p read-only 의무 = `--tools ""` (모든 도구 비활성) + `--setting-sources ""` (settings.json 미로드 → hook 발화 0) + `--max-budget-usd 0.50` cap [CONFIRMED — script line 213-220]
- [x] commit 단위 = CLI 자체 판단 = 본 cycle 의 산출물 8 file 단일 commit [PENDING — 본 REVIEW 직후 발화]

### 2. Regression Risk

- 변경 영향 범위: master repo 안 신설 영역 (scripts 3 file + .ai/reports 5 file + .ai/nightly-baseline 출력 dir) 만. cli infra (.claude/) 무접촉 · 보호 파일 5종 sha 변동 0 · 자식 repo read-only.
- 회귀 위험 없음 — [CONFIRMED — verify-sync 회귀 0 검증 PASS · 기존 drift 2 (app-foundation gradlew) 는 본 cycle prompt §0 명시 baseline · 추가 drift = 0]
- 본 cycle 의 산출물 추가 후 verify-sync.sh 검증 명단 변동 X (scripts/ 직속 신규 = CORE_CLI 명단 X · 전체 검증 find scope 도 `.claude docs scripts/agent .ai/promptfit .ai/uiux-sot/refresh .github` 한정 · scripts/ 직속 추적 영역 X).

### 11. Secrets Safety

- 시크릿 노출 없음 — [CONFIRMED — scripts 안 ANTHROPIC_API_KEY / 토큰 / API key 하드코딩 X · claude -p OAuth keychain 채택 (Coin 의 정상 인증 영역 재사용) · `--max-budget-usd 0.50` cap 으로 비용 예산 cap]
- compound-lint 시크릿 스캔 스코프 = `.ai/reports/<taskId>/` — 본 cycle 보고서 안 시크릿 패턴 X 의무 [CONFIRMED — 보고서 5 file (PLAN/EVIDENCE/VERIFY/REVIEW/TODO) 안 변수명만 인용 (`ANTHROPIC_API_KEY`) · 실 값 0]

## Findings

- 1 차 호출 진단 결과 = `--bare` flag 가 OAuth keychain 차단으로 `Not logged in` fallback 발화 [CONFIRMED — claude --help 명시: "Anthropic auth is strictly ANTHROPIC_API_KEY or apiKeyHelper via --settings"]. mitigation = `--bare` 제거 + `--setting-sources ""` 채택. 2 차 호출 PASS.
- LLM 종합 품질 = TL;DR 3 줄 + 측정 데이터 안에서 "재개 우선 cycle" 단서 (MASTER-LIBS-VERSIONS-CROSS-VERIFY-HOOK-001 = 유일하게 TODO 10 항목 잔존) 자동 추출 — 본 cycle 의도 부합.
- 본 잡 안 fallback patterns 도 정상 동작 검증됨 (1 차 호출 시 raw 측정 data 그대로 markdown 박힘 + 끝쪽에 claude -p stderr 진단 영역 박힘) — 향후 claude -p 회귀 시 graceful degradation 보장.

## Verdict

PASS

## Remaining Risks

- **6/15 이후 Agent SDK $200 풀 차감 영역**: 야간 1 회 호출 + `--max-budget-usd 0.50` cap 으로 월 ~15 USD 미만 예상. 별 cycle 안 실측 후보 (TODO §1).
- **claude binary path drift**: nvm 노드 버전 갱신 시 `/Users/yundonghyeon/.nvm/versions/node/v22.21.1/bin/claude` 가 변동 가능. mitigation = 잡 안 `resolve_claude()` 함수가 runtime `command -v claude` 우선 + nvm path glob fallback + Homebrew/local 절대경로 fallback patterns 보유 (script line 39-54). 노드 다중 버전 환경에서도 가장 최근 버전 채택.
- **launchctl 등재 단계 검증 부재**: 본 CLI 가 직접 `bash install-nightly-baseline-report.sh` 호출 X (= sandbox 외 시스템 영향 영역 · 사용자 손 작업 의무). install script 안 자체 self-test (launchctl list 등재 검증 + kickstart 1 회 + 출력 file 90 초 대기 검증) 보유 — Coin install 실행 시 자동 발화.
- **app-foundation gradlew drift 2**: 본 cycle prompt §0 명시된 기존 baseline · 본 cycle scope 외. 별 cycle 안 정정 후보.

---

## PromptFit

PromptFitScore: 92/100
PromptFitVerdict: PASS
PromptFitBreakdown:
- Requirement Alignment: 25/25 — Coin §4 4 축 결정 (하이브리드 / scripts 위치 / launchd 04:00 / Markdown → .ai/nightly-baseline) 모두 부합. §3 READ-ONLY 의무 자체 검증 PASS.
- Scope Control: 19/20 — 단일 repo scope 정합. cli infra / 보호 파일 / 자식 repo 무접촉. 단 fallback 안 stderr 디버그 영역 박음으로 5443→6369 byte 약간 ↑ (Low Risk).
- Evidence/Verify Quality: 18/20 — 검증 명령 6 건 + LOG 4 entry + READ-ONLY diff 0 명시. UNKNOWN = launchctl 등재 (사용자 손 작업 영역) 명시.
- Risk/STOP Handling: 10/10 — Low Risk · STOP 트리거 0 · 비가역 변경 0.
- Output Contract Compliance: 10/10 — 보고서 5 file (EVIDENCE/PLAN/VERIFY/REVIEW/TODO) 정합 · cleanup assessment N/A 명시 · `[EVIDENCE]→[DIFF]→[LOG]` stdout 순서 본 REVIEW LOG 안 박힘.
- Prompt Efficiency/Clarity: 10/15 — claude -p 첫 호출 시 `--bare` flag 진단 1 회 소요 (-5). 사후 mitigation 명시 박힘.

PromptFitIssues:
- 1 차 호출 시 `--bare` flag 가 OAuth keychain 차단 root cause 진단 1 회 소요 (claude --help 안 명시 spec 사전 인용 X 영역).

PromptFitNextActions:
- 6/15 이후 본 잡 월 실 비용 측정 (별 cycle 후보 · TODO §1).
- launchctl 등재 후 04:00 KST 자연 발화 1 차 측정 (Coin 손 작업 1 회 + 다음 날 아침 검증).

PromptFitConfidence: HIGH
