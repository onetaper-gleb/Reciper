import logging

from fastapi import APIRouter, Depends, HTTPException

from app.core.exceptions import AIServiceError, ValidationError
from app.schemas.recipe import (
    GenerateRecipeRequest,
    GenerateRecipeResponse,
    RecipeSuggestionRequest,
    RecipeSuggestionResponse,
)
from app.services.ai.gemini_client import GeminiTimeoutError
from app.services.recipe_service import RecipeService

router = APIRouter(prefix="/recipes", tags=["recipes"])
logger = logging.getLogger(__name__)


def get_recipe_service() -> RecipeService:
    return RecipeService()


@router.post("/suggest", response_model=RecipeSuggestionResponse)
def suggest_recipes(
    request: RecipeSuggestionRequest,
    recipe_service: RecipeService = Depends(get_recipe_service),
) -> RecipeSuggestionResponse:
    try:
        logger.info(
            "POST /recipes/suggest: query_len=%s filters=%s fridge_count=%s",
            len(request.query or ""),
            request.filters,
            len(request.fridge_products),
        )
        response = recipe_service.suggest_recipes(request)
        recipes = response.recipes if hasattr(response, "recipes") else response.get("recipes", [])
        logger.info("POST /recipes/suggest: response_recipes_count=%s", len(recipes))
        return response
    except GeminiTimeoutError as exc:
        raise HTTPException(status_code=504, detail=str(exc)) from exc
    except ValidationError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc
    except AIServiceError as exc:
        raise HTTPException(status_code=502, detail=str(exc)) from exc


@router.post("/generate", response_model=GenerateRecipeResponse)
def generate_recipe(
    request: GenerateRecipeRequest,
    recipe_service: RecipeService = Depends(get_recipe_service),
) -> GenerateRecipeResponse:
    try:
        logger.info(
            "POST /recipes/generate: prompt_len=%s has_nutrition_target=%s",
            len(request.prompt or ""),
            request.nutrition_target is not None,
        )
        response = recipe_service.generate_recipe(request)
        recipe_name = (
            response.recipe.name
            if hasattr(response, "recipe")
            else response.get("recipe", {}).get("name", "unknown")
        )
        logger.info("POST /recipes/generate: recipe_name=%s", recipe_name)
        return response
    except GeminiTimeoutError as exc:
        raise HTTPException(status_code=504, detail=str(exc)) from exc
    except ValidationError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc
    except AIServiceError as exc:
        raise HTTPException(status_code=502, detail=str(exc)) from exc
