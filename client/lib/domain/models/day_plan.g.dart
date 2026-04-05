// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayPlan _$DayPlanFromJson(Map<String, dynamic> json) => _DayPlan(
  id: (json['id'] as num).toInt(),
  mealPlanId: (json['meal_plan_id'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$DayPlanToJson(_DayPlan instance) => <String, dynamic>{
  'id': instance.id,
  'meal_plan_id': instance.mealPlanId,
  'date': instance.date.toIso8601String(),
};
