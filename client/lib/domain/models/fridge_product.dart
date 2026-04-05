import 'package:freezed_annotation/freezed_annotation.dart';

part 'fridge_product.freezed.dart';
part 'fridge_product.g.dart';

@freezed
abstract class FridgeProduct with _$FridgeProduct {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory FridgeProduct({
    required int id,
    required String name,
    required double amount,
    required String unit,
    required String category,
    DateTime? addedAt,
  }) = _FridgeProduct;

  factory FridgeProduct.fromJson(Map<String, dynamic> json) =>
      _$FridgeProductFromJson(json);
}
