# live_map

Flutter package that renders a live map with real-time vehicle tracking, 3D bus models, route lines, and stop pins. Built on top of Mapbox.

## What it does

- Renders a Mapbox map with a 3D GLB model (e.g. a bus) per vehicle.
- Animates vehicles smoothly as position updates arrive in real time.
- Draws route polylines and stop pins on the map.
- Supports 2D and 3D (pitched) camera modes.
- Detects taps on vehicles and notifies the app.

## How to use it

```dart
// 1. Set the Mapbox token once at startup
LiveMapWidget.setAccessToken('pk.your_token');

// 2. Create a controller to interact with the map
final controller = LiveMapController();

// 3. Mount the widget
LiveMapWidget(
  config: LiveMapConfig(
    initialLatitude: 19.43,
    initialLongitude: -99.13,
    dimensionMode: MapDimensionMode.twoD,
    modelConfig: ModelConfig(
      modelPath: 'assets/models/bus.glb',
      scale: [2.5, 2.5, 2.5],
      rotation: [0, 0, 90],
    ),
  ),
  controller: controller,
  onModelTap: (model) => print('Tapped ${model.id}'),
);

// 4. Push real-time vehicle positions
controller.dispatch(TrackingPositionReceived(
  modelId: 'bus-01',
  latitude: 19.43,
  longitude: -99.13,
  bearing: 90.0,
));

// 5. Draw a route and fit the camera to it
controller.assignRoute('bus-01', routePoints);
controller.fitRoute(routePoints);
```

## Importing

```dart
import 'package:live_map/live_map.dart';
```
