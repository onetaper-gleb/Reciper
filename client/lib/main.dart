import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'app/dependencies_scope.dart';
import 'core/constants/app_config.dart';
import 'core/constants/storage_keys.dart';
import 'core/utils/app_logger.dart';
import 'data/local/db/app_database.dart';
import 'data/local/source/profile_local_source.dart';
import 'data/local/source/preferences_local_source.dart';
import 'data/local/source/settings_local_source.dart';
import 'data/remote/api/reciper_api.dart';
import 'data/remote/source/meal_plan_remote_source.dart';
import 'data/remote/source/fridge_remote_source.dart';
import 'data/remote/source/recipe_remote_source.dart';
import 'data/repository/profile_repository.dart';
import 'data/repository/meal_plan_repository.dart';
import 'data/repository/preferences_repository.dart';
import 'data/repository/settings_repository.dart';
import 'data/repository/fridge_repository.dart';
import 'data/repository/recipe_repository.dart';
import 'data/repository/shopping_list_repository.dart';
import 'data/repository/progress_repository.dart';
import 'domain/bloc/profile/profile_bloc.dart';
import 'domain/bloc/profile/profile_event.dart';
import 'domain/bloc/meal_plan/meal_plan_bloc.dart';
import 'domain/bloc/meal_plan/meal_plan_event.dart';
import 'domain/bloc/progress/progress_bloc.dart';
import 'domain/bloc/progress/progress_event.dart';
import 'network/http_client.dart';
import 'services/connectivity_service.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeDateFormatting('ru');

  final database = AppDatabase.defaults();
  final sharedPreferences = await SharedPreferences.getInstance();

  // TODO: move to config later; for MVP keep dev base url.
  final dio = HttpClientFactory.create(baseUrl: AppConfig.resolvedApiBaseUrl());
  final reciperApi = ReciperApi(dio);
  final connectivityService = ConnectivityService();
  final mealPlanRemoteSource = MealPlanRemoteSourceImpl(reciperApi);
  final fridgeRemoteSource = FridgeRemoteSourceImpl(reciperApi);
  final recipeRemoteSource = RecipeRemoteSourceImpl(reciperApi);

  final profileLocalSource = ProfileLocalSource(database.profileDao);
  final preferencesLocalSource = PreferencesLocalSource(database.profileDao);
  final settingsLocalSource = SettingsLocalSource(sharedPreferences);

  final profileRepository = ProfileRepository(
    profileLocalSource: profileLocalSource,
    settingsLocalSource: settingsLocalSource,
  );
  final settingsRepository = SettingsRepository(settingsLocalSource);
  final preferencesRepository = PreferencesRepository(preferencesLocalSource);
  final mealPlanRepository = MealPlanRepository(
    database: database,
    remoteSource: mealPlanRemoteSource,
  );
  final fridgeRepository = FridgeRepository(
    database: database,
    remoteSource: fridgeRemoteSource,
  );
  final recipeRepository = RecipeRepository(
    database: database,
    remoteSource: recipeRemoteSource,
  );
  final shoppingListRepository = ShoppingListRepository(database: database);
  final progressRepository = ProgressRepository(database: database);

  ThemeMode parseThemeMode(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  final themeModeNotifier = ValueNotifier<ThemeMode>(
    parseThemeMode(sharedPreferences.getString(StorageKeys.themeMode)),
  );
  final sessionEpoch = ValueNotifier(0);

  final dependencies = Dependencies(
    database: database,
    sharedPreferences: sharedPreferences,
    dio: dio,
    reciperApi: reciperApi,
    connectivityService: connectivityService,
    mealPlanRemoteSource: mealPlanRemoteSource,
    profileRepository: profileRepository,
    settingsRepository: settingsRepository,
    preferencesRepository: preferencesRepository,
    mealPlanRepository: mealPlanRepository,
    fridgeRemoteSource: fridgeRemoteSource,
    fridgeRepository: fridgeRepository,
    recipeRemoteSource: recipeRemoteSource,
    recipeRepository: recipeRepository,
    shoppingListRepository: shoppingListRepository,
    progressRepository: progressRepository,
    themeModeNotifier: themeModeNotifier,
    sessionEpoch: sessionEpoch,
  );

  AppLogger.info('main: starting app');

  runApp(
    DependenciesScope(
      dependencies: dependencies,
      child: ValueListenableBuilder<int>(
        valueListenable: dependencies.sessionEpoch,
        builder: (context, epoch, _) {
          return MultiBlocProvider(
            key: ValueKey('session-$epoch'),
            providers: [
              BlocProvider<ProfileBloc>(
                create: (_) => ProfileBloc(profileRepository)
                  ..add(const ProfileLoadRequested()),
              ),
              BlocProvider<MealPlanBloc>(
                create: (_) =>
                    MealPlanBloc(mealPlanRepository: mealPlanRepository)
                      ..add(const MealPlanLoadRequested()),
              ),
              BlocProvider<ProgressBloc>(
                create: (_) => ProgressBloc(progressRepository)
                  ..add(const ProgressLoadRequested()),
              ),
            ],
            child: const MyApp(),
          );
        },
      ),
    ),
  );
}
