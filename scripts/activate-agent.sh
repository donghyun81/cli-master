#!/usr/bin/env bash
# scripts/activate-agent.sh — agent active/deferred 토글 + 정합 갱신
#
# 사용:
#   bash scripts/activate-agent.sh activate <agent-name>
#   bash scripts/activate-agent.sh deactivate <agent-name>
#   bash scripts/activate-agent.sh list
#
# 동작:
#   - agent 폴더 mv (active ↔ deferred)
#   - routing-and-delegation.md 의 [DEFERRED] 라벨 자동 toggle
#   - deferred-domains.md 표 갱신 (해당 도메인 행)
#
# 환경 변수:
#   MASTER_DIR    기본: ~/AndroidStudioProjects/claude-cli-master

set -uo pipefail

: "${MASTER_DIR:=$HOME/AndroidStudioProjects/claude-cli-master}"
ACTION="${1:-}"
NAME="${2:-}"

if [ -z "$ACTION" ]; then
  echo "사용: bash scripts/activate-agent.sh {activate|deactivate|list} [agent-name]" >&2
  exit 2
fi

cd "$MASTER_DIR"

ACTIVE_DIR=".claude/agents/active"
DEFERRED_DIR=".claude/agents/deferred"

case "$ACTION" in
  list)
    echo "═══════════════════════════════════════════════════════"
    echo "[activate-agent] 현 agent 분포"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "ACTIVE ($(ls $ACTIVE_DIR 2>/dev/null | wc -l | tr -d ' ')):"
    ls "$ACTIVE_DIR" 2>/dev/null | sed 's/\.md$//' | sed 's/^/  /'
    echo ""
    echo "DEFERRED ($(ls $DEFERRED_DIR 2>/dev/null | wc -l | tr -d ' ')):"
    ls "$DEFERRED_DIR" 2>/dev/null | sed 's/\.md$//' | sed 's/^/  /'
    exit 0
    ;;
  activate)
    SRC="$DEFERRED_DIR/$NAME.md"
    DST="$ACTIVE_DIR/$NAME.md"
    NEW_PATH="$ACTIVE_DIR/$NAME.md"
    OLD_PATH="$DEFERRED_DIR/$NAME.md"
    LABEL_OLD="\\[DEFERRED\\] "
    LABEL_NEW=""
    ;;
  deactivate)
    SRC="$ACTIVE_DIR/$NAME.md"
    DST="$DEFERRED_DIR/$NAME.md"
    NEW_PATH="$DEFERRED_DIR/$NAME.md"
    OLD_PATH="$ACTIVE_DIR/$NAME.md"
    LABEL_OLD=""
    LABEL_NEW="[DEFERRED] "
    ;;
  *)
    echo "[activate-agent] ERROR: 알 수 없는 action '$ACTION' (activate/deactivate/list)" >&2
    exit 2
    ;;
esac

if [ -z "$NAME" ]; then
  echo "[activate-agent] ERROR: agent-name 필수" >&2
  exit 2
fi

if [ ! -f "$SRC" ]; then
  echo "[activate-agent] ERROR: $SRC 부재" >&2
  echo "  현 위치 확인: bash scripts/activate-agent.sh list" >&2
  exit 2
fi

if [ -f "$DST" ]; then
  echo "[activate-agent] ERROR: $DST 이미 존재 (충돌)" >&2
  exit 2
fi

# === 1. agent 파일 mv ===
mv "$SRC" "$DST"
echo "[activate-agent] mv $SRC → $DST"

# === 2. routing-and-delegation.md 의 path + 라벨 갱신 ===
ROUTING="docs/rules/routing-and-delegation.md"
if [ -f "$ROUTING" ]; then
  # path 갱신
  sed -i.bak "s|$OLD_PATH|$NEW_PATH|g" "$ROUTING"
  rm -f "${ROUTING}.bak" 2>/dev/null

  # [DEFERRED] 라벨 toggle (해당 agent 행만)
  if [ "$ACTION" = "activate" ]; then
    sed -i.bak "/$NAME/s|\\[DEFERRED\\] ||" "$ROUTING"
  else
    # deactivate: 라벨 없으면 추가 (행 시작 후 첫 cell 안)
    sed -i.bak "/$NAME/{/\\[DEFERRED\\]/!s|\\(^\\| | \\)\\([^|]*\\) | $NAME |\\1[DEFERRED] \\2 | $NAME |}" "$ROUTING"
  fi
  rm -f "${ROUTING}.bak" 2>/dev/null

  echo "[activate-agent] routing-and-delegation.md 갱신 박음"
fi

# === 3. deferred-domains.md 표 status 갱신 (도메인 매핑) ===
# agent name → 도메인 매핑
case "$NAME" in
  auth-security-privacy)             DOMAIN="Auth / Security" ;;
  data-schema-guardian)              DOMAIN="Data / Migration" ;;
  backend-api-architect|server-implementer) DOMAIN="Backend / API" ;;
  performance-reliability-engineer)  DOMAIN="Performance" ;;
  billing-payments-guardian)         DOMAIN="Billing" ;;
  *) DOMAIN="" ;;
esac

DEFERRED_DOMAINS="docs/rules/deferred-domains.md"
if [ -n "$DOMAIN" ] && [ -f "$DEFERRED_DOMAINS" ]; then
  if [ "$ACTION" = "activate" ]; then
    NEW_STATUS="ACTIVE"
  else
    NEW_STATUS="UNKNOWN"
  fi
  # master 컬럼만 갱신 (현재 다른 컬럼은 자식 repo specific)
  sed -i.bak "s|^| $DOMAIN | [A-Z]* |\\(.*\\)|\\| $DOMAIN | $NEW_STATUS |\\1|" "$DEFERRED_DOMAINS" 2>/dev/null
  rm -f "${DEFERRED_DOMAINS}.bak" 2>/dev/null
  echo "[activate-agent] deferred-domains.md $DOMAIN → $NEW_STATUS 갱신 시도 (수동 확인 권장)"
fi

# === 4. 다음 단계 안내 ===
echo ""
echo "═══════════════════════════════════════════════════════"
echo "[activate-agent] $ACTION 완료: $NAME"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "다음 단계:"
echo "  1. bash scripts/propagate.sh $NEW_PATH --targets all"
echo "  2. bash scripts/verify-sync.sh"
echo "  3. master 에 cycle commit (cli infra 변경)"

exit 0
