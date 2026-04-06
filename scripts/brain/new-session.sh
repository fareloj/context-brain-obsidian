#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

SLUG_RAW="${1:-sessao}"
SLUG="$(echo "$SLUG_RAW" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9_-')"
TS="$(date +%Y-%m-%d-%H%M)"
DIR="$ROOT/_memory/sessions"
mkdir -p "$DIR"
FILE="$DIR/${TS}-${SLUG}.md"

cat >"$FILE" <<EOF
---
objetivo: ${SLUG_RAW}
escopo: ""
data: $(date +%Y-%m-%d)
---

## Resultado

## Notas criadas ou atualizadas

-

## Próximos passos

-

## Links

- [[00-index/map]]
- [[_memory/progress]]
- [[CLAUDE-BRAIN]]
EOF

echo "Criado: $FILE"
