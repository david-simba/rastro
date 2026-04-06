import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/features/map/data/services/user_location_service.dart';
import 'package:rastro/features/map/presentation/providers/map_state.dart';

mixin MapControlsMixin on Notifier<MapState> {
  LiveMapController get controller;
  UserLocationService get locationService;

  Future<void> centerOnUser() async {
    final position = await locationService.getCurrentPosition();
    if (position == null) return;
    if (controller.isReady) {
      controller.flyTo(
        latitude: position.latitude,
        longitude: position.longitude,
        zoom: 15,
      );
    }
  }

  void toggleDimension() {
    final next = state.dimensionMode == MapDimensionMode.twoD
        ? MapDimensionMode.threeD
        : MapDimensionMode.twoD;
    state = state.copyWith(dimensionMode: next);
    controller.toggleDimensionMode(next);
  }
}
