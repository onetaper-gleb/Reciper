import 'package:client/data/local/source/preferences_local_source.dart';
import 'package:client/domain/models/user_preferences.dart';

class PreferencesRepository {
  PreferencesRepository(this._local);

  final PreferencesLocalSource _local;

  Future<UserPreferences?> getPreferences() => _local.getPreferences();
}

