// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealPlan _$MealPlanFromJson(Map<String, dynamic> json) => _MealPlan(
  id: (json['id'] as num).toInt(),
  startDate: DateTime.parse(json['start_date'] as String),
  endDate: DateTime.parse(json['end_date'] as String),
  goal: $enumDecode(_$GoalEnumMap, json['goal']),
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MealPlanToJson(_MealPlan instance) => <String, dynamic>{
  'id': instance.id,
  'start_date': instance.startDate.toIso8601String(),
  'end_date': instance.endDate.toIso8601String(),
  'goal': _$GoalEnumMap[instance.goal]!,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$GoalEnumMap = {
  Goal.loseWeight: 'lose_weight',
  Goal.maintain: 'maintain',
  Goal.gainMuscle: 'gain_muscle',
};
