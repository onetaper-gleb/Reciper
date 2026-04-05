import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_entry.freezed.dart';
part 'weight_entry.g.dart';

@freezed
abstract class WeightEntry with _$WeightEntry {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory WeightEntry({
    required int id,
    required double weightKg,
    required DateTime entryDate,
  }) = _WeightEntry;

  factory WeightEntry.fromJson(Map<String, dynamic> json) =>
      _$WeightEntryFromJson(json);
}
