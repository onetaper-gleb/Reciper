import 'package:client/data/local/db/app_database.dart';
import 'package:client/domain/models/enums/weight_history_period.dart';
import 'package:client/domain/models/progress_statistics.dart';
import 'package:client/domain/models/weight_entry.dart';

class ProgressRepository {
  ProgressRepository({required AppDatabase database}) : _db = database;

  final AppDatabase _db;

  Future<int> addWeightEntry(double weightKg, DateTime date) {
    return _db.progressDao.insertWeightEntry(
      WeightEntriesCompanion.insert(
        weightKg: weightKg,
        entryDate: date,
      ),
    );
  }

  Future<List<WeightEntry>> getWeightHistory(
    WeightHistoryPeriod period, {
    DateTime? now,
  }) async {
    final effective = now ?? DateTime.now();
    final cutoff = effective.subtract(period.lookback);
    final rows = await _db.progressDao.getAllWeightEntries();
    final mapped = rows
        .map(
          (r) => WeightEntry(
            id: r.id,
            weightKg: r.weightKg,
            entryDate: r.entryDate,
          ),
        )
        .where((e) => !e.entryDate.isBefore(cutoff))
        .toList();
    mapped.sort((a, b) => a.entryDate.compareTo(b.entryDate));
    return mapped;
  }

  /// [referenceUtc] — optional clock for tests (wall time as returned by `DateTime` in app).
  Future<ProgressStatistics> getStatistics({DateTime? referenceUtc}) async {
    final now = referenceUtc ?? DateTime.now();
    final todayLocal = _localCalendarDate(now);

    final meals = await _db.mealPlanDao.getAllMeals();
    final mealsCooked = meals.where((m) => m.isDone).length;

    final planRows = await _db.mealPlanDao.getAllMealPlans();
    final activePlans = planRows.where((p) => p.isActive).toList();
    final recipeRows = await _db.recipeDao.getAllRecipes();
    final recipeCalories = {for (final r in recipeRows) r.id: r.calories};

    if (activePlans.isEmpty) {
      return ProgressStatistics(
        daysOnPlan: 0,
        mealsCooked: mealsCooked,
        consecutiveFullPlanDays: 0,
        averageConsumedKcalPastDays: null,
      );
    }

    final active = activePlans.first;
    final allDayRows = await _db.mealPlanDao.getAllDayPlans();
    final activeDayRows =
        allDayRows.where((d) => d.mealPlanId == active.id).toList();

    final startLocal = _localCalendarDate(active.startDate);
    final endLocal = _localCalendarDate(active.endDate);

    var daysOnPlan = 0;
    if (!todayLocal.isBefore(startLocal)) {
      final cap = endLocal.isBefore(todayLocal) ? endLocal : todayLocal;
      if (!cap.isBefore(startLocal)) {
        daysOnPlan = cap.difference(startLocal).inDays + 1;
      }
    }

    final dayIdToLocal = {
      for (final d in activeDayRows) d.id: _localCalendarDate(d.planDate),
    };

    final mealsByLocalDay = <DateTime, List<({bool isDone, double kcal})>>{};
    for (final m in meals) {
      final ld = dayIdToLocal[m.dayPlanId];
      if (ld == null) continue;
      final kcal = recipeCalories[m.recipeId] ?? 0;
      mealsByLocalDay.putIfAbsent(ld, () => []).add((isDone: m.isDone, kcal: kcal));
    }

    final consecutiveFullPlanDays = _consecutiveFullPlanStreak(
      todayLocal: todayLocal,
      mealsByLocalDay: mealsByLocalDay,
    );

    double sumConsumedPast = 0;
    var pastPlanDayCount = 0;
    for (final day in activeDayRows) {
      final ld = _localCalendarDate(day.planDate);
      if (!ld.isBefore(todayLocal)) continue;
      pastPlanDayCount++;
      final dayMeals = mealsByLocalDay[ld];
      if (dayMeals == null) continue;
      for (final e in dayMeals) {
        if (e.isDone) sumConsumedPast += e.kcal;
      }
    }

    final averageConsumedKcalPastDays = pastPlanDayCount > 0
        ? sumConsumedPast / pastPlanDayCount
        : null;

    return ProgressStatistics(
      daysOnPlan: daysOnPlan,
      mealsCooked: mealsCooked,
      consecutiveFullPlanDays: consecutiveFullPlanDays,
      averageConsumedKcalPastDays: averageConsumedKcalPastDays,
    );
  }

  /// Local calendar date (no time, no UTC shift for display math).
  static DateTime _localCalendarDate(DateTime dt) {
    final l = dt.toLocal();
    return DateTime(l.year, l.month, l.day);
  }

  /// From [todayLocal] backward: only days that have ≥1 meal in the map; all must be done.
  static int _consecutiveFullPlanStreak({
    required DateTime todayLocal,
    required Map<DateTime, List<({bool isDone, double kcal})>> mealsByLocalDay,
  }) {
    var streak = 0;
    var d = todayLocal;
    for (var i = 0; i < 800; i++) {
      final list = mealsByLocalDay[d];
      if (list == null || list.isEmpty) {
        break;
      }
      final allDone = list.every((e) => e.isDone);
      if (!allDone) {
        break;
      }
      streak++;
      d = d.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
