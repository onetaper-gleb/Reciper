import 'package:drift/drift.dart';

import '../converters/budget_level_converter.dart';
import '../converters/diet_type_converter.dart';

@DataClassName('PreferencesEntry')
class Preferences extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Comma-separated or JSON string.
  TextColumn get allergies => text().withDefault(const Constant(''))();

  TextColumn get dislikedProducts => text().withDefault(const Constant(''))();

  TextColumn get likedProducts => text().withDefault(const Constant(''))();

  IntColumn get maxCookingMinutes => integer().withDefault(const Constant(60))();

  IntColumn get budget => integer().map(const BudgetLevelConverter())();

  IntColumn get dietType => integer().map(const DietTypeConverter())();
}
