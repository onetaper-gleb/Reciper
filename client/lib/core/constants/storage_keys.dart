/// Keys for [SharedPreferences] (settings not stored in Drift).
abstract final class StorageKeys {
  static const String themeMode = 'settings_theme_mode';

  /// `true` — metric (kg, cm); `false` — imperial.
  static const String useMetricUnits = 'settings_use_metric_units';

  static const String onboardingCompleted = 'settings_onboarding_completed';

  static const String notificationsEnabled = 'settings_notifications_enabled';
}
