import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/utils/onboarding_validators.dart';
import 'package:client/domain/bloc/onboarding/onboarding_bloc.dart';
import 'package:client/domain/bloc/onboarding/onboarding_event.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';
import 'package:client/module/onboarding/onboarding_controller.dart';

class StepBody extends StatefulWidget {
  const StepBody({super.key});

  @override
  State<StepBody> createState() => _StepBodyState();
}

class _StepBodyState extends State<StepBody> {
  late final TextEditingController _height;
  late final TextEditingController _weight;

  @override
  void initState() {
    super.initState();
    final s = context.read<OnboardingBloc>().state;
    if (s is OnboardingEditing) {
      _height = TextEditingController(
        text: s.draft.heightCm != null ? _fmt(s.draft.heightCm!) : '',
      );
      _weight = TextEditingController(
        text: s.draft.weightKg != null ? _fmt(s.draft.weightKg!) : '',
      );
    } else {
      _height = TextEditingController();
      _weight = TextEditingController();
    }
  }

  static String _fmt(double v) {
    if (v == v.roundToDouble()) return '${v.toInt()}';
    return '$v';
  }

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  double? _parseDouble(String raw) {
    var t = raw.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  void _submit() {
    final h = _parseDouble(_height.text);
    final w = _parseDouble(_weight.text);
    final hErr = OnboardingValidators.heightCmError(h);
    final wErr = OnboardingValidators.weightKgError(w);
    if (hErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hErr)));
      return;
    }
    if (wErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(wErr)));
      return;
    }
    final s = context.read<OnboardingBloc>().state;
    if (s is! OnboardingEditing) return;
    context.read<OnboardingBloc>().add(
          OnboardingDraftUpdated(
            s.draft.copyWith(heightCm: h, weightKg: w),
          ),
        );
    FocusManager.instance.primaryFocus?.unfocus();
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
          Text('Параметры тела', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Рост в сантиметрах и вес в килограммах.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _height,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Рост (см)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weight,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Вес (кг)',
              border: OutlineInputBorder(),
            ),
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
