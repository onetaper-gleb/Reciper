import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition.freezed.dart';
part 'nutrition.g.dart';

@freezed
abstract class Nutrition with _$Nutrition {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Nutrition({
    required double dailyCalories,
    required double proteinG,
    required double fatG,
    required double carbsG,
  }) = _Nutrition;

  factory Nutrition.fromJson(Map<String, dynamic> json) =>
      _$NutritionFromJson(json);
}
