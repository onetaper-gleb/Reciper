// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    _UserPreferences(
      id: (json['id'] as num).toInt(),
      allergies:
          (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      dislikedProducts:
          (json['disliked_products'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      likedProducts:
          (json['liked_products'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      maxCookingMinutes: (json['max_cooking_minutes'] as num).toInt(),
      budget: $enumDecode(_$BudgetLevelEnumMap, json['budget']),
      dietType: $enumDecode(_$DietTypeEnumMap, json['diet_type']),
    );

Map<String, dynamic> _$UserPreferencesToJson(_UserPreferences instance) =>
    <String, dynamic>{
      'id': instance.id,
      'allergies': instance.allergies,
      'disliked_products': instance.dislikedProducts,
      'liked_products': instance.likedProducts,
      'max_cooking_minutes': instance.maxCookingMinutes,
      'budget': _$BudgetLevelEnumMap[instance.budget]!,
      'diet_type': _$DietTypeEnumMap[instance.dietType]!,
    };

const _$BudgetLevelEnumMap = {
  BudgetLevel.low: 'low',
  BudgetLevel.medium: 'medium',
  BudgetLevel.high: 'high',
};

const _$DietTypeEnumMap = {
  DietType.omnivore: 'omnivore',
  DietType.vegetarian: 'vegetarian',
  DietType.vegan: 'vegan',
  DietType.keto: 'keto',
};
