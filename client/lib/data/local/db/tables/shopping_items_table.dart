import 'package:drift/drift.dart';

import 'meal_plans_table.dart';

@DataClassName('ShoppingListEntry')
class ShoppingItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get mealPlanId => integer().references(MealPlans, #id)();

  TextColumn get name => text()();

  RealColumn get amount => real()();

  TextColumn get unit => text()();

  TextColumn get category => text()();

  BoolColumn get purchased => boolean().withDefault(const Constant(false))();

  BoolColumn get inFridge => boolean().withDefault(const Constant(false))();
}
