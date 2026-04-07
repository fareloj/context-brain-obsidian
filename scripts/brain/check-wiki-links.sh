#!/usr/bin/env bash
# Heurística: avisa se [[alvo]] não corresponde a um .md existente na raiz do vault.
# Uso:
#   check-wiki-links.sh              # varre todo o vault
#   check-wiki-links.sh --strict     # idem, exit 1 se houver órfãos
#   check-wiki-links.sh --strict -- a.md b.md   # só wikilinks nestes arquivos (caminhos relativos à raiz)
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

STRICT=0
FILES=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict)
      STRICT=1
      shift
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        FILES+=("$1")
        shift
      done
      break
      ;;
    -*)
      echo "Opção desconhecida: $1" >&2
      exit 2
      ;;
    *)
      FILES+=("$1")
      shift
      ;;
  esac
done

ORPHANS=0

check_one_file() {
  local rel="$1"
  [[ "$rel" == .git/* ]] && return 0
  [[ "$rel" == .obsidian/* ]] && return 0
  local path="$ROOT/$rel"
  [[ -f "$path" ]] || return 0
  mapfile -t links < <(grep -oE '\[\[[^]]+\]\]' "$path" 2>/dev/null | sed 's/^\[\[//;s/\]\]$//' || true)
  local raw base
  for raw in "${links[@]}"; do
    [[ -z "$raw" ]] && continue
    base="${raw%%|*}"
    base="${base%%#*}"
    base="${base#./}"
    if [[ -f "$ROOT/$base.md" ]] || [[ -f "$ROOT/$base" ]] || [[ -f "$ROOT/$base.canvas" ]]; then
      continue
    fi
    echo "Possível link órfão: [[$raw]] em $rel"
    ORPHANS=$((ORPHANS + 1))
  done
}

if [[ ${#FILES[@]} -gt 0 ]]; then
  for rel in "${FILES[@]}"; do
    check_one_file "$rel"
  done
else
  while IFS= read -r -d '' f; do
    rel="${f#./}"
    check_one_file "$rel"
  done < <(cd "$ROOT" && find . -name '*.md' -print0)
fi

if [[ "$STRICT" -eq 1 && "$ORPHANS" -gt 0 ]]; then
  exit 1
fi
exit 0
