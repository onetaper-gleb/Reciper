import 'package:freezed_annotation/freezed_annotation.dart';

part 'generate_meal_plan_request_dto.freezed.dart';
part 'generate_meal_plan_request_dto.g.dart';

@freezed
abstract class GenerateMealPlanRequestDto with _$GenerateMealPlanRequestDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory GenerateMealPlanRequestDto({
    required Map<String, dynamic> profile,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> planOptions,
    required List<Map<String, dynamic>> fridgeProducts,
    String? additionalNotes,
    @JsonKey(name: 'client_context') Map<String, dynamic>? clientContext,
  }) = _GenerateMealPlanRequestDto;

  factory GenerateMealPlanRequestDto.fromJson(Map<String, dynamic> json) =>
      _$GenerateMealPlanRequestDtoFromJson(json);
}

