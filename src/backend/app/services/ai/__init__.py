"""AI layer: protocol + Gemini implementation. Add another module implementing AITextClient to swap providers."""

from app.services.ai.ai_text_client import AITextClient
from app.services.ai.exceptions import (
    AIInvalidResponseError,
    AIRateLimitError,
    AITimeoutError,
    GeminiInvalidResponseError,
    GeminiRateLimitError,
    GeminiTimeoutError,
)
from app.services.ai.gemini_client import GeminiClient, GeminiTextClient

__all__ = [
    "AITextClient",
    "AIInvalidResponseError",
    "AIRateLimitError",
    "AITimeoutError",
    "GeminiClient",
    "GeminiInvalidResponseError",
    "GeminiRateLimitError",
    "GeminiTextClient",
    "GeminiTimeoutError",
]
