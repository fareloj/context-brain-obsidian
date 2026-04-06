# CLAUDE-BRAIN — Constituição do vault

Este repositório é um **cérebro em Markdown**: a memória de longo prazo fica em arquivos `.md` com **wikilinks** do Obsidian (colchetes duplos em volta do caminho da nota) para o grafo. O objetivo é **não inflar o contexto** do chat: leia só o necessário, registre o restante em notas pequenas e linkadas.

## Ordem de leitura (agente)

1. [[_memory/progress]] — estado atual, bloqueios, próximos passos.
2. [[00-index/map]] — mapa e hubs por domínio.
3. Notas específicas do domínio (`01-architecture/` … `08-team/`) **somente** se o pedido exigir.
4. [[docs/repo-inventory]] — visão da árvore (após script).

## Ao terminar uma tarefa (obrigatório)

- Atualize [[_memory/progress]]: em andamento, próximo, bloqueios, data.
- Se houve **decisão relevante**, crie `_memory/decisions/YYYYMMDD-slug-curto.md` (use o template abaixo) e linke a partir do hub do domínio e/ou do mapa.
- Se houve **sessão longa**, registre fatos em `_memory/sessions/` (script `new-session.sh` ou manual com template).

## Encerrar sessão (checklist)

Use antes de fechar um bloco longo de trabalho ou quando o contexto do chat estiver grande:

1. **Resumo** (3–5 linhas): o que foi feito e o que ficou pendente.
2. **Decisões**: links para ADRs novas em `_memory/decisions/` ou escrever “nenhuma”.
3. **Notas**: arquivos criados ou alterados + wikilinks novos (se houver).
4. **[[_memory/progress]]**: atualizar em andamento, próximo passo (uma frase), bloqueios e **data**.
5. **Opcional:** `scripts/brain/new-session.sh "assunto"` e colar o resumo no `.md` gerado em `_memory/sessions/`.

## Quando criar uma nota nova

| Situação | Onde |
|----------|------|
| Decisão de arquitetura / trade-off | `_memory/decisions/` + link em `01-architecture/` |
| Contrato de API, schema, endpoint | `02-backend/` ou `04-flows/` |
| Fluxo de usuário ou pipeline | `04-flows/` |
| Runbook, deploy, alerta | `05-operations/` |
| Regra de estilo ou processo | `06-guidelines/` |
| Requisito ou métrica de produto | `07-product/` |
| Responsabilidade ou onboarding | `08-team/` |

Sempre **adicione wikilinks** de volta para [[00-index/map]] ou para o `README.md` do domínio, para o grafo permanecer navegável.

## Convenções de nome

- Arquivos: `kebab-case.md` (exceto `README.md`, `CLAUDE.md`, `AGENTS.md`).
- Decisões: `YYYYMMDD-assunto-curto.md`.
- Sessões: `YYYY-MM-DD-HHMM-assunto.md` (preferir script).

## Wikilinks

- Cada wikilink deve apontar para um arquivo real, sem extensão `.md` no link (ex.: [[01-architecture/README]]).
- Após renomear arquivos, use o Obsidian **Atualizar links** ou mantenha `alwaysUpdateLinks` ativo no `.obsidian/app.json`.

## O que **não** colocar no chat

- Listagens enormes de árvore → use [[docs/repo-inventory]] e cite só o trecho.
- Histórico completo de commits → use [[_memory/events/git-commits]].
- Especificações estáveis → nova nota + link.

---

## Template: decisão (ADR curta)

```markdown
# Título da decisão

Data: YYYY-MM-DD
Status: proposta | aceita | obsoleta

## Contexto

## Decisão

## Consequências

## Links

- [[00-index/map]]
- [[01-architecture/README]]
```

## Template: sessão

```yaml
---
objetivo: ""
escopo: ""
data: YYYY-MM-DD
---

## Resultado

## Notas criadas ou atualizadas

- 

## Próximos passos

- 
```

## Template: endpoint (exemplo)

```markdown
# POST /recurso

## Objetivo

## Request

## Response

## Erros

## Links

- [[02-backend/README]]
- [[04-flows/README]]
```

## Automação

- Commits append em [[_memory/events/git-commits]] via hook Git (veja `README.md`).
- `scripts/brain/refresh-inventory.sh` atualiza [[docs/repo-inventory]].
- `scripts/brain/new-session.sh` cria arquivo em `_memory/sessions/`.
