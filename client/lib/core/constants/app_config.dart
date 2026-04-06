import 'dart:io';

abstract final class AppConfig {
  /// Override via `--dart-define=API_BASE_URL=http://192.168.1.10:8000`
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String resolvedApiBaseUrl() {
    if (apiBaseUrl.trim().isNotEmpty) return apiBaseUrl.trim();

    // Sensible defaults for local backend during development.
    // - Android emulator: host machine is 10.0.2.2
    // - iOS simulator: host machine is localhost
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }
}

