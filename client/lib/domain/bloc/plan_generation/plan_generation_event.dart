import 'package:equatable/equatable.dart';

sealed class PlanGenerationEvent extends Equatable {
  const PlanGenerationEvent();

  @override
  List<Object?> get props => [];
}

final class StepCompleted extends PlanGenerationEvent {
  const StepCompleted({required this.stepKey, required this.data});

  final String stepKey;
  final Map<String, dynamic> data;

  @override
  List<Object?> get props => [stepKey, data];
}

final class GenerationRequested extends PlanGenerationEvent {
  const GenerationRequested();
}

final class PlanAccepted extends PlanGenerationEvent {
  const PlanAccepted();
}

final class PlanRejected extends PlanGenerationEvent {
  const PlanRejected();
}

