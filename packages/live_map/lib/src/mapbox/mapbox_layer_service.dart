import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxLayerService {
  final MapboxMap controller;

  static const String _sourceId = 'model-source';
  static const String _layerId = 'model-layer';

  MapboxLayerService(this.controller);

  Future<void> addModelLayer({
    required String modelId,
    required String modelUrl,
    required Position position,
    required List<double> scale,
    required List<double> rotation,
  }) async {
    try {
      if (await controller.style.styleSourceExists(_sourceId)) return;
      await controller.style.addStyleModel(modelId, modelUrl);

      final geoJson = {
        'type': 'FeatureCollection',
        'features': [
          {
            'type': 'Feature',
            'geometry': {
              'type': 'Point',
              'coordinates': [position.lng, position.lat],
            },
            'properties': {},
          },
        ],
      };

      await controller.style.addSource(
        GeoJsonSource(id: _sourceId, data: jsonEncode(geoJson)),
      );

      if (await controller.style.styleLayerExists(_layerId)) return;
      await controller.style.addLayer(
        ModelLayer(id: _layerId, sourceId: _sourceId)
          ..modelId = modelId
          ..modelType = ModelType.COMMON_3D
          ..modelScale = scale
          ..modelRotation = rotation,
      );
    } catch (e) {
      debugPrint('Error adding model layer: $e');
    }
  }
}
