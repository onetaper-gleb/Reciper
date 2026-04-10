import 'package:drift/drift.dart';

import '../converters/meal_type_converter.dart';
import 'day_plans_table.dart';
import 'recipes_table.dart';

@DataClassName('MealEntry')
class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get dayPlanId => integer().references(DayPlans, #id)();

  IntColumn get mealType => integer().map(const MealTypeConverter())();

  DateTimeColumn get mealTime => dateTime()();

  IntColumn get recipeId => integer().references(Recipes, #id)();

  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
}
