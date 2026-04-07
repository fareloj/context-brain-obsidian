#!/usr/bin/env bash
# Gera só o bloco determinístico (Git + metadados) em _memory/sessions/_draft-*.md.
# Imprime o caminho absoluto do arquivo em stdout (uma linha); mensagem humana em stderr.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/brain/_memory-draft-lib.sh
source "$SCRIPT_DIR/_memory-draft-lib.sh"
ROOT="$MEMORY_VAULT_ROOT"
SESSIONS="$ROOT/_memory/sessions"
mkdir -p "$SESSIONS"

TS="$(date +%Y%m%d-%H%M%S)"
OUT="$SESSIONS/_draft-${TS}.md"

GIT_OK=0
if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  GIT_OK=1
fi

{
  echo "# Rascunho de sessão (revisar antes de promover)"
  echo ""
  echo "> Gerado por \`scripts/brain/memory-snapshot.sh\` (+ opcional \`memory-narrate.sh\`). Não é memória oficial até você revisar, renomear (remover o prefixo \`_draft-\`) e, se quiser, linkar em [[00-index/map]]."
  echo ""
  echo "## Metadados"
  echo ""
  echo "- **Data (local):** $(date -Iseconds)"
  echo "- **Raiz do vault:** \`$ROOT\`"
  echo ""
  echo "## Snapshot Git (determinístico)"
  echo ""
  if [[ "$GIT_OK" -eq 0 ]]; then
    echo "_Este diretório não é um repositório Git ou \`git\` falhou._"
    echo ""
  else
    echo "### Último commit"
    echo ""
    echo '```'
    git -C "$ROOT" log -1 --format=fuller 2>/dev/null || echo "(sem commits)"
    echo '```'
    echo ""
    echo "### git status -s"
    echo ""
    echo '```'
    git -C "$ROOT" status -s 2>/dev/null || true
    echo '```'
    echo ""
    echo "### diff --stat (working tree)"
    echo ""
    echo '```'
    git -C "$ROOT" diff --stat 2>/dev/null || true
    echo '```'
    echo ""
    echo "### diff --stat (staged)"
    echo ""
    echo '```'
    git -C "$ROOT" diff --cached --stat 2>/dev/null || true
    echo '```'
    echo ""
    echo "### diff --stat (último commit)"
    echo ""
    echo '```'
    git -C "$ROOT" show --stat --oneline -1 2>/dev/null || echo "(n/a)"
    echo '```'
    echo ""
  fi
} >"$OUT"

printf '%s\n' "$OUT"
printf 'Snapshot criado: %s\n' "$OUT" >&2
