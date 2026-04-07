import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/remote/api/reciper_api.dart';
import 'package:client/data/remote/source/fridge_remote_source.dart';

class _FakeReciperApi extends ReciperApi {
  _FakeReciperApi() : super(Dio());

  String? capturedExistingProductsJson;
  String? capturedScanMode;

  @override
  Future<Map<String, dynamic>> scanFridge(
    File image, {
    String? existingProductsJson,
    String scanMode = 'replace',
  }) async {
    capturedExistingProductsJson = existingProductsJson;
    capturedScanMode = scanMode;
    return {
      'recognized_products': [
        {'name': 'Яйца', 'amount': 4, 'unit': 'шт', 'confidence': 0.94},
      ],
    };
  }
}

void main() {
  test('scanImage maps confidence and sends append payload', () async {
    final api = _FakeReciperApi();
    final source = FridgeRemoteSourceImpl(api);

    final result = await source.scanImage(
      File('fake.jpg'),
      existingProducts: const [
        {'name': 'Яйца', 'amount': 2, 'unit': 'шт', 'confidence': 0.8},
      ],
      appendMode: true,
    );

    expect(api.capturedScanMode, 'append');
    expect(api.capturedExistingProductsJson, contains('"confidence"'));
    expect(result.single.name, 'Яйца');
    expect(result.single.confidence, 0.94);
  });
}
