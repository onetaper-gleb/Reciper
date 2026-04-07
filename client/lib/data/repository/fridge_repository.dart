import 'dart:io';

import 'package:drift/drift.dart';

import '../local/db/app_database.dart';
import '../remote/source/fridge_remote_source.dart';

class FridgeProductData {
  const FridgeProductData({
    required this.name,
    required this.amount,
    required this.unit,
    required this.category,
    this.confidence = 0,
  });

  final String name;
  final double amount;
  final String unit;
  final String category;
  final double confidence;

  FridgeProductData copyWith({
    String? name,
    double? amount,
    String? unit,
    String? category,
    double? confidence,
  }) {
    return FridgeProductData(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      confidence: confidence ?? this.confidence,
    );
  }
}

class FridgeScanData {
  const FridgeScanData({
    required this.id,
    required this.photoPath,
    required this.scanDate,
    required this.productCount,
  });

  final int id;
  final String photoPath;
  final DateTime scanDate;
  final int productCount;
}

abstract class FridgeRepositoryBase {
  Future<List<FridgeProductData>> scanImage(File image);
  Future<List<FridgeProductData>> appendScan(
    File image,
    List<FridgeProductData> existingProducts,
  );
  Future<List<FridgeProductData>> getProducts();
  Future<void> saveProducts(List<FridgeProductData> products);
  Future<void> addProduct(FridgeProductData product);
  Future<void> removeProductByName(String name);
  Future<void> updateProduct(String name, FridgeProductData product);
  Future<void> saveScanRecord(String photoPath, int productCount);
  Future<List<FridgeScanData>> getScanHistory();
}

class FridgeRepository implements FridgeRepositoryBase {
  FridgeRepository({
    required AppDatabase database,
    required FridgeRemoteSource remoteSource,
  })  : _db = database,
        _remote = remoteSource;

  final AppDatabase _db;
  final FridgeRemoteSource _remote;

  @override
  Future<List<FridgeProductData>> scanImage(File image) async {
    final rows = await _remote.scanImage(image);
    return rows
        .map(
          (e) => FridgeProductData(
            name: e.name,
            amount: e.amount,
            unit: e.unit,
            category: 'other',
            confidence: e.confidence,
          ),
        )
        .toList();
  }

  @override
  Future<List<FridgeProductData>> appendScan(
    File image,
    List<FridgeProductData> existingProducts,
  ) async {
    final incoming = await _remote.scanImage(
      image,
      existingProducts: existingProducts
          .map((e) => {
                'name': e.name,
                'amount': e.amount,
                'unit': e.unit,
                'confidence': e.confidence,
              })
          .toList(),
      appendMode: true,
    );
    return incoming
        .map(
          (p) => FridgeProductData(
            name: p.name,
            amount: p.amount,
            unit: p.unit,
            category: 'other',
            confidence: p.confidence,
          ),
        )
        .toList();
  }

  @override
  Future<List<FridgeProductData>> getProducts() async {
    final rows = await _db.fridgeDao.getAllFridgeProducts();
    return rows
        .map(
          (e) => FridgeProductData(
            name: e.name,
            amount: e.amount,
            unit: e.unit,
            category: e.category,
            confidence: 0,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveProducts(List<FridgeProductData> products) async {
    final existing = await _db.fridgeDao.getAllFridgeProducts();
    for (final row in existing) {
      await _db.fridgeDao.deleteFridgeProduct(row.id);
    }
    for (final p in products) {
      await addProduct(p);
    }
  }

  @override
  Future<void> addProduct(FridgeProductData product) async {
    await _db.fridgeDao.insertFridgeProduct(
      FridgeProductsCompanion.insert(
        name: product.name,
        amount: product.amount,
        unit: product.unit,
        category: product.category,
        addedAt: DateTime.now().toUtc(),
      ),
    );
  }

  @override
  Future<void> removeProductByName(String name) async {
    final rows = await _db.fridgeDao.getAllFridgeProducts();
    for (final row in rows.where((e) => _norm(e.name) == _norm(name))) {
      await _db.fridgeDao.deleteFridgeProduct(row.id);
    }
  }

  @override
  Future<void> updateProduct(String name, FridgeProductData product) async {
    final rows = await _db.fridgeDao.getAllFridgeProducts();
    FridgeProductEntry? row;
    for (final item in rows) {
      if (_norm(item.name) == _norm(name)) {
        row = item;
        break;
      }
    }
    if (row == null) return;
    await _db.fridgeDao.updateFridgeProduct(
      row.copyWith(
        name: product.name,
        amount: product.amount,
        unit: product.unit,
        category: product.category,
      ),
    );
  }

  @override
  Future<void> saveScanRecord(String photoPath, int productCount) async {
    await _db.fridgeDao.insertFridgeScan(
      FridgeScansCompanion.insert(
        photoPath: photoPath,
        scanDate: DateTime.now().toUtc(),
        productCount: Value(productCount),
      ),
    );
  }

  @override
  Future<List<FridgeScanData>> getScanHistory() async {
    final rows = await _db.fridgeDao.getAllFridgeScans();
    rows.sort((a, b) => b.scanDate.compareTo(a.scanDate));
    return rows
        .map(
          (e) => FridgeScanData(
            id: e.id,
            photoPath: e.photoPath,
            scanDate: e.scanDate,
            productCount: e.productCount,
          ),
        )
        .toList();
  }

  static String _norm(String value) => value.trim().toLowerCase();
}

