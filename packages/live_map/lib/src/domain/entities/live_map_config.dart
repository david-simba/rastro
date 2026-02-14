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
  final MapStyleMode styleMode;
  final MapDimensionMode dimensionMode;
  final ModelConfig? modelConfig;
  final double initialLatitude;
  final double initialLongitude;
  final double initialZoom;
  final List<MapModel> initialModels;

  const LiveMapConfig({
    required this.styleMode,
    required this.dimensionMode,
    this.modelConfig,
    required this.initialLatitude,
    required this.initialLongitude,
    this.initialZoom = 15.0,
    this.initialModels = const [],
  });
}
