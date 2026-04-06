import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/dependencies_scope.dart';
import '../../domain/bloc/plan_generation/plan_generation_bloc.dart';
import '../../domain/bloc/plan_generation/plan_generation_event.dart';
import '../../domain/bloc/plan_generation/plan_generation_state.dart';

class PlanGenerationScreen extends StatelessWidget {
  const PlanGenerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    return BlocProvider(
      create: (_) => PlanGenerationBloc(
        mealPlanRepository: deps.mealPlanRepository,
        profileRepository: deps.profileRepository,
        preferencesRepository: deps.preferencesRepository,
      ),
      child: const _PlanGenerationView(),
    );
  }
}

class _PlanGenerationView extends StatelessWidget {
  const _PlanGenerationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Генерация плана')),
      body: BlocBuilder<PlanGenerationBloc, PlanGenerationState>(
        builder: (context, state) {
          if (state is PlanGenerating) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlanGenerated) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'План создан: ${state.plan.mealPlan.startDate.toIso8601String().substring(0, 10)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Принять план'),
                  ),
                ],
              ),
            );
          }
          if (state is PlanGenerationError) {
            return Center(child: Text(state.message));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Мини-визард (MVP): заполнение шагов будет расширено.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    context.read<PlanGenerationBloc>().add(
                          const StepCompleted(stepKey: 'period', data: {'days': 7, 'meals_per_day': 5}),
                        );
                    context.read<PlanGenerationBloc>().add(const GenerationRequested());
                  },
                  child: const Text('Составить план'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

