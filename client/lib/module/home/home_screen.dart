import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/bloc/meal_plan/meal_plan_bloc.dart';
import '../../domain/bloc/meal_plan/meal_plan_event.dart';
import '../../domain/bloc/meal_plan/meal_plan_state.dart';
import '../plan_generation/plan_generation_screen.dart';
import '../recipe_detail/recipe_detail_screen.dart';
import '../shopping_list/shopping_list_screen.dart';
import 'home_controller.dart';
import 'package:client/core/utils/app_logger.dart';
import 'widgets/day_selector.dart';
import 'widgets/meal_section.dart';
import 'widgets/nutrition_summary.dart';
import 'widgets/replace_meal_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.connectivityStream});

  final Stream<bool>? connectivityStream;

  @override
  Widget build(BuildContext context) {
    final stream = connectivityStream ?? const Stream<bool>.empty();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            context.read<MealPlanBloc>().add(const MealPlanLoadRequested()),
        child: StreamBuilder<bool>(
          stream: stream,
          initialData: true,
          builder: (context, snapshot) {
            final isOnline = snapshot.data ?? true;
            return BlocBuilder<MealPlanBloc, MealPlanState>(
              builder: (context, state) {
                if (state is MealPlanLoading || state is MealPlanInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MealPlanEmpty) {
                  return _EmptyPlanView(
                    isOnline: isOnline,
                    onGeneratePressed: () => _openPlanGeneration(context),
                  );
                }

                if (state is MealReplacingInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MealPlanLoaded) {
                  return _LoadedPlanView(
                    state: state,
                    isOnline: isOnline,
                  );
                }

                if (state is MealPlanError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  void _openPlanGeneration(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PlanGenerationScreen(),
      ),
    );
  }
}

class _EmptyPlanView extends StatelessWidget {
  const _EmptyPlanView({
    required this.isOnline,
    required this.onGeneratePressed,
  });

  final bool isOnline;
  final VoidCallback onGeneratePressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.screenPaddingH),
          child: Column(
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isOnline ? onGeneratePressed : null,
                child: const Text('Составить персональный план'),
              ),
              if (!isOnline) ...[
                const SizedBox(height: 8),
                const Chip(label: Text('Офлайн-режим')),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadedPlanView extends StatelessWidget {
  const _LoadedPlanView({
    required this.state,
    required this.isOnline,
  });

  final MealPlanLoaded state;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final items = HomeController.mealsForSelectedDay(
      state.plan,
      state.selectedDate,
    );
    final nutrition = HomeController.calculateProgress(items);
    final byType = <String, List<HomeMealItem>>{};
    for (final item in items) {
      byType.putIfAbsent(item.meal.mealType.name, () => []).add(item);
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.screenPaddingH),
      children: [
        if (!isOnline) const Chip(label: Text('Офлайн-режим')),
        DaySelector(
          days: state.plan.days.map((e) => e.date).toList(),
          selectedDate: state.selectedDate,
          onDaySelected: (d) => context.read<MealPlanBloc>().add(DaySelected(d)),
        ),
        const SizedBox(height: 12),
        NutritionSummary(
          targetCalories: nutrition.targetCalories,
          consumedCalories: nutrition.consumedCalories,
          proteinProgress: nutrition.proteinProgress,
          fatProgress: nutrition.fatProgress,
          carbsProgress: nutrition.carbsProgress,
        ),
        const SizedBox(height: 16),
        MealSection(
          title: 'Завтрак',
          items: byType['breakfast'] ?? const [],
          isOffline: !isOnline,
          onReplace: (item) => _showReplaceBottomSheet(context, item.meal.id),
          onTapMeal: (item) => _openRecipeDetail(context, item),
          onMarkDone: (item) =>
              context.read<MealPlanBloc>().add(MealCompleted(item.meal.id)),
        ),
        MealSection(
          title: 'Обед',
          items: byType['lunch'] ?? const [],
          isOffline: !isOnline,
          onReplace: (item) => _showReplaceBottomSheet(context, item.meal.id),
          onTapMeal: (item) => _openRecipeDetail(context, item),
          onMarkDone: (item) =>
              context.read<MealPlanBloc>().add(MealCompleted(item.meal.id)),
        ),
        MealSection(
          title: 'Ужин',
          items: byType['dinner'] ?? const [],
          isOffline: !isOnline,
          onReplace: (item) => _showReplaceBottomSheet(context, item.meal.id),
          onTapMeal: (item) => _openRecipeDetail(context, item),
          onMarkDone: (item) =>
              context.read<MealPlanBloc>().add(MealCompleted(item.meal.id)),
        ),
        MealSection(
          title: 'Перекусы',
          items: byType['snack'] ?? const [],
          isOffline: !isOnline,
          onReplace: (item) => _showReplaceBottomSheet(context, item.meal.id),
          onTapMeal: (item) => _openRecipeDetail(context, item),
          onMarkDone: (item) =>
              context.read<MealPlanBloc>().add(MealCompleted(item.meal.id)),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ShoppingListScreen(
                  planId: state.plan.mealPlan.id,
                  date: state.selectedDate,
                ),
              ),
            );
          },
          child: const Text('Список покупок на этот день'),
        ),
      ],
    );
  }

  void _showReplaceBottomSheet(BuildContext context, int mealId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ReplaceMealBottomSheet(
        onSubmit: (reason, notes) {
          AppLogger.info('HomeScreen: _showReplaceBottomSheet: $reason, $notes');
          Navigator.pop(context);
          context
              .read<MealPlanBloc>()
              .add(MealReplaceRequested(mealId: mealId, reason: reason, notes: notes));
        },
      ),
    );
  }

  void _openRecipeDetail(BuildContext context, HomeMealItem item) {
    final ingredients = state.plan.ingredients
        .where((i) => i.recipeId == item.recipe.id)
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RecipeDetailScreen(
          recipe: item.recipe,
          ingredients: ingredients,
          meal: item.meal,
          mealPlanId: state.plan.mealPlan.id,
        ),
      ),
    );
  }
}
