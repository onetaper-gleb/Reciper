import 'package:shared_preferences/shared_preferences.dart';

import 'package:client/core/constants/storage_keys.dart';
import 'package:client/core/utils/app_logger.dart';

class SettingsLocalSource {
  SettingsLocalSource(this._prefs);

  final SharedPreferences _prefs;

  String? get themeMode => _prefs.getString(StorageKeys.themeMode);

  Future<void> setThemeMode(String value) async {
    await _prefs.setString(StorageKeys.themeMode, value);
    AppLogger.info('SettingsLocalSource: theme_mode=$value');
  }

  bool get useMetricUnits => _prefs.getBool(StorageKeys.useMetricUnits) ?? true;

  Future<void> setUseMetricUnits(bool value) async {
    await _prefs.setBool(StorageKeys.useMetricUnits, value);
    AppLogger.info('SettingsLocalSource: use_metric_units=$value');
  }

  bool get onboardingCompleted =>
      _prefs.getBool(StorageKeys.onboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(StorageKeys.onboardingCompleted, value);
    AppLogger.info('SettingsLocalSource: onboarding_completed=$value');
  }

  bool get notificationsEnabled =>
      _prefs.getBool(StorageKeys.notificationsEnabled) ?? true;

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(StorageKeys.notificationsEnabled, value);
    AppLogger.info('SettingsLocalSource: notifications_enabled=$value');
  }
}
