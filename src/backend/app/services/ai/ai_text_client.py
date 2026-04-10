"""Abstract surface for text+vision LLM calls. Swap `GeminiTextClient` for another implementation."""

from typing import Protocol, runtime_checkable


@runtime_checkable
class AITextClient(Protocol):
    def generate_text(self, prompt: str, system_instruction: str) -> str: ...

    def generate_with_image(self, prompt: str, image_bytes: bytes, system_instruction: str) -> str: ...
