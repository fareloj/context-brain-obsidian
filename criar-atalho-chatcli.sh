#!/usr/bin/env bash
# Cria o comando curto: vault-chatcli (caminho longo fica só dentro do arquivo).
# Rode UMA vez (pode colar esta linha inteira uma vez):
#   bash "/caminho/.../teste-claude-claudinho/criar-atalho-chatcli.sh"
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET="${HOME}/.local/bin"
OUT="${TARGET}/vault-chatcli"

mkdir -p "$TARGET"
{
  printf '%s\n' '#!/usr/bin/env bash'
  printf 'exec bash %q "$@"\n' "${ROOT}/chatcli.sh"
} >"$OUT"
chmod +x "$OUT"

printf '%s\n' "" "Criado: $OUT" ""
if printf '%s' ":${PATH}:" | grep -Fq ":${HOME}/.local/bin:"; then
  printf '%s\n' "Seu PATH já inclui ~/.local/bin. Digite:"
else
  printf '%s\n' "Adicione ao PATH (uma vez) e abra um terminal novo:" \
    "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc" \
    "  source ~/.bashrc" \
    "" \
  "Ou chame direto:" \
    "  ${OUT} --model \"seu-id\"" \
    ""
fi
printf '%s\n' "  vault-chatcli --model \"id-do-modelo-no-lm-studio\"" ""
