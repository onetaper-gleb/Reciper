from app.core.exceptions import AIServiceError, ValidationError
from app.schemas.meal_plan import (
    GeneratePlanRequest,
    GeneratePlanResponse,
    ReplaceMealRequest,
    ReplaceMealResponse,
)
from app.services.ai.gemini_client import GeminiClient
from app.services.ai.prompt_builder import PromptBuilder
from app.services.ai.response_parser import ResponseParser


class MealPlanService:
    def __init__(
        self,
        prompt_builder: PromptBuilder | None = None,
        gemini_client: GeminiClient | None = None,
        response_parser: ResponseParser | None = None,
    ) -> None:
        self.prompt_builder = prompt_builder or PromptBuilder()
        self.gemini_client = gemini_client or GeminiClient()
        self.response_parser = response_parser or ResponseParser()

    def generate_plan(self, request: GeneratePlanRequest) -> GeneratePlanResponse:
        system_prompt, user_prompt = self.prompt_builder.build_meal_plan_prompt(
            profile=request.profile.model_dump(),
            preferences=request.preferences.model_dump(),
            plan_options=request.plan_options.model_dump(),
            fridge_products=[p.model_dump() for p in request.fridge_products],
            notes=request.additional_notes,
        )
        ai_text = self.gemini_client.generate_text(user_prompt, system_prompt)
        try:
            response = self.response_parser.parse_json_response(ai_text, GeneratePlanResponse)
        except AIServiceError as first_exc:
            repair_prompt = self._build_repair_prompt(
                error=str(first_exc),
                required_top_level_keys=["plan", "weekly_summary"],
                original_response=ai_text,
            )
            ai_text_2 = self.gemini_client.generate_text(repair_prompt, system_prompt)
            response = self.response_parser.parse_json_response(ai_text_2, GeneratePlanResponse)
        self._validate_generate_response(response)
        return response

    def replace_meal(self, request: ReplaceMealRequest) -> ReplaceMealResponse:
        system_prompt, user_prompt = self.prompt_builder.build_replace_meal_prompt(
            current_meal=request.current_recipe.model_dump(),
            reason=request.reason,
            day_context=request.day_context.model_dump(),
            preferences=request.preferences.model_dump(),
            fridge=[p.model_dump() for p in request.fridge_products],
        )
        ai_text = self.gemini_client.generate_text(user_prompt, system_prompt)
        try:
            response = self.response_parser.parse_json_response(ai_text, ReplaceMealResponse)
        except AIServiceError as first_exc:
            repair_prompt = self._build_repair_prompt(
                error=str(first_exc),
                required_top_level_keys=["recipe"],
                original_response=ai_text,
            )
            ai_text_2 = self.gemini_client.generate_text(repair_prompt, system_prompt)
            response = self.response_parser.parse_json_response(ai_text_2, ReplaceMealResponse)
        self._validate_replace_response(request, response)
        return response

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

