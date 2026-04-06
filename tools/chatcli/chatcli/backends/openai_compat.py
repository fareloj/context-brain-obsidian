from __future__ import annotations

from collections.abc import Iterator
from typing import Any

from openai import OpenAI


class OpenAICompatBackend:
    """OpenAI API ou servidor compatível (ex.: LM Studio)."""

    def __init__(self, base_url: str, api_key: str, model: str) -> None:
        self._client = OpenAI(base_url=base_url, api_key=api_key or "lm-studio")
        self._model = model

    def iter_response(
        self,
        messages: list[dict[str, Any]],
        system: str | None,
        *,
        stream: bool,
    ) -> Iterator[str]:
        msgs: list[dict[str, Any]] = []
        if system:
            msgs.append({"role": "system", "content": system})
        msgs.extend(messages)

        if stream:
            s = self._client.chat.completions.create(
                model=self._model,
                messages=msgs,
                stream=True,
            )
            for chunk in s:
                choice = chunk.choices[0]
                if choice.delta and choice.delta.content:
                    yield choice.delta.content
        else:
            r = self._client.chat.completions.create(
                model=self._model,
                messages=msgs,
                stream=False,
            )
            content = r.choices[0].message.content
            if content:
                yield content
