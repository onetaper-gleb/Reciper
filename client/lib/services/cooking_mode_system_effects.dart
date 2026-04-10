import 'package:flutter/services.dart';

import 'package:client/domain/bloc/cooking_mode/cooking_mode_effects.dart';

import 'tts_service.dart';

class CookingModeSystemEffects implements CookingModeEffects {
  CookingModeSystemEffects({required TtsService tts}) : _tts = tts;

  final TtsService _tts;

  @override
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  @override
  Future<void> stopSpeaking() async {
    await _tts.stop();
  }

  @override
  Future<void> playTimerCompleteFeedback() async {
    await HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
  }
}
