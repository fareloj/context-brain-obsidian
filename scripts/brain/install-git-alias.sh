#!/usr/bin/env bash
# Registra o alias local commitbrain: commit + refresh-inventory (sem hook pós-commit).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if ! git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "Erro: $ROOT não é um repositório Git." >&2
  exit 1
fi

git -C "$ROOT" config alias.commitbrain '!git commit "$@" && "$(git rev-parse --show-toplevel)/scripts/brain/refresh-inventory.sh"'
echo "Alias registrado neste repositório: git commitbrain (equivale a commit + refresh-inventory.sh)"
echo "Depois do commit, revise e faça git add docs/repo-inventory.md se quiser versionar o inventário."
