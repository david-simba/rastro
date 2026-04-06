import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:live_map/src/domain/types/map_types.dart';

/// Pure in-memory route store and geometry utilities.
///
/// Stores route polylines keyed by [modelId] and exposes helper methods for
/// proximity checks and deviation detection. Has no external dependencies —
/// all reads and writes stay in memory.
class RouteManager {
  final Map<String, List<LatLng>> _routes = {};
  void saveRoute(String modelId, List<LatLng> routePoints) {
    _routes[modelId] = List.unmodifiable(routePoints);
    debugPrint('RouteManager: saved ${routePoints.length} pts for $modelId');
  }

  List<LatLng>? getRoute(String modelId) => _routes[modelId];
  Map<String, List<LatLng>> get allRoutes => Map.unmodifiable(_routes);

  void clearRoute(String modelId) {
    _routes.remove(modelId);
    debugPrint('RouteManager: cleared route for $modelId');
  }

  /// Returns `true` if [position] is within [tolerance] (degrees) of any
  /// point in [routePoints].
  bool isOnRoute(
    LatLng position,
    List<LatLng> routePoints, {
    double tolerance = 0.0005,
  }) {
    if (routePoints.isEmpty) return false;
    final closest = getClosestPointOnRoute(position, routePoints);
    if (closest == null) return false;
    return _euclidean(position, closest) <= tolerance;
  }

  /// Returns `true` if [position] has drifted more than [threshold] (degrees)
  /// from [expectedPosition].
  bool detectDeviation(
    LatLng position,
    LatLng expectedPosition, {
    double threshold = 0.0005,
  }) {
    return _euclidean(position, expectedPosition) > threshold;
  }

  /// Returns the point in [routePoints] closest to [position], or `null` if
  /// [routePoints] is empty.
  LatLng? getClosestPointOnRoute(LatLng position, List<LatLng> routePoints) {
    if (routePoints.isEmpty) return null;

    LatLng? closest;
    double minDist = double.infinity;

    for (final point in routePoints) {
      final d = _euclidean(position, point);
      if (d < minDist) {
        minDist = d;
        closest = point;
      }
    }

    return closest;
  }

  double _euclidean(LatLng a, LatLng b) {
    final dLat = a.lat - b.lat;
    final dLng = a.lng - b.lng;
    return sqrt(dLat * dLat + dLng * dLng);
  }
}
