"""AI provider errors — use these in endpoints so HTTP mapping stays independent of Gemini."""

from app.core.exceptions import AIServiceError


class AITimeoutError(AIServiceError):
    """Upstream LLM request exceeded time limit."""


class AIRateLimitError(AIServiceError):
    """Upstream LLM rate limit."""


class AIInvalidResponseError(AIServiceError):
    """Upstream returned empty or unusable text."""


# Backwards compatibility for imports
GeminiTimeoutError = AITimeoutError
GeminiRateLimitError = AIRateLimitError
GeminiInvalidResponseError = AIInvalidResponseError
