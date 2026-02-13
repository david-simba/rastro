class MapPosition {
  final double latitude;
  final double longitude;

  const MapPosition({
    required this.latitude,
    required this.longitude,
  });
}

abstract class LiveMapDataSource {
  MapPosition get cameraPosition;
  MapPosition get modelPosition;
  double get zoom;
}
