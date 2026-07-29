#!/bin/bash
# secret-scan.sh — 시크릿 패턴 스캔 단일 실행 진입점
# 신설 cycle: MASTER-CLI-CONTEXT-DIET-3-001 (2026-07-29)
#
# 본질: 정규식 본문이 4곳에 복제돼 있었다 (verify-all/SKILL.md · review-task/SKILL.md ·
#   reviewer.md · verification-and-review.md) → 이미 미세 발산 발생
#   (`AIza[0-9A-Za-z\-_]{35}` vs `AIza[0-9A-Za-z_-]{35}`). 보안 패턴이 조용히 갈라지면
#   한쪽만 못 잡는다 → 실행 진입점 단일화.
#
# 패턴 SoT = docs/rules/safety-and-secrets.md §시크릿 스캔 패턴 (= 패턴 추가/변경은 거기서 먼저).
#   본 script 는 그 패턴의 **실행 판**이다. 양쪽이 갈라지면 rule 이 이긴다.
#
# 사용:
#   bash scripts/agent/secret-scan.sh .ai/reports/<taskId>/
#   bash scripts/agent/secret-scan.sh app/ shared/ iosApp/      # product code 확장 스캔 (warn-only)
#
# exit: 0 = 무매치(PASS · 시크릿 0) · 1 = 매치(FAIL · 즉시 STOP) · 2 = 인자/경로 오류
#   ※ grep 의 exit 관례(0=매치)와 **반대**다 — 호출부가 "무매치=PASS"를 그대로 읽도록 뒤집었다.
#     구 판은 호출부마다 "무매치(exit 1) = PASS" 를 주석으로 설명해야 했다.

set -uo pipefail

PATTERN='AKIA[0-9A-Z]{16}|sk-[a-zA-Z0-9]{32,}|ghp_[a-zA-Z0-9]{36}|xox[baprs]-[0-9a-zA-Z-]+|ya29\.[a-zA-Z0-9._-]+|AIza[0-9A-Za-z_-]{35}'

if [ "$#" -eq 0 ]; then
  echo "usage: bash scripts/agent/secret-scan.sh <path> [path...]" >&2
  exit 2
fi

for p in "$@"; do
  if [ ! -e "$p" ]; then
    echo "[SECRET-SCAN] 경로 부재: $p" >&2
    exit 2
  fi
done

HITS="$(grep -rEn "$PATTERN" "$@" 2>/dev/null || true)"

if [ -n "$HITS" ]; then
  echo "[SECRET-SCAN] FAIL — 시크릿 패턴 매치 (즉시 STOP · 삭제 또는 마스킹 후 재실행):"
  # 매치 라인은 값 자체를 담을 수 있다 → 파일:라인 만 출력하고 본문은 찍지 않는다.
  echo "$HITS" | cut -d: -f1,2 | sort -u
  exit 1
fi

echo "[SECRET-SCAN] PASS — 시크릿 0 매치 ($*)"
exit 0
