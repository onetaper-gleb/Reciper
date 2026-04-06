import 'package:flutter/material.dart';

import 'package:client/module/onboarding/onboarding_controller.dart';

class StepWelcome extends StatelessWidget {
  const StepWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scope = OnboardingControllerScope.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            'Привет! Я Reciper — твой AI-ассистент питания.',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Давай настроим всё под тебя за пару минут.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const Spacer(),
          FilledButton(
            onPressed: scope.goNext,
            child: const Text('Начнём'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
