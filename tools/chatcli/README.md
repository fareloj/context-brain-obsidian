# Chat CLI (Python)

Terminal interativo para conversar com modelos via **LM Studio** (API compatível com OpenAI), **OpenAI** ou **Anthropic**, com streaming e prompt de sistema opcional (útil para testar o vault com `AGENTS.md` ou `CLAUDE-BRAIN.md`).

## Requisitos

- Python **3.10+**
- Um ambiente virtual (recomendado). No Ubuntu/Debian, se `python3 -m venv` falhar, instale `python3.12-venv` (ou equivalente) e tente de novo.

## Instalação

Na pasta deste projeto:

```bash
cd tools/chatcli
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -e .
```

Alternativa com [uv](https://github.com/astral-sh/uv):

```bash
cd tools/chatcli
uv venv
uv pip install -e .
uv run python -m chatcli --help
```

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
# Com venv ativo, a partir de tools/chatcli
python -m chatcli --profile lmstudio
python -m chatcli --profile lmstudio --model "nome-do-modelo-no-lm-studio"
python -m chatcli --profile lmstudio --system ../../AGENTS.md
python -m chatcli --profile openai
python -m chatcli --profile anthropic
python -m chatcli --profile lmstudio --no-stream
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
