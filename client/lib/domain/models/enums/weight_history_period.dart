/// Range for the profile weight chart (approximate calendar lengths).
enum WeightHistoryPeriod {
  days30,
  months3,
  months6,
  year1,
}

extension WeightHistoryPeriodX on WeightHistoryPeriod {
  String get labelRu => switch (this) {
        WeightHistoryPeriod.days30 => '30 дн.',
        WeightHistoryPeriod.months3 => '3 мес.',
        WeightHistoryPeriod.months6 => '6 мес.',
        WeightHistoryPeriod.year1 => 'Год',
      };

  Duration get lookback => switch (this) {
        WeightHistoryPeriod.days30 => const Duration(days: 30),
        WeightHistoryPeriod.months3 => const Duration(days: 90),
        WeightHistoryPeriod.months6 => const Duration(days: 180),
        WeightHistoryPeriod.year1 => const Duration(days: 365),
      };
}
