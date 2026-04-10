from pathlib import Path
import sys

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

from app.services.ai.prompt_loader import PromptLoader  # noqa: E402


def test_prompt_loader_does_not_fail_on_unbound_braces() -> None:
    loader = PromptLoader(prompts_root=PROJECT_ROOT / "prompts")

    text = loader.load(
        "meal_plan/replace_meal.txt",
        current_meal="{}",
        reason="test",
        day_context="{}",
        preferences="{}",
        fridge_products="[]",
    )

    assert "Response shape MUST be exactly" in text


def test_prompts_enforce_russian_user_facing_text() -> None:
    loader = PromptLoader(prompts_root=PROJECT_ROOT / "prompts")
    system = loader.load("meal_plan/system.txt")
    fridge = loader.load("fridge/scan.txt", existing_products="[]")
    suggest = loader.load("recipes/suggest.txt", query="q", filters="{}", fridge_products="[]")
    generate = loader.load("recipes/generate.txt", prompt="p", preferences="{}", nutrition_target="{}")

    assert "Russian" in system
    assert "Russian" in fridge
    assert "Russian" in suggest
    assert "Russian" in generate

