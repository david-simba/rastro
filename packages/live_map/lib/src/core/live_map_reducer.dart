import 'package:live_map/src/config/live_map_config.dart';
import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/state/live_map_state.dart';
import 'package:live_map/src/data/live_map_data_source.dart';

LiveMapState liveMapReducer(LiveMapState state, LiveMapEvent event) {
  return switch (event) {
    // Lifecycle
    MapCreated() => state.copyWith(lifecycle: MapLifecycle.created),
    MapStyleLoaded() => state.copyWith(lifecycle: MapLifecycle.styleLoaded),
    MapDisposed() => state.copyWith(lifecycle: MapLifecycle.disposed),

    // Camera
    CameraFlyTo(:final latitude, :final longitude, :final zoom) =>
      state.copyWith(
        camera: state.camera.copyWith(
          latitude: latitude,
          longitude: longitude,
          zoom: zoom,
        ),
      ),
    CameraMoveTo(:final latitude, :final longitude, :final zoom) =>
      state.copyWith(
        camera: state.camera.copyWith(
          latitude: latitude,
          longitude: longitude,
          zoom: zoom,
        ),
      ),
    CameraMoved(:final latitude, :final longitude, :final zoom) =>
      state.copyWith(
        camera: state.camera.copyWith(
          latitude: latitude,
          longitude: longitude,
          zoom: zoom,
        ),
      ),

    // Models
    ModelsUpdated(:final models) => state.copyWith(
        models: state.models.copyWith(models: models),
      ),
    ModelLayerRequested() => state.copyWith(
        models: state.models.copyWith(layerStatus: ModelLayerStatus.loading),
      ),
    ModelLayerAdded() => state.copyWith(
        models: state.models.copyWith(layerStatus: ModelLayerStatus.loaded),
      ),
    ModelLayerFailed(:final error) => state.copyWith(
        models: state.models.copyWith(
          layerStatus: ModelLayerStatus.failed,
          layerError: () => error,
        ),
      ),

    // Interaction — MapTapped is handled by middleware, reducer is a no-op
    MapTapped() => state,
    ModelSelected(:final model) => state.copyWith(
        models: state.models.copyWith(selectedModel: () => model),
      ),
    ModelDeselected() => state.copyWith(
        models: state.models.copyWith(selectedModel: () => null),
      ),

    // Tracking
    TrackingStarted() => state.copyWith(
        tracking: state.tracking.copyWith(status: TrackingStatus.active),
      ),
    TrackingStopped() => state.copyWith(
        tracking: state.tracking.copyWith(status: TrackingStatus.inactive),
      ),
    TrackingPositionReceived(
      :final modelId,
      :final latitude,
      :final longitude,
    ) =>
      _updateModelPosition(state, modelId, latitude, longitude),

    // Config
    StyleModeChanged(:final styleMode) =>
      state.copyWith(styleMode: styleMode),
    DimensionModeChanged(:final dimensionMode) => state.copyWith(
        dimensionMode: dimensionMode,
        camera: state.camera.copyWith(
          pitch: dimensionMode == MapDimensionMode.threeD ? 65.0 : 0.0,
        ),
      ),
  };
}

LiveMapState _updateModelPosition(
  LiveMapState state,
  String modelId,
  double latitude,
  double longitude,
) {
  final updatedModels = state.models.models.map((m) {
    if (m.id == modelId) {
      return MapModel(id: m.id, latitude: latitude, longitude: longitude);
    }
    return m;
  }).toList();

  return state.copyWith(
    models: state.models.copyWith(models: updatedModels),
  );
}
