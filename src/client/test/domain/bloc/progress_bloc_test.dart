import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/repository/progress_repository.dart';
import 'package:client/domain/bloc/progress/progress_bloc.dart';
import 'package:client/domain/bloc/progress/progress_event.dart';
import 'package:client/domain/bloc/progress/progress_state.dart';
import 'package:client/domain/models/enums/weight_history_period.dart';
import 'package:client/domain/models/progress_statistics.dart';

void main() {
  late AppDatabase db;
  late ProgressRepository repository;

  setUp(() {
    db = AppDatabase.test();
    repository = ProgressRepository(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  blocTest<ProgressBloc, ProgressState>(
    'ProgressLoadRequested emits ProgressLoaded',
    build: () => ProgressBloc(repository),
    act: (bloc) => bloc.add(const ProgressLoadRequested()),
    expect: () => [
      const ProgressLoading(),
      predicate<ProgressState>((s) {
        if (s is! ProgressLoaded) return false;
        return s.weightPeriod == WeightHistoryPeriod.days30 &&
            s.statistics.daysOnPlan == 0;
      }),
    ],
  );

  blocTest<ProgressBloc, ProgressState>(
    'WeightEntryAdded refreshes history',
    build: () => ProgressBloc(repository),
    seed: () =>       const ProgressLoaded(
      weightHistory: [],
      statistics: ProgressStatistics(
        daysOnPlan: 0,
        mealsCooked: 0,
        consecutiveFullPlanDays: 0,
        averageConsumedKcalPastDays: null,
      ),
      trend: 'Недостаточно данных для тренда',
      weightPeriod: WeightHistoryPeriod.days30,
    ),
    act: (bloc) => bloc.add(
      WeightEntryAdded(
        weightKg: 70,
        date: DateTime.utc(2026, 4, 10),
      ),
    ),
    expect: () => [
      predicate<ProgressState>((s) {
        if (s is! ProgressLoaded) return false;
        return s.weightHistory.length == 1 && s.weightHistory.first.weightKg == 70;
      }),
    ],
  );
}
