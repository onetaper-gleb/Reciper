part of '../app_database.dart';

@DriftAccessor(tables: [Profiles, Preferences])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  Future<int> insertProfile(ProfilesCompanion row) => into(profiles).insert(row);

  Future<ProfileEntry?> getProfileById(int id) =>
      (select(profiles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ProfileEntry>> getAllProfiles() => select(profiles).get();

  Future<bool> updateProfile(ProfileEntry row) => update(profiles).replace(row);

  Future<int> deleteProfile(int id) =>
      (delete(profiles)..where((t) => t.id.equals(id))).go();

  Future<int> insertPreferences(PreferencesCompanion row) =>
      into(preferences).insert(row);

  Future<PreferencesEntry?> getPreferencesById(int id) =>
      (select(preferences)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<PreferencesEntry>> getAllPreferences() =>
      select(preferences).get();

  Future<bool> updatePreferences(PreferencesEntry row) =>
      update(preferences).replace(row);

  Future<int> deletePreferences(int id) =>
      (delete(preferences)..where((t) => t.id.equals(id))).go();
}
