import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/live_map_store.dart';
import 'package:live_map/src/infrastructure/mapbox_adapter.dart';
import 'package:live_map/src/infrastructure/utils/asset_loader_service.dart';
import 'package:live_map/src/infrastructure/utils/geojson_builder.dart';
import 'package:live_map/src/infrastructure/utils/model_interpolator.dart';

/// Wires [LiveMapStore] events to the [MapboxAdapter] and drives per-frame
/// model interpolation via a [Ticker].
class MapboxRenderer {
  final LiveMapStore _store;
  final MapboxAdapter _adapter;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  static const String _sourceId = 'model-source';
  static const String _layerId = 'model-layer';

  // Must match the simulation tick interval so each position jump is smoothly
  // interpolated over the gap between ticks.
  static const Duration _animDuration = Duration(milliseconds: 200);

  late final Ticker _ticker;
  Duration _lastTickElapsed = Duration.zero;
  final Map<String, ModelInterpolator> _lerps = {};

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

  // ---------------------------------------------------------------------------
  // Camera
  // ---------------------------------------------------------------------------

  void _onCameraFlyTo(CameraFlyTo event) {
    _adapter.flyTo(event.latitude, event.longitude, event.zoom);
  }

  void _onCameraMoveTo(CameraMoveTo event) {
    // _adapter.easeTo(
    //   event.latitude,
    //   event.longitude,
    //   event.zoom,
    //   bearing: event.bearing,
    // );
  }

  // ---------------------------------------------------------------------------
  // Style / Dimension
  // ---------------------------------------------------------------------------

  Future<void> _onMapStyleLoaded(MapStyleLoaded event) async {
    final state = _store.state;
    try {
      await _adapter.hideDefaultLayers();
      if (state.waypoints.isNotEmpty) {
        await _adapter.drawWaypoints(state.waypoints);
      }
    } catch (e) {
      debugPrint('MapboxRenderer: error applying initial style config: $e');
    }
  }

  void _onDimensionModeChanged(DimensionModeChanged event) {
    _adapter.setPitch(_store.state.camera.pitch);
  }

  // ---------------------------------------------------------------------------
  // Model layer loading
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // Tracking – frame-level interpolation
  // ---------------------------------------------------------------------------

  void _onTrackingPositionReceived(TrackingPositionReceived event) {
    final existing = _lerps[event.modelId];

    // Start a new lerp from the current rendered position (mid-animation or
    // final) toward the just-received target.  On the very first event
    // `existing` is null so from == to (instant snap).
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

  // ---------------------------------------------------------------------------
  // Animation tick (~60 fps)
  // ---------------------------------------------------------------------------

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

    final geoJson = ModelGeoJsonBuilder.fromInterpolated(
      _store.state.models.models,
      _lerps,
    );
    _adapter.updateSourceData(_sourceId, geoJson);

    if (!anyActive) {
      _ticker.stop();
      _lastTickElapsed = Duration.zero;
    }
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  void dispose() {
    _ticker.dispose();
    _lerps.clear();
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
