# Instruções do projeto (Cursor / agentes)

Este diretório é um **vault de conhecimento** em Markdown, pensado para **Cursor**, **Claude Code** e visualização no **Obsidian** (grafo via wikilinks).

## Leia primeiro

1. [[CLAUDE-BRAIN]] — regras completas, templates e taxonomia.
2. [[_memory/progress]] — o que está em andamento agora.
3. [[00-index/map]] — hubs por domínio; só então abra notas específicas.
4. [[ONBOARDING]] — retomada rápida (opcional).

## Regras de trabalho

- **Limite por turno:** abra no máximo **5 arquivos** do vault por turno, salvo se o usuário pedir explicitamente mais ou listar caminhos.
- **Economize contexto**: não carregue o vault inteiro; abra só arquivos citados no mapa ou no progresso.
- **Honestidade sobre leitura:** não afirme ter lido arquivos que **não** estão anexados ou abertos no contexto da conversa.
- **Encerrar sessão / rascunho de memória:** sugira `bash scripts/brain/memory-draft.sh` (ou só `memory-snapshot.sh` se não for usar IA local); o `_draft` fica em `_memory/sessions/` para revisão antes de promover.
- **Ao concluir** alterações relevantes: atualize [[_memory/progress]] (após revisão humana do rascunho, se usar o fluxo acima); crie notas novas com wikilinks para os hubs.
- **Decisões**: `_memory/decisions/` com ADR curta (modelo em [[CLAUDE-BRAIN]]).
- **Grafo**: prefira linkar `README.md` de cada pasta numerada e o mapa central.

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

Detalhes em `README.md`.
