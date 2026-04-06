#!/usr/bin/env bash
# Inicia o chat CLI: cria/usa o venv em tools/chatcli/.venv e injeta --system AGENTS.md se você não passar outro.
# Veja COPIE-ESTA-LINHA.txt na raiz do vault para um exemplo de uma linha só.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
VENV="$ROOT/tools/chatcli/.venv"

if [[ ! -x "${VENV}/bin/python3" ]]; then
  printf '%s\n' "Instalando venv (primeira vez)..." >&2
  bash "$ROOT/install-chatcli-venv.sh"
fi
# shellcheck source=/dev/null
source "${VENV}/bin/activate"

has_system=0
has_model=0
for a in "$@"; do
  case "$a" in
    --system|-s) has_system=1 ;;
    --model|-m) has_model=1 ;;
  esac
done

prefix=()
if [[ "$has_system" -eq 0 ]]; then
  prefix+=(--system "$ROOT/AGENTS.md")
fi
if [[ "$has_model" -eq 0 && -n "${CHATCLI_MODEL:-}" ]]; then
  prefix+=(--model "$CHATCLI_MODEL")
fi

exec python3 -m chatcli "${prefix[@]}" "$@"
