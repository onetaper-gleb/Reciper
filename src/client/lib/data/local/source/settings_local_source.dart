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

  String? get reminderBreakfastTime =>
      _prefs.getString(StorageKeys.reminderBreakfastTime);

  Future<void> setReminderBreakfastTime(String value) async {
    await _prefs.setString(StorageKeys.reminderBreakfastTime, value);
  }

  String? get reminderLunchTime =>
      _prefs.getString(StorageKeys.reminderLunchTime);

  Future<void> setReminderLunchTime(String value) async {
    await _prefs.setString(StorageKeys.reminderLunchTime, value);
  }

  String? get reminderDinnerTime =>
      _prefs.getString(StorageKeys.reminderDinnerTime);

  Future<void> setReminderDinnerTime(String value) async {
    await _prefs.setString(StorageKeys.reminderDinnerTime, value);
  }

  bool get weighReminderEnabled =>
      _prefs.getBool(StorageKeys.weighReminderEnabled) ?? false;

  Future<void> setWeighReminderEnabled(bool value) async {
    await _prefs.setBool(StorageKeys.weighReminderEnabled, value);
  }

  String? get weighReminderTime =>
      _prefs.getString(StorageKeys.weighReminderTime);

  Future<void> setWeighReminderTime(String value) async {
    await _prefs.setString(StorageKeys.weighReminderTime, value);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
    AppLogger.info('SettingsLocalSource: cleared all preferences');
  }
}
