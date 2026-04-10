from pathlib import Path
import sys

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

from app.schemas.recipe import (  # noqa: E402
    GenerateRecipeRequest,
    GenerateRecipeResponse,
    RecipeSuggestionRequest,
    RecipeSuggestionResponse,
)
from app.services.recipe_service import RecipeService  # noqa: E402


class StubPromptBuilder:
    def build_recipe_suggest_prompt(self, query, filters, fridge_products, client_context=None):  # noqa: ANN001
        return "system", f"suggest {query} {filters} {fridge_products}"

    def build_recipe_generate_prompt(self, prompt, preferences, nutrition_target, client_context=None):  # noqa: ANN001
        return "system", f"generate {prompt} {preferences} {nutrition_target}"


class StubAITextClient:
    def __init__(self, response_text: str) -> None:
        self.response_text = response_text

    def generate_text(self, prompt: str, system_instruction: str) -> str:  # noqa: ARG002
        return self.response_text


class StubResponseParser:
    def parse_json_response(self, response_text: str, schema):  # noqa: ANN001
        return schema.model_validate_json(response_text)


def test_suggest_recipes_parses_response() -> None:
    service = RecipeService(
        prompt_builder=StubPromptBuilder(),
        ai_client=StubAITextClient(
            """
            {
              "recipes": [
                {
                  "name": "Chicken Salad",
                  "cooking_time_min": 15,
                  "nutrition": {"calories": 420, "protein_g": 35, "fat_g": 15, "carbs_g": 30},
                  "ingredients": [{"name": "Chicken", "amount": 200, "unit": "g"}],
                  "steps": [{"order": 1, "description": "Mix all"}]
                }
              ]
            }
            """
        ),
        response_parser=StubResponseParser(),
    )
    request = RecipeSuggestionRequest(
        query="quick dinner",
        filters={"max_cooking_time_min": 20},
        fridge_products=[{"name": "chicken"}],
    )

    result = service.suggest_recipes(request)

    assert isinstance(result, RecipeSuggestionResponse)
    assert result.recipes[0].name == "Chicken Salad"


def test_generate_recipe_parses_response() -> None:
    service = RecipeService(
        prompt_builder=StubPromptBuilder(),
        ai_client=StubAITextClient(
            """
            {
              "recipe": {
                "name": "Protein Omelette",
                "cooking_time_min": 10,
                "nutrition": {"calories": 350, "protein_g": 28, "fat_g": 18, "carbs_g": 15},
                "ingredients": [{"name": "Eggs", "amount": 3, "unit": "pcs"}],
                "steps": [{"order": 1, "description": "Cook eggs"}]
              }
            }
            """
        ),
        response_parser=StubResponseParser(),
    )
    request = GenerateRecipeRequest(
        prompt="High protein breakfast",
        preferences={"diet_type": "regular"},
        nutrition_target={"calories": 400, "protein_g": 30, "fat_g": 15, "carbs_g": 30},
    )

    result = service.generate_recipe(request)

    assert isinstance(result, GenerateRecipeResponse)
    assert result.recipe.name == "Protein Omelette"
