import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:live_map/src/domain/types/map_types.dart';

class MapboxAdapter {
  /// Degrees added to each model's bearing to compensate for GLB assets whose
  /// front face does not point North. Set to 270 if the model faces East by
  /// default; adjust whenever the GLB file changes.
  static const double _kModelBearingOffset = 0.0;

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
      MapAnimationOptions(duration: 1200),
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
        ..modelScaleMode = ModelScaleMode.MAP
        ..modelCastShadows = false
        ..modelReceiveShadows = false,
    );

    await map.style.setStyleLayerProperty(
      layerId,
      'model-rotation',
      [
        rotation[0],
        rotation[1],
        ['+', ['get', 'modelBearing'], _kModelBearingOffset, 180],
      ],
    );
  }

  void setPitch(double pitch) {
    final map = _map;
    if (map == null) return;
    map.flyTo(
      CameraOptions(pitch: pitch),
      MapAnimationOptions(duration: 0),
    );
  }

  Future<void> loadStyle(String styleUri) async {
    await _map?.loadStyleURI(styleUri);
  }

  /// Updates the model-layer scale property on the GPU without recreating
  /// the layer. Safe to call on every camera-change tick.
  Future<void> updateModelScale(String layerId, List<double> scale) async {
    final map = _map;
    if (map == null) return;
    await map.style.setStyleLayerProperty(layerId, 'model-scale', scale);
  }

  /// Renders a road route on the map as a [LineLayer].
  ///
  /// Safe to call multiple times for the same [routeId] — updates the GeoJSON
  /// source in-place if the layer already exists. The layer is keyed by
  /// [routeId] so multiple independent routes can coexist on the map.
  Future<void> drawRoute(
    String routeId,
    List<LatLng> points, {
    int color = 0xFF93C5FD,
    double width = 5.0,
  }) async {
    final map = _map;
    if (map == null || points.isEmpty) return;

    final sourceId = 'route-source-$routeId';
    final layerId = 'route-layer-$routeId';

    final geoJson = jsonEncode({
      'type': 'Feature',
      'geometry': {
        'type': 'LineString',
        'coordinates': points.map((p) => [p.lng, p.lat]).toList(),
      },
      'properties': {},
    });

    if (await sourceExists(sourceId)) {
      await updateSourceData(sourceId, geoJson);
    } else {
      await addGeoJsonSource(sourceId, geoJson);
    }

    if (!await layerExists(layerId)) {
      await map.style.addLayer(
        LineLayer(id: layerId, sourceId: sourceId)
          ..lineColor = color
          ..lineWidth = width,
      );

      // Place the route line below the first symbol layer (road labels, POI
      // names, etc.) so text remains readable on top of the route.
      final firstSymbol = await _firstSymbolLayerId();
      if (firstSymbol != null) {
        await map.style.moveStyleLayer(
          layerId,
          LayerPosition(below: firstSymbol),
        );
      }
    }
  }

  /// Returns the id of the first [symbol] layer in the current map style, or
  /// null if none is found. Used to position the route line below road labels.
  Future<String?> _firstSymbolLayerId() async {
    final map = _map;
    if (map == null) return null;
    final layers = await map.style.getStyleLayers();
    for (final layer in layers) {
      if (layer?.type == 'symbol') return layer?.id;
    }
    return null;
  }

  /// Draws a pin on the map for each stop in [points].
  ///
  /// If [pinIcon] is provided (raw PNG bytes), a symbol layer is used with
  /// that image. Otherwise falls back to a circle layer.
  ///
  /// Safe to call multiple times for the same [routeId] — updates the GeoJSON
  /// source in-place if the layer already exists.
  Future<void> drawStopPins(
    String routeId,
    List<LatLng> points, {
    Uint8List? pinIcon,
  }) async {
    final map = _map;
    if (map == null || points.isEmpty) return;

    final sourceId = 'stops-source-$routeId';
    final layerId = 'stops-layer-$routeId';
    final imageId = 'stops-icon-$routeId';

    final geoJson = jsonEncode({
      'type': 'FeatureCollection',
      'features': points
          .map((p) => {
                'type': 'Feature',
                'geometry': {
                  'type': 'Point',
                  'coordinates': [p.lng, p.lat],
                },
                'properties': {},
              })
          .toList(),
    });

    if (await sourceExists(sourceId)) {
      await updateSourceData(sourceId, geoJson);
    } else {
      await addGeoJsonSource(sourceId, geoJson);
    }

    if (!await layerExists(layerId)) {
      if (pinIcon != null) {
        final mbxImage = await _decodePngToMbxImage(pinIcon);
        await map.style.addStyleImage(imageId, 1.0, mbxImage, false, [], [], null);
        await map.style.addLayer(
          SymbolLayer(id: layerId, sourceId: sourceId)
            ..iconImage = imageId
            ..iconAllowOverlap = true
            ..iconIgnorePlacement = true
            ..iconAnchor = IconAnchor.BOTTOM
            ..iconSizeExpression = [
              'interpolate', ['linear'], ['zoom'],
              10, 0.2,
              14, 0.2,
              17, 0.3,
            ],
        );
      } else {
        await map.style.addLayer(
          CircleLayer(id: layerId, sourceId: sourceId)
            ..circleColor = 0xFF3B82F6
            ..circleRadius = 6.0
            ..circleStrokeWidth = 2.0
            ..circleStrokeColor = 0xFFFFFFFF,
        );
      }
    }
  }

  /// Wraps [bytes] (PNG/JPEG) into an [MbxImage].
  ///
  /// Mapbox's native SDK accepts compressed image data directly; we only need
  /// the pixel dimensions from the Flutter codec.
  Future<MbxImage> _decodePngToMbxImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    return MbxImage(
      width: image.width,
      height: image.height,
      data: bytes,
    );
  }

  /// Removes the stop pins layer, its backing GeoJSON source, and any
  /// registered icon image from the map style.
  Future<void> clearStopPins(String routeId) async {
    final map = _map;
    if (map == null) return;

    final layerId = 'stops-layer-$routeId';
    final sourceId = 'stops-source-$routeId';
    final imageId = 'stops-icon-$routeId';

    try {
      if (await layerExists(layerId)) {
        await map.style.removeStyleLayer(layerId);
      }
      if (await sourceExists(sourceId)) {
        await map.style.removeStyleSource(sourceId);
      }
      if (await map.style.hasStyleImage(imageId)) {
        await map.style.removeStyleImage(imageId);
      }
    } catch (_) {
      // Map was disposed before cleanup completed — safe to ignore.
    }
  }

  /// Removes the route line layer and its backing GeoJSON source from the map.
  Future<void> clearRoute(String routeId) async {
    final map = _map;
    if (map == null) return;

    final layerId = 'route-layer-$routeId';
    final sourceId = 'route-source-$routeId';

    try {
      if (await layerExists(layerId)) {
        await map.style.removeStyleLayer(layerId);
      }
      if (await sourceExists(sourceId)) {
        await map.style.removeStyleSource(sourceId);
      }
    } catch (_) {
      // Map was disposed before cleanup completed — safe to ignore.
    }
  }

  Future<void> fitBounds(
    List<LatLng> points, {
    double padding = 60.0,
    double? bottomPadding,
  }) async {
    final map = _map;
    if (map == null || points.isEmpty) return;

    final minLat = points.map((p) => p.lat).reduce(math.min);
    final maxLat = points.map((p) => p.lat).reduce(math.max);
    final minLng = points.map((p) => p.lng).reduce(math.min);
    final maxLng = points.map((p) => p.lng).reduce(math.max);

    final bounds = CoordinateBounds(
      southwest: Point(coordinates: Position(minLng, minLat)),
      northeast: Point(coordinates: Position(maxLng, maxLat)),
      infiniteBounds: false,
    );

    final camera = await map.cameraForCoordinateBounds(
      bounds,
      MbxEdgeInsets(
        top: padding,
        left: padding,
        bottom: bottomPadding ?? padding,
        right: padding,
      ),
      null, null, null, null,
    );

    map.flyTo(
      CameraOptions(
        center: camera.center,
        zoom: (camera.zoom ?? 14) - 0.5,
        bearing: camera.bearing,
        pitch: camera.pitch,
      ),
      MapAnimationOptions(duration: 1200),
    );
  }

  Future<void> enableLocationPuck() async {
    final map = _map;
    if (map == null) return;
    await map.location.updateSettings(
      LocationComponentSettings(enabled: true, pulsingEnabled: true),
    );
  }

  void dispose() {
    _map = null;
  }
}
