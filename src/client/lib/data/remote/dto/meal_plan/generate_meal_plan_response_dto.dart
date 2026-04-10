import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/cooking_step_dto.dart';
import '../common/ingredient_dto.dart';
import '../common/nutrition_dto.dart';

part 'generate_meal_plan_response_dto.freezed.dart';
part 'generate_meal_plan_response_dto.g.dart';

@freezed
abstract class GenerateMealPlanResponseDto with _$GenerateMealPlanResponseDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory GenerateMealPlanResponseDto({
    required PlanDto plan,
    required WeeklySummaryDto weeklySummary,
  }) = _GenerateMealPlanResponseDto;

  factory GenerateMealPlanResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GenerateMealPlanResponseDtoFromJson(json);
}

@freezed
abstract class PlanDto with _$PlanDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PlanDto({
    required String startDate,
    required String endDate,
    required List<DayDto> days,
  }) = _PlanDto;

  factory PlanDto.fromJson(Map<String, dynamic> json) => _$PlanDtoFromJson(json);
}

@freezed
abstract class DayDto with _$DayDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory DayDto({
    required String date,
    required List<MealDto> meals,
  }) = _DayDto;

  factory DayDto.fromJson(Map<String, dynamic> json) => _$DayDtoFromJson(json);
}

@freezed
abstract class MealDto with _$MealDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory MealDto({
    required String mealType,
    required RecipeDto recipe,
  }) = _MealDto;

  factory MealDto.fromJson(Map<String, dynamic> json) => _$MealDtoFromJson(json);
}

@freezed
abstract class RecipeDto with _$RecipeDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory RecipeDto({
    required String name,
    required int cookingTimeMin,
    required NutritionDto nutrition,
    required List<IngredientDto> ingredients,
    required List<CookingStepDto> steps,
  }) = _RecipeDto;

  factory RecipeDto.fromJson(Map<String, dynamic> json) =>
      _$RecipeDtoFromJson(json);
}

@freezed
abstract class WeeklySummaryDto with _$WeeklySummaryDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory WeeklySummaryDto({
    required double avgCalories,
    required double avgProteinG,
    required double avgFatG,
    required double avgCarbsG,
  }) = _WeeklySummaryDto;

  factory WeeklySummaryDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklySummaryDtoFromJson(json);
}

