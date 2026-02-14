import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxAdapter {
  MapboxMap? _map;

  void bind(MapboxMap map) {
    _map = map;
  }

  // ---------------------------------------------------------------------------
  // Camera
  // ---------------------------------------------------------------------------

  void flyTo(double lat, double lng, double? zoom) {
    final map = _map;
    if (map == null) return;
    map.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: zoom,
      ),
      null,
    );
  }

  void easeTo(double lat, double lng, double? zoom) {
    final map = _map;
    if (map == null) return;
    map.easeTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: zoom,
      ),
      null,
    );
  }

  // ---------------------------------------------------------------------------
  // Style models
  // ---------------------------------------------------------------------------

  Future<void> addStyleModel(String modelId, String modelUrl) async {
    final map = _map;
    if (map == null) return;
    await map.style.addStyleModel(modelId, modelUrl);
  }

  // ---------------------------------------------------------------------------
  // Sources
  // ---------------------------------------------------------------------------

  Future<bool> sourceExists(String sourceId) async {
    final map = _map;
    if (map == null) return false;
    return map.style.styleSourceExists(sourceId);
  }

  Future<void> addGeoJsonSource(String sourceId, String geoJson) async {
    final map = _map;
    if (map == null) return;
    await map.style.addSource(
      GeoJsonSource(id: sourceId, data: geoJson),
    );
  }

  Future<void> updateSourceData(String sourceId, String geoJson) async {
    final map = _map;
    if (map == null) return;
    await map.style.setStyleSourceProperty(sourceId, 'data', geoJson);
  }

  // ---------------------------------------------------------------------------
  // Layers
  // ---------------------------------------------------------------------------

  Future<bool> layerExists(String layerId) async {
    final map = _map;
    if (map == null) return false;
    return map.style.styleLayerExists(layerId);
  }

  Future<void> addModelLayer({
    required String layerId,
    required String sourceId,
    required String modelId,
    required List<double> scale,
    required List<double> rotation,
  }) async {
    final map = _map;
    if (map == null) return;
    await map.style.addLayer(
      ModelLayer(id: layerId, sourceId: sourceId)
        ..modelId = modelId
        ..modelType = ModelType.COMMON_3D
        ..modelScale = scale
        ..modelRotation = rotation,
    );
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  void dispose() {
    _map = null;
  }
}
