import 'package:client/data/local/source/settings_local_source.dart';

class SettingsRepository {
  SettingsRepository(this._source);

  final SettingsLocalSource _source;

  String? get themeMode => _source.themeMode;

  Future<void> setThemeMode(String value) => _source.setThemeMode(value);

  bool get useMetricUnits => _source.useMetricUnits;

  Future<void> setUseMetricUnits(bool value) =>
      _source.setUseMetricUnits(value);

  bool get onboardingCompleted => _source.onboardingCompleted;

  Future<void> setOnboardingCompleted(bool value) =>
      _source.setOnboardingCompleted(value);

  bool get notificationsEnabled => _source.notificationsEnabled;

  Future<void> setNotificationsEnabled(bool value) =>
      _source.setNotificationsEnabled(value);

  String? get reminderBreakfastTime => _source.reminderBreakfastTime;

  Future<void> setReminderBreakfastTime(String value) =>
      _source.setReminderBreakfastTime(value);

  String? get reminderLunchTime => _source.reminderLunchTime;

  Future<void> setReminderLunchTime(String value) =>
      _source.setReminderLunchTime(value);

  String? get reminderDinnerTime => _source.reminderDinnerTime;

  Future<void> setReminderDinnerTime(String value) =>
      _source.setReminderDinnerTime(value);

  bool get weighReminderEnabled => _source.weighReminderEnabled;

  Future<void> setWeighReminderEnabled(bool value) =>
      _source.setWeighReminderEnabled(value);

  String? get weighReminderTime => _source.weighReminderTime;

  Future<void> setWeighReminderTime(String value) =>
      _source.setWeighReminderTime(value);

  Future<void> clearAll() => _source.clearAll();
}
