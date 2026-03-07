import 'package:live_map/src/domain/types/map_types.dart';

class ModelConfig {
  final String modelPath;
  final List<double> scale;
  final List<double> rotation;

  const ModelConfig({
    required this.modelPath,
    required this.scale,
    required this.rotation,
  });
}

class LiveMapConfig {
  final MapDimensionMode dimensionMode;
  final ModelConfig? modelConfig;
  final double initialLatitude;
  final double initialLongitude;
  final double initialZoom;
  final List<MapModel> initialModels;
  final List<MapModel> waypoints;

  const LiveMapConfig({
    required this.dimensionMode,
    this.modelConfig,
    required this.initialLatitude,
    required this.initialLongitude,
    this.initialZoom = 15.0,
    this.initialModels = const [],
    this.waypoints = const [],
  });
}
