import 'package:flutter/material.dart';

class NutritionSummary extends StatelessWidget {
  const NutritionSummary({
    super.key,
    required this.targetCalories,
    required this.consumedCalories,
    required this.proteinProgress,
    required this.fatProgress,
    required this.carbsProgress,
  });

  final double targetCalories;
  final double consumedCalories;
  final double proteinProgress;
  final double fatProgress;
  final double carbsProgress;

  @override
  Widget build(BuildContext context) {
    final caloriesProgress =
        targetCalories > 0 ? (consumedCalories / targetCalories).clamp(0, 1) : 0.0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(value: caloriesProgress.toDouble()),
                      Center(
                        child: Text('${consumedCalories.toStringAsFixed(0)}'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Калории: ${consumedCalories.toStringAsFixed(0)} / ${targetCalories.toStringAsFixed(0)}'),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: proteinProgress),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(value: fatProgress),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(value: carbsProgress),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

