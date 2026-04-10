import 'package:flutter/material.dart';

class NutritionSummary extends StatelessWidget {
  const NutritionSummary({
    super.key,
    required this.targetCalories,
    required this.consumedCalories,
    required this.proteinProgress,
    required this.fatProgress,
    required this.carbsProgress,
    required this.consumedProteinG,
    required this.targetProteinG,
    required this.consumedFatG,
    required this.targetFatG,
    required this.consumedCarbsG,
    required this.targetCarbsG,
  });

  final double targetCalories;
  final double consumedCalories;
  final double proteinProgress;
  final double fatProgress;
  final double carbsProgress;
  final double consumedProteinG;
  final double targetProteinG;
  final double consumedFatG;
  final double targetFatG;
  final double consumedCarbsG;
  final double targetCarbsG;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final caloriesProgress =
        targetCalories > 0 ? (consumedCalories / targetCalories).clamp(0, 1) : 0.0;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Калории за день',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 88,
                  height: 88,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: caloriesProgress.toDouble(),
                        strokeWidth: 8,
                        backgroundColor: scheme.outlineVariant.withValues(alpha: 0.35),
                        color: scheme.primary,
                        strokeCap: StrokeCap.round,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              consumedCalories.toStringAsFixed(0),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1.1,
                                  ),
                            ),
                            Text(
                              'из ${targetCalories.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MacroRow(
                        label: 'Белки',
                        consumed: consumedProteinG,
                        target: targetProteinG,
                        progress: proteinProgress,
                        color: const Color(0xFF1565C0),
                      ),
                      const SizedBox(height: 10),
                      _MacroRow(
                        label: 'Жиры',
                        consumed: consumedFatG,
                        target: targetFatG,
                        progress: fatProgress,
                        color: const Color(0xFFF9A825),
                      ),
                      const SizedBox(height: 10),
                      _MacroRow(
                        label: 'Углеводы',
                        consumed: consumedCarbsG,
                        target: targetCarbsG,
                        progress: carbsProgress,
                        color: const Color(0xFF6A1B9A),
                      ),
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

class _MacroRow extends StatelessWidget {
  const _MacroRow({
    required this.label,
    required this.consumed,
    required this.target,
    required this.progress,
    required this.color,
  });

  final String label;
  final double consumed;
  final double target;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              '${consumed.toStringAsFixed(0)} / ${target.toStringAsFixed(0)} г',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress.toDouble(),
            minHeight: 6,
            backgroundColor: color.withValues(alpha: 0.15),
            color: color,
          ),
        ),
      ],
    );
  }
}
