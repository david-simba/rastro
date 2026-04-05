import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';
import 'package:polyline_codec/polyline_codec.dart';

import 'package:rastro/features/map/presentation/providers/map_state.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';
import 'package:rastro/features/stops/data/datasources/stops_firebase_datasource.dart';

mixin MapRouteMixin on Notifier<MapState> {
  LiveMapController get controller;
  StopsFirebaseDatasource get stopsDatasource;

  Future<void> selectRoute(RouteEntity route) async {
    if (state.selectedRoute != null && controller.isReady) {
      controller.clearRoute(state.selectedRoute!.id);
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
    if (controller.isReady) {
      controller.assignRoute(route.id, points);
      controller.fitRoute(points, bottomPadding: 430);
    }

    if (route.stops.isNotEmpty && controller.isReady) {
      final stops = await stopsDatasource.getStopsByIds(route.stops);
      final stopPoints = stops
          .map((s) => LatLng(lat: s.latitude, lng: s.longitude))
          .toList();
      final data = await rootBundle.load('assets/images/stop_pin.png');
      controller.drawStopPins(
        route.id,
        stopPoints,
        pinIcon: data.buffer.asUint8List(),
      );
    }
  }

  void clearSelection() {
    if (state.selectedRoute != null && controller.isReady) {
      controller.clearRoute(state.selectedRoute!.id);
      controller.clearStopPins(state.selectedRoute!.id);
    }
    state = state.copyWith(
      mode: MapMode.idle,
      selectedRoute: () => null,
    );
    final pos = state.userPosition;
    if (pos != null && controller.isReady) {
      controller.flyTo(latitude: pos.lat, longitude: pos.lng, zoom: 15);
    }
  }

  void flyToStop(double lat, double lng) {
    if (controller.isReady) {
      controller.flyTo(latitude: lat, longitude: lng, zoom: 17);
    }
  }

  void fitSelectedRoute() {
    final route = state.selectedRoute;
    if (route == null) return;
    final coords = PolylineCodec.decode(route.geometry, precision: 6);
    if (coords.isEmpty) return;
    final points = coords
        .map((c) => LatLng(lat: c[0].toDouble(), lng: c[1].toDouble()))
        .toList();
    if (controller.isReady) {
      controller.fitRoute(points, bottomPadding: 430);
    }
  }
}
