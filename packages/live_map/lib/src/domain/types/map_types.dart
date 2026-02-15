enum MapStyleMode { day, night }

enum MapDimensionMode { twoD, threeD }

class MapModel {
  static const double defaultThreshold = 0.00015;

  final String id;
  final double latitude;
  final double longitude;

  const MapModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  bool isNear(double lat, double lng, {double threshold = defaultThreshold}) {
    return (latitude - lat).abs() < threshold &&
        (longitude - lng).abs() < threshold;
  }
}
