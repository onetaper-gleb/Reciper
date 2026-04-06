import 'package:equatable/equatable.dart';

import 'package:client/domain/models/onboarding_draft.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

final class OnboardingDraftUpdated extends OnboardingEvent {
  const OnboardingDraftUpdated(this.draft);

  final OnboardingDraft draft;

  @override
  List<Object?> get props => [draft];
}

/// Recalculates [Nutrition] preview for the summary step from the current draft.
final class OnboardingPrepareSummary extends OnboardingEvent {
  const OnboardingPrepareSummary();
}

final class OnboardingFinished extends OnboardingEvent {
  const OnboardingFinished();
}
