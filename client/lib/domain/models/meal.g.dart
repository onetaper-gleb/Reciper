// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Meal _$MealFromJson(Map<String, dynamic> json) => _Meal(
  id: (json['id'] as num).toInt(),
  dayPlanId: (json['day_plan_id'] as num).toInt(),
  mealType: $enumDecode(_$MealTypeEnumMap, json['meal_type']),
  mealTime: DateTime.parse(json['meal_time'] as String),
  recipeId: (json['recipe_id'] as num).toInt(),
  isDone: json['is_done'] as bool,
  replaceReason: $enumDecodeNullable(
    _$ReplaceReasonEnumMap,
    json['replace_reason'],
  ),
);

Map<String, dynamic> _$MealToJson(_Meal instance) => <String, dynamic>{
  'id': instance.id,
  'day_plan_id': instance.dayPlanId,
  'meal_type': _$MealTypeEnumMap[instance.mealType]!,
  'meal_time': instance.mealTime.toIso8601String(),
  'recipe_id': instance.recipeId,
  'is_done': instance.isDone,
  'replace_reason': _$ReplaceReasonEnumMap[instance.replaceReason],
};

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.snack: 'snack',
};

const _$ReplaceReasonEnumMap = {
  ReplaceReason.notHungry: 'not_hungry',
  ReplaceReason.allergic: 'allergic',
  ReplaceReason.missingIngredients: 'missing_ingredients',
  ReplaceReason.preferOther: 'prefer_other',
  ReplaceReason.other: 'other',
};
