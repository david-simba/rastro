import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/features/map/data/datasources/simulation_datasource.dart';
import 'package:rastro/features/map/data/mappers/position_mapper.dart';
import 'package:rastro/features/map/data/repositories/map_repository_impl.dart';
import 'package:rastro/features/map/domain/entities/vehicle_position.dart';
import 'package:rastro/features/map/domain/repositories/i_map_repository.dart';
import 'package:rastro/features/map/presentation/providers/map_state.dart';

// ---------------------------------------------------------------------------
// Providers — composition root for the map feature
// ---------------------------------------------------------------------------

final mapRepositoryProvider = Provider<IMapRepository>((ref) {
  final datasource = SimulationDatasource();
  ref.onDispose(datasource.dispose);
  return MapRepositoryImpl(datasource);
});

final mapNotifierProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
);

// ---------------------------------------------------------------------------
// ViewModel
// ---------------------------------------------------------------------------

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
    final waypoints = _repository.waypoints;

    return LiveMapConfig(
      dimensionMode: state.dimensionMode,
      modelConfig: const ModelConfig(
        modelPath: 'assets/models/bus.glb',
        scale: [2.5, 2.5, 2.5],
        rotation: [0, 0, 0],
      ),
      initialLatitude: initial.latitude,
      initialLongitude: initial.longitude,
      initialZoom: 19,
      initialModels: [PositionMapper.toMapModel(initial)],
      waypoints: waypoints.map(PositionMapper.toMapModel).toList(),
    );
  }

  void startTracking() {
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
