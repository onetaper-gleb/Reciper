import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/cooking_step.dart';
import '../../domain/models/enums/difficulty.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/recipe.dart';
import '../local/db/app_database.dart';
import '../local/db/db_enums.dart';
import '../remote/source/recipe_remote_source.dart';

abstract class RecipeRepositoryBase {
  Future<List<Recipe>> suggestRecipes({
    required String query,
    required Map<String, dynamic> filters,
    required List<Map<String, dynamic>> fridgeProducts,
  });
  Future<Recipe> generateRecipe({
    required String prompt,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> nutritionTarget,
  });
  Future<List<Recipe>> getFavorites();
  Future<void> toggleFavorite(int recipeId);
  Future<Recipe?> getRecipeById(int id);
  Future<List<Ingredient>> getIngredientsByRecipeId(int recipeId);
}

class RecipeRepository implements RecipeRepositoryBase {
  RecipeRepository({
    required AppDatabase database,
    required RecipeRemoteSource remoteSource,
  })  : _db = database,
        _remote = remoteSource;

  final AppDatabase _db;
  final RecipeRemoteSource _remote;

  @override
  Future<List<Recipe>> suggestRecipes({
    required String query,
    required Map<String, dynamic> filters,
    required List<Map<String, dynamic>> fridgeProducts,
  }) async {
    final remoteRecipes = await _remote.suggestRecipes(
      query: query,
      filters: filters,
      fridgeProducts: fridgeProducts,
    );
    final persisted = <Recipe>[];
    for (final payload in remoteRecipes) {
      final id = await _upsertRecipe(payload.recipe);
      await _replaceIngredients(
        recipeId: id,
        ingredients: payload.ingredients,
      );
      persisted.add(payload.recipe.copyWith(id: id));
    }
    return persisted;
  }

  @override
  Future<Recipe> generateRecipe({
    required String prompt,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> nutritionTarget,
  }) async {
    final payload = await _remote.generateRecipe(
      prompt: prompt,
      preferences: preferences,
      nutritionTarget: nutritionTarget,
    );
    final id = await _upsertRecipe(payload.recipe);
    await _replaceIngredients(recipeId: id, ingredients: payload.ingredients);
    return payload.recipe.copyWith(id: id);
  }

  @override
  Future<List<Recipe>> getFavorites() async {
    final rows = await _db.recipeDao.getAllRecipes();
    return rows.where((e) => e.isFavorite).map(_mapRecipe).toList();
  }

  @override
  Future<void> toggleFavorite(int recipeId) async {
    final row = await _db.recipeDao.getRecipeById(recipeId);
    if (row == null) return;
    await _db.recipeDao.updateRecipe(row.copyWith(isFavorite: !row.isFavorite));
  }

  @override
  Future<Recipe?> getRecipeById(int id) async {
    final row = await _db.recipeDao.getRecipeById(id);
    if (row == null) return null;
    return _mapRecipe(row);
  }

  @override
  Future<List<Ingredient>> getIngredientsByRecipeId(int recipeId) async {
    final rows = await _db.recipeDao.getAllIngredients();
    return rows
        .where((e) => e.recipeId == recipeId)
        .map(
          (e) => Ingredient(
            id: e.id,
            recipeId: e.recipeId,
            name: e.name,
            amount: e.amount,
            unit: e.unit,
            category: e.category,
          ),
        )
        .toList();
  }

  Future<int> _upsertRecipe(Recipe recipe) async {
    final rows = await _db.recipeDao.getAllRecipes();
    RecipeEntry? existing;
    for (final row in rows) {
      if (_norm(row.title) == _norm(recipe.title)) {
        existing = row;
        break;
      }
    }
    if (existing != null) {
      await _db.recipeDao.updateRecipe(
        existing.copyWith(
          title: recipe.title,
          cookingTimeMinutes: recipe.cookingTimeMinutes,
          difficulty: _toDbDifficulty(recipe.difficulty),
          servings: recipe.servings,
          calories: recipe.calories,
          proteinG: recipe.proteinG,
          fatG: recipe.fatG,
          carbsG: recipe.carbsG,
          stepsJson: jsonEncode(recipe.steps.map((e) => e.toJson()).toList()),
        ),
      );
      return existing.id;
    }
    return _db.recipeDao.insertRecipe(
      RecipesCompanion.insert(
        title: recipe.title,
        cookingTimeMinutes: recipe.cookingTimeMinutes,
        difficulty: _toDbDifficulty(recipe.difficulty),
        servings: recipe.servings,
        calories: recipe.calories,
        proteinG: recipe.proteinG,
        fatG: recipe.fatG,
        carbsG: recipe.carbsG,
        isFavorite: Value(recipe.isFavorite),
        stepsJson: jsonEncode(recipe.steps.map((e) => e.toJson()).toList()),
      ),
    );
  }

  Recipe _mapRecipe(RecipeEntry row) {
    return Recipe(
      id: row.id,
      title: row.title,
      cookingTimeMinutes: row.cookingTimeMinutes,
      difficulty: _fromDbDifficulty(row.difficulty),
      servings: row.servings,
      calories: row.calories,
      proteinG: row.proteinG,
      fatG: row.fatG,
      carbsG: row.carbsG,
      isFavorite: row.isFavorite,
      steps: _parseSteps(row.stepsJson),
    );
  }

  List<CookingStep> _parseSteps(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((e) => CookingStep.fromJson(e.cast<String, dynamic>()))
            .toList();
      }
    } catch (_) {
      return const [];
    }
    return const [];
  }

  DbDifficulty _toDbDifficulty(Difficulty value) => switch (value) {
        Difficulty.easy => DbDifficulty.easy,
        Difficulty.medium => DbDifficulty.medium,
        Difficulty.hard => DbDifficulty.hard,
      };

  Difficulty _fromDbDifficulty(DbDifficulty value) => switch (value) {
        DbDifficulty.easy => Difficulty.easy,
        DbDifficulty.medium => Difficulty.medium,
        DbDifficulty.hard => Difficulty.hard,
      };

  String _norm(String value) => value.trim().toLowerCase();

  Future<void> _replaceIngredients({
    required int recipeId,
    required List<Ingredient> ingredients,
  }) async {
    final existing = await _db.recipeDao.getAllIngredients();
    for (final row in existing.where((e) => e.recipeId == recipeId)) {
      await _db.recipeDao.deleteIngredient(row.id);
    }
    for (final item in ingredients) {
      await _db.recipeDao.insertIngredient(
        IngredientsCompanion.insert(
          recipeId: recipeId,
          name: item.name,
          amount: item.amount,
          unit: item.unit,
          category: item.category,
        ),
      );
    }
  }
}
