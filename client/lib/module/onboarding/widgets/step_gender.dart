import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/domain/bloc/onboarding/onboarding_bloc.dart';
import 'package:client/domain/bloc/onboarding/onboarding_event.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';
import 'package:client/domain/models/enums/gender.dart';
import 'package:client/module/onboarding/onboarding_controller.dart';

class StepGender extends StatelessWidget {
  const StepGender({super.key});

  void _pick(BuildContext context, Gender gender) {
    final s = context.read<OnboardingBloc>().state;
    if (s is! OnboardingEditing) return;
    context.read<OnboardingBloc>().add(
          OnboardingDraftUpdated(s.draft.copyWith(gender: gender)),
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
          Text('Твой пол', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Нужен для точного расчёта калорийности.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          _GenderCard(
            label: 'Мужской',
            onTap: () => _pick(context, Gender.male),
          ),
          const SizedBox(height: 12),
          _GenderCard(
            label: 'Женский',
            onTap: () => _pick(context, Gender.female),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
