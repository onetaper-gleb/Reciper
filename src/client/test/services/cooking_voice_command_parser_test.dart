import 'package:flutter_test/flutter_test.dart';

import 'package:client/services/cooking_voice_command_parser.dart';

void main() {
  group('parseCookingVoiceCommand', () {
    test('returns next for synonyms', () {
      for (final phrase in [
        'следующий шаг',
        'следующий',
        'дальше',
        'далее',
        'вперёд',
        'вперед',
        'иди дальше',
        'продолжай',
      ]) {
        expect(
          parseCookingVoiceCommand(phrase)?.kind,
          CookingVoiceCommandKind.next,
          reason: phrase,
        );
      }
    });

    test('returns previous for synonyms', () {
      for (final phrase in [
        'назад',
        'предыдущий',
        'предыдущий шаг',
        'вернись назад',
        'верни назад',
      ]) {
        expect(
          parseCookingVoiceCommand(phrase)?.kind,
          CookingVoiceCommandKind.previous,
          reason: phrase,
        );
      }
    });

    test('returns repeat for synonyms', () {
      for (final phrase in [
        'повтори',
        'повторить',
        'ещё раз',
        'еще раз',
        'снова',
        'повтори шаг',
      ]) {
        expect(
          parseCookingVoiceCommand(phrase)?.kind,
          CookingVoiceCommandKind.repeat,
          reason: phrase,
        );
      }
    });

    test('returns stop for synonyms', () {
      for (final phrase in [
        'стоп',
        'хватит',
        'закончить',
        'выход',
        'остановись',
      ]) {
        expect(
          parseCookingVoiceCommand(phrase)?.kind,
          CookingVoiceCommandKind.stop,
          reason: phrase,
        );
      }
    });

    test('parses timer minutes', () {
      final a = parseCookingVoiceCommand('таймер 5 минут');
      expect(a?.kind, CookingVoiceCommandKind.timer);
      expect(a?.timerSeconds, 300);

      final b = parseCookingVoiceCommand('поставь таймер на 3 минуты');
      expect(b?.timerSeconds, 180);

      final c = parseCookingVoiceCommand('таймер 30 секунд');
      expect(c?.timerSeconds, 30);

      final d = parseCookingVoiceCommand('таймер на 1 минуту');
      expect(d?.timerSeconds, 60);
    });

    test('normalizes case and ё', () {
      expect(
        parseCookingVoiceCommand('  ДАЛЬШЕ  ')?.kind,
        CookingVoiceCommandKind.next,
      );
      expect(
        parseCookingVoiceCommand('ещё раз')?.kind,
        CookingVoiceCommandKind.repeat,
      );
    });

    test('returns null for unrelated text', () {
      expect(parseCookingVoiceCommand('добавь соль'), isNull);
      expect(parseCookingVoiceCommand(''), isNull);
    });

    test('priority: timer phrase over next keyword substring', () {
      final r = parseCookingVoiceCommand('таймер 2 минуты дальше');
      expect(r?.kind, CookingVoiceCommandKind.timer);
      expect(r?.timerSeconds, 120);
    });
  });
}
