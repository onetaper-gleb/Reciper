from datetime import datetime, timezone
from pathlib import Path
import sys

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

from app.schemas.common import ClientContextSchema  # noqa: E402
from app.schemas.fridge import RecognizedProductSchema  # noqa: E402
from app.services.ai.prompt_builder import PromptBuilder  # noqa: E402
from app.services.ai.prompt_loader import PromptLoader  # noqa: E402


def test_build_meal_plan_prompt_contains_user_fields() -> None:
    loader = PromptLoader(prompts_root=PROJECT_ROOT / "prompts")
    builder = PromptBuilder(loader=loader)

    system_prompt, user_prompt = builder.build_meal_plan_prompt(
        profile={"age": 25, "gender": "male", "goal": "weight_loss"},
        preferences={"allergies": ["nuts"], "diet_type": "regular"},
        plan_options={"days": 7, "meals_per_day": 5},
        fridge_products=["chicken", "rice"],
        notes="No spicy food",
    )

    assert "JSON" in system_prompt
    assert "25" in user_prompt
    assert "male" in user_prompt
    assert "weight_loss" in user_prompt
    assert "nuts" in user_prompt
    assert "7" in user_prompt
    assert "chicken" in user_prompt
    assert "No spicy food" in user_prompt
    assert "Client context" in user_prompt or "Клиент не передал" in user_prompt


def test_build_replace_and_recipe_prompts_include_inputs() -> None:
    loader = PromptLoader(prompts_root=PROJECT_ROOT / "prompts")
    builder = PromptBuilder(loader=loader)

    _, replace_prompt = builder.build_replace_meal_prompt(
        current_meal={"name": "Omelette", "calories": 450},
        reason="no_ingredients",
        day_context={"remaining_calories": 1200},
        preferences={"allergies": ["lactose"]},
        fridge=["eggs"],
    )
    _, recipe_prompt = builder.build_recipe_suggest_prompt(
        query="quick dinner",
        filters={"max_cooking_time_min": 20},
        fridge_products=["tomato", "pasta"],
    )

    assert "Omelette" in replace_prompt
    assert "no_ingredients" in replace_prompt
    assert "remaining_calories" in replace_prompt
    assert "quick dinner" in recipe_prompt
    assert "20" in recipe_prompt
    assert "pasta" in recipe_prompt


def test_build_fridge_and_recipe_generate_prompts_include_payload() -> None:
    loader = PromptLoader(prompts_root=PROJECT_ROOT / "prompts")
    builder = PromptBuilder(loader=loader)

    _, fridge_prompt = builder.build_fridge_scan_prompt(
        existing_products=[{"name": "Яйца", "amount": 4, "unit": "шт"}]
    )
    _, recipe_generate_prompt = builder.build_recipe_generate_prompt(
        prompt="Белковый завтрак",
        preferences={"diet_type": "regular"},
        nutrition_target={"calories": 400, "protein_g": 30},
    )

    assert "Яйца" in fridge_prompt
    assert "Белковый завтрак" in recipe_generate_prompt
    assert "protein_g" in recipe_generate_prompt


def test_build_fridge_prompt_serializes_pydantic_models() -> None:
    loader = PromptLoader(prompts_root=PROJECT_ROOT / "prompts")
    builder = PromptBuilder(loader=loader)

    _, fridge_prompt = builder.build_fridge_scan_prompt(
        existing_products=[
            RecognizedProductSchema(name="Яйца", amount=4, unit="шт", confidence=0.9),
        ]
    )

    assert "Яйца" in fridge_prompt
    assert "confidence" in fridge_prompt


def test_client_context_appears_in_prompts_when_provided() -> None:
    loader = PromptLoader(prompts_root=PROJECT_ROOT / "prompts")
    builder = PromptBuilder(loader=loader)
    ctx = ClientContextSchema(local_datetime=datetime(2026, 4, 10, 12, 0, tzinfo=timezone.utc))

    _, user_meal = builder.build_meal_plan_prompt(
        profile={"age": 30},
        preferences={},
        plan_options={"days": 1},
        fridge_products=[],
        notes="",
        client_context=ctx,
    )
    assert "2026-04-10" in user_meal

