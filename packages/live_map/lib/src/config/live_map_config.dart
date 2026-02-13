import 'package:live_map/src/data/live_map_data_source.dart';

enum MapStyleMode { day, night }

enum MapDimensionMode { twoD, threeD }

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
  final LiveMapDataSource dataSource;

  const LiveMapConfig({
    required this.styleMode,
    required this.dimensionMode,
    this.modelConfig,
    required this.dataSource,
  });
}
