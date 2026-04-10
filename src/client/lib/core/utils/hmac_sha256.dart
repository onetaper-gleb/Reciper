import 'dart:convert';
import 'dart:typed_data';

import 'sha256.dart';

abstract final class HmacSha256 {
  static const int _blockSize = 64;

  static Uint8List digest({required String key, required Uint8List message}) {
    var keyBytes = Uint8List.fromList(utf8.encode(key));
    if (keyBytes.length > _blockSize) {
      keyBytes = Sha256.hash(keyBytes);
    }
    if (keyBytes.length < _blockSize) {
      final padded = Uint8List(_blockSize);
      padded.setRange(0, keyBytes.length, keyBytes);
      keyBytes = padded;
    }

    final oKeyPad = Uint8List(_blockSize);
    final iKeyPad = Uint8List(_blockSize);
    for (var i = 0; i < _blockSize; i++) {
      final b = keyBytes[i];
      oKeyPad[i] = b ^ 0x5c;
      iKeyPad[i] = b ^ 0x36;
    }

    final inner = Sha256.hash(_concat(iKeyPad, message));
    return Sha256.hash(_concat(oKeyPad, inner));
  }

  static String hexDigest({required String key, required Uint8List message}) {
    final bytes = digest(key: key, message: message);
    final sb = StringBuffer();
    for (final b in bytes) {
      sb.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
  }

  static Uint8List _concat(Uint8List a, Uint8List b) {
    final out = Uint8List(a.length + b.length);
    out.setRange(0, a.length, a);
    out.setRange(a.length, out.length, b);
    return out;
  }
}

