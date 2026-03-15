import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/live_map_store.dart';
import 'package:live_map/src/infrastructure/services/route_manager.dart';

class TrackingHandler {
  /// Registers a middleware that intercepts [RouteAssigned] events and persists
  /// the route polyline into [routeManager] before any listener sees the event.
  ///
  /// [RouteRequested] is not handled here — the consumer listens to the event
  /// bus directly and responds with [RouteAssigned] after calling
  /// [DirectionsService.getRoute].
  static void register(LiveMapStore store, RouteManager routeManager) {
    store.addMiddleware((event, dispatch, getState) {
      if (event is RouteAssigned) {
        routeManager.saveRoute(event.modelId, event.routePoints);
      }
    });
  }
}
