import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/domain/bloc/meal_plan/meal_plan_bloc.dart';
import 'package:client/domain/bloc/meal_plan/meal_plan_state.dart';
import 'package:client/domain/models/day_plan.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/meal.dart';
import 'package:client/domain/models/meal_plan.dart';
import 'package:client/module/home/home_screen.dart';
import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/remote/source/meal_plan_remote_source.dart';

class FakeRepo extends MealPlanRepository {
  FakeRepo() : super(database: AppDatabase.test(), remoteSource: _DummyRemote());
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
  Future<GeneratedRecipe> replaceMeal({required Map<String, dynamic> requestJson}) async {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('shows empty state with generate button', (tester) async {
    final bloc = MealPlanBloc(mealPlanRepository: FakeRepo());
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: HomeScreen(
            connectivityStream: Stream<bool>.value(true),
          ),
        ),
      ),
    );

    bloc.emit(const MealPlanEmpty());
    await tester.pumpAndSettle();

    expect(find.text('Составить персональный план'), findsOneWidget);
  });

  testWidgets('shows plan widgets and offline badge', (tester) async {
    final bloc = MealPlanBloc(mealPlanRepository: FakeRepo());
    addTearDown(bloc.close);

    final connectivity = StreamController<bool>.broadcast();
    addTearDown(connectivity.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: HomeScreen(connectivityStream: connectivity.stream),
        ),
      ),
    );

    final graph = StoredMealPlanGraph(
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
    final loaded = MealPlanLoaded(
      activePlan: graph,
      plan: graph,
      selectedDate: DateTime.utc(2026, 4, 6),
    );

    bloc.emit(loaded);
    connectivity.add(true);
    await tester.pumpAndSettle();

    expect(find.text('Пересоздать план питания'), findsOneWidget);
    await tester.drag(find.byType(RefreshIndicator), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('Список покупок на этот день'), findsOneWidget);

    connectivity.add(false);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(RefreshIndicator), const Offset(0, 900));
    await tester.pumpAndSettle();

    expect(find.text('Офлайн-режим'), findsOneWidget);
    expect(find.text('Пересоздать план питания'), findsNothing);
    expect(find.textContaining('только онлайн'), findsOneWidget);
  });
}

