import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_dto.freezed.dart';
part 'nutrition_dto.g.dart';

@freezed
abstract class NutritionDto with _$NutritionDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory NutritionDto({
    required double calories,
    required double proteinG,
    required double fatG,
    required double carbsG,
  }) = _NutritionDto;

  factory NutritionDto.fromJson(Map<String, dynamic> json) =>
      _$NutritionDtoFromJson(json);
}

