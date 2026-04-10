import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:client/core/utils/app_logger.dart';
import 'cooking_voice_command_parser.dart';

typedef CookingSpeechCallback = void Function(
  CookingVoiceCommand? command,
  String rawText,
);

/// Called when the platform stopped listening (timeout, silence, error, stop).
/// Use this to start the next [startListening] — [onResult] alone is not enough.
typedef SpeechSessionEndedCallback = void Function();

/// Wrapper over [SpeechToText] with Russian locale and cooking command parsing.
class SpeechService {
  SpeechService() : _speech = SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;

  bool _continuousMode = false;
  SpeechSessionEndedCallback? _onSessionEnded;
  CookingSpeechCallback? _commandCallback;

  /// While true, [notListening]/[done] schedules [_onSessionEnded] (debounced).
  bool _suppressSessionEnded = false;
  bool _sessionEndScheduled = false;

  Future<bool> init() async {
    if (_initialized) return _speech.isAvailable;
    _initialized = true;
    return _speech.initialize(
      onError: _onError,
      onStatus: _onStatus,
    );
  }

  void _onError(SpeechRecognitionError e) {
    AppLogger.warning(
      'SpeechService: ${e.errorMsg} permanent=${e.permanent}',
    );
    if (_continuousMode && !e.permanent) {
      _scheduleSessionEnded();
    }
  }

  void _onStatus(String status) {
    if (status != SpeechToText.notListeningStatus &&
        status != SpeechToText.doneStatus) {
      return;
    }
    if (_suppressSessionEnded || !_continuousMode) return;
    _scheduleSessionEnded();
  }

  void _scheduleSessionEnded() {
    if (_sessionEndScheduled) return;
    _sessionEndScheduled = true;
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      _sessionEndScheduled = false;
      if (!_continuousMode || _suppressSessionEnded) return;
      _onSessionEnded?.call();
    });
  }

  /// When enabled, each end of a listen session invokes [onSessionEnded] so the UI can call [startListening] again.
  void setContinuousListening({
    required bool enabled,
    SpeechSessionEndedCallback? onSessionEnded,
  }) {
    _continuousMode = enabled;
    _onSessionEnded = enabled ? onSessionEnded : null;
    if (!enabled) {
      _sessionEndScheduled = false;
    } else {
      _lastCommandAt = null;
    }
  }

  bool get isAvailable => _speech.isAvailable;

  Future<void> startListening({required CookingSpeechCallback onResult}) async {
    if (!_initialized) await init();
    if (!_speech.isAvailable) return;

    _commandCallback = onResult;

    if (_speech.isListening) {
      _suppressSessionEnded = true;
      await _speech.stop();
      await Future<void>.delayed(const Duration(milliseconds: 180));
      _suppressSessionEnded = false;
    }

    try {
      await _speech.listen(
        onResult: _processResult,
        localeId: 'ru_RU',
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 5),
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.confirmation,
          partialResults: true,
          cancelOnError: false,
        ),
      );
    } catch (e, st) {
      AppLogger.warning('SpeechService.listen failed', e, st);
      if (_continuousMode) {
        _scheduleSessionEnded();
      }
    }
  }

  DateTime? _lastCommandAt;

  void _processResult(SpeechRecognitionResult res) {
    final cb = _commandCallback;
    if (cb == null) return;
    if (!res.finalResult) return;

    final text = res.recognizedWords.trim();
    if (text.isEmpty) return;

    final cmd = parseCookingVoiceCommand(text);
    if (cmd == null) {
      AppLogger.info('SpeechService: final, no command: "$text"');
      return;
    }

    final now = DateTime.now();
    if (_lastCommandAt != null &&
        now.difference(_lastCommandAt!) < const Duration(milliseconds: 700)) {
      return;
    }
    _lastCommandAt = now;

    cb(cmd, text);
  }

  Future<void> stopListening() async {
    _continuousMode = false;
    _onSessionEnded = null;
    _suppressSessionEnded = true;
    await _speech.stop();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _suppressSessionEnded = false;
  }

  Future<void> cancelListening() async {
    _continuousMode = false;
    _onSessionEnded = null;
    _suppressSessionEnded = true;
    await _speech.cancel();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _suppressSessionEnded = false;
  }
}
