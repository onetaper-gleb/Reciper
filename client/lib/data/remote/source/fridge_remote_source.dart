import 'dart:io';
import 'dart:convert';

import '../api/reciper_api.dart';

class RemoteFridgeProduct {
  const RemoteFridgeProduct({
    required this.name,
    required this.amount,
    required this.unit,
    required this.confidence,
  });

  final String name;
  final double amount;
  final String unit;
  final double confidence;
}

abstract class FridgeRemoteSource {
  Future<List<RemoteFridgeProduct>> scanImage(
    File image, {
    List<Map<String, dynamic>>? existingProducts,
    bool appendMode,
  });
}

class FridgeRemoteSourceImpl implements FridgeRemoteSource {
  FridgeRemoteSourceImpl(this._api);

  final ReciperApi _api;

  @override
  Future<List<RemoteFridgeProduct>> scanImage(
    File image, {
    List<Map<String, dynamic>>? existingProducts,
    bool appendMode = false,
  }) async {
    final data = await _api.scanFridge(
      image,
      existingProductsJson: existingProducts == null ? null : jsonEncode(existingProducts),
      scanMode: appendMode ? 'append' : 'replace',
    );
    final rows = (data['recognized_products'] as List?) ?? const [];
    return rows
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map(
          (e) => RemoteFridgeProduct(
            name: e['name']?.toString() ?? 'Unknown',
            amount: (e['amount'] as num?)?.toDouble() ?? 0,
            unit: e['unit']?.toString() ?? 'pcs',
            confidence: (e['confidence'] as num?)?.toDouble() ?? 0,
          ),
        )
        .toList();
  }
}

