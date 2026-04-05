import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/db/app_database.dart';
import '../data/repository/profile_repository.dart';
import '../data/repository/settings_repository.dart';

/// Composition root: repositories, database, HTTP client will be wired here.
class Dependencies {
  Dependencies({
    required this.database,
    required this.sharedPreferences,
    required this.profileRepository,
    required this.settingsRepository,
  });

  final AppDatabase database;
  final SharedPreferences sharedPreferences;
  final ProfileRepository profileRepository;
  final SettingsRepository settingsRepository;
}
