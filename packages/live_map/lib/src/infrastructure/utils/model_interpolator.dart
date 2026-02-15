/// Per-model interpolation state.
///
/// Holds from/to snapshots and advances via elapsed time so that the
/// renderer can push sub-frame GeoJSON updates at ~60 fps.
class ModelInterpolator {
  final double fromLat;
  final double fromLng;
  final double fromBearing;
  final double toLat;
  final double toLng;
  final double toBearing;
  final Duration duration;
  Duration elapsed = Duration.zero;

  ModelInterpolator({
    required this.fromLat,
    required this.fromLng,
    required this.fromBearing,
    required this.toLat,
    required this.toLng,
    required this.toBearing,
    required this.duration,
  });

  double get t => duration.inMicroseconds == 0
      ? 1.0
      : (elapsed.inMicroseconds / duration.inMicroseconds).clamp(0.0, 1.0);

  bool get isDone => t >= 1.0;

  double get lat => lerp(fromLat, toLat, t);
  double get lng => lerp(fromLng, toLng, t);
  double get bearing => lerpAngle(fromBearing, toBearing, t);

  /// Standard linear interpolation.
  static double lerp(double a, double b, double t) => a + (b - a) * t;

  /// Shortest-path angle interpolation (e.g. 350° → 10° goes through 0°).
  static double lerpAngle(double from, double to, double t) {
    final diff = ((to - from) % 360 + 540) % 360 - 180;
    return ((from + diff * t) % 360 + 360) % 360;
  }
}
