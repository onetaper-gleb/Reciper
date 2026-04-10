import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_statistics.freezed.dart';

@freezed
abstract class ProgressStatistics with _$ProgressStatistics {
  const factory ProgressStatistics({
    /// Local calendar days from active plan start through min(plan end, today), inclusive.
    required int daysOnPlan,

    /// Meals marked as cooked (`Meals.isDone`), all plans.
    required int mealsCooked,

    /// Consecutive local days (from today backward) on the active plan where every meal is done.
    required int consecutiveFullPlanDays,

    /// Mean kcal from **done** meals only, over **past** local plan days (before today) of the active plan.
    double? averageConsumedKcalPastDays,
  }) = _ProgressStatistics;
}
