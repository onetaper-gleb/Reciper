import 'package:drift/drift.dart';

import '../converters/difficulty_converter.dart';

@DataClassName('RecipeEntry')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  IntColumn get cookingTimeMinutes => integer()();

  IntColumn get difficulty => integer().map(const DifficultyConverter())();

  IntColumn get servings => integer()();

  RealColumn get calories => real()();

  RealColumn get proteinG => real()();

  RealColumn get fatG => real()();

  RealColumn get carbsG => real()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  TextColumn get stepsJson => text()();
}
