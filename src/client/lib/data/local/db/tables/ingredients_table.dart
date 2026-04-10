import 'package:drift/drift.dart';

import 'recipes_table.dart';

@DataClassName('IngredientEntry')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get recipeId => integer().references(Recipes, #id)();

  TextColumn get name => text()();

  RealColumn get amount => real()();

  TextColumn get unit => text()();

  TextColumn get category => text()();
}
