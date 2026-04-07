# Grafo 3D no Obsidian (opcional)

Este vault já oculta `tools/` e `scripts/` no grafo nativo (ver [`.obsidian/graph.json`](../.obsidian/graph.json), campo `search`).

## Filtro alinhado ao grafo 2D nativo

Ao configurar um plugin de grafo 3D que aceite **filtro / query** no estilo Obsidian, use a mesma ideia:

```text
-path:tools -path:scripts
```

Assim o 3D fica coerente com o Graph view padrão (menos ruído técnico).

## Plugins comunitários sugeridos (instalação manual no Obsidian)

1. **Definições → Plugins da comunidade** → desativar modo restrito se necessário.
2. Procurar e instalar um destes (experimente o que rodar melhor na sua máquina):
   - **New 3D Graph** — [Apoo711/obsidian-3d-graph](https://github.com/Apoo711/obsidian-3d-graph) (Three.js, filtros e grupos).
   - **3D Graph** (fork Yomaru) — [HananoshikaYomaru/obsidian-3d-graph](https://github.com/HananoshikaYomaru/obsidian-3d-graph) — inclui grafo **local** (vizinhança), útil para explorar a partir de um “núcleo”.
3. Abra o grafo 3D pelo ícone da fita ou pela **Paleta de comandos**.
4. Cole ou replique o filtro acima nas definições do plugin, se existir campo equivalente.

## Limitações honestas

- O grafo **nativo** do Obsidian não é 3D nem “núcleo expansível” no sentido de animação hierárquica; os plugins aproximam com **clique, foco e vizinhança**.
- Vaults muito grandes podem ficar pesados em 3D; reduza escopo com filtros ou use o grafo **local** a partir de [[00-index/map]].

## Dados para visualização fora do Obsidian

Para gerar JSON do grafo (nós e links) e usar num viewer Web próprio, rode:

```bash
bash scripts/brain/export-graph-json.sh
```

Saída: [`docs/graph-export.json`](graph-export.json) (regenerável; pode `.gitignore` se preferir não versionar).
