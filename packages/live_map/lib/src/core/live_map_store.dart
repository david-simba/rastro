import 'dart:async';

import 'package:live_map/src/core/event_bus.dart';
import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/live_map_reducer.dart';
import 'package:live_map/src/core/state/live_map_state.dart';

typedef StoreMiddleware = void Function(
  LiveMapEvent event,
  void Function(LiveMapEvent) dispatch,
  LiveMapState Function() getState,
);

class LiveMapStore {
  LiveMapState _state;
  final EventBus eventBus;
  final _stateController = StreamController<LiveMapState>.broadcast();
  final List<StoreMiddleware> _middlewares = [];
  final List<LiveMapEvent> _eventHistory = [];
  static const int _maxHistorySize = 20;

  LiveMapStore(this._state) : eventBus = EventBus();

  List<LiveMapEvent> get eventHistory => List.unmodifiable(_eventHistory);

  LiveMapState get state => _state;

  Stream<LiveMapState> get stateStream => _stateController.stream;

  Stream<T> select<T>(T Function(LiveMapState) selector) {
    return stateStream.map(selector).distinct();
  }

  void addMiddleware(StoreMiddleware middleware) {
    _middlewares.add(middleware);
  }

  bool get isClosed => _stateController.isClosed;

  void dispatch(LiveMapEvent event) {
    if (_stateController.isClosed) return;

    _eventHistory.insert(0, event);
    if (_eventHistory.length > _maxHistorySize) {
      _eventHistory.removeLast();
    }

    final previous = _state;
    _state = liveMapReducer(_state, event);

    if (_state != previous) {
      _stateController.add(_state);
    }

    eventBus.emit(event);

    for (final middleware in _middlewares) {
      middleware(event, dispatch, () => _state);
    }
  }

  void dispose() {
    eventBus.dispose();
    _stateController.close();
  }
}
