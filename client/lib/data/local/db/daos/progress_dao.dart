part of '../app_database.dart';

@DriftAccessor(tables: [WeightEntries])
class ProgressDao extends DatabaseAccessor<AppDatabase> with _$ProgressDaoMixin {
  ProgressDao(super.db);

  Future<int> insertWeightEntry(WeightEntriesCompanion row) =>
      into(weightEntries).insert(row);

  Future<BodyWeightEntry?> getWeightEntryById(int id) =>
      (select(weightEntries)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<BodyWeightEntry>> getAllWeightEntries() =>
      select(weightEntries).get();

  Future<bool> updateWeightEntry(BodyWeightEntry row) =>
      update(weightEntries).replace(row);

  Future<int> deleteWeightEntry(int id) =>
      (delete(weightEntries)..where((t) => t.id.equals(id))).go();
}
