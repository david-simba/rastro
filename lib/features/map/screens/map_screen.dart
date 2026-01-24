import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:rastro/features/map/provider/map_controller_provider.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({ super.key });

  static final Position mapInitialPosition = Position(-78.4925, -0.1994);
  static final Position busInitialPosition = Position(-78.4925, -0.19954);
  static const double initialZoom = 19;
  static const double initialPitch = 65;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapWidget(
      key: ValueKey('map'),
      cameraOptions: CameraOptions(
        center: Point(coordinates: mapInitialPosition),
        zoom: initialZoom,
        pitch: initialPitch,
      ),
      onMapCreated: (controller) {
        ref.read(mapControllerProvider.notifier).setController(controller);
      },
      onStyleLoadedListener: (StyleLoadedEventData data) {
        ref.read(mapControllerProvider.notifier).loadBusModel(
          position: busInitialPosition,
        );
      },
    );
  }
}
