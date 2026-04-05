// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fridge_scan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FridgeScan _$FridgeScanFromJson(Map<String, dynamic> json) => _FridgeScan(
  id: (json['id'] as num).toInt(),
  photoPath: json['photo_path'] as String,
  scanDate: DateTime.parse(json['scan_date'] as String),
  productCount: (json['product_count'] as num).toInt(),
);

Map<String, dynamic> _$FridgeScanToJson(_FridgeScan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'photo_path': instance.photoPath,
      'scan_date': instance.scanDate.toIso8601String(),
      'product_count': instance.productCount,
    };
