#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUT="$ROOT/docs/repo-inventory.md"

{
  echo "# Inventário do repositório"
  echo ""
  echo "> Gerado automaticamente em $(date -Iseconds) — rode \`scripts/brain/refresh-inventory.sh\` para atualizar."
  echo ""
  echo '```'
  (cd "$ROOT" && find . \( \
    -path './.git' -o \
    -path './.git/*' -o \
    -path '*/node_modules' -o \
    -path '*/node_modules/*' -o \
    -path './.obsidian/workspace.json' -o \
    -path './.obsidian/workspace-mobile.json' \
    \) -prune -o -type f -print | LC_ALL=C sort | sed 's|^\./||')
  echo '```'
  echo ""
  echo "## Links"
  echo ""
  echo "- [[00-index/map]]"
  echo "- [[CLAUDE-BRAIN]]"
} >"$OUT"

echo "Atualizado: $OUT"
