import 'package:drift/drift.dart';

import '../db_enums.dart';

class DifficultyConverter extends TypeConverter<DbDifficulty, int> {
  const DifficultyConverter();

  @override
  DbDifficulty fromSql(int fromDb) => DbDifficulty.values[fromDb];

  @override
  int toSql(DbDifficulty value) => value.index;
}
