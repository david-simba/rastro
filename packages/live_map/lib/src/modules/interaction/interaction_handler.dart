import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/state/live_map_state.dart';
import 'package:live_map/src/core/live_map_store.dart';

class InteractionHandler {
  static const _threshold = 0.00015;

  static void register(LiveMapStore store) {
    store.addMiddleware((event, dispatch, getState) {
      if (event is MapTapped) {
        _handleTap(event, dispatch, getState);
      }
    });
  }

  static void _handleTap(
    MapTapped event,
    void Function(LiveMapEvent) dispatch,
    LiveMapState Function() getState,
  ) {
    final state = getState();
    for (final model in state.models.models) {
      if (_isNear(event.latitude, event.longitude, model.latitude, model.longitude)) {
        dispatch(ModelSelected(model: model));
        return;
      }
    }
    if (state.models.selectedModel != null) {
      dispatch(const ModelDeselected());
    }
  }

  static bool _isNear(double lat1, double lng1, double lat2, double lng2) {
    return (lat1 - lat2).abs() < _threshold &&
        (lng1 - lng2).abs() < _threshold;
  }
}
