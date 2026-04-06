import 'package:client/core/utils/app_logger.dart';
import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/mappers/preferences_mapper.dart';
import 'package:client/domain/models/user_preferences.dart';

class PreferencesLocalSource {
  PreferencesLocalSource(this._dao);

  final ProfileDao _dao;

  Future<UserPreferences?> getPreferences() async {
    final rows = await _dao.getAllPreferences();
    if (rows.isEmpty) return null;
    rows.sort((a, b) => a.id.compareTo(b.id));
    return PreferencesMapper.fromEntry(rows.first);
  }

  Future<void> savePreferences(UserPreferences preferences) async {
    if (await getPreferences() != null) {
      throw StateError('Preferences already exists; use updatePreferences');
    }
    final id = await _dao.insertPreferences(
      PreferencesMapper.toInsertCompanion(preferences),
    );
    AppLogger.info('PreferencesLocalSource: inserted id=$id');
  }

  Future<void> updatePreferences(UserPreferences preferences) async {
    final existing = await getPreferences();
    if (existing == null) {
      throw StateError('No preferences to update; use savePreferences');
    }
    await _dao.updatePreferences(PreferencesMapper.toEntry(preferences));
    AppLogger.info('PreferencesLocalSource: updated id=${preferences.id}');
  }
}

