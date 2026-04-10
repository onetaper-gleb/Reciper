import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/utils/app_logger.dart';
import 'package:client/core/utils/weight_trend_label.dart';
import 'package:client/data/repository/progress_repository.dart';
import 'package:client/domain/bloc/progress/progress_event.dart';
import 'package:client/domain/bloc/progress/progress_state.dart';
import 'package:client/domain/models/enums/weight_history_period.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc(this._repository) : super(const ProgressInitial()) {
    on<ProgressLoadRequested>(_onLoadRequested);
    on<ProgressWeightPeriodChanged>(_onPeriodChanged);
    on<WeightEntryAdded>(_onWeightAdded);
  }

  final ProgressRepository _repository;

  Future<void> _onLoadRequested(
    ProgressLoadRequested event,
    Emitter<ProgressState> emit,
  ) async {
    emit(const ProgressLoading());
    try {
      await _emitLoaded(emit, WeightHistoryPeriod.days30);
    } catch (e, st) {
      AppLogger.warning('ProgressBloc: load failed', e, st);
      emit(ProgressError('$e'));
    }
  }

  Future<void> _onPeriodChanged(
    ProgressWeightPeriodChanged event,
    Emitter<ProgressState> emit,
  ) async {
    final current = state;
    if (current is! ProgressLoaded) {
      add(const ProgressLoadRequested());
      return;
    }
    try {
      final history = await _repository.getWeightHistory(event.period);
      emit(
        ProgressLoaded(
          weightHistory: history,
          statistics: current.statistics,
          trend: weightTrendLabel(history),
          weightPeriod: event.period,
        ),
      );
    } catch (e, st) {
      AppLogger.warning('ProgressBloc: period change failed', e, st);
      emit(ProgressError('$e'));
    }
  }

  Future<void> _onWeightAdded(
    WeightEntryAdded event,
    Emitter<ProgressState> emit,
  ) async {
    final current = state;
    final period = current is ProgressLoaded
        ? current.weightPeriod
        : WeightHistoryPeriod.days30;
    try {
      await _repository.addWeightEntry(event.weightKg, event.date);
      await _emitLoaded(emit, period);
    } catch (e, st) {
      AppLogger.warning('ProgressBloc: add weight failed', e, st);
      emit(ProgressError('$e'));
    }
  }

  Future<void> _emitLoaded(
    Emitter<ProgressState> emit,
    WeightHistoryPeriod period,
  ) async {
    final stats = await _repository.getStatistics();
    final history = await _repository.getWeightHistory(period);
    emit(
      ProgressLoaded(
        weightHistory: history,
        statistics: stats,
        trend: weightTrendLabel(history),
        weightPeriod: period,
      ),
    );
  }
}
