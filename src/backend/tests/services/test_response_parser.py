from pathlib import Path
import sys

import pytest
from pydantic import BaseModel

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

from app.core.exceptions import AIServiceError  # noqa: E402
from app.services.ai.response_parser import ResponseParser  # noqa: E402


class ParsedResult(BaseModel):
    name: str
    calories: int


def test_parse_valid_json_returns_pydantic_model() -> None:
    parser = ResponseParser()

    result = parser.parse_json_response('{"name":"Chicken salad","calories":380}', ParsedResult)

    assert isinstance(result, ParsedResult)
    assert result.name == "Chicken salad"
    assert result.calories == 380


def test_parse_invalid_json_raises_error() -> None:
    parser = ResponseParser()

    with pytest.raises(AIServiceError):
        parser.parse_json_response("this is not json", ParsedResult)


def test_parse_json_inside_markdown_fence() -> None:
    parser = ResponseParser()
    raw = """```json
{"name":"Omelette","calories":420}
```"""

    result = parser.parse_json_response(raw, ParsedResult)

    assert result.name == "Omelette"
    assert result.calories == 420


def test_parse_json_inside_plain_fence_without_language() -> None:
    parser = ResponseParser()
    raw = """```
{"name":"Toast","calories":300}
```"""

    result = parser.parse_json_response(raw, ParsedResult)

    assert result.name == "Toast"
    assert result.calories == 300

