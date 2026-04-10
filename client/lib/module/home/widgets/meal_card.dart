import 'package:flutter/material.dart';

import '../home_controller.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.item,
    required this.isOffline,
    required this.onReplace,
    required this.onTap,
    required this.onMarkDone,
    this.allowReplace = true,
    this.allowMarkDone = true,
  });

  final HomeMealItem item;
  final bool isOffline;
  final bool allowReplace;
  final bool allowMarkDone;
  final VoidCallback onReplace;
  final VoidCallback onTap;
  final VoidCallback onMarkDone;

  IconData _mealIcon() => switch (item.meal.mealType.name) {
        'breakfast' => Icons.wb_sunny_outlined,
        'lunch' => Icons.restaurant_outlined,
        'dinner' => Icons.dinner_dining_outlined,
        _ => Icons.cookie_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_mealIcon(), color: scheme.onPrimaryContainer, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.recipe.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.recipe.cookingTimeMinutes} мин · ${item.recipe.calories.toStringAsFixed(0)} ккал',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: allowMarkDone ? onMarkDone : null,
                    icon: Icon(
                      item.meal.isDone
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: item.meal.isDone ? scheme.primary : scheme.outline,
                    ),
                  ),
                  if (!isOffline && allowReplace)
                    IconButton(
                      onPressed: onReplace,
                      icon: Icon(Icons.swap_horiz_rounded, color: scheme.secondary),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
