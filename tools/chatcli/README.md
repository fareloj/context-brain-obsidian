# Chat CLI (Python)

Terminal interativo para conversar com modelos via **LM Studio** (API compatível com OpenAI), **OpenAI** ou **Anthropic**, com streaming e prompt de sistema opcional (útil para testar o vault com `AGENTS.md` ou `CLAUDE-BRAIN.md`).

**Se você cola vários comandos e o terminal “embaralha” tudo:** use o script na raiz do vault [`chatcli.sh`](../chatcli.sh) — **uma linha só** — ou abra o arquivo [`COPIE-ESTA-LINHA.txt`](../COPIE-ESTA-LINHA.txt), edite o id do modelo, copie **apenas** essa linha e cole no terminal.

## Requisitos

- Python **3.10+**
- **Ubuntu/Debian:** o módulo `venv` costuma vir à parte. Instale antes (ajuste `3.12` à sua versão: `python3 --version`):

```bash
sudo apt install python3.12-venv python3-pip
```

Sem isso, `python3 -m venv` falha com *ensurepip is not available*.

## Atenção ao copiar comandos

Cole **um comando por vez** (Enter entre eles). Se você colar `sudo apt ...` e `cd "..."` na mesma linha, o texto do `apt` pode **entrar dentro das aspas** do `cd` e o caminho vira lixo (ex.: `...IMPORTANTEsudo apt...`). Nesse caso, apague a linha e use a **Opção raiz** abaixo, com **um único** `bash`.

## Uma linha só (menos erro de colagem)

Na **raiz do vault** existe [`install-chatcli-venv.sh`](../install-chatcli-venv.sh). Rode **só isto** (troque pelo seu caminho real):

```bash
bash "/media/farelokkjk/DISCO D W/backup windows antigo/AA-BACKUP SUPER IMPORTANTE!!!!/teste-claude-claudinho/install-chatcli-venv.sh"
```

Depois:

```bash
source "/media/farelokkjk/DISCO D W/backup windows antigo/AA-BACKUP SUPER IMPORTANTE!!!!/teste-claude-claudinho/tools/chatcli/.venv/bin/activate"
python3 -m chatcli --profile lmstudio --model "ID_DO_MODELO" --system "/media/farelokkjk/DISCO D W/backup windows antigo/AA-BACKUP SUPER IMPORTANTE!!!!/teste-claude-claudinho/AGENTS.md"
```

Usar **`--system` com caminho absoluto** evita depender de em qual pasta você está.

## Onde está a pasta `tools/chatcli`

Ela fica **dentro do repositório do vault**, não no seu `$HOME`. Exemplo (ajuste o caminho se o seu for outro):

```bash
cd "/media/farelokkjk/DISCO D W/backup windows antigo/AA-BACKUP SUPER IMPORTANTE!!!!/teste-claude-claudinho/tools/chatcli"
```

Se `cd tools/chatcli` der *No such file or directory*, você está em outro diretório (por exemplo só `~`). Use `cd` até a raiz do vault e então `cd tools/chatcli`, ou o caminho absoluto acima.

## Instalação

**Opção A — script (recomendado):** a partir de qualquer lugar, com caminho absoluto:

```bash
bash "/caminho/completo/para/seu-vault/tools/chatcli/install-venv.sh"
source "/caminho/completo/para/seu-vault/tools/chatcli/.venv/bin/activate"
```

**Opção B — manual** (já dentro de `tools/chatcli`):

```bash
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -e .
```

No Linux use **`python3`** e **`pip`** do venv ativado. O comando `python` pode não existir até instalar o pacote `python-is-python3`.

**Opção C — [uv](https://github.com/astral-sh/uv)** (gerencia venv sem depender do `ensurepip` do sistema em muitos casos):

```bash
cd "/caminho/para/seu-vault/tools/chatcli"
uv venv
uv pip install -e .
uv run python -m chatcli --help
```

## Se der erro

| Mensagem | O que fazer |
|----------|-------------|
| `cd: ... No such file or directory` (caminho com `sudo` no meio) | Você colou comandos juntos. Use o script de **uma linha** `bash ".../install-chatcli-venv.sh"` ou `cd` **só** com o path entre aspas. |
| `cd: tools/chatcli: No such file or directory` | Entre na pasta do vault com `cd` e só então `cd tools/chatcli`, ou use caminho absoluto. |
| `ensurepip is not available` | `sudo apt install python3.12-venv` (veja sua versão do Python). |
| `externally-managed-environment` | Não use `pip` no Python do sistema; use **venv** (`.venv` dentro de `tools/chatcli`) ou `uv`. |
| `Command 'python' not found` | Use `python3` ou ative o venv e continue com `python3 -m chatcli`. |

## Perfis

- Arquivo versionado: [`profiles.example.yaml`](profiles.example.yaml) (exemplos `lmstudio`, `openai`, `anthropic`).
- Para ajustes locais (modelo real do LM Studio, chaves, etc.), copie e edite:

```bash
cp profiles.example.yaml profiles.local.yaml
```

`profiles.local.yaml` está no [`.gitignore`](.gitignore) e **não** deve ser commitado.

### Chaves de API

- **OpenAI / provedor compatível na nuvem:** exporte `OPENAI_API_KEY`.
- **Anthropic:** exporte `ANTHROPIC_API_KEY`.
- **LM Studio:** normalmente usa `api_key: lm-studio` no YAML; não precisa de segredo.

### Modelo no LM Studio

O id do modelo precisa bater com o servidor. Liste com:

```bash
curl -s http://127.0.0.1:1234/v1/models
```

Use o id em `profiles.local.yaml` ou passe `--model "id-exato"` na linha de comando.

## Uso

```bash
# Com venv ativo, a partir de tools/chatcli (Linux: prefira python3)
python3 -m chatcli --profile lmstudio
python3 -m chatcli --profile lmstudio --model "nome-do-modelo-no-lm-studio"
python3 -m chatcli --profile lmstudio --system ../../AGENTS.md
python3 -m chatcli --profile openai
python3 -m chatcli --profile anthropic
python3 -m chatcli --profile lmstudio --no-stream
```

Caminhos em `--system` podem ser absolutos ou relativos ao diretório de onde você rodou o comando. Exemplos a partir de `tools/chatcli`:

| Arquivo do vault | Caminho típico |
|------------------|------------------|
| Constituição | `../../CLAUDE-BRAIN.md` |
| Agentes Cursor | `../../AGENTS.md` |

### Comandos dentro do chat

| Comando | Ação |
|---------|------|
| `/quit` ou `/exit` | Sair |
| `/clear` | Limpar histórico da sessão |
| `/help` | Ajuda |

## Estrutura

- `chatcli/config.py` — YAML + resolução de perfil e leitura do system prompt
- `chatcli/repl.py` — loop interativo
- `chatcli/backends/openai_compat.py` — LM Studio / OpenAI
- `chatcli/backends/anthropic_backend.py` — API Anthropic

## Notas

- O CLI **não** lê `.env` sozinho; use `export` no shell ou ferramentas como `direnv`.
- Respostas longas no Anthropic usam `max_tokens=8192`; ajuste no código se precisar de mais.
