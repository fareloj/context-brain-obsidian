from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml


def _chatcli_root() -> Path:
    return Path(__file__).resolve().parent.parent


def _deep_merge(base: dict[str, Any], override: dict[str, Any]) -> dict[str, Any]:
    out = dict(base)
    for k, v in override.items():
        if k in out and isinstance(out[k], dict) and isinstance(v, dict):
            out[k] = _deep_merge(out[k], v)
        else:
            out[k] = v
    return out


def load_raw_profiles() -> dict[str, Any]:
    root = _chatcli_root()
    example_path = root / "profiles.example.yaml"
    if not example_path.is_file():
        raise FileNotFoundError(f"Faltando {example_path}")

    with example_path.open(encoding="utf-8") as f:
        data = yaml.safe_load(f) or {}

    local_path = root / "profiles.local.yaml"
    if local_path.is_file():
        with local_path.open(encoding="utf-8") as f:
            local = yaml.safe_load(f) or {}
        data = _deep_merge(data, local)

    return data


@dataclass
class Profile:
    name: str
    provider: str
    model: str
    base_url: str | None
    api_key: str


def resolve_profile(name: str, model_override: str | None = None) -> Profile:
    raw = load_raw_profiles()
    profiles = raw.get("profiles") or {}
    if name not in profiles:
        names = ", ".join(sorted(profiles.keys())) or "(nenhum)"
        raise KeyError(f"Perfil desconhecido: {name}. Disponíveis: {names}")

    p = profiles[name]
    provider = str(p.get("provider") or "").strip()
    model = (model_override or "").strip() or str(p.get("model") or "").strip()
    base_url = p.get("base_url")
    base_url_str = str(base_url).strip() if base_url else None

    api_key_env = p.get("api_key_env")
    api_key_literal = p.get("api_key")

    if api_key_env:
        env_name = str(api_key_env).strip()
        key = os.environ.get(env_name, "")
        if not key:
            raise RuntimeError(
                f"Perfil '{name}': variável de ambiente {env_name} não definida ou vazia."
            )
    elif api_key_literal is not None:
        key = str(api_key_literal)
    else:
        key = ""

    if provider == "openai_compat" and not base_url_str:
        raise RuntimeError(f"Perfil '{name}': base_url é obrigatório para openai_compat.")

    if not model:
        raise RuntimeError(
            f"Perfil '{name}': defina 'model' no YAML ou use --model na linha de comando."
        )

    return Profile(
        name=name,
        provider=provider,
        model=model,
        base_url=base_url_str,
        api_key=key,
    )


def read_system_prompt(path_str: str | None) -> str | None:
    if not path_str:
        return None
    path = Path(path_str).expanduser()
    if not path.is_file():
        raise FileNotFoundError(f"Arquivo de system prompt não encontrado: {path}")
    return path.read_text(encoding="utf-8")


def read_context_files(paths: list[str]) -> str:
    """Concatena arquivos para prefixar a primeira mensagem (ou --prompt)."""
    if not paths:
        return ""
    chunks: list[str] = []
    for raw in paths:
        path = Path(raw).expanduser()
        if not path.is_file():
            raise FileNotFoundError(f"Contexto: arquivo não encontrado: {path}")
        label = str(path)
        body = path.read_text(encoding="utf-8")
        chunks.append(f"### {label}\n\n{body}")
    return "\n\n---\n\n".join(chunks)
