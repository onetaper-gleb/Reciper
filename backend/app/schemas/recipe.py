from pydantic import BaseModel, Field

from app.schemas.common import ClientContextSchema, NutritionSchema
from app.schemas.meal_plan import FridgeProductSchema, PreferencesSchema, RecipeSchema


class RecipeSuggestionRequest(BaseModel):
    query: str
    filters: dict = Field(default_factory=dict)
    fridge_products: list[FridgeProductSchema] = Field(default_factory=list)
    client_context: ClientContextSchema | None = None


class RecipeSuggestionResponse(BaseModel):
    recipes: list[RecipeSchema] = Field(default_factory=list)


class GenerateRecipeRequest(BaseModel):
    prompt: str
    preferences: PreferencesSchema = Field(default_factory=PreferencesSchema)
    nutrition_target: NutritionSchema | None = None
    client_context: ClientContextSchema | None = None


class GenerateRecipeResponse(BaseModel):
    recipe: RecipeSchema
