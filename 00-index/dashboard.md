# Dashboard (Dataview)

> Ative o plugin comunitário **Dataview** no Obsidian. Sem ele, esta página não renderiza consultas.

## Progresso

```dataview
TABLE file.mtime as "Atualizado"
FROM "_memory/progress.md"
```

## Sessões recentes

```dataview
TABLE file.mtime as "Modificado"
FROM "_memory/sessions"
WHERE file.name != "index.md"
SORT file.mtime DESC
LIMIT 10
```

## Mapa

- [[00-index/map]]
