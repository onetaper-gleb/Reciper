import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum Goal {
  loseWeight,
  maintain,
  gainMuscle,
}
