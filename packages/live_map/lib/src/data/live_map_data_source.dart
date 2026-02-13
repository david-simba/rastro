class MapPosition {
  final double latitude;
  final double longitude;

  const MapPosition({
    required this.latitude,
    required this.longitude,
  });
}

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

abstract class LiveMapDataSource {
  MapPosition get cameraPosition;
  MapPosition get modelPosition;
  List<MapModel> get models;
  double get zoom;
}
