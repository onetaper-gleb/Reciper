import json
import re
from typing import Callable, TypeVar

from pydantic import BaseModel, ValidationError as PydanticValidationError

from app.core.exceptions import AIServiceError

ModelT = TypeVar("ModelT", bound=BaseModel)


class ResponseParser:
    def parse_json_response(
        self,
        response_text: str,
        schema: type[ModelT],
        retry_builder: Callable[[str], str] | None = None,
        max_retries: int = 1,
    ) -> ModelT:
        attempts = 0
        candidate = response_text

        while True:
            try:
                payload = self._extract_json_object(candidate)
                return schema.model_validate(payload)
            except (json.JSONDecodeError, PydanticValidationError, ValueError) as exc:
                if retry_builder is not None and attempts < max_retries:
                    candidate = retry_builder(str(exc))
                    attempts += 1
                    continue
                raise AIServiceError(f"Failed to parse AI response: {exc}") from exc

    @staticmethod
    def _extract_json_object(raw: str) -> dict:
        text = raw.strip()

        # Gemini can return:
        # - plain JSON
        # - fenced code blocks ```...```
        # - fenced code blocks with language tag ```json
        # Extract the fenced payload if present, otherwise use the whole text.
        parts = text.split("```")
        if len(parts) >= 3:
            text = parts[1].strip()
        elif parts:
            text = parts[0].strip()

        # Remove optional "json" language marker at the start of fenced content.
        text = re.sub(r"^\s*json\s*", "", text, count=1, flags=re.IGNORECASE).strip()

        data = json.loads(text)
        if not isinstance(data, dict):
            raise ValueError("JSON root must be an object")
        return data

