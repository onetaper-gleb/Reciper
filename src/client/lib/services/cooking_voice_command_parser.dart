/// Parsed voice intents for cooking mode (Russian).
enum CookingVoiceCommandKind { next, previous, repeat, stop, timer }

class CookingVoiceCommand {
  const CookingVoiceCommand({required this.kind, this.timerSeconds});

  final CookingVoiceCommandKind kind;
  final int? timerSeconds;
}

String _normalizeSpeechInput(String raw) {
  var s = raw.toLowerCase().trim().replaceAll('ё', 'е');
  s = s.replaceAll(RegExp(r'\s+'), ' ');
  return s;
}

final RegExp _timerRegex = RegExp(
  r'таймер\s*(?:на\s*)?(\d+)\s*(минут(?:ы|у)?|мин|секунд(?:ы|у)?|сек)?',
  caseSensitive: false,
);

CookingVoiceCommand? parseCookingVoiceCommand(String raw) {
  final text = _normalizeSpeechInput(raw);
  if (text.isEmpty) return null;

  final timerMatch = _timerRegex.firstMatch(text);
  if (timerMatch != null && text.contains('таймер')) {
    final n = int.tryParse(timerMatch.group(1) ?? '');
    if (n != null && n > 0) {
      final unit = timerMatch.group(2)?.toLowerCase() ?? 'мин';
      final seconds = (unit.startsWith('сек')) ? n : n * 60;
      if (seconds > 0 && seconds <= 24 * 3600) {
        return CookingVoiceCommand(kind: CookingVoiceCommandKind.timer, timerSeconds: seconds);
      }
    }
  }

  bool hasAny(Iterable<String> phrases) {
    for (final p in phrases) {
      if (text.contains(p)) return true;
    }
    return false;
  }

  if (hasAny(const [
        'следующий шаг',
        'след шаг',
        'следующий',
        'дальше',
        'далее',
        'вперед',
        'вперёд',
        'иди дальше',
        'продолжай',
        'продолжить',
      ])) {
    return const CookingVoiceCommand(kind: CookingVoiceCommandKind.next);
  }

  if (hasAny(const [
        'предыдущий шаг',
        'предыдущий',
        'назад',
        'вернись',
        'верни назад',
      ])) {
    return const CookingVoiceCommand(kind: CookingVoiceCommandKind.previous);
  }

  if (hasAny(const [
        'повтори шаг',
        'повторить шаг',
        'повтори',
        'повторить',
        'еще раз',
        'ещё раз',
        'снова',
        'еще разок',
      ])) {
    return const CookingVoiceCommand(kind: CookingVoiceCommandKind.repeat);
  }

  if (hasAny(const [
        'стоп',
        'хватит',
        'закончить',
        'выход',
        'остановись',
        'остановить',
      ])) {
    return const CookingVoiceCommand(kind: CookingVoiceCommandKind.stop);
  }

  return null;
}
