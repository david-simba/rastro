import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/live_map_store.dart';
import 'package:live_map/src/data/live_map_data_source.dart';
import 'package:live_map/src/infrastructure/mapbox_adapter.dart';

class MapboxRenderer {
  final LiveMapStore _store;
  final MapboxAdapter _adapter;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  static const String _sourceId = 'model-source';
  static const String _layerId = 'model-layer';

  MapboxRenderer(this._store, this._adapter) {
    _subscriptions.add(
      _store.eventBus.on<CameraFlyTo>(_onCameraFlyTo),
    );
    _subscriptions.add(
      _store.eventBus.on<CameraMoveTo>(_onCameraMoveTo),
    );
    _subscriptions.add(
      _store.eventBus.on<ModelLayerRequested>(_onModelLayerRequested),
    );
    _subscriptions.add(
      _store.eventBus.on<TrackingPositionReceived>(_onTrackingPositionReceived),
    );
  }

  // ---------------------------------------------------------------------------
  // Camera
  // ---------------------------------------------------------------------------

  void _onCameraFlyTo(CameraFlyTo event) {
    _adapter.flyTo(event.latitude, event.longitude, event.zoom);
  }

  void _onCameraMoveTo(CameraMoveTo event) {
    _adapter.easeTo(event.latitude, event.longitude, event.zoom);
  }

  // ---------------------------------------------------------------------------
  // Model layer loading
  // ---------------------------------------------------------------------------

  Future<void> _onModelLayerRequested(ModelLayerRequested event) async {
    final state = _store.state;
    final modelConfig = state.modelConfig;
    if (modelConfig == null) return;

    try {
      final modelUrl = await _loadModelToTempFile(modelConfig.modelPath);

      if (await _adapter.sourceExists(_sourceId)) return;

      await _adapter.addStyleModel('model', modelUrl);

      final geoJson = _buildModelGeoJson(state.models.models);
      await _adapter.addGeoJsonSource(_sourceId, geoJson);

      if (await _adapter.layerExists(_layerId)) return;

      await _adapter.addModelLayer(
        layerId: _layerId,
        sourceId: _sourceId,
        modelId: 'model',
        scale: modelConfig.scale,
        rotation: modelConfig.rotation,
      );

      _store.dispatch(const ModelLayerAdded());
    } catch (e) {
      debugPrint('MapboxRenderer: error loading model layer: $e');
      _store.dispatch(ModelLayerFailed(error: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Tracking
  // ---------------------------------------------------------------------------

  Future<void> _onTrackingPositionReceived(
    TrackingPositionReceived event,
  ) async {
    final state = _store.state;
    final geoJson = {
      'type': 'FeatureCollection',
      'features': state.models.models.map((m) {
        return {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [m.longitude, m.latitude],
          },
          'properties': {'modelId': m.id},
        };
      }).toList(),
    };

    try {
      await _adapter.updateSourceData(_sourceId, jsonEncode(geoJson));
    } catch (e) {
      debugPrint('MapboxRenderer: error updating model position: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _buildModelGeoJson(List<MapModel> models) {
    final geoJson = {
      'type': 'FeatureCollection',
      'features': models.map((m) {
        return {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [m.longitude, m.latitude],
          },
          'properties': {'modelId': m.id},
        };
      }).toList(),
    };
    return jsonEncode(geoJson);
  }

  static Future<String> _loadModelToTempFile(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final dir = await getTemporaryDirectory();
    final fileName = assetPath.split('/').last;
    final file = File('${dir.path}/$fileName');

    if (!await file.exists()) {
      await file.writeAsBytes(data.buffer.asUint8List());
    }
    return 'file://${file.path}';
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
