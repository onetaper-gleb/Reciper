import '../api/reciper_api.dart';
import '../dto/meal_plan/generate_meal_plan_request_dto.dart';
import '../mappers/meal_plan_mapper.dart';
import 'package:client/core/utils/app_logger.dart';
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
  const GeneratedRecipe({
    required this.title,
    required this.cookingTimeMinutes,
    required this.calories,
    required this.proteinG,
    required this.fatG,
    required this.carbsG,
  });
  final String title;
  final int cookingTimeMinutes;
  final double calories;
  final double proteinG;
  final double fatG;
  final double carbsG;

  factory GeneratedRecipe.fake({required String title}) => GeneratedRecipe(
        title: title,
        cookingTimeMinutes: 10,
        calories: 300,
        proteinG: 10,
        fatG: 10,
        carbsG: 40,
      );

  factory GeneratedRecipe.fromReplaceResponse(Map<String, dynamic> data) {
    final recipe = (data['recipe'] as Map?)?.cast<String, dynamic>() ?? const {};
    final nutrition =
        (recipe['nutrition'] as Map?)?.cast<String, dynamic>() ?? const {};
    return GeneratedRecipe(
      title: recipe['name']?.toString() ?? 'Рецепт',
      cookingTimeMinutes: (recipe['cooking_time_min'] as num?)?.toInt() ?? 10,
      calories: (nutrition['calories'] as num?)?.toDouble() ?? 300,
      proteinG: (nutrition['protein_g'] as num?)?.toDouble() ?? 0,
      fatG: (nutrition['fat_g'] as num?)?.toDouble() ?? 0,
      carbsG: (nutrition['carbs_g'] as num?)?.toDouble() ?? 0,
    );
  }

  Recipe toRecipe() => Recipe(
        id: 0,
        title: title,
        cookingTimeMinutes: cookingTimeMinutes,
        difficulty: Difficulty.easy,
        servings: 1,
        calories: calories,
        proteinG: proteinG,
        fatG: fatG,
        carbsG: carbsG,
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
    final normalized = _stringKeyedDeep(requestJson);
    AppLogger.info('MealPlanRemoteSource.replaceMeal normalizedRequest=$normalized');
    final data = await _api.replaceMeal(normalized);
    final generated = GeneratedRecipe.fromReplaceResponse(data);
    AppLogger.info(
      'MealPlanRemoteSource.replaceMeal parsedRecipe='
      '${generated.title}, ${generated.cookingTimeMinutes}m, ${generated.calories}kcal',
    );
    return generated;
  }
}

Map<String, dynamic> _stringKeyedDeep(Map<String, dynamic> input) {
  dynamic convert(dynamic value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), convert(v)));
    }
    if (value is List) {
      return value.map(convert).toList();
    }
    return value;
  }

  return Map<String, dynamic>.from(convert(input) as Map);
}

