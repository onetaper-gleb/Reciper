import 'package:client/core/utils/app_logger.dart';
import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/mappers/profile_mapper.dart';
import 'package:client/domain/models/profile.dart';

class ProfileLocalSource {
  ProfileLocalSource(this._dao);

  final ProfileDao _dao;

  Future<void> saveProfile(Profile profile) async {
    if (await hasProfile()) {
      throw StateError('Profile already exists; use updateProfile');
    }
    final id = await _dao.insertProfile(ProfileMapper.toInsertCompanion(profile));
    AppLogger.info('ProfileLocalSource: profile inserted id=$id');
  }

  Future<Profile?> getProfile() async {
    final rows = await _dao.getAllProfiles();
    if (rows.isEmpty) return null;
    rows.sort((a, b) => a.id.compareTo(b.id));
    return ProfileMapper.fromEntry(rows.first);
  }

  Future<void> updateProfile(Profile profile) async {
    if (!await hasProfile()) {
      throw StateError('No profile to update; use saveProfile');
    }
    await _dao.updateProfile(ProfileMapper.toEntry(profile));
    AppLogger.info('ProfileLocalSource: profile updated id=${profile.id}');
  }

  Future<bool> hasProfile() async => (await getProfile()) != null;
}
