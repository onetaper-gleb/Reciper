import 'package:flutter/material.dart';

import '../home_controller.dart';
import 'meal_card.dart';

class MealSection extends StatelessWidget {
  const MealSection({
    super.key,
    required this.title,
    required this.items,
    required this.isOffline,
    required this.onReplace,
    required this.onTapMeal,
    required this.onMarkDone,
  });

  final String title;
  final List<HomeMealItem> items;
  final bool isOffline;
  final ValueChanged<HomeMealItem> onReplace;
  final ValueChanged<HomeMealItem> onTapMeal;
  final ValueChanged<HomeMealItem> onMarkDone;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...items.map(
          (item) => MealCard(
            item: item,
            isOffline: isOffline,
            onReplace: () => onReplace(item),
            onTap: () => onTapMeal(item),
            onMarkDone: () => onMarkDone(item),
          ),
        ),
      ],
    );
  }
}

