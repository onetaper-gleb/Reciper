import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/domain/bloc/onboarding/onboarding_bloc.dart';
import 'package:client/domain/bloc/onboarding/onboarding_event.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/module/onboarding/onboarding_controller.dart';

class StepGoal extends StatelessWidget {
  const StepGoal({super.key});

  void _pick(BuildContext context, Goal goal) {
    final s = context.read<OnboardingBloc>().state;
    if (s is! OnboardingEditing) return;
    context.read<OnboardingBloc>().add(
          OnboardingDraftUpdated(s.draft.copyWith(goal: goal)),
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
          Text('Твоя цель', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _GoalTile(
                  emoji: '🔥',
                  title: 'Похудение',
                  onTap: () => _pick(context, Goal.loseWeight),
                ),
                const SizedBox(height: 10),
                _GoalTile(
                  emoji: '💪',
                  title: 'Набор массы',
                  onTap: () => _pick(context, Goal.gainMuscle),
                ),
                const SizedBox(height: 10),
                _GoalTile(
                  emoji: '⚖️',
                  title: 'Поддержание веса',
                  onTap: () => _pick(context, Goal.maintain),
                ),
                const SizedBox(height: 10),
                _GoalTile(
                  emoji: '🏃',
                  title: 'Сушка / рельеф',
                  onTap: () => _pick(context, Goal.cutting),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.emoji,
    required this.title,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
