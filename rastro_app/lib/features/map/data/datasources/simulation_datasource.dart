import 'dart:async';
import 'dart:math' as math;

import 'package:rastro/core/utils/geo_utils.dart';
import 'package:rastro/features/map/domain/entities/vehicle_position.dart';

class SimulationDatasource {
  /// Hard-coded stops used to call the Directions API (A → B → C → D) and as
  /// the fallback route if [setRoute] is never called.
  static const List<VehiclePosition> routeWaypoints = [
    VehiclePosition(id: 'wp-1', latitude: -0.209985, longitude: -78.493151),
    VehiclePosition(id: 'wp-2', latitude: -0.204986, longitude: -78.485352),
    VehiclePosition(id: 'wp-3', latitude: -0.203307, longitude: -78.483350),
    VehiclePosition(id: 'wp-4', latitude: -0.197131, longitude: -78.497805),
    VehiclePosition(id: 'wp-5', latitude: -0.198648, longitude: -78.498678),
    VehiclePosition(id: 'wp-6', latitude: -0.197758, longitude: -78.500051),
    VehiclePosition(id: 'wp-7', latitude: -0.196218, longitude: -78.499506),
    VehiclePosition(id: 'wp-8', latitude: -0.198164, longitude: -78.496175),
    VehiclePosition(id: 'wp-9', latitude: -0.199746, longitude: -78.496785),
    VehiclePosition(id: 'wp-10', latitude: -0.206892, longitude: -78.498844),
    VehiclePosition(id: 'wp-11', latitude: -0.210077, longitude: -78.493262),
  ];
  /// Distance (degrees) the vehicle advances per tick — ~11 m every 1 s ≈ 40 km/h.
  static const double _stepSize = 0.0001;
  static const String vehicleId = 'bus-1';

  /// Active route the bus follows. Replaced by [setRoute] once the Directions
  /// API response arrives; falls back to [routeWaypoints] otherwise.
  List<VehiclePosition> _route = routeWaypoints;

  final _controller = StreamController<VehiclePosition>.broadcast();
  Timer? _timer;
  bool _isDisposed = false;
  int _currentIndex = 0;
  late double _lat;
  late double _lng;

  Stream<VehiclePosition> get positionStream => _controller.stream;

  /// Replaces the simulation path with the road-snapped [points] returned by
  /// the Directions API. Must be called before [start].
  void setRoute(List<VehiclePosition> points) {
    assert(points.length >= 2, 'Route must have at least 2 points');
    _route = points;
  }

  void start() {
    if (_isDisposed) return;
    if (_timer != null) return;

    _currentIndex = 0;
    _lat = _route[0].latitude;
    _lng = _route[0].longitude;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _tick() {
    if (_isDisposed) return;

    // Advance exactly _stepSize along the polyline, passing through as many
    // intermediate points as needed. This prevents the bus from stalling when
    // consecutive route points are closer than _stepSize (common with the
    // dense geometry returned by the Directions API).
    double remaining = _stepSize;

    while (remaining > 0) {
      final targetIndex = (_currentIndex + 1) % _route.length;
      final target = _route[targetIndex];

      final dLat = target.latitude - _lat;
      final dLng = target.longitude - _lng;
      final dist = math.sqrt(dLat * dLat + dLng * dLng);

      if (dist <= remaining) {
        remaining -= dist;
        _currentIndex = targetIndex;
        _lat = target.latitude;
        _lng = target.longitude;
      } else {
        _lat += (dLat / dist) * remaining;
        _lng += (dLng / dist) * remaining;
        remaining = 0;
      }
    }

    // Calculate bearing toward the next point for model rotation.
    final nextIndex = (_currentIndex + 1) % _route.length;
    final next = _route[nextIndex];
    final bearing = GeoUtils.calculateBearing(_lat, _lng, next.latitude, next.longitude);

    _controller.add(VehiclePosition(
      id: vehicleId,
      latitude: _lat,
      longitude: _lng,
      bearing: bearing,
    ));
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    stop();
    _controller.close();
  }
}
