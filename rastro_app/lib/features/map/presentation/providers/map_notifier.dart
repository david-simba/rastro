import 'package:polyline_codec/polyline_codec.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';
import 'package:rastro/features/map/data/services/user_location_service.dart';
import 'package:rastro/features/map/presentation/providers/map_state.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';

const _kFallbackLat = -0.2295;
const _kFallbackLng = -78.5243;

final mapNotifierProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
);

class MapNotifier extends Notifier<MapState> {
  late final LiveMapController _controller;
  final _locationService = UserLocationService();

  @override
  MapState build() {
    _controller = LiveMapController();
    _initUserLocation();
    return MapState.initial();
  }

  LiveMapController get controller => _controller;

  LiveMapConfig get mapConfig => LiveMapConfig(
    initialLatitude: state.userPosition?.lat ?? _kFallbackLat,
    initialLongitude: state.userPosition?.lng ?? _kFallbackLng,
    dimensionMode: MapDimensionMode.twoD,
    showUserLocation: true,
  );

  Future<void> _initUserLocation() async {
    final position = await _locationService.getCurrentPosition();
    state = state.copyWith(
      userPosition: () => position != null
          ? LatLng(lat: position.latitude, lng: position.longitude)
          : const LatLng(lat: _kFallbackLat, lng: _kFallbackLng),
    );
  }

  Future<void> centerOnUser() async {
    final position = await _locationService.getCurrentPosition();
    if (position == null) return;
    if (_controller.isReady) {
      _controller.flyTo(latitude: position.latitude, longitude: position.longitude, zoom: 15);
    }
  }

  Future<void> loadRoute(RouteEntity route) async {
    final coords = PolylineCodec.decode(route.geometry, precision: 6);
    if (coords.isEmpty) return;

    final points = coords.map((c) => LatLng(lat: c[0].toDouble(), lng: c[1].toDouble())).toList();
    await Future.delayed(const Duration(milliseconds: 300));

    if (_controller.isReady) {
      _controller.assignRoute(route.id, points);
      _controller.fitRoute(points);
    }
  }

  void toggleDimension() {
    final next = state.dimensionMode == MapDimensionMode.twoD
        ? MapDimensionMode.threeD
        : MapDimensionMode.twoD;
    state = state.copyWith(dimensionMode: next);
    _controller.toggleDimensionMode(next);
  }
}
