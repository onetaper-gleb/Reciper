import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client/app/app.dart';
import 'package:client/app/dependencies.dart';
import 'package:client/app/dependencies_scope.dart';
import 'package:client/core/constants/storage_keys.dart';
import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/source/profile_local_source.dart';
import 'package:client/data/local/source/preferences_local_source.dart';
import 'package:client/data/local/source/settings_local_source.dart';
import 'package:client/data/remote/api/reciper_api.dart';
import 'package:client/data/remote/source/meal_plan_remote_source.dart';
import 'package:client/data/repository/profile_repository.dart';
import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/data/repository/preferences_repository.dart';
import 'package:client/data/repository/settings_repository.dart';
import 'package:client/domain/bloc/profile/profile_bloc.dart';
import 'package:client/domain/bloc/profile/profile_event.dart';
import 'package:client/network/http_client.dart';
import 'package:client/services/connectivity_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Main shell shows home tab title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      StorageKeys.onboardingCompleted: true,
    });

    final database = AppDatabase.test();
    addTearDown(() async => database.close());

    final prefs = await SharedPreferences.getInstance();
    final profileSource = ProfileLocalSource(database.profileDao);
    final settingsSource = SettingsLocalSource(prefs);
    final dio = HttpClientFactory.create(baseUrl: 'http://localhost:8000');
    final api = ReciperApi(dio);
    final connectivityService = ConnectivityService();
    addTearDown(connectivityService.dispose);
    final mealPlanRemoteSource = MealPlanRemoteSourceImpl(api);
    final preferencesRepository = PreferencesRepository(
      PreferencesLocalSource(database.profileDao),
    );
    final dependencies = Dependencies(
      database: database,
      sharedPreferences: prefs,
      dio: dio,
      reciperApi: api,
      connectivityService: connectivityService,
      mealPlanRemoteSource: mealPlanRemoteSource,
      profileRepository: ProfileRepository(
        profileLocalSource: profileSource,
        settingsLocalSource: settingsSource,
      ),
      settingsRepository: SettingsRepository(settingsSource),
      preferencesRepository: preferencesRepository,
      mealPlanRepository: MealPlanRepository(
        database: database,
        remoteSource: mealPlanRemoteSource,
      ),
    );

    await tester.pumpWidget(
      DependenciesScope(
        dependencies: dependencies,
        child: BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(dependencies.profileRepository)
            ..add(const ProfileLoadRequested()),
          child: const MyApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reciper'), findsOneWidget);
  });
}
