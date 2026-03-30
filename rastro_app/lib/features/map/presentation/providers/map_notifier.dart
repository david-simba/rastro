import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/core/providers/core_providers.dart';
import 'package:rastro/features/map/data/datasources/simulation_datasource.dart';
import 'package:rastro/features/map/data/mappers/position_mapper.dart';
import 'package:rastro/features/map/data/repositories/map_repository_impl.dart';
import 'package:rastro/features/map/domain/entities/vehicle_position.dart';
import 'package:rastro/features/map/domain/repositories/i_map_repository.dart';
import 'package:rastro/features/map/presentation/providers/map_state.dart';

final mapRepositoryProvider = Provider<IMapRepository>((ref) {
  final datasource = SimulationDatasource();
  ref.onDispose(datasource.dispose);
  return MapRepositoryImpl(datasource);
});

final mapNotifierProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
);

class MapNotifier extends Notifier<MapState> {
  late final LiveMapController _controller;
  late final IMapRepository _repository;
  StreamSubscription<VehiclePosition>? _positionSub;

  @override
  MapState build() {
    _controller = LiveMapController();
    _repository = ref.read(mapRepositoryProvider);

    ref.onDispose(() {
      _positionSub?.cancel();
      _repository.stopTracking();
    });

    return MapState.initial();
  }

  LiveMapController get controller => _controller;

  LiveMapConfig get mapConfig {
    final initial = _repository.initialPosition;

    return LiveMapConfig(
      initialZoom: 20,
      initialLatitude: initial.latitude,
      initialLongitude: initial.longitude,
      dimensionMode: state.dimensionMode,
      initialModels: [PositionMapper.toMapModel(initial)],
      modelConfig: const ModelConfig(
        modelPath: 'assets/models/optimized-bus.glb',
        scale: [1, 1, 1],
        rotation: [0, 0, 0],
        zoomScale: ZoomScaleConfig(
          minZoom: 10.0,
          maxZoom: 20.0,
          minScaleMultiplier: 1,
          maxScaleMultiplier: 30.0,
        ),
      ),
    );
  }

  Future<void> startTracking() async {
    // Fetch the road-snapped route from Mapbox Directions API and draw it on
    // the map before starting position updates.
    try {
      final token = ref.read(appConfigProvider).mapboxToken;
      final waypoints = SimulationDatasource.routeWaypoints
          .map((p) => LatLng(lat: p.latitude, lng: p.longitude))
          .toList();

      final routePoints = await DirectionsService.fetchRoute(
        waypoints: waypoints,
        accessToken: token,
      );

      _controller.assignRoute(SimulationDatasource.vehicleId, routePoints);

      // Make the bus follow the same road geometry drawn on the map.
      _repository.setRoute(
        routePoints
            .map((p) => VehiclePosition(
                  id: SimulationDatasource.vehicleId,
                  latitude: p.lat,
                  longitude: p.lng,
                ))
            .toList(),
      );
    } catch (e) {
      debugPrint('MapNotifier: failed to fetch route — $e');
    }

    _repository.startTracking();
    _positionSub = _repository.watchPositions().listen((position) {
      _controller.dispatch(TrackingPositionReceived(
        modelId: position.id,
        latitude: position.latitude,
        longitude: position.longitude,
        bearing: position.bearing,
      ));
      _controller.dispatch(CameraMoveTo(
        latitude: position.latitude,
        longitude: position.longitude,
        bearing: position.bearing,
      ));
    });
  }

  void stopTracking() {
    _positionSub?.cancel();
    _positionSub = null;
    _repository.stopTracking();
  }

  void toggleDimension() {
    final next = state.dimensionMode == MapDimensionMode.twoD
        ? MapDimensionMode.threeD
        : MapDimensionMode.twoD;
    state = state.copyWith(dimensionMode: next);
    _controller.toggleDimensionMode(next);
  }
}
