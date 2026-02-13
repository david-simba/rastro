import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:live_map/src/config/live_map_config.dart';
import 'package:live_map/src/controller/live_map_controller.dart';
import 'package:live_map/src/data/live_map_data_source.dart';
import 'package:live_map/src/mapbox/mapbox_layer_service.dart';
import 'package:live_map/src/mapbox/mapbox_model_loader.dart';

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
              center: Point(coordinates: Position(
                ds.cameraPosition.longitude,
                ds.cameraPosition.latitude,
              )),
              zoom: ds.zoom,
              pitch: _pitch,
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
    _mapboxMap = map;
    _controller.bind(map);
  }

  void _onMapTap(MapContentGestureContext context) {
    final coords = context.point.coordinates;
    _handleModelTap(coords.lat.toDouble(), coords.lng.toDouble());
  }

  void _handleModelTap(double tapLat, double tapLng) {
    final model = widget.config.dataSource.models.firstWhereOrNull(
      (m) => _isNear(tapLat, tapLng, m.latitude, m.longitude),
    );
    if (model == null) return;
    widget.onModelTap?.call(model);
  }

  static const _threshold = 0.00015;

  static bool _isNear(double lat1, double lng1, double lat2, double lng2) {
    return (lat1 - lat2).abs() < _threshold &&
           (lng1 - lng2).abs() < _threshold;
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
