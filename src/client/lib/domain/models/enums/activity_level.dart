import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
  veryActive,
}
