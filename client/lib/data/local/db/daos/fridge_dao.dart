part of '../app_database.dart';

@DriftAccessor(tables: [FridgeProducts, FridgeScans])
class FridgeDao extends DatabaseAccessor<AppDatabase> with _$FridgeDaoMixin {
  FridgeDao(super.db);

  Future<int> insertFridgeProduct(FridgeProductsCompanion row) =>
      into(fridgeProducts).insert(row);

  Future<FridgeProductEntry?> getFridgeProductById(int id) =>
      (select(fridgeProducts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<FridgeProductEntry>> getAllFridgeProducts() =>
      select(fridgeProducts).get();

  Future<bool> updateFridgeProduct(FridgeProductEntry row) =>
      update(fridgeProducts).replace(row);

  Future<int> deleteFridgeProduct(int id) =>
      (delete(fridgeProducts)..where((t) => t.id.equals(id))).go();

  Future<int> insertFridgeScan(FridgeScansCompanion row) =>
      into(fridgeScans).insert(row);

  Future<FridgeScanEntry?> getFridgeScanById(int id) =>
      (select(fridgeScans)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<FridgeScanEntry>> getAllFridgeScans() => select(fridgeScans).get();

  Future<bool> updateFridgeScan(FridgeScanEntry row) =>
      update(fridgeScans).replace(row);

  Future<int> deleteFridgeScan(int id) =>
      (delete(fridgeScans)..where((t) => t.id.equals(id))).go();
}
