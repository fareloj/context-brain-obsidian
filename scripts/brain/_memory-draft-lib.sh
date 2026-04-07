# shellcheck shell=bash
# Biblioteca compartilhada para memory-snapshot / memory-narrate (source, não executar).
_MEM_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MEMORY_VAULT_ROOT="$(cd "$_MEM_LIB_DIR/../.." && pwd)"

resolve_model() {
  if [[ -n "${CHATCLI_MODEL:-}" ]]; then
    printf '%s' "$CHATCLI_MODEL"
    return 0
  fi
  local p="$MEMORY_VAULT_ROOT/tools/chatcli/profiles.local.yaml"
  if [[ -f "$p" ]]; then
    awk '
      /^profiles:/ { next }
      /^  lmstudio:/ { m=1; next }
      m && /^  [a-zA-Z0-9_-]+:/ { m=0 }
      m && /^    model:/ {
        sub(/^    model:[[:space:]]*/, "")
        gsub(/"/, "")
        sub(/#.*/, "")
        gsub(/[[:space:]]+$/, "")
        print
        exit
      }
    ' "$p"
  fi
}
