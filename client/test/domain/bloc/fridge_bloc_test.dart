import 'dart:io';

import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/repository/fridge_repository.dart';
import 'package:client/domain/bloc/fridge/fridge_bloc.dart';
import 'package:client/domain/bloc/fridge/fridge_event.dart';
import 'package:client/domain/bloc/fridge/fridge_state.dart';

class _FakeFridgeRepository implements FridgeRepositoryBase {

  @override
  Future<List<FridgeProductData>> getProducts() async => const [
        FridgeProductData(name: 'Eggs', amount: 4, unit: 'pcs', category: 'other'),
      ];

  @override
  Future<List<FridgeProductData>> scanImage(File image) async => const [
        FridgeProductData(name: 'Milk', amount: 1, unit: 'l', category: 'other'),
      ];

  @override
  Future<void> addProduct(FridgeProductData product) async {}

  @override
  Future<List<FridgeProductData>> appendScan(
    File image,
    List<FridgeProductData> existingProducts,
  ) async =>
      existingProducts;

  @override
  Future<List<FridgeScanData>> getScanHistory() async => const [];

  @override
  Future<void> removeProductByName(String name) async {}

  @override
  Future<void> saveProducts(List<FridgeProductData> products) async {}

  @override
  Future<void> saveScanRecord(String photoPath, int productCount) async {}

  @override
  Future<void> updateProduct(String name, FridgeProductData product) async {}
}

void main() {
  blocTest<FridgeBloc, FridgeState>(
    'load emits FridgeLoaded',
    build: () => FridgeBloc(repository: _FakeFridgeRepository()),
    act: (bloc) => bloc.add(const FridgeLoadRequested()),
    expect: () => [
      isA<FridgeLoaded>(),
    ],
  );

  blocTest<FridgeBloc, FridgeState>(
    'scan emits scanning then result',
    build: () => FridgeBloc(repository: _FakeFridgeRepository()),
    act: (bloc) => bloc.add(FridgeScanStarted(File('fake.jpg'))),
    expect: () => [
      isA<FridgeScanning>(),
      isA<FridgeScanResult>(),
    ],
  );
}

