# Onboarding — IA Brain em poucos passos

Use quando clonar o vault ou retomar depois de semanas. Diagnóstico: `bash scripts/brain/health-check.sh`.

## 1. Repositório e hooks

```bash
cd /caminho/para/este/vault
git status   # ou git init se for cópia sem .git
bash scripts/brain/install-hooks.sh
```

Isso ativa `pre-commit` (wikilinks só nos `.md` staged) e `post-commit` (registro em `_memory/events/git-commits.md`).

## 2. Chat CLI (opcional, para LM Studio / APIs)

```bash
bash install-chatcli-venv.sh
cp tools/chatcli/profiles.local.yaml.example tools/chatcli/profiles.local.yaml
# edite model/base_url; ou: export CHATCLI_MODEL="id-do-modelo"
```

Atalho no shell (opcional):

```bash
bash criar-atalho-chatcli.sh
```

## 3. Alias `commitbrain` (opcional)

Para **commit + regenerar** [`docs/repo-inventory.md`](docs/repo-inventory.md) num fluxo só (sem hook automático no pós-commit):

```bash
bash scripts/brain/install-git-alias.sh
# uso: git commitbrain -m "sua mensagem"
# em seguida: git add docs/repo-inventory.md && git commit --amend --no-edit   # se quiser no mesmo commit
```

## 4. Obsidian

1. Abra a pasta deste repositório como vault.
2. Comece por [`00-index/map.md`](00-index/map.md).
3. Em Ajustes → Templates, use a pasta [`templates/`](templates/).

### Obsidian em equipe

- `workspace.json` já está no [`.gitignore`](.gitignore) (estado local).
- `graph.json` e `appearance.json` versionados podem gerar **conflitos de merge** em times; alinhe quem ajusta filtros do grafo ou considere ignorá-los no Git (trade-off: cada máquina reconfigura).

## 5. Rotina útil

```bash
bash scripts/brain/health-check.sh
bash scripts/brain/memory-draft.sh    # rascunho de sessão em _memory/sessions/
```

Leia também [`README.md`](README.md) e [`CLAUDE-BRAIN.md`](CLAUDE-BRAIN.md).
