import 'dart:math' as math;

class GeoUtils {
  GeoUtils._();

  static double calculateBearing(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    final lat1 = _toRadians(startLat);
    final lat2 = _toRadians(endLat);
    final dLon = _toRadians(endLng - startLng);

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final radians = math.atan2(y, x);
    return (_toDegrees(radians) + 360) % 360;
  }

  static double _toRadians(double deg) => deg * math.pi / 180;
  static double _toDegrees(double rad) => rad * 180 / math.pi;
}
