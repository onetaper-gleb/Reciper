import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/db/db_enums.dart';
import 'package:client/data/repository/progress_repository.dart';
import 'package:client/domain/models/enums/weight_history_period.dart';

void main() {
  late AppDatabase db;
  late ProgressRepository repo;

  setUp(() {
    db = AppDatabase.test();
    repo = ProgressRepository(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('addWeightEntry and getWeightHistory respect period cutoff', () async {
    final now = DateTime.utc(2026, 4, 10, 12);
    await repo.addWeightEntry(80, now.subtract(const Duration(days: 5)));
    await repo.addWeightEntry(79, now.subtract(const Duration(days: 40)));
    await repo.addWeightEntry(78, now.subtract(const Duration(days: 400)));

    final h30 = await repo.getWeightHistory(WeightHistoryPeriod.days30, now: now);
    expect(h30.length, 1);
    expect(h30.single.weightKg, 80);

    final hYear = await repo.getWeightHistory(WeightHistoryPeriod.year1, now: now);
    expect(hYear.length, 2);
  });

  test(
      'getStatistics: days on active plan (local), streak, past consumed average',
      () async {
    final planId = await db.mealPlanDao.insertMealPlan(
      MealPlansCompanion.insert(
        startDate: DateTime.utc(2026, 4, 1),
        endDate: DateTime.utc(2026, 4, 7),
        goal: DbGoal.maintain,
        isActive: const Value(true),
        createdAt: DateTime.utc(2026, 4, 1),
      ),
    );

    final day1 = await db.mealPlanDao.insertDayPlan(
      DayPlansCompanion.insert(
        mealPlanId: planId,
        planDate: DateTime.utc(2026, 4, 1),
      ),
    );
    final day2 = await db.mealPlanDao.insertDayPlan(
      DayPlansCompanion.insert(
        mealPlanId: planId,
        planDate: DateTime.utc(2026, 4, 2),
      ),
    );
    final day3 = await db.mealPlanDao.insertDayPlan(
      DayPlansCompanion.insert(
        mealPlanId: planId,
        planDate: DateTime.utc(2026, 4, 3),
      ),
    );

    Future<int> insertRecipe(double kcal) => db.recipeDao.insertRecipe(
          RecipesCompanion.insert(
            title: 'R',
            cookingTimeMinutes: 10,
            difficulty: DbDifficulty.easy,
            servings: 1,
            calories: kcal,
            proteinG: 10,
            fatG: 10,
            carbsG: 10,
            isFavorite: const Value(false),
            stepsJson: '[]',
          ),
        );

    final r1 = await insertRecipe(400);
    final r2 = await insertRecipe(400);

    Future<void> insertMeal(int dayId, int recipeId, {required bool done}) {
      return db.mealPlanDao.insertMeal(
        MealsCompanion.insert(
          dayPlanId: dayId,
          mealType: DbMealType.breakfast,
          mealTime: DateTime.utc(2026, 4, 1, 8),
          recipeId: recipeId,
          isDone: Value(done),
        ),
      );
    }

    await insertMeal(day1, r1, done: true);
    await insertMeal(day1, r2, done: true);
    await insertMeal(day2, r1, done: true);
    await insertMeal(day2, r2, done: true);
    await insertMeal(day3, r1, done: true);
    await insertMeal(day3, r2, done: true);

    final ref = DateTime.utc(2026, 4, 3, 15);
    final stats = await repo.getStatistics(referenceUtc: ref);

    expect(stats.daysOnPlan, 3);
    expect(stats.mealsCooked, 6);
    expect(stats.consecutiveFullPlanDays, 3);
    expect(stats.averageConsumedKcalPastDays, closeTo(800.0, 0.01));
  });

  test('getStatistics without active plan — zeros / null averages', () async {
    final stats = await repo.getStatistics();
    expect(stats.daysOnPlan, 0);
    expect(stats.mealsCooked, 0);
    expect(stats.consecutiveFullPlanDays, 0);
    expect(stats.averageConsumedKcalPastDays, isNull);
  });
}
