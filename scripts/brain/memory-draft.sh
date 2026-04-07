#!/usr/bin/env bash
# Wrapper: snapshot determinístico + narrativa opcional (mesmo fluxo de antes).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$(bash "$SCRIPT_DIR/memory-snapshot.sh")"
bash "$SCRIPT_DIR/memory-narrate.sh" "$OUT"
printf '%s\n' "Criado: $OUT" >&2
