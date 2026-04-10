import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/domain/models/enums/meal_type.dart';

/// Read-only view of a stored meal plan (history item).
class PlanHistoryDetailScreen extends StatelessWidget {
  const PlanHistoryDetailScreen({super.key, required this.graph});

  final StoredMealPlanGraph graph;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFmt = DateFormat.yMMMd('ru');
    final days = [...graph.days]..sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${dateFmt.format(graph.mealPlan.startDate)} — ${dateFmt.format(graph.mealPlan.endDate)}',
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final dayMeals =
              graph.meals.where((m) => m.dayPlanId == day.id).toList()
                ..sort((a, b) => a.mealTime.compareTo(b.mealTime));
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFmt.format(day.date),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  for (final m in dayMeals)
                    _MealRow(
                      mealType: m.mealType,
                      title: _recipeTitle(graph, m.recipeId),
                      done: m.isDone,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _recipeTitle(StoredMealPlanGraph g, int recipeId) {
    try {
      return g.recipes.firstWhere((r) => r.id == recipeId).title;
    } catch (_) {
      return 'Рецепт #$recipeId';
    }
  }
}

class _MealRow extends StatelessWidget {
  const _MealRow({
    required this.mealType,
    required this.title,
    required this.done,
  });

  final MealType mealType;
  final String title;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              _mealTypeRu(mealType),
              style: theme.textTheme.labelMedium,
            ),
          ),
          Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
          if (done)
            Icon(Icons.check_circle, size: 18, color: theme.colorScheme.primary),
        ],
      ),
    );
  }

  static String _mealTypeRu(MealType t) => switch (t) {
        MealType.breakfast => 'Завтрак',
        MealType.lunch => 'Обед',
        MealType.dinner => 'Ужин',
        MealType.snack => 'Перекус',
      };
}
