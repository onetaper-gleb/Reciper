import 'package:drift/drift.dart';

import '../db_enums.dart';

class GoalConverter extends TypeConverter<DbGoal, int> {
  const GoalConverter();

  @override
  DbGoal fromSql(int fromDb) => DbGoal.values[fromDb];

  @override
  int toSql(DbGoal value) => value.index;
}
