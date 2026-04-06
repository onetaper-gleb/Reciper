from pydantic import BaseModel


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

