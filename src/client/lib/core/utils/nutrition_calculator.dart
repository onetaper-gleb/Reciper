import 'package:client/domain/models/enums/activity_level.dart';
import 'package:client/domain/models/enums/gender.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/nutrition.dart';

/// Pure nutrition math (Mifflin–St Jeor BMR, PAL-based TDEE, goal factors).
abstract final class NutritionCalculator {
  /// BMR in kcal/day (Mifflin–St Jeor, metric inputs).
  static double bmrMifflinStJeor({
    required Gender gender,
    required int age,
    required double heightCm,
    required double weightKg,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    return switch (gender) {
      Gender.female => base - 161,
      Gender.male => base + 5,
    };
  }

  /// Physical activity level multiplier (classic factors).
  static double activityFactor(ActivityLevel level) => switch (level) {
        ActivityLevel.sedentary => 1.2,
        ActivityLevel.light => 1.375,
        ActivityLevel.moderate => 1.55,
        ActivityLevel.active => 1.725,
        ActivityLevel.veryActive => 1.9,
      };

  /// Multiplier applied to TDEE to get a daily calorie target.
  static double goalCalorieFactor(Goal goal) => switch (goal) {
        Goal.loseWeight => 0.75,
        Goal.maintain => 1.0,
        Goal.gainMuscle => 1.12,
        Goal.cutting => 0.85,
      };

  /// Macro ratios (fractions of total kcal) by goal.
  static ({double protein, double fat, double carbs}) macroRatios(Goal goal) =>
      switch (goal) {
        Goal.loseWeight => (protein: 0.30, fat: 0.30, carbs: 0.40),
        Goal.maintain => (protein: 0.25, fat: 0.30, carbs: 0.45),
        Goal.gainMuscle => (protein: 0.30, fat: 0.25, carbs: 0.45),
        Goal.cutting => (protein: 0.35, fat: 0.28, carbs: 0.37),
      };

  /// Daily calorie target and КБЖУ (4 kcal/g protein & carbs, 9 kcal/g fat).
  static Nutrition dailyTargets({
    required Gender gender,
    required int age,
    required double heightCm,
    required double weightKg,
    required ActivityLevel activityLevel,
    required Goal goal,
  }) {
    final bmr = bmrMifflinStJeor(
      gender: gender,
      age: age,
      heightCm: heightCm,
      weightKg: weightKg,
    );
    final tdee = bmr * activityFactor(activityLevel);
    final targetKcal = tdee * goalCalorieFactor(goal);
    final ratios = macroRatios(goal);

    return Nutrition(
      dailyCalories: _round1(targetKcal),
      proteinG: _round1(targetKcal * ratios.protein / 4),
      fatG: _round1(targetKcal * ratios.fat / 9),
      carbsG: _round1(targetKcal * ratios.carbs / 4),
    );
  }

  static double _round1(double v) => (v * 10).round() / 10;
}
