enum MapDimensionMode { twoD, threeD }

/// Lightweight coordinate pair used throughout live_map's domain and services.
class LatLng {
  final double lat;
  final double lng;

  const LatLng({required this.lat, required this.lng});

  @override
  String toString() => 'LatLng($lat, $lng)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLng && other.lat == lat && other.lng == lng;

  @override
  int get hashCode => Object.hash(lat, lng);
}

class MapModel {
  static const double defaultThreshold = 0.00015;

  final String id;
  final double latitude;
  final double longitude;
  final double bearing;
  final String? routeId;
  final bool isOnRoute;
  final Map<String, dynamic>? metadata;

  const MapModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.bearing = 0.0,
    this.routeId,
    this.isOnRoute = false,
    this.metadata,
  });

  bool isNear(double lat, double lng, {double threshold = defaultThreshold}) {
    return (latitude - lat).abs() < threshold &&
        (longitude - lng).abs() < threshold;
  }
}
