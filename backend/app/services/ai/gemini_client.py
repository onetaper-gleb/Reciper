"""Google Gemini implementation of [AITextClient]."""

from __future__ import annotations

import logging
import time
from concurrent.futures import FIRST_COMPLETED, ThreadPoolExecutor, wait
from typing import Any

import httpx
from google import genai

from app.core.config import get_settings
from app.core.exceptions import AIServiceError
from app.services.ai.exceptions import (
    AIInvalidResponseError,
    AIRateLimitError,
    AITimeoutError,
)
from app.services.ai.safety_rules import get_default_safety_settings

logger = logging.getLogger(__name__)


class GeminiTextClient:
    """Gemini-backed client. Optional second model + race: first successful response wins."""

    def __init__(self) -> None:
        settings = get_settings()
        if not settings.GEMINI_API_KEY:
            raise AIServiceError("GEMINI_API_KEY is not configured")
        if not settings.GEMINI_MODEL:
            raise AIServiceError("GEMINI_MODEL is not configured")

        self._primary_model = settings.GEMINI_MODEL
        self._fallback_model = (settings.GEMINI_MODEL_FALLBACK or "").strip() or None
        self._race_enabled = settings.AI_MODEL_RACE_ENABLED and bool(self._fallback_model)
        self._client = genai.Client(api_key=settings.GEMINI_API_KEY)

    def _models_for_text(self) -> list[str]:
        if self._race_enabled and self._fallback_model:
            return [self._primary_model, self._fallback_model]
        return [self._primary_model]

    def _models_for_image(self) -> list[str]:
        return self._models_for_text()

    def generate_text(self, prompt: str, system_instruction: str) -> str:
        models = self._models_for_text()
        if len(models) == 1:
            return self._generate_text_single(models[0], prompt, system_instruction)
        return self._race_generate_text(models, prompt, system_instruction)

    def generate_with_image(self, prompt: str, image_bytes: bytes, system_instruction: str) -> str:
        models = self._models_for_image()
        if len(models) == 1:
            return self._generate_with_image_single(models[0], prompt, image_bytes, system_instruction)
        return self._race_generate_image(models, prompt, image_bytes, system_instruction)

    def _race_generate_text(self, models: list[str], prompt: str, system_instruction: str) -> str:
        return self._race(
            models,
            lambda m: self._generate_text_single(m, prompt, system_instruction),
            "generate_text",
        )

    def _race_generate_image(
        self, models: list[str], prompt: str, image_bytes: bytes, system_instruction: str
    ) -> str:
        return self._race(
            models,
            lambda m: self._generate_with_image_single(m, prompt, image_bytes, system_instruction),
            "generate_with_image",
        )

    def _race(self, models: list[str], fn: Any, op: str) -> str:
        """Run tasks in parallel; return the first successful result."""
        errors: list[Exception] = []
        pool = ThreadPoolExecutor(max_workers=len(models))
        try:
            future_to_model = {pool.submit(fn, m): m for m in models}
            pending = set(future_to_model.keys())
            while pending:
                done, not_done = wait(pending, return_when=FIRST_COMPLETED)
                pending = set(not_done)
                for fut in done:
                    model = future_to_model[fut]
                    try:
                        result = fut.result()
                        logger.info(
                            "%s: model race won by %s (first success)",
                            op,
                            model,
                        )
                        for p in pending:
                            p.cancel()
                        # Important: don't wait for slower in-flight requests.
                        pool.shutdown(wait=False, cancel_futures=True)
                        return result
                    except Exception as exc:  # noqa: BLE001
                        errors.append(exc)
                        logger.warning("%s: model %s failed: %s", op, model, exc)
        finally:
            # Ensure resources are released for all-failed path.
            pool.shutdown(wait=False, cancel_futures=True)
        if errors:
            raise AIServiceError(f"All models failed ({op})") from errors[-1]
        raise AIServiceError(f"All models failed ({op})")

    def _generate_text_single(self, model: str, prompt: str, system_instruction: str) -> str:
        logger.debug(
            "Gemini generate_text: model=%s prompt_len=%s system_len=%s",
            model,
            len(prompt),
            len(system_instruction),
        )
        response = self._call_with_retry(
            model=model,
            contents=prompt,
            config={
                "system_instruction": system_instruction,
                "safety_settings": get_default_safety_settings(),
            },
        )
        text = self._extract_text(response)
        logger.debug("Gemini generate_text output: text_len=%s", len(text))
        return text

    def _generate_with_image_single(
        self,
        model: str,
        prompt: str,
        image_bytes: bytes,
        system_instruction: str,
    ) -> str:
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
            model=model,
            contents=contents,
            config={
                "system_instruction": system_instruction,
                "safety_settings": get_default_safety_settings(),
            },
        )
        return self._extract_text(response)

    def _call_with_retry(self, *, model: str, contents: Any, config: dict[str, Any]) -> Any:
        max_attempts = 3
        for attempt in range(1, max_attempts + 1):
            try:
                return self._client.models.generate_content(
                    model=model,
                    contents=contents,
                    config=config,
                )
            except httpx.TimeoutException as exc:
                if attempt >= max_attempts:
                    raise AITimeoutError("Сервис ИИ не ответил вовремя") from exc
                time.sleep(0.5 * attempt)
            except Exception as exc:  # noqa: BLE001
                message = str(exc).lower()
                if "429" in message or "rate" in message:
                    raise AIRateLimitError("Превышен лимит запросов к ИИ") from exc
                if "5" in message and attempt < max_attempts:
                    logger.warning("Gemini 5xx-like error, retrying (attempt %s/%s)", attempt, max_attempts)
                    time.sleep(0.5 * attempt)
                    continue
                raise AIServiceError(f"Запрос к ИИ не выполнен: {exc}") from exc

        raise AIServiceError("Запрос к ИИ не выполнен после повторов")

    @staticmethod
    def _extract_text(response: Any) -> str:
        text = getattr(response, "text", None)
        if text and isinstance(text, str):
            return text
        raise AIInvalidResponseError("ИИ вернул пустой или некорректный ответ")


# Alias for existing code and tests
GeminiClient = GeminiTextClient
