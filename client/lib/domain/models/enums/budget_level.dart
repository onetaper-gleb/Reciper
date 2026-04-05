import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum BudgetLevel {
  low,
  medium,
  high,
}
