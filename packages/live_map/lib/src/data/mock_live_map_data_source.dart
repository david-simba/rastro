import 'live_map_data_source.dart';

class MockLiveMapDataSource implements LiveMapDataSource {
  @override
  MapPosition get cameraPosition => const MapPosition(
    latitude: -0.1994,
    longitude: -78.4925,
  );

  @override
  MapPosition get modelPosition => const MapPosition(
    latitude: -0.19954,
    longitude: -78.4925,
  );

  @override
  List<MapModel> get models => const [
    MapModel(id: 'bus_24', latitude: -0.19954, longitude: -78.4925),
  ];

  @override
  double get zoom => 19;
}
