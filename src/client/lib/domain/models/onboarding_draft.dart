import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/activity_level.dart';
import 'enums/gender.dart';
import 'enums/goal.dart';

part 'onboarding_draft.freezed.dart';

@freezed
abstract class OnboardingDraft with _$OnboardingDraft {
  const factory OnboardingDraft({
    @Default('') String name,
    Gender? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    Goal? goal,
    ActivityLevel? activityLevel,
    @Default(<String>[]) List<String> allergyTags,
    @Default('') String allergiesOther,
  }) = _OnboardingDraft;
}
