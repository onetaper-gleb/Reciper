import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/domain/bloc/cooking_mode/cooking_mode_bloc.dart';
import 'package:client/domain/bloc/cooking_mode/cooking_mode_effects.dart';
import 'package:client/domain/bloc/cooking_mode/cooking_mode_event.dart';
import 'package:client/domain/bloc/cooking_mode/cooking_mode_state.dart';
import 'package:client/domain/models/cooking_step.dart';
import 'package:client/domain/models/enums/difficulty.dart';
import 'package:client/domain/models/recipe.dart';

class FakeCookingModeEffects extends CookingModeEffects {
  final List<String> spoken = [];
  int speakCalls = 0;
  int stopCalls = 0;
  int timerFeedbackCalls = 0;

  @override
  Future<void> speak(String text) async {
    speakCalls++;
    spoken.add(text);
  }

  @override
  Future<void> stopSpeaking() async {
    stopCalls++;
  }

  @override
  Future<void> playTimerCompleteFeedback() async {
    timerFeedbackCalls++;
  }
}

Recipe _testRecipe() {
  return Recipe(
    id: 1,
    title: 'Борщ',
    cookingTimeMinutes: 20,
    difficulty: Difficulty.easy,
    servings: 2,
    calories: 200,
    proteinG: 10,
    fatG: 5,
    carbsG: 20,
    isFavorite: false,
    steps: const [
      CookingStep(order: 1, instruction: 'Нарежьте лук', durationSeconds: null),
      CookingStep(order: 2, instruction: 'Варите бульон', durationSeconds: 60),
    ],
  );
}

void main() {
  late FakeCookingModeEffects effects;

  setUp(() {
    effects = FakeCookingModeEffects();
  });

  blocTest<CookingModeBloc, CookingModeState>(
    'CookingStarted sorts steps and speaks first instruction',
    build: () => CookingModeBloc(
      effects: effects,
      timerTick: const Duration(milliseconds: 20),
    ),
    act: (bloc) => bloc.add(CookingStarted(_testRecipe())),
    expect: () => [
      isA<CookingModeActive>().having(
        (s) => s.stepIndex,
        'stepIndex',
        0,
      ),
    ],
    verify: (_) {
      expect(effects.spoken.first, contains('Нарежьте лук'));
    },
  );

  blocTest<CookingModeBloc, CookingModeState>(
    'NextStepRequested advances and speaks',
    build: () => CookingModeBloc(
      effects: effects,
      timerTick: const Duration(milliseconds: 20),
    ),
    act: (bloc) {
      bloc.add(CookingStarted(_testRecipe()));
      bloc.add(const NextStepRequested());
    },
    expect: () => [
      isA<CookingModeActive>().having((s) => s.stepIndex, 'i', 0),
      isA<CookingModeActive>().having((s) => s.stepIndex, 'i', 1),
    ],
    verify: (_) {
      expect(effects.spoken.any((t) => t.contains('Варите бульон')), isTrue);
    },
  );

  blocTest<CookingModeBloc, CookingModeState>(
    'NextStepRequested on last step completes session',
    build: () => CookingModeBloc(
      effects: effects,
      timerTick: const Duration(milliseconds: 20),
    ),
    act: (bloc) {
      final r = _testRecipe();
      bloc.add(CookingStarted(r));
      bloc.add(const NextStepRequested());
      bloc.add(const NextStepRequested());
    },
    expect: () => [
      isA<CookingModeActive>().having((s) => s.stepIndex, 'i', 0),
      isA<CookingModeActive>().having((s) => s.stepIndex, 'i', 1),
      isA<CookingModeCompleted>(),
    ],
  );

  blocTest<CookingModeBloc, CookingModeState>(
    'PreviousStepRequested at start is no-op',
    build: () => CookingModeBloc(
      effects: effects,
      timerTick: const Duration(milliseconds: 20),
    ),
    act: (bloc) {
      bloc.add(CookingStarted(_testRecipe()));
      bloc.add(const PreviousStepRequested());
    },
    expect: () => [
      isA<CookingModeActive>().having((s) => s.stepIndex, 'i', 0),
    ],
  );

  blocTest<CookingModeBloc, CookingModeState>(
    'RepeatStepRequested speaks current step again',
    build: () => CookingModeBloc(
      effects: effects,
      timerTick: const Duration(milliseconds: 20),
    ),
    act: (bloc) {
      bloc.add(CookingStarted(_testRecipe()));
      bloc.add(const RepeatStepRequested());
    },
    expect: () => [
      isA<CookingModeActive>(),
    ],
    verify: (_) {
      expect(effects.spoken.where((t) => t.contains('Нарежьте лук')).length, greaterThanOrEqualTo(2));
    },
  );

  blocTest<CookingModeBloc, CookingModeState>(
    'VoiceCommandReceived maps next',
    build: () => CookingModeBloc(
      effects: effects,
      timerTick: const Duration(milliseconds: 20),
    ),
    act: (bloc) {
      bloc.add(CookingStarted(_testRecipe()));
      bloc.add(const VoiceCommandReceived(CookingVoiceKind.next));
    },
    expect: () => [
      isA<CookingModeActive>().having((s) => s.stepIndex, 'i', 0),
      isA<CookingModeActive>().having((s) => s.stepIndex, 'i', 1),
    ],
  );

  blocTest<CookingModeBloc, CookingModeState>(
    'TimerStarted runs then returns to active with feedback',
    build: () => CookingModeBloc(
      effects: effects,
      timerTick: const Duration(milliseconds: 10),
    ),
    act: (bloc) async {
      bloc.add(CookingStarted(_testRecipe()));
      bloc.add(const TimerStarted(seconds: 2));
      await Future<void>.delayed(const Duration(milliseconds: 250));
    },
    wait: const Duration(milliseconds: 350),
    verify: (bloc) {
      expect(effects.timerFeedbackCalls, 1);
      expect(bloc.state, isA<CookingModeActive>());
    },
  );
}
