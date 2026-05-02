# C14 + C13 + C15 묶음 cycle · master 정비 3 종

> 작성: 2026-05-02 · 묶음 사유: 3 cycle 모두 작음 (총 ~55 분) + 의존성 직선 + 충돌 영역 X
> Coin 본 의도: "한꺼번에 요청해도 될 것 같은데"

---

## 0. 묶음 결과 한 줄

3 cycle 모두 sandbox 적용 + syntax check + 자체 검증 통과. Coin 손 작업 1 paste (commit + 옵션 검증) 대기.

---

## 1. C14-PROPAGATION-COVERAGE-001 — `.gitignore` patch 자동화

### 사고
master `.gitignore` 12 줄에 `.claude/settings.local.json` 등록 / 자식 3 모두 미등록 → Coin git status 매번 untracked 1 노이즈.

### 정책 변경 (사전 검증 후)
초안 = "master `.gitignore` byte-identical cp" → **위험 발견**: 자식 `.gitignore` 가 Android Studio build/gradle 패턴 갖고 있음. master 로 단순 cp = 자식 빌드 차단.

→ **변경**: master `.gitignore` 자체는 propagate X (자식 자율 영역). 별 patch script 가 master cli infra patterns 만 자식 `.gitignore` 에 보장 (idempotent).

### 산출물
- 신설: `scripts/ensure-child-gitignore-patches.sh` (--verify / --target / patch 자동)
- 수정: `scripts/propagate.sh` 마지막 + ensure-child-gitignore-patches.sh 자동 호출 (warning 만, 실패도 propagation 영향 X)
- 자식 3 `.gitignore` 에 marker block 추가:
  ```
  # === claude-cli-master propagation patterns (auto-managed) ===
  # master cli infra 와 동기 의무. 직접 수정 금지.
  .claude/settings.local.json
  .ai/hooks/*.log
  .ai/traces/*.jsonl
  ```

### 효과
| before | after |
|---|---|
| Coin git status 매번 `?? .claude/settings.local.json` | 자식 git status clean |
| 자식 .gitignore drift | marker block byte-identical (3-repo) |
| propagate.sh = .gitignore 무관 | propagate.sh = .gitignore patches 자동 보장 (idempotent) |

---

## 2. C13-DAEMON-AUTOCHECK-001 — `verify-sync.sh` daemon 자동 진단

### 사고 (C12 RCA)
C8/C9/C10/C11 mitigation 모두 적용된 상태에서 C12 lock 사고 또 발생 → 근본 원인 = launchd daemon `com.coin.git-lock-cleaner` 미활성 (install 누락 또는 unload). hook 자동 정리 = Claude Code Bash tool 만 발화 → Coin 의 macOS 터미널 / Cowork chat git op = daemon 만이 유일한 자동 mitigation. daemon 미활성 = 영구 lock.

### 산출물
- 수정: `scripts/verify-sync.sh` 상단 30 줄 추가 (인자 파싱 직후 + cd MASTER_DIR 직전):
  - `launchctl list | grep com.coin.git-lock-cleaner` 검증
  - daemon 미활성 시 → install 명령 권장 (plist 존재 여부 따라 분기)
  - daemon 활성 + log mtime > 1시간 = "stuck 의심" 경고
  - macOS 외 OS (sandbox Linux 등) = launchctl 부재 → 자동 skip
  - `--skip-daemon-check` flag 신설 (필요 시 우회)

### 효과
| 시나리오 | before | after |
|---|---|---|
| Coin daemon install 누락 | 사고 발생 후 RCA (C12 처럼) | `verify-sync` 매 호출 시 자동 발견 + install 명령 권장 |
| daemon 활성하나 stuck | 1시간 이상 lock 잔존 가능 | log mtime > 1시간 → 자동 경고 |
| 자식 propagate 시 daemon 검증 | 별도 점검 의무 | propagate 후 verify-sync 호출 시 자동 |

---

## 3. C15-PROPAGATE-PRUNE-001 — `propagate.sh --prune` dry-run 모드

### 사고 (C4-VERIFY 경험)
master 에서 파일 rm 후 자식에 영구 잔존 (ex. deprecated 6 rules pointer × 3 자식 = 18 잔존). propagate.sh = cp 일방향 → orphan 미감지. 18 파일 rm 의 Coin 손 작업 1 paste 의무.

### 정책 변경 (sandbox 검증 중 발견)
초안 = "전 cli infra base path orphan 검사" → **위험 발견**: 자식의 도메인 영역 (docs/setup/DDL, docs/design/pencil-sot/.pen, scripts/agent/repo-config.sh, docs/agent/solutions/MANAGED_AGENTS_READINESS.md, .ai/promptfit/INDEX.md 등) 311 파일이 **false positive orphan** 으로 표시. `--apply` 실행 시 도메인 전체 날아감.

→ **변경 (whitelist 접근)**:
- default = `.claude/` 만 prune 후보 (master SoT 영역)
- root 파일 = default 제외 (gradlew 등 자식 build 영향)
- 자식 도메인 영역 = 자율 = 절대 prune 안 함
- 향후 확장 (`--include <path>` flag) = 별 cycle 검토

### 산출물
- 수정: `scripts/propagate.sh` 인자 + 새 모드 분기 추가:
  - `--prune` flag (dry-run · default · 안전)
  - `--apply` flag (실제 rm · `--prune` 와 함께 명시 의무)
  - whitelist `.claude/` 만 검사
  - exclude `.DS_Store` + `settings.local.json`
  - dry-run 모드 = orphan list 출력 + 적용 명령 안내
  - apply 모드 = 자식 rm + git add 자동 + 요약 통계

### 효과
| 시나리오 | before | after |
|---|---|---|
| master 에서 파일 rm | 자식 영구 잔존 (drift 누적) | `propagate --prune --apply` 자동 정리 |
| C4-VERIFY 같은 광역 사고 | Coin 손 작업 paste 100 파일 | dry-run 검토 후 1 paste apply |
| 도메인 영역 안전성 | (--prune 미존재) | whitelist .claude/ 만 = false positive 0 |
| dry-run vs apply | (없음) | 명확 분리 (`--apply` 명시 의무) |

### 자체 dry-run 검증
```
[propagate --prune] 총 orphan 0 (DRY-RUN · 실제 rm 없음)
```
현재 자식 `.claude/` = master 와 정합 ✓ → orphan 0 = expected (C4-VERIFY Coin 손 작업 후 baseline).

---

## 4. 묶음 검증 결과

| cycle | syntax check | sandbox 자체 검증 | 효과 즉시 체감 |
|---|---|---|---|
| C14 | ✓ ensure-child-gitignore-patches.sh + propagate.sh | --verify 모드 = 자식 3 모두 ✓ | git status 노이즈 제거 |
| C13 | ✓ verify-sync.sh | sandbox = launchctl 부재 → 자동 skip + 정상 작동 | Coin 환경 = daemon 미활성 즉시 발견 |
| C15 | ✓ propagate.sh | --prune dry-run = orphan 0 (whitelist 정확) | 향후 master rm 사고 자동 mitigation |

---

## 5. Coin 손 작업 1 paste (master 3 commit + 자식 3 × 1 commit)

```bash
cd ~/AndroidStudioProjects

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 0: 광역 lock 정리 (C12 사고 대비)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
for r in {gently-master,GentlyBreath,GentlyDay,GentlyTable}; do
  [ -d "$r/.git" ] || continue
  for lk in index.lock HEAD.lock packed-refs.lock config.lock; do
    rm -f "$r/.git/$lk"
  done
  find "$r/.git/refs" -name "*.lock" -type f -delete 2>/dev/null
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 1: master commit C14 (ensure-child-gitignore-patches.sh + propagate.sh)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
cd ~/AndroidStudioProjects/gently-master && \
chmod +x scripts/ensure-child-gitignore-patches.sh && \
git add scripts/ensure-child-gitignore-patches.sh scripts/propagate.sh && \
git commit -m "feat(propagation): C14-PROPAGATION-COVERAGE-001 — .gitignore patches 자동 보장

- 신설: scripts/ensure-child-gitignore-patches.sh (idempotent · --verify 모드)
- 수정: scripts/propagate.sh 마지막 ensure-child-gitignore-patches.sh 자동 호출
- 자식 3 .gitignore = marker block 으로 master cli infra patterns 자동 patch
- 효과: Coin git status untracked .claude/settings.local.json 노이즈 제거"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 2: master commit C13 (verify-sync daemon autocheck)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
git add scripts/verify-sync.sh && \
git commit -m "feat(verify-sync): C13-DAEMON-AUTOCHECK-001 — launchd daemon 자동 진단

- 추가: verify-sync.sh 상단 launchctl list grep + daemon 미활성 자동 경고
- 추가: log mtime > 1시간 = stuck 의심 경고
- 추가: --skip-daemon-check flag (우회 옵션)
- macOS 외 OS = launchctl 부재 → 자동 skip
- 효과: C12 사고 패턴 (daemon install 누락) 자동 발견 + install 명령 권장"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 3: master commit C15 (propagate --prune)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
git add scripts/propagate.sh && \
git commit -m "feat(propagate): C15-PROPAGATE-PRUNE-001 — --prune dry-run 모드 신설

- 신설: --prune flag (dry-run default · 안전)
- 신설: --apply flag (실제 rm · --prune 와 함께 명시 의무)
- 안전 정책: whitelist .claude/ 만 prune 후보 (자식 도메인 영역 X)
- exclude: .DS_Store + settings.local.json
- 효과: master rm 사고 시 자식 자동 mitigation (C4-VERIFY 같은 광역 정리 자동화)"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 4: master commit memory + REPORT
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
git add .auto-memory/decision-log.md .auto-memory/incident-log.md \
        .ai/reports/C14-C13-C15-INFRA-MITIGATION-001/REPORT.md \
        CLAUDE.md && \
git commit -m "docs(memory): C14+C13+C15 묶음 cycle 보고서 + memory 갱신"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 5: 자식 3 commit (.gitignore patch 만 = C14 영향)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
for repo in GentlyBreath GentlyDay GentlyTable; do
  cd ~/AndroidStudioProjects/$repo && \
  git add .gitignore && \
  git commit -m "chore(gitignore): C14-PROPAGATION-COVERAGE-001 — master cli infra patterns patch

- marker block 추가: claude-cli-master propagation patterns
- patches: .claude/settings.local.json + .ai/hooks/*.log + .ai/traces/*.jsonl
- 효과: git status 의 untracked .claude/settings.local.json 노이즈 제거
- 자동 관리: master scripts/ensure-child-gitignore-patches.sh idempotent"
  cd ~/AndroidStudioProjects
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 6: 검증 — verify-sync (daemon 진단 자동 호출)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
cd ~/AndroidStudioProjects/gently-master && \
bash scripts/verify-sync.sh

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 7: 검증 — --prune dry-run (orphan 0 expected)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
bash scripts/propagate.sh --prune

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 8: 검증 — ensure-child-gitignore-patches --verify
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
bash scripts/ensure-child-gitignore-patches.sh --verify
```

---

## 6. 기대 결과 (Coin 손 작업 후)

| 검증 | 기대 |
|---|---|
| `verify-sync.sh` | PASS 103 / DRIFT 0 / MISS 0 + (daemon 미활성 시 install 권장 line 출력) |
| `propagate.sh --prune` | 총 orphan 0 (DRY-RUN) |
| `ensure-child-gitignore-patches.sh --verify` | 자식 3 모두 ✓ + exit 0 |
| 자식 git status | clean (settings.local.json 사라짐) |
| master commit 수 | 4 (C14 + C13 + C15 + memory) |
| 자식 commit 수 | 1 × 3 = 3 |

---

## 7. 다음 cycle 진입 권장

| 옵션 | 내용 |
|---|---|
| 자식 도메인 본 작업 (★★★) | GB / GD / GT 중 1 + 도메인 cycle 시작 |
| C16-PRUNE-INCLUDE-FLAG (★) | `propagate.sh --prune --include <path>` 신설 (필요 시) |

C14/C13/C15 마감 = master 정비 100%. 자식 본 작업 진입 baseline 확보.
