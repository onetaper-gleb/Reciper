import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../app/dependencies_scope.dart';
import '../../data/repository/meal_plan_repository.dart';
import '../../data/repository/profile_repository.dart';
import '../../domain/bloc/plan_generation/plan_generation_bloc.dart';
import '../../domain/bloc/plan_generation/plan_generation_event.dart';
import '../../domain/bloc/plan_generation/plan_generation_state.dart';
import '../../domain/models/enums/goal.dart';
import '../../domain/models/profile.dart';

class PlanGenerationScreen extends StatelessWidget {
  const PlanGenerationScreen({super.key, this.planStartDate});

  /// When set, the generated plan’s first day is anchored to this calendar date (local).
  final DateTime? planStartDate;

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    return BlocProvider(
      create: (_) => PlanGenerationBloc(
        mealPlanRepository: deps.mealPlanRepository,
        profileRepository: deps.profileRepository,
        preferencesRepository: deps.preferencesRepository,
        planStartDate: planStartDate,
        fridgeProductsJsonLoader: () async {
          final rows = await deps.database.fridgeDao.getAllFridgeProducts();
          return rows
              .map(
                (e) => <String, dynamic>{
                  'name': e.name,
                  'amount': e.amount,
                  'unit': e.unit,
                },
              )
              .toList();
        },
      ),
      child: const _PlanGenerationScaffold(),
    );
  }
}

class _PlanGenerationScaffold extends StatelessWidget {
  const _PlanGenerationScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Составить план'),
      ),
      body: BlocBuilder<PlanGenerationBloc, PlanGenerationState>(
        builder: (context, state) {
          return switch (state) {
            PlanGenerating() => const _GeneratingView(),
            PlanGenerated(:final plan) => _SuccessView(plan: plan),
            PlanGenerationError(:final message) => _ErrorView(message: message),
            PlanGenerationStepState() => _PlanWizard(
                profileRepository: DependenciesScope.of(context).profileRepository,
              ),
          };
        },
      ),
    );
  }
}

class _GeneratingView extends StatelessWidget {
  const _GeneratingView();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Создаём ваш план',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Нейросеть подбирает блюда под ваш профиль и выбранные параметры. Обычно это 10–40 секунд.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.plan});

  final StoredMealPlanGraph plan;

  @override
  Widget build(BuildContext context) {
    final mp = plan.mealPlan;
    final dateFmt = DateFormat('d MMMM yyyy', 'ru');
    final start = mp.startDate.toLocal();
    final end = mp.endDate.toLocal();
    final days = plan.days.length;
    final meals = plan.meals.length;
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.check_circle_rounded, size: 64, color: scheme.primary),
          const SizedBox(height: 16),
          Text(
            'План готов',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Период: ${dateFmt.format(start)} — ${dateFmt.format(end)}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SuccessStatRow(icon: Icons.calendar_today_outlined, label: 'Дней в плане', value: '$days'),
                  const Divider(height: 24),
                  _SuccessStatRow(icon: Icons.restaurant_outlined, label: 'Блюд всего', value: '$meals'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Перейти к плану'),
          ),
        ],
      ),
    );
  }
}

class _SuccessStatRow extends StatelessWidget {
  const _SuccessStatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: Theme.of(context).textTheme.titleSmall)),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 56,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Не удалось создать план',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            FilledButton(
              onPressed: () =>
                  context.read<PlanGenerationBloc>().add(const GenerationRequested()),
              child: const Text('Повторить попытку'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanWizard extends StatefulWidget {
  const _PlanWizard({required this.profileRepository});

  final ProfileRepository profileRepository;

  @override
  State<_PlanWizard> createState() => _PlanWizardState();
}

class _PlanWizardState extends State<_PlanWizard> {
  final PageController _page = PageController();
  final TextEditingController _notes = TextEditingController();

  int _pageIndex = 0;
  static const int _pageCount = 7;

  int _days = 7;
  int _mealsPerDay = 5;
  String _cookWhen = 'evening';
  bool _useFridge = true;
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await widget.profileRepository.getProfile();
    if (mounted) setState(() => _profile = p);
  }

  @override
  void dispose() {
    _page.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _next() {
    if (_pageIndex < _pageCount - 1) {
      _page.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _back() {
    if (_pageIndex > 0) {
      _page.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _submit() {
    final bloc = context.read<PlanGenerationBloc>();
    bloc.add(
      StepCompleted(
        stepKey: 'period',
        data: {'days': _days, 'meals_per_day': _mealsPerDay},
      ),
    );
    bloc.add(StepCompleted(stepKey: 'cook_when', data: {'value': _cookWhen}));
    bloc.add(StepCompleted(stepKey: 'fridge', data: {'use': _useFridge}));
    bloc.add(
      StepCompleted(
        stepKey: 'notes',
        data: {'text': _notes.text.trim()},
      ),
    );
    bloc.add(const GenerationRequested());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (_pageIndex + 1) / _pageCount,
                  minHeight: 6,
                  backgroundColor: scheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Шаг ${_pageIndex + 1} из $_pageCount',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            controller: _page,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (i) => setState(() => _pageIndex = i),
            children: [
              _IntroPage(profile: _profile, onNext: _next),
              _DaysPage(
                value: _days,
                onChanged: (v) => setState(() => _days = v),
                onNext: _next,
                onBack: _back,
              ),
              _MealsPage(
                value: _mealsPerDay,
                onChanged: (v) => setState(() => _mealsPerDay = v),
                onNext: _next,
                onBack: _back,
              ),
              _CookWhenPage(
                value: _cookWhen,
                onChanged: (v) => setState(() => _cookWhen = v),
                onNext: _next,
                onBack: _back,
              ),
              _FridgePage(
                value: _useFridge,
                onChanged: (v) => setState(() => _useFridge = v),
                onNext: _next,
                onBack: _back,
              ),
              _NotesPage(
                controller: _notes,
                onNext: _next,
                onBack: _back,
              ),
              _ReviewPage(
                days: _days,
                mealsPerDay: _mealsPerDay,
                cookWhen: _cookWhen,
                useFridge: _useFridge,
                notes: _notes.text.trim(),
                onSubmit: _submit,
                onBack: _back,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({required this.profile, required this.onNext});

  final Profile? profile;
  final VoidCallback onNext;

  static String _goalLabel(Goal g) => switch (g) {
        Goal.loseWeight => 'Похудение',
        Goal.maintain => 'Поддержание веса',
        Goal.gainMuscle => 'Набор массы',
        Goal.cutting => 'Сушка / рельеф',
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Icon(Icons.restaurant_menu_rounded, size: 56, color: scheme.primary),
          const SizedBox(height: 20),
          Text(
            'Персональный план питания',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ответьте на несколько вопросов — мы отправим ваш профиль и пожелания на сервер, и нейросеть составит меню.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.5,
                ),
          ),
          if (profile != null) ...[
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ваш профиль',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text('${profile!.name}, цель: ${_goalLabel(profile!.goal)}'),
                    Text(
                      '${profile!.weightKg.toStringAsFixed(0)} кг → ${profile!.targetWeightKg.toStringAsFixed(0)} кг',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          FilledButton(
            onPressed: onNext,
            child: const Text('Начать'),
          ),
        ],
      ),
    );
  }
}

class _DaysPage extends StatelessWidget {
  const _DaysPage({
    required this.value,
    required this.onChanged,
    required this.onNext,
    required this.onBack,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final options = const [1, 3, 7, 14];
    return _WizardStepShell(
      title: 'На какой период?',
      subtitle: 'Выберите длину плана — чем дольше период, тем больше разнообразия в меню.',
      onBack: onBack,
      onPrimary: onNext,
      primaryLabel: 'Далее',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: options.map((d) {
          final selected = value == d;
          return ChoiceChip(
            label: Text('$d ${_dayWord(d)}'),
            selected: selected,
            onSelected: (_) => onChanged(d),
          );
        }).toList(),
      ),
    );
  }

  static String _dayWord(int d) {
    if (d == 1) return 'день';
    if (d >= 2 && d <= 4) return 'дня';
    return 'дней';
  }
}

class _MealsPage extends StatelessWidget {
  const _MealsPage({
    required this.value,
    required this.onChanged,
    required this.onNext,
    required this.onBack,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _WizardStepShell(
      title: 'Приёмы пищи в день',
      subtitle: 'Сколько раз в день вы хотите есть по этому плану?',
      onBack: onBack,
      onPrimary: onNext,
      primaryLabel: 'Далее',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [3, 4, 5].map((m) {
          return ChoiceChip(
            label: Text('$m ${_mealWord(m)}'),
            selected: value == m,
            onSelected: (_) => onChanged(m),
          );
        }).toList(),
      ),
    );
  }

  static String _mealWord(int m) {
    if (m == 1) return 'приём';
    if (m >= 2 && m <= 4) return 'приёма';
    return 'приёмов';
  }
}

class _CookWhenPage extends StatelessWidget {
  const _CookWhenPage({
    required this.value,
    required this.onChanged,
    required this.onNext,
    required this.onBack,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  static const _options = <({String id, String title, String desc})>[
    (id: 'morning', title: 'Утром', desc: 'Готовлю основные блюда по утрам'),
    (id: 'evening', title: 'Вечером', desc: 'На ужин или на следующий день'),
    (id: 'weekend_prep', title: 'Meal prep в выходные', desc: 'Заготовки на неделю'),
  ];

  @override
  Widget build(BuildContext context) {
    return _WizardStepShell(
      title: 'Когда удобно готовить?',
      subtitle: 'Это поможет подобрать реалистичные рецепты под ваш ритм.',
      onBack: onBack,
      onPrimary: onNext,
      primaryLabel: 'Далее',
      child: Column(
        children: _options.map((o) {
          final selected = value == o.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: selected
                  ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.55)
                  : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onChanged(o.id),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(
                        selected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              o.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              o.desc,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FridgePage extends StatelessWidget {
  const _FridgePage({
    required this.value,
    required this.onChanged,
    required this.onNext,
    required this.onBack,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _WizardStepShell(
      title: 'Продукты из холодильника',
      subtitle:
          'Если включить, в запрос уйдёт список из раздела «Холодильник» (если вы его заполняли).',
      onBack: onBack,
      onPrimary: onNext,
      primaryLabel: 'Далее',
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Учитывать при составлении плана'),
        subtitle: const Text('Рекомендуем, если список продуктов актуален'),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _NotesPage extends StatelessWidget {
  const _NotesPage({
    required this.controller,
    required this.onNext,
    required this.onBack,
  });

  final TextEditingController controller;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _WizardStepShell(
      title: 'Дополнительно',
      subtitle:
          'Например: «по вторникам ем вне дома», «больше рыбы», «без ужина после 20:00». Можно пропустить.',
      onBack: onBack,
      onPrimary: onNext,
      primaryLabel: 'Далее',
      child: TextField(
        controller: controller,
        maxLines: 5,
        minLines: 3,
        decoration: const InputDecoration(
          hintText: 'Ваши пожелания для AI…',
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class _ReviewPage extends StatelessWidget {
  const _ReviewPage({
    required this.days,
    required this.mealsPerDay,
    required this.cookWhen,
    required this.useFridge,
    required this.notes,
    required this.onSubmit,
    required this.onBack,
  });

  final int days;
  final int mealsPerDay;
  final String cookWhen;
  final bool useFridge;
  final String notes;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  static String _whenLabel(String id) => switch (id) {
        'morning' => 'Утром',
        'weekend_prep' => 'Meal prep в выходные',
        _ => 'Вечером',
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _WizardStepShell(
      title: 'Проверьте параметры',
      subtitle: 'После нажатия кнопки запрос уйдёт на сервер для генерации.',
      onBack: onBack,
      onPrimary: onSubmit,
      primaryLabel: 'Сгенерировать план',
      child: Card(
        elevation: 0,
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewRow(label: 'Период', value: '$days дн.'),
              _ReviewRow(label: 'Приёмы пищи', value: '$mealsPerDay в день'),
              _ReviewRow(label: 'Готовка', value: _whenLabel(cookWhen)),
              _ReviewRow(
                label: 'Холодильник',
                value: useFridge ? 'Учитывать' : 'Не учитывать',
              ),
              if (notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Пожелания', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(notes, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WizardStepShell extends StatelessWidget {
  const _WizardStepShell({
    required this.title,
    required this.subtitle,
    required this.child,
    this.onBack,
    required this.onPrimary,
    required this.primaryLabel,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback? onBack;
  final VoidCallback onPrimary;
  final String primaryLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                ),
                const SizedBox(height: 20),
                child,
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                if (onBack != null)
                  OutlinedButton(
                    onPressed: onBack,
                    child: const Text('Назад'),
                  ),
                if (onBack != null) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onPrimary,
                    child: Text(primaryLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
