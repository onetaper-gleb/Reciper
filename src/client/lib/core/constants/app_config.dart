import 'dart:io';

abstract final class AppConfig {
  /// Override via `--dart-define=API_BASE_URL=http://192.168.1.10:8000`
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Request signing secret for backend anti-abuse protection.
  /// Override via `--dart-define=API_SIGNING_SECRET=...`
  ///
  /// Note: putting a secret in a client app is best-effort only.
  static const String apiSigningSecret = String.fromEnvironment(
    'API_SIGNING_SECRET',
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

