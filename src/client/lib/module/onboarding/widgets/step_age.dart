import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/utils/onboarding_validators.dart';
import 'package:client/domain/bloc/onboarding/onboarding_bloc.dart';
import 'package:client/domain/bloc/onboarding/onboarding_event.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';
import 'package:client/module/onboarding/onboarding_controller.dart';

class StepAge extends StatefulWidget {
  const StepAge({super.key});

  @override
  State<StepAge> createState() => _StepAgeState();
}

class _StepAgeState extends State<StepAge> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final s = context.read<OnboardingBloc>().state;
    final initial = s is OnboardingEditing && s.draft.age != null
        ? '${s.draft.age}'
        : '';
    _controller = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final parsed = int.tryParse(_controller.text.trim());
    final err = OnboardingValidators.ageError(parsed);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    final s = context.read<OnboardingBloc>().state;
    if (s is! OnboardingEditing) return;
    context.read<OnboardingBloc>().add(
          OnboardingDraftUpdated(s.draft.copyWith(age: parsed)),
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
          Text('Сколько тебе лет?', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Возраст',
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
