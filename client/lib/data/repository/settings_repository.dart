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
}
