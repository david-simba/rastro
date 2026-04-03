import 'package:polyline_codec/polyline_codec.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';
import 'package:rastro/features/map/presentation/providers/map_state.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';

final mapNotifierProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
);

class MapNotifier extends Notifier<MapState> {
  late final LiveMapController _controller;

  @override
  MapState build() {
    _controller = LiveMapController();
    return MapState.initial();
  }

  LiveMapController get controller => _controller;

  LiveMapConfig get mapConfig => const LiveMapConfig(
    initialLatitude: -0.2295,
    initialLongitude: -78.5243,
    dimensionMode: MapDimensionMode.twoD,
  );

  Future<void> loadRoute(RouteEntity route) async {
    final coords = PolylineCodec.decode(route.geometry, precision: 6);
    if (coords.isEmpty) return;

    final points = coords.map((c) => LatLng(lat: c[0].toDouble(), lng: c[1].toDouble())).toList();
    await Future.delayed(const Duration(milliseconds: 300));

    if (_controller.isReady) {
      _controller.assignRoute(route.id, points);
      _controller.flyTo(latitude: points.first.lat, longitude: points.first.lng, zoom: 15);
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