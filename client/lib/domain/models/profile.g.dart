// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  age: (json['age'] as num).toInt(),
  heightCm: (json['height_cm'] as num).toDouble(),
  weightKg: (json['weight_kg'] as num).toDouble(),
  targetWeightKg: (json['target_weight_kg'] as num).toDouble(),
  goal: $enumDecode(_$GoalEnumMap, json['goal']),
  activityLevel: $enumDecode(_$ActivityLevelEnumMap, json['activity_level']),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'gender': _$GenderEnumMap[instance.gender]!,
  'age': instance.age,
  'height_cm': instance.heightCm,
  'weight_kg': instance.weightKg,
  'target_weight_kg': instance.targetWeightKg,
  'goal': _$GoalEnumMap[instance.goal]!,
  'activity_level': _$ActivityLevelEnumMap[instance.activityLevel]!,
};

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

const _$GoalEnumMap = {
  Goal.loseWeight: 'lose_weight',
  Goal.maintain: 'maintain',
  Goal.gainMuscle: 'gain_muscle',
  Goal.cutting: 'cutting',
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.sedentary: 'sedentary',
  ActivityLevel.light: 'light',
  ActivityLevel.moderate: 'moderate',
  ActivityLevel.active: 'active',
  ActivityLevel.veryActive: 'very_active',
};
