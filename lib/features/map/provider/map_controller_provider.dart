import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:rastro/features/map/provider/bus_model_provider.dart';
import 'package:rastro/features/map/services/bus_map_layer_service.dart';

class MapControllerNotifier extends Notifier<MapboxMap?> {
  @override
  MapboxMap? build() => null;

  void setController(MapboxMap controller) {
    state = controller;
  }

  Future<void> loadBusModel({
    required Position position,
  }) async {
    final controller = state;
    if (controller == null) return;

    final modelPath = await ref.read(busModelPathProvider.future);
    final mapboxService = Bus3DMapLayerService(controller);

    await mapboxService.add3DBusLayer(
      modelId: 'bus-model',
      modelUrl: modelPath,
      position: position,
    );
  }
}

final mapControllerProvider = NotifierProvider<MapControllerNotifier, MapboxMap?>(
  MapControllerNotifier.new,
);
