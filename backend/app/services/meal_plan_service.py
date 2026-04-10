import json
import logging

from app.core.exceptions import AIServiceError, ValidationError
from app.schemas.meal_plan import (
    GeneratePlanRequest,
    GeneratePlanResponse,
    ReplaceMealRequest,
    ReplaceMealResponse,
)
from app.services.ai.ai_text_client import AITextClient
from app.services.ai.gemini_client import GeminiTextClient
from app.services.ai.prompt_builder import PromptBuilder
from app.services.ai.response_parser import ResponseParser

logger = logging.getLogger(__name__)


class MealPlanService:
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

    def generate_plan(self, request: GeneratePlanRequest) -> GeneratePlanResponse:
        logger.info("generate_plan: profile=%s options=%s", request.profile.model_dump(), request.plan_options.model_dump())
        system_prompt, user_prompt = self.prompt_builder.build_meal_plan_prompt(
            profile=request.profile.model_dump(),
            preferences=request.preferences.model_dump(),
            plan_options=request.plan_options.model_dump(),
            fridge_products=[p.model_dump() for p in request.fridge_products],
            notes=request.additional_notes,
            client_context=request.client_context,
        )
        ai_text = self._ai().generate_text(user_prompt, system_prompt)
        logger.debug("generate_plan: ai_text_head=%s", ai_text[:500])
        try:
            response = self.response_parser.parse_json_response(ai_text, GeneratePlanResponse)
        except AIServiceError as first_exc:
            repair_prompt = self._build_repair_prompt(
                error=str(first_exc),
                required_top_level_keys=["plan", "weekly_summary"],
                original_response=ai_text,
            )
            ai_text_2 = self._ai().generate_text(repair_prompt, system_prompt)
            response = self.response_parser.parse_json_response(ai_text_2, GeneratePlanResponse)
        self._validate_generate_response(response)
        return response

    def replace_meal(self, request: ReplaceMealRequest) -> ReplaceMealResponse:
        logger.info("replace_meal: request=%s", request.model_dump())
        system_prompt, user_prompt = self.prompt_builder.build_replace_meal_prompt(
            current_meal=request.current_recipe.model_dump(),
            reason=request.reason,
            day_context=request.day_context.model_dump(),
            preferences=request.preferences.model_dump(),
            fridge=[p.model_dump() for p in request.fridge_products],
            client_context=request.client_context,
        )
        ai_text = self._ai().generate_text(user_prompt, system_prompt)
        ai_text = self._coerce_replace_payload(ai_text)
        logger.debug("replace_meal: ai_text_head=%s", ai_text[:500])
        try:
            response = self.response_parser.parse_json_response(ai_text, ReplaceMealResponse)
        except AIServiceError as first_exc:
            repair_prompt = self._build_repair_prompt(
                error=str(first_exc),
                required_top_level_keys=["recipe"],
                original_response=ai_text,
            )
            ai_text_2 = self._ai().generate_text(repair_prompt, system_prompt)
            ai_text_2 = self._coerce_replace_payload(ai_text_2)
            response = self.response_parser.parse_json_response(ai_text_2, ReplaceMealResponse)
        self._validate_replace_response(request, response)
        return response

    @staticmethod
    def _coerce_replace_payload(raw_text: str) -> str:
        """Accept accidental full-plan payloads and convert them to ReplaceMealResponse shape."""
        try:
            data = json.loads(raw_text)
        except Exception:  # noqa: BLE001
            return raw_text
        if isinstance(data, dict) and isinstance(data.get("recipe"), dict):
            return raw_text
        if isinstance(data, dict) and isinstance(data.get("plan"), dict):
            days = data.get("plan", {}).get("days", [])
            if isinstance(days, list) and days:
                meals = days[0].get("meals", []) if isinstance(days[0], dict) else []
                if isinstance(meals, list) and meals:
                    recipe = meals[0].get("recipe", {}) if isinstance(meals[0], dict) else {}
                    if isinstance(recipe, dict) and recipe:
                        return json.dumps({"recipe": recipe}, ensure_ascii=False)
        return raw_text

    @staticmethod
    def _validate_generate_response(response: GeneratePlanResponse) -> None:
        target = response.weekly_summary.avg_calories
        if target <= 0:
            raise ValidationError("weekly_summary.avg_calories must be positive")

        for day in response.plan.days:
            day_calories = sum(meal.recipe.nutrition.calories for meal in day.meals)
            min_allowed = target * 0.9
            max_allowed = target * 1.1
            if day.meals and not (min_allowed <= day_calories <= max_allowed):
                raise ValidationError(
                    f"Day {day.date} calories {day_calories} out of allowed range [{min_allowed:.0f}, {max_allowed:.0f}]"
                )

    @staticmethod
    def _validate_replace_response(
        request: ReplaceMealRequest,
        response: ReplaceMealResponse,
    ) -> None:
        remaining = request.day_context.remaining_calories
        if remaining <= 0:
            raise ValidationError("remaining_calories must be positive")

        new_calories = response.recipe.nutrition.calories
        if new_calories > remaining * 1.1:
            raise ValidationError("Replacement meal exceeds remaining day calories")

    @staticmethod
    def _build_repair_prompt(
        *,
        error: str,
        required_top_level_keys: list[str],
        original_response: str,
    ) -> str:
        keys = ", ".join(required_top_level_keys)
        return (
            "Your previous response was invalid or did not match the required schema.\n"
            f"Error: {error}\n"
            f"Return JSON ONLY. Top-level keys MUST be: {keys}\n"
            "Reformat the previous content into the required JSON shape. Do not add markdown.\n\n"
            "PREVIOUS RESPONSE:\n"
            f"{original_response}"
        )

