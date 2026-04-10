/// Side effects for cooking mode (TTS, haptics) — injectable for tests.
abstract class CookingModeEffects {
  Future<void> speak(String text);
  Future<void> stopSpeaking();
  Future<void> playTimerCompleteFeedback();
}
