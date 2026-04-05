import 'package:client/data/local/source/profile_local_source.dart';
import 'package:client/data/local/source/settings_local_source.dart';
import 'package:client/domain/models/profile.dart';

class ProfileRepository {
  ProfileRepository({
    required ProfileLocalSource profileLocalSource,
    required SettingsLocalSource settingsLocalSource,
  })  : _profile = profileLocalSource,
        _settings = settingsLocalSource;

  final ProfileLocalSource _profile;
  final SettingsLocalSource _settings;

  Future<void> saveProfile(Profile profile) => _profile.saveProfile(profile);

  Future<Profile?> getProfile() => _profile.getProfile();

  Future<void> updateProfile(Profile profile) =>
      _profile.updateProfile(profile);

  Future<bool> hasCompletedOnboarding() async =>
      _settings.onboardingCompleted;

  Future<void> setOnboardingCompleted(bool value) =>
      _settings.setOnboardingCompleted(value);
}
