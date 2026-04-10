import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

@freezed
abstract class Ingredient with _$Ingredient {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Ingredient({
    required int id,
    required int recipeId,
    required String name,
    required double amount,
    required String unit,
    required String category,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}
