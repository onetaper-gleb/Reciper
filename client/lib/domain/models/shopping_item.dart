import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_item.freezed.dart';
part 'shopping_item.g.dart';

@freezed
abstract class ShoppingItem with _$ShoppingItem {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory ShoppingItem({
    required int id,
    required int mealPlanId,
    required String name,
    required double amount,
    required String unit,
    required String category,
    required bool purchased,
    required bool inFridge,
  }) = _ShoppingItem;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);
}
