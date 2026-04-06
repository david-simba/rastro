import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/features/map/presentation/providers/map_state.dart';

mixin MapTrackingMixin on Notifier<MapState> {
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
}
