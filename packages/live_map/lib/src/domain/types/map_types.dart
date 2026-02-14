enum MapStyleMode { day, night }

enum MapDimensionMode { twoD, threeD }

class MapModel {
  final String id;
  final double latitude;
  final double longitude;

  const MapModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });
}
