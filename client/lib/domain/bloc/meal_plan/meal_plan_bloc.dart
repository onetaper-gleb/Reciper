import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/errors/user_facing_error.dart';
import 'package:client/core/utils/app_logger.dart';
import 'package:client/core/utils/calendar_week.dart';
import 'package:client/core/utils/client_request_clock.dart';
import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/domain/models/day_plan.dart';
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
      final sortedDayDates = active.days.map((e) => e.date).toList()
        ..sort(
          (a, b) => CalendarWeek.dateOnly(a).compareTo(CalendarWeek.dateOnly(b)),
        );
      final selectedDate = CalendarWeek.pickDefaultSelectedDate(
        sortedPlanDays: sortedDayDates,
        today: DateTime.now(),
      );
      DayPlan? selectedDay;
      for (final d in active.days) {
        if (CalendarWeek.isSameDay(d.date, selectedDate)) {
          selectedDay = d;
          break;
        }
      }
      emit(
        MealPlanLoaded(
          activePlan: active,
          plan: active,
          selectedDate: selectedDate,
          dayPlan: selectedDay,
        ),
      );
    } catch (e, st) {
      AppLogger.warning('MealPlanBloc: load failed', e, st);
      emit(MealPlanError(userFacingErrorMessage(e)));
    }
  }

  Future<void> _onDaySelected(
    DaySelected event,
    Emitter<MealPlanState> emit,
  ) async {
    final current = state;
    if (current is! MealPlanLoaded) return;

    final selected = CalendarWeek.dateOnly(event.date);
    final today = CalendarWeek.todayDateOnly();

    if (selected.isBefore(today)) {
      final hist = await _repo.getPlanCoveringDate(selected);
      if (hist != null) {
        DayPlan? histDay;
        for (final d in hist.days) {
          if (CalendarWeek.isSameDay(d.date, selected)) {
            histDay = d;
            break;
          }
        }
        emit(
          MealPlanLoaded(
            activePlan: current.activePlan,
            plan: hist,
            selectedDate: selected,
            dayPlan: histDay,
            isHistoricalView: true,
            missingHistoricalPlan: false,
          ),
        );
      } else {
        emit(
          MealPlanLoaded(
            activePlan: current.activePlan,
            plan: current.activePlan,
            selectedDate: selected,
            dayPlan: null,
            isHistoricalView: true,
            missingHistoricalPlan: true,
          ),
        );
      }
      return;
    }

    final active = await _repo.getActivePlan();
    if (active == null) {
      emit(const MealPlanEmpty());
      return;
    }

    DayPlan? activeDay;
    for (final d in active.days) {
      if (CalendarWeek.isSameDay(d.date, selected)) {
        activeDay = d;
        break;
      }
    }
    emit(
      MealPlanLoaded(
        activePlan: active,
        plan: active,
        selectedDate: selected,
        dayPlan: activeDay,
        isHistoricalView: false,
        missingHistoricalPlan: false,
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
    AppLogger.info('MealPlanBloc: _onMealReplaceRequested: ${event.mealId}');
    if (current is! MealPlanLoaded) return;
    if (current.isHistoricalView || current.missingHistoricalPlan) return;
    emit(MealReplacingInProgress(mealId: event.mealId, previous: current));
    try {
      final meal = current.activePlan.meals.where((m) => m.id == event.mealId).toList();
      final mealRow = meal.isNotEmpty ? meal.first : null;
      final recipe = () {
        if (mealRow == null) return null;
        final list =
            current.activePlan.recipes.where((r) => r.id == mealRow.recipeId).toList();
        return list.isEmpty ? null : list.first;
      }();

      final dayIds = current.activePlan.days
          .where((d) =>
              d.date.year == current.selectedDate.year &&
              d.date.month == current.selectedDate.month &&
              d.date.day == current.selectedDate.day)
          .map((d) => d.id)
          .toSet();
      final items =
          current.activePlan.meals.where((m) => dayIds.contains(m.dayPlanId)).toList();

      double sumCalories(Iterable<dynamic> meals) {
        final recipeById = {for (final r in current.activePlan.recipes) r.id: r};
        double sum = 0;
        for (final m in meals) {
          final r = recipeById[m.recipeId];
          if (r != null) sum += r.calories;
        }
        return sum;
      }

      final totalDayCalories = sumCalories(items);
      final doneDayCalories = sumCalories(items.where((m) => m.isDone));
      final remainingCalories = (totalDayCalories - doneDayCalories).clamp(200, 5000);

      final payload = {
        'meal_type': _mapMealType(mealRow?.mealType.name ?? 'snack'),
        'current_recipe': {
          'name': recipe?.title ?? 'Блюдо',
          'calories': recipe?.calories,
        },
        'reason': event.reason,
        'additional_info': event.notes,
        'day_context': {
          'remaining_calories': remainingCalories,
          'remaining_protein_g': 0,
          'remaining_fat_g': 0,
          'remaining_carbs_g': 0,
        },
        'preferences': {
          'diet_type': null,
          'allergies': const <String>[],
          'disliked_products': const <String>[],
          'favorite_products': const <String>[],
          'max_cooking_time_min': null,
          'budget_level': null,
        },
        'fridge_products': const <Map<String, dynamic>>[],
        'client_context': ClientRequestClock.clientContextJson(),
      };
      AppLogger.info('MealPlanBloc.replace payload=$payload');

      await _repo.replaceMeal(
        mealId: event.mealId,
        requestJson: payload,
      );
      add(const MealPlanLoadRequested());
    } catch (e, st) {
      AppLogger.warning('MealPlanBloc: replace failed', e, st);
      emit(
        MealPlanOperationError(
          previous: current,
          message: userFacingErrorMessage(e),
        ),
      );
    }
  }

  String _mapMealType(String mealType) {
    return switch (mealType) {
      'breakfast' => 'breakfast',
      'lunch' => 'lunch',
      'dinner' => 'dinner',
      // backend schema uses examples snack_1/snack_2, but accepts string — use snack_1
      _ => 'snack_1',
    };
  }
}

