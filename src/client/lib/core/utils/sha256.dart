import 'dart:typed_data';

// Minimal SHA-256 implementation (no external deps).
// Based on FIPS 180-4.

abstract final class Sha256 {
  static Uint8List hash(Uint8List message) {
    final padded = _pad(message);
    final h = Uint32List.fromList(_initialHashValues);

    final w = Uint32List(64);

    for (var chunkOffset = 0; chunkOffset < padded.length; chunkOffset += 64) {
      // Prepare message schedule.
      for (var i = 0; i < 16; i++) {
        final j = chunkOffset + (i * 4);
        w[i] = (padded[j] << 24) |
            (padded[j + 1] << 16) |
            (padded[j + 2] << 8) |
            (padded[j + 3]);
      }
      for (var i = 16; i < 64; i++) {
        final s0 = _smallSigma0(w[i - 15]);
        final s1 = _smallSigma1(w[i - 2]);
        w[i] = _add32(_add32(_add32(w[i - 16], s0), w[i - 7]), s1);
      }

      var a = h[0];
      var b = h[1];
      var c = h[2];
      var d = h[3];
      var e = h[4];
      var f = h[5];
      var g = h[6];
      var hh = h[7];

      for (var i = 0; i < 64; i++) {
        final t1 = _add32(
          _add32(_add32(_add32(hh, _bigSigma1(e)), _ch(e, f, g)), _k[i]),
          w[i],
        );
        final t2 = _add32(_bigSigma0(a), _maj(a, b, c));

        hh = g;
        g = f;
        f = e;
        e = _add32(d, t1);
        d = c;
        c = b;
        b = a;
        a = _add32(t1, t2);
      }

      h[0] = _add32(h[0], a);
      h[1] = _add32(h[1], b);
      h[2] = _add32(h[2], c);
      h[3] = _add32(h[3], d);
      h[4] = _add32(h[4], e);
      h[5] = _add32(h[5], f);
      h[6] = _add32(h[6], g);
      h[7] = _add32(h[7], hh);
    }

    final out = Uint8List(32);
    for (var i = 0; i < 8; i++) {
      final v = h[i];
      out[(i * 4) + 0] = (v >> 24) & 0xff;
      out[(i * 4) + 1] = (v >> 16) & 0xff;
      out[(i * 4) + 2] = (v >> 8) & 0xff;
      out[(i * 4) + 3] = v & 0xff;
    }
    return out;
  }

  static Uint8List _pad(Uint8List message) {
    final bitLen = message.lengthInBytes * 8;
    // 1 byte 0x80 + padding + 8 bytes length
    var padLen = 64 - ((message.lengthInBytes + 1 + 8) % 64);
    if (padLen == 64) padLen = 0;

    final out = Uint8List(message.lengthInBytes + 1 + padLen + 8);
    out.setRange(0, message.lengthInBytes, message);
    out[message.lengthInBytes] = 0x80;

    // Append 64-bit big-endian length.
    final lenOffset = out.lengthInBytes - 8;
    out[lenOffset + 0] = (bitLen >> 56) & 0xff;
    out[lenOffset + 1] = (bitLen >> 48) & 0xff;
    out[lenOffset + 2] = (bitLen >> 40) & 0xff;
    out[lenOffset + 3] = (bitLen >> 32) & 0xff;
    out[lenOffset + 4] = (bitLen >> 24) & 0xff;
    out[lenOffset + 5] = (bitLen >> 16) & 0xff;
    out[lenOffset + 6] = (bitLen >> 8) & 0xff;
    out[lenOffset + 7] = (bitLen) & 0xff;
    return out;
  }

  static int _add32(int a, int b) => (a + b) & 0xffffffff;

  static int _rotr(int x, int n) => ((x >> n) | ((x << (32 - n)) & 0xffffffff)) & 0xffffffff;

  static int _shr(int x, int n) => (x >> n) & 0xffffffff;

  static int _ch(int x, int y, int z) => (x & y) ^ ((~x) & z);
  static int _maj(int x, int y, int z) => (x & y) ^ (x & z) ^ (y & z);

  static int _bigSigma0(int x) => _rotr(x, 2) ^ _rotr(x, 13) ^ _rotr(x, 22);
  static int _bigSigma1(int x) => _rotr(x, 6) ^ _rotr(x, 11) ^ _rotr(x, 25);
  static int _smallSigma0(int x) => _rotr(x, 7) ^ _rotr(x, 18) ^ _shr(x, 3);
  static int _smallSigma1(int x) => _rotr(x, 17) ^ _rotr(x, 19) ^ _shr(x, 10);

  static const List<int> _initialHashValues = <int>[
    0x6a09e667,
    0xbb67ae85,
    0x3c6ef372,
    0xa54ff53a,
    0x510e527f,
    0x9b05688c,
    0x1f83d9ab,
    0x5be0cd19,
  ];

  static const List<int> _k = <int>[
    0x428a2f98,
    0x71374491,
    0xb5c0fbcf,
    0xe9b5dba5,
    0x3956c25b,
    0x59f111f1,
    0x923f82a4,
    0xab1c5ed5,
    0xd807aa98,
    0x12835b01,
    0x243185be,
    0x550c7dc3,
    0x72be5d74,
    0x80deb1fe,
    0x9bdc06a7,
    0xc19bf174,
    0xe49b69c1,
    0xefbe4786,
    0x0fc19dc6,
    0x240ca1cc,
    0x2de92c6f,
    0x4a7484aa,
    0x5cb0a9dc,
    0x76f988da,
    0x983e5152,
    0xa831c66d,
    0xb00327c8,
    0xbf597fc7,
    0xc6e00bf3,
    0xd5a79147,
    0x06ca6351,
    0x14292967,
    0x27b70a85,
    0x2e1b2138,
    0x4d2c6dfc,
    0x53380d13,
    0x650a7354,
    0x766a0abb,
    0x81c2c92e,
    0x92722c85,
    0xa2bfe8a1,
    0xa81a664b,
    0xc24b8b70,
    0xc76c51a3,
    0xd192e819,
    0xd6990624,
    0xf40e3585,
    0x106aa070,
    0x19a4c116,
    0x1e376c08,
    0x2748774c,
    0x34b0bcb5,
    0x391c0cb3,
    0x4ed8aa4a,
    0x5b9cca4f,
    0x682e6ff3,
    0x748f82ee,
    0x78a5636f,
    0x84c87814,
    0x8cc70208,
    0x90befffa,
    0xa4506ceb,
    0xbef9a3f7,
    0xc67178f2,
  ];
}

