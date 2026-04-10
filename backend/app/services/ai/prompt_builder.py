import json
from typing import Any

from pydantic import BaseModel

from app.schemas.common import ClientContextSchema
from app.services.ai.prompt_loader import PromptLoader


class PromptBuilder:
    def __init__(self, loader: PromptLoader | None = None) -> None:
        self.loader = loader or PromptLoader()

    @staticmethod
    def format_client_context(client_context: ClientContextSchema | None) -> str:
        if client_context is None:
            return (
                "Клиент не передал client_context.local_datetime. "
                "Интерпретируй относительные формулировки («сегодня», «завтра») нейтрально."
            )
        return (
            "Локальные дата и время на устройстве пользователя (учитывай часовой пояс): "
            f"{client_context.local_datetime.isoformat()}"
        )

    def build_meal_plan_prompt(
        self,
        profile: dict[str, Any],
        preferences: dict[str, Any],
        plan_options: dict[str, Any],
        fridge_products: list[Any],
        notes: str | None,
        client_context: ClientContextSchema | None = None,
    ) -> tuple[str, str]:
        system = self.loader.load("meal_plan/system.txt")
        user = self.loader.load(
            "meal_plan/generate.txt",
            client_context=self.format_client_context(client_context),
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
        client_context: ClientContextSchema | None = None,
    ) -> tuple[str, str]:
        system = self.loader.load("meal_plan/system.txt")
        user = self.loader.load(
            "meal_plan/replace_meal.txt",
            client_context=self.format_client_context(client_context),
            current_meal=self._as_json(current_meal),
            reason=reason,
            day_context=self._as_json(day_context),
            preferences=self._as_json(preferences),
            fridge_products=self._as_json(fridge),
        )
        return system, user

    def build_fridge_scan_prompt(
        self,
        existing_products: list[Any],
        client_context: ClientContextSchema | None = None,
    ) -> tuple[str, str]:
        system = self.loader.load("meal_plan/system.txt")
        user = self.loader.load(
            "fridge/scan.txt",
            client_context=self.format_client_context(client_context),
            existing_products=self._as_json(existing_products),
        )
        return system, user

    def build_recipe_suggest_prompt(
        self,
        query: str,
        filters: dict[str, Any],
        fridge_products: list[Any],
        client_context: ClientContextSchema | None = None,
    ) -> tuple[str, str]:
        system = self.loader.load("recipes/system.txt")
        user = self.loader.load(
            "recipes/suggest.txt",
            client_context=self.format_client_context(client_context),
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
        client_context: ClientContextSchema | None = None,
    ) -> tuple[str, str]:
        system = self.loader.load("recipes/system.txt")
        user = self.loader.load(
            "recipes/generate.txt",
            client_context=self.format_client_context(client_context),
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

