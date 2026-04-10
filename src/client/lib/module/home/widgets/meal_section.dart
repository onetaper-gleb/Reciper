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
    this.allowReplace = true,
    this.allowMarkDone = true,
  });

  final String title;
  final List<HomeMealItem> items;
  final bool isOffline;
  final ValueChanged<HomeMealItem> onReplace;
  final ValueChanged<HomeMealItem> onTapMeal;
  final ValueChanged<HomeMealItem> onMarkDone;
  final bool allowReplace;
  final bool allowMarkDone;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
          ),
        ),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MealCard(
              item: item,
              isOffline: isOffline,
              allowReplace: allowReplace,
              allowMarkDone: allowMarkDone,
              onReplace: () => onReplace(item),
              onTap: () => onTapMeal(item),
              onMarkDone: () => onMarkDone(item),
            ),
          ),
        ),
      ],
    );
  }
}

