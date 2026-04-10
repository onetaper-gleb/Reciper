import 'package:drift/drift.dart';

import '../db_enums.dart';

class MealTypeConverter extends TypeConverter<DbMealType, int> {
  const MealTypeConverter();

  @override
  DbMealType fromSql(int fromDb) => DbMealType.values[fromDb];

  @override
  int toSql(DbMealType value) => value.index;
}
