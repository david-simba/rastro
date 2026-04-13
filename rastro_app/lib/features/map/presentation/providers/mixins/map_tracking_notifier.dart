import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/features/map/presentation/providers/map_state.dart';

mixin MapTrackingMixin on Notifier<MapState> {
  LiveMapController get controller;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _vehicleSub;
  bool _modelRegistered = false;

  void startTracking(MapModel model) {
    _modelRegistered = false;
    if (state.selectedRoute != null && controller.isReady) {
      controller.clearRoute(state.selectedRoute!.id);
      controller.clearStopPins(state.selectedRoute!.id);
    }
    state = state.copyWith(
      mode: MapMode.trackingBus,
      trackedModel: () => model,
      selectedRoute: () => null,
    );
    _subscribeToVehiclePosition(model);
    ref.onDispose(() => _vehicleSub?.cancel());
  }

  void _subscribeToVehiclePosition(MapModel model) {
    _vehicleSub?.cancel();
    _vehicleSub = FirebaseFirestore.instance
        .collection('vehicles')
        .doc(model.id)
        .snapshots()
        .listen((doc) {
      final data = doc.data();
      if (data == null) return;
      final location = data['location'] as Map<String, dynamic>?;
      if (location == null) return;
      final lat = (location['lat'] as num).toDouble();
      final lng = (location['lng'] as num).toDouble();
      _dispatchPosition(model.id, lat, lng);
    });
  }

  bool get _modelLayerReady =>
      controller.isReady &&
      controller.state.models.layerStatus == ModelLayerStatus.loaded;

  void _dispatchPosition(String vehicleId, double lat, double lng) {
    if (!_modelLayerReady) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (state.trackedModel != null) {
          _dispatchPosition(vehicleId, lat, lng);
        }
      });
      return;
    }

    if (!_modelRegistered) {
      _modelRegistered = true;
      controller.dispatch(ModelsUpdated(models: [
        MapModel(id: vehicleId, latitude: lat, longitude: lng),
      ]));
    }

    controller.dispatch(TrackingPositionReceived(
      modelId: vehicleId,
      latitude: lat,
      longitude: lng,
    ));
    controller.flyTo(latitude: lat, longitude: lng, zoom: 16);
  }

  void stopTracking() {
    _vehicleSub?.cancel();
    _vehicleSub = null;
    _modelRegistered = false;
    state = state.copyWith(
      mode: MapMode.idle,
      trackedModel: () => null,
    );
  }
}
