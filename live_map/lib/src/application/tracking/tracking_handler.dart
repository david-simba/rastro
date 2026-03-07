import 'package:live_map/src/core/live_map_store.dart';

class TrackingHandler {
  static void register(LiveMapStore store) {
    // Expansion point for real-time tracking business logic:
    // - Position interpolation / smoothing
    // - Stale-data filtering
    // - Auto-follow camera when tracking is active
    //
    // TrackingPositionReceived updates model positions via the reducer.
    // TrackingStarted / TrackingStopped are forwarded to SocketAdapter via the event bus.
  }
}
