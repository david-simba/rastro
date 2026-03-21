import 'dart:async';
import 'dart:math' as math;

import 'package:rastro/core/utils/geo_utils.dart';
import 'package:rastro/features/map/domain/entities/vehicle_position.dart';

class SimulationDatasource {
  static const List<VehiclePosition> routeWaypoints = [
    VehiclePosition(id: 'wp-1', latitude: -0.1987990, longitude: -78.4982523),
    VehiclePosition(id: 'wp-2', latitude: -0.1978090, longitude: -78.5000000),
    VehiclePosition(id: 'wp-3', latitude: -0.1966900, longitude: -78.5020900),
    VehiclePosition(id: 'wp-4', latitude: -0.1996900, longitude: -78.5020900),
  ];

  // ~0.0005° por tick ≈ 55 m cada 5 s ≈ 40 km/h
  static const double _stepSize = 0.0005;
  static const String vehicleId = 'bus-1';

  final _controller = StreamController<VehiclePosition>.broadcast();
  Timer? _timer;
  bool _isDisposed = false;
  int _currentIndex = 0;
  late double _lat;
  late double _lng;

  Stream<VehiclePosition> get positionStream => _controller.stream;

  void start() {
    if (_isDisposed) return;
    if (_timer != null) return;

    _currentIndex = 0;
    _lat = routeWaypoints[0].latitude;
    _lng = routeWaypoints[0].longitude;

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _tick();
    });
  }

  void _tick() {
    if (_isDisposed) return;

    final targetIndex = (_currentIndex + 1) % routeWaypoints.length;
    final target = routeWaypoints[targetIndex];

    final dLat = target.latitude - _lat;
    final dLng = target.longitude - _lng;
    final distance = math.sqrt(dLat * dLat + dLng * dLng);

    final bearing = GeoUtils.calculateBearing(
      _lat,
      _lng,
      target.latitude,
      target.longitude,
    );

    if (distance < _stepSize) {
      _currentIndex = targetIndex;
      _lat = target.latitude;
      _lng = target.longitude;
    } else {
      _lat += (dLat / distance) * _stepSize;
      _lng += (dLng / distance) * _stepSize;
    }

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
