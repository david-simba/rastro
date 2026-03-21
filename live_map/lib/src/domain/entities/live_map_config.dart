import 'package:live_map/src/domain/types/map_types.dart';
import 'package:live_map/src/domain/entities/model_config.dart';

export 'package:live_map/src/domain/entities/zoom_scale_config.dart';
export 'package:live_map/src/domain/entities/model_config.dart';

class LiveMapConfig {
  final MapDimensionMode dimensionMode;
  final ModelConfig? modelConfig;
  final double initialLatitude;
  final double initialLongitude;
  final double initialZoom;
  final List<MapModel> initialModels;
  final List<MapModel> waypoints;

  /// Camera pitch (degrees) applied when [dimensionMode] is [MapDimensionMode.threeD].
  final double pitch3D;

  const LiveMapConfig({
    required this.dimensionMode,
    this.modelConfig,
    required this.initialLatitude,
    required this.initialLongitude,
    this.initialZoom = 15.0,
    this.initialModels = const [],
    this.waypoints = const [],
    this.pitch3D = 50.0,
  });
}
