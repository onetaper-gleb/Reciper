from pathlib import Path
import sys

from fastapi.testclient import TestClient

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

from app.core.exceptions import AIServiceError  # noqa: E402
from app.core.exceptions import ValidationError  # noqa: E402
from app.main import app  # noqa: E402
from app.api.v1.endpoints.meal_plans import get_meal_plan_service  # noqa: E402
from app.services.ai.gemini_client import GeminiTimeoutError  # noqa: E402


class FakeMealPlanService:
    def __init__(self, mode: str = "ok") -> None:
        self.mode = mode

    def generate_plan(self, request):  # noqa: ANN001
        if self.mode == "ai_error":
            raise AIServiceError("AI service unavailable")
        if self.mode == "validation":
            raise ValidationError("bad output")
        if self.mode == "timeout":
            raise GeminiTimeoutError("timeout")
        return {
            "plan": {
                "start_date": "2026-04-06",
                "end_date": "2026-04-12",
                "days": [
                    {
                        "date": "2026-04-06",
                        "meals": [
                            {
                                "meal_type": "breakfast",
                                "recipe": {
                                    "name": "Omelette",
                                    "cooking_time_min": 10,
                                    "nutrition": {
                                        "calories": 400,
                                        "protein_g": 20,
                                        "fat_g": 20,
                                        "carbs_g": 30,
                                    },
                                    "ingredients": [{"name": "Eggs", "amount": 2, "unit": "pcs"}],
                                    "steps": [{"order": 1, "description": "Cook eggs"}],
                                },
                            }
                        ],
                    }
                ],
            },
            "weekly_summary": {
                "avg_calories": 400,
                "avg_protein_g": 20,
                "avg_fat_g": 20,
                "avg_carbs_g": 30,
            },
        }

    def replace_meal(self, request):  # noqa: ANN001
        if self.mode == "ai_error":
            raise AIServiceError("AI service unavailable")
        if self.mode == "timeout":
            raise GeminiTimeoutError("timeout")
        return {
            "recipe": {
                "name": "Toast with eggs",
                "cooking_time_min": 8,
                "nutrition": {
                    "calories": 360,
                    "protein_g": 18,
                    "fat_g": 16,
                    "carbs_g": 35,
                },
                "ingredients": [{"name": "Bread", "amount": 2, "unit": "slice"}],
                "steps": [{"order": 1, "description": "Toast and serve"}],
            }
        }


client = TestClient(app)

VALID_GENERATE_PAYLOAD = {
    "profile": {
        "gender": "male",
        "age": 25,
        "height_cm": 178,
        "weight_kg": 82,
        "target_weight_kg": 75,
        "goal": "weight_loss",
        "activity_level": "moderate",
    },
    "preferences": {
        "diet_type": "regular",
        "allergies": ["lactose_free"],
        "disliked_products": ["broccoli"],
        "favorite_products": ["chicken", "rice"],
        "max_cooking_time_min": 30,
        "budget_level": "medium",
    },
    "plan_options": {"days": 7, "meals_per_day": 5, "cook_when": "evening", "use_fridge_products": True},
    "fridge_products": [{"name": "chicken breast", "amount": 500, "unit": "g"}],
    "additional_notes": "No spicy food",
}

VALID_REPLACE_PAYLOAD = {
    "meal_type": "breakfast",
    "current_recipe": {"name": "Oatmeal", "calories": 380},
    "reason": "too_long_to_cook",
    "additional_info": "Need faster",
    "day_context": {
        "remaining_calories": 1770,
        "remaining_protein_g": 138,
        "remaining_fat_g": 62,
        "remaining_carbs_g": 175,
    },
    "preferences": {"disliked_products": ["oatmeal"], "max_cooking_time_min": 15},
    "fridge_products": [{"name": "eggs", "amount": 4, "unit": "pcs"}],
}


def test_generate_meal_plan_returns_200_and_structure() -> None:
    app.dependency_overrides[get_meal_plan_service] = lambda: FakeMealPlanService("ok")
    response = client.post("/api/v1/meal-plans/generate", json=VALID_GENERATE_PAYLOAD)
    app.dependency_overrides.clear()

    assert response.status_code == 200
    body = response.json()
    assert "plan" in body
    assert "days" in body["plan"]
    assert body["plan"]["days"][0]["meals"][0]["recipe"]["name"] == "Omelette"


def test_replace_meal_returns_200_and_structure() -> None:
    app.dependency_overrides[get_meal_plan_service] = lambda: FakeMealPlanService("ok")
    response = client.post("/api/v1/meal-plans/replace-meal", json=VALID_REPLACE_PAYLOAD)
    app.dependency_overrides.clear()

    assert response.status_code == 200
    assert response.json()["recipe"]["name"] == "Toast with eggs"


def test_generate_meal_plan_invalid_body_returns_422() -> None:
    response = client.post("/api/v1/meal-plans/generate", json={"profile": {}})
    assert response.status_code == 422


def test_generate_meal_plan_ai_error_returns_502() -> None:
    app.dependency_overrides[get_meal_plan_service] = lambda: FakeMealPlanService("ai_error")
    response = client.post("/api/v1/meal-plans/generate", json=VALID_GENERATE_PAYLOAD)
    app.dependency_overrides.clear()
    assert response.status_code == 502


def test_generate_meal_plan_timeout_returns_504() -> None:
    app.dependency_overrides[get_meal_plan_service] = lambda: FakeMealPlanService("timeout")
    response = client.post("/api/v1/meal-plans/generate", json=VALID_GENERATE_PAYLOAD)
    app.dependency_overrides.clear()
    assert response.status_code == 504


def test_generate_meal_plan_validation_error_returns_422() -> None:
    app.dependency_overrides[get_meal_plan_service] = lambda: FakeMealPlanService("validation")
    response = client.post("/api/v1/meal-plans/generate", json=VALID_GENERATE_PAYLOAD)
    app.dependency_overrides.clear()
    assert response.status_code == 422

