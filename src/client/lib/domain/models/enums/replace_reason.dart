import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum ReplaceReason {
  notHungry,
  allergic,
  missingIngredients,
  preferOther,
  other,
}
