import 'package:drift/drift.dart';

import '../db_enums.dart';

class GenderConverter extends TypeConverter<DbGender, int> {
  const GenderConverter();

  @override
  DbGender fromSql(int fromDb) => DbGender.values[fromDb];

  @override
  int toSql(DbGender value) => value.index;
}
