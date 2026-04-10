import 'package:equatable/equatable.dart';

import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/domain/models/day_plan.dart';

sealed class MealPlanState extends Equatable {
  const MealPlanState();

  @override
  List<Object?> get props => [];
}

final class MealPlanInitial extends MealPlanState {
  const MealPlanInitial();
}

final class MealPlanLoading extends MealPlanState {
  const MealPlanLoading();
}

final class MealPlanEmpty extends MealPlanState {
  const MealPlanEmpty();
}

final class MealReplacingInProgress extends MealPlanState {
  const MealReplacingInProgress({required this.mealId, required this.previous});
  final int mealId;
  final MealPlanLoaded previous;

  @override
  List<Object?> get props => [mealId, previous];
}

final class MealPlanLoaded extends MealPlanState {
  const MealPlanLoaded({
    required this.activePlan,
    required this.plan,
    required this.selectedDate,
    this.dayPlan,
    this.isHistoricalView = false,
    this.missingHistoricalPlan = false,
  });

  /// Current active meal plan graph (mutations and “new plan” flow use this).
  final StoredMealPlanGraph activePlan;

  /// Graph shown for [selectedDate] (historical snapshot or [activePlan]).
  final StoredMealPlanGraph plan;
  final DateTime selectedDate;
  final DayPlan? dayPlan;
  final bool isHistoricalView;
  final bool missingHistoricalPlan;

  @override
  List<Object?> get props =>
      [activePlan, plan, selectedDate, dayPlan, isHistoricalView, missingHistoricalPlan];
}

final class MealPlanError extends MealPlanState {
  const MealPlanError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class MealPlanOperationError extends MealPlanState {
  const MealPlanOperationError({
    required this.previous,
    required this.message,
  });

  final MealPlanLoaded previous;
  final String message;

  @override
  List<Object?> get props => [previous, message];
}

