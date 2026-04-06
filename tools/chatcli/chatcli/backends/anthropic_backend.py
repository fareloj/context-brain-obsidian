from __future__ import annotations

from collections.abc import Iterator
from typing import Any

from anthropic import Anthropic


class AnthropicBackend:
    def __init__(self, api_key: str, model: str) -> None:
        self._client = Anthropic(api_key=api_key)
        self._model = model

    @staticmethod
    def _to_anthropic_messages(messages: list[dict[str, Any]]) -> list[dict[str, Any]]:
        out: list[dict[str, Any]] = []
        for m in messages:
            role = m.get("role")
            if role in ("user", "assistant"):
                out.append({"role": role, "content": m.get("content", "")})
        return out

    def iter_response(
        self,
        messages: list[dict[str, Any]],
        system: str | None,
        *,
        stream: bool,
    ) -> Iterator[str]:
        kwargs: dict[str, Any] = {
            "model": self._model,
            "max_tokens": 8192,
            "messages": self._to_anthropic_messages(messages),
        }
        if system:
            kwargs["system"] = system

        if stream:
            with self._client.messages.stream(**kwargs) as st:
                for text in st.text_stream:
                    yield text
        else:
            r = self._client.messages.create(stream=False, **kwargs)
            parts: list[str] = []
            for block in r.content:
                if block.type == "text":
                    parts.append(block.text)
            yield "".join(parts)
