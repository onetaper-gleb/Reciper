import 'package:freezed_annotation/freezed_annotation.dart';

part 'fridge_scan.freezed.dart';
part 'fridge_scan.g.dart';

@freezed
abstract class FridgeScan with _$FridgeScan {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory FridgeScan({
    required int id,
    required String photoPath,
    required DateTime scanDate,
    required int productCount,
  }) = _FridgeScan;

  factory FridgeScan.fromJson(Map<String, dynamic> json) =>
      _$FridgeScanFromJson(json);
}
