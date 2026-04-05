import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/activity_level.dart';
import 'enums/gender.dart';
import 'enums/goal.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Profile({
    required int id,
    required String name,
    required Gender gender,
    required int age,
    required double heightCm,
    required double weightKg,
    required double targetWeightKg,
    required Goal goal,
    required ActivityLevel activityLevel,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
