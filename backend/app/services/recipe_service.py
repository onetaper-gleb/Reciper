import logging

from app.schemas.recipe import (
    GenerateRecipeRequest,
    GenerateRecipeResponse,
    RecipeSuggestionRequest,
    RecipeSuggestionResponse,
)
from app.services.ai.gemini_client import GeminiClient
from app.services.ai.prompt_builder import PromptBuilder
from app.services.ai.response_parser import ResponseParser

logger = logging.getLogger(__name__)


class RecipeService:
    def __init__(
        self,
        prompt_builder: PromptBuilder | None = None,
        gemini_client: GeminiClient | None = None,
        response_parser: ResponseParser | None = None,
    ) -> None:
        self.prompt_builder = prompt_builder or PromptBuilder()
        self.gemini_client = gemini_client
        self.response_parser = response_parser or ResponseParser()

    def _gemini(self) -> GeminiClient:
        if self.gemini_client is None:
            self.gemini_client = GeminiClient()
        return self.gemini_client

    def suggest_recipes(self, request: RecipeSuggestionRequest) -> RecipeSuggestionResponse:
        fridge_trimmed = [item.model_dump() for item in request.fridge_products][:25]
        logger.info(
            "suggest_recipes: query_len=%s filters=%s fridge_count=%s trimmed_to=%s",
            len(request.query or ""),
            request.filters,
            len(request.fridge_products),
            len(fridge_trimmed),
        )
        system_prompt, user_prompt = self.prompt_builder.build_recipe_suggest_prompt(
            query=request.query,
            filters=request.filters,
            fridge_products=fridge_trimmed,
        )
        logger.debug(
            "suggest_recipes prompts: system_len=%s user_len=%s user_preview=%s",
            len(system_prompt),
            len(user_prompt),
            user_prompt[:1000],
        )
        ai_text = self._gemini().generate_text(user_prompt, system_prompt)
        logger.debug(
            "suggest_recipes ai_text_len=%s ai_text_preview=%s",
            len(ai_text),
            ai_text[:1200],
        )
        parsed = self.response_parser.parse_json_response(ai_text, RecipeSuggestionResponse)
        logger.info("suggest_recipes parsed recipes_count=%s", len(parsed.recipes))
        return parsed

    def generate_recipe(self, request: GenerateRecipeRequest) -> GenerateRecipeResponse:
        logger.info(
            "generate_recipe: prompt_len=%s has_nutrition_target=%s",
            len(request.prompt or ""),
            request.nutrition_target is not None,
        )
        system_prompt, user_prompt = self.prompt_builder.build_recipe_generate_prompt(
            prompt=request.prompt,
            preferences=request.preferences.model_dump(),
            nutrition_target=request.nutrition_target.model_dump() if request.nutrition_target else None,
        )
        logger.debug(
            "generate_recipe prompts: system_len=%s user_len=%s user_preview=%s",
            len(system_prompt),
            len(user_prompt),
            user_prompt[:1000],
        )
        ai_text = self._gemini().generate_text(user_prompt, system_prompt)
        logger.debug(
            "generate_recipe ai_text_len=%s ai_text_preview=%s",
            len(ai_text),
            ai_text[:1200],
        )
        parsed = self.response_parser.parse_json_response(ai_text, GenerateRecipeResponse)
        logger.info("generate_recipe parsed recipe_name=%s", parsed.recipe.name)
        return parsed
