import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/repository/recipe_repository.dart';
import 'package:client/domain/bloc/recipe/recipe_bloc.dart';
import 'package:client/domain/bloc/recipe/recipe_event.dart';
import 'package:client/domain/bloc/recipe/recipe_state.dart';
import 'package:client/domain/models/cooking_step.dart';
import 'package:client/domain/models/enums/difficulty.dart';
import 'package:client/domain/models/ingredient.dart';
import 'package:client/domain/models/recipe.dart';

class _FakeRecipeRepository implements RecipeRepositoryBase {
  final List<Recipe> _items = [
    const Recipe(
      id: 1,
      title: 'Омлет',
      cookingTimeMinutes: 10,
      difficulty: Difficulty.easy,
      servings: 1,
      calories: 300,
      proteinG: 20,
      fatG: 18,
      carbsG: 8,
      isFavorite: false,
      steps: [CookingStep(order: 1, instruction: 'Взбейте яйца')],
    ),
  ];

  @override
  Future<List<Recipe>> suggestRecipes({
    required String query,
    required Map<String, dynamic> filters,
    required List<Map<String, dynamic>> fridgeProducts,
  }) async {
    return _items;
  }

  @override
  Future<Recipe> generateRecipe({
    required String prompt,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> nutritionTarget,
  }) async {
    return _items.first;
  }

  @override
  Future<List<Recipe>> getFavorites() async =>
      _items.where((e) => e.isFavorite).toList();

  @override
  Future<void> toggleFavorite(int recipeId) async {
    final index = _items.indexWhere((e) => e.id == recipeId);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(isFavorite: !_items[index].isFavorite);
  }

  @override
  Future<Recipe?> getRecipeById(int id) async {
    final index = _items.indexWhere((e) => e.id == id);
    return index == -1 ? null : _items[index];
  }

  @override
  Future<List<Ingredient>> getIngredientsByRecipeId(int recipeId) async => const [];
}

void main() {
  blocTest<RecipeBloc, RecipeState>(
    'RecipeSearchRequested emits loading then results',
    build: () => RecipeBloc(repository: _FakeRecipeRepository()),
    act: (bloc) => bloc.add(
      const RecipeSearchRequested(query: 'омлет', filters: {}),
    ),
    expect: () => [
      isA<RecipeLoading>(),
      isA<RecipeResults>(),
    ],
  );

  blocTest<RecipeBloc, RecipeState>(
    'RecipeFavoriteToggled updates favorites list',
    build: () => RecipeBloc(repository: _FakeRecipeRepository()),
    act: (bloc) async {
      bloc.add(const RecipeFavoriteToggled(1));
      bloc.add(const RecipeFavoritesRequested());
    },
    expect: () => [
      isA<RecipeFavorites>(),
    ],
  );
}
