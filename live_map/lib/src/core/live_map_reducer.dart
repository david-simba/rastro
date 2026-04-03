import 'package:live_map/src/domain/types/map_types.dart';
import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/state/live_map_state.dart';

LiveMapState liveMapReducer(LiveMapState state, LiveMapEvent event) {
  return switch (event) {
    MapCreated() => state.copyWith(lifecycle: MapLifecycle.created),
    MapStyleLoaded() => state.copyWith(lifecycle: MapLifecycle.styleLoaded),
    MapDisposed() => state.copyWith(lifecycle: MapLifecycle.disposed),

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

    MapTapped() => state,
    ModelSelected(:final model) => state.copyWith(
        models: state.models.copyWith(selectedModel: () => model),
      ),
    ModelDeselected() => state.copyWith(
        models: state.models.copyWith(selectedModel: () => null),
      ),

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
      :final bearing,
    ) =>
      _updateModelPosition(state, modelId, latitude, longitude, bearing),

    DimensionModeChanged(:final dimensionMode) => state.copyWith(
        dimensionMode: dimensionMode,
        camera: state.camera.copyWith(
          pitch: dimensionMode == MapDimensionMode.threeD ? state.pitch3D : 0.0,
        ),
      ),

    // Route events are handled as side-effects by RouteManager / TrackingHandler;
    // they carry no reducer-level state change.
    RouteAssigned() => state,
    RouteUpdateNeeded() => state,
    RouteClearRequested() => state,
    CameraFitRoute() => state,
  };
}

LiveMapState _updateModelPosition(
  LiveMapState state,
  String modelId,
  double latitude,
  double longitude,
  double bearing,
) {
  final updatedModels = state.models.models.map((m) {
    if (m.id == modelId) {
      return MapModel(
        id: m.id,
        latitude: latitude,
        longitude: longitude,
        bearing: bearing,
        routeId: m.routeId,
        isOnRoute: m.isOnRoute,
        metadata: m.metadata,
      );
    }
    return m;
  }).toList();

  return state.copyWith(
    models: state.models.copyWith(models: updatedModels),
  );
}
