import 'dart:math' as math;

class UtilsFormats {
  static String formatSince(DateTime since) {
    final now = DateTime.now();
    Duration d = now.difference(since);
    if (d.isNegative) d = Duration.zero;

    final years = (d.inDays / 365).floor();
    final months = ((d.inDays % 365) / 30).floor();
    final days = d.inDays % 30;

    final parts = <String>[];
    if (years > 0) parts.add('$years р.');
    if (months > 0) parts.add('$months міс.');
    if (years == 0 && months == 0) parts.add('$days д.');

    return parts.isEmpty ? 'сьогодні' : parts.join(' ');
  }


  static double haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) * math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  static double _deg2rad(double deg) => deg * (math.pi / 180.0);

  static String formatDistance(double km) {
    if (km < 1) {
      final m = (km * 1000).round();
      return '$m м';
    }
    return '${km.toStringAsFixed(km < 10 ? 1 : 0)} км';
  }
}