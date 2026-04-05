import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'app/dependencies_scope.dart';
import 'core/utils/app_logger.dart';
import 'data/local/db/app_database.dart';
import 'data/local/source/profile_local_source.dart';
import 'data/local/source/settings_local_source.dart';
import 'data/repository/profile_repository.dart';
import 'data/repository/settings_repository.dart';
import 'domain/bloc/profile/profile_bloc.dart';
import 'domain/bloc/profile/profile_event.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final database = AppDatabase.defaults();
  final sharedPreferences = await SharedPreferences.getInstance();

  final profileLocalSource = ProfileLocalSource(database.profileDao);
  final settingsLocalSource = SettingsLocalSource(sharedPreferences);

  final profileRepository = ProfileRepository(
    profileLocalSource: profileLocalSource,
    settingsLocalSource: settingsLocalSource,
  );
  final settingsRepository = SettingsRepository(settingsLocalSource);

  final dependencies = Dependencies(
    database: database,
    sharedPreferences: sharedPreferences,
    profileRepository: profileRepository,
    settingsRepository: settingsRepository,
  );

  AppLogger.info('main: starting app');

  runApp(
    DependenciesScope(
      dependencies: dependencies,
      child: BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(profileRepository)
          ..add(const ProfileLoadRequested()),
        child: const MyApp(),
      ),
    ),
  );
}
