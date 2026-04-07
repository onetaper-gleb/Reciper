import 'package:equatable/equatable.dart';

sealed class MealPlanEvent extends Equatable {
  const MealPlanEvent();

  @override
  List<Object?> get props => [];
}

final class MealPlanLoadRequested extends MealPlanEvent {
  const MealPlanLoadRequested();
}

final class DaySelected extends MealPlanEvent {
  const DaySelected(this.date);
  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class MealReplaceRequested extends MealPlanEvent {
  const MealReplaceRequested({required this.mealId, required this.reason, this.notes});
  final int mealId;
  final String reason;
  final String? notes;

  @override
  List<Object?> get props => [mealId, reason, notes];
}

final class MealCompleted extends MealPlanEvent {
  const MealCompleted(this.mealId);
  final int mealId;

  @override
  List<Object?> get props => [mealId];
}

