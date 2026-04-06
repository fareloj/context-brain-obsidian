# Estado do projeto (visão rápida)

Nota curta para humanos e modelos pequenos: o que é este repositório **hoje**.

## O que é

Vault **IA Brain**: memória em Markdown + wikilinks para o **Obsidian** (grafo). Instruções para agentes em [[CLAUDE-BRAIN]], [[CLAUDE]], [[AGENTS]].

## Ferramentas em uso

- **Obsidian:** abrir esta pasta como vault; grafo para navegar links.
- **LM Studio:** modelos locais, API em `http://127.0.0.1:1234/v1` (perfil `lmstudio` no chatcli).
- **Chat CLI:** pasta `tools/chatcli/`; atalho de terminal `vault-chatcli` (script `criar-atalho-chatcli.sh` na raiz).
- **Git:** hook `post-commit` registra commits em [[_memory/events/git-commits]].

## Estrutura principal

- [[_memory/progress]] — estado atual da sprint.
- [[00-index/map]] — índice e hubs.
- `01-architecture/` … `08-team/` — domínios.
- `scripts/brain/` — inventário, sessão, hooks.

## Links

- [[00-index/map]]
- [[CLAUDE-BRAIN]]
