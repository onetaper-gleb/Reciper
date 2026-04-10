import 'package:freezed_annotation/freezed_annotation.dart';

part 'cooking_step.freezed.dart';
part 'cooking_step.g.dart';

@freezed
abstract class CookingStep with _$CookingStep {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory CookingStep({
    required int order,
    required String instruction,
    int? durationSeconds,
  }) = _CookingStep;

  factory CookingStep.fromJson(Map<String, dynamic> json) =>
      _$CookingStepFromJson(json);
}
