import 'package:equatable/equatable.dart';

import 'package:client/domain/models/cooking_step.dart';
import 'package:client/domain/models/recipe.dart';

sealed class CookingModeState extends Equatable {
  const CookingModeState();

  @override
  List<Object?> get props => [];
}

final class CookingModeInitial extends CookingModeState {
  const CookingModeInitial();
}

final class CookingModeActive extends CookingModeState {
  const CookingModeActive({
    required this.recipe,
    required this.steps,
    required this.stepIndex,
  });

  final Recipe recipe;
  final List<CookingStep> steps;
  final int stepIndex;

  int get totalSteps => steps.length;
  CookingStep get currentStep => steps[stepIndex];

  @override
  List<Object?> get props => [recipe, steps, stepIndex];
}

final class CookingModeTimerRunning extends CookingModeState {
  const CookingModeTimerRunning({
    required this.recipe,
    required this.steps,
    required this.stepIndex,
    required this.remainingSeconds,
  });

  final Recipe recipe;
  final List<CookingStep> steps;
  final int stepIndex;
  final int remainingSeconds;

  @override
  List<Object?> get props => [recipe, steps, stepIndex, remainingSeconds];
}

final class CookingModeCompleted extends CookingModeState {
  const CookingModeCompleted({required this.recipe});

  final Recipe recipe;

  @override
  List<Object?> get props => [recipe];
}
