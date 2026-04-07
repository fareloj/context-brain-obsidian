---
objetivo: Registar o que foi entregue e enviado ao GitHub nesta data
data: 2026-04-07
---

## Resumo

Entrega alinhada ao plano **vault UX + grafo 3D** e integração com o fluxo do cérebro: documentação, Canvas, export JSON, regras da IA para salvar conversa, ajustes Git e push para `origin/main`.

## O que foi feito (repositório)

- **Grafo 3D (Obsidian):** guia [[docs/obsidian-grafo-3d]]; plugins usados localmente **3d-graph-new** e **Dataview** listados em `.obsidian/community-plugins.json` (pastas dos plugins não vão para o Git — reinstalar pela loja após clone).
- **Canvas:** ficheiro `00-index/mapa-vivo.canvas`; `core-plugins.json` com `canvas: true`.
- **Export do grafo:** `scripts/brain/export-graph-json.sh` → `docs/graph-export.json`; nota [[docs/graph-viewer-web]] (com servidor HTTP na raiz do vault, usar URL `/docs/graph-export.json`).
- **Salvar conversa:** secções em `AGENTS.md` / `CLAUDE.md`; regra `.cursor/rules/salvar-conversa-vault.mdc`; `README.md` e `ONBOARDING.md` com frases gatilho.
- **Dashboard:** [[00-index/dashboard]] (Dataview).
- **Inventário:** `refresh-inventory.sh` passa a ignorar `.venv` e `.obsidian/plugins/` na listagem.
- **`.gitignore`:** plugins Obsidian + ficheiros `Untitled*` do Obsidian.

## O que fica manual após `git clone`

1. Obsidian → **Plugins da comunidade** → instalar **3D Graph New** (ou equivalente) e **Dataview** (se quiser o dashboard).
2. Opcional: `bash scripts/brain/export-graph-json.sh` para regenerar o JSON.

## Links

- [[00-index/map]]
- [[docs/obsidian-grafo-3d]]
