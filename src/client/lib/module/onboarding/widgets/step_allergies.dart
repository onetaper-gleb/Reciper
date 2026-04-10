import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/domain/bloc/onboarding/onboarding_bloc.dart';
import 'package:client/domain/bloc/onboarding/onboarding_event.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';
import 'package:client/domain/models/onboarding_draft.dart';
import 'package:client/module/onboarding/onboarding_controller.dart';

/// Preset allergy / diet tags (optional step).
abstract final class OnboardingAllergyOption {
  static const lactoseFree = 'lactose_free';
  static const glutenFree = 'gluten_free';
  static const vegetarian = 'vegetarian';
  static const vegan = 'vegan';
  static const noNuts = 'no_nuts';
  static const halal = 'halal';
  static const kosher = 'kosher';
  static const noSeafood = 'no_seafood';

  static const List<({String id, String label})> presets = [
    (id: lactoseFree, label: 'Без лактозы'),
    (id: glutenFree, label: 'Без глютена'),
    (id: vegetarian, label: 'Вегетарианство'),
    (id: vegan, label: 'Веганство'),
    (id: noNuts, label: 'Без орехов'),
    (id: halal, label: 'Халяль'),
    (id: kosher, label: 'Кошер'),
    (id: noSeafood, label: 'Без морепродуктов'),
  ];
}

class StepAllergies extends StatefulWidget {
  const StepAllergies({super.key});

  @override
  State<StepAllergies> createState() => _StepAllergiesState();
}

class _StepAllergiesState extends State<StepAllergies> {
  late final TextEditingController _other;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final s = context.read<OnboardingBloc>().state;
    final other = s is OnboardingEditing ? s.draft.allergiesOther : '';
    _other = TextEditingController(text: other);

    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _other.dispose();
    super.dispose();
  }

  void _toggleTag(String id, List<String> current) {
    final next = List<String>.from(current);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    final s = context.read<OnboardingBloc>().state;
    if (s is! OnboardingEditing) return;
    context.read<OnboardingBloc>().add(
          OnboardingDraftUpdated(s.draft.copyWith(allergyTags: next)),
        );
  }

  void _goToSummary() {
    final s = context.read<OnboardingBloc>().state;
    if (s is! OnboardingEditing) return;
    final bloc = context.read<OnboardingBloc>();
    bloc.add(
      OnboardingDraftUpdated(
        s.draft.copyWith(allergiesOther: _other.text.trim()),
      ),
    );
    bloc.add(const OnboardingPrepareSummary());
    FocusManager.instance.primaryFocus?.unfocus();
    OnboardingControllerScope.of(context).goNext();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      buildWhen: (p, c) =>
          c is OnboardingEditing && (p is! OnboardingEditing || c.draft != p.draft),
      builder: (context, state) {
        final draft = state is OnboardingEditing
            ? state.draft
            : const OnboardingDraft();
        final tags = draft.allergyTags;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Аллергии и предпочтения',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Можно пропустить — это необязательно.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final p in OnboardingAllergyOption.presets)
                        FilterChip(
                          label: Text(p.label),
                          selected: tags.contains(p.id),
                          onSelected: (_) => _toggleTag(p.id, tags),
                        ),
                    ],
                  ),
                ),
              ),
              TextField(
                focusNode: _focusNode,
                controller: _other,
                decoration: InputDecoration(
                  labelText: !_focusNode.hasFocus ? 'Другое (свой вариант)' : '',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _goToSummary,
                child: const Text('Далее'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
