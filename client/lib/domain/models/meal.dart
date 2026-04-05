import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/meal_type.dart';
import 'enums/replace_reason.dart';

part 'meal.freezed.dart';
part 'meal.g.dart';

@freezed
abstract class Meal with _$Meal {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Meal({
    required int id,
    required int dayPlanId,
    required MealType mealType,
    required DateTime mealTime,
    required int recipeId,
    required bool isDone,
    ReplaceReason? replaceReason,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}
