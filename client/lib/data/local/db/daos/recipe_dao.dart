part of '../app_database.dart';

@DriftAccessor(tables: [Recipes, Ingredients])
class RecipeDao extends DatabaseAccessor<AppDatabase> with _$RecipeDaoMixin {
  RecipeDao(super.db);

  Future<int> insertRecipe(RecipesCompanion row) => into(recipes).insert(row);

  Future<RecipeEntry?> getRecipeById(int id) =>
      (select(recipes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<RecipeEntry>> getAllRecipes() => select(recipes).get();

  Future<bool> updateRecipe(RecipeEntry row) => update(recipes).replace(row);

  Future<int> deleteRecipe(int id) =>
      (delete(recipes)..where((t) => t.id.equals(id))).go();

  Future<int> insertIngredient(IngredientsCompanion row) =>
      into(ingredients).insert(row);

  Future<IngredientEntry?> getIngredientById(int id) =>
      (select(ingredients)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<IngredientEntry>> getAllIngredients() => select(ingredients).get();

  Future<bool> updateIngredient(IngredientEntry row) =>
      update(ingredients).replace(row);

  Future<int> deleteIngredient(int id) =>
      (delete(ingredients)..where((t) => t.id.equals(id))).go();
}
