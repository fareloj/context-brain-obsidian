#!/usr/bin/env bash
# Rode com UM comando só (evita colar várias linhas no meio do caminho):
#   bash "/caminho/completo/ate/teste-claude-claudinho/install-chatcli-venv.sh"
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
exec bash "$ROOT/tools/chatcli/install-venv.sh"
