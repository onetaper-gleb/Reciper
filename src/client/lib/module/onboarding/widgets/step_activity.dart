import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/domain/bloc/onboarding/onboarding_bloc.dart';
import 'package:client/domain/bloc/onboarding/onboarding_event.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';
import 'package:client/domain/models/enums/activity_level.dart';
import 'package:client/module/onboarding/onboarding_controller.dart';

class StepActivity extends StatelessWidget {
  const StepActivity({super.key});

  void _pick(BuildContext context, ActivityLevel level) {
    final s = context.read<OnboardingBloc>().state;
    if (s is! OnboardingEditing) return;
    context.read<OnboardingBloc>().add(
          OnboardingDraftUpdated(s.draft.copyWith(activityLevel: level)),
        );
    OnboardingControllerScope.of(context).goNext();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text('Уровень активности', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Чтобы точнее оценить расход калорий.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _ActivityTile(
                  title: 'Сидячий образ жизни',
                  subtitle: 'Мало движения в течение дня',
                  onTap: () => _pick(context, ActivityLevel.sedentary),
                ),
                const SizedBox(height: 10),
                _ActivityTile(
                  title: 'Лёгкая активность',
                  subtitle: '1–2 тренировки в неделю или ~10k шагов',
                  onTap: () => _pick(context, ActivityLevel.light),
                ),
                const SizedBox(height: 10),
                _ActivityTile(
                  title: 'Средняя активность',
                  subtitle: '3–4 тренировки в неделю',
                  onTap: () => _pick(context, ActivityLevel.moderate),
                ),
                const SizedBox(height: 10),
                _ActivityTile(
                  title: 'Высокая активность',
                  subtitle: '5+ тренировок в неделю',
                  onTap: () => _pick(context, ActivityLevel.active),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
