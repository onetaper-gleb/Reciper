import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../data/local/db/app_database.dart';
import '../data/repository/profile_repository.dart';
import '../data/repository/settings_repository.dart';
import '../data/repository/meal_plan_repository.dart';
import '../data/repository/preferences_repository.dart';
import '../data/repository/fridge_repository.dart';
import '../data/repository/recipe_repository.dart';
import '../data/repository/shopping_list_repository.dart';
import '../data/remote/api/reciper_api.dart';
import '../data/remote/source/meal_plan_remote_source.dart';
import '../data/remote/source/fridge_remote_source.dart';
import '../data/remote/source/recipe_remote_source.dart';
import '../services/connectivity_service.dart';

/// Composition root: repositories, database, HTTP client will be wired here.
class Dependencies {
  Dependencies({
    required this.database,
    required this.sharedPreferences,
    required this.dio,
    required this.reciperApi,
    required this.connectivityService,
    required this.mealPlanRemoteSource,
    required this.profileRepository,
    required this.settingsRepository,
    required this.preferencesRepository,
    required this.mealPlanRepository,
    required this.fridgeRemoteSource,
    required this.fridgeRepository,
    required this.recipeRemoteSource,
    required this.recipeRepository,
    required this.shoppingListRepository,
  });

  final AppDatabase database;
  final SharedPreferences sharedPreferences;
  final Dio dio;
  final ReciperApi reciperApi;
  final ConnectivityService connectivityService;
  final MealPlanRemoteSource mealPlanRemoteSource;
  final ProfileRepository profileRepository;
  final SettingsRepository settingsRepository;
  final PreferencesRepository preferencesRepository;
  final MealPlanRepository mealPlanRepository;
  final FridgeRemoteSource fridgeRemoteSource;
  final FridgeRepository fridgeRepository;
  final RecipeRemoteSource recipeRemoteSource;
  final RecipeRepository recipeRepository;
  final ShoppingListRepository shoppingListRepository;
}
