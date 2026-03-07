import 'dart:async';

import 'package:live_map/src/core/live_map_event.dart';
import 'package:live_map/src/core/live_map_store.dart';

class SocketAdapter {
  final LiveMapStore _store;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  SocketAdapter(this._store) {
    _subscriptions.add(
      _store.eventBus.on<TrackingStarted>(_onTrackingStarted),
    );
    _subscriptions.add(
      _store.eventBus.on<TrackingStopped>(_onTrackingStopped),
    );
  }

  void _onTrackingStarted(TrackingStarted event) {}

  void _onTrackingStopped(TrackingStopped event) {}

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
