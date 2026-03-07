import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/state/live_map_state.dart';
import 'package:live_map/src/core/live_map_store.dart';

class ModelHandler {
  static void register(LiveMapStore store) {
    store.addMiddleware((event, dispatch, getState) {
      if (event is MapStyleLoaded) {
        _onStyleLoaded(dispatch, getState);
      }
    });
  }

  static void _onStyleLoaded(
    void Function(LiveMapEvent) dispatch,
    LiveMapState Function() getState,
  ) {
    final state = getState();
    if (state.modelConfig != null &&
        state.models.layerStatus == ModelLayerStatus.none) {
      dispatch(const ModelLayerRequested());
    }
  }
}
