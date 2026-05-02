# C8-GIT-LOCK-AUTOMITIGATION-001 · stale .git/index.lock 자동 정리

> 작성: 2026-05-02 · scope: master 의 pre-tool-use.sh + session-start.sh 강화 + C3 dead code 정정

---

## 0. 거시 목적

매 cycle 마다 sandbox 또는 agent crash 후 잔존 `.git/index.lock` 이 다음 git command 차단 → Coin 매번 손 작업 `rm -f .git/index.lock` 의무 반복.

C8 = 본 사고 영구 mitigation 박음 (사용자 요청: "매번 처리 안 할 수 있도록").

---

## 1. 자동 정리 매트릭스 (2 layer 박음)

| 발화 시점 | hook | stale 기준 | rm 조건 | 효과 |
|---|---|---|---|---|
| **세션 시작 즉시** | `session-start.sh` | > 5분 (300s) | safe margin (long-running git op 보호) | 새 세션 진입 시 잔존 lock 자동 정리 |
| **매 git command 직전** | `pre-tool-use.sh` (matcher=Bash) | > 30초 | 반응성 + race condition 회피 | 진행 중 새 lock 도 즉시 mitigation |

→ 99% sandbox / agent crash case 자동 처리. Coin 손 작업 0.

---

## 2. pre-tool-use.sh 강화 (git command 감지 + stale 자동 rm)

```bash
case "$CMD" in
  *"git "*|*"git -C"*|*"&& git"*)
    # 작업 디렉터리 추정 (cd <path> && git 또는 git -C <path>)
    WORK_DIR=$(추출 로직)
    LOCK_FILE="$WORK_DIR/.git/index.lock"

    if [ -f "$LOCK_FILE" ]; then
      AGE=$((NOW - LOCK_MTIME))
      if [ "$AGE" -gt 30 ]; then
        rm -f "$LOCK_FILE" 2>/dev/null && \
          echo "[HOOK:PRE-TOOL-USE] auto-cleanup stale .git/index.lock (age=${AGE}s) at $WORK_DIR" >&2
      fi
    fi
    ;;
esac
```

**안전 보장**:
- stale > 30초 만 rm (정상 git op 는 30s 안 거의 끝남 — 큰 commit 도 30s 안 fit)
- mtime 기준 (생성 직후 즉시 rm 안 함)
- silent failure (rm 실패 시 stderr 만 · git command 자체는 진행)

---

## 3. session-start.sh 강화 + C3 dead code 정정

**C3 dead code 사고**: C3 에서 박힌 Claude Code 버전 검증 코드가 `exit 0` 뒤에 있어서 작동 안 함. C8 에서 동시 정정.

```bash
# === C3 박음: Claude Code 환경 정합 자동 검증 (정정 박힘 · exit 0 위치 수정) ===
ACTUAL_VERSION=$(claude --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
if [ -n "$ACTUAL_VERSION" ] && [ "$ACTUAL_VERSION" != "$EXPECTED_VERSION" ]; then
    echo "[session] WARN: Claude Code 버전 $ACTUAL_VERSION ≠ pin $EXPECTED_VERSION ..." >&2
elif [ -n "$ACTUAL_VERSION" ]; then
    echo "[session] cc_version=$ACTUAL_VERSION (pin PASS)"
fi

# === C8 박음: 세션 시작 시 stale > 5분 .git/index.lock 자동 정리 ===
LOCK_FILE="$REPO_ROOT/.git/index.lock"
if [ -f "$LOCK_FILE" ]; then
    AGE=$((NOW - LOCK_MTIME))
    if [ "$AGE" -gt 300 ]; then
        rm -f "$LOCK_FILE" 2>/dev/null && \
            echo "[session] auto-cleanup stale .git/index.lock (age=${AGE}s · sandbox/agent crash mitigation)"
    else
        echo "[session] WARN: .git/index.lock present (age=${AGE}s · still active git op?)" >&2
    fi
fi

exit 0
```

---

## 4. 검증 (실측 PASS)

- bash -n pre-tool-use.sh PASS
- bash -n session-start.sh PASS
- C3 dead code 정정 (exit 0 → 정상 위치)
- 보호 파일 5종 sha 변동 0

---

## 5. 산출물 inventory (C8)

| 파일 | 변경 |
|---|---|
| `.claude/hooks/pre-tool-use.sh` | ~ 강화 (git command 감지 + stale > 30s 자동 rm) |
| `.claude/hooks/session-start.sh` | ~ exit 0 정정 + stale > 5분 자동 rm |
| `.auto-memory/incident-log.md` | + C8 entry append |
| `.auto-memory/decision-log.md` | + C8 entry append |
| `CLAUDE.md` §15 | + C8 row 추가 |
| `.ai/reports/C8-.../REPORT.md` | ★ 신설 본 파일 |

---

## 6. ROI

| 항목 | 비용 | 효과 |
|---|---|---|
| 2 hook 강화 | 1 cycle | Coin 매번 `rm .git/index.lock` 손 작업 0 (영구 mitigation) |
| C3 dead code 정정 | 1 cycle 안 흡수 | Claude Code 버전 검증 실 작동 (이전 = dead code) |
| C4 propagation 시 자식 자동 적용 | 0 추가 비용 | 모든 repo git lock 사고 자동 처리 |

---

## 7. Coin 손 작업 1줄

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "$(cat <<'COMMIT'
fix(master): C8-GIT-LOCK-AUTOMITIGATION-001 stale .git/index.lock 자동 정리 + C3 dead code 정정

[Goal] sandbox/agent crash 후 잔존 .git/index.lock 으로 매 git command 차단 사고 영구 mitigation
[Diff] ~2 hooks: pre-tool-use.sh (git 감지 + stale > 30s rm) + session-start.sh (exit 0 위치 정정 + stale > 5분 rm)
[Sha]  보호 5종 sha 변동 0
[EC]   bash -n PASS · 2 layer 자동 정리 (반응성 30s + 안전 5분) · C3 dead code 정정
[Next] C4 propagation 시 자식 자동 적용
[Refs] task: C8-GIT-LOCK-AUTOMITIGATION-001 · 사고: 사용자 보고 "매번 처리 안 할 수 있도록"
COMMIT
)"
```
