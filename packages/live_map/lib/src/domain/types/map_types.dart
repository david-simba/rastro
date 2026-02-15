enum MapStyleMode { day, night }

enum MapDimensionMode { twoD, threeD }

class MapModel {
  static const double defaultThreshold = 0.00015;

  final String id;
  final double latitude;
  final double longitude;
  final double bearing;

  const MapModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.bearing = 0.0,
  });

  bool isNear(double lat, double lng, {double threshold = defaultThreshold}) {
    return (latitude - lat).abs() < threshold &&
        (longitude - lng).abs() < threshold;
  }
}
