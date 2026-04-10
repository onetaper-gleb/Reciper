import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:client/app/dependencies.dart';
import 'package:client/app/dependencies_scope.dart';
import 'package:client/core/utils/nutrition_calculator.dart';
import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/domain/bloc/meal_plan/meal_plan_bloc.dart';
import 'package:client/domain/bloc/meal_plan/meal_plan_event.dart';
import 'package:client/domain/bloc/profile/profile_bloc.dart';
import 'package:client/domain/bloc/profile/profile_event.dart';
import 'package:client/domain/bloc/profile/profile_state.dart';
import 'package:client/domain/bloc/progress/progress_bloc.dart';
import 'package:client/domain/bloc/progress/progress_event.dart';
import 'package:client/domain/bloc/progress/progress_state.dart';
import 'package:client/domain/models/enums/budget_level.dart';
import 'package:client/domain/models/enums/diet_type.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/enums/weight_history_period.dart';
import 'package:client/domain/models/profile.dart';
import 'package:client/domain/models/progress_statistics.dart';
import 'package:client/domain/models/user_preferences.dart';
import 'package:client/module/onboarding/widgets/step_allergies.dart';
import 'package:client/module/plan_generation/plan_generation_screen.dart';
import 'package:client/module/profile/plan_history_detail_screen.dart';
import 'package:client/module/profile/widgets/weight_chart.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserPreferences? _prefs;
  var _prefsReady = false;

  var _editingProfile = false;
  var _editorsBoundProfileId = -1;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _ageCtrl;
  late final TextEditingController _heightCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _targetCtrl;
  Goal? _editGoal;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _ageCtrl = TextEditingController();
    _heightCtrl = TextEditingController();
    _weightCtrl = TextEditingController();
    _targetCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  Future<void> _ensurePrefs() async {
    if (_prefsReady) return;
    final deps = DependenciesScope.of(context);
    final p = await deps.preferencesRepository.getOrCreateDefaults();
    if (!mounted) return;
    setState(() {
      _prefs = p;
      _prefsReady = true;
    });
  }

  void _syncEditors(Profile p) {
    _nameCtrl.text = p.name;
    _ageCtrl.text = '${p.age}';
    _heightCtrl.text = p.heightCm.toStringAsFixed(0);
    _weightCtrl.text = p.weightKg.toStringAsFixed(1);
    _targetCtrl.text = p.targetWeightKg.toStringAsFixed(1);
    _editGoal = p.goal;
  }

  Future<void> _persistPrefs(UserPreferences next) async {
    final deps = DependenciesScope.of(context);
    await deps.preferencesRepository.updatePreferences(next);
    if (mounted) setState(() => _prefs = next);
  }

  Future<void> _openWeightDialog() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Записать вес'),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Вес, кг',
            hintText: 'например 72.4',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final v = double.tryParse(ctrl.text.replaceAll(',', '.'));
    if (v == null || v < 20 || v > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите вес от 20 до 300 кг')),
      );
      return;
    }
    context.read<ProgressBloc>().add(
          WeightEntryAdded(weightKg: v, date: DateTime.now().toUtc()),
        );
  }

  Future<void> _confirmReset() async {
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Сбросить все данные?'),
        content: const Text(
          'Профиль, планы, холодильник, вес и настройки будут удалены. '
          'Действие необратимо.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
    if (go != true || !mounted) return;
    final deps = DependenciesScope.of(context);
    await deps.database.clearAllUserData();
    await deps.settingsRepository.clearAll();
    deps.sessionEpoch.value++;
  }

  Future<void> _saveProfile(Profile current) async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Имя не может быть пустым')),
      );
      return;
    }
    final age = int.tryParse(_ageCtrl.text.trim());
    final h = double.tryParse(_heightCtrl.text.trim().replaceAll(',', '.'));
    final w = double.tryParse(_weightCtrl.text.trim().replaceAll(',', '.'));
    final tw = double.tryParse(_targetCtrl.text.trim().replaceAll(',', '.'));
    if (age == null || age < 10 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Возраст: 10–120')),
      );
      return;
    }
    if (h == null || h < 50 || h > 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Рост: 50–250 см')),
      );
      return;
    }
    if (w == null || w < 20 || w > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вес: 20–300 кг')),
      );
      return;
    }
    if (tw == null || tw < 20 || tw > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Целевой вес: 20–300 кг')),
      );
      return;
    }
    final g = _editGoal ?? current.goal;
    final updated = current.copyWith(
      name: name,
      age: age,
      heightCm: h,
      weightKg: w,
      targetWeightKg: tw,
      goal: g,
    );

    if (updated.goal != current.goal) {
      final regen = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Цель изменилась'),
          content: const Text(
            'Пересоздать план питания под новую цель?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Не сейчас'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Да, составить план'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      context.read<ProfileBloc>().add(ProfileUpdated(updated));
      setState(() => _editingProfile = false);
      if (regen == true) {
        await Navigator.of(context, rootNavigator: true).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => const PlanGenerationScreen(),
          ),
        );
        if (mounted) {
          context.read<MealPlanBloc>().add(const MealPlanLoadRequested());
        }
      }
      return;
    }

    context.read<ProfileBloc>().add(ProfileUpdated(updated));
    setState(() => _editingProfile = false);
  }

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensurePrefs());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is ProfileError) {
            return Center(child: Text(profileState.message));
          }
          if (profileState is! ProfileLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final profile = profileState.profile;
          if (!_editingProfile && profile.id != _editorsBoundProfileId) {
            _syncEditors(profile);
            _editorsBoundProfileId = profile.id;
          }

          return BlocBuilder<ProgressBloc, ProgressState>(
            builder: (context, progressState) {
              final progressLoaded = progressState is ProgressLoaded
                  ? progressState
                  : null;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProgressBloc>().add(const ProgressLoadRequested());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _UserCard(
                      profile: profile,
                      editing: _editingProfile,
                      onToggleEdit: () {
                        setState(() {
                          _editingProfile = !_editingProfile;
                          if (_editingProfile) {
                            _syncEditors(profile);
                          }
                        });
                      },
                      nameCtrl: _nameCtrl,
                      ageCtrl: _ageCtrl,
                      heightCtrl: _heightCtrl,
                      weightCtrl: _weightCtrl,
                      targetCtrl: _targetCtrl,
                      editGoal: _editGoal ?? profile.goal,
                      onGoalChanged: (g) => setState(() => _editGoal = g),
                      onSave: () => _saveProfile(profile),
                    ),
                    const SizedBox(height: 16),
                    if (progressLoaded != null) ...[
                      _SectionTitle('Вес'),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: WeightHistoryPeriod.values
                                    .map(
                                      (p) => ChoiceChip(
                                        label: Text(p.labelRu),
                                        selected:
                                            progressLoaded.weightPeriod == p,
                                        onSelected: (_) {
                                          context.read<ProgressBloc>().add(
                                                ProgressWeightPeriodChanged(p),
                                              );
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 16),
                              WeightChart(
                                entries: progressLoaded.weightHistory,
                                targetWeightKg: profile.targetWeightKg,
                                trendLabel: progressLoaded.trend,
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                onPressed: _openWeightDialog,
                                icon: const Icon(Icons.add),
                                label: const Text('Записать вес'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SectionTitle('Результативность'),
                      Text(
                        'Зажмите карточку метрики, чтобы увидеть пояснение.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.65),
                            ),
                      ),
                      const SizedBox(height: 8),
                      _MetricsGrid(stats: progressLoaded.statistics),
                    ] else if (progressState is ProgressLoading)
                      const Center(child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ))
                    else if (progressState is ProgressError)
                      Text(progressState.message),
                    const SizedBox(height: 16),
                    _SectionTitle('Мои предпочтения'),
                    if (_prefs != null)
                      _PreferencesCard(
                        prefs: _prefs!,
                        onChanged: _persistPrefs,
                      )
                    else
                      const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 16),
                    _SectionTitle('История планов'),
                    _PlanHistorySection(
                      onOpen: (g) {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => PlanHistoryDetailScreen(graph: g),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle('Настройки'),
                    _SettingsCard(
                      deps: deps,
                      onThemeChanged: (mode) async {
                        final s = switch (mode) {
                          ThemeMode.light => 'light',
                          ThemeMode.dark => 'dark',
                          ThemeMode.system => 'system',
                        };
                        await deps.settingsRepository.setThemeMode(s);
                        deps.themeModeNotifier.value = mode;
                        if (mounted) setState(() {});
                      },
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: _confirmReset,
                      child: const Text('Сбросить все данные'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.profile,
    required this.editing,
    required this.onToggleEdit,
    required this.nameCtrl,
    required this.ageCtrl,
    required this.heightCtrl,
    required this.weightCtrl,
    required this.targetCtrl,
    required this.editGoal,
    required this.onGoalChanged,
    required this.onSave,
  });

  final Profile profile;
  final bool editing;
  final VoidCallback onToggleEdit;
  final TextEditingController nameCtrl;
  final TextEditingController ageCtrl;
  final TextEditingController heightCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController targetCtrl;
  final Goal editGoal;
  final ValueChanged<Goal> onGoalChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final n = NutritionCalculator.dailyTargets(
      gender: profile.gender,
      age: profile.age,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      activityLevel: profile.activityLevel,
      goal: profile.goal,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '🥗',
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (editing)
                        TextField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Имя',
                          ),
                        )
                      else
                        Text(
                          profile.name,
                          style: theme.textTheme.headlineSmall,
                        ),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(_goalRu(editing ? editGoal : profile.goal)),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onToggleEdit,
                  child: Text(editing ? 'Отмена' : 'Редактировать'),
                ),
              ],
            ),
            if (!editing) ...[
              const SizedBox(height: 8),
              Text(
                'Ориентир: ~${n.dailyCalories.round()} ккал/день',
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (editing) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ageCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Возраст'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<Goal>(
                      key: ValueKey(editGoal),
                      initialValue: editGoal,
                      decoration: const InputDecoration(labelText: 'Цель'),
                      items: Goal.values
                          .map(
                            (g) => DropdownMenuItem(
                              value: g,
                              child: Text(_goalRu(g)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) onGoalChanged(v);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: heightCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Рост, см'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: weightCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Вес, кг'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: targetCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Целевой вес, кг'),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: onSave,
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _goalRu(Goal g) => switch (g) {
        Goal.loseWeight => 'Похудение',
        Goal.maintain => 'Поддержание',
        Goal.gainMuscle => 'Набор массы',
        Goal.cutting => 'Сушка',
      };
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.stats});

  final ProgressStatistics stats;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.4,
      children: [
        _MetricTile(
          title: 'В текущем плане',
          value: '${stats.daysOnPlan}',
          hint:
              'Сколько календарных дней (по вашему времени на устройстве) вы уже '
              'в активном плане: от даты начала до сегодня, но не позже даты '
              'окончания плана.',
        ),
        _MetricTile(
          title: 'Блюд приготовлено',
          value: '${stats.mealsCooked}',
          hint:
              'Сколько раз вы отметили блюдо как приготовленное во всех '
              'сохранённых планах.',
        ),
        _MetricTile(
          title: 'Подряд по плану',
          value: '${stats.consecutiveFullPlanDays}',
          hint:
              'Подряд идущие дни активного плана, когда отмечены все приёмы '
              'пищи на этот день. Пропущенный день или неотмеченное блюдо '
              'обнуляют серию.',
        ),
        _MetricTile(
          title: 'Ккал/день (факт)',
          value: stats.averageConsumedKcalPastDays != null
              ? stats.averageConsumedKcalPastDays!.round().toString()
              : '—',
          hint:
              'Средняя калорийность по уже прошедшим дням активного плана '
              '(сегодня не считается): учитываются только блюда, отмеченные '
              'как съеденные.',
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.hint,
  });

  final String title;
  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      triggerMode: TooltipTriggerMode.longPress,
      showDuration: const Duration(seconds: 6),
      message: hint,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferencesCard extends StatefulWidget {
  const _PreferencesCard({
    required this.prefs,
    required this.onChanged,
  });

  final UserPreferences prefs;
  final Future<void> Function(UserPreferences) onChanged;

  @override
  State<_PreferencesCard> createState() => _PreferencesCardState();
}

class _PreferencesCardState extends State<_PreferencesCard> {
  late final TextEditingController _dislikedInput;
  late final TextEditingController _likedInput;

  @override
  void initState() {
    super.initState();
    _dislikedInput = TextEditingController();
    _likedInput = TextEditingController();
  }

  @override
  void dispose() {
    _dislikedInput.dispose();
    _likedInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.prefs;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Нелюбимые продукты', style: theme.textTheme.titleSmall),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final x in p.dislikedProducts)
                  InputChip(
                    label: Text(x),
                    onDeleted: () {
                      widget.onChanged(
                        p.copyWith(
                          dislikedProducts:
                              p.dislikedProducts.where((e) => e != x).toList(),
                        ),
                      );
                    },
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dislikedInput,
                    decoration: const InputDecoration(
                      hintText: 'Добавить и Enter',
                    ),
                    onSubmitted: (s) {
                      final t = s.trim();
                      if (t.isEmpty) return;
                      if (p.dislikedProducts.contains(t)) return;
                      widget.onChanged(
                        p.copyWith(
                          dislikedProducts: [...p.dislikedProducts, t],
                        ),
                      );
                      _dislikedInput.clear();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Любимые продукты', style: theme.textTheme.titleSmall),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final x in p.likedProducts)
                  InputChip(
                    label: Text(x),
                    onDeleted: () {
                      widget.onChanged(
                        p.copyWith(
                          likedProducts:
                              p.likedProducts.where((e) => e != x).toList(),
                        ),
                      );
                    },
                  ),
              ],
            ),
            TextField(
              controller: _likedInput,
              decoration: const InputDecoration(
                hintText: 'Добавить и Enter',
              ),
              onSubmitted: (s) {
                final t = s.trim();
                if (t.isEmpty) return;
                if (p.likedProducts.contains(t)) return;
                widget.onChanged(
                  p.copyWith(likedProducts: [...p.likedProducts, t]),
                );
                _likedInput.clear();
              },
            ),
            const SizedBox(height: 16),
            Text('Аллергии и ограничения', style: theme.textTheme.titleSmall),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final opt in OnboardingAllergyOption.presets)
                  FilterChip(
                    label: Text(opt.label),
                    selected: p.allergies.contains(opt.id),
                    onSelected: (sel) {
                      final next = List<String>.from(p.allergies);
                      if (sel) {
                        if (!next.contains(opt.id)) next.add(opt.id);
                      } else {
                        next.remove(opt.id);
                      }
                      widget.onChanged(p.copyWith(allergies: next));
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Макс. время готовки: ${p.maxCookingMinutes} мин',
              style: theme.textTheme.bodyMedium,
            ),
            Slider(
              value: p.maxCookingMinutes.toDouble(),
              min: 10,
              max: 120,
              divisions: 22,
              label: '${p.maxCookingMinutes} мин',
              onChanged: (v) {
                widget.onChanged(
                  p.copyWith(maxCookingMinutes: v.round()),
                );
              },
            ),
            DropdownButtonFormField<BudgetLevel>(
              key: ValueKey('budget-${p.id}-${p.budget}'),
              initialValue: p.budget,
              decoration: const InputDecoration(labelText: 'Бюджет'),
              items: BudgetLevel.values
                  .map(
                    (b) => DropdownMenuItem(
                      value: b,
                      child: Text(_budgetRu(b)),
                    ),
                  )
                  .toList(),
              onChanged: (b) {
                if (b != null) widget.onChanged(p.copyWith(budget: b));
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<DietType>(
              key: ValueKey('diet-${p.id}-${p.dietType}'),
              initialValue: p.dietType,
              decoration: const InputDecoration(labelText: 'Тип питания'),
              items: DietType.values
                  .map(
                    (d) => DropdownMenuItem(
                      value: d,
                      child: Text(_dietRu(d)),
                    ),
                  )
                  .toList(),
              onChanged: (d) {
                if (d != null) widget.onChanged(p.copyWith(dietType: d));
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _budgetRu(BudgetLevel b) => switch (b) {
        BudgetLevel.low => 'Низкий',
        BudgetLevel.medium => 'Средний',
        BudgetLevel.high => 'Высокий',
      };

  static String _dietRu(DietType d) => switch (d) {
        DietType.omnivore => 'Обычное',
        DietType.vegetarian => 'Вегетарианство',
        DietType.vegan => 'Веганство',
        DietType.keto => 'Кето',
      };
}

class _PlanHistorySection extends StatelessWidget {
  const _PlanHistorySection({required this.onOpen});

  final void Function(StoredMealPlanGraph graph) onOpen;

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    return FutureBuilder<List<StoredMealPlanGraph>>(
      future: deps.mealPlanRepository.getPlanHistory(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = snap.data!;
        if (list.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Пока нет сохранённых планов'),
            ),
          );
        }
        final fmt = DateFormat.yMMMd('ru');
        return Column(
          children: [
            for (final g in list)
              Card(
                child: ListTile(
                  title: Text(
                    '${fmt.format(g.mealPlan.startDate)} — ${fmt.format(g.mealPlan.endDate)}',
                  ),
                  subtitle: Text(
                    g.mealPlan.isActive ? 'Активный' : 'Архив',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => onOpen(g),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SettingsCard extends StatefulWidget {
  const _SettingsCard({
    required this.deps,
    required this.onThemeChanged,
  });

  final Dependencies deps;
  final Future<void> Function(ThemeMode mode) onThemeChanged;

  @override
  State<_SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<_SettingsCard> {
  late bool _notifications;
  late bool _metric;
  late bool _weighRem;
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    final s = widget.deps.settingsRepository;
    _notifications = s.notificationsEnabled;
    _metric = s.useMetricUnits;
    _weighRem = s.weighReminderEnabled;
    _themeMode = _parseTheme(s.themeMode);
  }

  ThemeMode _parseTheme(String? raw) => switch (raw) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  @override
  Widget build(BuildContext context) {
    final s = widget.deps.settingsRepository;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.palette_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Цвет интерфейса',
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        'Светлая, тёмная или как в системе',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Светлая'),
                  icon: Icon(Icons.light_mode_outlined, size: 18),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Тёмная'),
                  icon: Icon(Icons.dark_mode_outlined, size: 18),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('Система'),
                  icon: Icon(Icons.brightness_auto_outlined, size: 18),
                ),
              ],
              selected: {_themeMode},
              onSelectionChanged: (set) async {
                final m = set.first;
                setState(() => _themeMode = m);
                await widget.onThemeChanged(m);
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Метрические единицы (кг, см)'),
              value: _metric,
              onChanged: (v) async {
                await s.setUseMetricUnits(v);
                setState(() => _metric = v);
              },
            ),
            SwitchListTile(
              title: const Text('Уведомления о приёмах пищи'),
              value: _notifications,
              onChanged: (v) async {
                await s.setNotificationsEnabled(v);
                setState(() => _notifications = v);
              },
            ),
            if (_notifications) ...[
              _TimeTile(
                title: 'Завтрак',
                timeStr: s.reminderBreakfastTime ?? '08:00',
                onPick: (t) => s.setReminderBreakfastTime(t),
                onAfterSave: () => setState(() {}),
              ),
              _TimeTile(
                title: 'Обед',
                timeStr: s.reminderLunchTime ?? '13:00',
                onPick: (t) => s.setReminderLunchTime(t),
                onAfterSave: () => setState(() {}),
              ),
              _TimeTile(
                title: 'Ужин',
                timeStr: s.reminderDinnerTime ?? '19:00',
                onPick: (t) => s.setReminderDinnerTime(t),
                onAfterSave: () => setState(() {}),
              ),
            ],
            SwitchListTile(
              title: const Text('Напоминание взвеситься'),
              value: _weighRem,
              onChanged: (v) async {
                await s.setWeighReminderEnabled(v);
                setState(() => _weighRem = v);
              },
            ),
            if (_weighRem)
              _TimeTile(
                title: 'Время напоминания',
                timeStr: s.weighReminderTime ?? '09:00',
                onPick: (t) => s.setWeighReminderTime(t),
                onAfterSave: () => setState(() {}),
              ),
          ],
        ),
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.title,
    required this.timeStr,
    required this.onPick,
    this.onAfterSave,
  });

  final String title;
  final String timeStr;
  final Future<void> Function(String) onPick;
  final VoidCallback? onAfterSave;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Text(timeStr),
      onTap: () async {
        final parts = timeStr.split(':');
        final h = int.tryParse(parts.first) ?? 8;
        final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
        final r = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: h, minute: m),
        );
        if (r == null) return;
        final next =
            '${r.hour.toString().padLeft(2, '0')}:${r.minute.toString().padLeft(2, '0')}';
        await onPick(next);
        onAfterSave?.call();
      },
    );
  }
}
