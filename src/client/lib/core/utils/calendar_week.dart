/// Local calendar helpers for week strip (Monday–Sunday) and date-only comparisons.
abstract final class CalendarWeek {
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime todayDateOnly() => dateOnly(DateTime.now());

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isPastDay(DateTime day) => dateOnly(day).isBefore(todayDateOnly());

  static bool isFutureDay(DateTime day) => dateOnly(day).isAfter(todayDateOnly());

  /// Monday of the ISO week containing [anyDay] (local calendar).
  static DateTime mondayOfWeek(DateTime anyDay) {
    final d = dateOnly(anyDay);
    return d.subtract(Duration(days: d.weekday - DateTime.monday));
  }

  /// Seven local dates: Mon … Sun for the week containing [anyDay].
  static List<DateTime> weekDaysMondayFirst(DateTime anyDay) {
    final mon = mondayOfWeek(anyDay);
    return List.generate(7, (i) => mon.add(Duration(days: i)));
  }

  /// Whole weeks between two Mondays (can be negative).
  static int weeksBetweenMondays(DateTime mondayA, DateTime mondayB) {
    return mondayB.difference(mondayA).inDays ~/ 7;
  }

  static DateTime pickDefaultSelectedDate({
    required List<DateTime> sortedPlanDays,
    required DateTime today,
  }) {
    if (sortedPlanDays.isEmpty) return dateOnly(today);
    final t = dateOnly(today);
    final first = dateOnly(sortedPlanDays.first);
    final last = dateOnly(sortedPlanDays.last);
    if (!t.isBefore(first) && !t.isAfter(last)) {
      return t;
    }
    if (t.isBefore(first)) return first;
    return last;
  }
}
