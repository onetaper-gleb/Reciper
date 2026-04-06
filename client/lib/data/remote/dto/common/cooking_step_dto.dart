import 'package:freezed_annotation/freezed_annotation.dart';

part 'cooking_step_dto.freezed.dart';
part 'cooking_step_dto.g.dart';

@freezed
abstract class CookingStepDto with _$CookingStepDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CookingStepDto({
    required int order,
    required String description,
    int? timerSeconds,
  }) = _CookingStepDto;

  factory CookingStepDto.fromJson(Map<String, dynamic> json) =>
      _$CookingStepDtoFromJson(json);
}

