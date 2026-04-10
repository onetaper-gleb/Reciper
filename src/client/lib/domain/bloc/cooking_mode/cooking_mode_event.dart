import 'package:equatable/equatable.dart';

import 'package:client/domain/models/recipe.dart';

sealed class CookingModeEvent extends Equatable {
  const CookingModeEvent();

  @override
  List<Object?> get props => [];
}

enum CookingVoiceKind { next, previous, repeat }

final class CookingStarted extends CookingModeEvent {
  const CookingStarted(this.recipe);
  final Recipe recipe;

  @override
  List<Object?> get props => [recipe];
}

final class NextStepRequested extends CookingModeEvent {
  const NextStepRequested();
}

final class PreviousStepRequested extends CookingModeEvent {
  const PreviousStepRequested();
}

final class RepeatStepRequested extends CookingModeEvent {
  const RepeatStepRequested();
}

final class TimerStarted extends CookingModeEvent {
  const TimerStarted({required this.seconds});
  final int seconds;

  @override
  List<Object?> get props => [seconds];
}

final class VoiceCommandReceived extends CookingModeEvent {
  const VoiceCommandReceived(this.kind);
  final CookingVoiceKind kind;

  @override
  List<Object?> get props => [kind];
}

/// Emitted by periodic timer; not used from UI.
final class CookingTimerTicked extends CookingModeEvent {
  const CookingTimerTicked();
}
