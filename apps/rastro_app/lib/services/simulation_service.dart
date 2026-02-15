import 'dart:async';
import 'dart:math' as math;

import 'package:live_map/live_map.dart';

class MovementSimulationService {
  final LiveMapController _controller;
  Timer? _timer;

  static const List<MapModel> waypoints = [
    MapModel(id: 'wp-1', latitude: -0.1987990, longitude: -78.4982523),
    MapModel(id: 'wp-2', latitude: -0.1978090, longitude: -78.5000000),
    MapModel(id: 'wp-3', latitude: -0.1966900, longitude: -78.5020900),
    MapModel(id: 'wp-4', latitude: -0.1996900, longitude: -78.5020900),
  ];

  int _currentIndex = 0;
  late double _lat;
  late double _lng;

  static const double _stepSize = 0.00003;

  MovementSimulationService(this._controller);

  void start() {
    _currentIndex = 0;
    _lat = waypoints[0].latitude;
    _lng = waypoints[0].longitude;

    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      _tick();
    });
  }

  void _tick() {
    final targetIndex = (_currentIndex + 1) % waypoints.length;
    final target = waypoints[targetIndex];

    final dLat = target.latitude - _lat;
    final dLng = target.longitude - _lng;
    final distance = math.sqrt(dLat * dLat + dLng * dLng);

    final bearing = _calculateBearing(
      _lat, _lng,
      target.latitude, target.longitude,
    );

    if (distance < _stepSize) {
      _currentIndex = targetIndex;
      _lat = target.latitude;
      _lng = target.longitude;
    } else {
      _lat += (dLat / distance) * _stepSize;
      _lng += (dLng / distance) * _stepSize;
    }

    _controller.dispatch(TrackingPositionReceived(
      modelId: 'bus-1',
      latitude: _lat,
      longitude: _lng,
      bearing: bearing,
    ));

    _controller.dispatch(CameraMoveTo(
      latitude: _lat,
      longitude: _lng,
      bearing: bearing,
    ));
  }

  /// Calculates the forward azimuth (bearing) in degrees [0, 360)
  /// from (startLat, startLng) to (endLat, endLng).
  static double _calculateBearing(
    double startLat, double startLng,
    double endLat, double endLng,
  ) {
    final lat1 = _toRadians(startLat);
    final lat2 = _toRadians(endLat);
    final dLon = _toRadians(endLng - startLng);

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final radians = math.atan2(y, x);
    return (_toDegrees(radians) + 360) % 360;
  }

  static double _toRadians(double deg) => deg * math.pi / 180;
  static double _toDegrees(double rad) => rad * 180 / math.pi;

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
