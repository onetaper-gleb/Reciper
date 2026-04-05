// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fridge_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FridgeProduct _$FridgeProductFromJson(Map<String, dynamic> json) =>
    _FridgeProduct(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
      addedAt: json['added_at'] == null
          ? null
          : DateTime.parse(json['added_at'] as String),
    );

Map<String, dynamic> _$FridgeProductToJson(_FridgeProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'unit': instance.unit,
      'category': instance.category,
      'added_at': instance.addedAt?.toIso8601String(),
    };
