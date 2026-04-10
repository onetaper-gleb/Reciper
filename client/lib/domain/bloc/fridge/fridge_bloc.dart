import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import 'package:client/core/errors/user_facing_error.dart';
import '../../../data/repository/fridge_repository.dart';
import 'fridge_event.dart';
import 'fridge_state.dart';

class FridgeBloc extends Bloc<FridgeEvent, FridgeState> {
  FridgeBloc({
    required FridgeRepositoryBase repository,
    this.useFakeScanner = false,
  })
      : _repo = repository,
        super(const FridgeInitial()) {
    on<FridgeLoadRequested>(_onLoad);
    on<FridgeScanStarted>(_onScan);
    on<FridgeAppendScanStarted>(_onAppendScan);
    on<FridgeProductsConfirmed>(_onConfirm);
    on<FridgeProductAdded>(_onAddProduct);
    on<FridgeProductRemoved>(_onRemoveProduct);
  }

  final FridgeRepositoryBase _repo;
  final bool useFakeScanner;

  Future<void> _onLoad(
    FridgeLoadRequested event,
    Emitter<FridgeState> emit,
  ) async {
    final products = await _repo.getProducts();
    final history = await _repo.getScanHistory();
    emit(FridgeLoaded(products: products, history: history));
  }

  Future<void> _onScan(
    FridgeScanStarted event,
    Emitter<FridgeState> emit,
  ) async {
    emit(const FridgeScanning());
    try {
      final products = useFakeScanner
          ? await _fakeScanProducts()
          : await _repo.scanImage(event.image);
      emit(FridgeScanResult(recognizedProducts: products, imageFile: event.image));
    } catch (e) {
      emit(FridgeError(userFacingErrorMessage(e)));
    }
  }

  Future<void> _onAppendScan(
    FridgeAppendScanStarted event,
    Emitter<FridgeState> emit,
  ) async {
    emit(const FridgeScanning());
    try {
      final existing = await _repo.getProducts();
      final products = useFakeScanner
          ? await _fakeAppendProducts(existing)
          : await _repo.appendScan(event.image, existing);
      emit(FridgeScanResult(recognizedProducts: products, imageFile: event.image));
    } catch (e) {
      emit(FridgeError(userFacingErrorMessage(e)));
    }
  }

  Future<void> _onConfirm(
    FridgeProductsConfirmed event,
    Emitter<FridgeState> emit,
  ) async {
    await _repo.saveProducts(event.products);
    await _repo.saveScanRecord(event.imagePath, event.products.length);
    add(const FridgeLoadRequested());
  }

  Future<void> _onAddProduct(
    FridgeProductAdded event,
    Emitter<FridgeState> emit,
  ) async {
    await _repo.addProduct(event.product);
    add(const FridgeLoadRequested());
  }

  Future<void> _onRemoveProduct(
    FridgeProductRemoved event,
    Emitter<FridgeState> emit,
  ) async {
    await _repo.removeProductByName(event.name);
    add(const FridgeLoadRequested());
  }

  Future<List<FridgeProductData>> _fakeScanProducts() async {
    // TODO(scanner): switch back to real backend call via repository.scanImage.
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    return const [
      FridgeProductData(name: 'Яйца', amount: 8, unit: 'шт', category: 'Белки'),
      FridgeProductData(name: 'Молоко', amount: 1, unit: 'л', category: 'Молочные'),
      FridgeProductData(name: 'Помидоры', amount: 4, unit: 'шт', category: 'Овощи'),
    ];
  }

  Future<List<FridgeProductData>> _fakeAppendProducts(
    List<FridgeProductData> existing,
  ) async {
    // TODO(scanner): switch back to real backend call via repository.appendScan.
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    final extra = [
      const FridgeProductData(name: 'Курица', amount: 0.6, unit: 'кг', category: 'Мясо'),
      const FridgeProductData(name: 'Яйца', amount: 2, unit: 'шт', category: 'Белки'),
    ];
    final merged = <String, FridgeProductData>{
      for (final p in existing) '${p.name}|${p.unit}': p,
    };
    for (final item in extra) {
      final key = '${item.name}|${item.unit}';
      final prev = merged[key];
      merged[key] = prev == null
          ? item
          : prev.copyWith(amount: prev.amount + item.amount);
    }
    return merged.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name))
      ..shuffle(Random(1));
  }
}

