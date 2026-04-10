import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/calendar_week.dart';
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
                    onGeneratePressed: () => _openPlanGeneration(context, null),
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

                if (state is MealPlanOperationError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  });
                  return _LoadedPlanView(
                    state: state.previous,
                    isOnline: isOnline,
                  );
                }

                if (state is MealPlanError) {
                  return _HomeErrorView(
                    message: state.message,
                    onRetry: () =>
                        context.read<MealPlanBloc>().add(const MealPlanLoadRequested()),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  void _openPlanGeneration(BuildContext context, DateTime? planStartDate) {
    Navigator.of(context)
        .push<void>(
      MaterialPageRoute<void>(
        builder: (_) => PlanGenerationScreen(planStartDate: planStartDate),
      ),
    )
        .then((_) {
      if (!context.mounted) return;
      context.read<MealPlanBloc>().add(const MealPlanLoadRequested());
    });
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.screenPaddingH),
      children: [
        const SizedBox(height: 48),
        Icon(Icons.cloud_off_outlined, size: 64, color: scheme.error),
        const SizedBox(height: 20),
        Text(
          'Не удалось загрузить план',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Повторить'),
        ),
      ],
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
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.screenPaddingH),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Icon(Icons.restaurant_menu_rounded, size: 72, color: scheme.primary),
              const SizedBox(height: 20),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Плана пока нет. Соберём меню под ваш профиль и цели — это займёт пару минут.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.45,
                    ),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: isOnline ? onGeneratePressed : null,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Составить персональный план'),
              ),
              if (!isOnline) ...[
                const SizedBox(height: 12),
                const Chip(label: Text('Офлайн-режим')),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeDateHeader extends StatelessWidget {
  const _HomeDateHeader({required this.date});

  final DateTime date;

  static const _weekdays = [
    '',
    'Понедельник',
    'Вторник',
    'Среда',
    'Четвер',
    'Пятница',
    'Суббота',
    'Воскресенье',
  ];

  static const _months = [
    '',
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  @override
  Widget build(BuildContext context) {
    final line =
        '${_weekdays[date.weekday]}, ${date.day} ${_months[date.month]}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'План на день',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          line,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
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

    final planDayHints = <DateTime>{
      for (final d in state.activePlan.days) CalendarWeek.dateOnly(d.date),
    };
    final readOnlyPlan = state.isHistoricalView || state.missingHistoricalPlan;
    final allowMarkDone =
        !CalendarWeek.isFutureDay(state.selectedDate) && !state.missingHistoricalPlan;
    final showFutureDayGenerate = !state.isHistoricalView &&
        !state.missingHistoricalPlan &&
        CalendarWeek.isFutureDay(state.selectedDate) &&
        items.isEmpty &&
        isOnline;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.screenPaddingH),
      children: [
        if (!isOnline) const Chip(label: Text('Офлайн-режим')),
        if (state.missingHistoricalPlan)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Нет сохранённого плана на выбранную дату.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        _HomeDateHeader(date: state.selectedDate),
        const SizedBox(height: 8),
        DaySelector(
          daysWithPlanData: planDayHints,
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
          consumedProteinG: nutrition.consumedProteinG,
          targetProteinG: nutrition.targetProteinG,
          consumedFatG: nutrition.consumedFatG,
          targetFatG: nutrition.targetFatG,
          consumedCarbsG: nutrition.consumedCarbsG,
          targetCarbsG: nutrition.targetCarbsG,
        ),
        const SizedBox(height: 14),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Новый план',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isOnline
                      ? 'Текущий план останется в истории, активным станет новый.'
                      : 'Составить новый план можно только онлайн.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                ),
                const SizedBox(height: 12),
                if (isOnline)
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.of(context)
                          .push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const PlanGenerationScreen(),
                        ),
                      )
                          .then((_) {
                        if (!context.mounted) return;
                        context.read<MealPlanBloc>().add(const MealPlanLoadRequested());
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text('Пересоздать план питания'),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        if (showFutureDayGenerate) ...[
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'На этот день ещё нет блюд в текущем плане.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => PlanGenerationScreen(planStartDate: state.selectedDate),
                        ),
                      )
                          .then((_) {
                        if (!context.mounted) return;
                        context.read<MealPlanBloc>().add(const MealPlanLoadRequested());
                      });
                    },
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Составить план с этого дня'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
        MealSection(
          title: 'Завтрак',
          items: byType['breakfast'] ?? const [],
          isOffline: !isOnline,
          allowReplace: !readOnlyPlan,
          allowMarkDone: allowMarkDone,
          onReplace: (item) => _showReplaceBottomSheet(context, item.meal.id),
          onTapMeal: (item) => _openRecipeDetail(context, item),
          onMarkDone: (item) =>
              context.read<MealPlanBloc>().add(MealCompleted(item.meal.id)),
        ),
        MealSection(
          title: 'Обед',
          items: byType['lunch'] ?? const [],
          isOffline: !isOnline,
          allowReplace: !readOnlyPlan,
          allowMarkDone: allowMarkDone,
          onReplace: (item) => _showReplaceBottomSheet(context, item.meal.id),
          onTapMeal: (item) => _openRecipeDetail(context, item),
          onMarkDone: (item) =>
              context.read<MealPlanBloc>().add(MealCompleted(item.meal.id)),
        ),
        MealSection(
          title: 'Ужин',
          items: byType['dinner'] ?? const [],
          isOffline: !isOnline,
          allowReplace: !readOnlyPlan,
          allowMarkDone: allowMarkDone,
          onReplace: (item) => _showReplaceBottomSheet(context, item.meal.id),
          onTapMeal: (item) => _openRecipeDetail(context, item),
          onMarkDone: (item) =>
              context.read<MealPlanBloc>().add(MealCompleted(item.meal.id)),
        ),
        MealSection(
          title: 'Перекусы',
          items: byType['snack'] ?? const [],
          isOffline: !isOnline,
          allowReplace: !readOnlyPlan,
          allowMarkDone: allowMarkDone,
          onReplace: (item) => _showReplaceBottomSheet(context, item.meal.id),
          onTapMeal: (item) => _openRecipeDetail(context, item),
          onMarkDone: (item) =>
              context.read<MealPlanBloc>().add(MealCompleted(item.meal.id)),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.shopping_cart_outlined),
          label: const Text('Список покупок на этот день'),
          onPressed: state.missingHistoricalPlan
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ShoppingListScreen(
                        planId: state.plan.mealPlan.id,
                        date: state.selectedDate,
                      ),
                    ),
                  );
                },
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
    Navigator.of(context)
        .push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RecipeDetailScreen(
          recipe: item.recipe,
          ingredients: ingredients,
          meal: item.meal,
          mealPlanId: state.plan.mealPlan.id,
        ),
      ),
    )
        .then((_) {
      if (!context.mounted) return;
      context.read<MealPlanBloc>().add(const MealPlanLoadRequested());
    });
  }
}
