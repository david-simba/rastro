import 'package:live_map/src/core/live_map_store.dart';

class CameraHandler {
  static void register(LiveMapStore store) {
    // Expansion point for future camera logic:
    // - Follow-mode (auto-track a model)
    // - Bounds clamping
    // - Animated transitions between modes
    //
    // CameraFlyTo / CameraMoveTo are forwarded to MapboxAdapter via the event bus.
  }
}
