import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'converters/activity_level_converter.dart';
import 'converters/budget_level_converter.dart';
import 'converters/diet_type_converter.dart';
import 'converters/difficulty_converter.dart';
import 'converters/gender_converter.dart';
import 'converters/goal_converter.dart';
import 'converters/meal_type_converter.dart';
import 'db_enums.dart';
import 'tables/day_plans_table.dart';
import 'tables/fridge_products_table.dart';
import 'tables/fridge_scans_table.dart';
import 'tables/ingredients_table.dart';
import 'tables/meal_plans_table.dart';
import 'tables/meals_table.dart';
import 'tables/preferences_table.dart';
import 'tables/profile_table.dart';
import 'tables/recipes_table.dart';
import 'tables/shopping_items_table.dart';
import 'tables/weight_entries_table.dart';

part 'daos/fridge_dao.dart';
part 'daos/meal_plan_dao.dart';
part 'daos/profile_dao.dart';
part 'daos/progress_dao.dart';
part 'daos/recipe_dao.dart';
part 'daos/shopping_list_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Profiles,
    Preferences,
    MealPlans,
    Recipes,
    DayPlans,
    Meals,
    Ingredients,
    FridgeProducts,
    FridgeScans,
    ShoppingItems,
    WeightEntries,
  ],
  daos: [
    ProfileDao,
    MealPlanDao,
    RecipeDao,
    FridgeDao,
    ShoppingListDao,
    ProgressDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens a file-backed database in the app documents directory.
  factory AppDatabase.defaults() => AppDatabase(_openConnection());

  /// In-memory database for tests.
  AppDatabase.test() : super(NativeDatabase.memory());

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      }
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'reciper.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );

  /// Deletes all user rows (profile, plans, recipes, fridge, weight, etc.).
  Future<void> clearAllUserData() async {
    await transaction(() async {
      await delete(shoppingItems).go();
      await delete(meals).go();
      await delete(dayPlans).go();
      await delete(mealPlans).go();
      await delete(ingredients).go();
      await delete(recipes).go();
      await delete(fridgeProducts).go();
      await delete(fridgeScans).go();
      await delete(weightEntries).go();
      await delete(preferences).go();
      await delete(profiles).go();
    });
  }
}
