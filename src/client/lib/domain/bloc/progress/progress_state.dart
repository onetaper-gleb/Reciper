import 'package:equatable/equatable.dart';

import 'package:client/domain/models/enums/weight_history_period.dart';
import 'package:client/domain/models/progress_statistics.dart';
import 'package:client/domain/models/weight_entry.dart';

sealed class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

final class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

final class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

final class ProgressLoaded extends ProgressState {
  const ProgressLoaded({
    required this.weightHistory,
    required this.statistics,
    required this.trend,
    required this.weightPeriod,
  });

  final List<WeightEntry> weightHistory;
  final ProgressStatistics statistics;
  final String trend;
  final WeightHistoryPeriod weightPeriod;

  @override
  List<Object?> get props => [weightHistory, statistics, trend, weightPeriod];
}

final class ProgressError extends ProgressState {
  const ProgressError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
