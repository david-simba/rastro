import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:live_map/src/config/live_map_config.dart';
import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/state/live_map_state.dart';
import 'package:live_map/src/core/live_map_store.dart';
import 'package:live_map/src/data/live_map_data_source.dart';
import 'package:live_map/src/infrastructure/mapbox_adapter.dart';
import 'package:live_map/src/infrastructure/mapbox_renderer.dart';
import 'package:live_map/src/modules/camera/camera_handler.dart';
import 'package:live_map/src/modules/interaction/interaction_handler.dart';
import 'package:live_map/src/modules/model/model_handler.dart';
import 'package:live_map/src/modules/tracking/tracking_handler.dart';
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
  late final MapboxAdapter _adapter;
  late final MapboxRenderer _renderer;
  late final LiveMapController _controller;
  StreamSubscription<ModelSelected>? _modelSelectedSub;

  @override
  void initState() {
    super.initState();

    final initialState = LiveMapState.fromConfig(widget.config);
    _store = LiveMapStore(initialState);

    // Register modules
    InteractionHandler.register(_store);
    CameraHandler.register(_store);
    ModelHandler.register(_store);
    TrackingHandler.register(_store);

    // Infrastructure
    _adapter = MapboxAdapter();
    _renderer = MapboxRenderer(_store, _adapter);

    // Controller
    _controller = widget.controller ?? LiveMapController();
    _controller.bind(_store);

    // Bridge ModelSelected events to the onModelTap callback
    if (widget.onModelTap != null) {
      _modelSelectedSub = _store.eventBus.on<ModelSelected>((event) {
        widget.onModelTap?.call(event.model);
      });
    }
  }

  String get _styleUri {
    switch (widget.config.styleMode) {
      case MapStyleMode.day:
        return MapboxStyles.STANDARD;
      case MapStyleMode.night:
        return MapboxStyles.DARK;
    }
  }

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
