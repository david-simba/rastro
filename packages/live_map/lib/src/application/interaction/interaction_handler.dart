import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/state/live_map_state.dart';
import 'package:live_map/src/core/live_map_store.dart';
import 'package:live_map/src/application/use_cases/select_model_on_tap.dart';

class InteractionHandler {
  static const _useCase = SelectModelOnTap();

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
    final found = _useCase.execute(
      state.models.models,
      latitude: event.latitude,
      longitude: event.longitude,
    );

    if (found != null) {
      dispatch(ModelSelected(model: found));
    } else if (state.models.selectedModel != null) {
      dispatch(const ModelDeselected());
    }
  }
}
