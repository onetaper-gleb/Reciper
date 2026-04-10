import json
from datetime import datetime

from app.core.exceptions import ValidationError
from app.schemas.common import ClientContextSchema
from app.schemas.fridge import FridgeScanResponse, RecognizedProductSchema
from app.services.ai.ai_text_client import AITextClient
from app.services.ai.gemini_client import GeminiTextClient
from app.services.ai.prompt_builder import PromptBuilder
from app.services.ai.response_parser import ResponseParser


class FridgeScanService:
    def __init__(
        self,
        prompt_builder: PromptBuilder | None = None,
        ai_client: AITextClient | None = None,
        response_parser: ResponseParser | None = None,
    ) -> None:
        self.prompt_builder = prompt_builder or PromptBuilder()
        self.ai_client = ai_client
        self.response_parser = response_parser or ResponseParser()

    def _ai(self) -> AITextClient:
        if self.ai_client is None:
            self.ai_client = GeminiTextClient()
        return self.ai_client

    def scan_fridge(
        self,
        image_bytes: bytes,
        existing_products_json: str | None,
        scan_mode: str,
        client_local_datetime_iso: str | None = None,
    ) -> FridgeScanResponse:
        existing_products = self._parse_existing(existing_products_json)
        client_ctx = self._parse_client_datetime(client_local_datetime_iso)
        system_prompt, user_prompt = self.prompt_builder.build_fridge_scan_prompt(
            existing_products, client_context=client_ctx
        )
        ai_text = self._ai().generate_with_image(user_prompt, image_bytes, system_prompt)
        response = self.response_parser.parse_json_response(ai_text, FridgeScanResponse)

        if scan_mode == "append":
            return FridgeScanResponse(
                recognized_products=self._merge_products(existing_products, response.recognized_products)
            )
        if scan_mode != "replace":
            raise ValidationError("scan_mode must be 'replace' or 'append'")
        return response

    @staticmethod
    def _parse_client_datetime(raw: str | None) -> ClientContextSchema | None:
        if not raw or not raw.strip():
            return None
        try:
            return ClientContextSchema(local_datetime=datetime.fromisoformat(raw.replace("Z", "+00:00")))
        except ValueError:
            raise ValidationError("client_local_datetime must be a valid ISO 8601 datetime string") from None

    @staticmethod
    def _parse_existing(existing_products_json: str | None) -> list[RecognizedProductSchema]:
        if not existing_products_json:
            return []
        try:
            parsed = json.loads(existing_products_json)
            if not isinstance(parsed, list):
                raise ValidationError("existing_products_json must be a JSON array")
            return [RecognizedProductSchema.model_validate(item) for item in parsed]
        except json.JSONDecodeError as exc:
            raise ValidationError("existing_products_json is not valid JSON") from exc

    @staticmethod
    def _merge_products(
        existing: list[RecognizedProductSchema],
        incoming: list[RecognizedProductSchema],
    ) -> list[RecognizedProductSchema]:
        merged: dict[tuple[str, str], RecognizedProductSchema] = {}
        for product in [*existing, *incoming]:
            key = (product.name.strip().lower(), (product.unit or "").strip().lower())
            if key in merged:
                prev = merged[key]
                merged[key] = RecognizedProductSchema(
                    name=prev.name,
                    unit=prev.unit or product.unit,
                    amount=(prev.amount or 0.0) + (product.amount or 0.0),
                    confidence=max(prev.confidence, product.confidence),
                )
            else:
                merged[key] = product
        return list(merged.values())
