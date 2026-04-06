import 'package:freezed_annotation/freezed_annotation.dart';

part 'replace_meal_request_dto.freezed.dart';
part 'replace_meal_request_dto.g.dart';

@freezed
abstract class ReplaceMealRequestDto with _$ReplaceMealRequestDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ReplaceMealRequestDto({
    required String mealType,
    required Map<String, dynamic> currentRecipe,
    required String reason,
    String? additionalInfo,
    required Map<String, dynamic> dayContext,
    required Map<String, dynamic> preferences,
    required List<Map<String, dynamic>> fridgeProducts,
  }) = _ReplaceMealRequestDto;

  factory ReplaceMealRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ReplaceMealRequestDtoFromJson(json);
}

