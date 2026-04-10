import 'package:client/domain/models/cooking_step.dart';
import 'package:client/domain/models/enums/difficulty.dart';
import 'package:client/domain/models/ingredient.dart';
import 'package:client/domain/models/recipe.dart';

import 'package:client/core/utils/client_request_clock.dart';

import '../api/reciper_api.dart';

abstract class RecipeRemoteSource {
  Future<List<RemoteRecipePayload>> suggestRecipes({
    required String query,
    required Map<String, dynamic> filters,
    required List<Map<String, dynamic>> fridgeProducts,
  });

  Future<RemoteRecipePayload> generateRecipe({
    required String prompt,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> nutritionTarget,
  });
}

class RemoteRecipePayload {
  const RemoteRecipePayload({
    required this.recipe,
    required this.ingredients,
  });

  final Recipe recipe;
  final List<Ingredient> ingredients;
}

class RecipeRemoteSourceImpl implements RecipeRemoteSource {
  RecipeRemoteSourceImpl(this._api);
  final ReciperApi _api;

  @override
  Future<List<RemoteRecipePayload>> suggestRecipes({
    required String query,
    required Map<String, dynamic> filters,
    required List<Map<String, dynamic>> fridgeProducts,
  }) async {
    final data = await _api.suggestRecipes({
      'query': query,
      'filters': filters,
      'fridge_products': fridgeProducts,
      'client_context': ClientRequestClock.clientContextJson(),
    });
    final raw = (data['recipes'] as List?) ?? const [];
    return raw
        .whereType<Map>()
        .map((e) => _toPayload(e.cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<RemoteRecipePayload> generateRecipe({
    required String prompt,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> nutritionTarget,
  }) async {
    final data = await _api.generateRecipe({
      'prompt': prompt,
      'preferences': preferences,
      'nutrition_target': nutritionTarget,
      'client_context': ClientRequestClock.clientContextJson(),
    });
    final recipe = (data['recipe'] as Map?)?.cast<String, dynamic>() ?? const {};
    return _toPayload(recipe);
  }

  RemoteRecipePayload _toPayload(Map<String, dynamic> json) {
    final nutrition = (json['nutrition'] as Map?)?.cast<String, dynamic>() ?? const {};
    final stepsRaw = (json['steps'] as List?) ?? const [];
    final ingredientsRaw = (json['ingredients'] as List?) ?? const [];
    final steps = <CookingStep>[];
    for (var i = 0; i < stepsRaw.length; i++) {
      final item = stepsRaw[i];
      if (item is Map) {
        final map = item.cast<String, dynamic>();
        final instruction =
            map['instruction']?.toString() ?? map['description']?.toString() ?? '';
        steps.add(
          CookingStep(
            order: (map['order'] as num?)?.toInt() ?? (i + 1),
            instruction: instruction,
            durationSeconds: (map['duration_seconds'] as num?)?.toInt() ??
                (map['timer_seconds'] as num?)?.toInt(),
          ),
        );
      } else {
        steps.add(CookingStep(order: i + 1, instruction: item.toString()));
      }
    }

    final recipe = Recipe(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? json['name']?.toString() ?? 'Рецепт',
      cookingTimeMinutes: (json['cooking_time_min'] as num?)?.toInt() ??
          (json['cooking_time_minutes'] as num?)?.toInt() ??
          15,
      difficulty: _parseDifficulty(json['difficulty']?.toString()),
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      calories: (nutrition['calories'] as num?)?.toDouble() ??
          (json['calories'] as num?)?.toDouble() ??
          0,
      proteinG: (nutrition['protein_g'] as num?)?.toDouble() ??
          (json['protein_g'] as num?)?.toDouble() ??
          0,
      fatG:
          (nutrition['fat_g'] as num?)?.toDouble() ?? (json['fat_g'] as num?)?.toDouble() ?? 0,
      carbsG: (nutrition['carbs_g'] as num?)?.toDouble() ??
          (json['carbs_g'] as num?)?.toDouble() ??
          0,
      isFavorite: false,
      steps: steps,
    );
    final ingredients = <Ingredient>[];
    for (var i = 0; i < ingredientsRaw.length; i++) {
      final item = ingredientsRaw[i];
      if (item is! Map) continue;
      final map = item.cast<String, dynamic>();
      ingredients.add(
        Ingredient(
          id: -(i + 1),
          recipeId: 0,
          name: map['name']?.toString() ?? 'Ингредиент',
          amount: (map['amount'] as num?)?.toDouble() ?? 0,
          unit: map['unit']?.toString() ?? 'шт',
          category: map['category']?.toString() ?? 'other',
        ),
      );
    }
    return RemoteRecipePayload(recipe: recipe, ingredients: ingredients);
  }

  Difficulty _parseDifficulty(String? raw) {
    final value = raw?.toLowerCase() ?? '';
    if (value.contains('hard') || value.contains('слож')) return Difficulty.hard;
    if (value.contains('medium') || value.contains('сред')) return Difficulty.medium;
    return Difficulty.easy;
  }
}
