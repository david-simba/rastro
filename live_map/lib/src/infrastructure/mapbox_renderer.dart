import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/live_map_store.dart';
import 'package:live_map/src/infrastructure/mapbox_adapter.dart';
import 'package:live_map/src/infrastructure/utils/asset_loader_service.dart';
import 'package:live_map/src/infrastructure/utils/geojson_builder.dart';
import 'package:live_map/src/infrastructure/utils/model_interpolator.dart';

typedef _ModelSnapshot = ({String id, double lng, double lat, double bearing});

/// Wires [LiveMapStore] events to the [MapboxAdapter] and drives per-frame
/// model interpolation via a [Ticker].
class MapboxRenderer {
  final LiveMapStore _store;
  final MapboxAdapter _adapter;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  static const String _sourceId = 'model-source';
  static const String _layerId = 'model-layer';
  static const Duration _animDuration = Duration(milliseconds: 200);

  late final Ticker _ticker;
  Duration _lastTickElapsed = Duration.zero;
  final Map<String, ModelInterpolator> _lerps = {};
  bool _isComputingGeoJson = false;
  bool _disposed = false;

  MapboxRenderer(this._store, this._adapter) {
    _ticker = Ticker(_onAnimationTick);

    _subscriptions.addAll([
      _store.eventBus.on<CameraFlyTo>(_onCameraFlyTo),
      _store.eventBus.on<CameraMoveTo>(_onCameraMoveTo),
      _store.eventBus.on<ModelLayerRequested>(_onModelLayerRequested),
      _store.eventBus.on<TrackingPositionReceived>(_onTrackingPositionReceived),
      _store.eventBus.on<MapStyleLoaded>(_onMapStyleLoaded),
      _store.eventBus.on<DimensionModeChanged>(_onDimensionModeChanged),
    ]);
  }

  void _onCameraFlyTo(CameraFlyTo event) {
    _adapter.flyTo(event.latitude, event.longitude, event.zoom);
  }

  void _onCameraMoveTo(CameraMoveTo event) {}

  Future<void> _onMapStyleLoaded(MapStyleLoaded event) async {
    final state = _store.state;
    try {
      await _adapter.hideDefaultLayers();
      if (state.waypoints.isNotEmpty) {
        await _adapter.drawWaypoints(state.waypoints);
      }
      if (state.modelConfig != null) {
        _store.dispatch(const ModelLayerRequested());
      }
    } catch (e) {
      debugPrint('MapboxRenderer: error applying initial style config: $e');
    }
  }

  void _onDimensionModeChanged(DimensionModeChanged event) {
    _adapter.setPitch(_store.state.camera.pitch);
  }

  Future<void> _onModelLayerRequested(ModelLayerRequested event) async {
    final state = _store.state;
    final modelConfig = state.modelConfig;
    if (modelConfig == null) return;

    try {
      final modelUrl = await AssetLoaderService.loadToTempFile(
        modelConfig.modelPath,
      );

      if (await _adapter.sourceExists(_sourceId)) return;

      await _adapter.addStyleModel('model', modelUrl);

      final geoJson = ModelGeoJsonBuilder.fromModels(state.models.models);
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

  void _onTrackingPositionReceived(TrackingPositionReceived event) {
    final existing = _lerps[event.modelId];

    _lerps[event.modelId] = ModelInterpolator(
      fromLat: existing?.lat ?? event.latitude,
      fromLng: existing?.lng ?? event.longitude,
      fromBearing: existing?.bearing ?? event.bearing,
      toLat: event.latitude,
      toLng: event.longitude,
      toBearing: event.bearing,
      duration: _animDuration,
    );

    if (!_ticker.isActive) {
      _lastTickElapsed = Duration.zero;
      _ticker.start();
    }
  }

  void _onAnimationTick(Duration elapsed) {
    final dt = elapsed - _lastTickElapsed;
    _lastTickElapsed = elapsed;

    bool anyActive = false;
    for (final lerp in _lerps.values) {
      if (!lerp.isDone) {
        lerp.elapsed += dt;
        anyActive = true;
      }
    }

    if (!_isComputingGeoJson) {
      _isComputingGeoJson = true;
      final snapshots = _snapshotPositions();
      compute(_buildGeoJsonFromSnapshots, snapshots).then((geoJson) {
        if (!_disposed) {
          _adapter.updateSourceData(_sourceId, geoJson);
        }
        _isComputingGeoJson = false;
      });
    }

    if (!anyActive) {
      _ticker.stop();
      _lastTickElapsed = Duration.zero;
    }
  }

  /// Captures the current interpolated position of each model on the main
  /// thread. The returned list is plain data safe to send across isolates.
  List<_ModelSnapshot> _snapshotPositions() {
    return _store.state.models.models.map((m) {
      final lerp = _lerps[m.id];
      return (
        id: m.id,
        lng: lerp?.lng ?? m.longitude,
        lat: lerp?.lat ?? m.latitude,
        bearing: lerp?.bearing ?? m.bearing,
      );
    }).toList();
  }

  /// Encodes model snapshots into a GeoJSON FeatureCollection.
  /// Runs on a background isolate via [compute]; must be static.
  static String _buildGeoJsonFromSnapshots(List<_ModelSnapshot> snapshots) {
    return jsonEncode({
      'type': 'FeatureCollection',
      'features': snapshots
          .map((s) => {
                'type': 'Feature',
                'geometry': {
                  'type': 'Point',
                  'coordinates': [s.lng, s.lat],
                },
                'properties': {'modelId': s.id, 'modelBearing': s.bearing},
              })
          .toList(),
    });
  }

  void dispose() {
    _disposed = true;
    _ticker.dispose();
    _lerps.clear();
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
