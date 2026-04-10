import 'package:equatable/equatable.dart';

import 'package:client/domain/models/enums/weight_history_period.dart';

sealed class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

final class ProgressLoadRequested extends ProgressEvent {
  const ProgressLoadRequested();
}

final class ProgressWeightPeriodChanged extends ProgressEvent {
  const ProgressWeightPeriodChanged(this.period);

  final WeightHistoryPeriod period;

  @override
  List<Object?> get props => [period];
}

final class WeightEntryAdded extends ProgressEvent {
  const WeightEntryAdded({required this.weightKg, required this.date});

  final double weightKg;
  final DateTime date;

  @override
  List<Object?> get props => [weightKg, date];
}
