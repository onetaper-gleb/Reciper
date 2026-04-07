import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/remote/source/meal_plan_remote_source.dart';
import 'package:client/domain/bloc/meal_plan/meal_plan_bloc.dart';
import 'package:client/domain/bloc/meal_plan/meal_plan_event.dart';
import 'package:client/domain/bloc/meal_plan/meal_plan_state.dart';
import 'package:client/domain/models/day_plan.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/meal.dart';
import 'package:client/domain/models/meal_plan.dart';

class FakeMealPlanRepository extends MealPlanRepository {
  FakeMealPlanRepository({this.hasPlan = false})
      : super(database: AppDatabase.test(), remoteSource: _DummyRemote());

  final bool hasPlan;

  @override
  Future<StoredMealPlanGraph?> getActivePlan() async {
    if (!hasPlan) return null;
    return StoredMealPlanGraph(
      mealPlan: MealPlan(
        id: 1,
        startDate: DateTime.utc(2026, 4, 6),
        endDate: DateTime.utc(2026, 4, 12),
        goal: Goal.maintain,
        isActive: true,
        createdAt: DateTime.utc(2026, 4, 6),
      ),
      days: [
        DayPlan(id: 1, mealPlanId: 1, date: DateTime.utc(2026, 4, 6)),
      ],
      meals: const <Meal>[],
      recipes: const [],
      ingredients: const [],
    );
  }
}

class _DummyRemote implements MealPlanRemoteSource {
  @override
  Future<GeneratedMealPlanGraph> generatePlan({
    required Map<String, dynamic> profileJson,
    required Map<String, dynamic> preferencesJson,
    required Map<String, dynamic> planOptionsJson,
    required List<Map<String, dynamic>> fridgeProductsJson,
    String? additionalNotes,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<GeneratedRecipe> replaceMeal({
    required Map<String, dynamic> requestJson,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  blocTest<MealPlanBloc, MealPlanState>(
    'load with empty repository emits MealPlanEmpty',
    build: () => MealPlanBloc(mealPlanRepository: FakeMealPlanRepository()),
    act: (bloc) => bloc.add(const MealPlanLoadRequested()),
    expect: () => [
      isA<MealPlanLoading>(),
      isA<MealPlanEmpty>(),
    ],
  );

  blocTest<MealPlanBloc, MealPlanState>(
    'load with active plan emits MealPlanLoaded',
    build: () =>
        MealPlanBloc(mealPlanRepository: FakeMealPlanRepository(hasPlan: true)),
    act: (bloc) => bloc.add(const MealPlanLoadRequested()),
    expect: () => [
      isA<MealPlanLoading>(),
      isA<MealPlanLoaded>(),
    ],
  );
}

