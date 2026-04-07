#!/usr/bin/env bash
# Diagnóstico rápido do vault (sempre exit 0; avisos em stdout).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
WARN=0

echo "=== Health check (IA Brain) ==="
echo "Raiz: $ROOT"
echo ""

if ! git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "[!] Não é repositório Git nesta pasta."
  WARN=$((WARN + 1))
else
  echo "[ok] Repositório Git"
  hp="$(git -C "$ROOT" config --get core.hooksPath || true)"
  if [[ "$hp" == ".githooks" ]]; then
    echo "[ok] core.hooksPath=.githooks"
  else
    echo "[!] core.hooksPath não é .githooks (atual: ${hp:-vazio}). Rode scripts/brain/install-hooks.sh"
    WARN=$((WARN + 1))
  fi
  for h in pre-commit post-commit; do
    f="$ROOT/.githooks/$h"
    if [[ -x "$f" ]]; then
      echo "[ok] Hook $h executável"
    else
      echo "[!] Hook $h ausente ou sem execução: $f"
      WARN=$((WARN + 1))
    fi
  done
fi

echo ""
if [[ -x "$ROOT/tools/chatcli/.venv/bin/python3" ]]; then
  echo "[ok] tools/chatcli/.venv presente"
else
  echo "[!] venv do chatcli ausente — rode install-chatcli-venv.sh se for usar o CLI"
  WARN=$((WARN + 1))
fi

echo ""
if cb="$(git -C "$ROOT" config --get alias.commitbrain 2>/dev/null)" && [[ -n "$cb" ]]; then
  echo "[ok] Alias git commitbrain configurado"
else
  echo "[i] Alias commitbrain não configurado — opcional: scripts/brain/install-git-alias.sh"
fi

echo ""
echo "--- Wikilinks (varredura completa, sem --strict) ---"
mapfile -t lines < <("$ROOT/scripts/brain/check-wiki-links.sh" 2>&1 || true)
if [[ ${#lines[@]} -eq 0 ]]; then
  echo "Nenhum aviso de link órfão."
else
  printf '%s\n' "${lines[@]}"
  echo "(total de linhas de aviso: ${#lines[@]})"
  WARN=$((WARN + 1))
fi

echo ""
PROGRESS="$ROOT/_memory/progress.md"
if [[ -f "$PROGRESS" ]]; then
  age_sec=$(( $(date +%s) - $(stat -c %Y "$PROGRESS") ))
  age_days=$(( age_sec / 86400 ))
  if [[ "$age_days" -gt 14 ]]; then
    echo "[!] _memory/progress.md não é modificado há ~${age_days} dias — confira se está atualizado"
    WARN=$((WARN + 1))
  else
    echo "[ok] progress.md modificado recentemente (~${age_days} dias)"
  fi
else
  echo "[!] Falta _memory/progress.md"
  WARN=$((WARN + 1))
fi

echo ""
echo "=== Fim (avisos acumulados: $WARN) ==="
exit 0
