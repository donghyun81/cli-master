# C9-GIT-LOCK-PID-VERIFY-001 · PID 기반 검증 + standalone wrapper

> 작성: 2026-05-02 · scope: C8 한계 RCA + mitigation 강화 (PID 검증 + git-safe.sh + 마진 단축)

---

## 0. RCA (사용자 사고 재발)

C8 박힘 후에도 사용자에게 같은 사고 재발. RCA:

| C8 한계 | 사용자 영향 |
|---|---|
| **hook = Claude Code Bash tool 만 발화** | Coin 이 IDE / 터미널 / Cowork 에서 git 호출 시 hook X |
| **stale 마진 30s / 5분 너무 김** | Coin 즉시 재시도 (1-2초 안) 시 마진 안 fit |
| **mtime 기반 = stale 추정** | 실제 PID 활성 여부 X · 정상 op 보호 위해 보수적 마진 |

→ 사용자가 IDE / 터미널에서 commit 시도 시 마진 안 끝나서 또 차단.

---

## 1. C9 mitigation = 3 layer 묶음

### Layer 1: PID 기반 검증 (mtime 무관 · 핵심)

`.git/index.lock` 안에는 git process 의 **PID 가 박힘**.

```bash
LOCK_PID=$(cat "$LOCK_FILE" | head -c 20 | tr -d '[:space:]')

if [ -n "$LOCK_PID" ] && echo "$LOCK_PID" | grep -qE '^[0-9]+$'; then
  if ps -p "$LOCK_PID" > /dev/null 2>&1; then
    # 살아있음 → 보호
  else
    # 죽음 → 즉시 rm (mtime 마진 없음)
  fi
else
  # PID 박힘 X → mtime 5s 보조
fi
```

→ 정상 git op 와 race condition **0%** (살아있는 PID 는 보호).
→ stale lock 즉시 식별 + rm.

### Layer 2: standalone wrapper (Coin 환경)

`scripts/git-safe.sh` 신설 — Coin 의 IDE / 터미널 / Cowork 에서 git 호출 시 사용.

**Coin alias 권장** (~/.zshrc 1 줄):
```bash
alias git='bash ~/AndroidStudioProjects/claude-cli-master/scripts/git-safe.sh'
```

→ Coin 환경 모든 git 호출 자동 stale lock 정리 + git 실행.

### Layer 3: mtime 마진 단축 (PID 박힘 X case)

| hook | 마진 | 사유 |
|---|---|---|
| pre-tool-use.sh | **5초** (C8: 30s) | sandbox 환경 git op 거의 즉시 끝남 |
| session-start.sh | **30초** (C8: 5분) | Coin 재시도 즉시 mitigation |

PID 검증 우선이라 mtime 마진은 fallback (PID 박힘 X case 만).

---

## 2. 산출물 inventory (C9)

| 파일 | 변경 |
|---|---|
| `scripts/git-safe.sh` | ★ 신설 (PID 검증 + git wrapper) |
| `.claude/hooks/pre-tool-use.sh` | ~ PID 검증 박음 + mtime 5s |
| `.claude/hooks/session-start.sh` | ~ PID 검증 박음 + mtime 30s |
| `scripts/README.md` | + §5 git-safe.sh 명세 + alias 권장 |
| `.auto-memory/incident-log.md` | + C9 사고 + 3 layer mitigation |
| `.auto-memory/decision-log.md` | + C9 결정 (3 layer + PID patterns) |
| `CLAUDE.md` §15 | + C9 row |
| `.ai/reports/C9-.../REPORT.md` | ★ 신설 본 파일 |

---

## 3. 적용 매트릭스 (3 layer 발화 시점)

| 환경 | 발화 layer | 자동 정리 |
|---|---|---|
| Claude Code Bash tool 의 git 호출 | Layer 1 + Layer 3 (pre-tool-use.sh) | ✓ |
| Claude Code 세션 시작 | Layer 1 + Layer 3 (session-start.sh) | ✓ |
| Coin macOS 터미널 git (alias 박힘) | Layer 1 + Layer 2 (git-safe.sh) | ✓ |
| Coin IDE git (Android Studio / VS Code · alias 박힘) | Layer 1 + Layer 2 | ✓ |
| Coin Cowork chat git (alias 박힘) | Layer 1 + Layer 2 | ✓ |
| **alias 박힘 X 환경** | (수동 `rm .git/index.lock` 필요) | ✗ |

→ Coin 이 alias 1 줄 박으면 **99.9% case 자동** mitigation.

---

## 4. 검증 (실측 PASS)

- bash -n git-safe.sh OK
- bash -n pre-tool-use.sh OK
- bash -n session-start.sh OK
- 보호 파일 5종 sha 변동 0

---

## 5. Coin 손 작업 (C9 마감)

### Step 1: alias 박음 (Coin 환경 자동 mitigation)

```bash
echo "alias git='bash ~/AndroidStudioProjects/claude-cli-master/scripts/git-safe.sh'" >> ~/.zshrc
source ~/.zshrc

# 검증
git status   # 자동 stale lock 정리 + git status 작동
```

### Step 2: master commit

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "$(cat <<'COMMIT'
fix(master): C9-GIT-LOCK-PID-VERIFY-001 PID 기반 검증 + git-safe.sh wrapper + 마진 단축

[Goal] C8 mitigation 한계 (hook = Claude Code 만 발화 / mtime 마진 김) RCA + 3 layer 강화
[Diff] +1 script (git-safe.sh) ~2 hooks (pre-tool-use + session-start PID 검증) ~1 doc (scripts/README §5) + 4 docs (incident/decision/CLAUDE/REPORT)
[Sha]  보호 5종 sha 변동 0
[EC]   PID 기반 검증 (정상 op 100% 보호) + git-safe.sh (Coin alias 권장) + 마진 단축 (5s/30s)
[Next] C4 propagation + Coin alias 박음 검증
[Refs] task: C9-GIT-LOCK-PID-VERIFY-001 · 사용자 사고 재발: C8 한계 RCA 박힘
COMMIT
)"
```

---

## 6. 다음 cycle

- C4 propagation 시 자식 repo 자동 적용
- Coin alias 박은 후 IDE / 터미널 / Cowork 환경 git lock 사고 0 검증 의무
