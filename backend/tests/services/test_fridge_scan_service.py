from pathlib import Path
import sys

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

from app.schemas.fridge import FridgeScanResponse  # noqa: E402
from app.services.fridge_scan_service import FridgeScanService  # noqa: E402


class StubPromptBuilder:
    def build_fridge_scan_prompt(self, existing_products):  # noqa: ANN001
        return "system", f"user prompt {existing_products}"


class StubGeminiClient:
    def __init__(self, response_text: str) -> None:
        self.response_text = response_text

    def generate_with_image(self, prompt: str, image_bytes: bytes, system_instruction: str) -> str:  # noqa: ARG002
        return self.response_text


class StubResponseParser:
    def parse_json_response(self, response_text: str, schema):  # noqa: ANN001
        return schema.model_validate_json(response_text)


def test_scan_fridge_replace_parses_ai_response() -> None:
    service = FridgeScanService(
        prompt_builder=StubPromptBuilder(),
        gemini_client=StubGeminiClient(
            """
            {
              "recognized_products": [
                {"name": "Milk", "amount": 1, "unit": "l", "confidence": 0.95}
              ]
            }
            """
        ),
        response_parser=StubResponseParser(),
    )

    response = service.scan_fridge(image_bytes=b"img", existing_products_json=None, scan_mode="replace")

    assert isinstance(response, FridgeScanResponse)
    assert response.recognized_products[0].name == "Milk"


def test_scan_fridge_append_merges_products_by_name_and_unit() -> None:
    service = FridgeScanService(
        prompt_builder=StubPromptBuilder(),
        gemini_client=StubGeminiClient(
            """
            {
              "recognized_products": [
                {"name": "Milk", "amount": 1, "unit": "l", "confidence": 0.95},
                {"name": "Eggs", "amount": 6, "unit": "pcs", "confidence": 0.91}
              ]
            }
            """
        ),
        response_parser=StubResponseParser(),
    )

    existing = '[{"name":"Milk","amount":0.5,"unit":"l","confidence":0.90}]'
    response = service.scan_fridge(image_bytes=b"img", existing_products_json=existing, scan_mode="append")

    assert len(response.recognized_products) == 2
    milk = next(item for item in response.recognized_products if item.name == "Milk")
    assert milk.amount == 1.5


def test_scan_fridge_append_accepts_existing_without_confidence() -> None:
    service = FridgeScanService(
        prompt_builder=StubPromptBuilder(),
        gemini_client=StubGeminiClient(
            """
            {
              "recognized_products": [
                {"name": "Milk", "amount": 1, "unit": "l", "confidence": 0.95}
              ]
            }
            """
        ),
        response_parser=StubResponseParser(),
    )

    existing = '[{"name":"Milk","amount":0.5,"unit":"l"}]'
    response = service.scan_fridge(image_bytes=b"img", existing_products_json=existing, scan_mode="append")

    milk = next(item for item in response.recognized_products if item.name == "Milk")
    assert milk.amount == 1.5
