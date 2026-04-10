import 'package:equatable/equatable.dart';

import 'package:client/domain/models/nutrition.dart';
import 'package:client/domain/models/onboarding_draft.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

final class OnboardingEditing extends OnboardingState {
  const OnboardingEditing(
    this.draft, {
    this.nutritionPreview,
    this.errorMessage,
  });

  final OnboardingDraft draft;
  final Nutrition? nutritionPreview;
  final String? errorMessage;

  @override
  List<Object?> get props => [draft, nutritionPreview, errorMessage];
}

final class OnboardingSubmitting extends OnboardingState {
  const OnboardingSubmitting();
}

final class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}
