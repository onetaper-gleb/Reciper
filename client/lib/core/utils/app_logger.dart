import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Minimal structured logging (see Dart DevTools / logcat).
abstract final class AppLogger {
  static const String _name = 'Reciper';

  static void info(String message) {
    developer.log(message, name: _name);
    if (kDebugMode) {
      // `developer.log` is not always visible in logcat console output.
      // Keep a mirrored stdout log for easier debugging in `flutter run`.
      // ignore: avoid_print
      print('[$_name] $message');
    }
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(message, name: _name, level: 900, error: error, stackTrace: stackTrace);
    if (kDebugMode) {
      // ignore: avoid_print
      print('[$_name][WARN] $message ${error ?? ''}');
      if (stackTrace != null) {
        // ignore: avoid_print
        print(stackTrace);
      }
    }
  }
}
