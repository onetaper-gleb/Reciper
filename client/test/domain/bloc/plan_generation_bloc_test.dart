import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/source/preferences_local_source.dart';
import 'package:client/data/local/source/profile_local_source.dart';
import 'package:client/data/local/source/settings_local_source.dart';
import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/data/repository/preferences_repository.dart';
import 'package:client/data/repository/profile_repository.dart';
import 'package:client/data/remote/source/meal_plan_remote_source.dart';
import 'package:client/domain/bloc/plan_generation/plan_generation_bloc.dart';
import 'package:client/domain/bloc/plan_generation/plan_generation_event.dart';
import 'package:client/domain/bloc/plan_generation/plan_generation_state.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/enums/gender.dart';
import 'package:client/domain/models/enums/activity_level.dart';
import 'package:client/domain/models/profile.dart';

class FakeMealPlanRemoteSource implements MealPlanRemoteSource {
  @override
  Future<GeneratedMealPlanGraph> generatePlan({
    required Map<String, dynamic> profileJson,
    required Map<String, dynamic> preferencesJson,
    required Map<String, dynamic> planOptionsJson,
    required List<Map<String, dynamic>> fridgeProductsJson,
    String? additionalNotes,
  }) async {
    return GeneratedMealPlanGraph.fake(
      goal: Goal.maintain,
      startDate: DateTime.utc(2026, 4, 6),
      days: 1,
    );
  }

  @override
  Future<GeneratedRecipe> replaceMeal({required Map<String, dynamic> requestJson}) {
    throw UnimplementedError();
  }
}

void main() {
  late AppDatabase db;
  late MealPlanRepository mealPlanRepository;
  late ProfileRepository profileRepository;
  late PreferencesRepository preferencesRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    db = AppDatabase.test();

    mealPlanRepository = MealPlanRepository(
      database: db,
      remoteSource: FakeMealPlanRemoteSource(),
    );

    profileRepository = ProfileRepository(
      profileLocalSource: ProfileLocalSource(db.profileDao),
      settingsLocalSource: SettingsLocalSource(prefs),
    );

    preferencesRepository = PreferencesRepository(
      PreferencesLocalSource(db.profileDao),
    );

    // Seed profile so generation can run.
    await profileRepository.saveProfile(
      const Profile(
        id: 1,
        name: 'Ivan',
        gender: Gender.male,
        age: 30,
        heightCm: 180,
        weightKg: 80,
        targetWeightKg: 75,
        goal: Goal.maintain,
        activityLevel: ActivityLevel.moderate,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  blocTest<PlanGenerationBloc, PlanGenerationState>(
    'walk through steps and generates plan',
    build: () {
      return PlanGenerationBloc(
        mealPlanRepository: mealPlanRepository,
        profileRepository: profileRepository,
        preferencesRepository: preferencesRepository,
      );
    },
    act: (bloc) async {
      bloc.add(const StepCompleted(stepKey: 'goal', data: {'goal': 'maintain'}));
      bloc.add(const StepCompleted(stepKey: 'period', data: {'days': 1}));
      bloc.add(const GenerationRequested());
    },
    expect: () => [
      isA<PlanGenerationStepState>(),
      isA<PlanGenerationStepState>(),
      isA<PlanGenerating>(),
      isA<PlanGenerated>(),
    ],
  );
}

