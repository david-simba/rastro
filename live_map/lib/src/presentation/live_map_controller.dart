import 'package:live_map/src/domain/types/map_types.dart';
import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/state/live_map_state.dart';
import 'package:live_map/src/core/live_map_store.dart';

class LiveMapController {
  LiveMapStore? _store;
  List<LiveMapEvent> get eventHistory => _store?.eventHistory ?? [];

  bool get isReady =>
      _store != null && _store!.state.lifecycle != MapLifecycle.idle;

  void bind(LiveMapStore store) {
    _store = store;
  }

  Future<void> flyTo({
    required double latitude,
    required double longitude,
    double? zoom,
  }) async {
    dispatch(CameraFlyTo(latitude: latitude, longitude: longitude, zoom: zoom));
  }

  LiveMapState get state {
    assert(_store != null, 'Controller not bound to store');
    return _store!.state;
  }

  Stream<LiveMapState> get stateStream {
    assert(_store != null, 'Controller not bound to store');
    return _store!.stateStream;
  }

  Stream<T> select<T>(T Function(LiveMapState) selector) {
    assert(_store != null, 'Controller not bound to store');
    return _store!.select(selector);
  }

  void dispatch(LiveMapEvent event) {
    _store?.dispatch(event);
  }

  void toggleDimensionMode(MapDimensionMode mode) {
    dispatch(DimensionModeChanged(dimensionMode: mode));
  }

  /// Assigns a pre-fetched route to [modelId] and draws it on the map.
  ///
  /// Use [DirectionsService.fetchRoute] to obtain [routePoints] from the
  /// Mapbox Directions API before calling this method.
  void assignRoute(String modelId, List<LatLng> routePoints) {
    dispatch(RouteAssigned(modelId: modelId, routePoints: routePoints));
  }

  /// Removes the route line for [modelId] from the map.
  void clearRoute(String modelId) {
    dispatch(RouteClearRequested(modelId: modelId));
  }
}
