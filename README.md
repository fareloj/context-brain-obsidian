# IA Brain — vault Markdown para Cursor, Claude Code e Obsidian

Cérebro multifuncional: **notas `.md` + wikilinks** formam a memória de longo prazo; agentes leem **só o necessário** ([[_memory/progress]], [[00-index/map]], hubs por domínio). O **grafo** (“rede neural”) é o **Graph view** do Obsidian sobre os mesmos arquivos.

**Primeiro acesso ou retomada:** [`ONBOARDING.md`](ONBOARDING.md) e `bash scripts/brain/health-check.sh`.

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

**Trabalho em equipe:** `workspace.json` já é ignorado; `graph.json` e `appearance.json` versionados podem gerar conflitos de merge — veja [ONBOARDING.md](ONBOARDING.md) («Obsidian em equipe»).

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

Isso define `git config core.hooksPath .githooks`. Cada `git commit` acrescenta um bloco em `_memory/events/git-commits.md`. O **pre-commit** roda [`check-wiki-links.sh`](scripts/brain/check-wiki-links.sh) com `--strict` **apenas nos `.md` staged** (não varre o vault inteiro).

**Identidade Git:** na primeira máquina, configure nome e e-mail (`git config user.name` / `user.email` neste repo ou globalmente).

### Inventário após o commit (opcional)

Sem hook automático (evita working tree suja a cada commit). Para **commit +** regenerar [`docs/repo-inventory.md`](docs/repo-inventory.md):

```bash
bash scripts/brain/install-git-alias.sh   # uma vez por clone
git commitbrain -m "sua mensagem"
```

Depois inclua `docs/repo-inventory.md` no commit ou emenda se quiser tudo junto.

## Scripts em `scripts/brain/`

| Script | Função |
|--------|--------|
| `install-hooks.sh` | Configura `core.hooksPath=.githooks` e garante permissões de execução |
| `install-git-alias.sh` | Registra o alias `git commitbrain` (commit + `refresh-inventory.sh`) |
| `append-commit.sh` | Chamado pelo hook; não precisa rodar à mão |
| `new-session.sh "assunto"` | Cria nota em `_memory/sessions/` com frontmatter e links |
| `refresh-inventory.sh` | Regenera [`docs/repo-inventory.md`](docs/repo-inventory.md) |
| `refresh-sessions-index.sh` | Regenera [`_memory/sessions/index.md`](_memory/sessions/index.md) |
| `check-wiki-links.sh` | Heurística de wikilinks; `--strict` falha se houver órfãos; pode receber lista de `.md` |
| `health-check.sh` | Diagnóstico rápido (hooks, venv, wikilinks, `progress.md`) |
| `memory-snapshot.sh` | Só snapshot Git em `_draft-*.md` (saída: caminho do arquivo em stdout) |
| `memory-narrate.sh` | Anexa narrativa opcional a um `.md` existente (argumento: caminho) |
| `memory-draft.sh` | Wrapper: snapshot + narrate (Git + opcional IA local via `vault-chatcli`) |

## Memória em 1 comando

No fim do dia ou ao encerrar uma sessão, gere um **rascunho** (não promove nada sozinho para `progress` ou sessões “oficiais”):

```bash
bash scripts/brain/memory-draft.sh
```

O fluxo em dois passos (se quiser só o Git, rode só `memory-snapshot.sh` e ignore `memory-narrate.sh`):

```bash
bash scripts/brain/memory-snapshot.sh   # imprime o caminho do _draft em stdout
bash scripts/brain/memory-narrate.sh /caminho/do/_draft-....md
```

O wrapper `memory-draft.sh` faz os dois. Com `vault-chatcli` no `PATH` e modelo (`CHATCLI_MODEL` ou `profiles.local.yaml` → `lmstudio`), o bloco narrativo é anexado. Depois:

1. Abra o `_draft` no Obsidian, ajuste o texto.
2. Renomeie (remova o prefixo `_draft-`) quando estiver satisfeito.
3. Opcional: linke a nota em [`00-index/map.md`](00-index/map.md).

## Chat CLI (testes locais / LM Studio)

Terminal multi-backend (LM Studio, OpenAI, Anthropic) em [`tools/chatcli/`](tools/chatcli/README.md). Para não colar comandos errados: [`COPIE-ESTA-LINHA.txt`](COPIE-ESTA-LINHA.txt). Atalho **curto** no terminal (`vault-chatcli`): rode uma vez [`criar-atalho-chatcli.sh`](criar-atalho-chatcli.sh). Também: [`chatcli.sh`](chatcli.sh), [`install-chatcli-venv.sh`](install-chatcli-venv.sh). Detalhes em [`tools/chatcli/README.md`](tools/chatcli/README.md).

**Modelo padrão sem `--model`:** copie [`tools/chatcli/profiles.local.yaml.example`](tools/chatcli/profiles.local.yaml.example) para `tools/chatcli/profiles.local.yaml` e ajuste; ou `export CHATCLI_MODEL="id-do-lm-studio"` no shell.

**Caminho curto no sistema:** opcional [`criar-symlink-vault.sh`](criar-symlink-vault.sh) cria `~/vault-cerebro` apontando para este repositório (útil com espaços no path).

## Ritual de fim de sessão

Checklist em [[CLAUDE-BRAIN]] («Encerrar sessão»). Para **rascunho rápido com Git** (e narrativa local opcional), use [`scripts/brain/memory-draft.sh`](scripts/brain/memory-draft.sh) (secção [Memória em 1 comando](#memória-em-1-comando)). No dia a dia: atualize [`_memory/progress.md`](_memory/progress.md) após revisar; para sessões longas use [`scripts/brain/new-session.sh`](scripts/brain/new-session.sh).

## Fluxo sugerido

1. Agentes leem [`_memory/progress.md`](_memory/progress.md) e [`00-index/map.md`](00-index/map.md).
2. Trabalham no código ou nas notas; criam links para hubs (`01-architecture/README`, etc.).
3. Ao final, atualizam `progress.md` e, se preciso, `git commitbrain` ou `./scripts/brain/refresh-inventory.sh`.
4. Você abre o Obsidian para explorar o **grafo** e revisar notas.

## Estrutura rápida

- `_memory/` — progresso, sessões, decisões, eventos (commits)
- `00-index/` … `08-team/` — conhecimento por domínio
- `docs/` — inventário gerado e documentação operacional
- `CLAUDE-BRAIN.md` — constituição do vault
