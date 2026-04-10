import 'package:flutter_tts/flutter_tts.dart';

/// Local text-to-speech (Russian).
class TtsService {
  TtsService() : _tts = FlutterTts();

  final FlutterTts _tts;
  bool _ready = false;

  Future<void> init({double speechRate = 0.48}) async {
    if (_ready) return;
    await _tts.setLanguage('ru-RU');
    await _tts.setSpeechRate(speechRate);
    await _tts.awaitSpeakCompletion(true);
    _ready = true;
  }

  Future<void> speak(String text) async {
    if (!_ready) await init();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
