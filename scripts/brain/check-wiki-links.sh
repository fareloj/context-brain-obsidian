#!/usr/bin/env bash
# Heurística: avisa se [[alvo]] não corresponde a um .md existente na raiz do vault.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

while IFS= read -r -d '' f; do
  rel="${f#./}"
  [[ "$rel" == .git/* ]] && continue
  [[ "$rel" == .obsidian/* ]] && continue
  mapfile -t links < <(grep -oE '\[\[[^]]+\]\]' "$ROOT/$rel" 2>/dev/null | sed 's/^\[\[//;s/\]\]$//' || true)
  for raw in "${links[@]}"; do
    [[ -z "$raw" ]] && continue
    base="${raw%%|*}"
    base="${base%%#*}"
    base="${base#./}"
    if [[ -f "$ROOT/$base.md" ]] || [[ -f "$ROOT/$base" ]]; then
      continue
    fi
    echo "Possível link órfão: [[$raw]] em $rel"
  done
done < <(cd "$ROOT" && find . -name '*.md' -print0)

exit 0
