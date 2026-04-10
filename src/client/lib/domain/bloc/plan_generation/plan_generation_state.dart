import 'package:equatable/equatable.dart';

import 'package:client/data/repository/meal_plan_repository.dart';

sealed class PlanGenerationState extends Equatable {
  const PlanGenerationState();

  @override
  List<Object?> get props => [];
}

final class PlanGenerationStepState extends PlanGenerationState {
  const PlanGenerationStepState({
    required this.currentStep,
    required this.collectedData,
  });

  final String currentStep;
  final Map<String, dynamic> collectedData;

  @override
  List<Object?> get props => [currentStep, collectedData];
}

final class PlanGenerating extends PlanGenerationState {
  const PlanGenerating(this.collectedData);

  final Map<String, dynamic> collectedData;

  @override
  List<Object?> get props => [collectedData];
}

final class PlanGenerated extends PlanGenerationState {
  const PlanGenerated({required this.plan});

  final StoredMealPlanGraph plan;

  @override
  List<Object?> get props => [plan];
}

final class PlanGenerationError extends PlanGenerationState {
  const PlanGenerationError(this.message, {required this.collectedData});

  final String message;
  final Map<String, dynamic> collectedData;

  @override
  List<Object?> get props => [message, collectedData];
}

