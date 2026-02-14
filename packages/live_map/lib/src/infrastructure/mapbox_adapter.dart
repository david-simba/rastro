import 'dart:convert';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:live_map/src/domain/types/map_types.dart';

class MapboxAdapter {
  MapboxMap? _map;

  void bind(MapboxMap map) {
    _map = map;
  }

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

  Future<void> addStyleModel(String modelId, String modelUrl) async {
    final map = _map;
    if (map == null) return;
    await map.style.addStyleModel(modelId, modelUrl);
  }

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
  // Waypoints
  // ---------------------------------------------------------------------------

  Future<void> drawWaypoints(List<MapModel> waypoints) async {
    final map = _map;
    if (map == null || waypoints.isEmpty) return;

    const sourceId = 'waypoints-source';
    const layerId = 'waypoints-layer';

    if (await sourceExists(sourceId)) return;

    final geoJson = jsonEncode({
      'type': 'FeatureCollection',
      'features': waypoints.map((w) => {
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          'coordinates': [w.longitude, w.latitude],
        },
        'properties': {'id': w.id},
      }).toList(),
    });

    await addGeoJsonSource(sourceId, geoJson);

    if (await layerExists(layerId)) return;

    await map.style.addLayer(
      CircleLayer(id: layerId, sourceId: sourceId)
        ..circleRadius = 6.0
        ..circleColor = 0xFF6B7280
        ..circleStrokeWidth = 2.0
        ..circleStrokeColor = 0xFFFFFFFF,
    );
  }

  // TODO: Integrate with a time-service or Location
  Future<void> updateStyleAppearance(MapStyleMode mode) async {
    final map = _map;
    if (map == null) return;

    await map.style.setStyleTransition(
      TransitionOptions(duration: 500, delay: 0),
    );

    final theme = mode == MapStyleMode.day ? 'day' : 'night';
    await map.style.setStyleImportConfigProperty(
      'basemap',
      'lightPreset',
      theme,
    );
  }

  Future<void> hideDefaultLayers() async {
    final map = _map;
    if (map == null) return;
    await map.style.setStyleImportConfigProperty(
      'basemap',
      'showPointOfInterestLabels',
      false,
    );
    await map.style.setStyleImportConfigProperty(
      'basemap',
      'showRoadLabels',
      true,
    );
    await map.style.setStyleImportConfigProperty(
      'basemap',
      'showPlaceLabels',
      true,
    );
  }

  void dispose() {
    _map = null;
  }
}
