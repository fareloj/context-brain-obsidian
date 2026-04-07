# Instruções do projeto (Cursor / agentes)

Este diretório é um **vault de conhecimento** em Markdown, pensado para **Cursor**, **Claude Code** e visualização no **Obsidian** (grafo via wikilinks).

## Leia primeiro

1. [[CLAUDE-BRAIN]] — regras completas, templates e taxonomia.
2. [[_memory/progress]] — o que está em andamento agora.
3. [[00-index/map]] — hubs por domínio; só então abra notas específicas.
4. [[ONBOARDING]] — retomada rápida, frases para salvar conversa e Obsidian (opcional).

## Regras de trabalho

- **Limite por turno:** abra no máximo **5 arquivos** do vault por turno, salvo se o usuário pedir explicitamente mais ou listar caminhos.
- **Economize contexto**: não carregue o vault inteiro; abra só arquivos citados no mapa ou no progresso.
- **Honestidade sobre leitura:** não afirme ter lido arquivos que **não** estão anexados ou abertos no contexto da conversa.
- **Encerrar sessão / rascunho de memória:** sugira `bash scripts/brain/memory-draft.sh` (ou só `memory-snapshot.sh` se não for usar IA local); o `_draft` fica em `_memory/sessions/` para revisão antes de promover.
- **Ao concluir** alterações relevantes: atualize [[_memory/progress]] (após revisão humana do rascunho, se usar o fluxo acima); crie notas novas com wikilinks para os hubs.
- **Decisões**: `_memory/decisions/` com ADR curta (modelo em [[CLAUDE-BRAIN]]).
- **Grafo**: prefira linkar `README.md` de cada pasta numerada e o mapa central.

## Salvar / revisar conversa

Quando o utilizador pedir para **rever a conversa**, **salvar a conversa**, **exportar para o Obsidian** ou **compactar e gravar** (ou disser que o **contexto está no limite**):

1. Gera um **ficheiro `.md`** no vault (prioridade sobre só responder no chat).
2. Coloca em **`01-architecture/` … `08-team/`** conforme a tabela em [[CLAUDE-BRAIN]] («Quando criar uma nota nova»). Se for só log de sessão sem domínio, usa `_memory/sessions/`.
3. Inclui wikilinks para [[00-index/map]] e para o `README` do domínio escolhido; não deixes links órfãos se o repositório tiver pre-commit de wikilinks.
4. **Compactação:** na resposta final, 3–6 linhas + caminho do ficheiro + próximo passo.

**Nota:** o cliente **não expõe** percentagem de contexto de forma fiável; não afirmes que detetaste «20%» — reage a **frases** do utilizador ou **oferece** gravar após conversa longa.

Frases de exemplo para o utilizador: ver [[ONBOARDING]] ou `README.md`.

## Arquivos de entrada

| Arquivo | Função |
|---------|--------|
| [[CLAUDE-BRAIN]] | Constituição do cérebro |
| [[_memory/progress]] | Estado atual |
| [[00-index/map]] | Índice visual/lógico |
| [[docs/repo-inventory]] | Árvore (script) |

## Scripts (opcional)

- `scripts/brain/install-hooks.sh` — hooks pre-commit (wikilinks staged) + post-commit (commits no vault).
- `scripts/brain/install-git-alias.sh` — alias `git commitbrain` (commit + inventário).
- `scripts/brain/health-check.sh` — diagnóstico do ambiente.
- `scripts/brain/new-session.sh "assunto"` — nova nota de sessão.
- `scripts/brain/memory-draft.sh` — rascunho completo; `memory-snapshot.sh` / `memory-narrate.sh` — passos separados.
- `scripts/brain/refresh-inventory.sh` / `refresh-sessions-index.sh` — inventário e índice de sessões.
- `scripts/brain/export-graph-json.sh` — gera `docs/graph-export.json` para viewers externos.

Detalhes em `README.md`.
