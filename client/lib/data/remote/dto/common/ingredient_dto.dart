import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_dto.freezed.dart';
part 'ingredient_dto.g.dart';

@freezed
abstract class IngredientDto with _$IngredientDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory IngredientDto({
    required String name,
    required double amount,
    required String unit,
    String? category,
  }) = _IngredientDto;

  factory IngredientDto.fromJson(Map<String, dynamic> json) =>
      _$IngredientDtoFromJson(json);
}

