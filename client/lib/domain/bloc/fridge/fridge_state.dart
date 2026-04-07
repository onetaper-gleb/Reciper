import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../data/repository/fridge_repository.dart';

sealed class FridgeState extends Equatable {
  const FridgeState();

  @override
  List<Object?> get props => [];
}

final class FridgeInitial extends FridgeState {
  const FridgeInitial();
}

final class FridgeScanning extends FridgeState {
  const FridgeScanning();
}

final class FridgeScanResult extends FridgeState {
  const FridgeScanResult({
    required this.recognizedProducts,
    required this.imageFile,
  });

  final List<FridgeProductData> recognizedProducts;
  final File imageFile;

  @override
  List<Object?> get props => [recognizedProducts, imageFile.path];
}

final class FridgeLoaded extends FridgeState {
  const FridgeLoaded({
    required this.products,
    required this.history,
  });

  final List<FridgeProductData> products;
  final List<FridgeScanData> history;

  DateTime? get lastScanDate => history.isEmpty ? null : history.first.scanDate;

  @override
  List<Object?> get props => [products, history];
}

final class FridgeError extends FridgeState {
  const FridgeError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

