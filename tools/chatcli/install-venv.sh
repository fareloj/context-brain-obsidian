#!/usr/bin/env bash
# Cria .venv nesta pasta e instala o pacote em modo editável.
# Pré-requisito no Ubuntu/Debian: sudo apt install python3.12-venv
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v python3 >/dev/null 2>&1; then
  echo "Instale Python 3 (ex.: sudo apt install python3 python3-pip)" >&2
  exit 1
fi

if [[ ! -d .venv ]]; then
  python3 -m venv .venv
fi

# shellcheck source=/dev/null
source .venv/bin/activate
pip install -U pip
pip install -e .

echo ""
echo "OK. Ative o venv e rode o CLI:"
echo "  source $(pwd)/.venv/bin/activate"
echo "  python3 -m chatcli --help"
