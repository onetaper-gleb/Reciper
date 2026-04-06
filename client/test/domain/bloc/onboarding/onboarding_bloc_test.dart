import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/source/profile_local_source.dart';
import 'package:client/data/local/source/settings_local_source.dart';
import 'package:client/data/repository/profile_repository.dart';
import 'package:client/domain/bloc/onboarding/onboarding_bloc.dart';
import 'package:client/domain/bloc/onboarding/onboarding_event.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';
import 'package:client/domain/models/enums/activity_level.dart';
import 'package:client/domain/models/enums/gender.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/onboarding_draft.dart';
import 'package:client/core/utils/nutrition_calculator.dart';

void main() {
  late AppDatabase db;
  late ProfileRepository repository;

  OnboardingDraft fullDraft() => const OnboardingDraft(
        name: 'Иван',
        gender: Gender.male,
        age: 30,
        heightCm: 180,
        weightKg: 80,
        goal: Goal.maintain,
        activityLevel: ActivityLevel.moderate,
        allergyTags: ['lactose_free'],
        allergiesOther: 'Мёд',
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

  blocTest<OnboardingBloc, OnboardingState>(
    'emits editing with updated draft',
    build: () => OnboardingBloc(repository),
    act: (bloc) => bloc.add(OnboardingDraftUpdated(fullDraft())),
    expect: () => [
      OnboardingEditing(fullDraft()),
    ],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'OnboardingPrepareSummary attaches nutritionPreview',
    build: () => OnboardingBloc(repository),
    act: (bloc) async {
      bloc.add(OnboardingDraftUpdated(fullDraft()));
      bloc.add(const OnboardingPrepareSummary());
    },
    expect: () => [
      OnboardingEditing(fullDraft()),
      predicate<OnboardingState>((s) {
        if (s is! OnboardingEditing) return false;
        return s.nutritionPreview != null &&
            s.nutritionPreview!.dailyCalories > 0;
      }),
    ],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'OnboardingFinished saves profile, sets flag, emits completed',
    build: () => OnboardingBloc(repository),
    act: (bloc) async {
      bloc.add(OnboardingDraftUpdated(fullDraft()));
      bloc.add(const OnboardingFinished());
    },
    expect: () => [
      OnboardingEditing(fullDraft()),
      const OnboardingSubmitting(),
      const OnboardingCompleted(),
    ],
    verify: (_) async {
      final profile = await repository.getProfile();
      expect(profile, isNotNull);
      expect(profile!.name, 'Иван');
      expect(await repository.hasCompletedOnboarding(), isTrue);
    },
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'OnboardingFinished with invalid draft emits editing with error',
    build: () => OnboardingBloc(repository),
    act: (bloc) async {
      bloc.add(
        const OnboardingDraftUpdated(
          OnboardingDraft(name: ''),
        ),
      );
      bloc.add(const OnboardingFinished());
    },
    expect: () => [
      const OnboardingEditing(OnboardingDraft(name: '')),
      predicate<OnboardingState>((s) {
        if (s is! OnboardingEditing) return false;
        return s.errorMessage != null && s.errorMessage!.isNotEmpty;
      }),
    ],
    verify: (_) async {
      expect(await repository.getProfile(), isNull);
      expect(await repository.hasCompletedOnboarding(), isFalse);
    },
  );

  test('nutrition preview matches calculator for full draft', () {
    final draft = fullDraft();
    final n = NutritionCalculator.dailyTargets(
      gender: draft.gender!,
      age: draft.age!,
      heightCm: draft.heightCm!,
      weightKg: draft.weightKg!,
      activityLevel: draft.activityLevel!,
      goal: draft.goal!,
    );
    expect(n.dailyCalories, greaterThan(0));
  });
}
