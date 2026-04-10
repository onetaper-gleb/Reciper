/// Wall clock on the device for AI request metadata (backend `client_context.local_datetime`).
abstract final class ClientRequestClock {
  static String localDateTimeIso8601([DateTime? now]) {
    final dt = (now ?? DateTime.now()).toLocal();
    final off = dt.timeZoneOffset;
    final totalMinutes = off.inMinutes;
    final sign = totalMinutes < 0 ? '-' : '+';
    final abs = totalMinutes.abs();
    final oh = (abs ~/ 60).toString().padLeft(2, '0');
    final om = (abs % 60).toString().padLeft(2, '0');
    final y = dt.year.toString().padLeft(4, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final ms = dt.millisecond.toString().padLeft(3, '0');
    return '$y-$mo-${d}T$h:$mi:$s.$ms$sign$oh:$om';
  }

  static Map<String, dynamic> clientContextJson([DateTime? now]) => {
        'local_datetime': localDateTimeIso8601(now),
      };
}
