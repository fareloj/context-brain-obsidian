#!/usr/bin/env bash
# Anexa ao .md existente o bloco de rascunho narrativo (IA local) ou instruções manuais.
# Uso: memory-narrate.sh /caminho/absoluto/para/rascunho.md
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/brain/_memory-draft-lib.sh
source "$SCRIPT_DIR/_memory-draft-lib.sh"
ROOT="$MEMORY_VAULT_ROOT"

if [[ $# -lt 1 || -z "$1" ]]; then
  echo "Uso: $0 <arquivo.md>" >&2
  exit 1
fi

OUT="$1"
if [[ ! -f "$OUT" ]]; then
  echo "Arquivo não encontrado: $OUT" >&2
  exit 1
fi

MODEL="$(resolve_model || true)"
MODEL="${MODEL//$'\r'/}"

if command -v vault-chatcli >/dev/null 2>&1 && [[ -n "$MODEL" ]]; then
  CONTEXT_ARGS=(-c "$OUT")
  [[ -f "$ROOT/AGENTS.md" ]] && CONTEXT_ARGS+=(-c "$ROOT/AGENTS.md")
  set +e
  LLM_OUT="$(
    vault-chatcli --model "$MODEL" --no-stream \
      "${CONTEXT_ARGS[@]}" \
      --prompt "Com base APENAS nos arquivos de contexto anexados (snapshot Git do rascunho e, se houver, AGENTS.md), escreva em português brasileiro, sem emojis, Markdown com as seções: ## Resumo (3 a 5 linhas), ## Decisoes (ou a palavra Nenhuma), ## Proximos passos (lista curta), ## Arquivos tocados (lista inferida só do diff). Não invente fatos, arquivos ou decisões que não apareçam no contexto. Se o snapshot estiver vazio ou sem alterações, diga isso explicitamente." 2>&1
  )"
  RC=$?
  set -e
  {
    echo ""
    echo "## Rascunho narrativo (IA local)"
    echo ""
  } >>"$OUT"
  if [[ "$RC" -ne 0 ]]; then
    echo "_Falha ao chamar \`vault-chatcli\` (código $RC). Saída:_" >>"$OUT"
    echo "" >>"$OUT"
    echo '```' >>"$OUT"
    echo "$LLM_OUT" >>"$OUT"
    echo '```' >>"$OUT"
  else
    echo "$LLM_OUT" >>"$OUT"
  fi
else
  {
    echo ""
    echo "## Rascunho narrativo (opcional)"
    echo ""
    echo "IA local não foi usada. Para gerar este bloco automaticamente na próxima vez:"
    echo ""
    echo "1. Tenha \`vault-chatcli\` no \`PATH\` (rode \`criar-atalho-chatcli.sh\` na raiz do vault)."
    echo "2. Defina \`export CHATCLI_MODEL=\"id-do-modelo-lm-studio\"\` **ou** configure \`model\` em \`tools/chatcli/profiles.local.yaml\` no perfil \`lmstudio\`."
    echo "3. Rode \`scripts/brain/memory-narrate.sh\` de novo neste arquivo."
    echo ""
    echo "Ou complete as seções **Resumo / Decisões / Próximos passos** manualmente abaixo."
    echo ""
  } >>"$OUT"
fi

printf 'Narrativa anexada em: %s\n' "$OUT" >&2
