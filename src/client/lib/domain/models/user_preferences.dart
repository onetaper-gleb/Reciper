import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/budget_level.dart';
import 'enums/diet_type.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

@freezed
abstract class UserPreferences with _$UserPreferences {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory UserPreferences({
    required int id,
    @Default(<String>[]) List<String> allergies,
    @Default(<String>[]) List<String> dislikedProducts,
    @Default(<String>[]) List<String> likedProducts,
    required int maxCookingMinutes,
    required BudgetLevel budget,
    required DietType dietType,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
