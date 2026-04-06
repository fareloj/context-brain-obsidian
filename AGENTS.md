# Instruções do projeto (Cursor / agentes)

Este diretório é um **vault de conhecimento** em Markdown, pensado para **Cursor**, **Claude Code** e visualização no **Obsidian** (grafo via wikilinks).

## Leia primeiro

1. [[CLAUDE-BRAIN]] — regras completas, templates e taxonomia.
2. [[_memory/progress]] — o que está em andamento agora.
3. [[00-index/map]] — hubs por domínio; só então abra notas específicas.

## Regras de trabalho

- **Limite por turno:** abra no máximo **5 arquivos** do vault por turno, salvo se o usuário pedir explicitamente mais ou listar caminhos.
- **Economize contexto**: não carregue o vault inteiro; abra só arquivos citados no mapa ou no progresso.
- **Ao concluir** alterações relevantes: atualize [[_memory/progress]]; crie notas novas com wikilinks para os hubs.
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

- `scripts/brain/install-hooks.sh` — registra hook de commit.
- `scripts/brain/new-session.sh "assunto"` — nova nota de sessão.
- `scripts/brain/refresh-inventory.sh` — atualiza inventário.

Detalhes em `README.md`.
