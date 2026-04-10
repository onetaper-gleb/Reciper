from pydantic import BaseModel, Field

from app.schemas.common import ClientContextSchema, CookingStepSchema, IngredientSchema, NutritionSchema


class ProfileSchema(BaseModel):
    gender: str
    age: int
    height_cm: float
    weight_kg: float
    target_weight_kg: float | None = None
    goal: str
    activity_level: str


class PreferencesSchema(BaseModel):
    diet_type: str | None = None
    allergies: list[str] = Field(default_factory=list)
    disliked_products: list[str] = Field(default_factory=list)
    favorite_products: list[str] = Field(default_factory=list)
    max_cooking_time_min: int | None = None
    budget_level: str | None = None


class PlanOptionsSchema(BaseModel):
    days: int = 7
    meals_per_day: int = 5
    cook_when: str | None = None
    use_fridge_products: bool = True
    start_date: str | None = Field(
        default=None,
        description="First calendar day of the plan (YYYY-MM-DD) in the user's local timezone.",
    )


class FridgeProductSchema(BaseModel):
    name: str
    amount: float | None = None
    unit: str | None = None


class RecipeSchema(BaseModel):
    name: str
    cooking_time_min: int
    nutrition: NutritionSchema
    ingredients: list[IngredientSchema] = Field(default_factory=list)
    steps: list[CookingStepSchema] = Field(default_factory=list)


class MealSchema(BaseModel):
    meal_type: str
    recipe: RecipeSchema


class DayPlanSchema(BaseModel):
    date: str
    meals: list[MealSchema] = Field(default_factory=list)


class PlanSchema(BaseModel):
    start_date: str
    end_date: str
    days: list[DayPlanSchema] = Field(default_factory=list)


class WeeklySummarySchema(BaseModel):
    avg_calories: float
    avg_protein_g: float
    avg_fat_g: float
    avg_carbs_g: float


class GeneratePlanRequest(BaseModel):
    profile: ProfileSchema
    preferences: PreferencesSchema
    plan_options: PlanOptionsSchema
    fridge_products: list[FridgeProductSchema] = Field(default_factory=list)
    additional_notes: str | None = None
    client_context: ClientContextSchema | None = None


class GeneratePlanResponse(BaseModel):
    plan: PlanSchema
    weekly_summary: WeeklySummarySchema


class CurrentRecipeSummarySchema(BaseModel):
    name: str
    calories: float | None = None


class DayContextSchema(BaseModel):
    remaining_calories: float
    remaining_protein_g: float | None = None
    remaining_fat_g: float | None = None
    remaining_carbs_g: float | None = None


class ReplaceMealRequest(BaseModel):
    meal_type: str
    current_recipe: CurrentRecipeSummarySchema
    reason: str
    additional_info: str | None = None
    day_context: DayContextSchema
    preferences: PreferencesSchema
    fridge_products: list[FridgeProductSchema] = Field(default_factory=list)
    client_context: ClientContextSchema | None = None


class ReplaceMealResponse(BaseModel):
    recipe: RecipeSchema

