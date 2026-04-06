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


def run_repl(
    backend: Backend,
    *,
    system: str | None,
    stream: bool,
) -> None:
    history: list[dict[str, str]] = []

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

        history.append({"role": "user", "content": line})

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
