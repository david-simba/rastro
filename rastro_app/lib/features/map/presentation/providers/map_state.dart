import 'package:live_map/live_map.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';

enum MapMode { idle, routeSelected, trackingBus }

class MapState {
  final MapMode mode;
  final MapDimensionMode dimensionMode;
  final LatLng? userPosition;
  final RouteEntity? selectedRoute;
  final MapModel? trackedModel;

  const MapState({
    required this.mode,
    required this.dimensionMode,
    this.userPosition,
    this.selectedRoute,
    this.trackedModel,
  });

  factory MapState.initial() => const MapState(
    mode: MapMode.idle,
    dimensionMode: MapDimensionMode.twoD,
  );

  MapState copyWith({
    MapMode? mode,
    MapDimensionMode? dimensionMode,
    LatLng? Function()? userPosition,
    RouteEntity? Function()? selectedRoute,
    MapModel? Function()? trackedModel,
  }) {
    return MapState(
      mode: mode ?? this.mode,
      dimensionMode: dimensionMode ?? this.dimensionMode,
      userPosition: userPosition != null ? userPosition() : this.userPosition,
      selectedRoute: selectedRoute != null ? selectedRoute() : this.selectedRoute,
      trackedModel: trackedModel != null ? trackedModel() : this.trackedModel,
    );
  }
}
