import 'dart:developer' as developer;

/// Minimal structured logging (see Dart DevTools / logcat).
abstract final class AppLogger {
  static const String _name = 'Reciper';

  static void info(String message) {
    developer.log(message, name: _name);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(message, name: _name, level: 900, error: error, stackTrace: stackTrace);
  }
}
