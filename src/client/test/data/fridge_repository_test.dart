import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/repository/fridge_repository.dart';
import 'package:client/data/remote/source/fridge_remote_source.dart';

class _FakeFridgeRemoteSource implements FridgeRemoteSource {
  List<Map<String, dynamic>>? lastExistingProducts;
  bool lastAppendMode = false;

  @override
  Future<List<RemoteFridgeProduct>> scanImage(
    File image, {
    List<Map<String, dynamic>>? existingProducts,
    bool appendMode = false,
  }) async {
    lastExistingProducts = existingProducts;
    lastAppendMode = appendMode;
    if (appendMode) {
      return const [
        RemoteFridgeProduct(name: 'Tomato', amount: 3, unit: 'pcs', confidence: 0.9),
      ];
    }
    return const [
      RemoteFridgeProduct(name: 'Eggs', amount: 4, unit: 'pcs', confidence: 0.8),
      RemoteFridgeProduct(name: 'Milk', amount: 1, unit: 'l', confidence: 0.95),
    ];
  }
}

void main() {
  test('scanImage + saveProducts persists fridge products', () async {
    final db = AppDatabase.test();
    addTearDown(db.close);
    final repo = FridgeRepository(
      database: db,
      remoteSource: _FakeFridgeRemoteSource(),
    );

    final products = await repo.scanImage(File('fake.jpg'));
    await repo.saveProducts(products);

    final stored = await repo.getProducts();
    expect(stored.length, 2);
    expect(stored.first.name, 'Eggs');
  });

  test('appendScan merges by name and unit', () async {
    final remote = _FakeFridgeRemoteSource();
    final db = AppDatabase.test();
    addTearDown(db.close);
    final repo = FridgeRepository(
      database: db,
      remoteSource: remote,
    );

    await repo.saveProducts(const [
      FridgeProductData(name: 'Tomato', amount: 1, unit: 'pcs', category: 'other'),
    ]);
    final appended = await repo.appendScan(File('fake2.jpg'), await repo.getProducts());
    expect(appended.length, 1);
    expect(appended.first.amount, 3);
    expect(remote.lastAppendMode, isTrue);
    expect(remote.lastExistingProducts, isNotNull);
    expect(remote.lastExistingProducts!.first['confidence'], isA<num>());
  });
}

