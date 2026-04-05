// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CookingStep _$CookingStepFromJson(Map<String, dynamic> json) => _CookingStep(
  order: (json['order'] as num).toInt(),
  instruction: json['instruction'] as String,
  durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$CookingStepToJson(_CookingStep instance) =>
    <String, dynamic>{
      'order': instance.order,
      'instruction': instance.instruction,
      'duration_seconds': instance.durationSeconds,
    };
