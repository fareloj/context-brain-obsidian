"""Backends de chat (OpenAI-compat e Anthropic)."""

__all__ = ["AnthropicBackend", "OpenAICompatBackend"]


def __getattr__(name: str):
    if name == "AnthropicBackend":
        from chatcli.backends.anthropic_backend import AnthropicBackend

        return AnthropicBackend
    if name == "OpenAICompatBackend":
        from chatcli.backends.openai_compat import OpenAICompatBackend

        return OpenAICompatBackend
    raise AttributeError(name)
