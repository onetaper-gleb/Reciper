from pathlib import Path
import sys

from fastapi.testclient import TestClient

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

from app.api.v1.endpoints.recipes import get_recipe_service  # noqa: E402
from app.main import app  # noqa: E402


class FakeRecipeService:
    def suggest_recipes(self, request):  # noqa: ANN001
        return {
            "recipes": [
                {
                    "name": "Chicken Salad",
                    "cooking_time_min": 15,
                    "nutrition": {"calories": 420, "protein_g": 35, "fat_g": 15, "carbs_g": 30},
                    "ingredients": [{"name": "Chicken", "amount": 200, "unit": "g"}],
                    "steps": [{"order": 1, "description": "Mix all"}],
                }
            ]
        }

    def generate_recipe(self, request):  # noqa: ANN001
        return {
            "recipe": {
                "name": "Protein Omelette",
                "cooking_time_min": 10,
                "nutrition": {"calories": 350, "protein_g": 28, "fat_g": 18, "carbs_g": 15},
                "ingredients": [{"name": "Eggs", "amount": 3, "unit": "pcs"}],
                "steps": [{"order": 1, "description": "Cook eggs"}],
            }
        }


client = TestClient(app)


def test_suggest_recipes_returns_200_and_list() -> None:
    app.dependency_overrides[get_recipe_service] = lambda: FakeRecipeService()
    response = client.post(
        "/api/v1/recipes/suggest",
        json={
            "query": "quick dinner",
            "filters": {"max_cooking_time_min": 20},
            "fridge_products": [{"name": "chicken"}],
        },
    )
    app.dependency_overrides.clear()

    assert response.status_code == 200
    assert response.json()["recipes"][0]["name"] == "Chicken Salad"


def test_generate_recipe_returns_200_and_recipe() -> None:
    app.dependency_overrides[get_recipe_service] = lambda: FakeRecipeService()
    response = client.post(
        "/api/v1/recipes/generate",
        json={
            "prompt": "High protein breakfast",
            "preferences": {"diet_type": "regular"},
            "nutrition_target": {"calories": 400, "protein_g": 30, "fat_g": 15, "carbs_g": 30},
        },
    )
    app.dependency_overrides.clear()

    assert response.status_code == 200
    assert response.json()["recipe"]["name"] == "Protein Omelette"
