import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/source/profile_local_source.dart';
import 'package:client/data/local/source/settings_local_source.dart';
import 'package:client/data/repository/profile_repository.dart';
import 'package:client/domain/models/enums/activity_level.dart';
import 'package:client/domain/models/enums/gender.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/profile.dart';

void main() {
  late AppDatabase db;
  late ProfileRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    db = AppDatabase.test();
    final profileSource = ProfileLocalSource(db.profileDao);
    final settingsSource = SettingsLocalSource(prefs);
    repository = ProfileRepository(
      profileLocalSource: profileSource,
      settingsLocalSource: settingsSource,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('saveProfile then getProfile — data matches', () async {
    const incoming = Profile(
      id: 0,
      name: 'Иван',
      gender: Gender.male,
      age: 28,
      heightCm: 180,
      weightKg: 75,
      targetWeightKg: 72,
      goal: Goal.loseWeight,
      activityLevel: ActivityLevel.moderate,
    );

    await repository.saveProfile(incoming);
    final loaded = await repository.getProfile();

    expect(loaded, isNotNull);
    expect(loaded!.name, incoming.name);
    expect(loaded.gender, Gender.male);
    expect(loaded.gender, isNot(Gender.female));
    expect(loaded.age, incoming.age);
    expect(loaded.heightCm, incoming.heightCm);
    expect(loaded.weightKg, incoming.weightKg);
    expect(loaded.targetWeightKg, incoming.targetWeightKg);
    expect(loaded.goal, incoming.goal);
    expect(loaded.activityLevel, incoming.activityLevel);
    expect(loaded.id, greaterThan(0));
  });

  test('hasCompletedOnboarding reads settings', () async {
    expect(await repository.hasCompletedOnboarding(), false);
    await repository.setOnboardingCompleted(true);
    expect(await repository.hasCompletedOnboarding(), true);
  });
}
