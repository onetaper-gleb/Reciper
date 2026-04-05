// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Nutrition _$NutritionFromJson(Map<String, dynamic> json) => _Nutrition(
  dailyCalories: (json['daily_calories'] as num).toDouble(),
  proteinG: (json['protein_g'] as num).toDouble(),
  fatG: (json['fat_g'] as num).toDouble(),
  carbsG: (json['carbs_g'] as num).toDouble(),
);

Map<String, dynamic> _$NutritionToJson(_Nutrition instance) =>
    <String, dynamic>{
      'daily_calories': instance.dailyCalories,
      'protein_g': instance.proteinG,
      'fat_g': instance.fatG,
      'carbs_g': instance.carbsG,
    };
