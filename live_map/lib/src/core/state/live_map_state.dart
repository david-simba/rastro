import 'package:live_map/src/domain/types/map_types.dart';
import 'package:live_map/src/domain/entities/live_map_config.dart';

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
  final MapDimensionMode dimensionMode;
  final ModelConfig? modelConfig;

  /// Pitch applied when [dimensionMode] is [MapDimensionMode.threeD].
  /// Set once from [LiveMapConfig.pitch3D] and never changes at runtime.
  final double pitch3D;

  const LiveMapState({
    required this.lifecycle,
    required this.camera,
    required this.models,
    required this.tracking,
    required this.dimensionMode,
    this.modelConfig,
    this.pitch3D = 50.0,
  });

  factory LiveMapState.fromConfig(LiveMapConfig config) {
    return LiveMapState(
      lifecycle: MapLifecycle.idle,
      camera: CameraState(
        latitude: config.initialLatitude,
        longitude: config.initialLongitude,
        zoom: config.initialZoom,
        pitch: config.dimensionMode == MapDimensionMode.threeD ? config.pitch3D : 0.0,
      ),
      models: ModelsState(models: config.initialModels),
      tracking: const TrackingState(),
      dimensionMode: config.dimensionMode,
      modelConfig: config.modelConfig,
      pitch3D: config.pitch3D,
    );
  }

  LiveMapState copyWith({
    MapLifecycle? lifecycle,
    CameraState? camera,
    ModelsState? models,
    TrackingState? tracking,
    MapDimensionMode? dimensionMode,
    ModelConfig? Function()? modelConfig,
  }) {
    return LiveMapState(
      lifecycle: lifecycle ?? this.lifecycle,
      camera: camera ?? this.camera,
      models: models ?? this.models,
      tracking: tracking ?? this.tracking,
      dimensionMode: dimensionMode ?? this.dimensionMode,
      modelConfig: modelConfig != null ? modelConfig() : this.modelConfig,
      pitch3D: pitch3D,
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
          dimensionMode == other.dimensionMode &&
          modelConfig == other.modelConfig;

  @override
  int get hashCode => Object.hash(
        lifecycle,
        camera,
        models,
        tracking,
        dimensionMode,
        modelConfig,
      );
}
