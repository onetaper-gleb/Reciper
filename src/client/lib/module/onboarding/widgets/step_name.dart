import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/utils/onboarding_validators.dart';
import 'package:client/domain/bloc/onboarding/onboarding_bloc.dart';
import 'package:client/domain/bloc/onboarding/onboarding_event.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';
import 'package:client/module/onboarding/onboarding_controller.dart';

class StepName extends StatefulWidget {
  const StepName({super.key});

  @override
  State<StepName> createState() => _StepNameState();
}

class _StepNameState extends State<StepName> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final s = context.read<OnboardingBloc>().state;
    final initial = s is OnboardingEditing ? s.draft.name : '';
    _controller = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text;
    final err = OnboardingValidators.nameError(name);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    final s = context.read<OnboardingBloc>().state;
    if (s is! OnboardingEditing) return;
    context.read<OnboardingBloc>().add(
          OnboardingDraftUpdated(s.draft.copyWith(name: name.trim())),
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
          Text('Как тебя зовут?', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Имя',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const Spacer(),
          FilledButton(
            onPressed: _submit,
            child: const Text('Далее'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
