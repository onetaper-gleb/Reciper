import '../api/reciper_api.dart';
import '../dto/meal_plan/generate_meal_plan_request_dto.dart';
import '../dto/meal_plan/replace_meal_request_dto.dart';
import '../mappers/meal_plan_mapper.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/enums/difficulty.dart';
import 'package:client/domain/models/enums/meal_type.dart';
import 'package:client/domain/models/ingredient.dart';
import 'package:client/domain/models/recipe.dart';

class GeneratedMealPlanGraph {
  const GeneratedMealPlanGraph({
    required this.goal,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.weeklySummaryJson,
  });

  final Goal goal;
  final DateTime startDate;
  final DateTime endDate;
  final List<GeneratedDay> days;
  final String weeklySummaryJson;

  factory GeneratedMealPlanGraph.fake({
    required Goal goal,
    required DateTime startDate,
    required int days,
  }) {
    final d = List.generate(
      days,
      (i) => GeneratedDay(
        date: startDate.add(Duration(days: i)),
        meals: [
          GeneratedMeal(
            mealType: MealType.breakfast,
            recipe: GeneratedRecipe.fake(title: 'Omelette').toRecipe(),
            ingredients: const [],
          )
        ],
      ),
    );

    return GeneratedMealPlanGraph(
      goal: goal,
      startDate: startDate,
      endDate: startDate.add(Duration(days: days - 1)),
      days: d,
      weeklySummaryJson: '{}',
    );
  }
}

class GeneratedDay {
  const GeneratedDay({required this.date, required this.meals});
  final DateTime date;
  final List<GeneratedMeal> meals;
}

class GeneratedMeal {
  const GeneratedMeal({
    required this.mealType,
    required this.recipe,
    required this.ingredients,
  });

  final MealType mealType;
  final Recipe recipe;
  final List<Ingredient> ingredients;
}

class GeneratedRecipe {
  const GeneratedRecipe({required this.title});
  final String title;

  factory GeneratedRecipe.fake({required String title}) => GeneratedRecipe(title: title);

  Recipe toRecipe() => Recipe(
        id: 0,
        title: title,
        cookingTimeMinutes: 10,
        difficulty: Difficulty.easy,
        servings: 1,
        calories: 300,
        proteinG: 10,
        fatG: 10,
        carbsG: 40,
        isFavorite: false,
        steps: const [],
      );
}

abstract class MealPlanRemoteSource {
  Future<GeneratedMealPlanGraph> generatePlan({
    required Map<String, dynamic> profileJson,
    required Map<String, dynamic> preferencesJson,
    required Map<String, dynamic> planOptionsJson,
    required List<Map<String, dynamic>> fridgeProductsJson,
    String? additionalNotes,
  });

  Future<GeneratedRecipe> replaceMeal({
    required Map<String, dynamic> requestJson,
  });
}

class MealPlanRemoteSourceImpl implements MealPlanRemoteSource {
  MealPlanRemoteSourceImpl(this._api);

  final ReciperApi _api;

  @override
  Future<GeneratedMealPlanGraph> generatePlan({
    required Map<String, dynamic> profileJson,
    required Map<String, dynamic> preferencesJson,
    required Map<String, dynamic> planOptionsJson,
    required List<Map<String, dynamic>> fridgeProductsJson,
    String? additionalNotes,
  }) async {
    final dto = await _api.generateMealPlan(
      GenerateMealPlanRequestDto(
        profile: profileJson,
        preferences: preferencesJson,
        planOptions: planOptionsJson,
        fridgeProducts: fridgeProductsJson,
        additionalNotes: additionalNotes,
      ),
    );
    return MealPlanMapper.toGeneratedGraph(dto);
  }

  @override
  Future<GeneratedRecipe> replaceMeal({required Map<String, dynamic> requestJson}) async {
    final data = await _api.replaceMeal(
      ReplaceMealRequestDto.fromJson(requestJson),
    );
    // For now keep a minimal representation; full mapping will be in task 11/12.
    final title = (data['recipe'] as Map?)?['name']?.toString() ?? 'Recipe';
    return GeneratedRecipe(title: title);
  }
}

