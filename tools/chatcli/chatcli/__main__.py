from __future__ import annotations

import argparse
import sys

from chatcli.config import read_context_files, read_system_prompt, resolve_profile
from chatcli.repl import run_repl, run_single_turn


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Chat CLI multi-backend (LM Studio / OpenAI / Anthropic)"
    )
    parser.add_argument(
        "--profile",
        "-p",
        default="lmstudio",
        help="Nome do perfil em profiles.example.yaml / profiles.local.yaml",
    )
    parser.add_argument(
        "--model",
        "-m",
        default=None,
        help="Sobrescreve o campo model do perfil",
    )
    parser.add_argument(
        "--system",
        "-s",
        default=None,
        help="Arquivo Markdown/texto usado como prompt de sistema",
    )
    parser.add_argument(
        "--no-stream",
        action="store_true",
        help="Resposta em um bloco só (sem streaming)",
    )
    parser.add_argument(
        "--prompt",
        "-P",
        default=None,
        metavar="TEXTO",
        help="Uma única pergunta; imprime a resposta e sai (sem REPL)",
    )
    parser.add_argument(
        "--context",
        "-c",
        action="append",
        default=[],
        metavar="ARQUIVO",
        help="Arquivo a incluir como contexto (pode repetir). No REPL, só na 1ª mensagem.",
    )
    args = parser.parse_args()

    try:
        profile = resolve_profile(args.profile, model_override=args.model)
        system = read_system_prompt(args.system)
        context_block = read_context_files(args.context) if args.context else ""
    except Exception as e:
        print(f"Erro de configuração: {e}", file=sys.stderr)
        sys.exit(1)

    if profile.provider == "openai_compat":
        from chatcli.backends.openai_compat import OpenAICompatBackend

        assert profile.base_url is not None
        backend = OpenAICompatBackend(
            base_url=profile.base_url,
            api_key=profile.api_key,
            model=profile.model,
        )
    elif profile.provider == "anthropic":
        from chatcli.backends.anthropic_backend import AnthropicBackend

        backend = AnthropicBackend(
            api_key=profile.api_key,
            model=profile.model,
        )
    else:
        print(
            f"Provider desconhecido: {profile.provider}. Use openai_compat ou anthropic.",
            file=sys.stderr,
        )
        sys.exit(1)

    stream = not args.no_stream
    if args.prompt is not None:
        user_body = args.prompt
        if context_block:
            user_body = f"{context_block}\n\n---\n\nPergunta:\n{args.prompt}"
        run_single_turn(
            backend,
            system=system,
            user_content=user_body,
            stream=stream,
        )
        return

    ctx_prefix = context_block if context_block else None
    run_repl(backend, system=system, stream=stream, context_prefix=ctx_prefix)


if __name__ == "__main__":
    main()
