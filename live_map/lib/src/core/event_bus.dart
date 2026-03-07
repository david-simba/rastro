import 'dart:async';

import 'package:live_map/src/core/live_map_event.dart';

class EventBus {
  final _controller = StreamController<LiveMapEvent>.broadcast();

  void emit(LiveMapEvent event) {
    if (_controller.isClosed) return;
    _controller.add(event);
  }

  StreamSubscription<T> on<T extends LiveMapEvent>(
    void Function(T event) handler,
  ) {
    return _controller.stream
        .where((event) => event is T)
        .cast<T>()
        .listen(handler);
  }

  Stream<LiveMapEvent> get stream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
