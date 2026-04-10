import 'package:flutter_test/flutter_test.dart';

import 'package:client/core/utils/weight_trend_label.dart';
import 'package:client/domain/models/weight_entry.dart';

void main() {
  test('weightTrendLabel needs at least two points', () {
    expect(
      weightTrendLabel([
        WeightEntry(id: 1, weightKg: 80, entryDate: _d(1)),
      ]),
      'Недостаточно данных для тренда',
    );
  });

  test('weightTrendLabel reports loss', () {
    final s = weightTrendLabel([
      WeightEntry(id: 1, weightKg: 82, entryDate: _d(1)),
      WeightEntry(id: 2, weightKg: 80, entryDate: _d(2)),
    ]);
    expect(s, contains('Снижение'));
  });

  test('weightTrendLabel reports gain', () {
    final s = weightTrendLabel([
      WeightEntry(id: 1, weightKg: 80, entryDate: _d(1)),
      WeightEntry(id: 2, weightKg: 81, entryDate: _d(2)),
    ]);
    expect(s, contains('Рост'));
  });
}

DateTime _d(int day) => DateTime.utc(2026, 4, day);
