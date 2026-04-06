import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rastro/features/stops/domain/entities/stop_entity.dart';

sealed class MapSelectedItem {
  const MapSelectedItem();
}

class MapSelectedStop extends MapSelectedItem {
  final StopEntity stop;
  const MapSelectedStop(this.stop);
}

class MapSelectedRoute extends MapSelectedItem {
  const MapSelectedRoute();
}

class MapSelectedLocation extends MapSelectedItem {
  const MapSelectedLocation();
}

final selectedItemProvider =
    NotifierProvider<SelectedItemNotifier, MapSelectedItem?>(
  SelectedItemNotifier.new,
);

class SelectedItemNotifier extends Notifier<MapSelectedItem?> {
  bool _silent = false;
  bool get isSilent => _silent;

  @override
  MapSelectedItem? build() => null;

  void select(MapSelectedItem item) {
    _silent = false;
    state = item;
  }

  /// Sets the item for display only — skips map actions and sheet snap.
  void selectSilent(MapSelectedItem item) {
    _silent = true;
    state = item;
  }

  void clear() {
    _silent = false;
    state = null;
  }
}
