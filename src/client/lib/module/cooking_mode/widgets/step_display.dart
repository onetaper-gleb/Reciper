import 'package:flutter/material.dart';

import 'package:client/domain/models/cooking_step.dart';

class StepDisplay extends StatelessWidget {
  const StepDisplay({
    super.key,
    required this.step,
    required this.stepIndex,
    required this.totalSteps,
  });

  final CookingStep step;
  final int stepIndex;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Шаг ${stepIndex + 1} из $totalSteps',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Шаг ${step.order}',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          step.instruction,
          style: theme.textTheme.titleLarge?.copyWith(height: 1.35),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
