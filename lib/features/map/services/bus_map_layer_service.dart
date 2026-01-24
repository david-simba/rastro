import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Bus3DMapLayerService {
  final MapboxMap controller;
  static const String sourceId = 'bus-source';
  static const String layerId = 'bus-layer';
  static const List<double> modelScale = [2.5, 2.5, 2.5];
  static const List<double> modelRotation = [0, 0, 112];
  static const ModelType modelType = ModelType.COMMON_3D;

  Bus3DMapLayerService(this.controller);

  Future<void> add3DBusLayer({
    required String modelId,
    required String modelUrl,
    required Position position,
  }) async {
    try {
      if (await controller.style.styleSourceExists(sourceId)) return;
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
        GeoJsonSource(id: sourceId, data: jsonEncode(geoJson)),
      );

      if (await controller.style.styleLayerExists(layerId)) return;
      await controller.style.addLayer(
        ModelLayer(id: layerId, sourceId: sourceId)
          ..modelId = modelId
          ..modelType = modelType
          ..modelScale = modelScale
          ..modelRotation = modelRotation,
      );
    } catch (e) {
      debugPrint('Error adding 3D bus layer: $e');
    }
  }
}
