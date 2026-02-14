import 'live_map_data_source.dart';

class MockLiveMapDataSource implements LiveMapDataSource {
  @override
  MapPosition get cameraPosition => const MapPosition(
    latitude: -0.1994,
    longitude: -78.4925,
  );

  @override
  List<MapModel> get models => const [
    MapModel(id: 'Mocked-Bus-1', latitude: -0.19954, longitude: -78.4925),
    MapModel(id: 'Mocked-Bus-2', latitude: -0.19940, longitude: -78.4930),
  ];

  @override
  double get zoom => 19;
}
