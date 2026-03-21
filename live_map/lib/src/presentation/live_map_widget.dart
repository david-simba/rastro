import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:live_map/src/domain/types/map_types.dart';
import 'package:live_map/src/domain/entities/live_map_config.dart';
import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/state/live_map_state.dart';
import 'package:live_map/src/core/live_map_store.dart';
import 'package:live_map/src/infrastructure/mapbox_adapter.dart';
import 'package:live_map/src/infrastructure/mapbox_renderer.dart';
import 'package:live_map/src/application/camera/camera_handler.dart';
import 'package:live_map/src/application/interaction/interaction_handler.dart';
import 'package:live_map/src/application/model/model_handler.dart';
import 'package:live_map/src/application/tracking/tracking_handler.dart';
import 'package:live_map/src/infrastructure/services/route_manager.dart';
import 'package:live_map/src/presentation/live_map_controller.dart';

class LiveMapWidget extends StatefulWidget {
  final LiveMapConfig config;
  final LiveMapController? controller;
  final void Function(MapModel model)? onModelTap;

  const LiveMapWidget({
    required this.config,
    this.controller,
    this.onModelTap,
    super.key,
  });

  static void setAccessToken(String token) {
    MapboxOptions.setAccessToken(token);
  }

  @override
  State<LiveMapWidget> createState() => _LiveMapWidgetState();
}

class _LiveMapWidgetState extends State<LiveMapWidget> {
  late final LiveMapStore _store;
  late final RouteManager _routeManager;
  late final MapboxAdapter _adapter;
  late final MapboxRenderer _renderer;
  late final LiveMapController _controller;
  StreamSubscription<ModelSelected>? _modelSelectedSub;
  Brightness _brightness = Brightness.light;

  // Camera-change throttle — keeps Redux free from 60-fps churn.
  // Scale updates still reach the GPU every frame via _renderer.onZoomChanged.
  static const double _zoomDispatchThreshold = 0.01;
  static const int _minDispatchIntervalMs = 16;
  final Stopwatch _cameraThrottle = Stopwatch()..start();
  int _lastDispatchMs = -_minDispatchIntervalMs; // ensures first event fires
  double _lastDispatchedZoom = double.infinity;

  @override
  void initState() {
    super.initState();

    final initialState = LiveMapState.fromConfig(widget.config);
    _store = LiveMapStore(initialState);

    _routeManager = RouteManager();

    InteractionHandler.register(_store);
    CameraHandler.register(_store);
    ModelHandler.register(_store);
    TrackingHandler.register(_store, _routeManager);

    _adapter = MapboxAdapter();
    _renderer = MapboxRenderer(_store, _adapter, _routeManager);

    _controller = widget.controller ?? LiveMapController();
    _controller.bind(_store);

    if (widget.onModelTap != null) {
      _modelSelectedSub = _store.eventBus.on<ModelSelected>((event) {
        widget.onModelTap?.call(event.model);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = MediaQuery.platformBrightnessOf(context);
    if (brightness != _brightness) {
      _brightness = brightness;
      _adapter.loadStyle(_styleUri);
    }
  }

  String get _styleUri => _brightness == Brightness.dark
      ? MapboxStyles.DARK
      : MapboxStyles.LIGHT;

  @override
  Widget build(BuildContext context) {
    final state = _store.state;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth == 0 || constraints.maxHeight == 0) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: MapWidget(
            key: const ValueKey('live-map'),
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: Position(
                  state.camera.longitude,
                  state.camera.latitude,
                ),
              ),
              zoom: state.camera.zoom,
              pitch: state.camera.pitch,
            ),
            styleUri: _styleUri,
            onMapCreated: _onMapCreated,
            onTapListener: _onMapTap,
            onStyleLoadedListener: _onStyleLoaded,
            onCameraChangeListener: _onCameraChange,
          ),
        );
      },
    );
  }

  void _onMapCreated(MapboxMap map) {
    _adapter.bind(map);
    _store.dispatch(const MapCreated());
  }

  void _onMapTap(MapContentGestureContext context) {
    final coords = context.point.coordinates;
    _store.dispatch(MapTapped(
      latitude: coords.lat.toDouble(),
      longitude: coords.lng.toDouble(),
    ));
  }

  void _onCameraChange(CameraChangedEventData data) {
    final zoom = data.cameraState.zoom;

    // Always forward zoom to the renderer — zero Redux overhead, zero GC.
    _renderer.onZoomChanged(zoom);

    // Throttle Redux dispatch: skip if zoom barely changed AND the minimum
    // interval hasn't elapsed. This keeps CameraState eventually consistent
    // without generating copyWith objects at 60 fps.
    final nowMs = _cameraThrottle.elapsedMilliseconds;
    final zoomDelta = (zoom - _lastDispatchedZoom).abs();
    if (zoomDelta <= _zoomDispatchThreshold &&
        nowMs - _lastDispatchMs < _minDispatchIntervalMs) {
      return;
    }

    _lastDispatchedZoom = zoom;
    _lastDispatchMs = nowMs;
    _store.dispatch(CameraMoved(
      latitude: _store.state.camera.latitude,
      longitude: _store.state.camera.longitude,
      zoom: zoom,
    ));
  }

  void _onStyleLoaded(StyleLoadedEventData data) {
    _store.dispatch(const MapStyleLoaded());
  }

  @override
  void dispose() {
    _store.dispatch(const MapDisposed());
    _modelSelectedSub?.cancel();
    _renderer.dispose();
    _adapter.dispose();
    _store.dispose();
    super.dispose();
  }
}
