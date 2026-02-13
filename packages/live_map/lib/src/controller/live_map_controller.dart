import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class LiveMapController {
  MapboxMap? _mapboxMap;

  bool get isReady => _mapboxMap != null;

  void bind(MapboxMap map) {
    _mapboxMap = map;
  }

  Future<void> flyTo({
    required double latitude,
    required double longitude,
    double? zoom,
  }) async {
    final map = _mapboxMap;
    if (map == null) return;
    await map.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(longitude, latitude)),
        zoom: zoom,
      ),
      null,
    );
  }
}
