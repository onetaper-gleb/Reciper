import 'dart:convert';

import 'package:drift/drift.dart';

import '../local/db/app_database.dart';
import '../local/db/db_enums.dart';
import '../remote/source/meal_plan_remote_source.dart';
import '../../domain/models/cooking_step.dart';
import '../../domain/models/enums/difficulty.dart';
import '../../domain/models/enums/goal.dart';
import '../../domain/models/enums/meal_type.dart';
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
    return _loadStoredGraph(active.first);
  }

  Future<StoredMealPlanGraph?> getPlanByDate(DateTime date) async {
    final active = await getActivePlan();
    if (active == null) return null;
    final day = active.days.where((d) => _isSameDate(d.date, date)).toList();
    if (day.isEmpty) return active;
    final dayIds = day.map((e) => e.id).toSet();
    final meals = active.meals.where((m) => dayIds.contains(m.dayPlanId)).toList();
    final recipeIds = meals.map((e) => e.recipeId).toSet();
    final recipes = active.recipes.where((r) => recipeIds.contains(r.id)).toList();
    final ingredients = active.ingredients
        .where((i) => recipeIds.contains(i.recipeId))
        .toList();
    return StoredMealPlanGraph(
      mealPlan: active.mealPlan,
      days: day,
      meals: meals,
      recipes: recipes,
      ingredients: ingredients,
    );
  }

  Future<void> markMealCompleted(int mealId) async {
    final row = await _db.mealPlanDao.getMealById(mealId);
    if (row == null) return;
    await _db.mealPlanDao.updateMeal(row.copyWith(isDone: true));
  }

  Future<void> setActivePlan(int planId) async {
    final all = await _db.mealPlanDao.getAllMealPlans();
    for (final row in all) {
      final shouldBeActive = row.id == planId;
      if (row.isActive != shouldBeActive) {
        await _db.mealPlanDao.updateMealPlan(
          row.copyWith(isActive: shouldBeActive),
        );
      }
    }
  }

  Future<List<StoredMealPlanGraph>> getPlanHistory() async {
    final all = await _db.mealPlanDao.getAllMealPlans();
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final result = <StoredMealPlanGraph>[];
    for (final row in all) {
      final graph = await _loadStoredGraph(row);
      result.add(graph);
    }
    return result;
  }

  Future<void> replaceMeal({
    required int mealId,
    required Map<String, dynamic> requestJson,
  }) async {
    final meal = await _db.mealPlanDao.getMealById(mealId);
    if (meal == null) return;
    final currentRecipe = await _db.recipeDao.getRecipeById(meal.recipeId);
    if (currentRecipe == null) return;

    final generated = await _remote.replaceMeal(requestJson: requestJson);
    final newRecipeId = await _db.recipeDao.insertRecipe(
      RecipesCompanion.insert(
        title: generated.title,
        cookingTimeMinutes: currentRecipe.cookingTimeMinutes,
        difficulty: currentRecipe.difficulty,
        servings: currentRecipe.servings,
        calories: currentRecipe.calories,
        proteinG: currentRecipe.proteinG,
        fatG: currentRecipe.fatG,
        carbsG: currentRecipe.carbsG,
        isFavorite: Value(currentRecipe.isFavorite),
        stepsJson: currentRecipe.stepsJson,
      ),
    );
    await _db.mealPlanDao.updateMeal(meal.copyWith(recipeId: newRecipeId));
  }

  Future<StoredMealPlanGraph> _loadStoredGraph(MealPlanEntry planRow) async {
    final plan = MealPlan(
      id: planRow.id,
      startDate: planRow.startDate,
      endDate: planRow.endDate,
      goal: _fromDbGoal(planRow.goal),
      isActive: planRow.isActive,
      createdAt: planRow.createdAt,
    );

    final dayRows = await _db.mealPlanDao.getAllDayPlans();
    final planDayRows = dayRows.where((d) => d.mealPlanId == plan.id).toList();
    final days = planDayRows
        .map((d) => DayPlan(id: d.id, mealPlanId: d.mealPlanId, date: d.planDate))
        .toList();

    final dayIds = planDayRows.map((d) => d.id).toSet();
    final mealRows = await _db.mealPlanDao.getAllMeals();
    final planMealRows = mealRows.where((m) => dayIds.contains(m.dayPlanId)).toList();
    final meals = planMealRows
        .map(
          (m) => Meal(
            id: m.id,
            dayPlanId: m.dayPlanId,
            mealType: _fromDbMealType(m.mealType),
            mealTime: m.mealTime,
            recipeId: m.recipeId,
            isDone: m.isDone,
          ),
        )
        .toList();

    final recipeIds = planMealRows.map((m) => m.recipeId).toSet();
    final recipeRows = await _db.recipeDao.getAllRecipes();
    final planRecipeRows = recipeRows.where((r) => recipeIds.contains(r.id)).toList();
    final recipes = planRecipeRows
        .map(
          (r) => Recipe(
            id: r.id,
            title: r.title,
            cookingTimeMinutes: r.cookingTimeMinutes,
            difficulty: _fromDbDifficulty(r.difficulty),
            servings: r.servings,
            calories: r.calories,
            proteinG: r.proteinG,
            fatG: r.fatG,
            carbsG: r.carbsG,
            isFavorite: r.isFavorite,
            steps: _parseSteps(r.stepsJson),
          ),
        )
        .toList();

    final ingredientRows = await _db.recipeDao.getAllIngredients();
    final planIngredientRows = ingredientRows
        .where((i) => recipeIds.contains(i.recipeId))
        .toList();
    final ingredients = planIngredientRows
        .map(
          (i) => Ingredient(
            id: i.id,
            recipeId: i.recipeId,
            name: i.name,
            amount: i.amount,
            unit: i.unit,
            category: i.category,
          ),
        )
        .toList();

    return StoredMealPlanGraph(
      mealPlan: plan,
      days: days,
      meals: meals,
      recipes: recipes,
      ingredients: ingredients,
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

  MealType _fromDbMealType(DbMealType mealType) => switch (mealType) {
        DbMealType.breakfast => MealType.breakfast,
        DbMealType.lunch => MealType.lunch,
        DbMealType.dinner => MealType.dinner,
        DbMealType.snack => MealType.snack,
      };

  Difficulty _fromDbDifficulty(DbDifficulty difficulty) => switch (difficulty) {
        DbDifficulty.easy => Difficulty.easy,
        DbDifficulty.medium => Difficulty.medium,
        DbDifficulty.hard => Difficulty.hard,
      };

  List<CookingStep> _parseSteps(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(CookingStep.fromJson)
            .toList();
      }
    } catch (_) {
      // keep empty for malformed or legacy data
    }
    return const [];
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime _defaultMealTime(DateTime day, dynamic mealType) {
    final base = DateTime.utc(day.year, day.month, day.day);
    final name = mealType.toString();
    if (name.contains('lunch')) return base.add(const Duration(hours: 13));
    if (name.contains('dinner')) return base.add(const Duration(hours: 19));
    if (name.contains('snack')) return base.add(const Duration(hours: 16));
    return base.add(const Duration(hours: 8));
  }
}

