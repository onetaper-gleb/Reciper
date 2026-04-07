import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/utils/app_logger.dart';
import 'package:client/data/repository/meal_plan_repository.dart';
import 'meal_plan_event.dart';
import 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  MealPlanBloc({required MealPlanRepository mealPlanRepository})
      : _repo = mealPlanRepository,
        super(const MealPlanInitial()) {
    on<MealPlanLoadRequested>(_onLoadRequested);
    on<DaySelected>(_onDaySelected);
    on<MealCompleted>(_onMealCompleted);
    on<MealReplaceRequested>(_onMealReplaceRequested);
  }

  final MealPlanRepository _repo;

  Future<void> _onLoadRequested(
    MealPlanLoadRequested event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(const MealPlanLoading());
    try {
      final active = await _repo.getActivePlan();
      if (active == null) {
        emit(const MealPlanEmpty());
        return;
      }
      final selectedDate = active.days.isNotEmpty ? active.days.first.date : DateTime.now();
      final selectedDay = active.days.isNotEmpty ? active.days.first : null;
      emit(
        MealPlanLoaded(
          plan: active,
          selectedDate: selectedDate,
          dayPlan: selectedDay,
        ),
      );
    } catch (e, st) {
      AppLogger.warning('MealPlanBloc: load failed', e, st);
      emit(MealPlanError('$e'));
    }
  }

  Future<void> _onDaySelected(
    DaySelected event,
    Emitter<MealPlanState> emit,
  ) async {
    final current = state;
    if (current is! MealPlanLoaded) return;
    final day = current.plan.days
        .where((d) => d.date.year == event.date.year && d.date.month == event.date.month && d.date.day == event.date.day)
        .cast()
        .toList();
    emit(
      MealPlanLoaded(
        plan: current.plan,
        selectedDate: event.date,
        dayPlan: day.isNotEmpty ? day.first : null,
      ),
    );
  }

  Future<void> _onMealCompleted(
    MealCompleted event,
    Emitter<MealPlanState> emit,
  ) async {
    await _repo.markMealCompleted(event.mealId);
    add(const MealPlanLoadRequested());
  }

  Future<void> _onMealReplaceRequested(
    MealReplaceRequested event,
    Emitter<MealPlanState> emit,
  ) async {
    final current = state;
    if (current is! MealPlanLoaded) return;
    emit(MealReplacingInProgress(mealId: event.mealId, previous: current));
    try {
      await _repo.replaceMeal(
        mealId: event.mealId,
        requestJson: {
          'meal_type': 'snack',
          'current_recipe': {'name': 'Current meal'},
          'reason': event.reason,
          'additional_info': event.notes,
          'day_context': {'remaining_calories': 1000},
          'preferences': {},
          'fridge_products': const [],
        },
      );
      add(const MealPlanLoadRequested());
    } catch (e, st) {
      AppLogger.warning('MealPlanBloc: replace failed', e, st);
      emit(MealPlanError('$e'));
    }
  }
}

