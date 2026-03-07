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
  final List<MapModel> waypoints;

  const LiveMapState({
    required this.lifecycle,
    required this.camera,
    required this.models,
    required this.tracking,
    required this.dimensionMode,
    this.modelConfig,
    this.waypoints = const [],
  });

  factory LiveMapState.fromConfig(LiveMapConfig config) {
    return LiveMapState(
      lifecycle: MapLifecycle.idle,
      camera: CameraState(
        latitude: config.initialLatitude,
        longitude: config.initialLongitude,
        zoom: config.initialZoom,
        pitch: config.dimensionMode == MapDimensionMode.threeD ? 65.0 : 0.0,
      ),
      models: ModelsState(models: config.initialModels),
      tracking: const TrackingState(),
      dimensionMode: config.dimensionMode,
      modelConfig: config.modelConfig,
      waypoints: config.waypoints,
    );
  }

  LiveMapState copyWith({
    MapLifecycle? lifecycle,
    CameraState? camera,
    ModelsState? models,
    TrackingState? tracking,
    MapDimensionMode? dimensionMode,
    ModelConfig? Function()? modelConfig,
    List<MapModel>? waypoints,
  }) {
    return LiveMapState(
      lifecycle: lifecycle ?? this.lifecycle,
      camera: camera ?? this.camera,
      models: models ?? this.models,
      tracking: tracking ?? this.tracking,
      dimensionMode: dimensionMode ?? this.dimensionMode,
      modelConfig: modelConfig != null ? modelConfig() : this.modelConfig,
      waypoints: waypoints ?? this.waypoints,
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
          modelConfig == other.modelConfig &&
          waypoints == other.waypoints;

  @override
  int get hashCode => Object.hash(
        lifecycle,
        camera,
        models,
        tracking,
        dimensionMode,
        modelConfig,
        Object.hashAll(waypoints),
      );
}
