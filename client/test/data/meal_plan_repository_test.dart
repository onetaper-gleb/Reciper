import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/data/remote/source/meal_plan_remote_source.dart';
import 'package:client/domain/models/enums/goal.dart';

class FakeMealPlanRemoteSource implements MealPlanRemoteSource {
  @override
  Future<GeneratedMealPlanGraph> generatePlan({
    required Map<String, dynamic> profileJson,
    required Map<String, dynamic> preferencesJson,
    required Map<String, dynamic> planOptionsJson,
    required List<Map<String, dynamic>> fridgeProductsJson,
    String? additionalNotes,
  }) async {
    return GeneratedMealPlanGraph.fake(
      goal: Goal.maintain,
      startDate: DateTime.utc(2026, 4, 6),
      days: 1,
    );
  }

  @override
  Future<GeneratedRecipe> replaceMeal({
    required Map<String, dynamic> requestJson,
  }) async {
    return const GeneratedRecipe(
      title: 'Toast with eggs',
      cookingTimeMinutes: 22,
      calories: 777,
      proteinG: 66,
      fatG: 55,
      carbsG: 44,
    );
  }
}

void main() {
  test('MealPlanRepository generatePlan stores and returns active plan', () async {
    final db = AppDatabase.test();
    addTearDown(db.close);

    final repo = MealPlanRepository(
      database: db,
      remoteSource: FakeMealPlanRemoteSource(),
    );

    final created = await repo.generatePlan(
      profileJson: const {'gender': 'male'},
      preferencesJson: const {},
      planOptionsJson: const {'days': 1, 'meals_per_day': 1},
      fridgeProductsJson: const [],
    );

    expect(created.mealPlan.isActive, isTrue);

    final active = await repo.getActivePlan();
    expect(active, isNotNull);
    expect(active!.mealPlan.id, created.mealPlan.id);
  });

  test('MealPlanRepository replaceMeal updates recipe nutrition and time', () async {
    final db = AppDatabase.test();
    addTearDown(db.close);

    final repo = MealPlanRepository(
      database: db,
      remoteSource: FakeMealPlanRemoteSource(),
    );

    await repo.generatePlan(
      profileJson: const {'gender': 'male'},
      preferencesJson: const {},
      planOptionsJson: const {'days': 1, 'meals_per_day': 1},
      fridgeProductsJson: const [],
    );

    final before = await repo.getActivePlan();
    final mealId = before!.meals.first.id;

    await repo.replaceMeal(
      mealId: mealId,
      requestJson: const {
        'meal_type': 'breakfast',
        'current_recipe': {'name': 'Old'},
        'reason': 'test',
        'day_context': {'remaining_calories': 1000},
        'preferences': {},
        'fridge_products': [],
      },
    );

    final after = await repo.getActivePlan();
    final updatedMeal = after!.meals.firstWhere((m) => m.id == mealId);
    final updatedRecipe = after.recipes.firstWhere((r) => r.id == updatedMeal.recipeId);

    expect(updatedRecipe.title, 'Toast with eggs');
    expect(updatedRecipe.cookingTimeMinutes, 22);
    expect(updatedRecipe.calories, 777);
    expect(updatedRecipe.proteinG, 66);
    expect(updatedRecipe.fatG, 55);
    expect(updatedRecipe.carbsG, 44);
  });
}

