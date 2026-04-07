# Viewer Web do grafo (opcional)

O ficheiro [`graph-export.json`](graph-export.json) é gerado por `scripts/brain/export-graph-json.sh` e contém `nodes` e `edges` (caminhos relativos ao vault).

Para ver o JSON no **browser** (só o ficheiro bruto):

- Se `python3 -m http.server` estiver a correr na **raiz do vault**, o URL correto é  
  `http://127.0.0.1:8765/docs/graph-export.json`  
  (não `/graph-export.json` — isso dá **404**).
- Se o servidor correr **dentro** da pasta `docs/`, aí sim: `http://127.0.0.1:8765/graph-export.json`.

Para visualizar em 3D no **browser** (com biblioteca), pode:

1. Servir a pasta `docs/` com um servidor HTTP estático (ex.: `python3 -m http.server 8765` dentro de `docs/`).
2. Usar uma página mínima com [3d-force-graph](https://github.com/vasturiano/3d-force-graph) ou Three.js: carregar o JSON, mapear `nodes`/`edges` para o formato que a biblioteca espera, e atribuir `id` = `path` do nó.

Não incluímos aqui um bundle front-end completo para manter o repositório leve; este ficheiro só documenta o contrato dos dados.
