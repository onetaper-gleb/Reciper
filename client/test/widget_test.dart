import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client/app/app.dart';
import 'package:client/app/dependencies.dart';
import 'package:client/app/dependencies_scope.dart';
import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/source/profile_local_source.dart';
import 'package:client/data/local/source/settings_local_source.dart';
import 'package:client/data/repository/profile_repository.dart';
import 'package:client/data/repository/settings_repository.dart';
import 'package:client/domain/bloc/profile/profile_bloc.dart';
import 'package:client/domain/bloc/profile/profile_event.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Main shell shows home tab title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final database = AppDatabase.test();
    addTearDown(() async => database.close());

    final prefs = await SharedPreferences.getInstance();
    final profileSource = ProfileLocalSource(database.profileDao);
    final settingsSource = SettingsLocalSource(prefs);
    final dependencies = Dependencies(
      database: database,
      sharedPreferences: prefs,
      profileRepository: ProfileRepository(
        profileLocalSource: profileSource,
        settingsLocalSource: settingsSource,
      ),
      settingsRepository: SettingsRepository(settingsSource),
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
