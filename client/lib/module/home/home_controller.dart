import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/domain/models/meal.dart';
import 'package:client/domain/models/recipe.dart';

class HomeMealItem {
  const HomeMealItem({required this.meal, required this.recipe});
  final Meal meal;
  final Recipe recipe;
}

class NutritionProgress {
  const NutritionProgress({
    required this.targetCalories,
    required this.consumedCalories,
    required this.proteinProgress,
    required this.fatProgress,
    required this.carbsProgress,
  });

  final double targetCalories;
  final double consumedCalories;
  final double proteinProgress;
  final double fatProgress;
  final double carbsProgress;
}

abstract final class HomeController {
  static List<HomeMealItem> mealsForSelectedDay(
    StoredMealPlanGraph graph,
    DateTime selectedDate,
  ) {
    final dayIds = graph.days
        .where((d) => _isSameDate(d.date, selectedDate))
        .map((d) => d.id)
        .toSet();
    final meals = graph.meals.where((m) => dayIds.contains(m.dayPlanId));
    final recipesById = {for (final r in graph.recipes) r.id: r};
    return meals
        .where((m) => recipesById.containsKey(m.recipeId))
        .map((m) => HomeMealItem(meal: m, recipe: recipesById[m.recipeId]!))
        .toList()
      ..sort((a, b) => a.meal.mealTime.compareTo(b.meal.mealTime));
  }

  static NutritionProgress calculateProgress(List<HomeMealItem> meals) {
    final targetCalories = meals.fold<double>(
      0,
      (sum, m) => sum + m.recipe.calories,
    );
    final consumedCalories = meals
        .where((m) => m.meal.isDone)
        .fold<double>(0, (sum, m) => sum + m.recipe.calories);

    final targetProtein = meals.fold<double>(0, (sum, m) => sum + m.recipe.proteinG);
    final targetFat = meals.fold<double>(0, (sum, m) => sum + m.recipe.fatG);
    final targetCarbs = meals.fold<double>(0, (sum, m) => sum + m.recipe.carbsG);

    final consumedProtein = meals
        .where((m) => m.meal.isDone)
        .fold<double>(0, (sum, m) => sum + m.recipe.proteinG);
    final consumedFat = meals
        .where((m) => m.meal.isDone)
        .fold<double>(0, (sum, m) => sum + m.recipe.fatG);
    final consumedCarbs = meals
        .where((m) => m.meal.isDone)
        .fold<double>(0, (sum, m) => sum + m.recipe.carbsG);

    return NutritionProgress(
      targetCalories: targetCalories,
      consumedCalories: consumedCalories,
      proteinProgress: _ratio(consumedProtein, targetProtein),
      fatProgress: _ratio(consumedFat, targetFat),
      carbsProgress: _ratio(consumedCarbs, targetCarbs),
    );
  }

  static bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static double _ratio(double value, double target) {
    if (target <= 0) return 0;
    final r = value / target;
    if (r < 0) return 0;
    if (r > 1) return 1;
    return r;
  }
}

