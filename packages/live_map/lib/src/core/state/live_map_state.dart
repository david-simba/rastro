import 'package:live_map/src/config/live_map_config.dart';
import 'package:live_map/src/data/live_map_data_source.dart';

import 'package:live_map/src/core/state/camera_state.dart';
import 'package:live_map/src/core/state/lifecycle_state.dart';
import 'package:live_map/src/core/state/models_state.dart';
import 'package:live_map/src/core/state/tracking_state.dart';

export 'package:live_map/src/core/state/camera_state.dart';
export 'package:live_map/src/core/state/lifecycle_state.dart';
export 'package:live_map/src/core/state/models_state.dart';
export 'package:live_map/src/core/state/tracking_state.dart';

class LiveMapState {
  final MapLifecycle lifecycle;
  final CameraState camera;
  final ModelsState models;
  final TrackingState tracking;
  final MapStyleMode styleMode;
  final MapDimensionMode dimensionMode;
  final ModelConfig? modelConfig;
  final LiveMapDataSource dataSource;

  const LiveMapState({
    required this.lifecycle,
    required this.camera,
    required this.models,
    required this.tracking,
    required this.styleMode,
    required this.dimensionMode,
    this.modelConfig,
    required this.dataSource,
  });

  factory LiveMapState.fromConfig(LiveMapConfig config) {
    final ds = config.dataSource;
    return LiveMapState(
      lifecycle: MapLifecycle.idle,
      camera: CameraState(
        latitude: ds.cameraPosition.latitude,
        longitude: ds.cameraPosition.longitude,
        zoom: ds.zoom,
        pitch: config.dimensionMode == MapDimensionMode.threeD ? 65.0 : 0.0,
      ),
      models: ModelsState(models: ds.models),
      tracking: const TrackingState(),
      styleMode: config.styleMode,
      dimensionMode: config.dimensionMode,
      modelConfig: config.modelConfig,
      dataSource: ds,
    );
  }

  LiveMapState copyWith({
    MapLifecycle? lifecycle,
    CameraState? camera,
    ModelsState? models,
    TrackingState? tracking,
    MapStyleMode? styleMode,
    MapDimensionMode? dimensionMode,
    ModelConfig? Function()? modelConfig,
    LiveMapDataSource? dataSource,
  }) {
    return LiveMapState(
      lifecycle: lifecycle ?? this.lifecycle,
      camera: camera ?? this.camera,
      models: models ?? this.models,
      tracking: tracking ?? this.tracking,
      styleMode: styleMode ?? this.styleMode,
      dimensionMode: dimensionMode ?? this.dimensionMode,
      modelConfig: modelConfig != null ? modelConfig() : this.modelConfig,
      dataSource: dataSource ?? this.dataSource,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiveMapState &&
          lifecycle == other.lifecycle &&
          camera == other.camera &&
          models == other.models &&
          tracking == other.tracking &&
          styleMode == other.styleMode &&
          dimensionMode == other.dimensionMode &&
          modelConfig == other.modelConfig &&
          dataSource == other.dataSource;

  @override
  int get hashCode => Object.hash(
        lifecycle,
        camera,
        models,
        tracking,
        styleMode,
        dimensionMode,
        modelConfig,
        dataSource,
      );
}
