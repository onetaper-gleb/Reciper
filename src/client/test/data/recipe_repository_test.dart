import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/repository/recipe_repository.dart';
import 'package:client/data/remote/source/recipe_remote_source.dart';
import 'package:client/domain/models/cooking_step.dart';
import 'package:client/domain/models/enums/difficulty.dart';
import 'package:client/domain/models/ingredient.dart';
import 'package:client/domain/models/recipe.dart';

class _FakeRecipeRemoteSource implements RecipeRemoteSource {
  @override
  Future<List<RemoteRecipePayload>> suggestRecipes({
    required String query,
    required Map<String, dynamic> filters,
    required List<Map<String, dynamic>> fridgeProducts,
  }) async {
    return const [
      RemoteRecipePayload(
        recipe: Recipe(
        id: 0,
        title: 'Быстрый ужин',
        cookingTimeMinutes: 15,
        difficulty: Difficulty.easy,
        servings: 2,
        calories: 450,
        proteinG: 30,
        fatG: 14,
        carbsG: 40,
        isFavorite: false,
        steps: [CookingStep(order: 1, instruction: 'Смешайте ингредиенты')],
      ),
      ingredients: [
        Ingredient(
          id: -1,
          recipeId: 0,
          name: 'Хлеб',
          amount: 2,
          unit: 'ломтика',
          category: 'other',
        ),
      ],
      ),
      RemoteRecipePayload(
        recipe: Recipe(
        id: 0,
        title: 'Курица с рисом',
        cookingTimeMinutes: 30,
        difficulty: Difficulty.medium,
        servings: 2,
        calories: 550,
        proteinG: 35,
        fatG: 18,
        carbsG: 55,
        isFavorite: false,
        steps: [CookingStep(order: 1, instruction: 'Обжарьте курицу')],
      ),
      ingredients: [],
      ),
    ];
  }

  @override
  Future<RemoteRecipePayload> generateRecipe({
    required String prompt,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> nutritionTarget,
  }) async {
    return const RemoteRecipePayload(
      recipe: Recipe(
        id: 0,
        title: 'Омлет',
        cookingTimeMinutes: 10,
        difficulty: Difficulty.easy,
        servings: 1,
        calories: 320,
        proteinG: 24,
        fatG: 20,
        carbsG: 6,
        isFavorite: false,
        steps: [CookingStep(order: 1, instruction: 'Взбейте яйца')],
      ),
      ingredients: [],
    );
  }
}

void main() {
  test('suggestRecipes stores recipes and toggleFavorite persists', () async {
    final db = AppDatabase.test();
    addTearDown(db.close);
    final repo = RecipeRepository(
      database: db,
      remoteSource: _FakeRecipeRemoteSource(),
    );

    final recipes = await repo.suggestRecipes(
      query: 'быстрый ужин',
      filters: const {'max_cooking_time_min': 30},
      fridgeProducts: const [],
    );

    expect(recipes, hasLength(2));
    expect(recipes.first.id, greaterThan(0));

    await repo.toggleFavorite(recipes.first.id);
    final favorites = await repo.getFavorites();
    expect(favorites, hasLength(1));
    expect(favorites.first.title, 'Быстрый ужин');

    final loaded = await repo.getRecipeById(recipes.first.id);
    expect(loaded?.isFavorite, isTrue);
    final ingredients = await repo.getIngredientsByRecipeId(recipes.first.id);
    expect(ingredients, isNotEmpty);
  });
}
