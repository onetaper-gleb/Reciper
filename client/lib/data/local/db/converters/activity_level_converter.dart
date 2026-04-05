import 'package:drift/drift.dart';

import '../db_enums.dart';

class ActivityLevelConverter extends TypeConverter<DbActivityLevel, int> {
  const ActivityLevelConverter();

  @override
  DbActivityLevel fromSql(int fromDb) => DbActivityLevel.values[fromDb];

  @override
  int toSql(DbActivityLevel value) => value.index;
}
