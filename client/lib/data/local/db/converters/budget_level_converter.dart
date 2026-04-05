import 'package:drift/drift.dart';

import '../db_enums.dart';

class BudgetLevelConverter extends TypeConverter<DbBudgetLevel, int> {
  const BudgetLevelConverter();

  @override
  DbBudgetLevel fromSql(int fromDb) => DbBudgetLevel.values[fromDb];

  @override
  int toSql(DbBudgetLevel value) => value.index;
}
