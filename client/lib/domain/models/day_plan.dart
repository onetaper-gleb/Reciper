import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_plan.freezed.dart';
part 'day_plan.g.dart';

@freezed
abstract class DayPlan with _$DayPlan {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory DayPlan({
    required int id,
    required int mealPlanId,
    required DateTime date,
  }) = _DayPlan;

  factory DayPlan.fromJson(Map<String, dynamic> json) =>
      _$DayPlanFromJson(json);
}
