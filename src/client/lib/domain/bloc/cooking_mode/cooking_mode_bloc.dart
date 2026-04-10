import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/domain/models/cooking_step.dart';
import 'cooking_mode_effects.dart';
import 'cooking_mode_event.dart';
import 'cooking_mode_state.dart';

class CookingModeBloc extends Bloc<CookingModeEvent, CookingModeState> {
  CookingModeBloc({
    required CookingModeEffects effects,
    Duration timerTick = const Duration(seconds: 1),
  })  : _effects = effects,
        _timerTick = timerTick,
        super(const CookingModeInitial()) {
    on<CookingStarted>(_onStarted);
    on<NextStepRequested>(_onNext);
    on<PreviousStepRequested>(_onPrevious);
    on<RepeatStepRequested>(_onRepeat);
    on<TimerStarted>(_onTimerStarted);
    on<VoiceCommandReceived>(_onVoice);
    on<CookingTimerTicked>(_onTimerTicked);
  }

  final CookingModeEffects _effects;
  final Duration _timerTick;
  Timer? _timer;

  Future<void> _onStarted(
    CookingStarted event,
    Emitter<CookingModeState> emit,
  ) async {
    final steps = [...event.recipe.steps]..sort((a, b) => a.order.compareTo(b.order));
    if (steps.isEmpty) {
      emit(CookingModeCompleted(recipe: event.recipe));
      return;
    }
    emit(
      CookingModeActive(
        recipe: event.recipe,
        steps: steps,
        stepIndex: 0,
      ),
    );
    await _speakCurrentStep(steps.first);
  }

  Future<void> _onNext(
    NextStepRequested event,
    Emitter<CookingModeState> emit,
  ) async {
    final s = state;
    if (s is CookingModeActive) {
      await _advanceStep(emit, s, 1);
      return;
    }
    if (s is CookingModeTimerRunning) {
      _cancelTimer();
      final active = CookingModeActive(
        recipe: s.recipe,
        steps: s.steps,
        stepIndex: s.stepIndex,
      );
      emit(active);
      await _advanceStep(emit, active, 1);
    }
  }

  Future<void> _onPrevious(
    PreviousStepRequested event,
    Emitter<CookingModeState> emit,
  ) async {
    final s = state;
    if (s is CookingModeTimerRunning) {
      _cancelTimer();
      emit(
        CookingModeActive(
          recipe: s.recipe,
          steps: s.steps,
          stepIndex: s.stepIndex,
        ),
      );
    }
    final active = state;
    if (active is! CookingModeActive) return;
    if (active.stepIndex <= 0) return;
    emit(
      CookingModeActive(
        recipe: active.recipe,
        steps: active.steps,
        stepIndex: active.stepIndex - 1,
      ),
    );
    await _speakCurrentStep(active.steps[active.stepIndex - 1]);
  }

  Future<void> _onRepeat(
    RepeatStepRequested event,
    Emitter<CookingModeState> emit,
  ) async {
    final s = state;
    if (s is CookingModeActive) {
      await _speakCurrentStep(s.currentStep);
      return;
    }
    if (s is CookingModeTimerRunning) {
      await _speakCurrentStep(s.steps[s.stepIndex]);
    }
  }

  Future<void> _onTimerStarted(
    TimerStarted event,
    Emitter<CookingModeState> emit,
  ) async {
    final s = state;
    if (s is! CookingModeActive) return;
    if (event.seconds <= 0) return;
    _cancelTimer();
    emit(
      CookingModeTimerRunning(
        recipe: s.recipe,
        steps: s.steps,
        stepIndex: s.stepIndex,
        remainingSeconds: event.seconds,
      ),
    );
    _timer = Timer.periodic(_timerTick, (_) => add(const CookingTimerTicked()));
  }

  Future<void> _onVoice(
    VoiceCommandReceived event,
    Emitter<CookingModeState> emit,
  ) async {
    switch (event.kind) {
      case CookingVoiceKind.next:
        add(const NextStepRequested());
      case CookingVoiceKind.previous:
        add(const PreviousStepRequested());
      case CookingVoiceKind.repeat:
        add(const RepeatStepRequested());
    }
  }

  Future<void> _onTimerTicked(
    CookingTimerTicked event,
    Emitter<CookingModeState> emit,
  ) async {
    final cur = state;
    if (cur is! CookingModeTimerRunning) {
      _cancelTimer();
      return;
    }
    if (cur.remainingSeconds <= 1) {
      _cancelTimer();
      await _effects.playTimerCompleteFeedback();
      await _effects.speak(
        'Время вышло! Скажите «следующий шаг», чтобы продолжить.',
      );
      emit(
        CookingModeActive(
          recipe: cur.recipe,
          steps: cur.steps,
          stepIndex: cur.stepIndex,
        ),
      );
      return;
    }
    emit(
      CookingModeTimerRunning(
        recipe: cur.recipe,
        steps: cur.steps,
        stepIndex: cur.stepIndex,
        remainingSeconds: cur.remainingSeconds - 1,
      ),
    );
  }

  Future<void> _advanceStep(
    Emitter<CookingModeState> emit,
    CookingModeActive s,
    int delta,
  ) async {
    final next = s.stepIndex + delta;
    if (next >= s.steps.length) {
      emit(CookingModeCompleted(recipe: s.recipe));
      return;
    }
    if (next < 0) return;
    emit(
      CookingModeActive(
        recipe: s.recipe,
        steps: s.steps,
        stepIndex: next,
      ),
    );
    await _speakCurrentStep(s.steps[next]);
  }

  Future<void> _speakCurrentStep(CookingStep step) async {
    await _effects.speak(step.instruction);
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
