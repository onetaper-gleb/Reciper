import 'package:drift/drift.dart';

import '../db_enums.dart';

class DietTypeConverter extends TypeConverter<DbDietType, int> {
  const DietTypeConverter();

  @override
  DbDietType fromSql(int fromDb) => DbDietType.values[fromDb];

  @override
  int toSql(DbDietType value) => value.index;
}
