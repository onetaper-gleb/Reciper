import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/db/db_enums.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.test();
  });

  tearDown(() async {
    await db.close();
  });

  group('ProfileDao', () {
    test('insert then read profile — fields match', () async {
      final id = await db.profileDao.insertProfile(
        ProfilesCompanion.insert(
          name: 'Анна',
          gender: DbGender.female,
          age: 30,
          heightCm: 165.5,
          weightKg: 60,
          targetWeightKg: 58,
          goal: DbGoal.loseWeight,
          activityLevel: DbActivityLevel.moderate,
        ),
      );

      final row = await db.profileDao.getProfileById(id);
      expect(row, isNotNull);
      expect(row!.name, 'Анна');
      expect(row.gender, DbGender.female);
      expect(row.age, 30);
      expect(row.heightCm, 165.5);
      expect(row.weightKg, 60);
      expect(row.targetWeightKg, 58);
      expect(row.goal, DbGoal.loseWeight);
      expect(row.activityLevel, DbActivityLevel.moderate);
    });
  });

  group('Meal plan graph (FKs)', () {
    test('insert plan → day → meal → recipe → ingredients; reads by FK hold',
        () async {
      final recipeId = await db.recipeDao.insertRecipe(
        RecipesCompanion.insert(
          title: 'Овсянка',
          cookingTimeMinutes: 15,
          difficulty: DbDifficulty.easy,
          servings: 1,
          calories: 320,
          proteinG: 12,
          fatG: 8,
          carbsG: 50,
          isFavorite: const Value(false),
          stepsJson: '[]',
        ),
      );

      final mealPlanId = await db.mealPlanDao.insertMealPlan(
        MealPlansCompanion.insert(
          startDate: DateTime.utc(2026, 4, 1),
          endDate: DateTime.utc(2026, 4, 7),
          goal: DbGoal.maintain,
          isActive: const Value(true),
          createdAt: DateTime.utc(2026, 4, 1, 8),
        ),
      );

      final dayPlanId = await db.mealPlanDao.insertDayPlan(
        DayPlansCompanion.insert(
          mealPlanId: mealPlanId,
          planDate: DateTime.utc(2026, 4, 2),
        ),
      );

      final mealId = await db.mealPlanDao.insertMeal(
        MealsCompanion.insert(
          dayPlanId: dayPlanId,
          mealType: DbMealType.breakfast,
          mealTime: DateTime.utc(2026, 4, 2, 7, 30),
          recipeId: recipeId,
          isDone: const Value(false),
        ),
      );

      await db.recipeDao.insertIngredient(
        IngredientsCompanion.insert(
          recipeId: recipeId,
          name: 'Овсяные хлопья',
          amount: 50,
          unit: 'г',
          category: 'крупы',
        ),
      );
      await db.recipeDao.insertIngredient(
        IngredientsCompanion.insert(
          recipeId: recipeId,
          name: 'Молоко',
          amount: 200,
          unit: 'мл',
          category: 'молочное',
        ),
      );

      final meal = await db.mealPlanDao.getMealById(mealId);
      expect(meal, isNotNull);
      expect(meal!.dayPlanId, dayPlanId);
      expect(meal.recipeId, recipeId);
      expect(meal.mealType, DbMealType.breakfast);

      final day = await db.mealPlanDao.getDayPlanById(dayPlanId);
      expect(day, isNotNull);
      expect(day!.mealPlanId, mealPlanId);

      final plan = await db.mealPlanDao.getMealPlanById(mealPlanId);
      expect(plan, isNotNull);
      expect(plan!.id, mealPlanId);

      final recipe = await db.recipeDao.getRecipeById(recipeId);
      expect(recipe, isNotNull);
      expect(recipe!.title, 'Овсянка');

      final ingredients = await db.recipeDao.getAllIngredients();
      final forRecipe = ingredients.where((e) => e.recipeId == recipeId).toList();
      expect(forRecipe, hasLength(2));
      expect(forRecipe.map((e) => e.name).toSet(), {'Овсяные хлопья', 'Молоко'});
    });
  });

  test('clearAllUserData removes all rows', () async {
    await db.profileDao.insertProfile(
      ProfilesCompanion.insert(
        name: 'X',
        gender: DbGender.male,
        age: 20,
        heightCm: 170,
        weightKg: 70,
        targetWeightKg: 68,
        goal: DbGoal.maintain,
        activityLevel: DbActivityLevel.light,
      ),
    );
    await db.clearAllUserData();
    expect(await db.profileDao.getAllProfiles(), isEmpty);
    expect(await db.mealPlanDao.getAllMealPlans(), isEmpty);
    expect(await db.progressDao.getAllWeightEntries(), isEmpty);
  });
}
