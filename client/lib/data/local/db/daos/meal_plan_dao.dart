part of '../app_database.dart';

@DriftAccessor(tables: [MealPlans, DayPlans, Meals])
class MealPlanDao extends DatabaseAccessor<AppDatabase> with _$MealPlanDaoMixin {
  MealPlanDao(super.db);

  Future<int> insertMealPlan(MealPlansCompanion row) => into(mealPlans).insert(row);

  Future<MealPlanEntry?> getMealPlanById(int id) =>
      (select(mealPlans)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<MealPlanEntry>> getAllMealPlans() => select(mealPlans).get();

  Future<bool> updateMealPlan(MealPlanEntry row) => update(mealPlans).replace(row);

  Future<int> deleteMealPlan(int id) =>
      (delete(mealPlans)..where((t) => t.id.equals(id))).go();

  Future<int> insertDayPlan(DayPlansCompanion row) => into(dayPlans).insert(row);

  Future<DayPlanEntry?> getDayPlanById(int id) =>
      (select(dayPlans)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<DayPlanEntry>> getAllDayPlans() => select(dayPlans).get();

  Future<bool> updateDayPlan(DayPlanEntry row) => update(dayPlans).replace(row);

  Future<int> deleteDayPlan(int id) =>
      (delete(dayPlans)..where((t) => t.id.equals(id))).go();

  Future<int> insertMeal(MealsCompanion row) => into(meals).insert(row);

  Future<MealEntry?> getMealById(int id) =>
      (select(meals)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<MealEntry>> getAllMeals() => select(meals).get();

  Future<bool> updateMeal(MealEntry row) => update(meals).replace(row);

  Future<int> deleteMeal(int id) =>
      (delete(meals)..where((t) => t.id.equals(id))).go();
}
