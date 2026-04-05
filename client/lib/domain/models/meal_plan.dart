import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/goal.dart';

part 'meal_plan.freezed.dart';
part 'meal_plan.g.dart';

@freezed
abstract class MealPlan with _$MealPlan {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory MealPlan({
    required int id,
    required DateTime startDate,
    required DateTime endDate,
    required Goal goal,
    required bool isActive,
    required DateTime createdAt,
  }) = _MealPlan;

  factory MealPlan.fromJson(Map<String, dynamic> json) =>
      _$MealPlanFromJson(json);
}
