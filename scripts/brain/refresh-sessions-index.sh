#!/usr/bin/env bash
# Gera _memory/sessions/index.md com lista das notas de sessão (exceto o próprio index).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DIR="$ROOT/_memory/sessions"
OUT="$DIR/index.md"

mkdir -p "$DIR"

{
  echo "# Índice de sessões"
  echo ""
  echo "> Gerado por \`scripts/brain/refresh-sessions-index.sh\` em $(date -Iseconds). Atualize rodando o script de novo."
  echo ""
  echo "| Arquivo | Tipo |"
  echo "|---------|------|"
  while IFS= read -r -d '' f; do
    base="$(basename "$f")"
    [[ "$base" == index.md ]] && continue
    if [[ "$base" == _draft-*.md ]]; then
      tipo="rascunho"
    else
      tipo="sessão"
    fi
    link="${base%.md}"
    echo "| [[_memory/sessions/$link]] | $tipo |"
  done < <(find "$DIR" -maxdepth 1 -name '*.md' -type f -print0 | LC_ALL=C sort -z)
  echo ""
} >"$OUT"

echo "Atualizado: $OUT"
