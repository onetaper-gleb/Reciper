import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/source/profile_local_source.dart';
import 'package:client/data/local/source/settings_local_source.dart';
import 'package:client/data/repository/profile_repository.dart';
import 'package:client/domain/bloc/profile/profile_bloc.dart';
import 'package:client/domain/bloc/profile/profile_event.dart';
import 'package:client/domain/bloc/profile/profile_state.dart';
import 'package:client/domain/models/enums/activity_level.dart';
import 'package:client/domain/models/enums/gender.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/profile.dart';

void main() {
  late AppDatabase db;
  late ProfileRepository repository;

  Profile sample(int id) => Profile(
        id: id,
        name: 'Мария',
        gender: Gender.female,
        age: 32,
        heightCm: 168,
        weightKg: 62,
        targetWeightKg: 60,
        goal: Goal.maintain,
        activityLevel: ActivityLevel.light,
      );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    db = AppDatabase.test();
    repository = ProfileRepository(
      profileLocalSource: ProfileLocalSource(db.profileDao),
      settingsLocalSource: SettingsLocalSource(prefs),
    );
  });

  tearDown(() async {
    await db.close();
  });

  blocTest<ProfileBloc, ProfileState>(
    'ProfileLoadRequested with empty DB keeps ProfileInitial',
    build: () => ProfileBloc(repository),
    act: (bloc) => bloc.add(const ProfileLoadRequested()),
    expect: () => const <ProfileState>[],
  );

  blocTest<ProfileBloc, ProfileState>(
    'after save, ProfileLoadRequested emits ProfileLoaded',
    build: () => ProfileBloc(repository),
    act: (bloc) async {
      await repository.saveProfile(sample(0));
      bloc.add(const ProfileLoadRequested());
    },
    expect: () => [
      predicate<ProfileState>((s) {
        if (s is! ProfileLoaded) return false;
        return s.profile.name == 'Мария' && s.profile.gender == Gender.female;
      }),
    ],
  );
}
