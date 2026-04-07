#!/usr/bin/env bash
# Gera docs/graph-export.json com nós (.md) e arestas (wikilinks resolvíveis).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUT="$ROOT/docs/graph-export.json"

if ! command -v python3 >/dev/null 2>&1; then
  echo "Erro: python3 é necessário para gerar JSON." >&2
  exit 1
fi

python3 - "$ROOT" "$OUT" <<'PY'
import json, re, sys
from pathlib import Path

root = Path(sys.argv[1]).resolve()
out = Path(sys.argv[2])

SKIP_DIR = {".git", ".obsidian", "node_modules", ".venv", "__pycache__"}
link_re = re.compile(r"\[\[([^\]|#]+)(?:\|[^\]]+)?(?:#[^\]]*)?\]\]")

def is_skipped(path: Path) -> bool:
    try:
        rel = path.relative_to(root)
    except ValueError:
        return True
    for part in rel.parts:
        if part in SKIP_DIR or part.startswith("."):
            return True
    return False

def resolve_link(target: str) -> Path | None:
    t = target.strip().strip("./")
    if not t.endswith(".md"):
        cand = root / f"{t}.md"
    else:
        cand = root / t
    try:
        cand = cand.resolve()
    except OSError:
        return None
    if not str(cand).startswith(str(root)):
        return None
    if cand.is_file():
        return cand
    return None

md_files: list[Path] = []
for p in root.rglob("*.md"):
    if is_skipped(p):
        continue
    md_files.append(p)

nodes_set: set[str] = set()
edges: list[dict[str, str]] = []

for src in md_files:
    rel_src = str(src.relative_to(root)).replace("\\", "/")
    nodes_set.add(rel_src)
    try:
        text = src.read_text(encoding="utf-8", errors="replace")
    except OSError:
        continue
    for m in link_re.finditer(text):
        raw = m.group(1).strip()
        dst_path = resolve_link(raw)
        if dst_path is None or not dst_path.suffix.lower() == ".md":
            continue
        if is_skipped(dst_path):
            continue
        rel_dst = str(dst_path.relative_to(root)).replace("\\", "/")
        nodes_set.add(rel_dst)
        edges.append({"source": rel_src, "target": rel_dst})

nodes = sorted(nodes_set)
data = {
    "generated_by": "scripts/brain/export-graph-json.sh",
    "vault_root": str(root),
    "node_count": len(nodes),
    "edge_count": len(edges),
    "nodes": [{"id": n, "path": n} for n in nodes],
    "edges": edges,
}
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"Atualizado: {out}", file=sys.stderr)
PY
