import 'dart:convert';

import 'package:drift/drift.dart';

import '../local/db/app_database.dart';
import '../local/db/db_enums.dart';
import '../remote/source/meal_plan_remote_source.dart';
import '../../domain/models/enums/goal.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/day_plan.dart';
import '../../domain/models/meal.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/ingredient.dart';

class StoredMealPlanGraph {
  const StoredMealPlanGraph({
    required this.mealPlan,
    required this.days,
    required this.meals,
    required this.recipes,
    required this.ingredients,
  });

  final MealPlan mealPlan;
  final List<DayPlan> days;
  final List<Meal> meals;
  final List<Recipe> recipes;
  final List<Ingredient> ingredients;
}

class MealPlanRepository {
  MealPlanRepository({
    required AppDatabase database,
    required MealPlanRemoteSource remoteSource,
  })  : _db = database,
        _remote = remoteSource;

  final AppDatabase _db;
  final MealPlanRemoteSource _remote;

  Future<StoredMealPlanGraph> generatePlan({
    required Map<String, dynamic> profileJson,
    required Map<String, dynamic> preferencesJson,
    required Map<String, dynamic> planOptionsJson,
    required List<Map<String, dynamic>> fridgeProductsJson,
    String? additionalNotes,
  }) async {
    final generated = await _remote.generatePlan(
      profileJson: profileJson,
      preferencesJson: preferencesJson,
      planOptionsJson: planOptionsJson,
      fridgeProductsJson: fridgeProductsJson,
      additionalNotes: additionalNotes,
    );

    // Mark all existing plans inactive (simple approach for MVP).
    final existing = await _db.mealPlanDao.getAllMealPlans();
    for (final row in existing.where((e) => e.isActive)) {
      await _db.mealPlanDao.updateMealPlan(row.copyWith(isActive: false));
    }

    final mealPlanId = await _db.mealPlanDao.insertMealPlan(
      MealPlansCompanion.insert(
        startDate: generated.startDate,
        endDate: generated.endDate,
        goal: _toDbGoal(generated.goal),
        isActive: const Value(true),
        createdAt: DateTime.now().toUtc(),
      ),
    );

    final List<DayPlan> dayModels = [];
    final List<Meal> mealModels = [];
    final List<Recipe> recipeModels = [];
    final List<Ingredient> ingredientModels = [];

    for (final day in generated.days) {
      final dayId = await _db.mealPlanDao.insertDayPlan(
        DayPlansCompanion.insert(mealPlanId: mealPlanId, planDate: day.date),
      );
      dayModels.add(DayPlan(id: dayId, mealPlanId: mealPlanId, date: day.date));

      for (final gm in day.meals) {
        final recipe = gm.recipe;
        final recipeId = await _db.recipeDao.insertRecipe(
          RecipesCompanion.insert(
            title: recipe.title,
            cookingTimeMinutes: recipe.cookingTimeMinutes,
            difficulty: _toDbDifficulty(recipe.difficulty),
            servings: recipe.servings,
            calories: recipe.calories,
            proteinG: recipe.proteinG,
            fatG: recipe.fatG,
            carbsG: recipe.carbsG,
            isFavorite: const Value(false),
            stepsJson: jsonEncode(
              recipe.steps.map((s) => s.toJson()).toList(),
            ),
          ),
        );

        recipeModels.add(recipe.copyWith(id: recipeId));

        for (final ing in gm.ingredients) {
          final ingId = await _db.recipeDao.insertIngredient(
            IngredientsCompanion.insert(
              recipeId: recipeId,
              name: ing.name,
              amount: ing.amount,
              unit: ing.unit,
              category: ing.category,
            ),
          );
          ingredientModels.add(
            ing.copyWith(id: ingId, recipeId: recipeId),
          );
        }

        final mealId = await _db.mealPlanDao.insertMeal(
          MealsCompanion.insert(
            dayPlanId: dayId,
            mealType: _toDbMealType(gm.mealType),
            mealTime: _defaultMealTime(day.date, gm.mealType),
            recipeId: recipeId,
            isDone: const Value(false),
          ),
        );

        mealModels.add(
          Meal(
            id: mealId,
            dayPlanId: dayId,
            mealType: gm.mealType,
            mealTime: _defaultMealTime(day.date, gm.mealType),
            recipeId: recipeId,
            isDone: false,
          ),
        );
      }
    }

    final plan = MealPlan(
      id: mealPlanId,
      startDate: generated.startDate,
      endDate: generated.endDate,
      goal: generated.goal,
      isActive: true,
      createdAt: DateTime.now().toUtc(),
    );

    return StoredMealPlanGraph(
      mealPlan: plan,
      days: dayModels,
      meals: mealModels,
      recipes: recipeModels,
      ingredients: ingredientModels,
    );
  }

  Future<StoredMealPlanGraph?> getActivePlan() async {
    final plans = await _db.mealPlanDao.getAllMealPlans();
    final active = plans.where((p) => p.isActive).toList();
    if (active.isEmpty) return null;

    final planRow = active.first;
    final plan = MealPlan(
      id: planRow.id,
      startDate: planRow.startDate,
      endDate: planRow.endDate,
      goal: _fromDbGoal(planRow.goal),
      isActive: planRow.isActive,
      createdAt: planRow.createdAt,
    );

    // Minimal MVP: return plan only (graph can be loaded later).
    return StoredMealPlanGraph(
      mealPlan: plan,
      days: const [],
      meals: const [],
      recipes: const [],
      ingredients: const [],
    );
  }

  DbGoal _toDbGoal(Goal goal) => switch (goal) {
        Goal.loseWeight => DbGoal.loseWeight,
        Goal.maintain => DbGoal.maintain,
        Goal.gainMuscle => DbGoal.gainMuscle,
        Goal.cutting => DbGoal.cutting,
      };

  Goal _fromDbGoal(DbGoal goal) => switch (goal) {
        DbGoal.loseWeight => Goal.loseWeight,
        DbGoal.maintain => Goal.maintain,
        DbGoal.gainMuscle => Goal.gainMuscle,
        DbGoal.cutting => Goal.cutting,
      };

  DbDifficulty _toDbDifficulty(dynamic difficulty) {
    // Domain difficulty is enum Difficulty; keep dynamic to avoid extra imports here.
    final name = difficulty.toString();
    if (name.contains('medium')) return DbDifficulty.medium;
    if (name.contains('hard')) return DbDifficulty.hard;
    return DbDifficulty.easy;
  }

  DbMealType _toDbMealType(dynamic mealType) {
    final name = mealType.toString();
    if (name.contains('lunch')) return DbMealType.lunch;
    if (name.contains('dinner')) return DbMealType.dinner;
    if (name.contains('snack')) return DbMealType.snack;
    return DbMealType.breakfast;
  }

  DateTime _defaultMealTime(DateTime day, dynamic mealType) {
    final base = DateTime.utc(day.year, day.month, day.day);
    final name = mealType.toString();
    if (name.contains('lunch')) return base.add(const Duration(hours: 13));
    if (name.contains('dinner')) return base.add(const Duration(hours: 19));
    if (name.contains('snack')) return base.add(const Duration(hours: 16));
    return base.add(const Duration(hours: 8));
  }
}

