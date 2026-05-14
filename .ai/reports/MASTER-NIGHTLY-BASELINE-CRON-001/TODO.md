# TODO — MASTER-NIGHTLY-BASELINE-CRON-001

## Coin 손 작업 의무 1 줄 (본 cycle 마감 직후 1 회)

```
bash $HOME/AndroidStudioProjects/claude-cli-master/scripts/install-nightly-baseline-report.sh
```

자동 동작:
1. `~/Library/LaunchAgents/com.coin.nightly-baseline-report.plist` 신설 (HOME 치환)
2. `launchctl unload`(기존) → `load`(신규)
3. `launchctl list | grep com.coin.nightly-baseline-report` 등재 검증
4. `launchctl kickstart -k gui/<uid>/com.coin.nightly-baseline-report` 1 회 즉시 강제 실행 (install ≠ activation 사고 패턴 mitigation)
5. `.ai/nightly-baseline/<today>.md` + `latest.md` 생성 90 초 대기 검증
6. 마감 보고 1 줄 출력

이후 매일 04:00 KST 자동 발화. 아침에 `cat ~/AndroidStudioProjects/claude-cli-master/.ai/nightly-baseline/latest.md` 또는 IDE 안 file 직접 열기.

## Deferred (lazy · 별 cycle 후보)

### §1. 6/15 이후 Agent SDK 실 비용 측정

- 잡 안 `--max-budget-usd 0.50` cap 으로 호출 1 회당 상한 박힘 · 야간 1 회 / 월 ~31 회 / 추정 ~15 USD 미만.
- 6/15 이후 실측 1 주차 후 별 cycle 진입 (= measurement-driven adjust). cap 조정 또는 호출 빈도 조정 후보.

### §2. claude binary path drift 자동 진단

- 현 시점 resolve 우선순위: `command -v claude` → nvm path glob `~/.nvm/versions/node/*/bin/claude` (가장 최근 버전) → Homebrew/local 절대경로 fallback.
- nvm 노드 버전 갱신 빈도 ↓ + 본 fallback patterns 견고 → lazy default.
- 회귀 발생 (= 잡 안 `claude_bin=(부재)` log 발화 시) 별 cycle 진입.

### §3. app-foundation gradlew drift 2 정정

- 본 cycle prompt §0 명시 baseline · scope 외.
- master gradlew = `3238afb2aed5` ↔ app-foundation = `734b3879d350` drift (gradlew.bat 도 동일 분류).
- Gradle wrapper version mismatch 정정 cycle 별도 후보.

### §4. 잡 안 hook 발화 (= `.ai/baseline-snapshot/<ts>.json`) 추가 분석

- 현 잡 안 `--setting-sources ""` 채택으로 hook 발화 0 영역 도달 검증됨 (POST git status diff 0).
- 향후 settings.json 안 hook spec 변동 시 본 영역 재검증 의무.

## 본 cycle 마감 조건 (모두 충족)

- [x] 보고서 5 file (EVIDENCE / PLAN / VERIFY / REVIEW / TODO) 작성
- [x] scripts 3 file (nightly-baseline-report.sh + plist + install) 작성
- [x] `.ai/nightly-baseline/` 출력 dir 신설 + .gitkeep
- [x] self-test 1 회 강제 실행 PASS (6369 byte 종합 markdown)
- [x] READ-ONLY 검증 PASS (보호 파일 sha + 자식 repo git status 변동 0)
- [x] verify-sync 회귀 0 검증 PASS
- [ ] commit 1 건 (본 cycle 산출물 묶음 · CLI 직접 발화 의무 · cycle-discipline §5 v2 자동 허용 카테고리 = chore/infra)
- [ ] Coin 손 작업 1 줄 보고 (본 chat 안 마감 보고)
