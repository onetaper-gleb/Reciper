import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../data/repository/fridge_repository.dart';

sealed class FridgeEvent extends Equatable {
  const FridgeEvent();

  @override
  List<Object?> get props => [];
}

final class FridgeLoadRequested extends FridgeEvent {
  const FridgeLoadRequested();
}

final class FridgeScanStarted extends FridgeEvent {
  const FridgeScanStarted(this.image);
  final File image;

  @override
  List<Object?> get props => [image.path];
}

final class FridgeAppendScanStarted extends FridgeEvent {
  const FridgeAppendScanStarted(this.image);
  final File image;

  @override
  List<Object?> get props => [image.path];
}

final class FridgeProductRemoved extends FridgeEvent {
  const FridgeProductRemoved(this.name);
  final String name;
  @override
  List<Object?> get props => [name];
}

final class FridgeProductAdded extends FridgeEvent {
  const FridgeProductAdded(this.product);
  final FridgeProductData product;
  @override
  List<Object?> get props => [product];
}

final class FridgeProductsConfirmed extends FridgeEvent {
  const FridgeProductsConfirmed(this.products, this.imagePath);
  final List<FridgeProductData> products;
  final String imagePath;
  @override
  List<Object?> get props => [products, imagePath];
}

