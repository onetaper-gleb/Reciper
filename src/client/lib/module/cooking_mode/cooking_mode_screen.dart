import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:client/domain/bloc/cooking_mode/cooking_mode_bloc.dart';
import 'package:client/domain/bloc/cooking_mode/cooking_mode_event.dart';
import 'package:client/domain/bloc/cooking_mode/cooking_mode_state.dart';
import 'package:client/domain/bloc/meal_plan/meal_plan_bloc.dart';
import 'package:client/domain/bloc/meal_plan/meal_plan_event.dart';
import 'package:client/domain/models/meal.dart';
import 'package:client/domain/models/recipe.dart';
import 'package:client/services/cooking_foreground_task.dart';
import 'package:client/services/cooking_mode_system_effects.dart';
import 'package:client/services/cooking_voice_command_parser.dart';
import 'package:client/services/speech_service.dart';
import 'package:client/services/tts_service.dart';

import 'widgets/step_display.dart';
import 'widgets/timer_widget.dart';
import 'widgets/voice_indicator.dart';

enum _CookingPhase { intro, active, complete }

/// Hands-free cooking flow: intro → steps → completion.
class CookingModeScreen extends StatefulWidget {
  const CookingModeScreen({
    super.key,
    required this.recipe,
    required this.meal,
    required this.mealPlanId,
  });

  final Recipe recipe;
  final Meal meal;
  final int mealPlanId;

  bool get canMarkMealInPlan => meal.id > 0 && mealPlanId > 0;

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen>
    with WidgetsBindingObserver {
  _CookingPhase _phase = _CookingPhase.intro;
  CookingModeBloc? _bloc;
  late final TtsService _tts = TtsService();
  late final SpeechService _speech = SpeechService();
  bool _servicesReady = false;
  bool _speechListening = false;
  int _stars = 0;
  bool? _thumbUp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FlutterForegroundTask.addTaskDataCallback(_onForegroundTaskData);
    _bootstrapServices();
  }

  Future<void> _bootstrapServices() async {
    await _tts.init();
    await _speech.init();
    await CookingForegroundTaskCoordinator.ensureInitialized();
    if (!mounted) return;
    setState(() {
      _servicesReady = true;
      _bloc = CookingModeBloc(
        effects: CookingModeSystemEffects(tts: _tts),
      );
    });
  }

  void _onForegroundTaskData(Object data) {
    if (data is! Map) return;
    final action = data['action']?.toString();
    final bloc = _bloc;
    if (bloc == null) return;
    switch (action) {
      case 'next':
        bloc.add(const NextStepRequested());
      case 'previous':
        bloc.add(const PreviousStepRequested());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _syncForegroundNotification();
    }
  }

  Future<void> _syncForegroundNotification() async {
    if (_phase != _CookingPhase.active || _bloc == null) return;
    final s = _bloc!.state;
    if (s is CookingModeActive) {
      await CookingForegroundTaskCoordinator.startOrUpdate(
        recipeTitle: s.recipe.title,
        stepText: s.currentStep.instruction,
        stepNumber: s.stepIndex + 1,
        totalSteps: s.totalSteps,
      );
    } else if (s is CookingModeTimerRunning) {
      await CookingForegroundTaskCoordinator.startOrUpdate(
        recipeTitle: s.recipe.title,
        stepText:
            'Таймер ${s.remainingSeconds} c — ${s.steps[s.stepIndex].instruction}',
        stepNumber: s.stepIndex + 1,
        totalSteps: s.steps.length,
      );
    }
  }

  Future<bool> _ensurePermissions() async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нужен доступ к микрофону для голосовых команд')),
        );
      }
      return false;
    }
    await CookingForegroundTaskCoordinator.requestNotificationPermissionIfNeeded();
    if (Platform.isAndroid) {
      final n = await Permission.notification.request();
      if (!n.isGranted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Без уведомлений foreground-сервис на Android может быть нестабилен'),
          ),
        );
      }
    }
    return true;
  }

  Future<void> _onStartCooking() async {
    if (!_servicesReady || _bloc == null) return;
    final ok = await _ensurePermissions();
    if (!ok || !mounted) return;
    _bloc!.add(CookingStarted(widget.recipe));
    setState(() => _phase = _CookingPhase.active);
    await CookingForegroundTaskCoordinator.startOrUpdate(
      recipeTitle: widget.recipe.title,
      stepText: widget.recipe.steps.isEmpty
          ? ''
          : (widget.recipe.steps.toList()..sort((a, b) => a.order.compareTo(b.order)))
              .first
              .instruction,
      stepNumber: 1,
      totalSteps: widget.recipe.steps.length,
    );
    _speech.setContinuousListening(
      enabled: true,
      onSessionEnded: () {
        if (!mounted || _phase != _CookingPhase.active) return;
        unawaited(_armSpeechListening());
      },
    );
    unawaited(_armSpeechListening());
  }

  Future<void> _armSpeechListening() async {
    if (!mounted || _phase != _CookingPhase.active) return;
    if (!_speech.isAvailable) return;
    setState(() => _speechListening = true);
    await _speech.startListening(
      onResult: (cmd, raw) {
        if (!mounted) return;
        setState(() => _speechListening = false);
        _handleVoiceCommand(cmd, raw);
      },
    );
  }

  void _handleVoiceCommand(CookingVoiceCommand? cmd, String _) {
    if (cmd == null) return;
    final bloc = _bloc;
    if (bloc == null || _phase != _CookingPhase.active) return;
    switch (cmd.kind) {
      case CookingVoiceCommandKind.stop:
        unawaited(_confirmExit());
      case CookingVoiceCommandKind.next:
        bloc.add(const VoiceCommandReceived(CookingVoiceKind.next));
      case CookingVoiceCommandKind.previous:
        bloc.add(const VoiceCommandReceived(CookingVoiceKind.previous));
      case CookingVoiceCommandKind.repeat:
        bloc.add(const VoiceCommandReceived(CookingVoiceKind.repeat));
      case CookingVoiceCommandKind.timer:
        final sec = cmd.timerSeconds;
        if (sec != null && sec > 0) {
          bloc.add(TimerStarted(seconds: sec));
        }
    }
  }

  Future<void> _confirmExit() async {
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Завершить готовку?'),
        content: const Text('Режим готовки будет закрыт.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
    if (go == true && mounted) {
      await _speech.stopListening();
      await CookingForegroundTaskCoordinator.stop();
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _onBlocStateForForeground(CookingModeState state) {
    if (_phase != _CookingPhase.active) return;
    if (state is CookingModeActive) {
      unawaited(
        CookingForegroundTaskCoordinator.startOrUpdate(
          recipeTitle: state.recipe.title,
          stepText: state.currentStep.instruction,
          stepNumber: state.stepIndex + 1,
          totalSteps: state.totalSteps,
        ),
      );
    } else if (state is CookingModeTimerRunning) {
      unawaited(
        CookingForegroundTaskCoordinator.startOrUpdate(
          recipeTitle: state.recipe.title,
          stepText:
              'Таймер ${state.remainingSeconds} c — ${state.steps[state.stepIndex].instruction}',
          stepNumber: state.stepIndex + 1,
          totalSteps: state.steps.length,
        ),
      );
    } else if (state is CookingModeCompleted) {
      unawaited(CookingForegroundTaskCoordinator.stop());
      _speech.setContinuousListening(enabled: false);
      unawaited(_speech.stopListening());
      setState(() {
        _phase = _CookingPhase.complete;
        _speechListening = false;
      });
    }
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_onForegroundTaskData);
    WidgetsBinding.instance.removeObserver(this);
    _speech.setContinuousListening(enabled: false);
    unawaited(_speech.cancelListening());
    unawaited(CookingForegroundTaskCoordinator.stop());
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_servicesReady || _bloc == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return switch (_phase) {
      _CookingPhase.intro => _IntroScaffold(
          recipeTitle: widget.recipe.title,
          onBack: () => Navigator.of(context).pop(),
          onStart: _onStartCooking,
        ),
      _CookingPhase.active => BlocProvider.value(
          value: _bloc!,
          child: _ActiveCookingView(
            recipeTitle: widget.recipe.title,
            onRequestExit: _confirmExit,
            speechListening: _speechListening,
            onBlocState: _onBlocStateForForeground,
          ),
        ),
      _CookingPhase.complete => _CompletionScaffold(
          recipeTitle: widget.recipe.title,
          canMarkMealInPlan: widget.canMarkMealInPlan,
          mealId: widget.meal.id,
          stars: _stars,
          onStarsChanged: (v) => setState(() => _stars = v),
          thumbUp: _thumbUp,
          onThumbChanged: (v) => setState(() => _thumbUp = v),
          onBackToPlan: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          onCloseToRecipe: () => Navigator.of(context).pop(),
        ),
    };
  }
}

class _IntroScaffold extends StatelessWidget {
  const _IntroScaffold({
    required this.recipeTitle,
    required this.onBack,
    required this.onStart,
  });

  final String recipeTitle;
  final VoidCallback onBack;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: const Text('Режим готовки'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(recipeTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 20),
          Text(
            'Я буду озвучивать шаги по очереди.\n'
            'Управляйте голосом:\n\n'
            '• «Следующий шаг» — дальше\n'
            '• «Повтори» — текущий шаг ещё раз\n'
            '• «Назад» — предыдущий шаг\n'
            '• «Таймер N минут» — таймер\n'
            '• «Стоп» — выход с подтверждением\n\n'
            'Положите телефон рядом и подготовьте продукты.',
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.mic_rounded),
            label: const Text('Начать готовку'),
          ),
        ],
      ),
    );
  }
}

class _ActiveCookingView extends StatelessWidget {
  const _ActiveCookingView({
    required this.recipeTitle,
    required this.onRequestExit,
    required this.speechListening,
    required this.onBlocState,
  });

  final String recipeTitle;
  final Future<void> Function() onRequestExit;
  final bool speechListening;
  final void Function(CookingModeState state) onBlocState;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CookingModeBloc, CookingModeState>(
      listener: (context, state) => onBlocState(state),
      builder: (context, state) {
        return WithForegroundTask(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                recipeTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => onRequestExit(),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: _buildBody(context, state),
                  ),
                ),
                _BottomCookingBar(
                  state: state,
                  speechListening: speechListening,
                  canGoPrevious: _stepIndexFromState(state) > 0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CookingModeState state) {
    if (state is CookingModeInitial) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state is CookingModeTimerRunning) {
      return Column(
        children: [
          StepDisplay(
            step: state.steps[state.stepIndex],
            stepIndex: state.stepIndex,
            totalSteps: state.steps.length,
          ),
          TimerWidget(
            remainingSeconds: state.remainingSeconds,
            stepDurationSeconds: null,
            onStartFromStep: () {},
          ),
        ],
      );
    }
    if (state is CookingModeActive) {
      final step = state.currentStep;
      return Column(
        children: [
          StepDisplay(
            step: step,
            stepIndex: state.stepIndex,
            totalSteps: state.totalSteps,
          ),
          TimerWidget(
            remainingSeconds: null,
            stepDurationSeconds: step.durationSeconds,
            onStartFromStep: () {
              final sec = step.durationSeconds;
              if (sec != null && sec > 0) {
                context.read<CookingModeBloc>().add(TimerStarted(seconds: sec));
              }
            },
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  static int _stepIndexFromState(CookingModeState state) {
    if (state is CookingModeActive) return state.stepIndex;
    if (state is CookingModeTimerRunning) return state.stepIndex;
    return 0;
  }
}

class _BottomCookingBar extends StatelessWidget {
  const _BottomCookingBar({
    required this.state,
    required this.speechListening,
    required this.canGoPrevious,
  });

  final CookingModeState state;
  final bool speechListening;
  final bool canGoPrevious;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CookingModeBloc>();
    final busy =
        state is! CookingModeActive && state is! CookingModeTimerRunning;
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VoiceIndicator(listening: speechListening && !busy),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (busy || !canGoPrevious)
                          ? null
                          : () => bloc.add(const PreviousStepRequested()),
                      child: const Text('Назад'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: busy
                          ? null
                          : () => bloc.add(const RepeatStepRequested()),
                      child: const Text('Повторить'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: busy
                          ? null
                          : () => bloc.add(const NextStepRequested()),
                      child: const Text('Далее'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionScaffold extends StatelessWidget {
  const _CompletionScaffold({
    required this.recipeTitle,
    required this.canMarkMealInPlan,
    required this.mealId,
    required this.stars,
    required this.onStarsChanged,
    required this.thumbUp,
    required this.onThumbChanged,
    required this.onBackToPlan,
    required this.onCloseToRecipe,
  });

  final String recipeTitle;
  final bool canMarkMealInPlan;
  final int mealId;
  final int stars;
  final ValueChanged<int> onStarsChanged;
  final bool? thumbUp;
  final ValueChanged<bool?> onThumbChanged;
  final VoidCallback onBackToPlan;
  final VoidCallback onCloseToRecipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Готово')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Приятного аппетита!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(recipeTitle),
          const SizedBox(height: 24),
          if (canMarkMealInPlan) ...[
            Text('Отметить блюдо как приготовленное?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                FilledButton(
                  onPressed: () {
                    context.read<MealPlanBloc>().add(MealCompleted(mealId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Блюдо отмечено в плане')),
                    );
                  },
                  child: const Text('Да, отметить'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Не сейчас'),
                ),
              ],
            ),
          ] else ...[
            Text(
              'Этот рецепт открыт из каталога — привязки к дню плана нет, '
              'отметка «съедено» здесь недоступна.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 28),
          Text('Оцените рецепт', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final n = i + 1;
              return IconButton(
                icon: Icon(
                  stars >= n ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 36,
                ),
                onPressed: () => onStarsChanged(n),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text('Как вам процесс готовки?', style: Theme.of(context).textTheme.titleMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 40,
                onPressed: () => onThumbChanged(true),
                icon: Icon(
                  Icons.thumb_up_alt_outlined,
                  color: thumbUp == true ? Colors.green : null,
                ),
              ),
              IconButton(
                iconSize: 40,
                onPressed: () => onThumbChanged(false),
                icon: Icon(
                  Icons.thumb_down_alt_outlined,
                  color: thumbUp == false ? Colors.orange : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onBackToPlan,
            child: const Text('Вернуться к плану'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onCloseToRecipe,
            child: const Text('К рецепту'),
          ),
        ],
      ),
    );
  }
}
