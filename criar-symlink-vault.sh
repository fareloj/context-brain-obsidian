#!/usr/bin/env bash
# Cria atalho curto ~/vault-cerebro -> raiz deste repositório (menos dor com espaços no path).
# Uso: bash criar-symlink-vault.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
LINK="${HOME}/vault-cerebro"
if [[ -L "$LINK" ]] || [[ -e "$LINK" ]]; then
  echo "Já existe (arquivo ou link): $LINK" >&2
  echo "Remova ou escolha outro nome editando LINK neste script." >&2
  exit 1
fi
ln -s "$ROOT" "$LINK"
printf '%s\n' "Criado: $LINK -> $ROOT" "" "Obsidian: Open folder as vault → $LINK" "Terminal: cd $LINK"
