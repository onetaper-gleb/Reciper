import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/db/db_enums.dart';
import 'package:client/data/repository/shopping_list_repository.dart';

void main() {
  test('generate list from plan groups and marks inFridge', () async {
    final db = AppDatabase.test();
    addTearDown(db.close);
    final repo = ShoppingListRepository(database: db);

    final planId = await db.mealPlanDao.insertMealPlan(
      MealPlansCompanion.insert(
        startDate: DateTime.utc(2026, 4, 7),
        endDate: DateTime.utc(2026, 4, 13),
        goal: DbGoal.maintain,
        isActive: const Value(true),
        createdAt: DateTime.utc(2026, 4, 7),
      ),
    );
    final dayId = await db.mealPlanDao.insertDayPlan(
      DayPlansCompanion.insert(
        mealPlanId: planId,
        planDate: DateTime.utc(2026, 4, 7),
      ),
    );
    final recipeId = await db.recipeDao.insertRecipe(
      RecipesCompanion.insert(
        title: 'Омлет',
        cookingTimeMinutes: 10,
        difficulty: DbDifficulty.easy,
        servings: 1,
        calories: 300,
        proteinG: 20,
        fatG: 20,
        carbsG: 10,
        isFavorite: const Value(false),
        stepsJson: '[]',
      ),
    );
    await db.mealPlanDao.insertMeal(
      MealsCompanion.insert(
        dayPlanId: dayId,
        mealType: DbMealType.breakfast,
        mealTime: DateTime.utc(2026, 4, 7, 8),
        recipeId: recipeId,
        isDone: const Value(false),
      ),
    );
    await db.recipeDao.insertIngredient(
      IngredientsCompanion.insert(
        recipeId: recipeId,
        name: 'Яйца',
        amount: 2,
        unit: 'шт',
        category: 'Белки',
      ),
    );
    await db.recipeDao.insertIngredient(
      IngredientsCompanion.insert(
        recipeId: recipeId,
        name: 'Молоко',
        amount: 0.2,
        unit: 'л',
        category: 'Молочные',
      ),
    );
    await db.fridgeDao.insertFridgeProduct(
      FridgeProductsCompanion.insert(
        name: 'Яйца',
        amount: 10,
        unit: 'шт',
        category: 'Белки',
        addedAt: DateTime.utc(2026, 4, 6),
      ),
    );

    final items = await repo.generateListFromPlan(planId, date: DateTime.utc(2026, 4, 7));
    expect(items.length, 2);
    final eggs = items.firstWhere((e) => e.name == 'Яйца');
    final milk = items.firstWhere((e) => e.name == 'Молоко');
    expect(eggs.inFridge, isTrue);
    expect(milk.inFridge, isFalse);
  });
}

