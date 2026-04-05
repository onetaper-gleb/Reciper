import 'package:freezed_annotation/freezed_annotation.dart';

import 'cooking_step.dart';
import 'enums/difficulty.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
abstract class Recipe with _$Recipe {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Recipe({
    required int id,
    required String title,
    required int cookingTimeMinutes,
    required Difficulty difficulty,
    required int servings,
    required double calories,
    required double proteinG,
    required double fatG,
    required double carbsG,
    required bool isFavorite,
    required List<CookingStep> steps,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
