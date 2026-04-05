import 'package:drift/drift.dart';

import 'meal_plans_table.dart';

@DataClassName('DayPlanEntry')
class DayPlans extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get mealPlanId => integer().references(MealPlans, #id)();

  DateTimeColumn get planDate => dateTime()();
}
