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
  });

  final HomeMealItem item;
  final bool isOffline;
  final VoidCallback onReplace;
  final VoidCallback onTap;
  final VoidCallback onMarkDone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(item.recipe.title),
        subtitle: Text(
          '${item.recipe.cookingTimeMinutes} мин • ${item.recipe.calories.toStringAsFixed(0)} ккал',
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              onPressed: onMarkDone,
              icon: Icon(
                item.meal.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              ),
            ),
            if (!isOffline)
              IconButton(
                onPressed: onReplace,
                icon: const Icon(Icons.swap_horiz),
              ),
          ],
        ),
      ),
    );
  }
}

