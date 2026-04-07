import logging
import time
from typing import Any

import httpx
from google import genai

from app.core.config import get_settings
from app.core.exceptions import AIServiceError
from app.services.ai.safety_rules import get_default_safety_settings

logger = logging.getLogger(__name__)


class GeminiRateLimitError(AIServiceError):
    pass


class GeminiTimeoutError(AIServiceError):
    pass


class GeminiInvalidResponseError(AIServiceError):
    pass


class GeminiClient:
    def __init__(self) -> None:
        settings = get_settings()
        if not settings.GEMINI_API_KEY:
            raise AIServiceError("GEMINI_API_KEY is not configured")
        if not settings.GEMINI_MODEL:
            raise AIServiceError("GEMINI_MODEL is not configured")

        self.model = settings.GEMINI_MODEL
        self._client = genai.Client(api_key=settings.GEMINI_API_KEY)

    def generate_text(self, prompt: str, system_instruction: str) -> str:
        logger.debug(
            "Gemini generate_text input: model=%s prompt_len=%s system_len=%s prompt_preview=%s",
            self.model,
            len(prompt),
            len(system_instruction),
            prompt[:700],
        )
        response = self._call_with_retry(
            contents=prompt,
            config={
                "system_instruction": system_instruction,
                "safety_settings": get_default_safety_settings(),
            },
        )
        text = self._extract_text(response)
        logger.debug(
            "Gemini generate_text output: text_len=%s text_preview=%s",
            len(text),
            text[:1000],
        )
        return text

    def generate_with_image(self, prompt: str, image_bytes: bytes, system_instruction: str) -> str:
        contents = [
            {"text": prompt},
            {
                "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": image_bytes,
                }
            },
        ]

        response = self._call_with_retry(
            contents=contents,
            config={
                "system_instruction": system_instruction,
                "safety_settings": get_default_safety_settings(),
            },
        )
        return self._extract_text(response)

    def _call_with_retry(self, *, contents: Any, config: dict[str, Any]) -> Any:
        max_attempts = 3
        for attempt in range(1, max_attempts + 1):
            try:
                return self._client.models.generate_content(
                    model=self.model,
                    contents=contents,
                    config=config,
                )
            except httpx.TimeoutException as exc:
                if attempt >= max_attempts:
                    raise GeminiTimeoutError("Gemini request timed out") from exc
                time.sleep(0.5 * attempt)
            except Exception as exc:  # noqa: BLE001
                message = str(exc).lower()
                if "429" in message or "rate" in message:
                    raise GeminiRateLimitError("Gemini rate limit exceeded") from exc
                if "5" in message and attempt < max_attempts:
                    logger.warning("Gemini 5xx-like error, retrying (attempt %s/%s)", attempt, max_attempts)
                    time.sleep(0.5 * attempt)
                    continue
                raise AIServiceError(f"Gemini request failed: {exc}") from exc

        raise AIServiceError("Gemini request failed after retries")

    @staticmethod
    def _extract_text(response: Any) -> str:
        text = getattr(response, "text", None)
        if text and isinstance(text, str):
            return text
        raise GeminiInvalidResponseError("Gemini returned empty or invalid text response")

