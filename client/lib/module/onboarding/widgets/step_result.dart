import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/domain/bloc/onboarding/onboarding_bloc.dart';
import 'package:client/domain/bloc/onboarding/onboarding_event.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';

class StepResult extends StatelessWidget {
  const StepResult({super.key});

  void _finish(BuildContext context) {
    context.read<OnboardingBloc>().add(const OnboardingFinished());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is! OnboardingEditing) {
          return const Center(child: CircularProgressIndicator());
        }
        final draft = state.draft;
        final n = state.nutritionPreview;
        if (n == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final kcal = n.dailyCalories.round();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Отлично, ${draft.name}!',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Твоя ориентировочная норма: ~$kcal ккал в день.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Б: ${n.proteinG.toStringAsFixed(0)} г · '
                'Ж: ${n.fatG.toStringAsFixed(0)} г · '
                'У: ${n.carbsG.toStringAsFixed(0)} г',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Сейчас можно составить первый план питания или сначала '
                'осмотреть приложение.',
                style: theme.textTheme.bodyMedium,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => _finish(context),
                child: const Text('Составить план'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => _finish(context),
                child: const Text('Пропустить и посмотреть приложение'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
