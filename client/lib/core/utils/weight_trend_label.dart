import 'package:client/domain/models/weight_entry.dart';

/// Short Russian label for weight change across sorted history.
String weightTrendLabel(List<WeightEntry> entries) {
  if (entries.length < 2) {
    return 'Недостаточно данных для тренда';
  }
  final sorted = [...entries]..sort((a, b) => a.entryDate.compareTo(b.entryDate));
  final first = sorted.first.weightKg;
  final last = sorted.last.weightKg;
  final delta = last - first;
  if (delta.abs() < 0.05) {
    return 'Вес стабилен';
  }
  if (delta < 0) {
    return 'Снижение на ${delta.abs().toStringAsFixed(1)} кг';
  }
  return 'Рост на ${delta.toStringAsFixed(1)} кг';
}
