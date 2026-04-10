from datetime import datetime

from pydantic import BaseModel, Field


class ClientContextSchema(BaseModel):
    """Device-local wall time from the Flutter client (includes timezone offset)."""

    local_datetime: datetime = Field(
        description="ISO 8601 timestamp from the user's device, e.g. 2026-04-10T15:30:00+03:00",
    )


class NutritionSchema(BaseModel):
    calories: int
    protein_g: float
    fat_g: float
    carbs_g: float


class IngredientSchema(BaseModel):
    name: str
    amount: float
    unit: str
    category: str | None = None


class CookingStepSchema(BaseModel):
    order: int
    description: str
    timer_seconds: int | None = None

