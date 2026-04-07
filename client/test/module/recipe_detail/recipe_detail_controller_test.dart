import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/db/db_enums.dart';
import 'package:client/domain/models/ingredient.dart';
import 'package:client/module/recipe_detail/recipe_detail_controller.dart';

void main() {
  test('scales ingredients by selected portions', () {
    const ingredient = Ingredient(
      id: 1,
      recipeId: 10,
      name: 'Рис',
      amount: 100,
      unit: 'г',
      category: 'Крупы',
    );

    final scaled = RecipeDetailController.scaleIngredients(
      ingredients: const [ingredient],
      portions: 2,
    );

    expect(scaled.single.amount, 200);
  });

  test('adds only missing ingredients to shopping list', () async {
    final db = AppDatabase.test();
    addTearDown(db.close);

    final mealPlanId = await db.mealPlanDao.insertMealPlan(
      MealPlansCompanion.insert(
        startDate: DateTime.utc(2026, 4, 7),
        endDate: DateTime.utc(2026, 4, 13),
        goal: DbGoal.maintain,
        isActive: const Value(true),
        createdAt: DateTime.utc(2026, 4, 7),
      ),
    );

    const ingredients = [
      Ingredient(
        id: 1,
        recipeId: 10,
        name: 'Яйца',
        amount: 2,
        unit: 'шт',
        category: 'Белки',
      ),
      Ingredient(
        id: 2,
        recipeId: 10,
        name: 'Хлеб',
        amount: 1,
        unit: 'уп',
        category: 'Выпечка',
      ),
    ];

    final inserted = await RecipeDetailController.addMissingToShoppingList(
      database: db,
      mealPlanId: mealPlanId,
      ingredients: ingredients,
      fridgeNames: {'яйца'},
      portions: 1,
    );

    expect(inserted, 1);

    final rows = await db.shoppingListDao.getAllShoppingItems();
    expect(rows.length, 1);
    expect(rows.single.name, 'Хлеб');
    expect(rows.single.inFridge, isFalse);
  });
}

