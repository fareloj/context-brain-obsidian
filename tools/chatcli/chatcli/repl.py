from __future__ import annotations

import sys
from typing import Any, Protocol


class Backend(Protocol):
    def iter_response(
        self,
        messages: list[dict[str, Any]],
        system: str | None,
        *,
        stream: bool,
    ) -> Any: ...


def run_single_turn(
    backend: Backend,
    *,
    system: str | None,
    user_content: str,
    stream: bool,
) -> str:
    messages: list[dict[str, str]] = [{"role": "user", "content": user_content}]
    parts: list[str] = []
    for chunk in backend.iter_response(messages, system, stream=stream):
        parts.append(chunk)
        if stream:
            print(chunk, end="", flush=True)
    text = "".join(parts)
    if stream:
        print()
    else:
        print(text + "\n")
    return text


def run_repl(
    backend: Backend,
    *,
    system: str | None,
    stream: bool,
    context_prefix: str | None = None,
) -> None:
    history: list[dict[str, str]] = []
    pending_context = (context_prefix or "").strip() or None

    print("Chat CLI — comandos: /quit, /clear, /help")
    print("Digite sua mensagem e Enter.\n")

    while True:
        try:
            line = input("você> ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nAté logo.")
            return

        if not line:
            continue

        if line in ("/quit", "/exit"):
            print("Até logo.")
            return

        if line == "/clear":
            history.clear()
            print("(histórico limpo)\n")
            continue

        if line == "/help":
            print("  /quit /exit  — sair")
            print("  /clear       — limpar mensagens da sessão")
            print("  /help        — esta ajuda\n")
            continue

        if line.startswith("/"):
            print("Comando desconhecido. Use /help.\n")
            continue

        user_content = line
        if pending_context is not None:
            user_content = f"{pending_context}\n\n---\n\nPergunta:\n{line}"
            pending_context = None

        history.append({"role": "user", "content": user_content})

        print("modelo> ", end="", flush=True)
        parts: list[str] = []
        try:
            for chunk in backend.iter_response(history, system, stream=stream):
                parts.append(chunk)
                if stream:
                    print(chunk, end="", flush=True)
        except Exception as e:
            print(f"\n[erro] {e}", file=sys.stderr)
            history.pop()
            print()
            continue

        assistant_text = "".join(parts)
        if stream:
            print("\n")
        else:
            print(assistant_text + "\n")
        history.append({"role": "assistant", "content": assistant_text})
