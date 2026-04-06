#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$ROOT" ]]; then
  echo "append-commit.sh: não é um repositório Git; ignorando."
  exit 0
fi

TARGET="$ROOT/_memory/events/git-commits.md"
if [[ ! -f "$TARGET" ]]; then
  echo "append-commit.sh: arquivo ausente: $TARGET"
  exit 1
fi

HASH="$(git -C "$ROOT" rev-parse --short HEAD)"
DATE="$(git -C "$ROOT" log -1 --format=%ci)"
MSG="$(git -C "$ROOT" log -1 --format=%s)"
AUTHOR="$(git -C "$ROOT" log -1 --format=%an)"

FILES="$(git -C "$ROOT" show --name-only --pretty="" HEAD | sed '/^$/d' | head -80)"
if [[ $(git -C "$ROOT" show --name-only --pretty="" HEAD | wc -l) -gt 80 ]]; then
  FILES="$FILES
... (truncado)"
fi

{
  echo "### $DATE — \`$HASH\` — $MSG"
  echo "**Autor:** $AUTHOR"
  echo ""
  echo '```'
  echo "$FILES"
  echo '```'
  echo ""
} >>"$TARGET"
