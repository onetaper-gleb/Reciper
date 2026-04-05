import 'package:drift/drift.dart';

import '../converters/goal_converter.dart';

@DataClassName('MealPlanEntry')
class MealPlans extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime()();

  IntColumn get goal => integer().map(const GoalConverter())();

  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
}
