import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:live_map/src/config/live_map_config.dart';
import 'package:live_map/src/controller/live_map_controller.dart';
import 'package:live_map/src/mapbox/mapbox_layer_service.dart';
import 'package:live_map/src/mapbox/mapbox_model_loader.dart';

class LiveMapWidget extends StatefulWidget {
  final LiveMapConfig config;
  final LiveMapController? controller;

  const LiveMapWidget({
    required this.config,
    this.controller,
    super.key,
  });

  static void setAccessToken(String token) {
    MapboxOptions.setAccessToken(token);
  }

  @override
  State<LiveMapWidget> createState() => _LiveMapWidgetState();
}

class _LiveMapWidgetState extends State<LiveMapWidget> {
  MapboxMap? _mapboxMap;
  late final LiveMapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? LiveMapController();
  }

  double get _pitch {
    return widget.config.dimensionMode == MapDimensionMode.threeD ? 65.0 : 0.0;
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
    final ds = widget.config.dataSource;
    return MapWidget(
      key: const ValueKey('live-map'),
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(
          ds.cameraPosition.longitude,
          ds.cameraPosition.latitude,
        )),
        zoom: ds.zoom,
        pitch: _pitch,
      ),
      styleUri: _styleUri,
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: _onStyleLoaded,
    );
  }

  void _onMapCreated(MapboxMap map) {
    _mapboxMap = map;
    _controller.bind(map);
  }

  void _onStyleLoaded(StyleLoadedEventData data) async {
    final map = _mapboxMap;
    if (map == null) return;

    final modelConfig = widget.config.modelConfig;
    if (modelConfig == null) return;

    final ds = widget.config.dataSource;
    final modelUrl = await MapboxModelLoader.loadToTempFile(modelConfig.modelPath);
    final layerService = MapboxLayerService(map);

    await layerService.addModelLayer(
      modelId: 'model',
      modelUrl: modelUrl,
      position: Position(
        ds.modelPosition.longitude,
        ds.modelPosition.latitude,
      ),
      scale: modelConfig.scale,
      rotation: modelConfig.rotation,
    );
  }
}
