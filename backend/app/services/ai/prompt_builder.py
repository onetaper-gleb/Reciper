import json
from typing import Any

from pydantic import BaseModel

from app.services.ai.prompt_loader import PromptLoader


class PromptBuilder:
    def __init__(self, loader: PromptLoader | None = None) -> None:
        self.loader = loader or PromptLoader()

    def build_meal_plan_prompt(
        self,
        profile: dict[str, Any],
        preferences: dict[str, Any],
        plan_options: dict[str, Any],
        fridge_products: list[Any],
        notes: str | None,
    ) -> tuple[str, str]:
        system = self.loader.load("meal_plan/system.txt")
        user = self.loader.load(
            "meal_plan/generate.txt",
            profile=self._as_json(profile),
            preferences=self._as_json(preferences),
            plan_options=self._as_json(plan_options),
            fridge_products=self._as_json(fridge_products),
            notes=notes or "",
        )
        return system, user

    def build_replace_meal_prompt(
        self,
        current_meal: dict[str, Any],
        reason: str,
        day_context: dict[str, Any],
        preferences: dict[str, Any],
        fridge: list[Any],
    ) -> tuple[str, str]:
        system = self.loader.load("meal_plan/system.txt")
        user = self.loader.load(
            "meal_plan/replace_meal.txt",
            current_meal=self._as_json(current_meal),
            reason=reason,
            day_context=self._as_json(day_context),
            preferences=self._as_json(preferences),
            fridge_products=self._as_json(fridge),
        )
        return system, user

    def build_fridge_scan_prompt(self, existing_products: list[Any]) -> tuple[str, str]:
        system = self.loader.load("meal_plan/system.txt")
        user = self.loader.load(
            "fridge/scan.txt",
            existing_products=self._as_json(existing_products),
        )
        return system, user

    def build_recipe_suggest_prompt(
        self,
        query: str,
        filters: dict[str, Any],
        fridge_products: list[Any],
    ) -> tuple[str, str]:
        system = self.loader.load("recipes/system.txt")
        user = self.loader.load(
            "recipes/suggest.txt",
            query=query,
            filters=self._as_json(filters),
            fridge_products=self._as_json(fridge_products),
        )
        return system, user

    def build_recipe_generate_prompt(
        self,
        prompt: str,
        preferences: dict[str, Any],
        nutrition_target: dict[str, Any] | None,
    ) -> tuple[str, str]:
        system = self.loader.load("recipes/system.txt")
        user = self.loader.load(
            "recipes/generate.txt",
            prompt=prompt,
            preferences=self._as_json(preferences),
            nutrition_target=self._as_json(nutrition_target or {}),
        )
        return system, user

    @staticmethod
    def _as_json(value: Any) -> str:
        def _default(obj: Any) -> Any:
            if isinstance(obj, BaseModel):
                return obj.model_dump()
            raise TypeError(f"Object of type {obj.__class__.__name__} is not JSON serializable")

        return json.dumps(value, ensure_ascii=False, indent=2, default=_default)

