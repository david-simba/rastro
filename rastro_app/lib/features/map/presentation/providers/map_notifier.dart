import 'package:polyline_codec/polyline_codec.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';
import 'package:rastro/features/map/data/services/user_location_service.dart';
import 'package:rastro/features/map/presentation/providers/map_state.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';
import 'package:rastro/features/stops/data/datasources/stops_firebase_datasource.dart';

const _kFallbackLat = -0.2295;
const _kFallbackLng = -78.5243;

final mapNotifierProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
);

class MapNotifier extends Notifier<MapState> {
  late final LiveMapController _controller;
  final _locationService = UserLocationService();
  final _stopsDatasource = const StopsFirebaseDatasource();

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
      _controller.flyTo(
        latitude: position.latitude,
        longitude: position.longitude,
        zoom: 15,
      );
    }
  }

  Future<void> selectRoute(RouteEntity route) async {
    if (state.selectedRoute != null && _controller.isReady) {
      _controller.clearRoute(state.selectedRoute!.id);
    }

    final coords = PolylineCodec.decode(route.geometry, precision: 6);
    if (coords.isEmpty) return;

    final points = coords
      .map((c) => LatLng(lat: c[0].toDouble(), lng: c[1].toDouble()))
      .toList();

    state = state.copyWith(
      mode: MapMode.routeSelected,
      selectedRoute: () => route,
    );

    await Future.delayed(const Duration(milliseconds: 300));
    if (_controller.isReady) {
      _controller.assignRoute(route.id, points);
      _controller.fitRoute(points, bottomPadding: 410);
    }

    if (route.stops.isNotEmpty && _controller.isReady) {
      final stops = await _stopsDatasource.getStopsByIds(route.stops);
      final stopPoints = stops
          .map((s) => LatLng(lat: s.latitude, lng: s.longitude))
          .toList();
      _controller.drawStopPins(route.id, stopPoints);
    }
  }

  void clearSelection() {
    if (state.selectedRoute != null && _controller.isReady) {
      _controller.clearRoute(state.selectedRoute!.id);
      _controller.clearStopPins(state.selectedRoute!.id);
    }
    state = state.copyWith(
      mode: MapMode.idle,
      selectedRoute: () => null,
    );
    final pos = state.userPosition;
    if (pos != null && _controller.isReady) {
      _controller.flyTo(latitude: pos.lat, longitude: pos.lng, zoom: 15);
    }
  }

  void startTracking(MapModel model) {
    state = state.copyWith(
      mode: MapMode.trackingBus,
      trackedModel: () => model,
    );
  }

  void stopTracking() {
    state = state.copyWith(
      mode: MapMode.idle,
      trackedModel: () => null,
    );
  }

  void toggleDimension() {
    final next = state.dimensionMode == MapDimensionMode.twoD
        ? MapDimensionMode.threeD
        : MapDimensionMode.twoD;
    state = state.copyWith(dimensionMode: next);
    _controller.toggleDimensionMode(next);
  }
}
