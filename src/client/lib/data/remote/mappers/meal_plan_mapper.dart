import 'dart:convert';

import 'package:client/data/remote/dto/meal_plan/generate_meal_plan_response_dto.dart';
import 'package:client/data/remote/source/meal_plan_remote_source.dart';
import 'package:client/domain/models/cooking_step.dart';
import 'package:client/domain/models/enums/difficulty.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/enums/meal_type.dart';
import 'package:client/domain/models/ingredient.dart';
import 'package:client/domain/models/recipe.dart';

class MealPlanMapper {
  static GeneratedMealPlanGraph toGeneratedGraph(GenerateMealPlanResponseDto dto) {
    final startDate = DateTime.parse(dto.plan.startDate);
    final endDate = DateTime.parse(dto.plan.endDate);

    final days = dto.plan.days.map((dayDto) {
      final date = DateTime.parse(dayDto.date);
      final meals = dayDto.meals.map((mealDto) {
        final mealType = _mealTypeFromApi(mealDto.mealType);
        final recipeDto = mealDto.recipe;

        final steps = recipeDto.steps
            .map(
              (s) => CookingStep(
                order: s.order,
                instruction: s.description,
                durationSeconds: s.timerSeconds,
              ),
            )
            .toList();

        final recipe = Recipe(
          id: 0,
          title: recipeDto.name,
          cookingTimeMinutes: recipeDto.cookingTimeMin,
          difficulty: Difficulty.easy,
          servings: 1,
          calories: recipeDto.nutrition.calories,
          proteinG: recipeDto.nutrition.proteinG,
          fatG: recipeDto.nutrition.fatG,
          carbsG: recipeDto.nutrition.carbsG,
          isFavorite: false,
          steps: steps,
        );

        final ingredients = recipeDto.ingredients
            .map(
              (i) => Ingredient(
                id: 0,
                recipeId: 0,
                name: i.name,
                amount: i.amount,
                unit: i.unit,
                category: i.category ?? 'other',
              ),
            )
            .toList();

        return GeneratedMeal(
          mealType: mealType,
          recipe: recipe,
          ingredients: ingredients,
        );
      }).toList();

      return GeneratedDay(date: date, meals: meals);
    }).toList();

    return GeneratedMealPlanGraph(
      goal: Goal.maintain,
      startDate: startDate,
      endDate: endDate,
      days: days,
      weeklySummaryJson: jsonEncode(dto.weeklySummary.toJson()),
    );
  }

  static MealType _mealTypeFromApi(String value) {
    return switch (value) {
      'breakfast' => MealType.breakfast,
      'lunch' => MealType.lunch,
      'dinner' => MealType.dinner,
      'snack_1' => MealType.snack,
      'snack_2' => MealType.snack,
      _ => MealType.breakfast,
    };
  }
}

