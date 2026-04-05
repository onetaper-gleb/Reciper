import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:client/core/utils/nutrition_calculator.dart';
import 'package:client/domain/models/cooking_step.dart';
import 'package:client/domain/models/day_plan.dart';
import 'package:client/domain/models/fridge_product.dart';
import 'package:client/domain/models/fridge_scan.dart';
import 'package:client/domain/models/ingredient.dart';
import 'package:client/domain/models/meal.dart';
import 'package:client/domain/models/meal_plan.dart';
import 'package:client/domain/models/nutrition.dart';
import 'package:client/domain/models/profile.dart';
import 'package:client/domain/models/recipe.dart';
import 'package:client/domain/models/shopping_item.dart';
import 'package:client/domain/models/user_preferences.dart';
import 'package:client/domain/models/weight_entry.dart';
import 'package:client/domain/models/enums/activity_level.dart';
import 'package:client/domain/models/enums/budget_level.dart';
import 'package:client/domain/models/enums/diet_type.dart';
import 'package:client/domain/models/enums/difficulty.dart';
import 'package:client/domain/models/enums/gender.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/enums/meal_type.dart';
import 'package:client/domain/models/enums/replace_reason.dart';

void main() {
  group('Profile JSON', () {
    test('round-trip equals original', () {
      const original = Profile(
        id: 1,
        name: 'Анна',
        gender: Gender.female,
        age: 30,
        heightCm: 165.5,
        weightKg: 60,
        targetWeightKg: 58,
        goal: Goal.loseWeight,
        activityLevel: ActivityLevel.moderate,
      );

      final json = original.toJson();
      final decoded = Profile.fromJson(json);
      expect(decoded, original);

      final viaString = jsonEncode(json);
      expect(Profile.fromJson(jsonDecode(viaString) as Map<String, dynamic>), original);
    });
  });

  group('NutritionCalculator', () {
    test(
      'male 25y, 178cm, 82kg, moderate activity, weight loss → kcal in 1900–2200',
      () {
        final nutrition = NutritionCalculator.dailyTargets(
          gender: Gender.male,
          age: 25,
          heightCm: 178,
          weightKg: 82,
          activityLevel: ActivityLevel.moderate,
          goal: Goal.loseWeight,
        );

        expect(
          nutrition.dailyCalories,
          inInclusiveRange(1900, 2200),
          reason: 'Mifflin–St Jeor BMR × moderate PAL × weight-loss factor',
        );
        expect(nutrition.proteinG, greaterThan(0));
        expect(nutrition.fatG, greaterThan(0));
        expect(nutrition.carbsG, greaterThan(0));
      },
    );
  });

  group('copyWith on all freezed models', () {
    test('each model reflects a single field change', () {
      const profile = Profile(
        id: 1,
        name: 'A',
        gender: Gender.male,
        age: 20,
        heightCm: 170,
        weightKg: 70,
        targetWeightKg: 68,
        goal: Goal.maintain,
        activityLevel: ActivityLevel.sedentary,
      );
      expect(profile.copyWith(name: 'B').name, 'B');

      final prefs = UserPreferences(
        id: 1,
        allergies: const ['nuts'],
        dislikedProducts: const [],
        likedProducts: const [],
        maxCookingMinutes: 45,
        budget: BudgetLevel.medium,
        dietType: DietType.omnivore,
      );
      expect(prefs.copyWith(maxCookingMinutes: 60).maxCookingMinutes, 60);

      const nutrition = Nutrition(
        dailyCalories: 2000,
        proteinG: 100,
        fatG: 70,
        carbsG: 200,
      );
      expect(nutrition.copyWith(proteinG: 110).proteinG, 110);

      final mealPlan = MealPlan(
        id: 1,
        startDate: DateTime.utc(2026, 4, 1),
        endDate: DateTime.utc(2026, 4, 7),
        goal: Goal.maintain,
        isActive: true,
        createdAt: DateTime.utc(2026, 4, 1, 8),
      );
      expect(mealPlan.copyWith(isActive: false).isActive, false);

      final dayPlan = DayPlan(
        id: 1,
        mealPlanId: 1,
        date: DateTime.utc(2026, 4, 2),
      );
      expect(dayPlan.copyWith(mealPlanId: 2).mealPlanId, 2);

      final meal = Meal(
        id: 1,
        dayPlanId: 1,
        mealType: MealType.breakfast,
        mealTime: DateTime.utc(2026, 4, 2, 7, 30),
        recipeId: 10,
        isDone: false,
      );
      expect(meal.copyWith(isDone: true).isDone, true);
      expect(
        meal.copyWith(replaceReason: ReplaceReason.missingIngredients).replaceReason,
        ReplaceReason.missingIngredients,
      );

      const step = CookingStep(
        order: 0,
        instruction: 'Boil water',
        durationSeconds: 120,
      );
      final recipe = Recipe(
        id: 1,
        title: 'Soup',
        cookingTimeMinutes: 30,
        difficulty: Difficulty.easy,
        servings: 2,
        calories: 400,
        proteinG: 20,
        fatG: 10,
        carbsG: 50,
        isFavorite: false,
        steps: [step],
      );
      expect(recipe.copyWith(title: 'Stew').title, 'Stew');

      expect(step.copyWith(order: 1).order, 1);

      const ingredient = Ingredient(
        id: 1,
        recipeId: 1,
        name: 'Salt',
        amount: 1,
        unit: 'g',
        category: 'spice',
      );
      expect(ingredient.copyWith(amount: 2).amount, 2);

      const shopping = ShoppingItem(
        id: 1,
        mealPlanId: 1,
        name: 'Milk',
        amount: 1,
        unit: 'l',
        category: 'dairy',
        purchased: false,
        inFridge: false,
      );
      expect(shopping.copyWith(purchased: true).purchased, true);

      const fridgeProduct = FridgeProduct(
        id: 1,
        name: 'Eggs',
        amount: 6,
        unit: 'pcs',
        category: 'dairy',
      );
      expect(fridgeProduct.copyWith(amount: 12).amount, 12);

      final scan = FridgeScan(
        id: 1,
        photoPath: '/tmp/a.jpg',
        scanDate: DateTime.utc(2026, 4, 1),
        productCount: 3,
      );
      expect(scan.copyWith(productCount: 5).productCount, 5);

      final weight = WeightEntry(
        id: 1,
        weightKg: 80,
        entryDate: DateTime.utc(2026, 4, 1),
      );
      expect(weight.copyWith(weightKg: 79.5).weightKg, 79.5);
    });
  });
}
