import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import '../core/constants/app_config.dart';
import '../core/utils/hmac_sha256.dart';

abstract final class RequestSigning {
  static bool get enabled => AppConfig.apiSigningSecret.trim().isNotEmpty;

  static Map<String, String> buildHeaders({
    required String method,
    required String path,
    DateTime? now,
  }) {
    final secret = AppConfig.apiSigningSecret.trim();
    if (secret.isEmpty) return const {};

    final ts = ((now ?? DateTime.now()).millisecondsSinceEpoch / 1000).floor();
    final nonce = _nonceBase64Url(16);
    final msg = utf8.encode('$ts\n$nonce\n${method.toUpperCase()}\n$path');
    final sig = HmacSha256.hexDigest(key: secret, message: Uint8List.fromList(msg));

    return <String, String>{
      'X-Reciper-Timestamp': ts.toString(),
      'X-Reciper-Nonce': nonce,
      'X-Reciper-Signature': sig,
    };
  }

  static String _nonceBase64Url(int lengthBytes) {
    final rnd = Random.secure();
    final bytes = Uint8List(lengthBytes);
    for (var i = 0; i < lengthBytes; i++) {
      bytes[i] = rnd.nextInt(256);
    }
    // Strip '=' padding for nicer header.
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}

