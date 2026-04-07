#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Erro: este diretório não é um repositório Git."
  echo "Rode: git init && git add . && git commit -m \"chore: vault inicial\""
  exit 1
fi

chmod +x "$ROOT/scripts/brain/append-commit.sh"
chmod +x "$ROOT/.githooks/post-commit" 2>/dev/null || true
chmod +x "$ROOT/.githooks/pre-commit" 2>/dev/null || true

git config core.hooksPath .githooks
echo "Configurado: core.hooksPath=.githooks (raiz: $ROOT)"
echo "Hooks: pre-commit (wikilinks nos .md staged) e post-commit (append em _memory/events/git-commits.md)"
