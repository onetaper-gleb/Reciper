// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  cookingTimeMinutes: (json['cooking_time_minutes'] as num).toInt(),
  difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
  servings: (json['servings'] as num).toInt(),
  calories: (json['calories'] as num).toDouble(),
  proteinG: (json['protein_g'] as num).toDouble(),
  fatG: (json['fat_g'] as num).toDouble(),
  carbsG: (json['carbs_g'] as num).toDouble(),
  isFavorite: json['is_favorite'] as bool,
  steps: (json['steps'] as List<dynamic>)
      .map((e) => CookingStep.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'cooking_time_minutes': instance.cookingTimeMinutes,
  'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
  'servings': instance.servings,
  'calories': instance.calories,
  'protein_g': instance.proteinG,
  'fat_g': instance.fatG,
  'carbs_g': instance.carbsG,
  'is_favorite': instance.isFavorite,
  'steps': instance.steps.map((e) => e.toJson()).toList(),
};

const _$DifficultyEnumMap = {
  Difficulty.easy: 'easy',
  Difficulty.medium: 'medium',
  Difficulty.hard: 'hard',
};
