import 'package:live_map/src/domain/types/map_types.dart';

sealed class LiveMapEvent {
  const LiveMapEvent();
}

final class MapCreated extends LiveMapEvent {
  const MapCreated();
}

final class MapStyleLoaded extends LiveMapEvent {
  const MapStyleLoaded();
}

final class MapDisposed extends LiveMapEvent {
  const MapDisposed();
}

final class CameraFlyTo extends LiveMapEvent {
  final double latitude;
  final double longitude;
  final double? zoom;

  const CameraFlyTo({
    required this.latitude,
    required this.longitude,
    this.zoom,
  });
}

final class CameraMoveTo extends LiveMapEvent {
  final double latitude;
  final double longitude;
  final double? zoom;
  final double? bearing;

  const CameraMoveTo({
    required this.latitude,
    required this.longitude,
    this.zoom,
    this.bearing,
  });
}

final class CameraMoved extends LiveMapEvent {
  final double latitude;
  final double longitude;
  final double zoom;

  const CameraMoved({
    required this.latitude,
    required this.longitude,
    required this.zoom,
  });
}

final class ModelsUpdated extends LiveMapEvent {
  final List<MapModel> models;

  const ModelsUpdated({required this.models});
}

final class ModelLayerRequested extends LiveMapEvent {
  const ModelLayerRequested();
}

final class ModelLayerAdded extends LiveMapEvent {
  const ModelLayerAdded();
}

final class ModelLayerFailed extends LiveMapEvent {
  final String error;

  const ModelLayerFailed({required this.error});
}

final class MapTapped extends LiveMapEvent {
  final double latitude;
  final double longitude;

  const MapTapped({required this.latitude, required this.longitude});
}

final class ModelSelected extends LiveMapEvent {
  final MapModel model;

  const ModelSelected({required this.model});
}

final class ModelDeselected extends LiveMapEvent {
  const ModelDeselected();
}

final class TrackingStarted extends LiveMapEvent {
  const TrackingStarted();
}

final class TrackingStopped extends LiveMapEvent {
  const TrackingStopped();
}

final class TrackingPositionReceived extends LiveMapEvent {
  final String modelId;
  final double latitude;
  final double longitude;
  final double bearing;

  const TrackingPositionReceived({
    required this.modelId,
    required this.latitude,
    required this.longitude,
    this.bearing = 0.0,
  });
}

final class DimensionModeChanged extends LiveMapEvent {
  final MapDimensionMode dimensionMode;

  const DimensionModeChanged({required this.dimensionMode});
}

/// Dispatched by the consumer when the backend provides route points for a
/// model. [RouteManager] stores the polyline; the renderer verifies each
/// incoming position against it.
final class RouteAssigned extends LiveMapEvent {
  final String modelId;
  final List<LatLng> routePoints;

  const RouteAssigned({required this.modelId, required this.routePoints});
}

/// Emitted by the renderer when a model drifts outside the deviation threshold.
/// The consumer listens and dispatches a fresh [RouteAssigned] when ready.
final class RouteUpdateNeeded extends LiveMapEvent {
  final String modelId;
  final LatLng currentPosition;

  const RouteUpdateNeeded({
    required this.modelId,
    required this.currentPosition,
  });
}

/// Dispatched by the consumer to remove a previously drawn route line from
/// the map and clear it from [RouteManager].
final class RouteClearRequested extends LiveMapEvent {
  final String modelId;

  const RouteClearRequested({required this.modelId});
}
