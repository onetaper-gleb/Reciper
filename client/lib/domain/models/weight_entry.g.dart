// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeightEntry _$WeightEntryFromJson(Map<String, dynamic> json) => _WeightEntry(
  id: (json['id'] as num).toInt(),
  weightKg: (json['weight_kg'] as num).toDouble(),
  entryDate: DateTime.parse(json['entry_date'] as String),
);

Map<String, dynamic> _$WeightEntryToJson(_WeightEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weight_kg': instance.weightKg,
      'entry_date': instance.entryDate.toIso8601String(),
    };
