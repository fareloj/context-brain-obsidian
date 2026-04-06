# IA Brain — vault Markdown para Cursor, Claude Code e Obsidian

Cérebro multifuncional: **notas `.md` + wikilinks** formam a memória de longo prazo; agentes leem **só o necessário** ([[_memory/progress]], [[00-index/map]], hubs por domínio). O **grafo** (“rede neural”) é o **Graph view** do Obsidian sobre os mesmos arquivos.

## Cursor

O Cursor costuma respeitar [`AGENTS.md`](AGENTS.md) na raiz. Lá está o mesmo contrato resumido; detalhes em [`CLAUDE-BRAIN.md`](CLAUDE-BRAIN.md).

## Claude Code

O Claude Code usa [`CLAUDE.md`](CLAUDE.md) como instruções do projeto. Leia também [`CLAUDE-BRAIN.md`](CLAUDE-BRAIN.md) para templates e taxonomia.

## Obsidian (visualização em grafo)

1. Instale o [Obsidian](https://obsidian.md/).
2. **Open folder as vault** e escolha **esta pasta** (a raiz do repositório).
3. Abra **Visualização em gráfico** (Graph view): cada nota é um nó; wikilinks entre notas viram arestas.
4. Comece por [`00-index/map.md`](00-index/map.md) para navegar e ver o grafo crescer a partir dos hubs.

A pasta [`.obsidian/`](.obsidian/) está versionada de forma mínima (`app.json`, `core-plugins.json` com **graph** e **templates**, `appearance.json`). Arquivos de workspace locais estão no [`.gitignore`](.gitignore).

**Anexos:** novas mídias podem ir para `_memory/assets/` (configurado em `.obsidian/app.json`).

**Grafo:** o [`.obsidian/graph.json`](.obsidian/graph.json) vem com filtro de busca que **oculta** pastas `tools/` e `scripts/` (menos ruído técnico). Ajuste no próprio Graph view se quiser ver tudo.

**Templates (plugin core «Templates»):** em Ajustes do Obsidian, defina a pasta de modelos como [`templates/`](templates/) e use [`templates/sessao-vault.md`](templates/sessao-vault.md) (variáveis `{{date:YYYY-MM-DD}}` do plugin nativo).

## Git e hooks

Este vault funciona melhor como **repositório Git próprio** na pasta do cérebro (assim os hooks registram commits em [`_memory/events/git-commits.md`](_memory/events/git-commits.md)).

Se a pasta estiver **dentro** de um monorepo maior, você pode:

- manter um `git init` **só** nesta pasta (submódulo ou repo aninhado — entenda as implicações com seu fluxo), ou
- copiar `.githooks/` e `scripts/brain/` para o repo principal e apontar `core.hooksPath` para uma pasta de hooks que chame `append-commit.sh` com `ROOT` correto.

### Instalar o hook de commit

Na raiz do vault (com Git já inicializado):

```bash
./scripts/brain/install-hooks.sh
```

Isso define `git config core.hooksPath .githooks`. Cada `git commit` acrescenta um bloco em `_memory/events/git-commits.md`.

**Identidade Git:** na primeira máquina, configure nome e e-mail (`git config user.name` / `user.email` neste repo ou globalmente).

## Scripts em `scripts/brain/`

| Script | Função |
|--------|--------|
| `install-hooks.sh` | Configura `core.hooksPath=.githooks` e garante permissões de execução |
| `append-commit.sh` | Chamado pelo hook; não precisa rodar à mão |
| `new-session.sh "assunto"` | Cria nota em `_memory/sessions/` com frontmatter e links |
| `refresh-inventory.sh` | Regenera [`docs/repo-inventory.md`](docs/repo-inventory.md) |
| `check-wiki-links.sh` | Heurística para possíveis wikilinks sem arquivo `.md` correspondente |

## Chat CLI (testes locais / LM Studio)

Terminal multi-backend (LM Studio, OpenAI, Anthropic) em [`tools/chatcli/`](tools/chatcli/README.md). Para não colar comandos errados: [`COPIE-ESTA-LINHA.txt`](COPIE-ESTA-LINHA.txt). Atalho **curto** no terminal (`vault-chatcli`): rode uma vez [`criar-atalho-chatcli.sh`](criar-atalho-chatcli.sh). Também: [`chatcli.sh`](chatcli.sh), [`install-chatcli-venv.sh`](install-chatcli-venv.sh). Detalhes em [`tools/chatcli/README.md`](tools/chatcli/README.md).

**Modelo padrão sem `--model`:** copie [`tools/chatcli/profiles.local.yaml.example`](tools/chatcli/profiles.local.yaml.example) para `tools/chatcli/profiles.local.yaml` e ajuste; ou `export CHATCLI_MODEL="id-do-lm-studio"` no shell.

**Caminho curto no sistema:** opcional [`criar-symlink-vault.sh`](criar-symlink-vault.sh) cria `~/vault-cerebro` apontando para este repositório (útil com espaços no path).

## Ritual de fim de sessão

Checklist em [[CLAUDE-BRAIN]] («Encerrar sessão»). No dia a dia: atualize [`_memory/progress.md`](_memory/progress.md); para sessões longas use [`scripts/brain/new-session.sh`](scripts/brain/new-session.sh).

## Fluxo sugerido

1. Agentes leem [`_memory/progress.md`](_memory/progress.md) e [`00-index/map.md`](00-index/map.md).
2. Trabalham no código ou nas notas; criam links para hubs (`01-architecture/README`, etc.).
3. Ao final, atualizam `progress.md` e, se preciso, rodam `./scripts/brain/refresh-inventory.sh`.
4. Você abre o Obsidian para explorar o **grafo** e revisar notas.

## Estrutura rápida

- `_memory/` — progresso, sessões, decisões, eventos (commits)
- `00-index/` … `08-team/` — conhecimento por domínio
- `docs/` — inventário gerado e documentação operacional
- `CLAUDE-BRAIN.md` — constituição do vault
